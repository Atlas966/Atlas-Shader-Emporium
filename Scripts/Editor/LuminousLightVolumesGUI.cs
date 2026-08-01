using System.Linq;
using UnityEditor;
using UnityEngine;

public class LuminousLightbeamGUI : ShaderGUI
{
    private const string LogoPath = "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/LuminousLightVolumes Logo.psd";

    MaterialEditor m_MaterialEditor;
    GUIStyle headerStyle;
    GUIStyle titleCharStyle;
    Texture2D logoTexture;
    bool triedLoadingLogo;

    // Monochrome theme: top-level boxes use a bright, near-white accent; nested
    // sub-boxes use a dimmer grey, so hierarchy still reads clearly without color.
    static readonly Color TopAccent = new Color(0.88f, 0.88f, 0.88f);
    static readonly Color NestedAccent = new Color(0.6f, 0.6f, 0.6f);

    private MaterialProperty P(MaterialProperty[] props, string name)
    {
        try { return FindProperty(name, props, false); }
        catch { return null; }
    }

    // returns true when a toggle-style MaterialProperty is currently "on"
    bool IsOn(MaterialProperty toggleProp)
    {
        return toggleProp != null && toggleProp.floatValue > 0.5f;
    }

    // ---------- BOXES ----------

    void DrawBox(string title, Color accentColor, System.Action draw, bool gradientStripe = false)
    {
        var boxStyle = new GUIStyle(GUI.skin.box);
        boxStyle.padding = new RectOffset(8, 6, 2, 4);
        boxStyle.margin = new RectOffset(0, 0, 3, 3);

        Color baseColor = new Color(0.1f, 0.1f, 0.1f, 1f);
        float blend = 0.05f;
        Color faded = new Color(accentColor.r, accentColor.g, accentColor.b, 1f);
        Color bgColor = Color.Lerp(baseColor, faded, blend);
        bgColor.a = 0.9f;
        boxStyle.normal.background = MakeTexture(bgColor);

        if (headerStyle == null)
        {
            headerStyle = new GUIStyle(EditorStyles.boldLabel);
            headerStyle.alignment = TextAnchor.MiddleCenter;
            headerStyle.fontSize = 11;
            headerStyle.fontStyle = FontStyle.Bold;
            headerStyle.margin = new RectOffset(0, 0, 0, 0);
            headerStyle.padding = new RectOffset(0, 0, 2, 0);
        }
        headerStyle.normal.textColor = accentColor;

        EditorGUILayout.BeginVertical(boxStyle);

        GUILayout.Label(title, headerStyle);

        draw?.Invoke();
        EditorGUILayout.EndVertical();

        var rect = GUILayoutUtility.GetLastRect();

        if (gradientStripe)
        {
            DrawGradientStripe(new Rect(rect.x, rect.y, 3, rect.height));
        }
        else
        {
            EditorGUI.DrawRect(new Rect(rect.x, rect.y, 3, rect.height), accentColor);
        }
    }

    void DrawGradientStripe(Rect rect)
    {
        int slices = Mathf.Max(1, Mathf.CeilToInt(rect.height / 2f));

        Color start = new Color(0.95f, 0.95f, 0.95f); // near white
        Color end = new Color(0.15f, 0.15f, 0.15f);   // near black

        for (int i = 0; i < slices; i++)
        {
            float sliceHeight = rect.height / slices;
            float t = slices <= 1 ? 0f : (float)i / (slices - 1);
            Color c = Color.Lerp(start, end, t);
            EditorGUI.DrawRect(new Rect(rect.x, rect.y + i * sliceHeight, rect.width, sliceHeight + 1), c);
        }
    }

    Texture2D MakeTexture(Color c)
    {
        Texture2D t = new Texture2D(2, 2);
        t.SetPixels(new[] { c, c, c, c });
        t.Apply();
        return t;
    }

    // Optional "label" override lets us show a custom display name in the GUI
    // without needing to touch the property's [Header]/display name in the
    // .shader file itself.
    void Prop(MaterialProperty p, string label = null)
    {
        if (p != null)
            m_MaterialEditor.ShaderProperty(p, label ?? p.displayName);
    }

    // Draws a toggle without going through MaterialEditor.ShaderProperty, which
    // auto-renders any [Header]/[Space] decorator attached to the property in the
    // shader file. That decorator is what was causing the extra gap above the
    // toggles sitting right under a box title. The label stays left-aligned like
    // a normal field; the checkbox is placed at the true horizontal center of the
    // row (not just centered in the space left over after the label).
    void ToggleProp(MaterialProperty p, string label = null)
    {
        if (p == null) return;

        Rect row = EditorGUILayout.GetControlRect(GUILayout.Height(EditorGUIUtility.singleLineHeight));

        EditorGUI.showMixedValue = p.hasMixedValue;
        EditorGUI.BeginChangeCheck();

        EditorGUI.LabelField(row, label ?? p.displayName);

        const float toggleWidth = 16f;
        Rect toggleRect = new Rect(row.x + row.width * 0.5f - toggleWidth * 0.5f, row.y, toggleWidth, row.height);
        bool value = EditorGUI.Toggle(toggleRect, p.floatValue > 0.5f);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(p.displayName);
            p.floatValue = value ? 1f : 0f;
        }
        EditorGUI.showMixedValue = false;
    }

    void Tex(MaterialProperty p)
    {
        if (p != null)
            m_MaterialEditor.TextureProperty(p, p.displayName);
    }

    void ColorProp(MaterialProperty p, string label = null)
    {
        if (p != null)
            m_MaterialEditor.ColorProperty(p, label ?? p.displayName);
    }

    void DrawGradientTitle(string text, int fontSize, Color colorStart, Color colorEnd)
    {
        if (titleCharStyle == null)
        {
            titleCharStyle = new GUIStyle(EditorStyles.boldLabel);
        }
        titleCharStyle.fontSize = fontSize;
        titleCharStyle.alignment = TextAnchor.MiddleCenter;
        titleCharStyle.fontStyle = FontStyle.Bold;

        float[] charWidths = new float[text.Length];
        for (int i = 0; i < text.Length; i++)
        {
            var size = titleCharStyle.CalcSize(new GUIContent(text[i].ToString()));
            charWidths[i] = size.x;
        }

        EditorGUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        for (int i = 0; i < text.Length; i++)
        {
            float t = text.Length <= 1 ? 0f : (float)i / (text.Length - 1);
            titleCharStyle.normal.textColor = Color.Lerp(colorStart, colorEnd, t);
            GUILayout.Label(text[i].ToString(), titleCharStyle, GUILayout.Width(charWidths[i]));
        }
        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();
    }

    void DrawLogo()
    {
        if (!triedLoadingLogo)
        {
            triedLoadingLogo = true;
            logoTexture = AssetDatabase.LoadAssetAtPath<Texture2D>(LogoPath);
        }

        if (logoTexture == null) return;

        float maxHeight = 64f;
        float aspect = (float)logoTexture.width / logoTexture.height;
        float drawHeight = maxHeight;
        float drawWidth = drawHeight * aspect;

        EditorGUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.Label(logoTexture, GUILayout.Width(drawWidth), GUILayout.Height(drawHeight));
        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();
    }

    // Slider that offsets each selected material's render queue relative to its
    // shader's own default queue - mirrors Unity's standard "Sorting Priority"
    // control: centered on 0, and can go negative or positive.
    void DrawSortingPrioritySlider()
    {
        if (m_MaterialEditor.targets == null || m_MaterialEditor.targets.Length == 0) return;

        var firstMaterial = m_MaterialEditor.targets[0] as Material;
        if (firstMaterial == null || firstMaterial.shader == null) return;

        int shaderQueue = firstMaterial.shader.renderQueue;
        int currentOffset = Mathf.Clamp(firstMaterial.renderQueue - shaderQueue, -50, 50);

        EditorGUI.BeginChangeCheck();
        int newOffset = EditorGUILayout.IntSlider("Sorting Priority", currentOffset, -50, 50);
        if (EditorGUI.EndChangeCheck())
        {
            Undo.RecordObjects(m_MaterialEditor.targets, "Change Sorting Priority");
            foreach (var target in m_MaterialEditor.targets)
            {
                var material = target as Material;
                if (material != null && material.shader != null)
                    material.renderQueue = material.shader.renderQueue + newOffset;
            }
        }
    }

    // Returns true only when this GUI is being used by the lit Luminous Lightbeam shader.
    bool IsLuminousLightbeamLit()
    {
        if (m_MaterialEditor == null || m_MaterialEditor.targets == null)
            return false;

        foreach (var target in m_MaterialEditor.targets)
        {
            var material = target as Material;
            if (material == null || material.shader == null ||
                material.shader.name != "AtlasShaders/Luminous Light Volumes/Luminous Lightbeam Lit")
            {
                return false;
            }
        }

        return m_MaterialEditor.targets.Length > 0;
    }

    // ---------- MAIN GUI ----------

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        m_MaterialEditor = materialEditor;

        GUILayout.Space(4);
        DrawLogo();
        GUILayout.Space(2);

        Color titleStart = new Color(0.45f, 0.43f, 0.81f);
        Color titleEnd = Color.white;
        DrawGradientTitle("Luminous Lightbeam", 20, titleStart, titleEnd);
        GUILayout.Space(4);

        // BASE
        var BeamColor = P(props, "_BeamColor");
        var GlobalIntensity = P(props, "_GlobalIntensity");

        // Edge Color Falloff (formerly "White Edge Falloff")
        var EnableEdgeColorFalloff = P(props, "_EnableEdgeColorFalloff");
        var EdgeColorFalloffColor = P(props, "_EdgeColorFalloff");
        var ColorEdgeBlend = P(props, "_ColorEdgeBlend");
        var ColorEdgeFalloff = P(props, "_ColorEdgeFalloff");

        var EnableGradient = P(props, "_EnableGradient");
        var GradientProp = P(props, "_Gradient");
        var GradientScrollSpeed = P(props, "_GradientScrollSpeed");

        DrawBox("Base Attributes", TopAccent, () => {

            DrawSortingPrioritySlider();
            ColorProp(BeamColor);
            Prop(GlobalIntensity, "Global Intensity");

            DrawBox("Edge Color Falloff", NestedAccent, () => {
                ToggleProp(EnableEdgeColorFalloff, "Enable Edge Color Falloff");
                if (IsOn(EnableEdgeColorFalloff))
                {
                    ColorProp(EdgeColorFalloffColor, "Edge Color Falloff");
                    Prop(ColorEdgeBlend, "Color Edge Blend");
                    Prop(ColorEdgeFalloff, "Color Edge Falloff");
                }
            });

            DrawBox("Gradient", NestedAccent, () => {
                ToggleProp(EnableGradient);
                if (IsOn(EnableGradient))
                {
                    Prop(GradientProp);
                    Prop(GradientScrollSpeed, "Gradient Scroll Speed");
                }
            }, gradientStripe: true);
        });



        // BEAM SETTINGS
        DrawBox("Beam Settings", TopAccent, () => {

            Prop(P(props, "_EdgeFalloff"));
            Prop(P(props, "_Length"));
            Prop(P(props, "_LengthFalloff"));

        });



        // SOFT INTERSECTION
        var EnableSoftIntersection = P(props, "_EnableSoftIntersection");
        var EnableCameraDepthFading = P(props, "_EnableCameraDepthFading");

        DrawBox("Soft Intersection Settings", TopAccent, () => {

            ToggleProp(EnableSoftIntersection);

            if (IsOn(EnableSoftIntersection))
            {
                Prop(P(props, "_SoftIntersection"));
                Prop(P(props, "_DepthFadeBlueNoise"));
                Prop(P(props, "_DepthFadeBlueNoiseSize"));

                DrawBox("Camera Depth Fading", NestedAccent, () => {

                    ToggleProp(EnableCameraDepthFading);

                    if (IsOn(EnableCameraDepthFading))
                    {
                        Prop(P(props, "_CDFalloff"));
                        Prop(P(props, "_CDDistance"));
                    }

                });
            }

        });



        // BLUE NOISE
        var EnableBlueNoiseOverlay = P(props, "_EnableBlueNoiseOverlay");

        DrawBox("Blue Noise", TopAccent, () => {

            ToggleProp(EnableBlueNoiseOverlay);

            if (IsOn(EnableBlueNoiseOverlay))
            {
                Prop(P(props, "_BlueNoise"));
            }

        });



        // 3D NOISE
        var Enable3DNoise = P(props, "_Enable3DNoise");
        var NoiseType = P(props, "_NoiseType");

        DrawBox("3D Noise", TopAccent, () => {

            ToggleProp(Enable3DNoise);

            if (IsOn(Enable3DNoise))
            {
                Prop(NoiseType, "Noise Type");
                Prop(P(props, "_3DNoiseIntensity"));

                // Hide 3D noise texture when Generated (NoiseType = 1)
                if (NoiseType == null || NoiseType.floatValue == 0)
                {
                    Tex(P(props, "_3DNoise"));
                }

                Prop(P(props, "_NoiseVelocity"), "Noise Velocity");
                Prop(P(props, "_WorldSpaceNoise"));
                Prop(P(props, "_3DNoiseTiling"));
                Prop(P(props, "_3DNoiseSpeed"));
                Prop(P(props, "_FactorNoiseIntoAlpha"));
                Prop(P(props, "_3DNoiseAlphaFalloff"));
                Prop(P(props, "_3DNoiseAlphaIntensity"));
            }

        });



        // COOKIE
        var EnableCookieProjection = P(props, "_EnableCookieProjection");

        DrawBox("Cookie Projection", TopAccent, () => {

            ToggleProp(EnableCookieProjection);

            if (IsOn(EnableCookieProjection))
            {
                ColorProp(P(props, "_CookieColor"));
                Tex(P(props, "_Cookie"));
                Prop(P(props, "_CookieAlphaContribution"));
                Prop(P(props, "_CookieLength"));
                Prop(P(props, "_CookieBlending"));
                Prop(P(props, "_Saturation"));
            }

        });



        // QUEST
        DrawBox("Quest Depth Fade", TopAccent, () => {

            Prop(P(props, "_QuestDepthFade"));
            Prop(P(props, "_QuestDepthFadeBlueNoiseSize"));
            ToggleProp(P(props, "_PCDebug"));

        });

        // BRDF settings only exist on the lit Luminous Lightbeam shader.
        if (IsLuminousLightbeamLit())
        {
            var EnableBRDFMap = P(props, "BRDFMAP");

            DrawBox("BRDF Settings", TopAccent, () => {

                ToggleProp(EnableBRDFMap, "Enable BRDF Map");

                if (IsOn(EnableBRDFMap))
                {
                    Tex(P(props, "g_tBRDFMap"));
                }

            });
        }

        // Our toggles above are drawn manually (EditorGUI.Toggle) instead of through
        // MaterialEditor.ShaderProperty, so Unity's automatic keyword syncing for any
        // [Toggle]-attributed property never runs. This call re-syncs material keywords
        // to match the current property values, which is what was making the toggles
        // look like they had no effect on the shader.
        if (GUI.changed)
        {
            MaterialEditor.ApplyMaterialPropertyDrawers(materialEditor.targets);
        }
    }
}