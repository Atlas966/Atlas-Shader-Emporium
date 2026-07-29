using UnityEditor;
using UnityEngine;

public class FakePointLightGUI : ShaderGUI
{
    // Replace with your icon path if needed.
    private const string LogoPath = "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/FakePointLight.psd";

    MaterialEditor m_MaterialEditor;

    GUIStyle headerStyle;
    GUIStyle titleStyle;

    Texture2D logoTexture;
    bool triedLoadingLogo;

    static readonly Color TopAccent = new Color(0.88f, 0.88f, 0.88f);
    static readonly Color NestedAccent = new Color(0.6f, 0.6f, 0.6f);

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

        GUILayout.Label(
            logoTexture,
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

    void RangeProp(MaterialProperty p, string name = null)
    {
        if (p == null)
            return;

        EditorGUI.showMixedValue = p.hasMixedValue;
        EditorGUI.BeginChangeCheck();

        float value = EditorGUILayout.Slider(
            name ?? p.displayName,
            p.floatValue,
            p.rangeLimits.x,
            p.rangeLimits.y);

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

        for (int i = 0; i < text.Length; i++)
        {
            float hue = (float)i / Mathf.Max(1, text.Length - 1);

            // More colorful rainbow
            Color rainbow = Color.HSVToRGB(hue, 0.75f, 1f);

            // Keep it bright without washing it out
            rainbow = Color.Lerp(Color.white, rainbow, 0.70f);

            titleStyle.normal.textColor = rainbow;

            GUILayout.Label(text[i].ToString(), titleStyle);
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
    }

    public override void OnGUI(
        MaterialEditor materialEditor,
        MaterialProperty[] props)
    {
        m_MaterialEditor = materialEditor;

        GUILayout.Space(4);

        DrawLogo();

        GUILayout.Space(2);

        Title("Fake Point Light");

        GUILayout.Space(4);

        var color = P(props, "_Color");
        var intensity = P(props, "_BlobIntensity");
        var radius = P(props, "_BlobRadius");

        var multiplyWithWorld = P(props, "_MultiplyWithWorld");
        var intensityBoost = P(props, "_IntensityBoost");

        var enableBlueNoise = P(props, "_EnableBlueNoise");
        var blueNoise = P(props, "_BlueNoise");
        var blueNoiseSize = P(props, "_BlueNoiseSize");

        DrawBox("Base Attributes", TopAccent, () =>
        {
            ColorProp(color, "Color");
            RangeProp(intensity, "Blob Intensity");
            Prop(radius, "Blob Radius");
        });

        DrawBox("Light Settings", TopAccent, () =>
        {
            Toggle(multiplyWithWorld, "Multiply With World");
            Prop(intensityBoost, "Intensity Boost");
        });

        DrawBox("Blue Noise", TopAccent, () =>
        {
            Toggle(enableBlueNoise, "Enable Blue Noise");

            if (IsOn(enableBlueNoise))
            {
                RangeProp(blueNoise, "Blue Noise");
                RangeProp(blueNoiseSize, "Blue Noise Size");
            }
        });

        GUILayout.Space(4);

        if (GUI.changed)
        {
            // Required because Toggle() is drawn manually rather than
            // through MaterialEditor.ShaderProperty().
            MaterialEditor.ApplyMaterialPropertyDrawers(
                materialEditor.targets);
        }
    }
}