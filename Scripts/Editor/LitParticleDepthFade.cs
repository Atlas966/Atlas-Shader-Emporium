using UnityEditor;
using UnityEngine;

public class LitParticleDepthFadeGUI : ShaderGUI
{
    private const string LogoPath = "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/LitParticleDepthFade.psd";
    MaterialEditor m_MaterialEditor;

    GUIStyle headerStyle;
    GUIStyle titleStyle;

    Texture2D logoTexture;
    bool triedLoadingLogo;

    static readonly Color TopAccent = new Color(0.88f, 0.88f, 0.88f);
    static readonly Color NestedAccent = new Color(0.6f, 0.6f, 0.6f);

    const float RainbowFadeAmount = 0.0f;

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
            GUILayout.Height(maxHeight)
        );

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
            r.height
        );

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
            p.rangeLimits.y
        );

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(p.displayName);
            p.floatValue = value;
        }

        EditorGUI.showMixedValue = false;
    }

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

        selected = EditorGUILayout.Popup(name, selected, options);

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(name);

            switch (selected)
            {
                case 0:
                    p.floatValue = 0;
                    break;

                case 1:
                    p.floatValue = 2;
                    break;

                case 2:
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

        for (int i = 0; i < text.Length; i++)
        {
            float t = (float)i / Mathf.Max(1, text.Length - 1);

            Color gradient = Color.Lerp(
                Color.white,
                new Color(0.65f, 0.85f, 1.0f),
                t
            );

            titleStyle.normal.textColor = gradient;

            GUILayout.Label(
                text[i].ToString(),
                titleStyle
            );
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
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

        Title("Lit Particle Depth Fade");

        GUILayout.Space(4);


        var particleTexture = P(props, "_ParticleTexture");
        var normalMap = P(props, "_NormalMap");
        var normalIntensity = P(props, "_NormalIntensity");
        var color = P(props, "_Color");
        var transparency = P(props, "_Transparency");
        var alphaClip = P(props, "_AlphaClip");
        var edgeFalloff = P(props, "_EdgeFalloff");
        var cull = P(props, "_Cull");


        DrawBox("Base Attributes", TopAccent, () =>
        {
            CullProp(cull);
            Tex(particleTexture);
            Tex(normalMap);
            RangeProp(normalIntensity, "Normal Intensity");
            ColorProp(color, "Color");
            RangeProp(transparency, "Transparency");
            RangeProp(alphaClip, "Alpha Clip");
            RangeProp(edgeFalloff, "Edge Falloff");
        });


        var blueNoiseOverlay = P(props, "_BlueNoiseOverlay");
        var blueNoise = P(props, "_BlueNoise");
        var blueNoiseSize = P(props, "_BlueNoiseSize");


        DrawBox("Blue Noise", TopAccent, () =>
        {
            Toggle(
                blueNoiseOverlay,
                "Enable Blue Noise Overlay"
            );

            if (IsOn(blueNoiseOverlay))
            {
                RangeProp(blueNoise, "Blue Noise");
                RangeProp(blueNoiseSize, "Blue Noise Size");
            }
        });


        var softIntersection = P(props, "_EnableSoftIntersection");
        var softIntersectionAmount = P(props, "_SoftIntersection");
        var depthFadeBlueNoise = P(props, "_DepthFadeBlueNoise");
        var depthFadeBlueNoiseSize = P(props, "_DepthFadeBlueNoiseSize");


        DrawBox("Soft Intersection", TopAccent, () =>
        {
            Toggle(
                softIntersection,
                "Enable Soft Intersection"
            );

            if (IsOn(softIntersection))
            {
                RangeProp(
                    softIntersectionAmount,
                    "Soft Intersection"
                );

                RangeProp(
                    depthFadeBlueNoise,
                    "Depth Fade Blue Noise"
                );

                RangeProp(
                    depthFadeBlueNoiseSize,
                    "Blue Noise Size"
                );
            }
        });

        var cameraDepthFading = P(props, "_EnableCameraDepthFading");
        var cameraFalloff = P(props, "_CDFalloff1");
        var cameraDistance = P(props, "_CDDistance1");


        DrawBox("Camera Depth Fading", TopAccent, () =>
        {
            Toggle(
                cameraDepthFading,
                "Enable Camera Depth Fading"
            );

            if (IsOn(cameraDepthFading))
            {
                RangeProp(
                    cameraFalloff,
                    "Falloff"
                );

                RangeProp(
                    cameraDistance,
                    "Distance"
                );
            }
        });


        var questDepthFade = P(props, "_QuestDepthFade");
        var questDepthFadeBlueNoiseSize = P(props, "_QuestDepthFadeBlueNoiseSize");
        var pcDebug = P(props, "_PCDebug");


        DrawBox("Quest Depth Fade", TopAccent, () =>
        {
            RangeProp(
                questDepthFade,
                "Quest Depth Fade"
            );

            RangeProp(
                questDepthFadeBlueNoiseSize,
                "Blue Noise Size"
            );

            Toggle(
                pcDebug,
                "PC Debug"
            );
        });


        var brdfMapToggle = P(props, "BRDFMAP");
        var brdfMap = P(props, "g_tBRDFMap");


        DrawBox("BRDF Lut", TopAccent, () =>
        {
            Toggle(
                brdfMapToggle,
                "Enable BRDF Map"
            );

            if (IsOn(brdfMapToggle))
            {
                Tex(brdfMap);
            }
        });


        if (GUI.changed)
        {
            MaterialEditor.ApplyMaterialPropertyDrawers(materialEditor.targets);
        }
    }
}