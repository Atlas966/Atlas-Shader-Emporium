using UnityEngine;
using UnityEngine.Rendering.Universal;
#if UNITY_EDITOR
using UnityEditor;
#endif

[AddComponentMenu("LitMAS Water/Ripple Camera Utility")]
public class LitMASWaterRippleCameraUtility : MonoBehaviour { }

#if UNITY_EDITOR
[CustomEditor(typeof(LitMASWaterRippleCameraUtility))]
public class LitMASWaterRippleCameraUtilityEditor : Editor
{
    static bool showInstructions = false;

    // Helper function to safely fetch hidden Serialized URP fields
    private SerializedProperty FindURPProp(SerializedObject obj, string name)
    {
        return obj.FindProperty(name);
    }

    private bool CheckIdealSettings(Camera cam)
    {
        if (cam == null) return false;

        var urp = cam.GetComponent<UniversalAdditionalCameraData>();
        if (!urp) return false;

        // SerializedObject lets us access m_StopNaNs / m_Dithering safely
        var so = new SerializedObject(urp);
        var stopNaNsProp = FindURPProp(so, "m_StopNaNs");
        var ditheringProp = FindURPProp(so, "m_Dithering");

        bool stopNaNsOff = stopNaNsProp == null || stopNaNsProp.boolValue == false;
        bool ditheringOff = ditheringProp == null || ditheringProp.boolValue == false;

        return
            cam.orthographic == false &&
            Mathf.Approximately(cam.fieldOfView, 5.73f) &&
            Mathf.Approximately(cam.nearClipPlane, 0.01f) &&
            Mathf.Approximately(cam.farClipPlane, 200.3f) &&
            cam.clearFlags == CameraClearFlags.SolidColor &&
            cam.backgroundColor == new Color(0f, 0f, 0f, 1f) &&
            cam.allowHDR == false &&
            cam.allowMSAA == false &&
            cam.useOcclusionCulling == true &&
            cam.cullingMask == LayerMask.GetMask("ObserverTrigger") &&

            // Depth / Opaque
            urp.requiresDepthOption == CameraOverrideOption.Off &&
            urp.requiresColorOption == CameraOverrideOption.Off &&

            // Must all be OFF
            urp.renderPostProcessing == false &&
            urp.renderShadows == false &&
            urp.antialiasing == AntialiasingMode.None &&
            stopNaNsOff &&
            ditheringOff;
    }

    public override void OnInspectorGUI()
    {
        Camera cam = ((LitMASWaterRippleCameraUtility)target).GetComponent<Camera>();
        bool hasRT = cam != null && cam.targetTexture != null;
        bool recommended = cam != null && CheckIdealSettings(cam);

        // --- ERRORS ---
        if (cam == null)
        {
            EditorGUILayout.HelpBox("No camera found.", MessageType.Error);
        }
        else if (!hasRT)
        {
            EditorGUILayout.HelpBox("Missing Render Texture!", MessageType.Error);
        }

        // --- MAIN WARNING ---
        EditorGUILayout.HelpBox(
            "This Ripple Camera MUST match your LitMAS Water plane setup! Ensure it’s positioned correctly and has the same coverage area.",
            MessageType.Warning
        );

        // --- STATUS ---
        if (cam != null && hasRT && !recommended)
            EditorGUILayout.HelpBox("Ripple camera settings not ideal — click button to fix.", MessageType.Warning);

        if (cam != null && hasRT && recommended)
        {
            Texture checkIcon = EditorGUIUtility.IconContent("TestPassed").image;
            EditorGUILayout.BeginHorizontal(EditorStyles.helpBox);
            GUILayout.Label(checkIcon, GUILayout.Width(22), GUILayout.Height(22));
            GUILayout.Label("Recommended ripple camera settings detected!", EditorStyles.boldLabel);
            EditorGUILayout.EndHorizontal();
        }

        EditorGUILayout.Space(6);

        // --- BUTTON ---
        string text = cam == null ? "Set Up Ripple Camera" : "Apply Ripple Camera Settings";
        Texture camIcon = EditorGUIUtility.IconContent("Camera Icon").image;

        Rect r = GUILayoutUtility.GetRect(0, 40, GUILayout.ExpandWidth(true));
        bool disableButton = recommended;

        float prevAlpha = GUI.color.a;
        if (disableButton) GUI.color = new Color(1f, 1f, 1f, 0.4f);

        EditorGUI.BeginDisabledGroup(disableButton);
        if (GUI.Button(r, GUIContent.none))
        {
            SetupRippleCamera(cam);
        }
        EditorGUI.EndDisabledGroup();

        GUI.color = disableButton ? new Color(1f, 1f, 1f, 0.4f) : new Color(1f, 1f, 1f, prevAlpha);

        GUIStyle txt = new GUIStyle(GUI.skin.label)
        { alignment = TextAnchor.MiddleCenter, fontStyle = FontStyle.Bold, fontSize = 13 };

        Vector2 tSize = txt.CalcSize(new GUIContent(text));
        int iconSize = 22; float pad = 6f;
        float total = tSize.x + iconSize + pad;
        float startX = r.x + (r.width - total) * 0.5f;
        float y = r.y + (r.height - iconSize) * 0.5f;

        GUI.Label(new Rect(startX, r.y, tSize.x, r.height), text, txt);
        GUI.Label(new Rect(startX + tSize.x + pad, y, iconSize, iconSize), camIcon);

        GUI.color = new Color(1f, 1f, 1f, prevAlpha);
        EditorGUILayout.Space(10);

        // --- INSTRUCTIONS ---
        showInstructions = EditorGUILayout.Foldout(showInstructions, "Camera instructions", true);
        if (showInstructions)
        {
            GUIStyle wrap = new GUIStyle(EditorStyles.label) { wordWrap = true };
            Texture infoIcon = EditorGUIUtility.IconContent("console.infoicon").image;

            // Info block
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.BeginHorizontal();
            GUILayout.Label(infoIcon, GUILayout.Width(20), GUILayout.Height(20));
            EditorGUILayout.LabelField(
@"LitMAS Water requires a camera for dynamic ripples, this is necessary to view the ripples and use them in the shader. The position, size, and depth far clipping plane of the ripple camera are crucial for proper functionality. This script can automatically set these settings, however manual adjustment will likely be necessary based on your setup. Explanations on what each setting controls and does is also necessary to understand how to properly set the camera.",
                wrap);
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.EndVertical();

            EditorGUILayout.Space(6);

            // Settings block
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.BeginHorizontal();
            GUILayout.Label(infoIcon, GUILayout.Width(20), GUILayout.Height(20));
            EditorGUILayout.LabelField(
@"Ripple Camera Settings:
(IMPORTANT) Ripple Camera Position:
At least 100m BELOW your water plane. Anything lower will cause warping. Must not be ABOVE water plane!

(IMPORTANT) Projection:
Set to Perspective.

(IMPORTANT) FOV:
Change FOV to match EXACT water plane dimensions! Enter orthographic camera view mode to percisely adjust the FOV gizmo in scene view.

(IMPORTANT) Clipping Planes:
Determines how close/far ripples are visible to your Ripple Camera. Keep near clipping plane at 0.01. The Far clipping plane value determines how far off the surface ripples are visible to the Ripple Camera (Recommended to set around ~200.1, this number depends on if you set your Ripple Camera Position to something OTHER than 100m BELOW your water plane).

(IMPORTANT) Post Processing, Anti-aliasing, Render Shadows:
Set all to OFF. Leaving on is unnecessary lost performance.

(IMPORTANT) Depth and Opaque texture:
Both Depth and Opaque textures must be set to Off. Turning off Depth Texture is necessary for ripples to be visible to the Ripple Camera. Turning off Opaque Texture is necessary to save performance.

(IMPORTANT) Culling Mask:
MUST BE SET TO 'OBSERVER TRIGGER' LAYER ONLY. Otherwise, ripple particles will be visible through spectator camera, as well as visible to the player on Quest. 

Render Texture (Output Texture):
MUST be set to a Render Texture set to 1024x1024 or higher. Lower the resolution, the more performance gained, at the cost of more pixelated ripples.

Target Eye:
Set to none.",
                wrap);
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.EndVertical();
        }
    }

    private void SetupRippleCamera(Camera cam)
    {
        if (cam == null)
            cam = ((LitMASWaterRippleCameraUtility)target).gameObject.AddComponent<Camera>();

        Undo.RecordObject(cam, "LitMAS Ripple Camera Setup");

        cam.orthographic = false;
        cam.fieldOfView = 5.73f;
        cam.nearClipPlane = 0.01f;
        cam.farClipPlane = 200.3f;
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = new Color(0f, 0f, 0f, 1f);
        cam.allowHDR = false;
        cam.allowMSAA = false;
        cam.useOcclusionCulling = true;
        cam.cullingMask = LayerMask.GetMask("ObserverTrigger");
        cam.stereoTargetEye = StereoTargetEyeMask.Both;

        var listener = cam.GetComponent<AudioListener>();
        if (listener) Undo.DestroyObjectImmediate(listener);

        var urp = cam.GetComponent<UniversalAdditionalCameraData>();
        if (!urp) urp = cam.gameObject.AddComponent<UniversalAdditionalCameraData>();

        // Apply URP camera settings
        urp.renderPostProcessing = false;
        urp.renderShadows = false;
        urp.antialiasing = AntialiasingMode.None;
        urp.requiresColorOption = CameraOverrideOption.Off;
        urp.requiresDepthOption = CameraOverrideOption.Off;

        // SerializedObject gives access to Stop NaNs / Dithering
        var so = new SerializedObject(urp);
        var stopNaNsProp = FindURPProp(so, "m_StopNaNs");
        var ditheringProp = FindURPProp(so, "m_Dithering");

        if (stopNaNsProp != null) stopNaNsProp.boolValue = false;
        if (ditheringProp != null) ditheringProp.boolValue = false;

        so.ApplyModifiedProperties();

        urp.cameraStack.Clear();
    }
}
#endif
