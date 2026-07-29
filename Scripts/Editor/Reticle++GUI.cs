using UnityEditor;
using UnityEngine;

public class ReticlePlusPlusGUI : ShaderGUI
{
    private const string LogoPath = "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/Reticle++.psd";

    MaterialEditor m_MaterialEditor;

    GUIStyle headerStyle;
    GUIStyle titleStyle;

    Texture2D logoTexture;
    bool triedLoadingLogo;

    static readonly Color TopAccent = new Color(0.88f, 0.88f, 0.88f);
    static readonly Color NestedAccent = new Color(0.6f, 0.6f, 0.6f);


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

        float height = maxHeight;
        float width = height * aspect;


        EditorGUILayout.BeginHorizontal();

        GUILayout.FlexibleSpace();

        GUILayout.Label(
            logoTexture,
            GUILayout.Width(width),
            GUILayout.Height(height)
        );

        GUILayout.FlexibleSpace();

        EditorGUILayout.EndHorizontal();
    }


    void DrawBox(string title, Color accent, System.Action draw)
    {
        GUIStyle s = new GUIStyle(GUI.skin.box);

        s.padding = new RectOffset(8, 6, 2, 4);
        s.margin = new RectOffset(0, 0, 3, 3);


        Color bg = Color.Lerp(
            new Color(.1f, .1f, .1f),
            accent,
            .05f
        );

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


        EditorGUILayout.BeginVertical(s);

        GUILayout.Label(title, headerStyle);

        draw?.Invoke();

        EditorGUILayout.EndVertical();


        Rect r = GUILayoutUtility.GetLastRect();

        EditorGUI.DrawRect(
            new Rect(r.x, r.y, 3, r.height),
            accent
        );
    }


    void Prop(MaterialProperty p, string name = null)
    {
        if (p != null)
            m_MaterialEditor.ShaderProperty(
                p,
                name ?? p.displayName
            );
    }


    void Tex(MaterialProperty p)
    {
        if (p != null)
            m_MaterialEditor.TextureProperty(
                p,
                p.displayName
            );
    }


    void ColorProp(MaterialProperty p, string name = null)
    {
        if (p != null)
            m_MaterialEditor.ColorProperty(
                p,
                name ?? p.displayName
            );
    }


    void Toggle(MaterialProperty p, string name = null)
    {
        if (p == null)
            return;


        Rect r = EditorGUILayout.GetControlRect();

        EditorGUI.LabelField(
            r,
            name ?? p.displayName
        );


        Rect toggleRect = new Rect(
            r.x + r.width * .5f - 8,
            r.y,
            16,
            r.height
        );


        bool value = EditorGUI.Toggle(
            toggleRect,
            p.floatValue > .5f
        );


        if (value != (p.floatValue > .5f))
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(
                p.displayName
            );

            p.floatValue = value ? 1 : 0;
        }
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


        EditorGUILayout.BeginHorizontal();

        GUILayout.FlexibleSpace();


        for (int i = 0; i < text.Length; i++)
        {
            float t = (float)i / (text.Length - 1);


            titleStyle.normal.textColor =
                Color.Lerp(
                    new Color(1f, 0.02f, 0.02f),
                    new Color(1f, 0.45f, 0.02f),
                    t
                );


            GUILayout.Label(
                text[i].ToString(),
                titleStyle
            );
        }


        GUILayout.FlexibleSpace();

        EditorGUILayout.EndHorizontal();
    }


    public override void OnGUI(
        MaterialEditor materialEditor,
        MaterialProperty[] props
    )
    {
        m_MaterialEditor = materialEditor;


        GUILayout.Space(4);

        DrawLogo();

        GUILayout.Space(2);

        Title("Reticle++");

        GUILayout.Space(4);


        var texture = P(props, "_Reticle");
        var nonAdd = P(props, "_IsTextureNonAdditiveHasAlpha");
        var color = P(props, "_Color");
        var tintColor = P(props, "_TintColor");
        var contrast = P(props, "_ReticleContrast");
        var saturation = P(props, "_ReticleSaturation");


        DrawBox("Reticle", TopAccent, () =>
        {
            Tex(texture);
            Toggle(nonAdd);
            ColorProp(color);
            ColorProp(tintColor, "Tint Color");
            Prop(contrast);
            Prop(saturation);
        });


        DrawBox("Reticle Settings", TopAccent, () =>
        {
            Prop(P(props, "_ReticleDepth"));
            Prop(P(props, "_ReticleScale"));
        });


        DrawBox("Rotation", TopAccent, () =>
        {
            Prop(P(props, "_RotationAmount"));
            Prop(P(props, "_RotationSpeed"));
        });


        var chrom = P(props, "_UseChromaticAberration");

        DrawBox("Chromatic Aberration", TopAccent, () =>
        {
            Toggle(chrom);

            if (IsOn(chrom))
                Prop(P(props, "_RGBOffset"));
        });


        var blue = P(props, "_UseBlueNoiseDiffusion");

        DrawBox("Blue Noise Diffusion", TopAccent, () =>
        {
            Toggle(blue);

            if (IsOn(blue))
            {
                Prop(P(props, "_BlueNoise"));
                Prop(P(props, "_BlueNoiseSize"));
            }
        });


        DrawBox("Offset", TopAccent, () =>
        {
            Prop(P(props, "_Offset"));
        });


        if (GUI.changed)
        {
            MaterialEditor.ApplyMaterialPropertyDrawers(
                materialEditor.targets
            );
        }
    }
}