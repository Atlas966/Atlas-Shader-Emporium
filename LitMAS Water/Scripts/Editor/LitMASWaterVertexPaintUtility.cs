// Assets/AtlasUtils/Editor/AtlasVertexPainterWindow.cs
// Unity 2021.3+ — Pure Vertex Color Painter (RGBA).
// • Modes: Paint & Smooth (Erase = hold CTRL while painting)
// • Directly edits mesh vertex colors (sharedMesh); NO save button, NO textures
// • Undo (Ctrl+Z) supported
// • Auto-prepare: adds a TEMP MeshCollider if missing, fixes bad colliders
// • Cleans up TEMP collider when you deselect or close the window
// • SceneView-safe (no GUI spam / no blanking)

#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace AtlasUtils
{
    public class AtlasVertexPainterWindow : EditorWindow
    {
        private enum PaintMode { Paint, Smooth }
        private enum Channel { R, G, B, A }

        // Brush settings
        [SerializeField] private float brushSize = 1.5f;   // world units (radius)
        [SerializeField] private float strength = 0.5f;   // 0..1 per dab
        [SerializeField] private float hardness = 0.75f;  // 0 (soft) .. 1 (hard)
        [SerializeField] private PaintMode mode = PaintMode.Paint;
        [SerializeField] private Channel channel = Channel.R;

        // Hotkeys
        private const float SizeStep = 0.25f;
        private const float StrengthStep = 0.05f;

        // Scene/selection state
        private bool sceneHooked;
        private int controlId;
        private GameObject currentGO;
        private MeshFilter currentMF;
        private MeshRenderer currentMR;
        private MeshCollider currentMC;
        private bool tempColliderAdded;

        private Vector3 hitPoint, hitNormal;
        private static readonly Color kRing = new Color(1f, 1f, 1f, 0.9f);

        [MenuItem("AtlasUtils/Vertex Painter")]
        public static void Open()
        {
            var win = GetWindow<AtlasVertexPainterWindow>("Vertex Painter");
            win.minSize = new Vector2(320, 320);
        }

        // ---------- Lifecycle ----------
        private void OnEnable()
        {
            if (!sceneHooked)
            {
                SceneView.duringSceneGui += DuringSceneGUI;
                sceneHooked = true;
            }
            PrepareForSelection(Selection.activeGameObject);
        }

        private void OnDisable()
        {
            CleanupTempCollider();
            if (sceneHooked)
            {
                SceneView.duringSceneGui -= DuringSceneGUI;
                sceneHooked = false;
            }
        }

        private void OnSelectionChange()
        {
            PrepareForSelection(Selection.activeGameObject);
            Repaint();
        }

        // ---------- UI ----------
        private void OnGUI()
        {
            EditorGUILayout.LabelField("Target", EditorStyles.boldLabel);
            EditorGUILayout.ObjectField("Selected Object", currentGO, typeof(GameObject), true);

            if (currentMF == null || currentMR == null || currentMF.sharedMesh == null)
                EditorGUILayout.HelpBox("Select a GameObject with a MeshFilter + MeshRenderer.", MessageType.Info);

            EditorGUILayout.Space(6);
            EditorGUILayout.LabelField("Brush", EditorStyles.boldLabel);
            mode = (PaintMode)EditorGUILayout.EnumPopup("Mode", mode);
            channel = (Channel)EditorGUILayout.EnumPopup("Channel", channel);
            brushSize = EditorGUILayout.Slider("Size (world units)", brushSize, 0.05f, 64f);
            strength = EditorGUILayout.Slider("Strength", strength, 0.01f, 1f);
            hardness = EditorGUILayout.Slider("Hardness", hardness, 0f, 1f);

            EditorGUILayout.Space(8);
            using (new EditorGUILayout.VerticalScope("helpbox"))
            {
                GUILayout.Label("Instructions", EditorStyles.boldLabel);
                GUILayout.Label("LMB = Paint");
                GUILayout.Label("CTRL + LMB = Erase (while in Paint)");
                GUILayout.Label("SHIFT + LMB = Smooth");
                GUILayout.Label("[ / ] = Size    ; / ' = Strength");
            }
        }

        // ---------- Scene View ----------
        private void DuringSceneGUI(SceneView sv)
        {
            Event e = Event.current;
            controlId = GUIUtility.GetControlID(FocusType.Passive);

            // Claim default control ONLY during Layout (prevents GUI recursion)
            if (e.type == EventType.Layout)
            {
                HandleUtility.AddDefaultControl(controlId);
                return;
            }

            // Ignore navigation
            if (e.alt || Tools.current == Tool.View) return;

            // Auto-prepare selection continuously (robust against external changes)
            if (currentGO != Selection.activeGameObject)
                PrepareForSelection(Selection.activeGameObject);

            if (currentMF == null || currentMF.sharedMesh == null || currentMC == null) return;

            // Hotkeys
            if (e.type == EventType.KeyDown)
            {
                if (e.keyCode == KeyCode.LeftBracket) { brushSize = Mathf.Max(0.05f, brushSize - SizeStep); e.Use(); }
                if (e.keyCode == KeyCode.RightBracket) { brushSize += SizeStep; e.Use(); }
                if (e.keyCode == KeyCode.Semicolon) { strength = Mathf.Max(0.01f, strength - StrengthStep); e.Use(); }
                if (e.keyCode == KeyCode.Quote) { strength = Mathf.Min(1f, strength + StrengthStep); e.Use(); }
            }

            // Raycast against the selected object's collider only
            Ray ray = HandleUtility.GUIPointToWorldRay(e.mousePosition);
            bool hit = currentMC.Raycast(ray, out RaycastHit rh, float.MaxValue);

            // Draw brush ring during Repaint only
            if (e.type == EventType.Repaint)
            {
                if (hit)
                {
                    hitPoint = rh.point;
                    hitNormal = rh.normal;
                    DrawBrushRing(hitPoint, hitNormal);
                }
                else
                {
                    // Subtle view-plane ring to gauge size
                    Plane p = new Plane(sv.camera.transform.forward, sv.camera.transform.position + sv.camera.transform.forward * 5f);
                    if (p.Raycast(ray, out float t))
                    {
                        Vector3 pos = ray.GetPoint(t);
                        DrawBrushRing(pos, p.normal);
                    }
                }
            }

            // Input
            if (hit && (e.type == EventType.MouseDown || e.type == EventType.MouseDrag) && e.button == 0)
            {
#if UNITY_EDITOR_OSX
                bool ctrlHeld = e.command;
#else
                bool ctrlHeld = e.control;
#endif
                if (mode == PaintMode.Paint)
                    DoPaint(currentMF.sharedMesh, currentMF.transform, rh, erase: ctrlHeld);
                else
                    DoSmooth(currentMF.sharedMesh, currentMF.transform, rh);

                e.Use();
            }
        }

        private void DrawBrushRing(Vector3 pos, Vector3 normal)
        {
            Handles.zTest = UnityEngine.Rendering.CompareFunction.LessEqual;
            Handles.color = kRing;
            Handles.DrawWireDisc(pos, normal, brushSize);
            float inner = Mathf.Lerp(0.01f, brushSize, hardness);
            Handles.DrawWireDisc(pos, normal, inner);
            Handles.zTest = UnityEngine.Rendering.CompareFunction.Always;
        }

        // ---------- Painting ----------
        private void DoPaint(Mesh mesh, Transform tr, RaycastHit rh, bool erase)
        {
            EnsureColorArray(mesh);

            // Proper Undo for mesh changes
            Undo.RecordObject(mesh, erase ? "Vertex Erase" : "Vertex Paint");

            var verts = mesh.vertices;
            var cols = mesh.colors32;
            int n = verts.Length;

            Matrix4x4 l2w = tr.localToWorldMatrix;
            float radius = Mathf.Max(0.0001f, brushSize);
            float hard = Mathf.Clamp01(hardness);
            float str = Mathf.Clamp01(strength);

            for (int i = 0; i < n; i++)
            {
                Vector3 wp = l2w.MultiplyPoint3x4(verts[i]);
                float dist = Vector3.Distance(wp, rh.point);
                if (dist > radius) continue;

                float t = Mathf.Clamp01(1f - dist / radius);           // edge..center
                float falloff = Mathf.Pow(t, Mathf.Lerp(1f, 4f, hard)); // hardness curve
                float lerp = falloff * str;

                Color c = cols[i];
                float target = erase ? 0f : 1f;

                switch (channel)
                {
                    case Channel.R: c.r = Mathf.Lerp(c.r, target, lerp); break;
                    case Channel.G: c.g = Mathf.Lerp(c.g, target, lerp); break;
                    case Channel.B: c.b = Mathf.Lerp(c.b, target, lerp); break;
                    case Channel.A: c.a = Mathf.Lerp(c.a, target, lerp); break;
                }
                cols[i] = (Color32)c;
            }

            mesh.colors32 = cols;
            mesh.UploadMeshData(false);
            EditorUtility.SetDirty(mesh);
            SceneView.RepaintAll();
        }

        private void DoSmooth(Mesh mesh, Transform tr, RaycastHit rh)
        {
            EnsureColorArray(mesh);
            Undo.RecordObject(mesh, "Vertex Smooth");

            var verts = mesh.vertices;
            var cols = mesh.colors32;
            int n = verts.Length;

            Matrix4x4 l2w = tr.localToWorldMatrix;
            float radius = Mathf.Max(0.0001f, brushSize);
            float innerRadius = radius * 0.5f;
            float hard = Mathf.Clamp01(hardness);
            float str = Mathf.Clamp01(strength);

            // Precompute world positions
            Vector3[] wp = new Vector3[n];
            for (int i = 0; i < n; i++)
                wp[i] = l2w.MultiplyPoint3x4(verts[i]);

            for (int i = 0; i < n; i++)
            {
                float dist = Vector3.Distance(wp[i], rh.point);
                if (dist > radius) continue;

                // Average neighbors in inner radius
                Color accum = Color.black;
                int count = 0;
                for (int j = 0; j < n; j++)
                {
                    float d2 = (wp[j] - wp[i]).sqrMagnitude;
                    if (d2 <= innerRadius * innerRadius)
                    {
                        accum += (Color)cols[j];
                        count++;
                    }
                }
                if (count == 0) continue;

                Color avg = accum / count;
                Color cur = cols[i];

                float t = Mathf.Clamp01(1f - dist / radius);
                float fall = Mathf.Pow(t, Mathf.Lerp(1f, 4f, hard));
                float lerp = fall * str;

                // Smooth only the chosen channel
                switch (channel)
                {
                    case Channel.R: cur.r = Mathf.Lerp(cur.r, avg.r, lerp); break;
                    case Channel.G: cur.g = Mathf.Lerp(cur.g, avg.g, lerp); break;
                    case Channel.B: cur.b = Mathf.Lerp(cur.b, avg.b, lerp); break;
                    case Channel.A: cur.a = Mathf.Lerp(cur.a, avg.a, lerp); break;
                }
                cols[i] = (Color32)cur;
            }

            mesh.colors32 = cols;
            mesh.UploadMeshData(false);
            EditorUtility.SetDirty(mesh);
            SceneView.RepaintAll();
        }

        // ---------- Prep / Cleanup ----------
        private void PrepareForSelection(GameObject go)
        {
            // Clean up previous temp collider if selection changed
            if (go != currentGO)
                CleanupTempCollider();

            currentGO = go;
            currentMF = null;
            currentMR = null;
            currentMC = null;

            if (currentGO == null) return;

            currentMF = currentGO.GetComponent<MeshFilter>();
            currentMR = currentGO.GetComponent<MeshRenderer>();

            if (currentMF == null || currentMR == null || currentMF.sharedMesh == null)
                return;

            // Use existing MeshCollider if present
            currentMC = currentGO.GetComponent<MeshCollider>();
            tempColliderAdded = false;

            if (currentMC == null)
            {
                // Add TEMP collider (editor-only) and remember to remove later
                currentMC = currentGO.AddComponent<MeshCollider>();
                currentMC.hideFlags |= HideFlags.DontSave;
                tempColliderAdded = true;
            }

            // Fix collider if needed (safe per your OK): ensure non-convex and mesh assigned
            currentMC.convex = false;
            if (currentMC.sharedMesh == null)
                currentMC.sharedMesh = currentMF.sharedMesh;
        }

        private void CleanupTempCollider()
        {
            if (tempColliderAdded && currentMC != null && currentGO != null)
            {
                // Remove ONLY if we added it
                DestroyImmediate(currentMC);
            }
            tempColliderAdded = false;
            currentMC = null;
        }

        private static void EnsureColorArray(Mesh mesh)
        {
            if (mesh.colors32 == null || mesh.colors32.Length != mesh.vertexCount)
            {
                var init = new Color32[mesh.vertexCount];
                for (int i = 0; i < init.Length; i++) init[i] = new Color32(0, 0, 0, 0);
                mesh.colors32 = init;
            }
        }
    }
}
#endif
