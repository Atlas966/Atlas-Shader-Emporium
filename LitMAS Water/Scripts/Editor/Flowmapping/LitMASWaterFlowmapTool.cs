#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System.IO;

namespace AtlasUtils.LitMASWater
{
    public class FlowmapPainter : EditorWindow
    {
        [MenuItem("AtlasUtils/LitMAS Water/Flowmap Painter")]
        public static void ShowWindow()
        {
            GetWindow<FlowmapPainter>("Flow Painter").minSize = new Vector2(380, 520);
        }

        GameObject go;
        MeshRenderer mr;
        MeshFilter mf;
        MeshCollider mc;   // <-- FIXED: returned this

        Material originalMaterial;
        Texture2D flowmap;

        readonly int[] textureSizes = new int[] { 128, 256, 512, 1024, 2048 };
        int textureSizeIndex = 2;

        bool painting = false;

        Texture2D[] brushes;
        Texture2D[] scaledBrushes;
        int activeBrush = 0;

        float brushSize = 100f;
        float opacity = 1f;
        bool clampToUV = true;

        enum PreviewMode { LitMASWater, RawPreview }
        PreviewMode preview = PreviewMode.LitMASWater;

        Material unlitMat;
        const string LITMAS_SLOT = "_Flowmap";

        private void OnEnable()
        {
            SceneView.duringSceneGui += OnSceneGUI;
            Selection.selectionChanged += OnSelectionChanged;
            LoadBrushes();
            AutoAssign();
        }

        private void OnDisable()
        {
            SceneView.duringSceneGui -= OnSceneGUI;
            Selection.selectionChanged -= OnSelectionChanged;
            RestoreMaterial();
        }

        private void OnSelectionChanged()
        {
            AutoAssign();
            Repaint();
        }

        private void OnGUI()
        {
            GUILayout.Space(6);

            GUIStyle title = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontSize = 20
            };
            GUILayout.Label("LitMAS Water Flowmap Painter", title);
            GUILayout.Space(8);

            // -------------------------
            // FIXED COLLIDER WARNING
            // -------------------------
            if (!mr || !mf)
            {
                EditorGUILayout.HelpBox("Select water plane to begin. Plane must have Mesh Collider", MessageType.Info);
                return;
            }

            if (!mc)
            {
                EditorGUILayout.HelpBox("Selected object needs a MeshCollider to paint.", MessageType.Error);
                return;
            }

            // PREVIEW MODE
            string[] previewLabels = {
                "LitMAS Water",
                "Direct Preview (Show flowmap texture only)"
            };

            PreviewMode newPreview = (PreviewMode)EditorGUILayout.Popup(
                "Preview Mode",
                (int)preview,
                previewLabels
            );

            if (newPreview != preview)
            {
                preview = newPreview;
                ApplyPreview();
            }

            if (!painting)
                textureSizeIndex = EditorGUILayout.Popup("Flowmap Texture Size", textureSizeIndex,
                    new string[] { "128", "256", "512", "1024", "2048" });

            GUILayout.Space(6);

            if (painting)
            {
                EditorGUILayout.HelpBox(
                    "Drag mouse in the direction to guide water flow. Realtime preview does NOT show final flow direction.",
                    MessageType.Info
                );
            }

            GUI.backgroundColor = painting ? new Color(0.85f, 0.22f, 0.22f) : new Color(0.22f, 0.85f, 0.22f);
            if (GUILayout.Button(painting ? "Stop Painting" : "Start Painting", GUILayout.Height(36)))
            {
                painting = !painting;
                if (painting) StartPainting(); else StopPainting();
            }
            GUI.backgroundColor = Color.white;

            if (!painting) return;

            GUIStyle slowWarn = new GUIStyle(EditorStyles.label)
            {
                alignment = TextAnchor.MiddleCenter,
                fontStyle = FontStyle.Bold
            };
            slowWarn.normal.textColor = Color.yellow;
            GUILayout.Space(3);
            GUILayout.Label("⚠ Drag mouse SLOW to yield better results", slowWarn);
            GUILayout.Space(6);

            brushSize = EditorGUILayout.Slider("Brush Size", brushSize, 32f, 512f);
            opacity = EditorGUILayout.Slider("Opacity", opacity, 0.05f, 1f);
            clampToUV = EditorGUILayout.Toggle("Clamp To UV", clampToUV);

            GUILayout.Space(10);
            activeBrush = GUILayout.SelectionGrid(activeBrush, scaledBrushes, scaledBrushes.Length, GUILayout.Height(48));
            GUILayout.Space(10);

            GUI.backgroundColor = new Color(0.76f, 0.76f, 0.76f);
            if (GUILayout.Button("Reset", GUILayout.Height(28)))
                ClearFlowmap();
            GUI.backgroundColor = Color.white;

            GUILayout.Space(8);

            GUIStyle saveStyle = new GUIStyle(GUI.skin.button)
            {
                fontSize = 15,
                fontStyle = FontStyle.Bold,
                alignment = TextAnchor.MiddleCenter,
            };
            saveStyle.normal.textColor = Color.white;

            GUI.backgroundColor = new Color(0.15f, 0.75f, 0.25f);
            if (GUILayout.Button("Save To Texture", saveStyle, GUILayout.Height(48)))
                SaveFlowmap();
            GUI.backgroundColor = Color.white;

            GUILayout.Space(12);
            if (flowmap)
            {
                Rect r = GUILayoutUtility.GetRect(300, 300);
                GUI.DrawTexture(r, flowmap, ScaleMode.ScaleToFit);
            }
        }

        void StartPainting()
        {
            if (!flowmap)
                CreateFlowmap();
            ApplyPreview();
        }

        void StopPainting()
        {
            painting = false;
            RestoreMaterial();
        }

        void CreateFlowmap()
        {
            int size = textureSizes[textureSizeIndex];
            flowmap = new Texture2D(size, size, TextureFormat.RGBA32, false, true);
            flowmap.wrapMode = TextureWrapMode.Repeat;
            ClearFlowmap();
        }

        void Paint(Vector2 uv, Vector2 dir)
        {
            int radius = Mathf.RoundToInt(brushSize * 0.5f);
            Texture2D brush = scaledBrushes[activeBrush];
            Color[] pixels = flowmap.GetPixels();

            int cx = Mathf.RoundToInt(uv.x * flowmap.width);
            int cy = Mathf.RoundToInt(uv.y * flowmap.height);

            for (int y = -radius; y <= radius; y++)
            {
                for (int x = -radius; x <= radius; x++)
                {
                    int px = cx + x;
                    int py = cy + y;

                    if (clampToUV)
                    {
                        if (px < 0 || px >= flowmap.width || py < 0 || py >= flowmap.height)
                            continue;
                    }
                    else
                    {
                        px = (px + flowmap.width) % flowmap.width;
                        py = (py + flowmap.height) % flowmap.height;
                    }

                    int idx = py * flowmap.width + px;

                    Color mask = brush.GetPixelBilinear(
                        (float)(x + radius) / (radius * 2f),
                        (float)(y + radius) / (radius * 2f));

                    Color old = pixels[idx];

                    Color flow = new Color(
                        (-dir.x * 0.5f + 0.5f),
                        (-dir.y * 0.5f + 0.5f),
                        0f, 1f
                    );

                    pixels[idx] = Color.Lerp(old, flow, mask.a * opacity);
                }
            }

            flowmap.SetPixels(pixels);
            flowmap.Apply();
            ApplyPreview();
        }

        void OnSceneGUI(SceneView sv)
        {
            if (!painting || !flowmap || !mr || !mc) return;

            HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));

            Event e = Event.current;
            Ray ray = HandleUtility.GUIPointToWorldRay(e.mousePosition);
            if (!Physics.Raycast(ray, out RaycastHit hit)) return;
            if (hit.collider != mc) return;

            float worldRadius = (brushSize / flowmap.width) * mf.sharedMesh.bounds.extents.magnitude;

            Handles.color = Color.yellow;
            Handles.DrawWireDisc(hit.point, hit.normal, worldRadius);

            if (e.type == EventType.MouseDrag && e.button == 0 && !e.alt)
            {
                Vector2 dir = e.delta.normalized;
                dir.y = -dir.y;
                Paint(hit.textureCoord, dir);
                e.Use();
                sv.Repaint();
            }
        }

        void ApplyPreview()
        {
            if (!mr || !flowmap) return;

            if (preview == PreviewMode.RawPreview)
            {
                if (!unlitMat)
                    unlitMat = new Material(Shader.Find("Universal Render Pipeline/Unlit"));
                unlitMat.SetTexture("_BaseMap", flowmap);
                mr.sharedMaterial = unlitMat;
                return;
            }

            if (originalMaterial != null)
                mr.sharedMaterial = originalMaterial;

            if (mr.sharedMaterial.HasProperty(LITMAS_SLOT))
                mr.sharedMaterial.SetTexture(LITMAS_SLOT, flowmap);
        }

        void RestoreMaterial()
        {
            if (mr && originalMaterial)
                mr.sharedMaterial = originalMaterial;
        }

        void SaveFlowmap()
        {
            string file = EditorUtility.SaveFilePanelInProject("Save Flowmap", "Flowmap", "png", "");
            if (file.Length == 0) return;

            File.WriteAllBytes(file, flowmap.EncodeToPNG());
            AssetDatabase.Refresh();

            TextureImporter ti = AssetImporter.GetAtPath(file) as TextureImporter;
            ti.textureType = TextureImporterType.NormalMap;
            ti.SaveAndReimport();

            mr.sharedMaterial.SetTexture(LITMAS_SLOT, AssetDatabase.LoadAssetAtPath<Texture2D>(file));
        }

        void ClearFlowmap()
        {
            Color[] fill = new Color[flowmap.width * flowmap.height];
            for (int i = 0; i < fill.Length; i++)
                fill[i] = new Color(0.5f, 0.5f, 0.0f, 1f);

            flowmap.SetPixels(fill);
            flowmap.Apply();
            ApplyPreview();
        }

        void AutoAssign()
        {
            go = Selection.activeGameObject;
            if (!go) return;

            mr = go.GetComponent<MeshRenderer>();
            mf = go.GetComponent<MeshFilter>();
            mc = go.GetComponent<MeshCollider>();   // <-- FIXED: collider needed

            if (!mr || !mf) return;

            if (originalMaterial == null)
                originalMaterial = mr.sharedMaterial;
        }

        void LoadBrushes()
        {
            string path = "Assets/LitMAS Water/Scripts/Editor/Flowmapping/Brushes/";

            brushes = new Texture2D[4];
            scaledBrushes = new Texture2D[4];

            for (int i = 0; i < 4; i++)
            {
                brushes[i] = AssetDatabase.LoadAssetAtPath<Texture2D>($"{path}LWFP_BrushFalloff_{i + 1}.png");
                scaledBrushes[i] = Instantiate(brushes[i]);
            }
        }
    }
}
#endif
