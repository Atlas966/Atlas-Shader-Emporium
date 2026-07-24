using UnityEditor;
using UnityEngine;

public class LitMASWaterCausticsGUI : ShaderGUI
{
    MaterialEditor m_MaterialEditor;
    private GUIStyle boxStyle;
    private GUIStyle headerStyle;

    // ---------- standardized ? tooltip helpers ----------
    private static GUIStyle _helpIconStyle;

    private GUIStyle HelpIconStyle
    {
        get
        {
            if (_helpIconStyle == null)
            {
                _helpIconStyle = new GUIStyle(GUI.skin.box)
                {
                    alignment = TextAnchor.MiddleCenter,
                    fontStyle = FontStyle.Bold,
                    fixedWidth = 20,
                    fixedHeight = 20,
                    margin = new RectOffset(2, 6, 0, 0),
                    padding = new RectOffset(0, 0, 0, 0)
                };
                _helpIconStyle.normal.textColor = Color.white;
            }
            return _helpIconStyle;
        }
    }

    private void DrawHelpIcon(string tooltip)
    {
        GUIContent c = new GUIContent("?", tooltip);
        GUILayout.Box(c, HelpIconStyle, GUILayout.Width(20), GUILayout.Height(20));
    }

    private void DrawHelpIcon(Rect position, string tooltip)
    {
        GUIContent c = new GUIContent("?", tooltip);
        GUI.Box(position, c, HelpIconStyle);
    }

    // ---------- helpers ----------
    private void DrawToggleGroup(MaterialProperty toggle, System.Action drawContent)
    {
        if (toggle == null) return;

        m_MaterialEditor.ShaderProperty(toggle, toggle.displayName);
        if (toggle.floatValue == 1 && drawContent != null)
        {
            EditorGUI.indentLevel++;
            drawContent.Invoke();
            EditorGUI.indentLevel--;
        }
    }

    private void DrawBox(string title, System.Action drawContents)
    {
        if (boxStyle == null)
        {
            boxStyle = new GUIStyle(GUI.skin.box)
            {
                padding = new RectOffset(10, 10, 10, 10),
                margin = new RectOffset(5, 5, 5, 5)
            };
            boxStyle.normal.background = MakeRoundedTexture(2, new Color(0.2f, 0.2f, 0.2f, 0.4f));
        }

        if (headerStyle == null)
        {
            headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontSize = 13
            };
        }

        EditorGUILayout.BeginVertical(boxStyle);
        if (!string.IsNullOrEmpty(title))
        {
            GUILayout.Label(title, headerStyle);
            EditorGUILayout.Space();
        }
        drawContents?.Invoke();
        EditorGUILayout.EndVertical();
        EditorGUILayout.Space();
    }

    private Texture2D MakeRoundedTexture(int radius, Color color)
    {
        int size = radius * 2 + 2;
        Texture2D tex = new Texture2D(size, size);
        Color transparent = new Color(0, 0, 0, 0);

        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                bool inside =
                    (x >= radius && x < size - radius) ||
                    (y >= radius && y < size - radius);

                tex.SetPixel(x, y, inside ? color : transparent);
            }
        }

        tex.Apply();
        return tex;
    }

    private MaterialProperty P(MaterialProperty[] props, string name)
    {
        try { return FindProperty(name, props, false); }
        catch { return null; }
    }

    // ---------- main GUI ----------
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        m_MaterialEditor = materialEditor;

        // Title
        EditorGUILayout.Space(10);
        GUIStyle titleStyle = new GUIStyle(EditorStyles.boldLabel)
        {
            fontSize = 22,
            alignment = TextAnchor.MiddleCenter,
            normal = { textColor = new Color(0.25f, 0.6f, 1f) }
        };
        GUILayout.Label("LitMAS Water Caustics", titleStyle);
        EditorGUILayout.Space(10);

        GUIStyle sectionHeaderStyle = new GUIStyle(titleStyle)
        {
            fontSize = 18,
            alignment = TextAnchor.MiddleLeft
        };
        sectionHeaderStyle.normal.textColor = Color.white;

        // === PROPERTIES ===

        // Caustics Core
        var _Color = P(props, "_Color");
        var _Caustics = P(props, "_Caustics");
        var _EnableAntiTile = P(props, "_EnableAntiTile");
        var _CausticScale = P(props, "_CausticScale");
        var _FlowAXYSpeed = P(props, "_FlowAXYSpeed");
        var _FlowBXYSpeed = P(props, "_FlowBXYSpeed");
        var _Falloff = P(props, "_Falloff");
        var _CircleMask = P(props, "_CircleMask");

        // Chromatic Aberration
        var _ChromaticAberration = P(props, "_ChromaticAberration");
        var _RGBOffset1 = P(props, "_RGBOffset1");

        // Distorted UVs
        var _EnableDistortedUVs = P(props, "_EnableDistortedUVs");
        var _Distortion = P(props, "_Distortion");
        var _Tiling = P(props, "_Tiling");
        var _OffsetXYSpeed = P(props, "_OffsetXYSpeed");
        var _DistortionStrength = P(props, "_DistortionStrength");

        // Blue Noise
        var _EnableBlueNoise = P(props, "_EnableBlueNoise");
        var _NoiseDefusion = P(props, "_NoiseDefusion");

        // Post Processing
        var _EnablePostProcessing = P(props, "_EnablePostProcessing");
        var _Grayscale = P(props, "_Grayscale");
        var _Saturation = P(props, "_Saturation");
        var _SaturationIntensity = P(props, "_SaturationIntensity");
        var _Contrast = P(props, "_Contrast");
        var _ContrastIntensity = P(props, "_ContrastIntensity");


        // ===================================================================
        // CAUSTICS
        // ===================================================================
        GUILayout.Label("Caustics", sectionHeaderStyle);
        EditorGUILayout.Space(4);

        DrawBox("Caustic Settings", () =>
        {
            if (_Color != null)
                m_MaterialEditor.ColorProperty(_Color, _Color.displayName);

            if (_Caustics != null)
                m_MaterialEditor.TextureProperty(_Caustics, _Caustics.displayName);

            if (_EnableAntiTile != null)
                m_MaterialEditor.ShaderProperty(_EnableAntiTile, _EnableAntiTile.displayName);

            if (_CausticScale != null)
                m_MaterialEditor.VectorProperty(_CausticScale, _CausticScale.displayName);

            if (_FlowAXYSpeed != null)
                m_MaterialEditor.VectorProperty(_FlowAXYSpeed, "Flow A (XY = Speed)");

            if (_FlowBXYSpeed != null)
                m_MaterialEditor.VectorProperty(_FlowBXYSpeed, "Flow B (XY = Speed)");

            // Falloff
            if (_Falloff != null)
            {
                EditorGUILayout.BeginHorizontal();
                DrawHelpIcon("Controls caustic color falloff.");
                m_MaterialEditor.ShaderProperty(_Falloff, _Falloff.displayName);
                EditorGUILayout.EndHorizontal();
            }

            // Circle Mask
            if (_CircleMask != null)
            {
                EditorGUILayout.BeginHorizontal();
                DrawHelpIcon("Spherical mask for how far out caustics can appear from outside the bounds of the mesh. Keep value between 1 and 5.");
                m_MaterialEditor.ShaderProperty(_CircleMask, _CircleMask.displayName);
                EditorGUILayout.EndHorizontal();
            }
        });

        // ===================================================================
        // VISUALS
        // ===================================================================
        GUILayout.Label("Visuals", sectionHeaderStyle);
        EditorGUILayout.Space(4);


        // ===================================================================
        // CHROMATIC ABERRATION
        // ===================================================================
        DrawBox("Chromatic Aberration", () =>
        {
            if (_ChromaticAberration != null)
            {
                EditorGUILayout.BeginHorizontal();
                DrawHelpIcon("Adjust offset between R, G, and B channels in the caustic texture. Provides realistic caustic visuals.");
                m_MaterialEditor.ShaderProperty(_ChromaticAberration, _ChromaticAberration.displayName);
                EditorGUILayout.EndHorizontal();
            }

            if (_ChromaticAberration.floatValue == 1f)
            {
                EditorGUI.indentLevel++;
                if (_RGBOffset1 != null)
                    m_MaterialEditor.ShaderProperty(_RGBOffset1, "RGB Offset");
                EditorGUI.indentLevel--;
            }
        });


        // ===================================================================
        // BLUE NOISE
        // ===================================================================
        DrawBox("Blue Noise", () =>
        {
            if (_EnableBlueNoise != null)
            {
                EditorGUILayout.BeginHorizontal();
                DrawHelpIcon("Enable Blue Noise diffusion to give caustics a unique and interesting visual appearance. Keep Noise Diffusion relatively low (~0.025).");
                m_MaterialEditor.ShaderProperty(_EnableBlueNoise, _EnableBlueNoise.displayName);
                EditorGUILayout.EndHorizontal();
            }

            if (_EnableBlueNoise.floatValue == 1f)
            {
                EditorGUI.indentLevel++;
                if (_NoiseDefusion != null)
                    m_MaterialEditor.ShaderProperty(_NoiseDefusion, "Noise Diffusion");
                EditorGUI.indentLevel--;
            }
        });


        // ===================================================================
        // POST PROCESSING
        // ===================================================================
        DrawBox("Post Processing", () =>
        {
            if (_EnablePostProcessing != null)
            {
                EditorGUILayout.BeginHorizontal();

                Rect ppRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                DrawHelpIcon(ppRect,
                    "Change properties that control the visual appearance of caustics. Mix and match different features for interesting results."
                );

                m_MaterialEditor.ShaderProperty(_EnablePostProcessing, _EnablePostProcessing.displayName);

                EditorGUILayout.EndHorizontal();
            }

            if (_EnablePostProcessing.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                // Grayscale
                if (_Grayscale != null)
                {
                    EditorGUILayout.BeginHorizontal();
                    Rect gRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(gRect, "Make caustics appear completely black and white.");
                    m_MaterialEditor.ShaderProperty(_Grayscale, _Grayscale.displayName);
                    EditorGUILayout.EndHorizontal();
                    EditorGUILayout.Space(6);
                }

                // Saturation
                if (_Saturation != null)
                {
                    EditorGUILayout.BeginHorizontal();
                    Rect sRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(sRect, "Increase saturation of caustics to provide an enhanced appearance.");
                    m_MaterialEditor.ShaderProperty(_Saturation, _Saturation.displayName);
                    EditorGUILayout.EndHorizontal();

                    if (_Saturation.floatValue == 1f && _SaturationIntensity != null)
                    {
                        EditorGUI.indentLevel++;
                        m_MaterialEditor.ShaderProperty(_SaturationIntensity, _SaturationIntensity.displayName);
                        EditorGUI.indentLevel--;
                    }

                    EditorGUILayout.Space(6);
                }

                // Contrast
                if (_Contrast != null)
                {
                    EditorGUILayout.BeginHorizontal();
                    Rect cRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(cRect, "Increase contrast to provide more or less definition to caustic appearance.");
                    m_MaterialEditor.ShaderProperty(_Contrast, _Contrast.displayName);
                    EditorGUILayout.EndHorizontal();

                    if (_Contrast.floatValue == 1f && _ContrastIntensity != null)
                    {
                        EditorGUI.indentLevel++;
                        m_MaterialEditor.ShaderProperty(_ContrastIntensity, _ContrastIntensity.displayName);
                        EditorGUI.indentLevel--;
                    }

                    EditorGUILayout.Space(6);
                }

                EditorGUI.indentLevel--;
            }
        });


        // ===================================================================
        // UV OPTIONS (BIG HEADER LIKE LW3)
        // ===================================================================
        GUILayout.Label("UV Options", sectionHeaderStyle);
        EditorGUILayout.Space(4);


        // ===================================================================
        // DISTORTED UVs (inside UV Options)
        // ===================================================================
        DrawBox("Distorted UV's", () =>
        {
            if (_EnableDistortedUVs != null)
            {
                EditorGUILayout.BeginHorizontal();
                DrawHelpIcon("Distort caustic visuals for a more realistic appearance. Keep tiling relatively low (~0.1), and Distortion Strength relatively low (~0.25).");
                m_MaterialEditor.ShaderProperty(_EnableDistortedUVs, _EnableDistortedUVs.displayName);
                EditorGUILayout.EndHorizontal();
            }

            if (_EnableDistortedUVs.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                if (_Distortion != null)
                    m_MaterialEditor.TextureProperty(_Distortion, _Distortion.displayName);

                if (_Tiling != null)
                    m_MaterialEditor.VectorProperty(_Tiling, "Tiling");

                if (_OffsetXYSpeed != null)
                    m_MaterialEditor.VectorProperty(_OffsetXYSpeed, "Offset");

                if (_DistortionStrength != null)
                    m_MaterialEditor.ShaderProperty(_DistortionStrength, "Distortion Strength");

                EditorGUI.indentLevel--;
            }
        });
    }
}
