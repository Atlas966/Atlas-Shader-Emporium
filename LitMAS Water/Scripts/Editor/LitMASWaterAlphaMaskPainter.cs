#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System.IO;

namespace AtlasUtils.LitMASWater
{
    public class AlphaMaskPainter : EditorWindow
    {
        [MenuItem("AtlasUtils/LitMAS Water/Alpha Mask Painter")]
        public static void ShowWindow()
        {
            GetWindow<AlphaMaskPainter>("Alpha Mask Painter").minSize = new Vector2(380, 520);
        }

        GameObject go;
        MeshRenderer mr;
        MeshFilter mf;

        Material originalMaterial;
        Texture2D alphaMask;

        readonly int[] textureSizes = new int[] { 128, 256, 512, 1024, 2048 };
        int textureSizeIndex = 2;      // 512 default

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
        const string MASK_SLOT = "_AlphaMask";

        // ─────────────────────────────────────────────
        // LIFECYCLE
        // ─────────────────────────────────────────────
        void OnEnable()
        {
            SceneView.duringSceneGui += OnSceneGUI;
            Selection.selectionChanged += OnSelectionChanged;
            LoadBrushes();
            AutoAssign();
        }

        void OnDisable()
        {
            SceneView.duringSceneGui -= OnSceneGUI;
            Selection.selectionChanged -= OnSelectionChanged;
            RestoreMaterial();
        }

        void OnSelectionChanged()
        {
            AutoAssign();
            Repaint();
        }

        // ─────────────────────────────────────────────
        // GUI
        // ─────────────────────────────────────────────
        void OnGUI()
        {
            GUILayout.Space(6);

            GUIStyle title = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontSize = 20
            };
            GUILayout.Label("LitMAS Water Alpha Mask Painter", title);
            GUILayout.Space(8);

            if (!mr)
            {
                EditorGUILayout.HelpBox(
                    "Select water plane to begin. Plane must have Mesh Collider",
                    MessageType.Info
                );
                return;
            }

            // Preview Mode popup with custom labels
            string[] previewLabels =
            {
                "LitMAS Water",
                "Direct Preview (Show mask texture only)"
            };

            PreviewMode newPreview = (PreviewMode)EditorGUILayout.Popup(
                "Preview Mode",
                (int)preview,
                previewLabels
            );

            if (newPreview != preview)
            {
                preview = newPreview;
                ApplyPreview(); // realtime switching
            }

            // Info box under preview mode
            EditorGUILayout.HelpBox(
                "Brush paints alpha to texture for alpha masking.",
                MessageType.Info
            );

            if (!painting)
            {
                textureSizeIndex = EditorGUILayout.Popup(
                    "Alpha Texture Size",
                    textureSizeIndex,
                    new string[] { "128", "256", "512", "1024", "2048" }
                );
            }

            GUILayout.Space(6);

            // Start / Stop button
            GUI.backgroundColor = painting
                ? new Color(0.85f, 0.22f, 0.22f)
                : new Color(0.22f, 0.85f, 0.22f);

            if (GUILayout.Button(painting ? "Stop Painting" : "Start Painting", GUILayout.Height(36)))
            {
                painting = !painting;
                if (painting) StartPainting();
                else StopPainting();
            }
            GUI.backgroundColor = Color.white;

            if (!painting) return;

            // Center yellow slow warning
            GUIStyle slowWarn = new GUIStyle(EditorStyles.label)
            {
                alignment = TextAnchor.MiddleCenter,
                fontStyle = FontStyle.Bold
            };
            slowWarn.normal.textColor = Color.yellow;
            GUILayout.Space(3);
            GUILayout.Label("⚠ Drag mouse SLOW to yield better results", slowWarn);
            GUILayout.Space(6);

            // Brush controls
            brushSize = EditorGUILayout.Slider("Brush Size", brushSize, 32f, 512f);
            opacity = EditorGUILayout.Slider("Opacity", opacity, 0.05f, 1f);
            clampToUV = EditorGUILayout.Toggle("Clamp To UV", clampToUV);

            GUILayout.Space(10);

            activeBrush = GUILayout.SelectionGrid(
                activeBrush,
                scaledBrushes,
                scaledBrushes.Length,
                GUILayout.Height(48)
            );

            GUILayout.Space(10);

            // Reset button (grey)
            GUI.backgroundColor = new Color(0.76f, 0.76f, 0.76f);
            if (GUILayout.Button("Reset", GUILayout.Height(28)))
                ClearMask();
            GUI.backgroundColor = Color.white;

            GUILayout.Space(8);

            // Big Save button (green)
            GUIStyle saveStyle = new GUIStyle(GUI.skin.button)
            {
                fontSize = 15,
                fontStyle = FontStyle.Bold,
                alignment = TextAnchor.MiddleCenter
            };
            saveStyle.normal.textColor = Color.white;
            GUI.backgroundColor = new Color(0.15f, 0.75f, 0.25f);

            if (GUILayout.Button("Save To Texture", saveStyle, GUILayout.Height(48)))
                SaveMask();

            GUI.backgroundColor = Color.white;

            GUILayout.Space(12);

            if (alphaMask)
            {
                Rect r = GUILayoutUtility.GetRect(300, 300);
                GUI.DrawTexture(r, alphaMask, ScaleMode.ScaleToFit);
            }
        }

        // ─────────────────────────────────────────────
        // PAINTING CORE
        // ─────────────────────────────────────────────
        void StartPainting()
        {
            if (!alphaMask)
                CreateMask();
            ApplyPreview();
        }

        void StopPainting()
        {
            painting = false;
            RestoreMaterial();
        }

        void CreateMask()
        {
            int size = textureSizes[textureSizeIndex];
            alphaMask = new Texture2D(size, size, TextureFormat.RGBA32, false, true);
            alphaMask.wrapMode = TextureWrapMode.Repeat;
            ClearMask();
        }

        // Paints ALPHA holes: black RGB, lerp alpha toward 0
        void Paint(Vector2 uv)
        {
            if (!alphaMask) return;

            int radius = Mathf.RoundToInt(brushSize * 0.5f);
            Texture2D brush = scaledBrushes[activeBrush];
            Color[] pixels = alphaMask.GetPixels();

            int cx = Mathf.RoundToInt(uv.x * alphaMask.width);
            int cy = Mathf.RoundToInt(uv.y * alphaMask.height);

            for (int y = -radius; y <= radius; y++)
            {
                for (int x = -radius; x <= radius; x++)
                {
                    int px = cx + x;
                    int py = cy + y;

                    if (clampToUV)
                    {
                        if (px < 0 || px >= alphaMask.width || py < 0 || py >= alphaMask.height)
                            continue;
                    }
                    else
                    {
                        px = (px + alphaMask.width) % alphaMask.width;
                        py = (py + alphaMask.height) % alphaMask.height;
                    }

                    int idx = py * alphaMask.width + px;

                    Color maskSample = brush.GetPixelBilinear(
                        (float)(x + radius) / (radius * 2f),
                        (float)(y + radius) / (radius * 2f));

                    Color old = pixels[idx];

                    // Target = fully transparent black
                    Color hole = new Color(0f, 0f, 0f, 0f);

                    pixels[idx] = Color.Lerp(old, hole, maskSample.a * opacity);
                }
            }

            alphaMask.SetPixels(pixels);
            alphaMask.Apply();
            ApplyPreview();
        }

        // ─────────────────────────────────────────────
        // SCENE VIEW
        // ─────────────────────────────────────────────
        void OnSceneGUI(SceneView sv)
        {
            if (!painting || !alphaMask || !mr) return;

            HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));

            Event e = Event.current;
            Ray ray = HandleUtility.GUIPointToWorldRay(e.mousePosition);
            if (!Physics.Raycast(ray, out RaycastHit hit)) return;
            if (hit.collider.gameObject != go) return;

            float worldRadius = (brushSize / alphaMask.width) * mf.sharedMesh.bounds.extents.magnitude;
            Handles.color = Color.yellow;
            Handles.DrawWireDisc(hit.point, hit.normal, worldRadius);

            if (e.type == EventType.MouseDrag && e.button == 0 && !e.alt)
            {
                Paint(hit.textureCoord);
                e.Use();
                sv.Repaint();
            }
        }

        // ─────────────────────────────────────────────
        // PREVIEW
        // ─────────────────────────────────────────────
        void ApplyPreview()
        {
            if (!mr || !alphaMask) return;

            if (preview == PreviewMode.RawPreview)
            {
                if (!unlitMat)
                {
                    unlitMat = new Material(Shader.Find("Universal Render Pipeline/Unlit"));
                    if (unlitMat != null)
                    {
                        // Force URP Transparent Mode (FULL)
                        unlitMat.SetFloat("_Surface", 1f); // 1 = Transparent
                        unlitMat.SetFloat("_BlendMode", 0f); // Alpha blending

                        unlitMat.EnableKeyword("_SURFACE_TYPE_TRANSPARENT");
                        unlitMat.DisableKeyword("_SURFACE_TYPE_OPAQUE");

                        unlitMat.EnableKeyword("_ALPHAPREMULTIPLY_ON");
                        unlitMat.DisableKeyword("_ALPHATEST_ON");

                        unlitMat.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        unlitMat.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        unlitMat.SetInt("_ZWrite", 0);

                        unlitMat.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;

                        // Identity color
                        unlitMat.SetColor("_BaseColor", Color.white);
                    }
                }


                if (unlitMat != null)
                {
                    unlitMat.SetTexture("_BaseMap", alphaMask);
                    mr.sharedMaterial = unlitMat;
                }
                return;
            }

            // LitMAS Water preview: restore original material, then assign mask
            if (originalMaterial != null)
                mr.sharedMaterial = originalMaterial;

            if (mr.sharedMaterial != null && mr.sharedMaterial.HasProperty(MASK_SLOT))
                mr.sharedMaterial.SetTexture(MASK_SLOT, alphaMask);
        }

        void RestoreMaterial()
        {
            if (mr && originalMaterial)
                mr.sharedMaterial = originalMaterial;
        }

        // ─────────────────────────────────────────────
        // SAVE / RESET
        // ─────────────────────────────────────────────
        void SaveMask()
        {
            string file = EditorUtility.SaveFilePanelInProject(
                "Save Alpha Mask",
                "AlphaMask",
                "png",
                ""
            );
            if (string.IsNullOrEmpty(file)) return;

            File.WriteAllBytes(file, alphaMask.EncodeToPNG());
            AssetDatabase.Refresh();

            TextureImporter ti = AssetImporter.GetAtPath(file) as TextureImporter;
            if (ti != null)
            {
                ti.textureType = TextureImporterType.Default;
                ti.alphaSource = TextureImporterAlphaSource.FromInput;
                ti.alphaIsTransparency = true;
                ti.SaveAndReimport();
            }

            Texture2D tex = AssetDatabase.LoadAssetAtPath<Texture2D>(file);
            if (mr != null && mr.sharedMaterial != null && mr.sharedMaterial.HasProperty(MASK_SLOT))
                mr.sharedMaterial.SetTexture(MASK_SLOT, tex);
        }

        void ClearMask()
        {
            if (alphaMask == null) return;

            // Start as fully opaque black
            Color[] fill = new Color[alphaMask.width * alphaMask.height];
            for (int i = 0; i < fill.Length; i++)
                fill[i] = new Color(0f, 0f, 0f, 1f);

            alphaMask.SetPixels(fill);
            alphaMask.Apply();
            ApplyPreview();
        }

        // ─────────────────────────────────────────────
        // UTILS
        // ─────────────────────────────────────────────
        void AutoAssign()
        {
            go = Selection.activeGameObject;
            if (!go) return;

            mr = go.GetComponent<MeshRenderer>();
            mf = go.GetComponent<MeshFilter>();

            if (!mr || !mf) return;

            if (originalMaterial == null)
                originalMaterial = mr.sharedMaterial;
        }

        void LoadBrushes()
        {
            string path = "Assets/AtlasShaders/LitMAS Water/Scripts/Editor/Flowmapping/Brushes/";

            brushes = new Texture2D[4];
            scaledBrushes = new Texture2D[4];

            for (int i = 0; i < 4; i++)
            {
                brushes[i] = AssetDatabase.LoadAssetAtPath<Texture2D>($"{path}LWFP_BrushFalloff_{i + 1}.png");
                if (brushes[i] != null)
                    scaledBrushes[i] = Instantiate(brushes[i]);
            }
        }
    }
}
#endif
