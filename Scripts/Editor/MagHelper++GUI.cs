using UnityEditor;
using UnityEngine;

public class MagHelperGUI : ShaderGUI
{
    private const string LogoPath = "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/MagHelper++.psd";

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

        Color bg = Color.Lerp(
            new Color(0.1f, 0.1f, 0.1f),
            accent,
            0.05f
        );

        bg.a = 0.9f;

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

        EditorGUI.DrawRect(
            new Rect(r.x, r.y, 3, r.height),
            accent
        );
    }

    void Prop(MaterialProperty p, string name = null)
    {
        if (p != null)
        {
            m_MaterialEditor.ShaderProperty(
                p,
                name ?? p.displayName
            );
        }
    }

    void ColorProp(MaterialProperty p, string name = null)
    {
        if (p != null)
        {
            m_MaterialEditor.ColorProperty(
                p,
                name ?? p.displayName
            );
        }
    }

    void Toggle(MaterialProperty p, string name = null)
    {
        if (p == null)
            return;

        Rect r = EditorGUILayout.GetControlRect();

        EditorGUI.showMixedValue = p.hasMixedValue;
        EditorGUI.BeginChangeCheck();

        EditorGUI.LabelField(
            r,
            name ?? p.displayName
        );

        Rect toggleRect = new Rect(
            r.x + r.width * 0.5f - 8,
            r.y,
            16,
            r.height
        );

        bool value = EditorGUI.Toggle(
            toggleRect,
            p.floatValue > 0.5f
        );

        if (EditorGUI.EndChangeCheck())
        {
            m_MaterialEditor.RegisterPropertyChangeUndo(
                p.displayName
            );

            p.floatValue = value ? 1f : 0f;
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
            m_MaterialEditor.RegisterPropertyChangeUndo(
                p.displayName
            );

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

        Color[] titleGradient =
        {
            new Color(1.00f, 0.00f, 0.55f),
            new Color(1.00f, 0.05f, 0.75f),
            new Color(0.95f, 0.10f, 0.95f),
            new Color(0.65f, 0.20f, 1.00f),
            new Color(0.30f, 0.40f, 1.00f),
            new Color(0.00f, 0.65f, 1.00f)
        };

        for (int i = 0; i < text.Length; i++)
        {
            float t = (float)i / Mathf.Max(
                1,
                text.Length - 1
            );

            float scaled = t * (titleGradient.Length - 1);

            int a = Mathf.FloorToInt(scaled);
            int b = Mathf.Min(
                a + 1,
                titleGradient.Length - 1
            );

            Color pure = Color.Lerp(
                titleGradient[a],
                titleGradient[b],
                scaled - a
            );

            titleStyle.normal.textColor = Color.Lerp(
                pure,
                Color.white,
                RainbowFadeAmount
            );

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
        MaterialProperty[] props)
    {
        m_MaterialEditor = materialEditor;

        GUILayout.Space(4);

        DrawLogo();

        GUILayout.Space(2);

        Title("Mag Helper++");

        GUILayout.Space(4);

        var gradient = P(props, "_EnableGradient");

        DrawBox("Main", TopAccent, () =>
        {
            ColorProp(P(props, "_Color"));

            Toggle(
                gradient,
                "Enable Gradient"
            );

            if (IsOn(gradient))
            {
                /*
                 * ShaderProperty is used here instead of TextureProperty.
                 * This allows the [Gradient] MaterialPropertyDrawer from
                 * GradientDrawer.cs to draw its original custom inspector.
                 */
                Prop(
                    P(props, "_Gradient"),
                    "Gradient"
                );

                Prop(P(props, "_ColorFalloff"));
                Prop(P(props, "_Tiling"));
                Prop(P(props, "_Scroll"));
                Prop(P(props, "_Rotation"));
            }
        });

        var blink = P(props, "_BlinkEnabled");

        DrawBox("Animation Options", TopAccent, () =>
        {
            Toggle(
                blink,
                "Blink Enabled"
            );

            if (IsOn(blink))
            {
                Prop(P(props, "_BlinkIntensity"));
                Prop(P(props, "_BlinkFreq"));
                Prop(P(props, "_BlinkExponent"));
            }

            Prop(P(props, "_ScrollSpeed"));
        });

        var blueNoise = P(props, "_EnableBluenoise");
        var dither = P(props, "_EnableDither");
        var depthFade = P(props, "_EnableDepthFading");
        var cameraDepthFade = P(
            props,
            "_EnableCameraDepthFading"
        );

        DrawBox("Visuals", TopAccent, () =>
        {
            Toggle(
                blueNoise,
                "Enable Bluenoise"
            );

            if (IsOn(blueNoise))
            {
                Prop(P(props, "_BlueNoise"));
                Prop(P(props, "_BlueNoiseSize"));
            }

            Toggle(
                dither,
                "Enable Dither"
            );

            if (IsOn(dither))
            {
                Prop(P(props, "_DitherAmount"));
            }

            DrawBox("Depth Fade", NestedAccent, () =>
            {
                Toggle(
                    depthFade,
                    "Enable Depth Fading"
                );

                if (IsOn(depthFade))
                {
                    Prop(P(props, "_DepthFade"));
                    Prop(P(props, "_DepthFadeBlueNoise"));
                    Prop(P(props, "_DepthFadeBlueNoiseSize"));

                    DrawBox(
                        "Camera Depth Fading",
                        NestedAccent,
                        () =>
                        {
                            Toggle(
                                cameraDepthFade,
                                "Enable Camera Depth Fading"
                            );

                            if (IsOn(cameraDepthFade))
                            {
                                Prop(P(props, "_Distance"));
                                Prop(P(props, "_Falloff"));
                            }
                        }
                    );
                }
            });
        });

        DrawBox("Quest Depth Fade", TopAccent, () =>
        {
            RangeProp(
                P(props, "_QuestDepthFade"),
                "Quest Depth Fade"
            );

            Prop(
                P(
                    props,
                    "_QuestDepthFadeBlueNoiseSize"
                )
            );

            Toggle(
                P(props, "_PCDebug"),
                "PC Debug"
            );
        });

        if (GUI.changed)
        {
            MaterialEditor.ApplyMaterialPropertyDrawers(
                materialEditor.targets
            );
        }
    }
}