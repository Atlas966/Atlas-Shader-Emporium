using UnityEditor;
using UnityEngine;

public class ReticlePlusPlusGUI : ShaderGUI
{
    MaterialEditor m_MaterialEditor;
    GUIStyle headerStyle;
    GUIStyle titleStyle;

    static readonly Color TopAccent = new Color(0.88f, 0.88f, 0.88f);
    static readonly Color NestedAccent = new Color(0.6f, 0.6f, 0.6f);

    MaterialProperty P(MaterialProperty[] props, string name)
    {
        try { return FindProperty(name, props, false); }
        catch { return null; }
    }

    bool IsOn(MaterialProperty p) => p != null && p.floatValue > 0.5f;

    Texture2D MakeTexture(Color c)
    {
        Texture2D t = new Texture2D(2, 2);
        t.SetPixels(new[] { c, c, c, c });
        t.Apply();
        return t;
    }

    void DrawBox(string title, Color accent, System.Action draw)
    {
        GUIStyle s = new GUIStyle(GUI.skin.box);
        s.padding = new RectOffset(8, 6, 2, 4);
        Color bg = Color.Lerp(new Color(.1f, .1f, .1f), accent, .05f);
        bg.a = .9f;
        s.normal.background = MakeTexture(bg);

        if (headerStyle == null)
        {
            headerStyle = new GUIStyle(EditorStyles.boldLabel);
            headerStyle.alignment = TextAnchor.MiddleCenter;
            headerStyle.fontSize = 11;
        }
        headerStyle.normal.textColor = accent;

        EditorGUILayout.BeginVertical(s);
        GUILayout.Label(title, headerStyle);
        draw?.Invoke();
        EditorGUILayout.EndVertical();

        Rect r = GUILayoutUtility.GetLastRect();
        EditorGUI.DrawRect(new Rect(r.x, r.y, 3, r.height), accent);
    }

    void Prop(MaterialProperty p, string name = null)
    {
        if (p != null) m_MaterialEditor.ShaderProperty(p, name ?? p.displayName);
    }

    void Tex(MaterialProperty p)
    {
        if (p != null) m_MaterialEditor.TextureProperty(p, p.displayName);
    }

    void ColorProp(MaterialProperty p, string name = null)
    {
        if (p != null) m_MaterialEditor.ColorProperty(p, name ?? p.displayName);
    }

    void Toggle(MaterialProperty p, string name = null)
    {
        if (p == null) return;
        Rect r = EditorGUILayout.GetControlRect();
        EditorGUI.LabelField(r, name ?? p.displayName);
        Rect tr = new Rect(r.x + r.width * .5f - 8, r.y, 16, r.height);
        bool v = EditorGUI.Toggle(tr, p.floatValue > 0.5f);
        if (v != (p.floatValue > 0.5f))
            p.floatValue = v ? 1 : 0;
    }

    void Title(string text)
    {
        if (titleStyle == null)
        {
            titleStyle = new GUIStyle(EditorStyles.boldLabel);
            titleStyle.alignment = TextAnchor.MiddleCenter;
            titleStyle.fontSize = 20;
        }

        EditorGUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        for (int i = 0; i < text.Length; i++)
        {
            float t = (float)i / (text.Length - 1);
            titleStyle.normal.textColor = Color.Lerp(
                new Color(1f, 0.02f, 0.02f),
                new Color(1f, 0.45f, 0.02f),
                t);
            GUILayout.Label(text[i].ToString(), titleStyle);
        }

        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        m_MaterialEditor = materialEditor;

        GUILayout.Space(4);
        Title("Reticle++");
        GUILayout.Space(4);

        var texture = P(props, "_Reticle");
        var nonAdd = P(props, "_IsTextureNonAdditiveHasAlpha");
        var color = P(props, "_Color");
        var tintColor = P(props, "_TintColor");
        var contrast = P(props, "_ReticleContrast");
        var saturation = P(props, "_ReticleSaturation");

        DrawBox("Reticle", TopAccent, () => {
            Tex(texture);
            Toggle(nonAdd);
            ColorProp(color);
            ColorProp(tintColor, "Tint Color");
            Prop(contrast);
            Prop(saturation);
        });

        DrawBox("Reticle Settings", TopAccent, () => {
            Prop(P(props, "_ReticleDepth"));
            Prop(P(props, "_ReticleScale"));
        });

        DrawBox("Rotation", TopAccent, () => {
            Prop(P(props, "_RotationAmount"));
            Prop(P(props, "_RotationSpeed"));
        });

        var chrom = P(props, "_UseChromaticAberration");
        DrawBox("Chromatic Aberration", TopAccent, () => {
            Toggle(chrom);
            if (IsOn(chrom))
                Prop(P(props, "_RGBOffset"));
        });

        var blue = P(props, "_UseBlueNoiseDiffusion");
        DrawBox("Blue Noise Diffusion", TopAccent, () => {
            Toggle(blue);
            if (IsOn(blue))
            {
                Prop(P(props, "_BlueNoise"));
                Prop(P(props, "_BlueNoiseSize"));
            }
        });

        DrawBox("Offset", TopAccent, () => {
            Prop(P(props, "_Offset"));
        });

        if (GUI.changed)
            MaterialEditor.ApplyMaterialPropertyDrawers(materialEditor.targets);
    }
}
