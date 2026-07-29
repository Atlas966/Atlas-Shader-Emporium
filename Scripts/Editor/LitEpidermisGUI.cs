using UnityEditor;
using UnityEngine;

public class LitEpidermisGUI : ShaderGUI
{
    private const string LogoPath = "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/Lit Epidermis.psd";

    MaterialEditor m_MaterialEditor;

    GUIStyle headerStyle;
    GUIStyle titleStyle;

    Texture2D logoTexture;
    bool triedLoadingLogo;

    static readonly Color TopAccent = new Color(0.88f, 0.88f, 0.88f);
    // Dimmer grey used for boxes nested inside a top-level box, same convention
    // as LuminousLightbeamGUI, so hierarchy reads clearly without extra color.
    static readonly Color NestedAccent = new Color(0.6f, 0.6f, 0.6f);

    // How much the rainbow title gets washed out toward white.
    // 0 = full saturation rainbow, 1 = pure white. Raised from the
    // previous implicit 0 to give a softer, more pastel look.
    const float RainbowFadeAmount = 0.55f;

    MaterialProperty P(MaterialProperty[] props, string name)
    {
        try { return FindProperty(name, props, false); }
        catch { return null; }
    }

    bool IsOn(MaterialProperty p)
    {
        return p != null && p.floatValue > 0.5f;
    }

    Texture2D MakeTexture(Color c)
    {
        Texture2D t = new Texture2D(2, 2);
        t.SetPixels(new[] { c, c, c, c });
        t.Apply();
        return t;
    }

    void DrawLogo()
    {
        if (!triedLoadingLogo)
        {
            triedLoadingLogo = true;
            logoTexture = AssetDatabase.LoadAssetAtPath<Texture2D>(LogoPath);
        }

        if (logoTexture == null)
            return;

        float maxHeight = 64f;
        float aspect = (float)logoTexture.width / logoTexture.height;

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.Label(logoTexture,
            GUILayout.Width(maxHeight * aspect),
            GUILayout.Height(maxHeight));
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
    }

    void DrawBox(string title, Color accent, System.Action draw)
    {
        GUIStyle s = new GUIStyle(GUI.skin.box);

        s.padding = new RectOffset(8, 6, 2, 4);
        s.margin = new RectOffset(0, 0, 3, 3);

        Color bg = Color.Lerp(new Color(.1f, .1f, .1f), accent, .05f);
        bg.a = .9f;

        s.normal.background = MakeTexture(bg);

        if (headerStyle == null)
        {
            headerStyle = new GUIStyle(EditorStyles.boldLabel);
            headerStyle.alignment = TextAnchor.MiddleCenter;
            headerStyle.fontSize = 11;
            headerStyle.fontStyle = FontStyle.Bold;
        }

        headerStyle.normal.textColor = accent;

        GUILayout.BeginVertical(s);

        GUILayout.Label(title, headerStyle);

        draw?.Invoke();

        GUILayout.EndVertical();

        Rect r = GUILayoutUtility.GetLastRect();
        EditorGUI.DrawRect(new Rect(r.x, r.y, 3, r.height), accent);
    }

    void Prop(MaterialProperty p, string name = null)
    {
        if (p != null)
            m_MaterialEditor.ShaderProperty(p, name ?? p.displayName);
    }

    void Tex(MaterialProperty p)
    {
        if (p != null)
            m_MaterialEditor.TextureProperty(p, p.displayName);
    }

    void ColorProp(MaterialProperty p, string name = null)
    {
        if (p != null)
            m_MaterialEditor.ColorProperty(p, name ?? p.displayName);
    }

    // Drawn manually (EditorGUI.Toggle) instead of through MaterialEditor.ShaderProperty
    // so a [Header]/[Space] decorator on the property can't push the row down and make
    // it look like the toggle vanished. Checkbox sits at the true horizontal center of
    // the row, same as LuminousLightbeamGUI.
    void Toggle(MaterialProperty p, string name = null)
    {
        if (p == null)
            return;

        Rect r = EditorGUILayout.GetControlRect();

        EditorGUI.showMixedValue = p.hasMixedValue;
        EditorGUI.BeginChangeCheck();

        EditorGUI.LabelField(r, name ?? p.displayName);

        Rect toggleRect = new Rect(
            r.x + r.width * .5f - 8,
            r.y,
            16,
            r.height);

        bool value = EditorGUI.Toggle(toggleRect, p.floatValue > .5f);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(p.displayName);
            p.floatValue = value ? 1 : 0;
        }
        EditorGUI.showMixedValue = false;
    }

    // Drawn manually (EditorGUILayout.Slider) instead of through
    // MaterialEditor.ShaderProperty for the same reason as Toggle() above:
    // _QuestDepthFade has a [Header(Quest Depth Fade)] decorator in the shader,
    // and ShaderProperty auto-renders that decorator as its own bold label +
    // spacing above the row. Since our box already has a "Quest Depth Fade"
    // title, that decorator was drawing as a duplicate label with a gap
    // underneath it. Drawing the slider directly skips the decorator entirely.
    void RangeProp(MaterialProperty p, string name = null)
    {
        if (p == null)
            return;

        EditorGUI.showMixedValue = p.hasMixedValue;
        EditorGUI.BeginChangeCheck();

        float value = EditorGUILayout.Slider(name ?? p.displayName, p.floatValue, p.rangeLimits.x, p.rangeLimits.y);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(p.displayName);
            p.floatValue = value;
        }
        EditorGUI.showMixedValue = false;
    }

    void Title(string text)
    {
        if (titleStyle == null)
        {
            titleStyle = new GUIStyle(EditorStyles.boldLabel);
            titleStyle.alignment = TextAnchor.MiddleCenter;
            titleStyle.fontSize = 20;
            titleStyle.fontStyle = FontStyle.Bold;
        }

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        // Red -> warm white/orange gradient.
        Color start = new Color(0.72f, 0.18f, 0.18f);
        Color end = new Color(1.00f, 0.90f, 0.78f);

        const float fadeToWhite = 0.20f;

        for (int i = 0; i < text.Length; i++)
        {
            float t = (float)i / Mathf.Max(1, text.Length - 1);

            Color c = Color.Lerp(start, end, t);
            c = Color.Lerp(c, Color.white, fadeToWhite);

            titleStyle.normal.textColor = c;
            GUILayout.Label(text[i].ToString(), titleStyle);
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        m_MaterialEditor = materialEditor;

        GUILayout.Space(4);

        DrawLogo();

        GUILayout.Space(2);

        Title("Lit Epidermis");

        GUILayout.Space(4);

        DrawBox("Main", TopAccent, () =>
        {
            ColorProp(P(props, "_Color"));
            Tex(P(props, "_Albedo"));
        });

        DrawBox("Normal", TopAccent, () =>
        {
            Tex(P(props, "_Normal"));
            Prop(P(props, "_NormalStrength"));
        });

        var useOcclusionFromTexture = P(props, "_UseOcclusionFromTexture");

        DrawBox("Metallic", TopAccent, () =>
        {
            Prop(P(props, "_MetallicType"));
            Tex(P(props, "_MetallicSmoothness"));
            RangeProp(P(props, "_Metallic"));
            RangeProp(P(props, "_Smoothness"));
            Toggle(useOcclusionFromTexture);

            if (IsOn(useOcclusionFromTexture))
            {
                DrawBox("Ambient Occlusion", NestedAccent, () =>
                {
                    Tex(P(props, "_AmbientOcclusion"));
                    RangeProp(P(props, "_AmbientOcclusionAmount"));
                });
            }
        });

        DrawBox("Emission", TopAccent, () =>
        {
            Tex(P(props, "_EmissionMap"));
            ColorProp(P(props, "_EmissionColor"));
            RangeProp(P(props, "_EmissionFalloff"));
            Toggle(P(props, "_EmitAlbedo"));
        });

        DrawBox("SSS Settings", TopAccent, () =>
        {
            Tex(P(props, "_ThicknessROcclusionGSSSMaskAOptional"));
            ColorProp(P(props, "_ScatteringColor"));
            RangeProp(P(props, "_TransluencyStrength"));
            RangeProp(P(props, "_NormalDistortion"));
            RangeProp(P(props, "_ScatteringAmount"));
            RangeProp(P(props, "_Direct"));
            RangeProp(P(props, "_Ambient"));
        });

        // Manual toggle controls bypass MaterialEditor.ShaderProperty, so refresh
        // the shader's [Toggle] and [KeywordEnum] drawers after any GUI change.
        if (GUI.changed)
        {
            MaterialEditor.ApplyMaterialPropertyDrawers(materialEditor.targets);
        }
    }
}