#if UNITY_EDITOR

using UnityEditor;
using UnityEngine;

public sealed class SLZImproved : ShaderGUI
{
    private const string LogoPath =
        "Packages/com.atlas.atlasshaderemporium/!Resources/Script Icons/SLZ Improved.psd";

    private Texture2D _logo;
    private GUIStyle _titleStyle;

    public override void OnGUI(
        MaterialEditor materialEditor,
        MaterialProperty[] properties)
    {
        GUILayout.Space(4f);

        DrawLogo();

        GUILayout.Space(2f);

        Material material = materialEditor.target as Material;

        DrawTitle(GetShaderName(material));

        GUILayout.Space(4f);

        // Restore Shader Graph's hidden Face / Cull setting.
        DrawFaceSetting(materialEditor, properties);

        // Draw all of the shader's normal exposed properties.
        base.OnGUI(materialEditor, properties);

        // Refresh toggle and keyword property drawers after changes.
        if (GUI.changed)
        {
            MaterialEditor.ApplyMaterialPropertyDrawers(
                materialEditor.targets);
        }
    }

    private void DrawLogo()
    {
        if (_logo == null)
        {
            _logo = AssetDatabase.LoadAssetAtPath<Texture2D>(
                LogoPath);
        }

        if (_logo == null)
        {
            EditorGUILayout.HelpBox(
                $"Logo not found at:\n{LogoPath}",
                MessageType.Warning);

            EditorGUILayout.Space(4f);
            return;
        }

        const float maxHeight = 100f;

        float inspectorWidth = Mathf.Max(
            100f,
            EditorGUIUtility.currentViewWidth - 40f);

        float aspect = _logo.height > 0
            ? (float)_logo.width / _logo.height
            : 1f;

        float width = Mathf.Min(
            inspectorWidth,
            maxHeight * aspect);

        float height = width / aspect;

        Rect area = EditorGUILayout.GetControlRect(
            false,
            height + 8f);

        Rect logoRect = new Rect(
            area.x + (area.width - width) * 0.5f,
            area.y,
            width,
            height);

        GUI.DrawTexture(
            logoRect,
            _logo,
            ScaleMode.ScaleToFit,
            true);
    }

    private void DrawTitle(string text)
    {
        if (_titleStyle == null)
        {
            _titleStyle = new GUIStyle(
                EditorStyles.boldLabel);

            _titleStyle.alignment =
                TextAnchor.MiddleCenter;

            _titleStyle.fontSize = 20;
            _titleStyle.fontStyle = FontStyle.Bold;
        }

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        // White-to-gray character gradient.
        Color start = new Color(
            1f,
            1f,
            1f,
            1f);

        Color end = new Color(
            0.55f,
            0.55f,
            0.55f,
            1f);

        for (int i = 0; i < text.Length; i++)
        {
            float t = (float)i /
                Mathf.Max(1, text.Length - 1);

            _titleStyle.normal.textColor =
                Color.Lerp(start, end, t);

            GUILayout.Label(
                text[i].ToString(),
                _titleStyle);
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
    }

    private static void DrawFaceSetting(
        MaterialEditor materialEditor,
        MaterialProperty[] properties)
    {
        MaterialProperty cullProperty =
            FindProperty("_Cull", properties, false);

        if (cullProperty == null)
        {
            return;
        }

        /*
         * Unity Cull values:
         *
         * 0 = Cull Off   -> render Both faces
         * 1 = Cull Front -> render Back faces
         * 2 = Cull Back  -> render Front faces
         */

        string[] faceNames =
        {
            "Front",
            "Back",
            "Both"
        };

        int currentCullValue =
            Mathf.RoundToInt(cullProperty.floatValue);

        int selectedFace;

        switch (currentCullValue)
        {
            case 2:
                selectedFace = 0; // Front
                break;

            case 1:
                selectedFace = 1; // Back
                break;

            default:
                selectedFace = 2; // Both
                break;
        }

        EditorGUI.showMixedValue =
            cullProperty.hasMixedValue;

        EditorGUI.BeginChangeCheck();

        selectedFace = EditorGUILayout.Popup(
            "Face",
            selectedFace,
            faceNames);

        if (EditorGUI.EndChangeCheck())
        {
            materialEditor.RegisterPropertyChangeUndo(
                "Face");

            switch (selectedFace)
            {
                case 0:
                    cullProperty.floatValue = 2f;
                    break;

                case 1:
                    cullProperty.floatValue = 1f;
                    break;

                default:
                    cullProperty.floatValue = 0f;
                    break;
            }
        }

        EditorGUI.showMixedValue = false;

        GUILayout.Space(4f);
    }

    private static string GetShaderName(
        Material material)
    {
        if (material == null ||
            material.shader == null)
        {
            return "Missing Shader";
        }

        string shaderName = material.shader.name;

        if (string.IsNullOrEmpty(shaderName))
        {
            return "Unnamed Shader";
        }

        // Remove folders from the shader name.
        // Example:
        // Atlas/Particles/My Shader
        // becomes:
        // My Shader

        int lastSlash =
            shaderName.LastIndexOf('/');

        if (lastSlash >= 0 &&
            lastSlash < shaderName.Length - 1)
        {
            shaderName = shaderName.Substring(
                lastSlash + 1);
        }

        return shaderName;
    }
}

#endif