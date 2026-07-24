using UnityEditor;
using UnityEngine;
using System.Collections.Generic;

public class LitMASWaterShaderGUI : ShaderGUI
{
    MaterialEditor m_MaterialEditor;
    private GUIStyle boxStyle;
    private GUIStyle headerStyle;

    // ASE keyword names (exact)
    const string KW_NONE = "_WAVETYPE_NONE";
    const string KW_GERSTNER = "_WAVETYPE_GERSTNERWAVES";
    const string KW_3DTEXTURE = "_WAVETYPE_3DTEXTURE";
    const string KW_BOTH = "_WAVETYPE_GERSTNERAND3DTEXTURE";
    const string KW_NOISE = "_WAVETYPE_NOISE";

    // ---------- standardized ? tooltip helpers ----------

    private static GUIStyle _helpIconStyle;

    private GUIStyle HelpIconStyle
    {
        get
        {
            if (_helpIconStyle == null)
            {
                _helpIconStyle = new GUIStyle(GUI.skin.box)
                {
                    alignment = TextAnchor.MiddleCenter,
                    fontStyle = FontStyle.Bold,
                    fixedWidth = 20,
                    fixedHeight = 20,
                    margin = new RectOffset(2, 6, 0, 0),
                    padding = new RectOffset(0, 0, 0, 0)
                };
                _helpIconStyle.normal.textColor = Color.white;
            }
            return _helpIconStyle;
        }
    }

    private void DrawHelpIcon(string tooltip)
    {
        GUIContent c = new GUIContent("?", tooltip);
        GUILayout.Box(c, HelpIconStyle, GUILayout.Width(20), GUILayout.Height(20));
    }

    private void DrawHelpIcon(Rect position, string tooltip)
    {
        GUIContent c = new GUIContent("?", tooltip);
        GUI.Box(position, c, HelpIconStyle);
    }

    // ---------- helpers ----------

    private void DrawToggleGroup(MaterialProperty toggle, System.Action drawContent)
    {
        if (toggle == null) return;
        m_MaterialEditor.ShaderProperty(toggle, toggle.displayName);
        if (toggle.floatValue == 1 && drawContent != null)
        {
            EditorGUI.indentLevel++;
            drawContent.Invoke();
            EditorGUI.indentLevel--;
        }
    }

    private void DrawEnumGroup(MaterialProperty enumProp, System.Action<int> drawContent)
    {
        if (enumProp == null) return;
        EditorGUI.BeginChangeCheck();
        m_MaterialEditor.ShaderProperty(enumProp, enumProp.displayName);
        int val = (int)enumProp.floatValue;
        if (EditorGUI.EndChangeCheck())
        {
            foreach (Material mat in enumProp.targets)
                mat.SetFloat(enumProp.name, val);
        }
        if (val != 0 && drawContent != null)
        {
            EditorGUI.indentLevel++;
            drawContent.Invoke(val);
            EditorGUI.indentLevel--;
        }
    }

    private void DrawBox(string title, System.Action drawContents)
    {
        if (boxStyle == null)
        {
            boxStyle = new GUIStyle(GUI.skin.box)
            {
                padding = new RectOffset(10, 10, 10, 10),
                margin = new RectOffset(5, 5, 5, 5)
            };
            boxStyle.normal.background = MakeRoundedTexture(2, new Color(0.2f, 0.2f, 0.2f, 0.4f));
        }

        if (headerStyle == null)
        {
            headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontSize = 13
            };
        }

        EditorGUILayout.BeginVertical(boxStyle);
        if (!string.IsNullOrEmpty(title))
        {
            GUILayout.Label(title, headerStyle);
            EditorGUILayout.Space();
        }
        drawContents?.Invoke();
        EditorGUILayout.EndVertical();
        EditorGUILayout.Space();
    }

    private Texture2D MakeRoundedTexture(int radius, Color color)
    {
        int size = radius * 2 + 2;
        Texture2D tex = new Texture2D(size, size);
        Color transparent = new Color(0, 0, 0, 0);

        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                bool inside = (x >= radius && x < size - radius) ||
                              (y >= radius && y < size - radius);
                tex.SetPixel(x, y, inside ? color : transparent);
            }
        }
        tex.Apply();
        return tex;
    }

    private List<Material> GetSelectedMaterials()
    {
        var list = new List<Material>();
        foreach (var o in m_MaterialEditor.targets)
        {
            var mat = o as Material;
            if (mat != null) list.Add(mat);
        }
        return list;
    }

    private int GetWaveTypeFromMaterial(Material m)
    {
        if (m == null) return 0;
        if (m.IsKeywordEnabled(KW_GERSTNER)) return 1;
        if (m.IsKeywordEnabled(KW_3DTEXTURE)) return 2;
        if (m.IsKeywordEnabled(KW_BOTH)) return 3;
        if (m.IsKeywordEnabled(KW_NOISE)) return 4;

        if (m.HasProperty("_WaveType"))
        {
            int v = Mathf.RoundToInt(m.GetFloat("_WaveType"));
            if (v >= 0 && v <= 5) return v;
        }
        return 0;
    }

    private void SetWaveTypeOnMaterial(Material m, int val)
    {
        if (m == null) return;

        m.DisableKeyword(KW_NONE);
        m.DisableKeyword(KW_GERSTNER);
        m.DisableKeyword(KW_3DTEXTURE);
        m.DisableKeyword(KW_BOTH);
        m.DisableKeyword(KW_NOISE);

        switch (val)
        {
            case 0: m.EnableKeyword(KW_NONE); break;
            case 1: m.EnableKeyword(KW_GERSTNER); break;
            case 2: m.EnableKeyword(KW_3DTEXTURE); break;
            case 3: m.EnableKeyword(KW_BOTH); break;
            case 4: m.EnableKeyword(KW_NOISE); break;
            case 5: break; // Dynamic Ripples — no keyword
        }

        if (m.HasProperty("_WaveType"))
            m.SetFloat("_WaveType", val);

        EditorUtility.SetDirty(m);
    }

    private MaterialProperty FindFirstProperty(MaterialProperty[] props, params string[] names)
    {
        foreach (var name in names)
        {
            try
            {
                var p = FindProperty(name, props, false);
                if (p != null) return p;
            }
            catch { }
        }
        return null;
    }

    private float GetFloatMix(List<Material> mats, string propName, out bool mixed, float defaultValue = 0f)
    {
        mixed = false;
        if (mats.Count == 0) return defaultValue;

        float first = mats[0].GetFloat(propName);
        for (int i = 1; i < mats.Count; i++)
        {
            if (!Mathf.Approximately(mats[i].GetFloat(propName), first))
            {
                mixed = true;
                break;
            }
        }
        return first;
    }

    private void SetFloatOnMats(List<Material> mats, string propName, float value)
    {
        foreach (var m in mats)
        {
            if (m == null) continue;
            m.SetFloat(propName, value);
            EditorUtility.SetDirty(m);
        }
    }

    // ---------- main GUI ----------

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        m_MaterialEditor = materialEditor;

        // Title
        EditorGUILayout.Space(10);
        GUIStyle titleStyle = new GUIStyle(EditorStyles.boldLabel)
        {
            fontSize = 22,
            alignment = TextAnchor.MiddleCenter,
            normal = { textColor = new Color(0.25f, 0.6f, 1f) }
        };
        GUILayout.Label("LitMAS Water 3", titleStyle);
        EditorGUILayout.Space(10);

        // Section header style (like title but white)
        GUIStyle sectionHeaderStyle = new GUIStyle(titleStyle)
        {
            fontSize = 18,
            alignment = TextAnchor.MiddleLeft
        };
        sectionHeaderStyle.normal.textColor = Color.white;

        // === PROPERTY FINDS ===
        var _Cull = FindFirstProperty(props, "_Cull");

        var _WaterColor = FindFirstProperty(props, "_WaterColor");
        var _Smoothness = FindFirstProperty(props, "_Smoothness");
        var _Reflectivity = FindFirstProperty(props, "_Reflectivity");
        var _EnableDepthMaskedRefraction = FindFirstProperty(props, "_EnableDepthMaskedRefraction");

        var _EnableSoftIntersection = FindFirstProperty(props, "_EnableSoftIntersection");
        var _SoftIntersectionIntensity = FindFirstProperty(props, "_SoftIntersectionIntensity");

        var _EnableCameraDepthFading = FindFirstProperty(props, "_EnableCameraDepthFading");
        var _CDFalloff = FindFirstProperty(props, "_CDFalloff");
        var _CDDistance = FindFirstProperty(props, "_CDDistance");


        var _SSROff = FindFirstProperty(props, "_SSROff");
        var _BRDFMAP = FindFirstProperty(props, "BRDFMAP");
        var _g_tBRDFMap = FindFirstProperty(props, "g_tBRDFMap");

        var _DistortionType = FindFirstProperty(props, "_DistortionType");
        var _DistortionIntensity = FindFirstProperty(props, "_DistortionIntensity");
        var _RGBOffset = FindFirstProperty(props, "_RGBOffset");

        var _NormalMap = FindFirstProperty(props, "_NormalMap");
        var _EnableAntiTileNormals = FindFirstProperty(props, "_EnableAntiTileNormals");
        var _NormalTiling = FindFirstProperty(props, "_NormalTiling");
        var _NormalIntensity = FindFirstProperty(props, "_NormalIntensity");
        var _WaterSpeedX = FindFirstProperty(props, "_WaterSpeedX");
        var _WaterSpeedY = FindFirstProperty(props, "_WaterSpeedY");

        var _MicroNormals = FindFirstProperty(props, "_MicroNormals");
        var _MicroNormalMap = FindFirstProperty(props, "_MicroNormalMap");
        var _MicroNormalTiling = FindFirstProperty(props, "_MicroNormalTiling");
        var _MicroNormalIntensity = FindFirstProperty(props, "_MicroNormalIntensity");
        var _MicroNormalSpeedX = FindFirstProperty(props, "_MicroNormalSpeedX");
        var _MicroNormalSpeedY = FindFirstProperty(props, "_MicroNormalSpeedY");
        var _MicroNormalsNearFadeDistance = FindFirstProperty(props, "_MicroNormalsNearFadeDistance");
        var _MicroNormalsFarFadeDistance = FindFirstProperty(props, "_MicroNormalsFarFadeDistance");

        var _EnableDistortedUVs = FindFirstProperty(props, "_EnableDistortedUVs");
        var _Distortion = FindFirstProperty(props, "_Distortion");
        var _EnableAntiTileUVDistortion = FindFirstProperty(props, "_EnableAntiTileUVDistortion");
        var _DistortOverlayIntensity = FindFirstProperty(props, "_DistortOverlayIntensity");
        var _DistortedUVInfluence = FindFirstProperty(props, "_DistortedUVInfluence");
        var _DistortionSpeedX = FindFirstProperty(props, "_DistortionSpeedX");
        var _DistortionSpeedY = FindFirstProperty(props, "_DistortionSpeedY");
        var _DistortionTiling = FindFirstProperty(props, "_DistortionTiling");

        var _EnableRainDropRipples = FindFirstProperty(props, "_EnableRainDropRipples");
        var _RainDropRippleTiling = FindFirstProperty(props, "_RainDropRippleTiling");
        var _RainDropRippleIntensity = FindFirstProperty(props, "_RainDropRippleIntensity");
        var _RainDropRippleSpeed = FindFirstProperty(props, "_RainDropRippleSpeed");

        var _WaveType = FindFirstProperty(props, "_WaveType");
        var _NumberOfWaves = FindFirstProperty(props, "_NumberOfWaves");
        var _Steepness = FindFirstProperty(props, "_Steepness");
        var _Wavelength = FindFirstProperty(props, "_Wavelength");
        var _Amplitude = FindFirstProperty(props, "_Amplitude");
        var _Speed = FindFirstProperty(props, "_Speed");
        var _Displacement3DTexture = FindFirstProperty(props, "_Displacement3DTexture");
        var _DisplacementTiling = FindFirstProperty(props, "_DisplacementTiling");
        var _WaveSpeed = FindFirstProperty(props, "_WaveSpeed");
        var _WaveHeight = FindFirstProperty(props, "_WaveHeight");
        var _MixingIntensity = FindFirstProperty(props, "_MixingIntensity");
        var _DynamicRippleWaveHeight = FindFirstProperty(props, "_DynamicRippleWaveHeight");

        var _NoiseWavesSpeed = FindFirstProperty(props, "_NoiseWavesSpeed");
        var _NoiseWavesScale = FindFirstProperty(props, "_NoiseWavesScale");
        var _NoiseWavesSize = FindFirstProperty(props, "_NoiseWavesSize");
        var _NoiseWavesDirection = FindFirstProperty(props, "_NoiseWavesDirection");

        var _EnableFoam = FindFirstProperty(props, "_EnableFoam");
        var _FoamTexture = FindFirstProperty(props, "_FoamTexture");
        var _FoamTiling = FindFirstProperty(props, "_FoamTiling");
        var _EnableAntiTileFoam = FindFirstProperty(props, "_EnableAntiTileFoam");
        var _FoamColor = FindFirstProperty(props, "_FoamColor");
        var _FoamSpeedX = FindFirstProperty(props, "_FoamSpeedX");
        var _FoamSpeedY = FindFirstProperty(props, "_FoamSpeedY");
        var _FoamStrength = FindFirstProperty(props, "_FoamStrength");
        var _FoamAlpha = FindFirstProperty(props, "_FoamAlpha");
        var _DistortedUVInfluence1 = FindFirstProperty(props, "_DistortedUVInfluence1");
        var _EnableFoamParallax = FindFirstProperty(props, "_EnableFoamParallax");
        var _FoamParallaxScale = FindFirstProperty(props, "_FoamParallaxScale");
        var _EnableFoamDistortion = FindFirstProperty(props, "_EnableFoamDistortion");
        var _FoamDistortion = FindFirstProperty(props, "_FoamDistortion");

        var _EnableDynamicRipples = FindFirstProperty(props, "_EnableDynamicRipples");
        var _DynamicRippleIntensity = FindFirstProperty(props, "_DynamicRippleIntensity");
        var _RippleRenderTexture = FindFirstProperty(props, "_RippleRenderTexture");
        var _DebugView1 = FindFirstProperty(props, "_DebugView1");
        var _DebugContrast1 = FindFirstProperty(props, "_DebugContrast1");

        var _EnableFlowmappedUVs = FindFirstProperty(props, "_EnableFlowmappedUVs");
        var _Flowmap = FindFirstProperty(props, "_Flowmap");
        var _FlowmapTiling = FindFirstProperty(props, "_FlowmapTiling");
        var _FlowmapOffset = FindFirstProperty(props, "_FlowmapOffset");
        var _Strength = FindFirstProperty(props, "_Strength");
        var _FlowSpeed = FindFirstProperty(props, "_FlowSpeed");
        var _DebugView = FindFirstProperty(props, "_DebugView");
        var _DebugContrast = FindFirstProperty(props, "_DebugContrast");

        var _EnableDepthColors = FindFirstProperty(props, "_EnableDepthColors");
        var _DepthColorMode = FindFirstProperty(props, "_DepthColorMode");

        var _DepthColor = FindFirstProperty(props, "_DepthColor");
        var _Clarity = FindFirstProperty(props, "_Clarity");
        var _Murkiness = FindFirstProperty(props, "_Murkiness");

        var _ShallowColor = FindFirstProperty(props, "_ShallowColor");
        var _DeepColor = FindFirstProperty(props, "_DeepColor");
        var _WaterDepth = FindFirstProperty(props, "_WaterDepth");
        var _DepthTranslucency = FindFirstProperty(props, "_DepthTranslucency");

        var _EnablePostProcessing = FindFirstProperty(props, "_EnablePostProcessing");

        var _Grayscale = FindFirstProperty(props, "_Grayscale");
        var _Saturation = FindFirstProperty(props, "_Saturation");
        var _SaturationIntensity = FindFirstProperty(props, "_SaturationIntensity");

        var _Contrast = FindFirstProperty(props, "_Contrast");
        var _ContrastIntensity = FindFirstProperty(props, "_ContrastIntensity");

        var _Posterize = FindFirstProperty(props, "_Posterize");
        var _PosterizationIntensity = FindFirstProperty(props, "_PosterizationIntensity");

        var _Midtones = FindFirstProperty(props, "_Midtones");
        var _Red = FindFirstProperty(props, "_Red");
        var _Green = FindFirstProperty(props, "_Green");
        var _Blue = FindFirstProperty(props, "_Blue");

        var _EnableAlphaMasking = FindFirstProperty(props, "_EnableAlphaMasking");
        var _AlphaMask = FindFirstProperty(props, "_AlphaMask");
        var _AlphaFalloff = FindFirstProperty(props, "_AlphaFalloff");

        // ===========================
        // SURFACE SECTION HEADER
        // ===========================
        GUILayout.Label("Surface", sectionHeaderStyle);
        EditorGUILayout.Space(4);
        // -------- Water Attributes --------
        DrawBox("Water Attributes", () =>
        {
            // -----------------------------------------
            // RENDER FACE — uses _Cull float from ASE
            // -----------------------------------------
            {
                var mats = GetSelectedMaterials();

                if (_Cull != null && mats.Count > 0)
                {
                    // Read mixed state
                    float first = _Cull.floatValue;
                    bool mixed = false;

                    for (int i = 1; i < mats.Count; i++)
                    {
                        if (!Mathf.Approximately(first, mats[i].GetFloat("_Cull")))
                        {
                            mixed = true;
                            break;
                        }
                    }

                    // Unity cull enum (we are writing the *enum* value into the float):
                    // Off  = 0  -> BOTH
                    // Front = 1 -> cull front (show back)
                    // Back  = 2 -> cull back  (show front)
                    //
                    // UI order: Front, Back, Both
                    string[] labels = { "Front", "Back", "Both" };

                    // Map current value -> UI index
                    // 2 => Front, 1 => Back, anything else (0) => Both
                    int index;
                    if (Mathf.Approximately(first, 2f)) index = 0; // Front
                    else if (Mathf.Approximately(first, 1f)) index = 1; // Back
                    else index = 2; // Both (0 or anything weird)

                    EditorGUI.showMixedValue = mixed;
                    EditorGUI.BeginChangeCheck();

                    index = EditorGUILayout.Popup("Render Face", index, labels);

                    if (EditorGUI.EndChangeCheck())
                    {
                        // Front  => enum Back (2)  -> show front
                        // Back   => enum Front (1) -> show back
                        // Both   => enum Off (0)   -> both sides
                        int newCullEnum = 0;
                        switch (index)
                        {
                            case 0: newCullEnum = 2; break; // Front
                            case 1: newCullEnum = 1; break; // Back
                            case 2: newCullEnum = 0; break; // Both
                        }

                        // Write back to the ASE float and the materials
                        _Cull.floatValue = newCullEnum;

                        foreach (var m in mats)
                        {
                            if (m == null) continue;
                            m.SetFloat("_Cull", newCullEnum);
                            EditorUtility.SetDirty(m);
                        }
                    }

                    EditorGUI.showMixedValue = false;
                }
            }

            // =======================================================
            // MAIN WATER SETTINGS
            // =======================================================
            if (_WaterColor != null)
                m_MaterialEditor.ColorProperty(_WaterColor, _WaterColor.displayName);

            if (_Smoothness != null)
                m_MaterialEditor.ShaderProperty(_Smoothness, _Smoothness.displayName);

            if (_Reflectivity != null)
                m_MaterialEditor.ShaderProperty(_Reflectivity, _Reflectivity.displayName);


            // --- replace your current "Soft Intersection" block inside Water Attributes with this ---

            // -----------------------------------------
            // SOFT INTERSECTION
            // -----------------------------------------
            EditorGUILayout.LabelField("Soft Intersection", EditorStyles.boldLabel);

            if (_EnableSoftIntersection != null)
            {
                EditorGUILayout.BeginHorizontal();

                GUIStyle iconBox = new GUIStyle(GUI.skin.box)
                {
                    padding = new RectOffset(2, 2, 2, 2),
                    margin = new RectOffset(2, 6, 0, 0)
                };
                iconBox.normal.textColor = Color.white;

                GUIContent warnIcon = EditorGUIUtility.IconContent("console.warnicon.sml");
                warnIcon.tooltip =
                    "Soft intersection allows a soft transition between objects entering water.\n\nUsing this with Waves enabled is not recommended, offsetting where geometry actually enters water and where soft intersection is applied will occur.";

                GUILayout.BeginVertical(iconBox, GUILayout.Width(22), GUILayout.Height(22));
                GUILayout.Label(warnIcon, GUILayout.Width(18), GUILayout.Height(18));
                GUILayout.EndVertical();

                m_MaterialEditor.ShaderProperty(_EnableSoftIntersection, _EnableSoftIntersection.displayName);

                EditorGUILayout.EndHorizontal();
            }

            if (_SoftIntersectionIntensity != null && _EnableSoftIntersection != null && _EnableSoftIntersection.floatValue == 1f)
            {
                EditorGUI.indentLevel++;
                m_MaterialEditor.ShaderProperty(_SoftIntersectionIntensity, _SoftIntersectionIntensity.displayName);
                EditorGUI.indentLevel--;
            }

            // -----------------------------------------
            // CAMERA DEPTH FADING (NEW) — under Soft Intersection Intensity
            // -----------------------------------------
            if (_EnableCameraDepthFading != null && _EnableSoftIntersection != null && _EnableSoftIntersection.floatValue == 1f)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Enables a smoother transition between surface of the water and underwater.");
                m_MaterialEditor.ShaderProperty(_EnableCameraDepthFading, _EnableCameraDepthFading.displayName);

                EditorGUILayout.EndHorizontal();

                if (_EnableCameraDepthFading.floatValue == 1f)
                {
                    EditorGUI.indentLevel++;

                    if (_CDDistance != null)
                        m_MaterialEditor.ShaderProperty(_CDDistance, "Distance");

                    if (_CDFalloff != null)
                        m_MaterialEditor.ShaderProperty(_CDFalloff, "Falloff");

                    EditorGUI.indentLevel--;
                }
            }



            // =======================================================
            // SCREEN SPACE REFLECTIONS — DISABLE SSR WRAPPER
            // =======================================================
            GUILayout.Space(14);
            EditorGUILayout.LabelField("Screen Space Reflections", EditorStyles.boldLabel);

            MaterialProperty ssrRealToggle = _SSROff;
            int ssrUI = ssrRealToggle != null && ssrRealToggle.floatValue > 0.5f ? 1 : 0;

            EditorGUILayout.BeginHorizontal();

            GUIStyle ssrWarnBox = new GUIStyle(GUI.skin.box)
            {
                padding = new RectOffset(2, 2, 2, 2),
                margin = new RectOffset(2, 6, 0, 0)
            };
            ssrWarnBox.normal.textColor = Color.white;

            GUIContent ssrWarnIcon = EditorGUIUtility.IconContent("console.warnicon.sml");
            ssrWarnIcon.tooltip =
                "Disables SSR on water surface. It is HIGHLY recommended to disable SSR for large water planes, as lag or unnecessary performance loss can occur!";

            GUILayout.BeginVertical(ssrWarnBox, GUILayout.Width(22), GUILayout.Height(22));
            GUILayout.Label(ssrWarnIcon, GUILayout.Width(18), GUILayout.Height(18));
            GUILayout.EndVertical();

            EditorGUI.BeginChangeCheck();
            bool newSSR = EditorGUILayout.Toggle("Disable SSR", ssrUI == 1);
            if (EditorGUI.EndChangeCheck())
            {
                ssrUI = newSSR ? 1 : 0;

                if (ssrRealToggle != null)
                {
                    foreach (Material m in ssrRealToggle.targets)
                    {
                        if (m == null) continue;

                        m.SetFloat("_SSROff", ssrUI);

                        if (ssrUI == 1)
                            m.EnableKeyword("_NO_SSR");
                        else
                            m.DisableKeyword("_NO_SSR");

                        EditorUtility.SetDirty(m);
                    }
                }
            }

            EditorGUILayout.EndHorizontal();

            // =======================================================
            // BRDF MAP (MATCHED STYLE + ALIGNMENT)
            // =======================================================
            GUILayout.Space(14);
            EditorGUILayout.LabelField("BRDF Lut", EditorStyles.boldLabel);

            if (_BRDFMAP != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Use a BRDF ramp texture to change how light is reflected on the water surface.");

                GUILayout.Space(6);

                EditorGUI.BeginChangeCheck();
                bool newBRDF = EditorGUILayout.Toggle("Enable BRDF map", _BRDFMAP.floatValue == 1f);
                if (EditorGUI.EndChangeCheck())
                {
                    foreach (Material m in _BRDFMAP.targets)
                    {
                        if (m == null) continue;
                        m.SetFloat("BRDFMAP", newBRDF ? 1f : 0f);

                        if (newBRDF) m.EnableKeyword("_BRDFMAP");
                        else m.DisableKeyword("_BRDFMAP");

                        EditorUtility.SetDirty(m);
                    }
                }

                EditorGUILayout.EndHorizontal();

                // Show BRDF texture only when enabled
                if (_BRDFMAP.floatValue == 1f && _g_tBRDFMap != null)
                {
                    EditorGUI.indentLevel++;
                    m_MaterialEditor.TextureProperty(_g_tBRDFMap, _g_tBRDFMap.displayName);
                    EditorGUI.indentLevel--;
                }
            }
        });



        // -------- Distortion --------
        DrawBox("Distortion", () =>
        {
            // We intercept BEFORE calling DrawEnumGroup to place icon inline.
            EditorGUILayout.BeginHorizontal();

            int currentDistortion = _DistortionType != null ? (int)_DistortionType.floatValue : 0;

            // Show warning ONLY if Chromatic Aberration = 2
            if (currentDistortion == 2)
            {
                GUIStyle warnBox = new GUIStyle(GUI.skin.box)
                {
                    padding = new RectOffset(2, 2, 2, 2),
                    margin = new RectOffset(2, 6, 0, 0)
                };
                warnBox.normal.textColor = Color.white;

                GUIContent warnIcon = EditorGUIUtility.IconContent("console.warnicon.sml");
                warnIcon.tooltip =
                    "Chromatic Aberration distortion costs more performance than regular distortion. Please be considerate when using!";

                GUILayout.BeginVertical(warnBox, GUILayout.Width(22), GUILayout.Height(22));
                GUILayout.Label(warnIcon, GUILayout.Width(18), GUILayout.Height(18));
                GUILayout.EndVertical();
            }
            else
            {
                // No placeholder at all → removes empty left indentation
            }

            //
            // Distortion Type dropdown (UNCHANGED)
            //
            EditorGUI.BeginChangeCheck();
            m_MaterialEditor.ShaderProperty(_DistortionType, _DistortionType.displayName);
            if (EditorGUI.EndChangeCheck())
            {
                foreach (Material m in _DistortionType.targets)
                {
                    if (m == null) continue;
                    m.SetFloat(_DistortionType.name, _DistortionType.floatValue);
                    EditorUtility.SetDirty(m);
                }
            }

            EditorGUILayout.EndHorizontal();


            // Now run the ORIGINAL inner DrawEnumGroup content
            int val = (int)_DistortionType.floatValue;

            if (_DistortionIntensity != null)
                m_MaterialEditor.ShaderProperty(_DistortionIntensity, _DistortionIntensity.displayName);

            if (val > 1 && _RGBOffset != null)
                m_MaterialEditor.ShaderProperty(_RGBOffset, _RGBOffset.displayName);

            // ORIGINAL — depth masked refraction (unchanged logic)
            if (_EnableDepthMaskedRefraction != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Depth Masked Refraction suppresses distortion around geometry in front of the water surface.");
                m_MaterialEditor.ShaderProperty(_EnableDepthMaskedRefraction, _EnableDepthMaskedRefraction.displayName);

                EditorGUILayout.EndHorizontal();
            }
        });



        //--------------------------------------------------------------------
        // DEPTH COLORS (DIRECTLY AFTER DISTORTION — INSTANT SWITCH + SHADER FLASH)
        //--------------------------------------------------------------------
        DrawBox("Depth Colors", () =>
        {
            // Header row with ? icon
            if (_EnableDepthColors != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Underwater fog, create murky or non-clear water.");
                m_MaterialEditor.ShaderProperty(_EnableDepthColors, _EnableDepthColors.displayName);

                EditorGUILayout.EndHorizontal();
            }

            if (_EnableDepthColors != null && _EnableDepthColors.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                //----------------------------------------------------------------
                // Depth Color Mode Dropdown (Instant Apply)
                //----------------------------------------------------------------
                if (_DepthColorMode != null)
                {
                    if (_DepthColorMode.floatValue != 0f && _DepthColorMode.floatValue != 1f)
                        _DepthColorMode.floatValue = 0f;

                    string[] depthModes = new[] { "Regular (Recommended)", "Distance Based" };
                    int selected = (int)_DepthColorMode.floatValue;

                    EditorGUI.BeginChangeCheck();
                    selected = EditorGUILayout.Popup("Depth Color Mode", selected, depthModes);

                    if (EditorGUI.EndChangeCheck())
                    {
                        _DepthColorMode.floatValue = selected;

                        foreach (Material m in _DepthColorMode.targets)
                        {
                            if (m == null) continue;

                            m.SetFloat(_DepthColorMode.name, selected);
                            EditorUtility.SetDirty(m);

                            // force shader "flash" recompile
                            m.shader = m.shader;
                            SceneView.RepaintAll();
                            HandleUtility.Repaint();
                        }

                        GUI.changed = true;
                    }
                }

                //----------------------------------------------------------------
                // Draw Selected Mode Properties
                //----------------------------------------------------------------
                int mode = _DepthColorMode != null ? (int)_DepthColorMode.floatValue : 0;

                if (mode == 0)
                {
                    if (_DepthColor != null)
                        m_MaterialEditor.ColorProperty(_DepthColor, _DepthColor.displayName);

                    if (_Clarity != null)
                        m_MaterialEditor.ShaderProperty(_Clarity, _Clarity.displayName);

                    if (_Murkiness != null)
                        m_MaterialEditor.ShaderProperty(_Murkiness, _Murkiness.displayName);
                }

                if (mode == 1)
                {
                    if (_ShallowColor != null)
                        m_MaterialEditor.ColorProperty(_ShallowColor, _ShallowColor.displayName);

                    if (_DeepColor != null)
                        m_MaterialEditor.ColorProperty(_DeepColor, _DeepColor.displayName);

                    if (_WaterDepth != null)
                        m_MaterialEditor.ShaderProperty(_WaterDepth, _WaterDepth.displayName);

                    if (_DepthTranslucency != null)
                        m_MaterialEditor.ShaderProperty(_DepthTranslucency, _DepthTranslucency.displayName);
                }

                EditorGUI.indentLevel--;
            }
        });

        // ===========================
        // NORMALS SECTION HEADER
        // ===========================
        GUILayout.Label("Normals", sectionHeaderStyle);
        EditorGUILayout.Space(4);

        // -------- Normals --------
        DrawBox("Normals", () =>
        {
            // ---------------------------
            // Normal Map (always visible)
            // ---------------------------
            if (_NormalMap != null)
                m_MaterialEditor.TextureProperty(_NormalMap, _NormalMap.displayName);

            // -----------------------------------------
            // Anti-Tile toggle (DIRECTLY below texture)
            // -----------------------------------------
            if (_EnableAntiTileNormals != null)
                m_MaterialEditor.ShaderProperty(_EnableAntiTileNormals, _EnableAntiTileNormals.displayName);

            // -------------------------------
            // Normal settings (ALWAYS VISIBLE)
            // -------------------------------
            if (_NormalTiling != null)
                m_MaterialEditor.VectorProperty(_NormalTiling, _NormalTiling.displayName);

            if (_NormalIntensity != null)
                m_MaterialEditor.ShaderProperty(_NormalIntensity, _NormalIntensity.displayName);

            if (_WaterSpeedX != null)
                m_MaterialEditor.ShaderProperty(_WaterSpeedX, _WaterSpeedX.displayName);

            if (_WaterSpeedY != null)
                m_MaterialEditor.ShaderProperty(_WaterSpeedY, _WaterSpeedY.displayName);

            // -------------------------------------------------------
            // Anti-Tile–only settings (shown ONLY when toggle = ON)
            // -------------------------------------------------------
            if (_EnableAntiTileNormals != null && _EnableAntiTileNormals.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                // (If you have ANY anti-tile extras, put them here)

                EditorGUI.indentLevel--;
            }
        });

        // -------- Micro Normals --------
        DrawBox("Micro Normals", () =>
        {
            if (_MicroNormals != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Micro Normals add tiny high-frequency detail to the surface.");
                m_MaterialEditor.ShaderProperty(_MicroNormals, _MicroNormals.displayName);
                EditorGUILayout.EndHorizontal();
            }

            if (_MicroNormals.floatValue == 1f)
            {
                EditorGUI.indentLevel++;
                if (_MicroNormalMap != null) m_MaterialEditor.TextureProperty(_MicroNormalMap, _MicroNormalMap.displayName);
                if (_MicroNormalTiling != null) m_MaterialEditor.VectorProperty(_MicroNormalTiling, _MicroNormalTiling.displayName);
                if (_MicroNormalIntensity != null) m_MaterialEditor.ShaderProperty(_MicroNormalIntensity, _MicroNormalIntensity.displayName);
                if (_MicroNormalSpeedX != null) m_MaterialEditor.ShaderProperty(_MicroNormalSpeedX, _MicroNormalSpeedX.displayName);
                if (_MicroNormalSpeedY != null) m_MaterialEditor.ShaderProperty(_MicroNormalSpeedY, _MicroNormalSpeedY.displayName);
                if (_MicroNormalsNearFadeDistance != null) m_MaterialEditor.ShaderProperty(_MicroNormalsNearFadeDistance, _MicroNormalsNearFadeDistance.displayName);
                if (_MicroNormalsFarFadeDistance != null) m_MaterialEditor.ShaderProperty(_MicroNormalsFarFadeDistance, _MicroNormalsFarFadeDistance.displayName);
                EditorGUI.indentLevel--;
            }
        });

        //--------------------------------------------------------------------
        // DYNAMIC RIPPLES (with Debug View)  **BEFORE WAVES & FOAM HEADER**
        //--------------------------------------------------------------------
        DrawBox("Dynamic Ripples", () =>
        {
            // Enable Ripple Switch
            if (_EnableDynamicRipples != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Dynamic ripples use a camera + RenderTexture. Use the Dynamic Ripples Plane prefab.");
                m_MaterialEditor.ShaderProperty(_EnableDynamicRipples, _EnableDynamicRipples.displayName);

                EditorGUILayout.EndHorizontal();
            }

            // Ripple settings when enabled
            if (_EnableDynamicRipples.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                if (_DynamicRippleIntensity != null)
                    m_MaterialEditor.ShaderProperty(_DynamicRippleIntensity, _DynamicRippleIntensity.displayName);

                if (_RippleRenderTexture != null)
                    m_MaterialEditor.TextureProperty(_RippleRenderTexture, _RippleRenderTexture.displayName);

                // --------------------------
                // DEBUG VIEW AT BOTTOM
                // --------------------------
                EditorGUILayout.Space(6);

                if (_DebugView1 != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    DrawHelpIcon("Visually see Dynamic Ripple texture on your water.");
                    m_MaterialEditor.ShaderProperty(_DebugView1, _DebugView1.displayName);

                    EditorGUILayout.EndHorizontal();
                }

                if (_DebugView1 != null && _DebugView1.floatValue == 1f)
                {
                    EditorGUI.indentLevel++;

                    if (_DebugContrast1 != null)
                        m_MaterialEditor.ShaderProperty(_DebugContrast1, _DebugContrast1.displayName);

                    EditorGUI.indentLevel--;
                }

                EditorGUI.indentLevel--;
            }
        });

        // ===========================
        // WAVES & FOAM SECTION HEADER
        // ===========================
        GUILayout.Label("Waves and Foam", sectionHeaderStyle);
        EditorGUILayout.Space(4);

        // -------- Waves --------
        DrawBox("Waves", () =>
        {
            var mats = GetSelectedMaterials();

            int baseVal = mats.Count > 0 ? GetWaveTypeFromMaterial(mats[0]) : 0;

            bool mixed = false;
            for (int i = 1; i < mats.Count; i++)
                if (GetWaveTypeFromMaterial(mats[i]) != baseVal)
                    mixed = true;

            bool dynEnabled = (_EnableDynamicRipples != null && _EnableDynamicRipples.floatValue == 1f);

            List<string> optionsList = new List<string>()
            {
                "None",
                "Gerstner Waves",
                "3D Texture",
                "Gerstner + 3D Texture",
                "Noise"
            };

            // Add Dynamic Ripples option only if enabled
            if (dynEnabled)
                optionsList.Add("Dynamic Ripples");

            // Prevent invalid value if dynamic ripples is off
            if (!dynEnabled && baseVal == 5)
            {
                baseVal = 0;
                foreach (var m in mats)
                {
                    SetWaveTypeOnMaterial(m, 0);
                    if (m.HasProperty("_WaveType"))
                        m.SetFloat("_WaveType", 0);
                }
            }

            string[] options = optionsList.ToArray();

            if (baseVal >= options.Length)
                baseVal = 0;

            EditorGUI.showMixedValue = mixed;
            EditorGUI.BeginChangeCheck();

            int selected = EditorGUILayout.Popup("Wave Type", baseVal, options);

            if (EditorGUI.EndChangeCheck())
            {
                // If dynamic ripples is enabled, interpret last option as index 5
                if (dynEnabled && selected == options.Length - 1 && options.Length == 6)
                    selected = 5;

                foreach (var m in mats)
                    SetWaveTypeOnMaterial(m, selected);

                foreach (var m in mats)
                {
                    if (m.HasProperty("_WaveType"))
                        m.SetFloat("_WaveType", selected);
                }
            }

            EditorGUI.showMixedValue = false;

            bool showGerstner = false;
            bool show3D = false;
            bool showNoise = false;
            bool showDynamicRipples = false;

            foreach (var m in mats)
            {
                int v = GetWaveTypeFromMaterial(m);
                if (v == 1 || v == 3) showGerstner = true;
                if (v == 2 || v == 3) show3D = true;
                if (v == 4) showNoise = true;
                if (v == 5) showDynamicRipples = true;
            }

            if (showGerstner)
            {
                EditorGUILayout.LabelField("Gerstner Wave Settings", EditorStyles.boldLabel);
                if (_NumberOfWaves != null) m_MaterialEditor.ShaderProperty(_NumberOfWaves, _NumberOfWaves.displayName);
                if (_Steepness != null) m_MaterialEditor.ShaderProperty(_Steepness, _Steepness.displayName);
                if (_Wavelength != null) m_MaterialEditor.ShaderProperty(_Wavelength, _Wavelength.displayName);
                if (_Amplitude != null) m_MaterialEditor.ShaderProperty(_Amplitude, _Amplitude.displayName);
                if (_Speed != null) m_MaterialEditor.ShaderProperty(_Speed, _Speed.displayName);
            }

            if (show3D)
            {
                EditorGUILayout.LabelField("3D Texture Wave Settings", EditorStyles.boldLabel);
                if (_Displacement3DTexture != null) m_MaterialEditor.TextureProperty(_Displacement3DTexture, _Displacement3DTexture.displayName);
                if (_DisplacementTiling != null) m_MaterialEditor.ShaderProperty(_DisplacementTiling, _DisplacementTiling.displayName);
                if (_WaveSpeed != null) m_MaterialEditor.ShaderProperty(_WaveSpeed, _WaveSpeed.displayName);
                if (_WaveHeight != null) m_MaterialEditor.ShaderProperty(_WaveHeight, _WaveHeight.displayName);
            }

            if (showNoise)
            {
                EditorGUILayout.LabelField("Noise Wave Settings", EditorStyles.boldLabel);
                if (_NoiseWavesSpeed != null) m_MaterialEditor.ShaderProperty(_NoiseWavesSpeed, _NoiseWavesSpeed.displayName);
                if (_NoiseWavesScale != null) m_MaterialEditor.ShaderProperty(_NoiseWavesScale, _NoiseWavesScale.displayName);
                if (_NoiseWavesSize != null) m_MaterialEditor.ShaderProperty(_NoiseWavesSize, _NoiseWavesSize.displayName);
                if (_NoiseWavesDirection != null) m_MaterialEditor.VectorProperty(_NoiseWavesDirection, _NoiseWavesDirection.displayName);
            }

            if (showDynamicRipples && _DynamicRippleWaveHeight != null)
            {
                EditorGUILayout.LabelField("Dynamic Ripple Wave Settings", EditorStyles.boldLabel);
                m_MaterialEditor.ShaderProperty(_DynamicRippleWaveHeight, _DynamicRippleWaveHeight.displayName);

                EditorGUILayout.Space(6);
                EditorGUILayout.BeginVertical(GUI.skin.box);

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label(EditorGUIUtility.IconContent("console.infoicon"), GUILayout.Width(36), GUILayout.Height(36));
                GUILayout.Label(
                    "Dynamic ripple waves work best with a high-poly plane.\nAssign high-poly or default plane below.",
                    EditorStyles.wordWrappedLabel
                );
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.Space(4);
                EditorGUILayout.BeginHorizontal();

                if (GUILayout.Button("Assign High Poly Water Plane", GUILayout.Height(22)))
                {
                    Mesh highPoly = AssetDatabase.LoadAssetAtPath<Mesh>(
                        "Assets/LitMAS Water/Assets/Mesh/LitMAS Water Plane High Poly.mesh"
                    );

                    foreach (var t in Selection.gameObjects)
                    {
                        var mf = t.GetComponent<MeshFilter>();
                        if (mf != null && highPoly != null)
                        {
                            Undo.RecordObject(mf, "Assign High Poly Water Plane");
                            mf.sharedMesh = highPoly;
                            EditorUtility.SetDirty(mf);
                        }
                    }
                }

                if (GUILayout.Button("Assign Regular Water Plane", GUILayout.Height(22)))
                {
                    Mesh regular = AssetDatabase.LoadAssetAtPath<Mesh>(
                        "Assets/LitMAS Water/Assets/Mesh/LitMAS Water Plane.mesh"
                    );

                    foreach (var t in Selection.gameObjects)
                    {
                        var mf = t.GetComponent<MeshFilter>();
                        if (mf != null && regular != null)
                        {
                            Undo.RecordObject(mf, "Assign Regular Water Plane");
                            mf.sharedMesh = regular;
                            EditorUtility.SetDirty(mf);
                        }
                    }
                }

                EditorGUILayout.EndHorizontal();
                EditorGUILayout.EndVertical();
            }
        });

        //--------------------------------------------------------------------
        // FOAM
        //--------------------------------------------------------------------
        DrawBox("Foam", () =>
        {
            DrawToggleGroup(_EnableFoam, () =>
            {
                if (_FoamTexture != null) m_MaterialEditor.TextureProperty(_FoamTexture, _FoamTexture.displayName);
                if (_FoamTiling != null) m_MaterialEditor.VectorProperty(_FoamTiling, _FoamTiling.displayName);
                if (_EnableAntiTileFoam != null) m_MaterialEditor.ShaderProperty(_EnableAntiTileFoam, _EnableAntiTileFoam.displayName);
                if (_FoamColor != null) m_MaterialEditor.ColorProperty(_FoamColor, _FoamColor.displayName);
                if (_FoamSpeedX != null) m_MaterialEditor.ShaderProperty(_FoamSpeedX, _FoamSpeedX.displayName);
                if (_FoamSpeedY != null) m_MaterialEditor.ShaderProperty(_FoamSpeedY, _FoamSpeedY.displayName);
                if (_FoamStrength != null) m_MaterialEditor.ShaderProperty(_FoamStrength, _FoamStrength.displayName);
                if (_FoamAlpha != null) m_MaterialEditor.ShaderProperty(_FoamAlpha, _FoamAlpha.displayName);

                if (_DistortedUVInfluence1 != null)
                {
                    Rect r = EditorGUILayout.GetControlRect();
                    Rect iconR = new Rect(r.x, r.y, 20, r.height);
                    Rect fieldR = new Rect(r.x + 22, r.y, r.width - 22, r.height);

                    DrawHelpIcon(iconR, "Controls how much distorted UVs influence the foam.");
                    m_MaterialEditor.ShaderProperty(fieldR, _DistortedUVInfluence1, "Distorted UV Influence");
                }

                if (_EnableFoamParallax != null)
                {
                    m_MaterialEditor.ShaderProperty(_EnableFoamParallax, _EnableFoamParallax.displayName);

                    if (_EnableFoamParallax.floatValue == 1f && _FoamParallaxScale != null)
                    {
                        Rect r = EditorGUILayout.GetControlRect();
                        Rect iconR = new Rect(r.x, r.y, 20, r.height);
                        Rect fieldR = new Rect(r.x + 22, r.y, r.width - 22, r.height);

                        DrawHelpIcon(iconR, "Adds a depth effect to foam. Use small values (<0.3).");
                        m_MaterialEditor.ShaderProperty(fieldR, _FoamParallaxScale, _FoamParallaxScale.displayName);
                    }
                }

                if (_EnableFoamDistortion != null)
                {
                    m_MaterialEditor.ShaderProperty(_EnableFoamDistortion, _EnableFoamDistortion.displayName);

                    if (_EnableFoamDistortion.floatValue == 1f && _FoamDistortion != null)
                    {
                        Rect r = EditorGUILayout.GetControlRect();
                        Rect iconR = new Rect(r.x, r.y, 20, r.height);
                        Rect fieldR = new Rect(r.x + 22, r.y, r.width - 22, r.height);

                        DrawHelpIcon(iconR, "Distorts foam. If foam disappears, increase Alpha or Foam Color.");
                        m_MaterialEditor.ShaderProperty(fieldR, _FoamDistortion, _FoamDistortion.displayName);
                    }
                }
            });
        });

        // ===========================
        // UV OPTIONS SECTION HEADER
        // ===========================
        GUILayout.Label("UV Options", sectionHeaderStyle);
        EditorGUILayout.Space(4);

        //--------------------------------------------------------------------
        // FLOWMAPPED UVS  (with Debug View at bottom, NO HEADERS)
        //--------------------------------------------------------------------
        DrawBox("Flowmap UV's", () =>
        {
            // -------------------------
            // Enable Flowmapped UVs row
            // -------------------------
            if (_EnableFlowmappedUVs != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Guide water flow using flowmaps. Create them with AtlasUtils → LitMAS Water → Flowmap Painter.");
                m_MaterialEditor.ShaderProperty(_EnableFlowmappedUVs, _EnableFlowmappedUVs.displayName);

                EditorGUILayout.EndHorizontal();
                EditorGUILayout.Space(2);

                // Only show button when enabled
                if (_EnableFlowmappedUVs.floatValue == 1f)
                {
                    if (GUILayout.Button("Open Flowmap Painter Tool", GUILayout.Height(20)))
                    {
                        EditorApplication.ExecuteMenuItem("AtlasUtils/LitMAS Water/Flowmap Painter");
                    }

                    EditorGUILayout.Space(4);
                }
            }

            // -------------------------------
            // FLOWMAP SETTINGS (IF ENABLED)
            // -------------------------------
            if (_EnableFlowmappedUVs != null && _EnableFlowmappedUVs.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                // --------------------------------
                // WARNINGS
                // --------------------------------
                Texture flowTex = _Flowmap != null ? _Flowmap.textureValue : null;

                if (flowTex == null)
                {
                    EditorGUILayout.HelpBox(
                        "No Flowmap texture assigned! Disable Flowmapping if unused.",
                        MessageType.Warning);
                }
                else
                {
                    TextureImporter ti = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(flowTex)) as TextureImporter;
                    if (ti != null && ti.textureType != TextureImporterType.NormalMap)
                    {
                        EditorGUILayout.HelpBox(
                            "Flowmap texture is NOT marked as a Normal Map! Flowmaps MUST be normal maps.",
                            MessageType.Warning);
                    }
                }

                // --------------------------------
                // Flowmap texture + settings
                // --------------------------------
                if (_Flowmap != null)
                    m_MaterialEditor.TextureProperty(_Flowmap, _Flowmap.displayName);

                if (_FlowmapTiling != null)
                    m_MaterialEditor.VectorProperty(_FlowmapTiling, _FlowmapTiling.displayName);

                if (_FlowmapOffset != null)
                    m_MaterialEditor.VectorProperty(_FlowmapOffset, _FlowmapOffset.displayName);

                if (_Strength != null)
                    m_MaterialEditor.ShaderProperty(_Strength, _Strength.displayName);

                if (_FlowSpeed != null)
                    m_MaterialEditor.ShaderProperty(_FlowSpeed, _FlowSpeed.displayName);

                // --------------------------------
                // DEBUG VIEW (BOTTOM ALWAYS)
                // --------------------------------
                EditorGUILayout.Space(6);

                // Debug View toggle row
                if (_DebugView != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    DrawHelpIcon("Visually see where Flowmap is on your water.");
                    m_MaterialEditor.ShaderProperty(_DebugView, _DebugView.displayName);

                    EditorGUILayout.EndHorizontal();
                }

                // Debug Contrast only when enabled
                if (_DebugView != null && _DebugView.floatValue == 1f)
                {
                    EditorGUI.indentLevel++;

                    if (_DebugContrast != null)
                        m_MaterialEditor.ShaderProperty(_DebugContrast, _DebugContrast.displayName);

                    EditorGUI.indentLevel--;
                }

                EditorGUI.indentLevel--;
            }
        });

        // -------- Distorted UVs --------
        DrawBox("Distorted UV's", () =>
        {
            if (_EnableDistortedUVs != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Distorts the UVs of the water surface to create warping.");
                m_MaterialEditor.ShaderProperty(_EnableDistortedUVs, _EnableDistortedUVs.displayName);

                EditorGUILayout.EndHorizontal();
            }

            if (_EnableDistortedUVs.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                if (_Distortion != null)
                    m_MaterialEditor.TextureProperty(_Distortion, _Distortion.displayName);

                if (_EnableAntiTileUVDistortion != null)
                    m_MaterialEditor.ShaderProperty(_EnableAntiTileUVDistortion, "Enable Anti-Tile UV Distortion");

                if (_DistortOverlayIntensity != null)
                    m_MaterialEditor.ShaderProperty(_DistortOverlayIntensity, "Distort Overlay Intensity");

                if (_DistortionSpeedX != null)
                    m_MaterialEditor.ShaderProperty(_DistortionSpeedX, _DistortionSpeedX.displayName);

                if (_DistortionSpeedY != null)
                    m_MaterialEditor.ShaderProperty(_DistortionSpeedY, _DistortionSpeedY.displayName);

                if (_DistortionTiling != null)
                    m_MaterialEditor.VectorProperty(_DistortionTiling, _DistortionTiling.displayName);

                EditorGUI.indentLevel--;
            }
        });

        // ===========================
        // OTHER OPTIONS SECTION HEADER
        // ===========================
        GUILayout.Label("Other Options", sectionHeaderStyle);
        EditorGUILayout.Space(4);

        // -------- Rain Drop Ripples --------
        DrawBox("Rain Drop Ripples", () =>
        {
            if (_EnableRainDropRipples != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Simulates raindrop circular ripples.");
                m_MaterialEditor.ShaderProperty(_EnableRainDropRipples, _EnableRainDropRipples.displayName);

                EditorGUILayout.EndHorizontal();
            }

            if (_EnableRainDropRipples.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                if (_RainDropRippleTiling != null)
                    m_MaterialEditor.VectorProperty(_RainDropRippleTiling, _RainDropRippleTiling.displayName);

                if (_RainDropRippleIntensity != null)
                    m_MaterialEditor.ShaderProperty(_RainDropRippleIntensity, _RainDropRippleIntensity.displayName);

                if (_RainDropRippleSpeed != null)
                    m_MaterialEditor.ShaderProperty(_RainDropRippleSpeed, _RainDropRippleSpeed.displayName);

                if (_EnableDistortedUVs.floatValue == 1f && _DistortedUVInfluence != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    DrawHelpIcon("Controls how much distorted UVs affect rain ripple movement.");
                    m_MaterialEditor.ShaderProperty(_DistortedUVInfluence, "Distorted UV Influence");

                    EditorGUILayout.EndHorizontal();
                }

                EditorGUI.indentLevel--;
            }
        });

        // ===========================
        // POST PROCESSING SECTION
        // ===========================
        DrawBox("Post Processing", () =>
        {
            // MASTER TOGGLE: ENABLE POST PROCESSING
            if (_EnablePostProcessing != null)
            {
                EditorGUILayout.BeginHorizontal();

                Rect ppRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                DrawHelpIcon(ppRect,
                    "Change properties that control the visual appearance of the water color. Mix and match different features to get interesting visuals."
                );

                m_MaterialEditor.ShaderProperty(_EnablePostProcessing, _EnablePostProcessing.displayName);

                EditorGUILayout.EndHorizontal();
            }

            EditorGUILayout.Space(6);

            // CHILD OPTIONS (ONLY IF MASTER ON)
            if (_EnablePostProcessing != null && _EnablePostProcessing.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                // ==============================
                // GRAYSCALE
                // ==============================
                if (_Grayscale != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    Rect gRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(gRect, "Make water appear fully black and white.");

                    m_MaterialEditor.ShaderProperty(_Grayscale, _Grayscale.displayName);

                    EditorGUILayout.EndHorizontal();

                    EditorGUILayout.Space(6);
                }

                // ==============================
                // SATURATION
                // ==============================
                if (_Saturation != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    Rect sRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(sRect, "Increase color vibrance of water.");

                    m_MaterialEditor.ShaderProperty(_Saturation, _Saturation.displayName);

                    EditorGUILayout.EndHorizontal();

                    // Only show intensity when Saturation is ON
                    if (_Saturation.floatValue == 1f && _SaturationIntensity != null)
                    {
                        EditorGUI.indentLevel++;
                        m_MaterialEditor.ShaderProperty(_SaturationIntensity, _SaturationIntensity.displayName);
                        EditorGUI.indentLevel--;
                    }

                    EditorGUILayout.Space(6);
                }

                // ==============================
                // CONTRAST
                // ==============================
                if (_Contrast != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    Rect cRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(cRect, "Change difference between different colors.");

                    m_MaterialEditor.ShaderProperty(_Contrast, _Contrast.displayName);

                    EditorGUILayout.EndHorizontal();

                    // Only show intensity when Contrast is ON
                    if (_Contrast.floatValue == 1f && _ContrastIntensity != null)
                    {
                        EditorGUI.indentLevel++;
                        m_MaterialEditor.ShaderProperty(_ContrastIntensity, _ContrastIntensity.displayName);
                        EditorGUI.indentLevel--;
                    }

                    EditorGUILayout.Space(6);
                }

                // ==============================
                // POSTERIZE
                // ==============================
                if (_Posterize != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    Rect pRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(pRect, "Posterize water for interesting visuals.");

                    m_MaterialEditor.ShaderProperty(_Posterize, _Posterize.displayName);

                    EditorGUILayout.EndHorizontal();

                    // Only show intensity when Posterize is ON
                    if (_Posterize.floatValue == 1f && _PosterizationIntensity != null)
                    {
                        EditorGUI.indentLevel++;
                        m_MaterialEditor.ShaderProperty(_PosterizationIntensity, _PosterizationIntensity.displayName);
                        EditorGUI.indentLevel--;
                    }

                    EditorGUILayout.Space(6);
                }

                // ==============================
                // MIDTONES
                // ==============================
                if (_Midtones != null)
                {
                    EditorGUILayout.BeginHorizontal();

                    Rect mRect = GUILayoutUtility.GetRect(20, 20, GUILayout.Width(20));
                    DrawHelpIcon(mRect, "Adjust water mid tones for interesting visuals (Experimental).");

                    m_MaterialEditor.ShaderProperty(_Midtones, _Midtones.displayName);

                    EditorGUILayout.EndHorizontal();

                    // Only show RGB when Midtones is ON
                    if (_Midtones.floatValue == 1f && (_Red != null || _Green != null || _Blue != null))
                    {
                        EditorGUI.indentLevel++;

                        if (_Red != null)
                            m_MaterialEditor.ShaderProperty(_Red, _Red.displayName);
                        if (_Green != null)
                            m_MaterialEditor.ShaderProperty(_Green, _Green.displayName);
                        if (_Blue != null)
                            m_MaterialEditor.ShaderProperty(_Blue, _Blue.displayName);

                        EditorGUI.indentLevel--;
                    }

                    EditorGUILayout.Space(6);
                }

                EditorGUI.indentLevel--;
            }
        });

        // ===========================
        // ALPHA MASKING SECTION
        // ===========================
        DrawBox("Alpha Masking", () =>
        {
            // ---------------------------
            // Enable Alpha Masking row
            // ---------------------------
            if (_EnableAlphaMasking != null)
            {
                EditorGUILayout.BeginHorizontal();

                DrawHelpIcon("Mask out parts of the water with an alpha mask.\nUse the included Alpha Mask Painter tool to create one.");
                m_MaterialEditor.ShaderProperty(_EnableAlphaMasking, _EnableAlphaMasking.displayName);

                EditorGUILayout.EndHorizontal();
            }

            // ---------------------------
            // Button to open the tool
            // ONLY show when enabled
            // ---------------------------
            if (_EnableAlphaMasking != null && _EnableAlphaMasking.floatValue == 1f)
            {
                EditorGUI.indentLevel++;

                if (GUILayout.Button("Open Alpha Masking Tool", GUILayout.Height(20)))
                {
                    EditorApplication.ExecuteMenuItem("AtlasUtils/LitMAS Water/Alpha Mask Painter");
                }

                EditorGUILayout.Space(4);

                // ---------------------------
                // Alpha Mask properties
                // ---------------------------
                if (_AlphaMask != null)
                    m_MaterialEditor.TextureProperty(_AlphaMask, _AlphaMask.displayName);

                if (_AlphaFalloff != null)
                    m_MaterialEditor.ShaderProperty(_AlphaFalloff, _AlphaFalloff.displayName);

                EditorGUI.indentLevel--;
            }
        });

    }
}
