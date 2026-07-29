using UnityEditor;
using UnityEngine;

public class DecalUnlitGUI : ShaderGUI
{
    private const string LitShaderName =
        "AtlasShaders/Decals/DecalLit";

    private const string UnlitLogoPath =
        "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/DecalUnlit.psd";

    private const string LitLogoPath =
        "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/DecalLit.psd";

    MaterialEditor m_MaterialEditor;

    GUIStyle headerStyle;
    GUIStyle titleStyle;

    Texture2D logoTexture;
    string loadedLogoPath;

    static readonly Color TopAccent =
        new Color(0.88f, 0.88f, 0.88f);

    static readonly Color NestedAccent =
        new Color(0.6f, 0.6f, 0.6f);

    MaterialProperty P(
        MaterialProperty[] props,
        string name)
    {
        try
        {
            return FindProperty(name, props, false);
        }
        catch
        {
            return null;
        }
    }

    bool IsOn(MaterialProperty p)
    {
        return p != null &&
               p.floatValue > 0.5f;
    }

    bool IsLit(MaterialEditor materialEditor)
    {
        Material material =
            materialEditor.target as Material;

        return material != null &&
               material.shader != null &&
               material.shader.name == LitShaderName;
    }

    Texture2D MakeTexture(Color c)
    {
        Texture2D t =
            new Texture2D(2, 2);

        t.SetPixels(
            new[]
            {
                c,
                c,
                c,
                c
            });

        t.Apply();

        return t;
    }

    void DrawLogo(bool isLit)
    {
        string logoPath =
            isLit
                ? LitLogoPath
                : UnlitLogoPath;

        if (logoTexture == null ||
            loadedLogoPath != logoPath)
        {
            loadedLogoPath = logoPath;

            logoTexture =
                AssetDatabase.LoadAssetAtPath<Texture2D>(
                    logoPath);
        }

        if (logoTexture == null)
            return;

        float maxHeight = 64f;

        float aspect =
            (float)logoTexture.width /
            logoTexture.height;

        GUILayout.BeginHorizontal();

        GUILayout.FlexibleSpace();

        GUILayout.Label(
            logoTexture,
            GUILayout.Width(maxHeight * aspect),
            GUILayout.Height(maxHeight));

        GUILayout.FlexibleSpace();

        GUILayout.EndHorizontal();
    }

    void DrawBox(
        string title,
        Color accent,
        System.Action draw)
    {
        GUIStyle s =
            new GUIStyle(GUI.skin.box);

        s.padding =
            new RectOffset(8, 6, 2, 4);

        s.margin =
            new RectOffset(0, 0, 3, 3);

        Color bg =
            Color.Lerp(
                new Color(.1f, .1f, .1f),
                accent,
                .05f);

        bg.a = .9f;

        s.normal.background =
            MakeTexture(bg);

        if (headerStyle == null)
        {
            headerStyle =
                new GUIStyle(
                    EditorStyles.boldLabel);

            headerStyle.alignment =
                TextAnchor.MiddleCenter;

            headerStyle.fontSize = 11;

            headerStyle.fontStyle =
                FontStyle.Bold;
        }

        headerStyle.normal.textColor =
            accent;

        GUILayout.BeginVertical(s);

        GUILayout.Label(
            title,
            headerStyle);

        draw?.Invoke();

        GUILayout.EndVertical();

        Rect r =
            GUILayoutUtility.GetLastRect();

        EditorGUI.DrawRect(
            new Rect(
                r.x,
                r.y,
                3,
                r.height),
            accent);
    }

    void Prop(
        MaterialProperty p,
        string name = null)
    {
        if (p != null)
        {
            m_MaterialEditor.ShaderProperty(
                p,
                name ?? p.displayName);
        }
    }

    void Tex(
        MaterialProperty p)
    {
        if (p != null)
        {
            m_MaterialEditor.TextureProperty(
                p,
                p.displayName);
        }
    }

    void ColorProp(
        MaterialProperty p,
        string name = null)
    {
        if (p != null)
        {
            m_MaterialEditor.ColorProperty(
                p,
                name ?? p.displayName);
        }
    }

    void Toggle(
        MaterialProperty p,
        string name = null)
    {
        if (p == null)
            return;

        Rect r =
            EditorGUILayout.GetControlRect();

        EditorGUI.showMixedValue =
            p.hasMixedValue;

        EditorGUI.BeginChangeCheck();

        EditorGUI.LabelField(
            r,
            name ?? p.displayName);

        Rect toggleRect =
            new Rect(
                r.x + r.width * .5f - 8,
                r.y,
                16,
                r.height);

        bool value =
            EditorGUI.Toggle(
                toggleRect,
                p.floatValue > .5f);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor
                .RegisterPropertyChangeUndo(
                    p.displayName);

            p.floatValue =
                value ? 1 : 0;
        }

        EditorGUI.showMixedValue = false;
    }

    void RangeProp(
        MaterialProperty p,
        string name = null)
    {
        if (p == null)
            return;

        EditorGUI.showMixedValue =
            p.hasMixedValue;

        EditorGUI.BeginChangeCheck();

        float value =
            EditorGUILayout.Slider(
                name ?? p.displayName,
                p.floatValue,
                p.rangeLimits.x,
                p.rangeLimits.y);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor
                .RegisterPropertyChangeUndo(
                    p.displayName);

            p.floatValue = value;
        }

        EditorGUI.showMixedValue = false;
    }

    void Title(string text)
    {
        if (titleStyle == null)
        {
            titleStyle =
                new GUIStyle(
                    EditorStyles.boldLabel);

            titleStyle.alignment =
                TextAnchor.MiddleCenter;

            titleStyle.fontSize = 20;

            titleStyle.fontStyle =
                FontStyle.Bold;
        }

        GUILayout.BeginHorizontal();

        GUILayout.FlexibleSpace();

        Color orange =
            new Color(
                1f,
                0.35f,
                0f);

        Color yellow =
            new Color(
                1f,
                0.9f,
                0.1f);

        for (int i = 0;
             i < text.Length;
             i++)
        {
            float t =
                (float)i /
                Mathf.Max(
                    1,
                    text.Length - 1);

            titleStyle.normal.textColor =
                Color.Lerp(
                    orange,
                    yellow,
                    t);

            GUILayout.Label(
                text[i].ToString(),
                titleStyle);
        }

        GUILayout.FlexibleSpace();

        GUILayout.EndHorizontal();
    }

    public override void OnGUI(
        MaterialEditor materialEditor,
        MaterialProperty[] props)
    {
        m_MaterialEditor =
            materialEditor;

        bool isLit =
            IsLit(materialEditor);

        GUILayout.Space(4);

        DrawLogo(isLit);

        GUILayout.Space(2);

        Title(
            isLit
                ? "Decal Lit"
                : "Decal Unlit");

        GUILayout.Space(4);

        var alphaClip =
            P(props, "_AlphaClip");

        var color =
            P(props, "_Color");

        var texture =
            P(props, "_Texture");

        DrawBox(
            "Base Attributes",
            TopAccent,
            () =>
            {
                RangeProp(
                    alphaClip,
                    "Alpha Clip");

                ColorProp(
                    color,
                    "Color");

                Tex(texture);
            });

        if (isLit)
        {
            DrawBox(
                "Surface Settings",
                TopAccent,
                () =>
                {
                    Tex(
                        P(
                            props,
                            "_Normal"));

                    Prop(
                        P(
                            props,
                            "_NormalStrength"),
                        "Normal Strength");

                    Tex(
                        P(
                            props,
                            "_MetallicSmoothness"));

                    Prop(
                        P(
                            props,
                            "_Metallic"),
                        "Metallic");

                    Prop(
                        P(
                            props,
                            "_Smoothness"),
                        "Smoothness");
                });
        }

        DrawBox(
            "Parallax Settings",
            TopAccent,
            () =>
            {
                Tex(
                    P(
                        props,
                        "_HeightTexture"));

                Prop(
                    P(
                        props,
                        "_ParallaxDepth"),
                    "Parallax Depth");

                Prop(
                    P(
                        props,
                        "_ParallaxHeightOffset"),
                    "Parallax Height Offset");
            });

        DrawBox(
            "Emission Settings",
            TopAccent,
            () =>
            {
                Tex(
                    P(
                        props,
                        "_EmissionTexture"));

                ColorProp(
                    P(
                        props,
                        "_EmissionColor"),
                    "Emission Color");

                RangeProp(
                    P(
                        props,
                        "_EmissionFading"),
                    "Emission Fading");
            });

        DrawBox(
            "Alpha Settings",
            TopAccent,
            () =>
            {
                RangeProp(
                    P(
                        props,
                        "_Fade"),
                    "Alpha Fading");

                RangeProp(
                    P(
                        props,
                        "_AlphaFalloff"),
                    "Alpha Falloff");
            });

        DrawBox(
            "Circle Mask",
            TopAccent,
            () =>
            {
                RangeProp(
                    P(
                        props,
                        "_CircleMaskSize"),
                    "Circle Mask Size");

                RangeProp(
                    P(
                        props,
                        "_CircleMaskFalloff"),
                    "Circle Mask Falloff");

                Toggle(
                    P(
                        props,
                        "_CircleMaskDebugView"),
                    "Circle Mask Debug View");
            });

        if (isLit)
        {
            var ssrOff =
                P(
                    props,
                    "_SSROff");

            DrawBox(
                "Screen Space Reflections",
                TopAccent,
                () =>
                {
                    Toggle(
                        ssrOff,
                        "Disable SSR");

                    if (!IsOn(ssrOff))
                    {
                        RangeProp(
                            P(
                                props,
                                "_SSRTemporalMul"),
                            "Temporal Accumulation Factor");
                    }
                });
        }

        if (GUI.changed)
        {
            MaterialEditor
                .ApplyMaterialPropertyDrawers(
                    materialEditor.targets);
        }
    }
}