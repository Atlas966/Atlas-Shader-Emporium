using UnityEditor;
using UnityEngine;

public class HDRAdditive : ShaderGUI
{
    private const string LogoPath = "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/HDR Additive.psd";

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

    // _Cull stores a UnityEngine.Rendering.CullMode value (Off/Front/Back) and
    // controls which faces of the mesh get rendered. It's [HideInInspector] in
    // the shader (so Unity's default property drawer skips it), but that only
    // hides it from the automatic per-property list - FindProperty can still
    // find it and we can still drive it from a normal control.
    void CullProp(MaterialProperty p, string name = "Render Face")
    {
        if (p == null)
            return;

        EditorGUI.showMixedValue = p.hasMixedValue;
        EditorGUI.BeginChangeCheck();

        int mode = Mathf.RoundToInt(p.floatValue);

        string[] options =
        {
        "Both",
        "Front",
        "Back"
    };

        int selected;

        switch (mode)
        {
            case 0: // Off
                selected = 0;
                break;

            case 1: // Front
                selected = 2;
                break;

            default: // Back
                selected = 1;
                break;
        }

        selected = EditorGUILayout.Popup(name, selected, options);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(name);

            switch (selected)
            {
                case 0: // Both
                    p.floatValue = 0;
                    break;

                case 1: // Front (renders front faces, culls back)
                    p.floatValue = 2;
                    break;

                case 2: // Back (renders back faces, culls front)
                    p.floatValue = 1;
                    break;
            }
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

        Color[] rainbow =
        {
            new Color(1f,0f,0f),
            new Color(1f,0.5f,0f),
            new Color(1f,1f,0f),
            new Color(0f,1f,0f),
            new Color(0f,1f,1f),
            new Color(0f,0.5f,1f),
            new Color(0.8f,0f,1f)
        };

        for (int i = 0; i < text.Length; i++)
        {
            float t = (float)i / Mathf.Max(1, text.Length - 1);

            float scaled = t * (rainbow.Length - 1);
            int a = Mathf.FloorToInt(scaled);
            int b = Mathf.Min(a + 1, rainbow.Length - 1);

            Color pure = Color.Lerp(rainbow[a], rainbow[b], scaled - a);

            // Wash the color toward white so the title reads as a soft,
            // faded rainbow rather than a fully saturated one.
            titleStyle.normal.textColor = Color.Lerp(pure, Color.white, RainbowFadeAmount);

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

        Title("HDR Additive");

        GUILayout.Space(4);

        var tint = P(props, "_TintColor");
        var mainTex = P(props, "_MainTex");
        // Confirmed against HDR_Additive.shader: the property itself is declared
        // as "_IsTextureNonAdditiveHasAlpha" (the ALLCAPS string is only the
        // [Toggle(...)] keyword name, not the property name FindProperty needs).
        // There is no "_IsTextureAdditiveHasAlpha" property in this shader at
        // all, so that second toggle from the original script pointed at
        // nothing and has been removed.
        var nonAdditive = P(props, "_IsTextureNonAdditiveHasAlpha");
        var cull = P(props, "_Cull");

        DrawBox("Base Attributes", TopAccent, () =>
        {
            CullProp(cull);
            ColorProp(tint, "Tint Color");
            Tex(mainTex);
            Toggle(nonAdditive, "Is Texture Non-Additive? (Has Alpha)");
        });

        // Property names confirmed against HDR_Additive.shader.
        var depthFade = P(props, "_EnableDepthFade");
        var cameraFade = P(props, "_EnableCameraFade");

        // Blue Noise lives inside Depth Fade now, matching the shader's own
        // property order (_DepthFadeAmount, _BlueNoise, _BlueNoiseSize all sit
        // together before Camera Fade) instead of being split into its own box.
        DrawBox("Depth Fade", TopAccent, () =>
        {
            Toggle(depthFade, "Enable Depth Fade");

            if (IsOn(depthFade))
            {
                Prop(P(props, "_DepthFadeAmount"));
                Prop(P(props, "_BlueNoise"));
                Prop(P(props, "_BlueNoiseSize"));

                // Nested as its own box (matching LuminousLightbeamGUI's
                // "Camera Depth Fading" pattern) instead of a manual indent,
                // so Camera Fade visually reads as a child of Depth Fade and
                // fully disappears - toggle included - when Depth Fade is off.
                DrawBox("Camera Fade", NestedAccent, () =>
                {
                    Toggle(cameraFade, "Enable Camera Fade");

                    if (IsOn(cameraFade))
                    {
                        Prop(P(props, "_Falloff"));
                        Prop(P(props, "_Distance"));
                    }
                });
            }
        });

        // Standalone box at the end, laid out exactly like LuminousLightbeamGUI's
        // "Quest Depth Fade" box: not gated behind any toggle, _QuestDepthFade
        // followed by the PC Debug toggle. This shader has no Quest blue-noise-size
        // property (unlike Luminous), so it's just these two.
        DrawBox("Quest Depth Fade", TopAccent, () =>
        {
            RangeProp(P(props, "_QuestDepthFade"), "Quest Depth Fade");
            Toggle(P(props, "_PCDebug"), "PC Debug");
        });

        // Manual EditorGUI.Toggle calls bypass MaterialEditor.ShaderProperty, so Unity's
        // automatic keyword syncing for [Toggle]-attributed properties never runs on its
        // own. Re-sync here so toggles actually flip their shader keywords.
        if (GUI.changed)
        {
            MaterialEditor.ApplyMaterialPropertyDrawers(materialEditor.targets);
        }
    }
}