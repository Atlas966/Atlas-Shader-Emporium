using UnityEditor;
using UnityEngine;

public class LitEpidermisGUI : ShaderGUI
{
    private const string LogoPath =
        "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/Lit Epidermis.psd";

    MaterialEditor m_MaterialEditor;

    GUIStyle headerStyle;
    GUIStyle titleStyle;

    Texture2D logoTexture;
    bool triedLoadingLogo;

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
        return p != null && p.floatValue > 0.5f;
    }

    Texture2D MakeTexture(Color c)
    {
        Texture2D texture = new Texture2D(2, 2);

        texture.SetPixels(new[]
        {
            c,
            c,
            c,
            c
        });

        texture.Apply();

        return texture;
    }

    void DrawLogo()
    {
        if (!triedLoadingLogo)
        {
            triedLoadingLogo = true;

            logoTexture =
                AssetDatabase.LoadAssetAtPath<Texture2D>(
                    LogoPath);
        }

        if (logoTexture == null)
        {
            return;
        }

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
        GUIStyle style =
            new GUIStyle(GUI.skin.box);

        style.padding =
            new RectOffset(8, 6, 2, 4);

        style.margin =
            new RectOffset(0, 0, 3, 3);

        Color background =
            Color.Lerp(
                new Color(0.1f, 0.1f, 0.1f),
                accent,
                0.05f);

        background.a = 0.9f;

        style.normal.background =
            MakeTexture(background);

        if (headerStyle == null)
        {
            headerStyle =
                new GUIStyle(EditorStyles.boldLabel);

            headerStyle.alignment =
                TextAnchor.MiddleCenter;

            headerStyle.fontSize = 11;

            headerStyle.fontStyle =
                FontStyle.Bold;
        }

        headerStyle.normal.textColor = accent;

        GUILayout.BeginVertical(style);

        GUILayout.Label(title, headerStyle);

        draw?.Invoke();

        GUILayout.EndVertical();

        Rect rect =
            GUILayoutUtility.GetLastRect();

        EditorGUI.DrawRect(
            new Rect(
                rect.x,
                rect.y,
                3,
                rect.height),
            accent);
    }

    void Prop(
        MaterialProperty property,
        string name = null)
    {
        if (property != null)
        {
            m_MaterialEditor.ShaderProperty(
                property,
                name ?? property.displayName);
        }
    }

    void Tex(MaterialProperty property)
    {
        if (property != null)
        {
            m_MaterialEditor.TextureProperty(
                property,
                property.displayName);
        }
    }

    void ColorProp(
        MaterialProperty property,
        string name = null)
    {
        if (property != null)
        {
            m_MaterialEditor.ColorProperty(
                property,
                name ?? property.displayName);
        }
    }

    void Toggle(
        MaterialProperty property,
        string name = null)
    {
        if (property == null)
        {
            return;
        }

        Rect rect =
            EditorGUILayout.GetControlRect();

        EditorGUI.showMixedValue =
            property.hasMixedValue;

        EditorGUI.BeginChangeCheck();

        EditorGUI.LabelField(
            rect,
            name ?? property.displayName);

        Rect toggleRect =
            new Rect(
                rect.x + rect.width * 0.5f - 8,
                rect.y,
                16,
                rect.height);

        bool value =
            EditorGUI.Toggle(
                toggleRect,
                property.floatValue > 0.5f);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor
                .RegisterPropertyChangeUndo(
                    property.displayName);

            property.floatValue =
                value ? 1f : 0f;
        }

        EditorGUI.showMixedValue = false;
    }

    void RangeProp(
        MaterialProperty property,
        string name = null)
    {
        if (property == null)
        {
            return;
        }

        EditorGUI.showMixedValue =
            property.hasMixedValue;

        EditorGUI.BeginChangeCheck();

        float value =
            EditorGUILayout.Slider(
                name ?? property.displayName,
                property.floatValue,
                property.rangeLimits.x,
                property.rangeLimits.y);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor
                .RegisterPropertyChangeUndo(
                    property.displayName);

            property.floatValue = value;
        }

        EditorGUI.showMixedValue = false;
    }

    void CullProp(
        MaterialProperty property,
        string name = "Render Face")
    {
        if (property == null)
        {
            return;
        }

        EditorGUI.showMixedValue =
            property.hasMixedValue;

        EditorGUI.BeginChangeCheck();

        int mode =
            Mathf.RoundToInt(
                property.floatValue);

        string[] options =
        {
            "Both",
            "Front",
            "Back"
        };

        int selected;

        switch (mode)
        {
            case 0:
                selected = 0;
                break;

            case 1:
                selected = 2;
                break;

            default:
                selected = 1;
                break;
        }

        selected =
            EditorGUILayout.Popup(
                name,
                selected,
                options);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor
                .RegisterPropertyChangeUndo(name);

            switch (selected)
            {
                case 0:
                    property.floatValue = 0;
                    break;

                case 1:
                    property.floatValue = 2;
                    break;

                case 2:
                    property.floatValue = 1;
                    break;
            }
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

        Color start =
            new Color(
                0.72f,
                0.18f,
                0.18f);

        Color end =
            new Color(
                1.00f,
                0.90f,
                0.78f);

        const float fadeToWhite = 0.20f;

        for (int i = 0; i < text.Length; i++)
        {
            float t =
                (float)i /
                Mathf.Max(
                    1,
                    text.Length - 1);

            Color color =
                Color.Lerp(
                    start,
                    end,
                    t);

            color =
                Color.Lerp(
                    color,
                    Color.white,
                    fadeToWhite);

            titleStyle.normal.textColor =
                color;

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

        GUILayout.Space(4);

        DrawLogo();

        GUILayout.Space(2);

        Title("Lit Epidermis");

        GUILayout.Space(4);

        DrawBox(
            "Main",
            TopAccent,
            () =>
            {
                CullProp(
                    P(props, "_Cull"));

                ColorProp(
                    P(props, "_Color"));

                Tex(
                    P(props, "_Albedo"));
            });

        DrawBox(
            "Normal",
            TopAccent,
            () =>
            {
                Tex(
                    P(props, "_Normal"));

                Prop(
                    P(props, "_NormalStrength"));
            });

        MaterialProperty useOcclusionFromTexture =
            P(
                props,
                "_UseOcclusionFromTexture");

        DrawBox(
            "Metallic",
            TopAccent,
            () =>
            {
                Prop(
                    P(props, "_MetallicType"));

                Tex(
                    P(
                        props,
                        "_MetallicSmoothness"));

                RangeProp(
                    P(props, "_Metallic"));

                RangeProp(
                    P(props, "_Smoothness"));

                Toggle(
                    useOcclusionFromTexture);

                if (IsOn(
                    useOcclusionFromTexture))
                {
                    DrawBox(
                        "Ambient Occlusion",
                        NestedAccent,
                        () =>
                        {
                            Tex(
                                P(
                                    props,
                                    "_AmbientOcclusion"));

                            RangeProp(
                                P(
                                    props,
                                    "_AmbientOcclusionAmount"));
                        });
                }
            });

        DrawBox(
            "Emission",
            TopAccent,
            () =>
            {
                Tex(
                    P(props, "_EmissionMap"));

                ColorProp(
                    P(props, "_EmissionColor"));

                RangeProp(
                    P(props, "_EmissionFalloff"));

                Toggle(
                    P(props, "_EmitAlbedo"));
            });

        DrawBox(
            "SSS Settings",
            TopAccent,
            () =>
            {
                Tex(
                    P(
                        props,
                        "_ThicknessROcclusionGSSSMaskAOptional"));

                ColorProp(
                    P(
                        props,
                        "_ScatteringColor"));

                RangeProp(
                    P(
                        props,
                        "_TransluencyStrength"));

                RangeProp(
                    P(
                        props,
                        "_NormalDistortion"));

                RangeProp(
                    P(
                        props,
                        "_ScatteringAmount"));

                RangeProp(
                    P(props, "_Direct"));

                RangeProp(
                    P(props, "_Ambient"));
            });

        if (GUI.changed)
        {
            MaterialEditor
                .ApplyMaterialPropertyDrawers(
                    materialEditor.targets);
        }
    }
}