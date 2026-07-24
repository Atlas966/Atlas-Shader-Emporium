// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Force reimport: 2
Shader "AtlasShaders/LitMAS Water/LitMAS Water 3"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_Cull("_Cull", Float) = 0
		[HDR][Header(Water Attributes)]_WaterColor("Water Color", Color) = (8.47419,8.47419,8.47419,1)
		[Toggle(_ENABLEDEPTHMASKEDREFRACTION_ON)] _EnableDepthMaskedRefraction("Enable Depth Masked Refraction ", Float) = 1
		[Toggle(_ENABLESOFTINTERSECTION_ON)] _EnableSoftIntersection("Enable Soft Intersection", Float) = 0
		_SoftIntersectionIntensity("Soft Intersection Intensity", Range( 0 , 2)) = 0.2
		[Toggle(_ENABLECAMERADEPTHFADING_ON)] _EnableCameraDepthFading("Enable Camera Depth Fading", Float) = 1
		_CDFalloff("Falloff", Range( 0 , 0.5)) = 0.05
		_CDDistance("Distance", Range( 0 , 1)) = 0.05
		[Space(20)][Header(BRDF Lut)][Space(10)][Toggle(_BRDFMAP)] BRDFMAP("Enable BRDF map", Float) = 0
		[NoScaleOffset][SingleLineTexture]g_tBRDFMap("BRDF map", 2D) = "white" {}
		[Header(Specular)]_Smoothness("Smoothness", Range( 0 , 1)) = 0.95
		_Reflectivity("Reflectivity", Range( 0 , 5)) = 0.1
		[KeywordEnum(None,Default,ChromaticAberration)] _DistortionType("Distortion Type", Float) = 1
		_DistortionIntensity("Distortion Intensity", Range( 0 , 1)) = 0.25
		_RGBOffset("RGB Offset", Range( 0 , 10)) = 0.4
		[Header(Normals)][NoScaleOffset][Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		[Toggle(_ENABLEANTITILENORMALS_ON)] _EnableAntiTileNormals("Enable Anti-Tile Normals", Float) = 0
		_NormalTiling("Normal Tiling", Vector) = (2,2,0,0)
		_NormalIntensity("Normal Intensity", Range( 0 , 3)) = 0
		_WaterSpeedX("Water Speed X", Range( -1 , 1)) = 0.01
		_WaterSpeedY("Water Speed Y", Range( -1 , 1)) = 0.01
		[Toggle(_MICRONORMALS)] _MicroNormals("Micro Normals", Float) = 0
		[NoScaleOffset][Normal]_MicroNormalMap("Micro Normal Map", 2D) = "bump" {}
		_MicroNormalTiling("Micro Normal Tiling", Vector) = (50,50,0,0)
		_MicroNormalIntensity("Micro Normal Intensity", Range( 0 , 1)) = 0.095
		_MicroNormalSpeedX("Micro Normal Speed X", Range( -0.1 , 0.1)) = 0.05
		_MicroNormalSpeedY("Micro Normal Speed Y", Range( -0.1 , 0.1)) = 0.05
		_MicroNormalsNearFadeDistance("Micro Normals Near Fade Distance", Range( 0 , 50)) = 0
		_MicroNormalsFarFadeDistance("Micro Normals Far Fade Distance", Range( 0 , 50)) = 4
		[Toggle(_ENABLEDISTORTEDUVS)] _EnableDistortedUVs("Enable Distorted UV's", Float) = 0
		[NoScaleOffset]_Distortion("Distortion", 2D) = "white" {}
		[Toggle(_ENABLEANTITILEUVDISTORTION_ON)] _EnableAntiTileUVDistortion("Enable Anti-Tile UV Distortion", Float) = 0
		_DistortOverlayIntensity("Distort Overlay Intensity", Range( 0 , 0.5)) = 0.15
		_DistortionSpeedX("Distortion Speed X", Range( -0.5 , 0.5)) = 0
		_DistortionSpeedY("Distortion Speed Y", Range( -0.5 , 0.5)) = 0.008
		_DistortionTiling("Distortion Tiling", Vector) = (1,1,0,0)
		[Toggle(_ENABLERAINDROPRIPPLES)] _EnableRainDropRipples("Enable Rain Drop Ripples", Float) = 0
		_RainDropRippleTiling("Rain Drop Ripple Tiling", Vector) = (35,35,0,0)
		_RainDropRippleIntensity("Rain Drop Ripple Intensity", Range( 0 , 5)) = 1
		_RainDropRippleSpeed("Rain Drop Ripple Speed", Range( 0 , 32)) = 25
		_DistortedUVInfluence("Distorted UV Influence", Range( 0 , 5)) = 0.35
		[HideInInspector][NoScaleOffset][Normal]_BubbleBook("BubbleBook", 2D) = "bump" {}
		[KeywordEnum(None,GerstnerWaves,3DTexture,Gerstnerand3DTexture,Noise,DynamicRipples)] _WaveType("Wave Type", Float) = 0
		_NumberOfWaves("Number Of Waves", Range( 0 , 8)) = 8
		_Steepness("Steepness", Range( 0 , 20)) = 10
		_Wavelength("Wavelength", Range( 0 , 15)) = 2.5
		_Amplitude("Amplitude", Range( -0.5 , 0.5)) = 0.05
		_Speed("Speed", Range( -8 , 8)) = 0.35
		[Header(3D Texture Wave Settings)][NoScaleOffset]_Displacement3DTexture("Displacement 3D Texture", 3D) = "white" {}
		_DisplacementTiling("Displacement Tiling", Range( 0 , 2)) = 0.25
		_WaveSpeed("Wave Speed", Range( 0 , 5)) = 0.5
		_WaveHeight("Wave Height", Range( 0 , 5)) = 0.25
		[Header(Gerstner and 3D Tex Wave Mixing)]_MixingIntensity("Mixing Intensity", Range( -5 , 5)) = 1
		[Toggle(_ENABLEFOAM_ON)] _EnableFoam("Enable Foam", Float) = 0
		[NoScaleOffset]_FoamTexture("Foam Texture", 2D) = "white" {}
		_FoamTiling("Foam Tiling", Vector) = (25,25,0,0)
		[Toggle(_ENABLEANTITILEFOAM_ON)] _EnableAntiTileFoam("Enable Anti-Tile Foam", Float) = 1
		[HDR]_FoamColor("Foam Color", Color) = (2.996078,2.996078,2.996078,1)
		_FoamSpeedX("Foam Speed X", Range( -3 , 3)) = 0.01
		_FoamSpeedY("Foam Speed Y", Range( -3 , 3)) = 0.05
		_FoamStrength("Foam Strength", Range( 0 , 25)) = 1
		_FoamAlpha("Foam Alpha", Range( 0 , 15)) = 5
		_DistortedUVInfluence1("Distorted UV Influence", Range( 0 , 15)) = 2.5
		[Header(Foam Parallax) ][Toggle(_ENABLEFOAMPARALLAX_ON)] _EnableFoamParallax("Enable Foam Parallax", Float) = 0
		_FoamParallaxScale("Foam Parallax Scale", Range( 0 , 1)) = 0.2
		[Header(Foam Distortion) ][Toggle(_ENABLEFOAMDISTORTION_ON)] _EnableFoamDistortion("Enable Foam Distortion", Float) = 0
		_FoamDistortion("Foam Distortion", Range( 0 , 0.15)) = 0.05
		_NoiseWavesSpeed("Noise Waves Speed", Range( 0.075 , 0.5)) = 0.075
		_NoiseWavesScale("Noise Waves Scale", Range( 0 , 20)) = 10
		_NoiseWavesSize("Noise Waves Height", Range( 2 , 15)) = 8
		_NoiseWavesDirection("Noise Waves Direction", Vector) = (0,1,0,0)
		[Toggle(_ENABLEDYNAMICRIPPLES_ON)] _EnableDynamicRipples("Enable Dynamic Ripples", Float) = 0
		_DynamicRippleIntensity("Dynamic Ripple Intensity", Range( 0 , 2)) = 0.075
		_RippleRenderTexture("Ripple Render Texture", 2D) = "white" {}
		[Toggle(_DEBUGVIEW1_ON)] _DebugView1("Debug View", Float) = 0
		_DebugContrast1("Debug Contrast", Range( 0 , 1)) = 0.5
		_DynamicRippleWaveHeight("Dynamic Ripple Wave Height", Range( 0 , 1)) = 0.25
		[Toggle(_ENABLEFLOWMAPPEDUVS_ON)] _EnableFlowmappedUVs("Enable Flowmapped UV's", Float) = 0
		[NoScaleOffset][Normal]_Flowmap("Flowmap", 2D) = "white" {}
		_FlowSpeed("Flow Speed", Range( -5 , 5)) = 0.6
		_Strength("Strength", Range( 0 , 1)) = 0.35
		[Toggle(_DEBUGVIEW_ON)] _DebugView("Debug View", Float) = 0
		_DebugContrast("Debug Contrast", Range( 0 , 1)) = 0.5
		[Toggle(_ENABLEDEPTHCOLORS_ON)] _EnableDepthColors("Enable Depth Colors", Float) = 0
		[KeywordEnum(RegularRecommended,DistanceBased)] _DepthColorMode("Depth Color Mode", Float) = 0
		_ShallowColor("Shallow Color", Color) = (0,0.4078431,0.4352941,1)
		_DeepColor("Deep Color", Color) = (0,0.627451,0.7176471,1)
		_WaterDepth("Water Depth", Range( -1 , 1)) = 1
		_DepthTranslucency("Depth Translucency", Range( 0 , 0.2)) = 0.03
		_DepthColor("Depth Color", Color) = (0.2313726,0.4352941,0.5490196,1)
		_Clarity("Clarity", Range( 0.01 , 1)) = 0.7
		_Murkiness("Murkiness", Range( 0.01 , 1)) = 0.7
		[Toggle(_ENABLEPOSTPROCESSING_ON)] _EnablePostProcessing("Enable Post Processing", Float) = 0
		[Toggle(_GRAYSCALE_ON)] _Grayscale("Grayscale", Float) = 0
		[Toggle(_SATURATION_ON)] _Saturation("Saturation", Float) = 0
		_SaturationIntensity("Saturation Intensity", Range( 0 , 10)) = 1.25
		[Toggle(_CONTRAST_ON)] _Contrast("Contrast", Float) = 0
		_ContrastIntensity("Contrast Intensity", Range( 0 , 3)) = 1.1
		[Toggle(_POSTERIZE_ON)] _Posterize("Posterize", Float) = 0
		_PosterizationIntensity("Posterization Intensity", Range( 1 , 100)) = 25
		[Toggle(_MIDTONES_ON)] _Midtones("Midtones", Float) = 0
		_Red("Red", Range( -10 , 10)) = 0
		_Green("Green", Range( -10 , 10)) = 0
		_Blue("Blue", Range( -10 , 10)) = 0
		[Toggle(_ENABLEALPHAMASKING_ON)] _EnableAlphaMasking("Enable Alpha Masking", Float) = 0
		[NoScaleOffset]_AlphaMask("Alpha Mask", 2D) = "white" {}
		[ASEEnd]_AlphaFalloff("Alpha Falloff", Range( 0 , 3)) = 0.25
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		[Space(30)][Header(Screen Space Reflections)][Space(10)][Toggle(_NO_SSR)] _SSROff("Disable SSR", Float) = 0
		[Header(This should be 0 for skinned meshes)]
		_SSRTemporalMul("Temporal Accumulation Factor", Range(0, 2)) = 1.0
		//[Toggle(_SM6_QUAD)] _SM6_Quad("Quad-avg SSR", Float) = 0


	}
	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite On
		Cull [_Cull]
		ZTest LEqual
		Offset 0 , 0
		ColorMask RGBA
		//LOD 100
		

		
		Pass
		{

			

			Name "Forward"
			Tags { "Lightmode"="UniversalForward" }
			
			HLSLPROGRAM
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _SLZ_SPECULAR_SETUP
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define ASE_SRP_VERSION -1
			#define REQUIRE_OPAQUE_TEXTURE 1
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0

			
			#define LITMAS_FEATURE_TS_NORMALS
			
			#define LITMAS_FEATURE_SSR
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			#if defined(SHADER_API_DESKTOP)
			
			
			
			
			#endif

			//StandardForward------------------------------------------------------------------------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//
			//
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
					
					
			#define SHADERPASS SHADERPASS_FORWARD
			#define _NORMAL_DROPOFF_TS 1
			#define _EMISSION
			#define _NORMALMAP 1
					
			#if defined(SHADER_API_MOBILE)
			#if defined(MOBILE_LIGHTS_VERTEX)
				#define _ADDITIONAL_LIGHTS_VERTEX
			#endif
					
			#if defined(MOBILE_RECEIVE_SHADOWS)
				#undef _RECEIVE_SHADOWS_OFF
				#define _MAIN_LIGHT_SHADOWS
				#define _ADDITIONAL_LIGHT_SHADOWS
				#pragma multi_compile_fragment  _  _MAIN_LIGHT_SHADOWS_CASCADE
				#pragma multi_compile_fragment _ _ADDITIONAL_LIGHTS
				#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
				#define _SHADOWS_SOFT 1
			#else
				#define _RECEIVE_SHADOWS_OFF 1
			#endif
					
			#if defined(MOBILE_SSAO)
				#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#endif
					
			#if defined(MOBILE_REFLECTION_PROBE_BLENDING)
				#define _REFLECTION_PROBE_BLENDING
			#endif
					
			#if defined(MOBILE_REFLECTION_PROBE_BOX_PROJECTION)
				#define _REFLECTION_PROBE_BOX_PROJECTION 
			#endif
						
			#else
					
			//#define DYNAMIC_SCREEN_SPACE_OCCLUSION
			#if defined(PC_SSAO)
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#endif
					
			//#define DYNAMIC_ADDITIONAL_LIGHTS
			#if defined(PC_RECEIVE_SHADOWS)
				#undef _RECEIVE_SHADOWS_OFF
				#pragma multi_compile_fragment  _  _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHTS
					
					
			//#define DYNAMIC_ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
					
				#define _SHADOWS_SOFT 1
			#else
				#define _RECEIVE_SHADOWS_OFF 1
			#endif
					
			#if defined(PC_REFLECTION_PROBE_BLENDING)
				#define _REFLECTION_PROBE_BLENDING
			#endif
				//#pragma shader_feature_fragment _REFLECTION_PROBE_BOX_PROJECTION
				// We don't need a keyword for this! the w component of the probe position already branches box vs non-box, & so little cost on pc it doesn't matter
			#if defined(PC_REFLECTION_PROBE_BOX_PROJECTION)
				#define _REFLECTION_PROBE_BOX_PROJECTION 
			#endif
					
			// Begin Injection STANDALONE_DEFINES from Injection_SSR.hlsl ----------------------------------------------------------
			#pragma multi_compile _ _SLZ_SSR_ENABLED
			#pragma shader_feature_local _ _NO_SSR
			#if defined(_SLZ_SSR_ENABLED) && !defined(_NO_SSR) && !defined(SHADER_API_MOBILE)
				#define _SSR_ENABLED
			#endif
			// End Injection STANDALONE_DEFINES from Injection_SSR.hlsl ----------------------------------------------------------
					
			#endif
					
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			//#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			//#pragma multi_compile_fog
			//#pragma skip_variants FOG_LINEAR FOG_EXP
			//#pragma multi_compile_fragment _ DEBUG_DISPLAY
			//#pragma multi_compile_fragment _ _DETAILS_ON
			//#pragma multi_compile_fragment _ _EMISSION_ON
					
					
			#if defined(LITMAS_FEATURE_LIGHTMAPPING)
				#pragma multi_compile _ LIGHTMAP_ON
				#pragma multi_compile _ DYNAMICLIGHTMAP_ON
				#pragma multi_compile _ DIRLIGHTMAP_COMBINED
				#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#endif
					
					
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
			#undef UNITY_DECLARE_DEPTH_TEXTURE_INCLUDED
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZLighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"
					
			// Begin Injection INCLUDES from Injection_SSR.hlsl ----------------------------------------------------------
			#if !defined(SHADER_API_MOBILE)
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZLightingSSR.hlsl"
			#endif
			// End Injection INCLUDES from Injection_SSR.hlsl ----------------------------------------------------------
					
					
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _WAVETYPE_NONE _WAVETYPE_GERSTNERWAVES _WAVETYPE_3DTEXTURE _WAVETYPE_GERSTNERAND3DTEXTURE _WAVETYPE_NOISE _WAVETYPE_DYNAMICRIPPLES
			#pragma shader_feature_local _ENABLEDYNAMICRIPPLES_ON
			#pragma shader_feature_local _DEBUGVIEW1_ON
			#pragma shader_feature_local _DEBUGVIEW_ON
			#pragma shader_feature_local _ENABLEFOAM_ON
			#pragma shader_feature_local _ENABLEPOSTPROCESSING_ON
			#pragma shader_feature_local _ENABLEDEPTHCOLORS_ON
			#pragma shader_feature_local _DISTORTIONTYPE_NONE _DISTORTIONTYPE_DEFAULT _DISTORTIONTYPE_CHROMATICABERRATION
			#pragma shader_feature_local _ENABLEDEPTHMASKEDREFRACTION_ON
			#pragma shader_feature_local _ENABLEFLOWMAPPEDUVS_ON
			#pragma shader_feature_local _ENABLEDISTORTEDUVS
			#pragma shader_feature_local _ENABLEANTITILEUVDISTORTION_ON
			#pragma shader_feature_local _ENABLERAINDROPRIPPLES
			#pragma shader_feature_local _DEPTHCOLORMODE_REGULARRECOMMENDED _DEPTHCOLORMODE_DISTANCEBASED
			#pragma shader_feature_local _GRAYSCALE_ON
			#pragma shader_feature_local _MIDTONES_ON
			#pragma shader_feature_local _POSTERIZE_ON
			#pragma shader_feature_local _CONTRAST_ON
			#pragma shader_feature_local _SATURATION_ON
			#pragma shader_feature_local _ENABLEANTITILEFOAM_ON
			#pragma shader_feature_local _ENABLEFOAMDISTORTION_ON
			#pragma shader_feature_local _ENABLEFOAMPARALLAX_ON
			#pragma shader_feature_local _MICRONORMALS
			#pragma shader_feature_local _ENABLEANTITILENORMALS_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEALPHAMASKING_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON

					
			struct VertIn
			{
				float4 vertex   : POSITION;
				float3 normal    : NORMAL;
				float4 tangent   : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct VertOut
			{
				float4 vertex       : SV_POSITION;
				float4 uv0XY_bitZ_fog : TEXCOORD0;
			#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				float4 uv1 : TEXCOORD1;
			#endif
				half4 SHVertLights : TEXCOORD2;
				half4 normXYZ_tanX : TEXCOORD3;
				float3 wPos : TEXCOORD4;
			
			// Begin Injection INTERPOLATORS from Injection_SSR.hlsl ----------------------------------------------------------
				float4 lastVertex : TEXCOORD5;
			// End Injection INTERPOLATORS from Injection_SSR.hlsl ----------------------------------------------------------
			// Begin Injection INTERPOLATORS from Injection_NormalMaps.hlsl ----------------------------------------------------------
				half4 tanYZ_bitXY : TEXCOORD6;
			// End Injection INTERPOLATORS from Injection_NormalMaps.hlsl ----------------------------------------------------------
			
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_texcoord10 : TEXCOORD10;
				UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
			};
			
			//TEXTURE2D(_BaseMap);
			//SAMPLER(sampler_BaseMap);
			
			//TEXTURE2D(_BumpMap);
			//TEXTURE2D(_MetallicGlossMap);
			
			//TEXTURE2D(_DetailMap);
			//SAMPLER(sampler_DetailMap);
			
			// Begin Injection UNIFORMS from Injection_Emission.hlsl ----------------------------------------------------------
			//TEXTURE2D(_EmissionMap);
			// End Injection UNIFORMS from Injection_Emission.hlsl ----------------------------------------------------------
			
			CBUFFER_START(UnityPerMaterial)
				float4 _DepthColor;
				float4 _DeepColor;
				float4 _ShallowColor;
				float4 _WaterColor;
				float4 _RippleRenderTexture_TexelSize;
				float4 _RippleRenderTexture_ST;
				float4 _FoamColor;
				float4 _FoamTexture_ST;
				float2 _DistortionTiling;
				float2 _NormalTiling;
				float2 _FoamTiling;
				float2 _RainDropRippleTiling;
				float2 _MicroNormalTiling;
				float2 _NoiseWavesDirection;
				float _FoamStrength;
				float _Blue;
				float _Green;
				float _Red;
				float _FoamSpeedX;
				float _PosterizationIntensity;
				float _ContrastIntensity;
				float _SaturationIntensity;
				float _FoamSpeedY;
				float _FoamDistortion;
				float _FoamParallaxScale;
				float _FoamAlpha;
				float _DebugContrast;
				float _DebugContrast1;
				float _MicroNormalSpeedX;
				float _MicroNormalIntensity;
				float _MicroNormalsNearFadeDistance;
				float _MicroNormalsFarFadeDistance;
				float _MicroNormalSpeedY;
				float _Cull;
				float _Reflectivity;
				float _Smoothness;
				float _SoftIntersectionIntensity;
				float _AlphaFalloff;
				float _DistortedUVInfluence1;
				float _DepthTranslucency;
				float _Steepness;
				float _Murkiness;
				float _Wavelength;
				float _Amplitude;
				float _NumberOfWaves;
				float _Speed;
				float _DisplacementTiling;
				float _WaveSpeed;
				float _WaveHeight;
				float _MixingIntensity;
				float _NoiseWavesSpeed;
				float _NoiseWavesScale;
				float _NoiseWavesSize;
				float _DynamicRippleWaveHeight;
				float _DistortionIntensity;
				float _WaterDepth;
				float _WaterSpeedX;
				float _DistortionSpeedX;
				float _DistortionSpeedY;
				float _Strength;
				float _FlowSpeed;
				float _NormalIntensity;
				float _WaterSpeedY;
				float _RainDropRippleSpeed;
				float _DistortedUVInfluence;
				float _RainDropRippleIntensity;
				float _DynamicRippleIntensity;
				float _RGBOffset;
				float _Clarity;
				float _CDFalloff;
				float _DistortOverlayIntensity;
				float _CDDistance;
				//float4 _BaseMap_ST;
				//half4 _BaseColor;
			// Begin Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			//float4 _DetailMap_ST;
			//half  _Details;
			//half  _Normals;
			// End Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
				float _SSRTemporalMul;
			// End Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_Emission.hlsl ----------------------------------------------------------
				//half  _Emission;
				//half4 _EmissionColor;
				//half  _EmissionFalloff;
				//half  _BakedMutiplier;
			// End Injection MATERIAL_CBUFFER from Injection_Emission.hlsl ----------------------------------------------------------
				//int _Surface;
			CBUFFER_END
			sampler3D _Displacement3DTexture;
			sampler2D _RippleRenderTexture;
			sampler2D _NormalMap;
			sampler2D _Distortion;
			sampler2D _Flowmap;
			sampler2D _BubbleBook;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _FoamTexture;
			sampler2D _MicroNormalMap;
			sampler2D _AlphaMask;

			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			
			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			inline float3 MyCustomExpression( half4 In0 )
			{
				return UnpackNormal(In0);;
			}
			
			float3 CombineSamplesSharp128_g1862( float S0, float S1, float S2, float Strength )
			{
				{
				    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
				    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
				    return normalize( cross( va, vb ) );
				}
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			float RBGToLuminance2_g1886( float3 Color )
			{
				float fmin = min(min(Color.r, Color.g), Color.b);
				float fmax = max(max(Color.r, Color.g), Color.b);
				return (fmax + fmin) / 2.0;
			}
			
			inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
			{
				float3 result = 0;
				int stepIndex = 0;
				int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
				float layerHeight = 1.0 / numSteps;
				float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
				uvs.xy += refPlane * plane;
				float2 deltaTex = -plane * layerHeight;
				float2 prevTexOffset = 0;
				float prevRayZ = 1.0f;
				float prevHeight = 0.0f;
				float2 currTexOffset = deltaTex;
				float currRayZ = 1.0f - layerHeight;
				float currHeight = 0.0f;
				float intersection = 0;
				float2 finalTexOffset = 0;
				while ( stepIndex < numSteps + 1 )
				{
				 	currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r;
				 	if ( currHeight > currRayZ )
				 	{
				 	 	stepIndex = numSteps + 1;
				 	}
				 	else
				 	{
				 	 	stepIndex++;
				 	 	prevTexOffset = currTexOffset;
				 	 	prevRayZ = currRayZ;
				 	 	prevHeight = currHeight;
				 	 	currTexOffset += deltaTex;
				 	 	currRayZ -= layerHeight;
				 	}
				}
				int sectionSteps = 2;
				int sectionIndex = 0;
				float newZ = 0;
				float newHeight = 0;
				while ( sectionIndex < sectionSteps )
				{
				 	intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				 	finalTexOffset = prevTexOffset + intersection * deltaTex;
				 	newZ = prevRayZ - intersection * layerHeight;
				 	newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
				 	if ( newHeight > newZ )
				 	{
				 	 	currTexOffset = finalTexOffset;
				 	 	currHeight = newHeight;
				 	 	currRayZ = newZ;
				 	 	deltaTex = intersection * deltaTex;
				 	 	layerHeight = intersection * layerHeight;
				 	}
				 	else
				 	{
				 	 	prevTexOffset = finalTexOffset;
				 	 	prevHeight = newHeight;
				 	 	prevRayZ = newZ;
				 	 	deltaTex = ( 1 - intersection ) * deltaTex;
				 	 	layerHeight = ( 1 - intersection ) * layerHeight;
				 	}
				 	sectionIndex++;
				}
				return uvs.xy + finalTexOffset;
			}
			
			
			half3 OverlayBlendDetail(half source, half3 destination)
			{
				half3 switch0 = round(destination); // if destination >= 0.5 then 1, else 0 assuming 0-1 input
				half3 blendGreater = mad(mad(2.0, destination, -2.0), 1.0 - source, 1.0); // (2.0 * destination - 2.0) * ( 1.0 - source) + 1.0
				half3 blendLesser = (2.0 * source) * destination;
				return mad(switch0, blendGreater, mad(-switch0, blendLesser, blendLesser)); // switch0 * blendGreater + (1 - switch0) * blendLesser 
				//return half3(destination.r > 0.5 ? blendGreater.r : blendLesser.r,
				//             destination.g > 0.5 ? blendGreater.g : blendLesser.g,
				//             destination.b > 0.5 ? blendGreater.b : blendLesser.b
				//            );
			}
			
			
			VertOut vert(VertIn v  )
			{
				VertOut o = (VertOut)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			
				float temp_output_15_0_g1860 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1860 = _Amplitude;
				float temp_output_1142_0 = ( _NumberOfWaves * -1.0 );
				float temp_output_58_0_g1860 = ( ( _Steepness / ( ( temp_output_15_0_g1860 * temp_output_26_0_g1860 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1860 );
				float3 temp_output_5_0_g1860 = (float4(1,0.8896552,0,1)).rgb;
				float3 normalizeResult4_g1860 = normalize( temp_output_5_0_g1860 );
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 transform69_g1860 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1860 = dot( normalizeResult4_g1860 , (transform69_g1860).xyz );
				float temp_output_21_0_g1860 = ( ( dotResult11_g1860 * temp_output_15_0_g1860 ) + ( ( _Speed * temp_output_15_0_g1860 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1860 = cos( temp_output_21_0_g1860 );
				float4 appendResult54_g1860 = (float4(( temp_output_58_0_g1860 * ( (temp_output_5_0_g1860).x * temp_output_62_0_g1860 ) ) , ( temp_output_58_0_g1860 * ( temp_output_62_0_g1860 * (temp_output_5_0_g1860).y ) ) , ( sin( temp_output_21_0_g1860 ) * ( temp_output_26_0_g1860 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1857 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1857 = _Amplitude;
				float temp_output_58_0_g1857 = ( ( _Steepness / ( ( temp_output_15_0_g1857 * temp_output_26_0_g1857 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1857 );
				float3 temp_output_5_0_g1857 = (( float4(0.7379313,0,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1857 = normalize( temp_output_5_0_g1857 );
				float4 transform69_g1857 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1857 = dot( normalizeResult4_g1857 , (transform69_g1857).xyz );
				float temp_output_21_0_g1857 = ( ( dotResult11_g1857 * temp_output_15_0_g1857 ) + ( ( _Speed * temp_output_15_0_g1857 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1857 = cos( temp_output_21_0_g1857 );
				float4 appendResult54_g1857 = (float4(( temp_output_58_0_g1857 * ( (temp_output_5_0_g1857).x * temp_output_62_0_g1857 ) ) , ( temp_output_58_0_g1857 * ( temp_output_62_0_g1857 * (temp_output_5_0_g1857).y ) ) , ( sin( temp_output_21_0_g1857 ) * ( temp_output_26_0_g1857 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1858 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1858 = _Amplitude;
				float temp_output_58_0_g1858 = ( ( _Steepness / ( ( temp_output_15_0_g1858 * temp_output_26_0_g1858 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1858 );
				float3 temp_output_5_0_g1858 = (( float4(0,0.9586205,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1858 = normalize( temp_output_5_0_g1858 );
				float4 transform69_g1858 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1858 = dot( normalizeResult4_g1858 , (transform69_g1858).xyz );
				float temp_output_21_0_g1858 = ( ( dotResult11_g1858 * temp_output_15_0_g1858 ) + ( ( _Speed * temp_output_15_0_g1858 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1858 = cos( temp_output_21_0_g1858 );
				float4 appendResult54_g1858 = (float4(( temp_output_58_0_g1858 * ( (temp_output_5_0_g1858).x * temp_output_62_0_g1858 ) ) , ( temp_output_58_0_g1858 * ( temp_output_62_0_g1858 * (temp_output_5_0_g1858).y ) ) , ( sin( temp_output_21_0_g1858 ) * ( temp_output_26_0_g1858 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1859 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1859 = _Amplitude;
				float temp_output_58_0_g1859 = ( ( _Steepness / ( ( temp_output_15_0_g1859 * temp_output_26_0_g1859 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1859 );
				float3 temp_output_5_0_g1859 = (( float4(1,0.4344828,0,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1859 = normalize( temp_output_5_0_g1859 );
				float4 transform69_g1859 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1859 = dot( normalizeResult4_g1859 , (transform69_g1859).xyz );
				float temp_output_21_0_g1859 = ( ( dotResult11_g1859 * temp_output_15_0_g1859 ) + ( ( _Speed * temp_output_15_0_g1859 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1859 = cos( temp_output_21_0_g1859 );
				float4 appendResult54_g1859 = (float4(( temp_output_58_0_g1859 * ( (temp_output_5_0_g1859).x * temp_output_62_0_g1859 ) ) , ( temp_output_58_0_g1859 * ( temp_output_62_0_g1859 * (temp_output_5_0_g1859).y ) ) , ( sin( temp_output_21_0_g1859 ) * ( temp_output_26_0_g1859 * 2.0 ) ) , 0.0));
				float4 GerstnerWaves1121 = ( appendResult54_g1860 + appendResult54_g1857 + appendResult54_g1858 + appendResult54_g1859 );
				float mulTime1086 = _TimeParameters.x * _WaveSpeed;
				float3 appendResult1085 = (float3(( ase_worldPos.x * _DisplacementTiling ) , ( ase_worldPos.z * _DisplacementTiling ) , mulTime1086));
				float4 ThreeDTexture1090 = ( tex3Dlod( _Displacement3DTexture, float4( appendResult1085, 0.0) ) * float4( ( float3(0,1,0) * (0.0 + (_WaveHeight - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) ) , 0.0 ) );
				float4 MixedWaves1107 = ( ( GerstnerWaves1121 * _MixingIntensity ) + ( ThreeDTexture1090 * _MixingIntensity ) );
				float mulTime1521 = _TimeParameters.x * _NoiseWavesSpeed;
				float2 texCoord1513 = v.uv0.xy * float2( 1,1 ) + ( mulTime1521 * _NoiseWavesDirection );
				float simplePerlin2D1541 = snoise( texCoord1513*_NoiseWavesScale );
				simplePerlin2D1541 = simplePerlin2D1541*0.5 + 0.5;
				float NoiseWaves1548 = (0.0 + (simplePerlin2D1541 - 0.0) * (1.0 - 0.0) / (_NoiseWavesSize - 0.0));
				float4 temp_cast_7 = (NoiseWaves1548).xxxx;
				float2 uv_RippleRenderTexture = v.uv0.xy * _RippleRenderTexture_ST.xy + _RippleRenderTexture_ST.zw;
				float4 tex2DNode1574 = tex2Dlod( _RippleRenderTexture, float4( uv_RippleRenderTexture, 0, 0.0) );
				#ifdef _ENABLEDYNAMICRIPPLES_ON
				float staticSwitch2073 = ( tex2DNode1574.r * ( _DynamicRippleWaveHeight * 0.1 ) );
				#else
				float staticSwitch2073 = 0.0;
				#endif
				float DynamicRippleWaves1750 = staticSwitch2073;
				float4 temp_cast_8 = (DynamicRippleWaves1750).xxxx;
				#if defined(_WAVETYPE_NONE)
				float4 staticSwitch1066 = float4( 0,0,0,0 );
				#elif defined(_WAVETYPE_GERSTNERWAVES)
				float4 staticSwitch1066 = GerstnerWaves1121;
				#elif defined(_WAVETYPE_3DTEXTURE)
				float4 staticSwitch1066 = ThreeDTexture1090;
				#elif defined(_WAVETYPE_GERSTNERAND3DTEXTURE)
				float4 staticSwitch1066 = MixedWaves1107;
				#elif defined(_WAVETYPE_NOISE)
				float4 staticSwitch1066 = temp_cast_7;
				#elif defined(_WAVETYPE_DYNAMICRIPPLES)
				float4 staticSwitch1066 = temp_cast_8;
				#else
				float4 staticSwitch1066 = float4( 0,0,0,0 );
				#endif
				float4 Waves2060 = staticSwitch1066;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord7 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.x = eyeDepth;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.tangent.xyz);
				o.ase_texcoord8.yzw = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.normal);
				o.ase_texcoord9.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord10.xyz = ase_worldBitangent;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.w = 0;
				o.ase_texcoord10.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Waves2060.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.normal = v.normal;
			
				o.wPos = TransformObjectToWorld(v.vertex.xyz);
				o.vertex = TransformWorldToHClip(o.wPos);
				o.uv0XY_bitZ_fog.xy = v.uv0.xy;
			
			#if defined(LIGHTMAP_ON) || defined(DIRLIGHTMAP_COMBINED)
				OUTPUT_LIGHTMAP_UV(v.uv1.xy, unity_LightmapST, o.uv1.xy);
			#endif
			
			#ifdef DYNAMICLIGHTMAP_ON
				OUTPUT_LIGHTMAP_UV(v.uv2.xy, unity_DynamicLightmapST, o.uv1.zw);
			#endif
			
				// Exp2 fog
				half clipZ_0Far = UNITY_Z_0_FAR_FROM_CLIPSPACE(o.vertex.z);
				o.uv0XY_bitZ_fog.w = unity_FogParams.x * clipZ_0Far;
			
			// Begin Injection VERTEX_NORMALS from Injection_NormalMaps.hlsl ----------------------------------------------------------
				VertexNormalInputs ntb = GetVertexNormalInputs(v.normal, v.tangent);
				o.normXYZ_tanX = half4(ntb.normalWS, ntb.tangentWS.x);
				o.tanYZ_bitXY = half4(ntb.tangentWS.yz, ntb.bitangentWS.xy);
				o.uv0XY_bitZ_fog.z = ntb.bitangentWS.z;
			// End Injection VERTEX_NORMALS from Injection_NormalMaps.hlsl ----------------------------------------------------------
			
				o.SHVertLights = 0;
				// Calculate vertex lights and L2 probe lighting on quest 
				o.SHVertLights.xyz = VertexLighting(o.wPos, o.normXYZ_tanX.xyz);
			#if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON) && defined(SHADER_API_MOBILE)
				o.SHVertLights.xyz += SampleSHVertex(o.normXYZ_tanX.xyz);
			#endif
			
			// Begin Injection VERTEX_END from Injection_SSR.hlsl ----------------------------------------------------------
				#if defined(_SSR_ENABLED)
					float4 lastWPos = mul(GetPrevObjectToWorldMatrix(), v.vertex);
					o.lastVertex = mul(prevVP, lastWPos);
				#endif
			// End Injection VERTEX_END from Injection_SSR.hlsl ----------------------------------------------------------
				return o;
			}
			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif
			
			half4 frag(VertOut i 
				#ifdef ASE_DEPTH_WRITE_ON
				, out float outputDepth : ASE_SV_DEPTH
				#endif
				) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				float4 screenPos = i.ase_texcoord7;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 temp_cast_0 = (_WaterSpeedX).xx;
				float2 texCoord576 = i.uv0XY_bitZ_fog.xy * _NormalTiling + float2( 0,0 );
				float2 panner573 = ( 1.0 * _Time.y * temp_cast_0 + texCoord576);
				float2 appendResult705 = (float2(( _DistortionSpeedX * _TimeParameters.x ) , ( _DistortionSpeedY * _TimeParameters.x )));
				float2 texCoord602 = i.uv0XY_bitZ_fog.xy * _DistortionTiling + appendResult705;
				float localStochasticTiling2_g1856 = ( 0.0 );
				float2 Input_UV145_g1856 = texCoord602;
				float2 UV2_g1856 = Input_UV145_g1856;
				float2 UV12_g1856 = float2( 0,0 );
				float2 UV22_g1856 = float2( 0,0 );
				float2 UV32_g1856 = float2( 0,0 );
				float W12_g1856 = 0.0;
				float W22_g1856 = 0.0;
				float W32_g1856 = 0.0;
				StochasticTiling( UV2_g1856 , UV12_g1856 , UV22_g1856 , UV32_g1856 , W12_g1856 , W22_g1856 , W32_g1856 );
				float2 temp_output_10_0_g1856 = ddx( Input_UV145_g1856 );
				float2 temp_output_12_0_g1856 = ddy( Input_UV145_g1856 );
				float4 Output_2D293_g1856 = ( ( tex2D( _Distortion, UV12_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W12_g1856 ) + ( tex2D( _Distortion, UV22_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W22_g1856 ) + ( tex2D( _Distortion, UV32_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W32_g1856 ) );
				#ifdef _ENABLEANTITILEUVDISTORTION_ON
				float4 staticSwitch1078 = Output_2D293_g1856;
				#else
				float4 staticSwitch1078 = tex2D( _Distortion, texCoord602 );
				#endif
				#ifdef _ENABLEDISTORTEDUVS
				float4 staticSwitch714 = ( _DistortOverlayIntensity * staticSwitch1078 );
				#else
				float4 staticSwitch714 = float4( 0,0,0,0 );
				#endif
				float4 DistortedUVs1008 = staticSwitch714;
				float2 uv_Flowmap1838 = i.uv0XY_bitZ_fog.xy;
				float3 tex2DNode1838 = UnpackNormalScale( tex2D( _Flowmap, uv_Flowmap1838 ), 1.0f );
				float2 appendResult1833 = (float2(tex2DNode1838.r , tex2DNode1838.g));
				float2 temp_output_1874_0 = ( -appendResult1833 * ( _Strength * -1.0 ) );
				float temp_output_1835_0 = ( _TimeParameters.x * _FlowSpeed );
				float temp_output_1851_0 = frac( temp_output_1835_0 );
				float2 FlowUVA1933 = ( temp_output_1874_0 * ( temp_output_1851_0 - 0.0 ) );
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1971 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVA1933, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1971 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float3 unpack567 = UnpackNormalScale( tex2D( _NormalMap, staticSwitch1971.rg ), _NormalIntensity );
				unpack567.z = lerp( 1, unpack567.z, saturate(_NormalIntensity) );
				float3 tex2DNode567 = unpack567;
				float2 temp_cast_5 = (_WaterSpeedY).xx;
				float2 panner572 = ( 1.0 * _Time.y * temp_cast_5 + texCoord576);
				float2 FlowUVB1934 = ( float2( 0,0 ) + ( temp_output_1874_0 * ( frac( ( temp_output_1835_0 + 0.5 ) ) - 0.0 ) ) );
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1974 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVB1934, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1974 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float3 unpack579 = UnpackNormalScale( tex2D( _NormalMap, staticSwitch1974.rg ), _NormalIntensity );
				unpack579.z = lerp( 1, unpack579.z, saturate(_NormalIntensity) );
				float3 tex2DNode579 = unpack579;
				float FlowUVAlpha1942 = abs( ( ( temp_output_1851_0 * 2.0 ) + -1.0 ) );
				float3 lerpResult1943 = lerp( tex2DNode567 , tex2DNode579 , FlowUVAlpha1942);
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float3 staticSwitch1976 = lerpResult1943;
				#else
				float3 staticSwitch1976 = BlendNormal( tex2DNode567 , tex2DNode579 );
				#endif
				float localStochasticTiling2_g102 = ( 0.0 );
				float2 texCoord797 = i.uv0XY_bitZ_fog.xy * _RainDropRippleTiling + float2( 0,0 );
				float temp_output_852_0 = ( _RainDropRippleSpeed * -1.0 );
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles809 = 1.0 * 16.0;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset809 = 1.0f / 1.0;
				float fbrowsoffset809 = 1.0f / 16.0;
				// Speed of animation
				float fbspeed809 = _TimeParameters.x * temp_output_852_0;
				// UV Tiling (col and row offset)
				float2 fbtiling809 = float2(fbcolsoffset809, fbrowsoffset809);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex809 = round( fmod( fbspeed809 + 0.0, fbtotaltiles809) );
				fbcurrenttileindex809 += ( fbcurrenttileindex809 < 0) ? fbtotaltiles809 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox809 = round ( fmod ( fbcurrenttileindex809, 1.0 ) );
				// Multiply Offset X by coloffset
				float fboffsetx809 = fblinearindextox809 * fbcolsoffset809;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy809 = round( fmod( ( fbcurrenttileindex809 - fblinearindextox809 ) / 1.0, 16.0 ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy809 = (int)(16.0-1) - fblinearindextoy809;
				// Multiply Offset Y by rowoffset
				float fboffsety809 = fblinearindextoy809 * fbrowsoffset809;
				// UV Offset
				float2 fboffset809 = float2(fboffsetx809, fboffsety809);
				// Flipbook UV
				half2 fbuv809 = texCoord797 * fbtiling809 + fboffset809;
				// *** END Flipbook UV Animation vars ***
				float2 appendResult826 = (float2(frac( fbuv809.x ) , frac( fbuv809.y )));
				float2 Input_UV145_g102 = ( float4( appendResult826, 0.0 , 0.0 ) + ( _DistortedUVInfluence * DistortedUVs1008 ) ).rg;
				float2 UV2_g102 = Input_UV145_g102;
				float2 UV12_g102 = float2( 0,0 );
				float2 UV22_g102 = float2( 0,0 );
				float2 UV32_g102 = float2( 0,0 );
				float W12_g102 = 0.0;
				float W22_g102 = 0.0;
				float W32_g102 = 0.0;
				StochasticTiling( UV2_g102 , UV12_g102 , UV22_g102 , UV32_g102 , W12_g102 , W22_g102 , W32_g102 );
				float2 temp_output_10_0_g102 = ddx( Input_UV145_g102 );
				float2 temp_output_12_0_g102 = ddy( Input_UV145_g102 );
				float4 Output_2D293_g102 = ( ( tex2D( _BubbleBook, UV12_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W12_g102 ) + ( tex2D( _BubbleBook, UV22_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W22_g102 ) + ( tex2D( _BubbleBook, UV32_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W32_g102 ) );
				float localStochasticTiling2_g103 = ( 0.0 );
				float fbtotaltiles810 = 1.0 * 16.0;
				float fbcolsoffset810 = 1.0f / 1.0;
				float fbrowsoffset810 = 1.0f / 16.0;
				float fbspeed810 = ( _TimeParameters.x - 2.0 ) * temp_output_852_0;
				float2 fbtiling810 = float2(fbcolsoffset810, fbrowsoffset810);
				float fbcurrenttileindex810 = round( fmod( fbspeed810 + 0.0, fbtotaltiles810) );
				fbcurrenttileindex810 += ( fbcurrenttileindex810 < 0) ? fbtotaltiles810 : 0;
				float fblinearindextox810 = round ( fmod ( fbcurrenttileindex810, 1.0 ) );
				float fboffsetx810 = fblinearindextox810 * fbcolsoffset810;
				float fblinearindextoy810 = round( fmod( ( fbcurrenttileindex810 - fblinearindextox810 ) / 1.0, 16.0 ) );
				fblinearindextoy810 = (int)(16.0-1) - fblinearindextoy810;
				float fboffsety810 = fblinearindextoy810 * fbrowsoffset810;
				float2 fboffset810 = float2(fboffsetx810, fboffsety810);
				half2 fbuv810 = texCoord797 * fbtiling810 + fboffset810;
				float2 appendResult828 = (float2(frac( fbuv810.x ) , frac( fbuv810.y )));
				float2 Input_UV145_g103 = ( float4( appendResult828, 0.0 , 0.0 ) + ( _DistortedUVInfluence * DistortedUVs1008 ) ).rg;
				float2 UV2_g103 = Input_UV145_g103;
				float2 UV12_g103 = float2( 0,0 );
				float2 UV22_g103 = float2( 0,0 );
				float2 UV32_g103 = float2( 0,0 );
				float W12_g103 = 0.0;
				float W22_g103 = 0.0;
				float W32_g103 = 0.0;
				StochasticTiling( UV2_g103 , UV12_g103 , UV22_g103 , UV32_g103 , W12_g103 , W22_g103 , W32_g103 );
				float2 temp_output_10_0_g103 = ddx( Input_UV145_g103 );
				float2 temp_output_12_0_g103 = ddy( Input_UV145_g103 );
				float4 Output_2D293_g103 = ( ( tex2D( _BubbleBook, UV12_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W12_g103 ) + ( tex2D( _BubbleBook, UV22_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W22_g103 ) + ( tex2D( _BubbleBook, UV32_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W32_g103 ) );
				float4 lerpResult814 = lerp( Output_2D293_g102 , Output_2D293_g103 , abs( ( ( 0.5 - frac( ( ( _TimeParameters.x / 4.0 ) + 0.5 ) ) ) / 0.5 ) ));
				float4 In02_g105 = lerpResult814;
				float3 localMyCustomExpression2_g105 = MyCustomExpression( In02_g105 );
				float3 break836 = localMyCustomExpression2_g105;
				float4 appendResult839 = (float4(( break836.x * _RainDropRippleIntensity ) , ( break836.y * _RainDropRippleIntensity ) , break836.z , 0.0));
				float4 normalizeResult840 = normalize( appendResult839 );
				#ifdef _ENABLERAINDROPRIPPLES
				float4 staticSwitch846 = normalizeResult840;
				#else
				float4 staticSwitch846 = float4( staticSwitch1976 , 0.0 );
				#endif
				float4 RainDropRipples1004 = staticSwitch846;
				float3 temp_output_747_0 = BlendNormal( staticSwitch1976 , RainDropRipples1004.xyz );
				float localCalculateUVsSharp110_g1862 = ( 0.0 );
				float2 uv_RippleRenderTexture = i.uv0XY_bitZ_fog.xy * _RippleRenderTexture_ST.xy + _RippleRenderTexture_ST.zw;
				float2 temp_output_85_0_g1862 = uv_RippleRenderTexture;
				float2 UV110_g1862 = temp_output_85_0_g1862;
				float4 TexelSize110_g1862 = _RippleRenderTexture_TexelSize;
				float2 UV0110_g1862 = float2( 0,0 );
				float2 UV1110_g1862 = float2( 0,0 );
				float2 UV2110_g1862 = float2( 0,0 );
				{
				{
				    UV110_g1862.y -= TexelSize110_g1862.y * 0.5;
				    UV0110_g1862 = UV110_g1862;
				    UV1110_g1862 = UV110_g1862 + float2( TexelSize110_g1862.x, 0 );
				    UV2110_g1862 = UV110_g1862 + float2( 0, TexelSize110_g1862.y );
				}
				}
				float4 break134_g1862 = tex2D( _RippleRenderTexture, UV0110_g1862 );
				float S0128_g1862 = break134_g1862.r;
				float4 break136_g1862 = tex2D( _RippleRenderTexture, UV1110_g1862 );
				float S1128_g1862 = break136_g1862.r;
				float4 break138_g1862 = tex2D( _RippleRenderTexture, UV2110_g1862 );
				float S2128_g1862 = break138_g1862.r;
				float temp_output_91_0_g1862 = _DynamicRippleIntensity;
				float Strength128_g1862 = temp_output_91_0_g1862;
				float3 localCombineSamplesSharp128_g1862 = CombineSamplesSharp128_g1862( S0128_g1862 , S1128_g1862 , S2128_g1862 , Strength128_g1862 );
				float3 temp_output_1565_40 = localCombineSamplesSharp128_g1862;
				float3 NormalsDynamic1571 = temp_output_1565_40;
				#ifdef _ENABLEDYNAMICRIPPLES_ON
				float3 staticSwitch2074 = BlendNormal( temp_output_747_0 , NormalsDynamic1571 );
				#else
				float3 staticSwitch2074 = temp_output_747_0;
				#endif
				float3 DistortionNormals1000 = staticSwitch2074;
				float3 temp_output_1433_0 = ( _DistortionIntensity * DistortionNormals1000 );
				float eyeDepth = i.ase_texcoord8.x;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth28_g1854 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g1854 = ( (DistortionNormals1000).xy * ( _DistortionIntensity / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g1854 - eyeDepth ) ) );
				float eyeDepth2_g1854 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g1854, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g1854 = (( float4( ( temp_output_20_0_g1854 * saturate( ( eyeDepth2_g1854 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				#ifdef _ENABLEDEPTHMASKEDREFRACTION_ON
				float4 staticSwitch1435 = float4( temp_output_32_0_g1854, 0.0 , 0.0 );
				#else
				float4 staticSwitch1435 = ( ase_grabScreenPosNorm + float4( temp_output_1433_0 , 0.0 ) );
				#endif
				float4 fetchOpaqueVal972 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( staticSwitch1435.xy ), 1.0 );
				float4 fetchOpaqueVal968 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( staticSwitch1435 - float4( ( _RGBOffset * float2( 0.002,0 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal967 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( staticSwitch1435 - float4( ( _RGBOffset * float2( 0,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal966 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( staticSwitch1435 - float4( ( _RGBOffset * float2( -0.002,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 appendResult965 = (float4(fetchOpaqueVal968.r , fetchOpaqueVal967.g , fetchOpaqueVal966.b , 0.0));
				#if defined(_DISTORTIONTYPE_NONE)
				float4 staticSwitch1014 = _WaterColor;
				#elif defined(_DISTORTIONTYPE_DEFAULT)
				float4 staticSwitch1014 = ( _WaterColor * fetchOpaqueVal972 );
				#elif defined(_DISTORTIONTYPE_CHROMATICABERRATION)
				float4 staticSwitch1014 = ( _WaterColor * appendResult965 );
				#else
				float4 staticSwitch1014 = ( _WaterColor * fetchOpaqueVal972 );
				#endif
				float4 DistortionType2035 = staticSwitch1014;
				float4 break10_g1866 = float4(1,1,1,1);
				float4 appendResult2_g1866 = (float4(break10_g1866.x , break10_g1866.y , break10_g1866.z , break10_g1866.w));
				float4 break10_g1865 = float4(0,0.5,0.5,1);
				float4 appendResult2_g1865 = (float4(break10_g1865.x , break10_g1865.y , break10_g1865.z , break10_g1865.w));
				float3 DepthColorNormals2027 = temp_output_1433_0;
				float eyeDepth2003 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( DepthColorNormals2027 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float temp_output_2010_0 = saturate( pow( ( abs( ( eyeDepth2003 - ( ase_grabScreenPos + float4( DepthColorNormals2027 , 0.0 ) ).w ) ) * _Clarity ) , 0.3 ) );
				float temp_output_9_0_g1863 = temp_output_2010_0;
				float4 lerpResult7_g1863 = lerp( appendResult2_g1866 , appendResult2_g1865 , ( temp_output_9_0_g1863 * 2.0 ));
				float4 break10_g1867 = float4(0,0,0,1);
				float4 appendResult2_g1867 = (float4(break10_g1867.x , break10_g1867.y , break10_g1867.z , break10_g1867.w));
				float4 lerpResult8_g1863 = lerp( float4( 0,0,0,0 ) , appendResult2_g1867 , temp_output_9_0_g1863);
				float4 lerpResult17_g1863 = lerp( lerpResult7_g1863 , lerpResult8_g1863 , temp_output_9_0_g1863);
				float4 lerpResult2021 = lerp( lerpResult17_g1863 , DistortionType2035 , temp_output_2010_0);
				float4 lerpResult2023 = lerp( lerpResult2021 , _DepthColor , _Murkiness);
				float4 DepthColorRegular2045 = lerpResult2023;
				float eyeDepth1718 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float temp_output_1725_0 = saturate( pow( ( eyeDepth1718 + ( _WaterDepth * 100.0 ) ) , ( _DepthTranslucency * -10.0 ) ) );
				float4 lerpResult1637 = lerp( _DeepColor , _ShallowColor , temp_output_1725_0);
				float4 lerpResult1735 = lerp( lerpResult1637 , DistortionType2035 , temp_output_1725_0);
				float4 DepthColorDistanceBased2047 = lerpResult1735;
				#if defined(_DEPTHCOLORMODE_REGULARRECOMMENDED)
				float4 staticSwitch2041 = DepthColorRegular2045;
				#elif defined(_DEPTHCOLORMODE_DISTANCEBASED)
				float4 staticSwitch2041 = DepthColorDistanceBased2047;
				#else
				float4 staticSwitch2041 = DepthColorRegular2045;
				#endif
				#ifdef _ENABLEDEPTHCOLORS_ON
				float4 staticSwitch1742 = staticSwitch2041;
				#else
				float4 staticSwitch1742 = DistortionType2035;
				#endif
				float4 ColorWithDepthColors2131 = staticSwitch1742;
				float dotResult2124 = dot( float4( float3(0.2126729,0.7151522,0.072175) , 0.0 ) , ColorWithDepthColors2131 );
				float4 temp_cast_32 = (dotResult2124).xxxx;
				float4 lerpResult2123 = lerp( temp_cast_32 , ColorWithDepthColors2131 , _SaturationIntensity);
				#ifdef _SATURATION_ON
				float4 staticSwitch2136 = lerpResult2123;
				#else
				float4 staticSwitch2136 = ColorWithDepthColors2131;
				#endif
				#ifdef _CONTRAST_ON
				float4 staticSwitch2138 = CalculateContrast(_ContrastIntensity,staticSwitch2136);
				#else
				float4 staticSwitch2138 = staticSwitch2136;
				#endif
				float div2106=256.0/float((int)_PosterizationIntensity);
				float4 posterize2106 = ( floor( staticSwitch2138 * div2106 ) / div2106 );
				#ifdef _POSTERIZE_ON
				float4 staticSwitch2152 = posterize2106;
				#else
				float4 staticSwitch2152 = staticSwitch2138;
				#endif
				float4 temp_output_25_0_g1886 = staticSwitch2152;
				float3 Color2_g1886 = temp_output_25_0_g1886.rgb;
				float localRBGToLuminance2_g1886 = RBGToLuminance2_g1886( Color2_g1886 );
				float3 appendResult17_g1886 = (float3(_Red , _Green , _Blue));
				#ifdef _MIDTONES_ON
				float4 staticSwitch2175 = saturate( ( temp_output_25_0_g1886 + float4( ( saturate( ( ( ( localRBGToLuminance2_g1886 - 0.333 ) / 0.25 ) + 0.5 ) ) * saturate( ( 0.5 + ( ( localRBGToLuminance2_g1886 + 0.333 + -1.0 ) / -0.25 ) ) ) * 0.7 * appendResult17_g1886 ) , 0.0 ) ) );
				#else
				float4 staticSwitch2175 = staticSwitch2152;
				#endif
				float grayscale2171 = Luminance(staticSwitch2175.rgb);
				float4 temp_cast_37 = (grayscale2171).xxxx;
				#ifdef _GRAYSCALE_ON
				float4 staticSwitch2172 = temp_cast_37;
				#else
				float4 staticSwitch2172 = staticSwitch2175;
				#endif
				float4 ColorPostProcess2133 = staticSwitch2172;
				#ifdef _ENABLEPOSTPROCESSING_ON
				float4 staticSwitch2098 = ColorPostProcess2133;
				#else
				float4 staticSwitch2098 = staticSwitch1742;
				#endif
				float4 Color991 = staticSwitch2098;
				float3 temp_output_5_0_g1860 = (float4(1,0.8896552,0,1)).rgb;
				float3 normalizeResult4_g1860 = normalize( temp_output_5_0_g1860 );
				float4 transform69_g1860 = mul(GetWorldToObjectMatrix(),float4( i.wPos.xyz , 0.0 ));
				float dotResult11_g1860 = dot( normalizeResult4_g1860 , (transform69_g1860).xyz );
				float temp_output_15_0_g1860 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1860 = ( ( dotResult11_g1860 * temp_output_15_0_g1860 ) + ( ( _Speed * temp_output_15_0_g1860 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1860 = cos( temp_output_21_0_g1860 );
				float Cosphase76_g1860 = temp_output_62_0_g1860;
				float temp_output_26_0_g1860 = _Amplitude;
				float temp_output_72_0_g1860 = ( Cosphase76_g1860 * temp_output_26_0_g1860 );
				float3 temp_output_5_0_g1857 = (( float4(0.7379313,0,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1857 = normalize( temp_output_5_0_g1857 );
				float4 transform69_g1857 = mul(GetWorldToObjectMatrix(),float4( i.wPos.xyz , 0.0 ));
				float dotResult11_g1857 = dot( normalizeResult4_g1857 , (transform69_g1857).xyz );
				float temp_output_15_0_g1857 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1857 = ( ( dotResult11_g1857 * temp_output_15_0_g1857 ) + ( ( _Speed * temp_output_15_0_g1857 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1857 = cos( temp_output_21_0_g1857 );
				float Cosphase76_g1857 = temp_output_62_0_g1857;
				float temp_output_26_0_g1857 = _Amplitude;
				float temp_output_72_0_g1857 = ( Cosphase76_g1857 * temp_output_26_0_g1857 );
				float3 temp_output_5_0_g1858 = (( float4(0,0.9586205,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1858 = normalize( temp_output_5_0_g1858 );
				float4 transform69_g1858 = mul(GetWorldToObjectMatrix(),float4( i.wPos.xyz , 0.0 ));
				float dotResult11_g1858 = dot( normalizeResult4_g1858 , (transform69_g1858).xyz );
				float temp_output_15_0_g1858 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1858 = ( ( dotResult11_g1858 * temp_output_15_0_g1858 ) + ( ( _Speed * temp_output_15_0_g1858 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1858 = cos( temp_output_21_0_g1858 );
				float Cosphase76_g1858 = temp_output_62_0_g1858;
				float temp_output_26_0_g1858 = _Amplitude;
				float temp_output_72_0_g1858 = ( Cosphase76_g1858 * temp_output_26_0_g1858 );
				float3 temp_output_5_0_g1859 = (( float4(1,0.4344828,0,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1859 = normalize( temp_output_5_0_g1859 );
				float4 transform69_g1859 = mul(GetWorldToObjectMatrix(),float4( i.wPos.xyz , 0.0 ));
				float dotResult11_g1859 = dot( normalizeResult4_g1859 , (transform69_g1859).xyz );
				float temp_output_15_0_g1859 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1859 = ( ( dotResult11_g1859 * temp_output_15_0_g1859 ) + ( ( _Speed * temp_output_15_0_g1859 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1859 = cos( temp_output_21_0_g1859 );
				float Cosphase76_g1859 = temp_output_62_0_g1859;
				float temp_output_26_0_g1859 = _Amplitude;
				float temp_output_72_0_g1859 = ( Cosphase76_g1859 * temp_output_26_0_g1859 );
				float temp_output_1148_0 = ( ( temp_output_72_0_g1860 * (normalizeResult4_g1860).x ) + ( temp_output_72_0_g1857 * (normalizeResult4_g1857).x ) + ( temp_output_72_0_g1858 * (normalizeResult4_g1858).x ) + ( temp_output_72_0_g1859 * (normalizeResult4_g1859).x ) );
				float total_dXdY1168 = temp_output_1148_0;
				float temp_output_1157_0 = ( ( temp_output_72_0_g1860 * (normalizeResult4_g1860).z ) + ( temp_output_72_0_g1857 * (normalizeResult4_g1857).z ) + ( temp_output_72_0_g1858 * (normalizeResult4_g1858).z ) + ( temp_output_72_0_g1859 * (normalizeResult4_g1859).z ) );
				float total_dYdZ1169 = temp_output_1157_0;
				float2 appendResult1172 = (float2(total_dXdY1168 , total_dYdZ1169));
				float smoothstepResult1201 = smoothstep( 0.015 , 0.06 , ( length( appendResult1172 ) * _FoamStrength ));
				float FoamMask1239 = saturate( smoothstepResult1201 );
				float2 appendResult1195 = (float2(( _FoamSpeedX * _TimeParameters.x ) , ( _FoamSpeedY * _TimeParameters.x )));
				float2 texCoord1186 = i.uv0XY_bitZ_fog.xy * _FoamTiling + appendResult1195;
				float4 temp_output_1283_0 = ( float4( texCoord1186, 0.0 , 0.0 ) + ( _DistortedUVInfluence1 * DistortedUVs1008 ) );
				float4 texCoord1344 = float4(i.uv0XY_bitZ_fog.xy,0,0);
				texCoord1344.xy = float4(i.uv0XY_bitZ_fog.xy,0,0).xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_worldTangent = i.ase_texcoord8.yzw;
				float3 ase_worldNormal = i.ase_texcoord9.xyz;
				float3 ase_worldBitangent = i.ase_texcoord10.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - i.wPos.xyz );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 OffsetPOM1345 = POM( _FoamTexture, texCoord1344.xy, ddx(texCoord1344.xy), ddy(texCoord1344.xy), ase_worldNormal, ase_worldViewDir, ase_tanViewDir, 8, 8, _FoamParallaxScale, 0, _FoamTexture_ST.xy, float2(0,0), 0 );
				#ifdef _ENABLEFOAMPARALLAX_ON
				float4 staticSwitch1352 = ( float4( OffsetPOM1345, 0.0 , 0.0 ) + temp_output_1283_0 );
				#else
				float4 staticSwitch1352 = temp_output_1283_0;
				#endif
				float2 texCoord1368 = i.uv0XY_bitZ_fog.xy * float2( -5,-5 ) + float2( 0,0 );
				#ifdef _ENABLEFOAMDISTORTION_ON
				float4 staticSwitch1361 = ( tex2D( _FoamTexture, ( staticSwitch1352 + float4( texCoord1368, 0.0 , 0.0 ) ).rg ) * _FoamDistortion );
				#else
				float4 staticSwitch1361 = staticSwitch1352;
				#endif
				float4 tex2DNode1184 = tex2D( _FoamTexture, staticSwitch1361.rg );
				float4 WaterColor1270 = _WaterColor;
				float localStochasticTiling2_g147 = ( 0.0 );
				float2 Input_UV145_g147 = staticSwitch1361.rg;
				float2 UV2_g147 = Input_UV145_g147;
				float2 UV12_g147 = float2( 0,0 );
				float2 UV22_g147 = float2( 0,0 );
				float2 UV32_g147 = float2( 0,0 );
				float W12_g147 = 0.0;
				float W22_g147 = 0.0;
				float W32_g147 = 0.0;
				StochasticTiling( UV2_g147 , UV12_g147 , UV22_g147 , UV32_g147 , W12_g147 , W22_g147 , W32_g147 );
				float2 temp_output_10_0_g147 = ddx( Input_UV145_g147 );
				float2 temp_output_12_0_g147 = ddy( Input_UV145_g147 );
				float4 Output_2D293_g147 = ( ( tex2D( _FoamTexture, UV12_g147, temp_output_10_0_g147, temp_output_12_0_g147 ) * W12_g147 ) + ( tex2D( _FoamTexture, UV22_g147, temp_output_10_0_g147, temp_output_12_0_g147 ) * W22_g147 ) + ( tex2D( _FoamTexture, UV32_g147, temp_output_10_0_g147, temp_output_12_0_g147 ) * W32_g147 ) );
				#ifdef _ENABLEANTITILEFOAM_ON
				float4 staticSwitch1243 = ( FoamMask1239 * _FoamColor * Output_2D293_g147 * WaterColor1270 );
				#else
				float4 staticSwitch1243 = ( FoamMask1239 * _FoamColor * tex2DNode1184 * WaterColor1270 );
				#endif
				float4 break31_g147 = Output_2D293_g147;
				float temp_output_1217_0 = ( FoamMask1239 * pow( break31_g147.a , _FoamAlpha ) );
				float temp_output_1234_0 = ( FoamMask1239 * pow( tex2DNode1184.a , _FoamAlpha ) );
				#ifdef _ENABLEANTITILEFOAM_ON
				float staticSwitch1260 = ( ( temp_output_1234_0 * 0.0 ) + temp_output_1217_0 );
				#else
				float staticSwitch1260 = ( ( temp_output_1217_0 * 0.0 ) + temp_output_1234_0 );
				#endif
				float FoamAlpha1245 = staticSwitch1260;
				float4 lerpResult1198 = lerp( Color991 , staticSwitch1243 , FoamAlpha1245);
				float4 Foam1267 = lerpResult1198;
				#ifdef _ENABLEFOAM_ON
				float4 staticSwitch1266 = Foam1267;
				#else
				float4 staticSwitch1266 = staticSwitch2098;
				#endif
				float3 DebugFlowmap2077 = tex2DNode1838;
				float4 lerpResult2085 = lerp( staticSwitch1266 , float4( DebugFlowmap2077 , 0.0 ) , _DebugContrast);
				#ifdef _DEBUGVIEW_ON
				float4 staticSwitch2082 = lerpResult2085;
				#else
				float4 staticSwitch2082 = staticSwitch1266;
				#endif
				float4 tex2DNode1574 = tex2D( _RippleRenderTexture, uv_RippleRenderTexture );
				float4 DebugDynamicRipple2091 = tex2DNode1574;
				float4 lerpResult2092 = lerp( staticSwitch2082 , DebugDynamicRipple2091 , _DebugContrast1);
				#ifdef _DEBUGVIEW1_ON
				float4 staticSwitch2087 = lerpResult2092;
				#else
				float4 staticSwitch2087 = staticSwitch2082;
				#endif
				float4 FinalColor2079 = staticSwitch2087;
				
				float localStochasticTiling2_g111 = ( 0.0 );
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1982 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVA1933, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1982 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float2 Input_UV145_g111 = staticSwitch1982.rg;
				float2 UV2_g111 = Input_UV145_g111;
				float2 UV12_g111 = float2( 0,0 );
				float2 UV22_g111 = float2( 0,0 );
				float2 UV32_g111 = float2( 0,0 );
				float W12_g111 = 0.0;
				float W22_g111 = 0.0;
				float W32_g111 = 0.0;
				StochasticTiling( UV2_g111 , UV12_g111 , UV22_g111 , UV32_g111 , W12_g111 , W22_g111 , W32_g111 );
				float2 temp_output_10_0_g111 = ddx( Input_UV145_g111 );
				float2 temp_output_12_0_g111 = ddy( Input_UV145_g111 );
				float4 Output_2D293_g111 = ( ( tex2D( _NormalMap, UV12_g111, temp_output_10_0_g111, temp_output_12_0_g111 ) * W12_g111 ) + ( tex2D( _NormalMap, UV22_g111, temp_output_10_0_g111, temp_output_12_0_g111 ) * W22_g111 ) + ( tex2D( _NormalMap, UV32_g111, temp_output_10_0_g111, temp_output_12_0_g111 ) * W32_g111 ) );
				float4 In02_g101 = Output_2D293_g111;
				float3 localMyCustomExpression2_g101 = MyCustomExpression( In02_g101 );
				float3 break675 = localMyCustomExpression2_g101;
				float4 appendResult680 = (float4(( break675.x * _NormalIntensity ) , ( break675.y * _NormalIntensity ) , break675.z , 0.0));
				float4 normalizeResult684 = normalize( appendResult680 );
				float localStochasticTiling2_g104 = ( 0.0 );
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1979 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVB1934, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1979 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float2 Input_UV145_g104 = staticSwitch1979.rg;
				float2 UV2_g104 = Input_UV145_g104;
				float2 UV12_g104 = float2( 0,0 );
				float2 UV22_g104 = float2( 0,0 );
				float2 UV32_g104 = float2( 0,0 );
				float W12_g104 = 0.0;
				float W22_g104 = 0.0;
				float W32_g104 = 0.0;
				StochasticTiling( UV2_g104 , UV12_g104 , UV22_g104 , UV32_g104 , W12_g104 , W22_g104 , W32_g104 );
				float2 temp_output_10_0_g104 = ddx( Input_UV145_g104 );
				float2 temp_output_12_0_g104 = ddy( Input_UV145_g104 );
				float4 Output_2D293_g104 = ( ( tex2D( _NormalMap, UV12_g104, temp_output_10_0_g104, temp_output_12_0_g104 ) * W12_g104 ) + ( tex2D( _NormalMap, UV22_g104, temp_output_10_0_g104, temp_output_12_0_g104 ) * W22_g104 ) + ( tex2D( _NormalMap, UV32_g104, temp_output_10_0_g104, temp_output_12_0_g104 ) * W32_g104 ) );
				float4 In02_g99 = Output_2D293_g104;
				float3 localMyCustomExpression2_g99 = MyCustomExpression( In02_g99 );
				float3 break678 = localMyCustomExpression2_g99;
				float4 appendResult683 = (float4(( break678.x * _NormalIntensity ) , ( break678.y * _NormalIntensity ) , break678.z , 0.0));
				float4 normalizeResult685 = normalize( appendResult683 );
				float4 lerpResult1945 = lerp( normalizeResult684 , normalizeResult685 , FlowUVAlpha1942);
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1983 = lerpResult1945;
				#else
				float4 staticSwitch1983 = float4( BlendNormal( normalizeResult684.xyz , normalizeResult685.xyz ) , 0.0 );
				#endif
				#ifdef _ENABLEANTITILENORMALS_ON
				float3 staticSwitch644 = BlendNormal( staticSwitch1983.xyz , RainDropRipples1004.xyz );
				#else
				float3 staticSwitch644 = temp_output_747_0;
				#endif
				float2 temp_cast_68 = (_MicroNormalSpeedX).xx;
				float2 texCoord591 = i.uv0XY_bitZ_fog.xy * _MicroNormalTiling + float2( 0,0 );
				float2 panner588 = ( 1.0 * _Time.y * temp_cast_68 + texCoord591);
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1993 = ( float4( panner588, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVA1933, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1993 = ( float4( panner588, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float temp_output_1_0_g98 = _MicroNormalsNearFadeDistance;
				float temp_output_626_0 = ( _MicroNormalIntensity * ( 1.0 - saturate( ( ( length( ( i.wPos.xyz - _WorldSpaceCameraPos ) ) - temp_output_1_0_g98 ) / ( _MicroNormalsFarFadeDistance - temp_output_1_0_g98 ) ) ) ) );
				float3 unpack592 = UnpackNormalScale( tex2D( _MicroNormalMap, staticSwitch1993.rg ), temp_output_626_0 );
				unpack592.z = lerp( 1, unpack592.z, saturate(temp_output_626_0) );
				float3 tex2DNode592 = unpack592;
				float2 temp_cast_73 = (_MicroNormalSpeedY).xx;
				float2 panner587 = ( 1.0 * _Time.y * temp_cast_73 + texCoord591);
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1994 = ( float4( panner587, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVB1934, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1994 = ( float4( panner587, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float3 unpack593 = UnpackNormalScale( tex2D( _MicroNormalMap, staticSwitch1994.rg ), temp_output_626_0 );
				unpack593.z = lerp( 1, unpack593.z, saturate(temp_output_626_0) );
				float3 tex2DNode593 = unpack593;
				float3 lerpResult1948 = lerp( tex2DNode592 , tex2DNode593 , FlowUVAlpha1942);
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float3 staticSwitch1988 = lerpResult1948;
				#else
				float3 staticSwitch1988 = BlendNormal( tex2DNode592 , tex2DNode593 );
				#endif
				float3 MicroNormals1006 = BlendNormal( staticSwitch1988 , staticSwitch644 );
				#ifdef _MICRONORMALS
				float3 staticSwitch585 = MicroNormals1006;
				#else
				float3 staticSwitch585 = staticSwitch644;
				#endif
				float3 Normals982 = staticSwitch585;
				#ifdef _ENABLEDYNAMICRIPPLES_ON
				float3 staticSwitch2072 = BlendNormal( Normals982 , temp_output_1565_40 );
				#else
				float3 staticSwitch2072 = Normals982;
				#endif
				float3 NormalsFinal1751 = staticSwitch2072;
				
				float3 temp_cast_78 = (_Cull).xxx;
				
				float3 temp_cast_79 = (_Reflectivity).xxx;
				
				float screenDepth2206 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2206 = saturate( abs( ( screenDepth2206 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch1501 = distanceDepth2206;
				#else
				float staticSwitch1501 = WaterColor1270.a;
				#endif
				float2 uv_AlphaMask2197 = i.uv0XY_bitZ_fog.xy;
				float smoothstepResult2199 = smoothstep( 0.0 , _AlphaFalloff , tex2D( _AlphaMask, uv_AlphaMask2197 ).a);
				#ifdef _ENABLEALPHAMASKING_ON
				float staticSwitch2208 = smoothstepResult2199;
				#else
				float staticSwitch2208 = ( 0.0 + 1.0 );
				#endif
				float cameraDepthFade2233 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch2230 = saturate( cameraDepthFade2233 );
				#else
				float staticSwitch2230 = 1.0;
				#endif
				float Alpha1498 = ( staticSwitch1501 * staticSwitch2208 * WaterColor1270.a * staticSwitch2230 );
				
			
			//--------------------------------------------------------------------------------------------------------------------------
			//--Read Input Data---------------------------------------------------------------------------------------------------------
			//--------------------------------------------------------------------------------------------------------------------------
			
				//float2 uv_main = mad(float2(i.uv0XY_bitZ_fog.xy), _BaseMap_ST.xy, _BaseMap_ST.zw);
				//float2 uv_detail = mad(float2(i.uv0XY_bitZ_fog.xy), _DetailMap_ST.xy, _DetailMap_ST.zw);
				//half4 albedo = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv_main);
				//half4 mas = SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_BaseMap, uv_main);
			
			
			
				//albedo *= _BaseColor;
				//half metallic = mas.r;
				//half ao = mas.g;
				//half smoothness = mas.b;
			
			
			//---------------------------------------------------------------------------------------------------------------------------
			//---Sample Normal Map-------------------------------------------------------------------------------------------------------
			//---------------------------------------------------------------------------------------------------------------------------
			
				//half3 normalTS = half3(0, 0, 1);
				//half  geoSmooth = 1;
				//half4 normalMap = half4(0, 0, 1, 0);
			
				half3 albedo3 = FinalColor2079.rgb;
				half3 normalTS = NormalsFinal1751;
				half3 emission = half3(0,0,0);
				half3 emissionbaked = temp_cast_78;
			
			// Begin Injection NORMAL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
				//normalMap = SAMPLE_TEXTURE2D(_BumpMap, sampler_BaseMap, uv_main);
				//normalTS = UnpackNormal(normalMap);
				//normalTS = _Normals ? normalTS : half3(0, 0, 1);
				//geoSmooth = _Normals ? normalMap.b : 1.0;
				//smoothness = saturate(smoothness + geoSmooth - 1.0);
			// End Injection NORMAL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
				half metallic = half(0);
				half3 specular = temp_cast_79;
				half smoothness = _Smoothness;
				half ao = half(1);
				half alpha = Alpha1498;
				half alphaclip = half(0);
				half alphaclipthresholdshadow = half(0);
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif
			
				#if defined(_ALPHATEST_ON)
					clip(alpha - alphaclip);
				#endif
			
				#if defined(_ISTRANSPARENT)
					_SSRTemporalMul = 0.0;
				#endif
				half4 albedo = half4(albedo3.rgb, alpha);
			
			//---------------------------------------------------------------------------------------------------------------------------
			//---Read Detail Map---------------------------------------------------------------------------------------------------------
			//---------------------------------------------------------------------------------------------------------------------------
			
				//#if defined(_DETAILS_ON) 
			
			// Begin Injection DETAIL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
					//half4 detailMap = SAMPLE_TEXTURE2D(_DetailMap, sampler_DetailMap, uv_detail);
					//half3 detailTS = half3(2.0 * detailMap.ag - 1.0, 1.0);
					//normalTS = BlendNormal(normalTS, detailTS);
			// End Injection DETAIL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
				   
					//smoothness = saturate(2.0 * detailMap.b * smoothness);
					//albedo.rgb = OverlayBlendDetail(detailMap.r, albedo.rgb);
			
				//#endif
			
			
			//---------------------------------------------------------------------------------------------------------------------------
			//---Transform Normals To Worldspace-----------------------------------------------------------------------------------------
			//---------------------------------------------------------------------------------------------------------------------------
			
			// Begin Injection NORMAL_TRANSFORM from Injection_NormalMaps.hlsl ----------------------------------------------------------
				half3 normalWS = i.normXYZ_tanX.xyz;
				half3x3 TStoWS = half3x3(
					i.normXYZ_tanX.w, i.tanYZ_bitXY.z, normalWS.x,
					i.tanYZ_bitXY.x, i.tanYZ_bitXY.w, normalWS.y,
					i.tanYZ_bitXY.y, i.uv0XY_bitZ_fog.z, normalWS.z
					);
				normalWS = mul(TStoWS, normalTS);
				normalWS = normalize(normalWS);
			// End Injection NORMAL_TRANSFORM from Injection_NormalMaps.hlsl ----------------------------------------------------------
				
				
			//---------------------------------------------------------------------------------------------------------------------------//
			//---Lighting Calculations---------------------------------------------------------------------------------------------------//
			//---------------------------------------------------------------------------------------------------------------------------//
				
			// Begin Injection SPEC_AA from Injection_NormalMaps.hlsl ----------------------------------------------------------
				#if !defined(SHADER_API_MOBILE) && !defined(LITMAS_FEATURE_TP) // Specular antialiasing based on normal derivatives. Only on PC to avoid cost of derivatives on Quest
					smoothness = min(smoothness, SLZGeometricSpecularAA(normalWS));
				#endif
			// End Injection SPEC_AA from Injection_NormalMaps.hlsl ----------------------------------------------------------
				
				
				#if defined(LIGHTMAP_ON)
					SLZFragData fragData = SLZGetFragData(i.vertex, i.wPos, normalWS, i.uv1.xy, i.uv1.zw, i.SHVertLights.xyz);
				#else
					SLZFragData fragData = SLZGetFragData(i.vertex, i.wPos, normalWS, float2(0, 0), float2(0, 0), i.SHVertLights.xyz);
				#endif
				
				//half4 emission = half4(0,0,0,0);
				
			// Begin Injection EMISSION from Injection_Emission.hlsl ----------------------------------------------------------
				//UNITY_BRANCH if (_Emission)
				//{
					//emission += SAMPLE_TEXTURE2D(_EmissionMap, sampler_BaseMap, uv_main) * _EmissionColor;
					//emission.rgb *= lerp(albedo.rgb, half3(1, 1, 1), emission.a);
					//emission.rgb *= pow(abs(fragData.NoV), _EmissionFalloff);
				//}
			// End Injection EMISSION from Injection_Emission.hlsl ----------------------------------------------------------
				
				
				#if !defined(_SLZ_SPECULAR_SETUP)
				SLZSurfData surfData = SLZGetSurfDataMetallicGloss(albedo.rgb, saturate(metallic), saturate(smoothness), ao, emission.rgb, albedo.a);
				#else
				SLZSurfData surfData;
			    surfData.albedo = albedo.rgb;
			    surfData.specular = specular.rgb;
			    surfData.perceptualRoughness = half(1.0) - saturate(smoothness);
			    surfData.reflectivity = (specular.r + specular.g + specular.b) / half(3.0);
			    surfData.roughness = max(surfData.perceptualRoughness * surfData.perceptualRoughness, 1.0e-3h);
			    surfData.emission = emission.rgb;
			    surfData.occlusion = ao;
			    surfData.alpha = alpha;
				#endif
				
				half4 color = half4(1, 1, 1, 1);
				
				#if defined(_SurfaceOpaque)
				int _Surface = 0;
				#elif defined(_SurfaceTransparent)
				int _Surface = 1;
				#elif defined(_SurfaceFade)
				int _Surface = 2;
				#else
				int _Surface = 0;
				#endif
				
			// Begin Injection LIGHTING_CALC from Injection_SSR.hlsl ----------------------------------------------------------
				#if defined(_SSR_ENABLED)
					half4 noiseRGBA = GetScreenNoiseRGBA(fragData.screenUV);
				
					SSRExtraData ssrExtra;
					ssrExtra.meshNormal = i.normXYZ_tanX.xyz;
					ssrExtra.lastClipPos = i.lastVertex;
					ssrExtra.temporalWeight = _SSRTemporalMul;
					ssrExtra.depthDerivativeSum = 0;
					ssrExtra.noise = noiseRGBA;
					ssrExtra.fogFactor = i.uv0XY_bitZ_fog.w;
				
					color = SLZPBRFragmentSSR(fragData, surfData, ssrExtra, _Surface);
					color.rgb = max(0, color.rgb);
				#else
					color = SLZPBRFragment(fragData, surfData, _Surface);
				#endif
			// End Injection LIGHTING_CALC from Injection_SSR.hlsl ----------------------------------------------------------
				
				
			// Begin Injection VOLUMETRIC_FOG from Injection_SSR.hlsl ----------------------------------------------------------
				#if !defined(_SSR_ENABLED)
					color = MixFogSurf(color, -fragData.viewDir, i.uv0XY_bitZ_fog.w, _Surface);
					
					color = VolumetricsSurf(color, fragData.position, _Surface);
				#endif
			// End Injection VOLUMETRIC_FOG from Injection_SSR.hlsl ----------------------------------------------------------
				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif
				
				return color;
			}
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			ENDHLSL
		}

		
		Pass
		{
			

			Name "DepthOnly"
			Tags { "Lightmode"="DepthOnly" }
			
			
			ColorMask 0

			HLSLPROGRAM
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _SLZ_SPECULAR_SETUP
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma vertex vert
			#pragma fragment frag
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			//DepthOnly------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _WAVETYPE_NONE _WAVETYPE_GERSTNERWAVES _WAVETYPE_3DTEXTURE _WAVETYPE_GERSTNERAND3DTEXTURE _WAVETYPE_NOISE _WAVETYPE_DYNAMICRIPPLES
			#pragma shader_feature_local _ENABLEDYNAMICRIPPLES_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEALPHAMASKING_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON


			struct appdata
			{
			    float4 vertex : POSITION;
			
				float4 ase_texcoord : TEXCOORD0;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
			    float4 vertex : SV_POSITION;
			
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			    UNITY_VERTEX_OUTPUT_STEREO
			};
			sampler3D _Displacement3DTexture;
			sampler2D _RippleRenderTexture;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _AlphaMask;
			CBUFFER_START( UnityPerMaterial )
			float4 _DepthColor;
			float4 _DeepColor;
			float4 _ShallowColor;
			float4 _WaterColor;
			float4 _RippleRenderTexture_TexelSize;
			float4 _RippleRenderTexture_ST;
			float4 _FoamColor;
			float4 _FoamTexture_ST;
			float2 _DistortionTiling;
			float2 _NormalTiling;
			float2 _FoamTiling;
			float2 _RainDropRippleTiling;
			float2 _MicroNormalTiling;
			float2 _NoiseWavesDirection;
			float _FoamStrength;
			float _Blue;
			float _Green;
			float _Red;
			float _FoamSpeedX;
			float _PosterizationIntensity;
			float _ContrastIntensity;
			float _SaturationIntensity;
			float _FoamSpeedY;
			float _FoamDistortion;
			float _FoamParallaxScale;
			float _FoamAlpha;
			float _DebugContrast;
			float _DebugContrast1;
			float _MicroNormalSpeedX;
			float _MicroNormalIntensity;
			float _MicroNormalsNearFadeDistance;
			float _MicroNormalsFarFadeDistance;
			float _MicroNormalSpeedY;
			float _Cull;
			float _Reflectivity;
			float _Smoothness;
			float _SoftIntersectionIntensity;
			float _AlphaFalloff;
			float _DistortedUVInfluence1;
			float _DepthTranslucency;
			float _Steepness;
			float _Murkiness;
			float _Wavelength;
			float _Amplitude;
			float _NumberOfWaves;
			float _Speed;
			float _DisplacementTiling;
			float _WaveSpeed;
			float _WaveHeight;
			float _MixingIntensity;
			float _NoiseWavesSpeed;
			float _NoiseWavesScale;
			float _NoiseWavesSize;
			float _DynamicRippleWaveHeight;
			float _DistortionIntensity;
			float _WaterDepth;
			float _WaterSpeedX;
			float _DistortionSpeedX;
			float _DistortionSpeedY;
			float _Strength;
			float _FlowSpeed;
			float _NormalIntensity;
			float _WaterSpeedY;
			float _RainDropRippleSpeed;
			float _DistortedUVInfluence;
			float _RainDropRippleIntensity;
			float _DynamicRippleIntensity;
			float _RGBOffset;
			float _Clarity;
			float _CDFalloff;
			float _DistortOverlayIntensity;
			float _CDDistance;
			CBUFFER_END


			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			v2f vert(appdata v )
			{
			    v2f o;
			    UNITY_SETUP_INSTANCE_ID(v);
			    UNITY_TRANSFER_INSTANCE_ID(v, o);
			    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

			    float temp_output_15_0_g1860 = ( ( 2.0 * PI ) / _Wavelength );
			    float temp_output_26_0_g1860 = _Amplitude;
			    float temp_output_1142_0 = ( _NumberOfWaves * -1.0 );
			    float temp_output_58_0_g1860 = ( ( _Steepness / ( ( temp_output_15_0_g1860 * temp_output_26_0_g1860 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1860 );
			    float3 temp_output_5_0_g1860 = (float4(1,0.8896552,0,1)).rgb;
			    float3 normalizeResult4_g1860 = normalize( temp_output_5_0_g1860 );
			    float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
			    float4 transform69_g1860 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
			    float dotResult11_g1860 = dot( normalizeResult4_g1860 , (transform69_g1860).xyz );
			    float temp_output_21_0_g1860 = ( ( dotResult11_g1860 * temp_output_15_0_g1860 ) + ( ( _Speed * temp_output_15_0_g1860 ) * _TimeParameters.x ) );
			    float temp_output_62_0_g1860 = cos( temp_output_21_0_g1860 );
			    float4 appendResult54_g1860 = (float4(( temp_output_58_0_g1860 * ( (temp_output_5_0_g1860).x * temp_output_62_0_g1860 ) ) , ( temp_output_58_0_g1860 * ( temp_output_62_0_g1860 * (temp_output_5_0_g1860).y ) ) , ( sin( temp_output_21_0_g1860 ) * ( temp_output_26_0_g1860 * 2.0 ) ) , 0.0));
			    float temp_output_15_0_g1857 = ( ( 2.0 * PI ) / _Wavelength );
			    float temp_output_26_0_g1857 = _Amplitude;
			    float temp_output_58_0_g1857 = ( ( _Steepness / ( ( temp_output_15_0_g1857 * temp_output_26_0_g1857 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1857 );
			    float3 temp_output_5_0_g1857 = (( float4(0.7379313,0,1,1) * -1.0 )).rgb;
			    float3 normalizeResult4_g1857 = normalize( temp_output_5_0_g1857 );
			    float4 transform69_g1857 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
			    float dotResult11_g1857 = dot( normalizeResult4_g1857 , (transform69_g1857).xyz );
			    float temp_output_21_0_g1857 = ( ( dotResult11_g1857 * temp_output_15_0_g1857 ) + ( ( _Speed * temp_output_15_0_g1857 ) * _TimeParameters.x ) );
			    float temp_output_62_0_g1857 = cos( temp_output_21_0_g1857 );
			    float4 appendResult54_g1857 = (float4(( temp_output_58_0_g1857 * ( (temp_output_5_0_g1857).x * temp_output_62_0_g1857 ) ) , ( temp_output_58_0_g1857 * ( temp_output_62_0_g1857 * (temp_output_5_0_g1857).y ) ) , ( sin( temp_output_21_0_g1857 ) * ( temp_output_26_0_g1857 * 2.0 ) ) , 0.0));
			    float temp_output_15_0_g1858 = ( ( 2.0 * PI ) / _Wavelength );
			    float temp_output_26_0_g1858 = _Amplitude;
			    float temp_output_58_0_g1858 = ( ( _Steepness / ( ( temp_output_15_0_g1858 * temp_output_26_0_g1858 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1858 );
			    float3 temp_output_5_0_g1858 = (( float4(0,0.9586205,1,1) * -1.0 )).rgb;
			    float3 normalizeResult4_g1858 = normalize( temp_output_5_0_g1858 );
			    float4 transform69_g1858 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
			    float dotResult11_g1858 = dot( normalizeResult4_g1858 , (transform69_g1858).xyz );
			    float temp_output_21_0_g1858 = ( ( dotResult11_g1858 * temp_output_15_0_g1858 ) + ( ( _Speed * temp_output_15_0_g1858 ) * _TimeParameters.x ) );
			    float temp_output_62_0_g1858 = cos( temp_output_21_0_g1858 );
			    float4 appendResult54_g1858 = (float4(( temp_output_58_0_g1858 * ( (temp_output_5_0_g1858).x * temp_output_62_0_g1858 ) ) , ( temp_output_58_0_g1858 * ( temp_output_62_0_g1858 * (temp_output_5_0_g1858).y ) ) , ( sin( temp_output_21_0_g1858 ) * ( temp_output_26_0_g1858 * 2.0 ) ) , 0.0));
			    float temp_output_15_0_g1859 = ( ( 2.0 * PI ) / _Wavelength );
			    float temp_output_26_0_g1859 = _Amplitude;
			    float temp_output_58_0_g1859 = ( ( _Steepness / ( ( temp_output_15_0_g1859 * temp_output_26_0_g1859 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1859 );
			    float3 temp_output_5_0_g1859 = (( float4(1,0.4344828,0,1) * -1.0 )).rgb;
			    float3 normalizeResult4_g1859 = normalize( temp_output_5_0_g1859 );
			    float4 transform69_g1859 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
			    float dotResult11_g1859 = dot( normalizeResult4_g1859 , (transform69_g1859).xyz );
			    float temp_output_21_0_g1859 = ( ( dotResult11_g1859 * temp_output_15_0_g1859 ) + ( ( _Speed * temp_output_15_0_g1859 ) * _TimeParameters.x ) );
			    float temp_output_62_0_g1859 = cos( temp_output_21_0_g1859 );
			    float4 appendResult54_g1859 = (float4(( temp_output_58_0_g1859 * ( (temp_output_5_0_g1859).x * temp_output_62_0_g1859 ) ) , ( temp_output_58_0_g1859 * ( temp_output_62_0_g1859 * (temp_output_5_0_g1859).y ) ) , ( sin( temp_output_21_0_g1859 ) * ( temp_output_26_0_g1859 * 2.0 ) ) , 0.0));
			    float4 GerstnerWaves1121 = ( appendResult54_g1860 + appendResult54_g1857 + appendResult54_g1858 + appendResult54_g1859 );
			    float mulTime1086 = _TimeParameters.x * _WaveSpeed;
			    float3 appendResult1085 = (float3(( ase_worldPos.x * _DisplacementTiling ) , ( ase_worldPos.z * _DisplacementTiling ) , mulTime1086));
			    float4 ThreeDTexture1090 = ( tex3Dlod( _Displacement3DTexture, float4( appendResult1085, 0.0) ) * float4( ( float3(0,1,0) * (0.0 + (_WaveHeight - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) ) , 0.0 ) );
			    float4 MixedWaves1107 = ( ( GerstnerWaves1121 * _MixingIntensity ) + ( ThreeDTexture1090 * _MixingIntensity ) );
			    float mulTime1521 = _TimeParameters.x * _NoiseWavesSpeed;
			    float2 texCoord1513 = v.ase_texcoord.xyz * float2( 1,1 ) + ( mulTime1521 * _NoiseWavesDirection );
			    float simplePerlin2D1541 = snoise( texCoord1513*_NoiseWavesScale );
			    simplePerlin2D1541 = simplePerlin2D1541*0.5 + 0.5;
			    float NoiseWaves1548 = (0.0 + (simplePerlin2D1541 - 0.0) * (1.0 - 0.0) / (_NoiseWavesSize - 0.0));
			    float4 temp_cast_7 = (NoiseWaves1548).xxxx;
			    float2 uv_RippleRenderTexture = v.ase_texcoord.xy * _RippleRenderTexture_ST.xy + _RippleRenderTexture_ST.zw;
			    float4 tex2DNode1574 = tex2Dlod( _RippleRenderTexture, float4( uv_RippleRenderTexture, 0, 0.0) );
			    #ifdef _ENABLEDYNAMICRIPPLES_ON
			    float staticSwitch2073 = ( tex2DNode1574.r * ( _DynamicRippleWaveHeight * 0.1 ) );
			    #else
			    float staticSwitch2073 = 0.0;
			    #endif
			    float DynamicRippleWaves1750 = staticSwitch2073;
			    float4 temp_cast_8 = (DynamicRippleWaves1750).xxxx;
			    #if defined(_WAVETYPE_NONE)
			    float4 staticSwitch1066 = float4( 0,0,0,0 );
			    #elif defined(_WAVETYPE_GERSTNERWAVES)
			    float4 staticSwitch1066 = GerstnerWaves1121;
			    #elif defined(_WAVETYPE_3DTEXTURE)
			    float4 staticSwitch1066 = ThreeDTexture1090;
			    #elif defined(_WAVETYPE_GERSTNERAND3DTEXTURE)
			    float4 staticSwitch1066 = MixedWaves1107;
			    #elif defined(_WAVETYPE_NOISE)
			    float4 staticSwitch1066 = temp_cast_7;
			    #elif defined(_WAVETYPE_DYNAMICRIPPLES)
			    float4 staticSwitch1066 = temp_cast_8;
			    #else
			    float4 staticSwitch1066 = float4( 0,0,0,0 );
			    #endif
			    float4 Waves2060 = staticSwitch1066;
			    
			    float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
			    float4 screenPos = ComputeScreenPos(ase_clipPos);
			    o.ase_texcoord = screenPos;
			    float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
			    float eyeDepth = -objectToViewPos.z;
			    o.ase_texcoord1.w = eyeDepth;
			    
			    o.ase_texcoord1.xyz = v.ase_texcoord.xyz;
			    #ifdef ASE_ABSOLUTE_VERTEX_POS
			        float3 defaultVertexValue = v.vertex.xyz;
			    #else
			        float3 defaultVertexValue = float3(0, 0, 0);
			    #endif
			    float3 vertexValue = Waves2060.xyz;
			    #ifdef ASE_ABSOLUTE_VERTEX_POS
			        v.vertex.xyz = vertexValue;
			    #else
			        v.vertex.xyz += vertexValue;
			    #endif
			
			    o.vertex = TransformObjectToHClip(v.vertex.xyz);
			    return o;
			}
			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
			    #define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
			    #define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(v2f i 
			    #ifdef ASE_DEPTH_WRITE_ON
			    , out float outputDepth : ASE_SV_DEPTH
			    #endif
			     ) : SV_Target
			{
			    UNITY_SETUP_INSTANCE_ID(i);
			    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
			    float4 WaterColor1270 = _WaterColor;
			    float4 screenPos = i.ase_texcoord;
			    float4 ase_screenPosNorm = screenPos / screenPos.w;
			    ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			    float screenDepth2206 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
			    float distanceDepth2206 = saturate( abs( ( screenDepth2206 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
			    #ifdef _ENABLESOFTINTERSECTION_ON
			    float staticSwitch1501 = distanceDepth2206;
			    #else
			    float staticSwitch1501 = WaterColor1270.a;
			    #endif
			    float2 uv_AlphaMask2197 = i.ase_texcoord1.xyz.xy;
			    float smoothstepResult2199 = smoothstep( 0.0 , _AlphaFalloff , tex2D( _AlphaMask, uv_AlphaMask2197 ).a);
			    #ifdef _ENABLEALPHAMASKING_ON
			    float staticSwitch2208 = smoothstepResult2199;
			    #else
			    float staticSwitch2208 = ( 0.0 + 1.0 );
			    #endif
			    float eyeDepth = i.ase_texcoord1.w;
			    float cameraDepthFade2233 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
			    #ifdef _ENABLECAMERADEPTHFADING_ON
			    float staticSwitch2230 = saturate( cameraDepthFade2233 );
			    #else
			    float staticSwitch2230 = 1.0;
			    #endif
			    float Alpha1498 = ( staticSwitch1501 * staticSwitch2208 * WaterColor1270.a * staticSwitch2230 );
			    
			
				half alpha = Alpha1498;
				half alphaclip = half(0);
				half alphaclipthresholdshadow = half(0);
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif
				#if defined(_ALPHATEST_ON)
					clip(alpha - alphaclip);
				#endif
				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif
			
			    return 0;
			}
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "Lightmode"="DepthNormals" }
			
			
			
			

			HLSLPROGRAM
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _SLZ_SPECULAR_SETUP
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma vertex vert
			#pragma fragment frag
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			//StandardDepthNormals-------------------------------------------------------------------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//
			//
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
					
			#define SHADERPASS SHADERPASS_DEPTHNORMALS
					
			#if defined(SHADER_API_MOBILE)
			#else
			#endif
					
					
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/EncodeNormalsTexture.hlsl"
					
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _WAVETYPE_NONE _WAVETYPE_GERSTNERWAVES _WAVETYPE_3DTEXTURE _WAVETYPE_GERSTNERAND3DTEXTURE _WAVETYPE_NOISE _WAVETYPE_DYNAMICRIPPLES
			#pragma shader_feature_local _ENABLEDYNAMICRIPPLES_ON
			#pragma shader_feature_local _MICRONORMALS
			#pragma shader_feature_local _ENABLEANTITILENORMALS_ON
			#pragma shader_feature_local _ENABLEFLOWMAPPEDUVS_ON
			#pragma shader_feature_local _ENABLEDISTORTEDUVS
			#pragma shader_feature_local _ENABLEANTITILEUVDISTORTION_ON
			#pragma shader_feature_local _ENABLERAINDROPRIPPLES
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEALPHAMASKING_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON

					
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			// Begin Injection VERTEX_IN from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				float4 tangent : TANGENT;
				float2 uv0 : TEXCOORD0;
			// End Injection VERTEX_IN from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 normalWS : NORMAL;
				float2 uv0 : TEXCOORD0;
			// Begin Injection INTERPOLATORS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				float4 tanYZ_bitXY : TEXCOORD1;
				float4 uv0XY_bitZ_fog : TEXCOORD2;
			// End Injection INTERPOLATORS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			// Begin Injection UNIFORMS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				//TEXTURE2D(_BumpMap);
				//SAMPLER(sampler_BumpMap);
			// End Injection UNIFORMS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
			
			CBUFFER_START(UnityPerMaterial)
				float4 _DepthColor;
				float4 _DeepColor;
				float4 _ShallowColor;
				float4 _WaterColor;
				float4 _RippleRenderTexture_TexelSize;
				float4 _RippleRenderTexture_ST;
				float4 _FoamColor;
				float4 _FoamTexture_ST;
				float2 _DistortionTiling;
				float2 _NormalTiling;
				float2 _FoamTiling;
				float2 _RainDropRippleTiling;
				float2 _MicroNormalTiling;
				float2 _NoiseWavesDirection;
				float _FoamStrength;
				float _Blue;
				float _Green;
				float _Red;
				float _FoamSpeedX;
				float _PosterizationIntensity;
				float _ContrastIntensity;
				float _SaturationIntensity;
				float _FoamSpeedY;
				float _FoamDistortion;
				float _FoamParallaxScale;
				float _FoamAlpha;
				float _DebugContrast;
				float _DebugContrast1;
				float _MicroNormalSpeedX;
				float _MicroNormalIntensity;
				float _MicroNormalsNearFadeDistance;
				float _MicroNormalsFarFadeDistance;
				float _MicroNormalSpeedY;
				float _Cull;
				float _Reflectivity;
				float _Smoothness;
				float _SoftIntersectionIntensity;
				float _AlphaFalloff;
				float _DistortedUVInfluence1;
				float _DepthTranslucency;
				float _Steepness;
				float _Murkiness;
				float _Wavelength;
				float _Amplitude;
				float _NumberOfWaves;
				float _Speed;
				float _DisplacementTiling;
				float _WaveSpeed;
				float _WaveHeight;
				float _MixingIntensity;
				float _NoiseWavesSpeed;
				float _NoiseWavesScale;
				float _NoiseWavesSize;
				float _DynamicRippleWaveHeight;
				float _DistortionIntensity;
				float _WaterDepth;
				float _WaterSpeedX;
				float _DistortionSpeedX;
				float _DistortionSpeedY;
				float _Strength;
				float _FlowSpeed;
				float _NormalIntensity;
				float _WaterSpeedY;
				float _RainDropRippleSpeed;
				float _DistortedUVInfluence;
				float _RainDropRippleIntensity;
				float _DynamicRippleIntensity;
				float _RGBOffset;
				float _Clarity;
				float _CDFalloff;
				float _DistortOverlayIntensity;
				float _CDDistance;
				//float4 _BaseMap_ST;
				//half4 _BaseColor;
			// Begin Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			//float4 _DetailMap_ST;
			//half  _Details;
			//half  _Normals;
			// End Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
				float _SSRTemporalMul;
			// End Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_Emission_CBuffer.hlsl ----------------------------------------------------------
				//half  _Emission;
				//half4 _EmissionColor;
				//half  _EmissionFalloff;
				//half  _BakedMutiplier;
			// End Injection MATERIAL_CBUFFER from Injection_Emission_CBuffer.hlsl ----------------------------------------------------------
				//int _Surface;
			CBUFFER_END
			sampler3D _Displacement3DTexture;
			sampler2D _RippleRenderTexture;
			sampler2D _NormalMap;
			sampler2D _Distortion;
			sampler2D _Flowmap;
			sampler2D _BubbleBook;
			sampler2D _MicroNormalMap;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _AlphaMask;

				
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			inline float3 MyCustomExpression( half4 In0 )
			{
				return UnpackNormal(In0);;
			}
			
			float3 CombineSamplesSharp128_g1862( float S0, float S1, float S2, float Strength )
			{
				{
				    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
				    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
				    return normalize( cross( va, vb ) );
				}
			}
			
			
			v2f vert(appdata v  )
			{
			
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			
			
				float temp_output_15_0_g1860 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1860 = _Amplitude;
				float temp_output_1142_0 = ( _NumberOfWaves * -1.0 );
				float temp_output_58_0_g1860 = ( ( _Steepness / ( ( temp_output_15_0_g1860 * temp_output_26_0_g1860 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1860 );
				float3 temp_output_5_0_g1860 = (float4(1,0.8896552,0,1)).rgb;
				float3 normalizeResult4_g1860 = normalize( temp_output_5_0_g1860 );
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 transform69_g1860 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1860 = dot( normalizeResult4_g1860 , (transform69_g1860).xyz );
				float temp_output_21_0_g1860 = ( ( dotResult11_g1860 * temp_output_15_0_g1860 ) + ( ( _Speed * temp_output_15_0_g1860 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1860 = cos( temp_output_21_0_g1860 );
				float4 appendResult54_g1860 = (float4(( temp_output_58_0_g1860 * ( (temp_output_5_0_g1860).x * temp_output_62_0_g1860 ) ) , ( temp_output_58_0_g1860 * ( temp_output_62_0_g1860 * (temp_output_5_0_g1860).y ) ) , ( sin( temp_output_21_0_g1860 ) * ( temp_output_26_0_g1860 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1857 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1857 = _Amplitude;
				float temp_output_58_0_g1857 = ( ( _Steepness / ( ( temp_output_15_0_g1857 * temp_output_26_0_g1857 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1857 );
				float3 temp_output_5_0_g1857 = (( float4(0.7379313,0,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1857 = normalize( temp_output_5_0_g1857 );
				float4 transform69_g1857 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1857 = dot( normalizeResult4_g1857 , (transform69_g1857).xyz );
				float temp_output_21_0_g1857 = ( ( dotResult11_g1857 * temp_output_15_0_g1857 ) + ( ( _Speed * temp_output_15_0_g1857 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1857 = cos( temp_output_21_0_g1857 );
				float4 appendResult54_g1857 = (float4(( temp_output_58_0_g1857 * ( (temp_output_5_0_g1857).x * temp_output_62_0_g1857 ) ) , ( temp_output_58_0_g1857 * ( temp_output_62_0_g1857 * (temp_output_5_0_g1857).y ) ) , ( sin( temp_output_21_0_g1857 ) * ( temp_output_26_0_g1857 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1858 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1858 = _Amplitude;
				float temp_output_58_0_g1858 = ( ( _Steepness / ( ( temp_output_15_0_g1858 * temp_output_26_0_g1858 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1858 );
				float3 temp_output_5_0_g1858 = (( float4(0,0.9586205,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1858 = normalize( temp_output_5_0_g1858 );
				float4 transform69_g1858 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1858 = dot( normalizeResult4_g1858 , (transform69_g1858).xyz );
				float temp_output_21_0_g1858 = ( ( dotResult11_g1858 * temp_output_15_0_g1858 ) + ( ( _Speed * temp_output_15_0_g1858 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1858 = cos( temp_output_21_0_g1858 );
				float4 appendResult54_g1858 = (float4(( temp_output_58_0_g1858 * ( (temp_output_5_0_g1858).x * temp_output_62_0_g1858 ) ) , ( temp_output_58_0_g1858 * ( temp_output_62_0_g1858 * (temp_output_5_0_g1858).y ) ) , ( sin( temp_output_21_0_g1858 ) * ( temp_output_26_0_g1858 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1859 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1859 = _Amplitude;
				float temp_output_58_0_g1859 = ( ( _Steepness / ( ( temp_output_15_0_g1859 * temp_output_26_0_g1859 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1859 );
				float3 temp_output_5_0_g1859 = (( float4(1,0.4344828,0,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1859 = normalize( temp_output_5_0_g1859 );
				float4 transform69_g1859 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1859 = dot( normalizeResult4_g1859 , (transform69_g1859).xyz );
				float temp_output_21_0_g1859 = ( ( dotResult11_g1859 * temp_output_15_0_g1859 ) + ( ( _Speed * temp_output_15_0_g1859 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1859 = cos( temp_output_21_0_g1859 );
				float4 appendResult54_g1859 = (float4(( temp_output_58_0_g1859 * ( (temp_output_5_0_g1859).x * temp_output_62_0_g1859 ) ) , ( temp_output_58_0_g1859 * ( temp_output_62_0_g1859 * (temp_output_5_0_g1859).y ) ) , ( sin( temp_output_21_0_g1859 ) * ( temp_output_26_0_g1859 * 2.0 ) ) , 0.0));
				float4 GerstnerWaves1121 = ( appendResult54_g1860 + appendResult54_g1857 + appendResult54_g1858 + appendResult54_g1859 );
				float mulTime1086 = _TimeParameters.x * _WaveSpeed;
				float3 appendResult1085 = (float3(( ase_worldPos.x * _DisplacementTiling ) , ( ase_worldPos.z * _DisplacementTiling ) , mulTime1086));
				float4 ThreeDTexture1090 = ( tex3Dlod( _Displacement3DTexture, float4( appendResult1085, 0.0) ) * float4( ( float3(0,1,0) * (0.0 + (_WaveHeight - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) ) , 0.0 ) );
				float4 MixedWaves1107 = ( ( GerstnerWaves1121 * _MixingIntensity ) + ( ThreeDTexture1090 * _MixingIntensity ) );
				float mulTime1521 = _TimeParameters.x * _NoiseWavesSpeed;
				float2 texCoord1513 = v.uv0 * float2( 1,1 ) + ( mulTime1521 * _NoiseWavesDirection );
				float simplePerlin2D1541 = snoise( texCoord1513*_NoiseWavesScale );
				simplePerlin2D1541 = simplePerlin2D1541*0.5 + 0.5;
				float NoiseWaves1548 = (0.0 + (simplePerlin2D1541 - 0.0) * (1.0 - 0.0) / (_NoiseWavesSize - 0.0));
				float4 temp_cast_7 = (NoiseWaves1548).xxxx;
				float2 uv_RippleRenderTexture = v.uv0 * _RippleRenderTexture_ST.xy + _RippleRenderTexture_ST.zw;
				float4 tex2DNode1574 = tex2Dlod( _RippleRenderTexture, float4( uv_RippleRenderTexture, 0, 0.0) );
				#ifdef _ENABLEDYNAMICRIPPLES_ON
				float staticSwitch2073 = ( tex2DNode1574.r * ( _DynamicRippleWaveHeight * 0.1 ) );
				#else
				float staticSwitch2073 = 0.0;
				#endif
				float DynamicRippleWaves1750 = staticSwitch2073;
				float4 temp_cast_8 = (DynamicRippleWaves1750).xxxx;
				#if defined(_WAVETYPE_NONE)
				float4 staticSwitch1066 = float4( 0,0,0,0 );
				#elif defined(_WAVETYPE_GERSTNERWAVES)
				float4 staticSwitch1066 = GerstnerWaves1121;
				#elif defined(_WAVETYPE_3DTEXTURE)
				float4 staticSwitch1066 = ThreeDTexture1090;
				#elif defined(_WAVETYPE_GERSTNERAND3DTEXTURE)
				float4 staticSwitch1066 = MixedWaves1107;
				#elif defined(_WAVETYPE_NOISE)
				float4 staticSwitch1066 = temp_cast_7;
				#elif defined(_WAVETYPE_DYNAMICRIPPLES)
				float4 staticSwitch1066 = temp_cast_8;
				#else
				float4 staticSwitch1066 = float4( 0,0,0,0 );
				#endif
				float4 Waves2060 = staticSwitch1066;
				
				o.ase_texcoord3.xyz = ase_worldPos;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.w = eyeDepth;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = Waves2060.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				v.normal = v.normal;
			
			// Begin Injection VERTEX_NORMAL from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				VertexNormalInputs ntb = GetVertexNormalInputs(v.normal, v.tangent);
				o.normalWS = float4(ntb.normalWS, ntb.tangentWS.x);
				o.tanYZ_bitXY = float4(ntb.tangentWS.yz, ntb.bitangentWS.xy);
				o.uv0XY_bitZ_fog.zw = ntb.bitangentWS.zz;
				o.uv0XY_bitZ_fog.xy = v.uv0.xy;
			// End Injection VERTEX_NORMAL from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				o.uv0 = v.uv0;
			
				return o;
			}
			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif
			
			half4 frag(v2f i
				#ifdef ASE_DEPTH_WRITE_ON
				, out float outputDepth : ASE_SV_DEPTH
				#endif
				) : SV_Target
			{
			   UNITY_SETUP_INSTANCE_ID(i);
			   UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
			   float2 temp_cast_0 = (_WaterSpeedX).xx;
			   float2 texCoord576 = i.uv0.xy * _NormalTiling + float2( 0,0 );
			   float2 panner573 = ( 1.0 * _Time.y * temp_cast_0 + texCoord576);
			   float2 appendResult705 = (float2(( _DistortionSpeedX * _TimeParameters.x ) , ( _DistortionSpeedY * _TimeParameters.x )));
			   float2 texCoord602 = i.uv0.xy * _DistortionTiling + appendResult705;
			   float localStochasticTiling2_g1856 = ( 0.0 );
			   float2 Input_UV145_g1856 = texCoord602;
			   float2 UV2_g1856 = Input_UV145_g1856;
			   float2 UV12_g1856 = float2( 0,0 );
			   float2 UV22_g1856 = float2( 0,0 );
			   float2 UV32_g1856 = float2( 0,0 );
			   float W12_g1856 = 0.0;
			   float W22_g1856 = 0.0;
			   float W32_g1856 = 0.0;
			   StochasticTiling( UV2_g1856 , UV12_g1856 , UV22_g1856 , UV32_g1856 , W12_g1856 , W22_g1856 , W32_g1856 );
			   float2 temp_output_10_0_g1856 = ddx( Input_UV145_g1856 );
			   float2 temp_output_12_0_g1856 = ddy( Input_UV145_g1856 );
			   float4 Output_2D293_g1856 = ( ( tex2D( _Distortion, UV12_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W12_g1856 ) + ( tex2D( _Distortion, UV22_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W22_g1856 ) + ( tex2D( _Distortion, UV32_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W32_g1856 ) );
			   #ifdef _ENABLEANTITILEUVDISTORTION_ON
			   float4 staticSwitch1078 = Output_2D293_g1856;
			   #else
			   float4 staticSwitch1078 = tex2D( _Distortion, texCoord602 );
			   #endif
			   #ifdef _ENABLEDISTORTEDUVS
			   float4 staticSwitch714 = ( _DistortOverlayIntensity * staticSwitch1078 );
			   #else
			   float4 staticSwitch714 = float4( 0,0,0,0 );
			   #endif
			   float4 DistortedUVs1008 = staticSwitch714;
			   float2 uv_Flowmap1838 = i.uv0.xy;
			   float3 tex2DNode1838 = UnpackNormalScale( tex2D( _Flowmap, uv_Flowmap1838 ), 1.0f );
			   float2 appendResult1833 = (float2(tex2DNode1838.r , tex2DNode1838.g));
			   float2 temp_output_1874_0 = ( -appendResult1833 * ( _Strength * -1.0 ) );
			   float temp_output_1835_0 = ( _TimeParameters.x * _FlowSpeed );
			   float temp_output_1851_0 = frac( temp_output_1835_0 );
			   float2 FlowUVA1933 = ( temp_output_1874_0 * ( temp_output_1851_0 - 0.0 ) );
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float4 staticSwitch1971 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVA1933, 0.0 , 0.0 ) );
			   #else
			   float4 staticSwitch1971 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 );
			   #endif
			   float3 unpack567 = UnpackNormalScale( tex2D( _NormalMap, staticSwitch1971.rg ), _NormalIntensity );
			   unpack567.z = lerp( 1, unpack567.z, saturate(_NormalIntensity) );
			   float3 tex2DNode567 = unpack567;
			   float2 temp_cast_5 = (_WaterSpeedY).xx;
			   float2 panner572 = ( 1.0 * _Time.y * temp_cast_5 + texCoord576);
			   float2 FlowUVB1934 = ( float2( 0,0 ) + ( temp_output_1874_0 * ( frac( ( temp_output_1835_0 + 0.5 ) ) - 0.0 ) ) );
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float4 staticSwitch1974 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVB1934, 0.0 , 0.0 ) );
			   #else
			   float4 staticSwitch1974 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 );
			   #endif
			   float3 unpack579 = UnpackNormalScale( tex2D( _NormalMap, staticSwitch1974.rg ), _NormalIntensity );
			   unpack579.z = lerp( 1, unpack579.z, saturate(_NormalIntensity) );
			   float3 tex2DNode579 = unpack579;
			   float FlowUVAlpha1942 = abs( ( ( temp_output_1851_0 * 2.0 ) + -1.0 ) );
			   float3 lerpResult1943 = lerp( tex2DNode567 , tex2DNode579 , FlowUVAlpha1942);
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float3 staticSwitch1976 = lerpResult1943;
			   #else
			   float3 staticSwitch1976 = BlendNormal( tex2DNode567 , tex2DNode579 );
			   #endif
			   float localStochasticTiling2_g102 = ( 0.0 );
			   float2 texCoord797 = i.uv0.xy * _RainDropRippleTiling + float2( 0,0 );
			   float temp_output_852_0 = ( _RainDropRippleSpeed * -1.0 );
			   // *** BEGIN Flipbook UV Animation vars ***
			   // Total tiles of Flipbook Texture
			   float fbtotaltiles809 = 1.0 * 16.0;
			   // Offsets for cols and rows of Flipbook Texture
			   float fbcolsoffset809 = 1.0f / 1.0;
			   float fbrowsoffset809 = 1.0f / 16.0;
			   // Speed of animation
			   float fbspeed809 = _TimeParameters.x * temp_output_852_0;
			   // UV Tiling (col and row offset)
			   float2 fbtiling809 = float2(fbcolsoffset809, fbrowsoffset809);
			   // UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			   // Calculate current tile linear index
			   float fbcurrenttileindex809 = round( fmod( fbspeed809 + 0.0, fbtotaltiles809) );
			   fbcurrenttileindex809 += ( fbcurrenttileindex809 < 0) ? fbtotaltiles809 : 0;
			   // Obtain Offset X coordinate from current tile linear index
			   float fblinearindextox809 = round ( fmod ( fbcurrenttileindex809, 1.0 ) );
			   // Multiply Offset X by coloffset
			   float fboffsetx809 = fblinearindextox809 * fbcolsoffset809;
			   // Obtain Offset Y coordinate from current tile linear index
			   float fblinearindextoy809 = round( fmod( ( fbcurrenttileindex809 - fblinearindextox809 ) / 1.0, 16.0 ) );
			   // Reverse Y to get tiles from Top to Bottom
			   fblinearindextoy809 = (int)(16.0-1) - fblinearindextoy809;
			   // Multiply Offset Y by rowoffset
			   float fboffsety809 = fblinearindextoy809 * fbrowsoffset809;
			   // UV Offset
			   float2 fboffset809 = float2(fboffsetx809, fboffsety809);
			   // Flipbook UV
			   half2 fbuv809 = texCoord797 * fbtiling809 + fboffset809;
			   // *** END Flipbook UV Animation vars ***
			   float2 appendResult826 = (float2(frac( fbuv809.x ) , frac( fbuv809.y )));
			   float2 Input_UV145_g102 = ( float4( appendResult826, 0.0 , 0.0 ) + ( _DistortedUVInfluence * DistortedUVs1008 ) ).rg;
			   float2 UV2_g102 = Input_UV145_g102;
			   float2 UV12_g102 = float2( 0,0 );
			   float2 UV22_g102 = float2( 0,0 );
			   float2 UV32_g102 = float2( 0,0 );
			   float W12_g102 = 0.0;
			   float W22_g102 = 0.0;
			   float W32_g102 = 0.0;
			   StochasticTiling( UV2_g102 , UV12_g102 , UV22_g102 , UV32_g102 , W12_g102 , W22_g102 , W32_g102 );
			   float2 temp_output_10_0_g102 = ddx( Input_UV145_g102 );
			   float2 temp_output_12_0_g102 = ddy( Input_UV145_g102 );
			   float4 Output_2D293_g102 = ( ( tex2D( _BubbleBook, UV12_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W12_g102 ) + ( tex2D( _BubbleBook, UV22_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W22_g102 ) + ( tex2D( _BubbleBook, UV32_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W32_g102 ) );
			   float localStochasticTiling2_g103 = ( 0.0 );
			   float fbtotaltiles810 = 1.0 * 16.0;
			   float fbcolsoffset810 = 1.0f / 1.0;
			   float fbrowsoffset810 = 1.0f / 16.0;
			   float fbspeed810 = ( _TimeParameters.x - 2.0 ) * temp_output_852_0;
			   float2 fbtiling810 = float2(fbcolsoffset810, fbrowsoffset810);
			   float fbcurrenttileindex810 = round( fmod( fbspeed810 + 0.0, fbtotaltiles810) );
			   fbcurrenttileindex810 += ( fbcurrenttileindex810 < 0) ? fbtotaltiles810 : 0;
			   float fblinearindextox810 = round ( fmod ( fbcurrenttileindex810, 1.0 ) );
			   float fboffsetx810 = fblinearindextox810 * fbcolsoffset810;
			   float fblinearindextoy810 = round( fmod( ( fbcurrenttileindex810 - fblinearindextox810 ) / 1.0, 16.0 ) );
			   fblinearindextoy810 = (int)(16.0-1) - fblinearindextoy810;
			   float fboffsety810 = fblinearindextoy810 * fbrowsoffset810;
			   float2 fboffset810 = float2(fboffsetx810, fboffsety810);
			   half2 fbuv810 = texCoord797 * fbtiling810 + fboffset810;
			   float2 appendResult828 = (float2(frac( fbuv810.x ) , frac( fbuv810.y )));
			   float2 Input_UV145_g103 = ( float4( appendResult828, 0.0 , 0.0 ) + ( _DistortedUVInfluence * DistortedUVs1008 ) ).rg;
			   float2 UV2_g103 = Input_UV145_g103;
			   float2 UV12_g103 = float2( 0,0 );
			   float2 UV22_g103 = float2( 0,0 );
			   float2 UV32_g103 = float2( 0,0 );
			   float W12_g103 = 0.0;
			   float W22_g103 = 0.0;
			   float W32_g103 = 0.0;
			   StochasticTiling( UV2_g103 , UV12_g103 , UV22_g103 , UV32_g103 , W12_g103 , W22_g103 , W32_g103 );
			   float2 temp_output_10_0_g103 = ddx( Input_UV145_g103 );
			   float2 temp_output_12_0_g103 = ddy( Input_UV145_g103 );
			   float4 Output_2D293_g103 = ( ( tex2D( _BubbleBook, UV12_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W12_g103 ) + ( tex2D( _BubbleBook, UV22_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W22_g103 ) + ( tex2D( _BubbleBook, UV32_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W32_g103 ) );
			   float4 lerpResult814 = lerp( Output_2D293_g102 , Output_2D293_g103 , abs( ( ( 0.5 - frac( ( ( _TimeParameters.x / 4.0 ) + 0.5 ) ) ) / 0.5 ) ));
			   float4 In02_g105 = lerpResult814;
			   float3 localMyCustomExpression2_g105 = MyCustomExpression( In02_g105 );
			   float3 break836 = localMyCustomExpression2_g105;
			   float4 appendResult839 = (float4(( break836.x * _RainDropRippleIntensity ) , ( break836.y * _RainDropRippleIntensity ) , break836.z , 0.0));
			   float4 normalizeResult840 = normalize( appendResult839 );
			   #ifdef _ENABLERAINDROPRIPPLES
			   float4 staticSwitch846 = normalizeResult840;
			   #else
			   float4 staticSwitch846 = float4( staticSwitch1976 , 0.0 );
			   #endif
			   float4 RainDropRipples1004 = staticSwitch846;
			   float3 temp_output_747_0 = BlendNormal( staticSwitch1976 , RainDropRipples1004.xyz );
			   float localStochasticTiling2_g111 = ( 0.0 );
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float4 staticSwitch1982 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVA1933, 0.0 , 0.0 ) );
			   #else
			   float4 staticSwitch1982 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 );
			   #endif
			   float2 Input_UV145_g111 = staticSwitch1982.rg;
			   float2 UV2_g111 = Input_UV145_g111;
			   float2 UV12_g111 = float2( 0,0 );
			   float2 UV22_g111 = float2( 0,0 );
			   float2 UV32_g111 = float2( 0,0 );
			   float W12_g111 = 0.0;
			   float W22_g111 = 0.0;
			   float W32_g111 = 0.0;
			   StochasticTiling( UV2_g111 , UV12_g111 , UV22_g111 , UV32_g111 , W12_g111 , W22_g111 , W32_g111 );
			   float2 temp_output_10_0_g111 = ddx( Input_UV145_g111 );
			   float2 temp_output_12_0_g111 = ddy( Input_UV145_g111 );
			   float4 Output_2D293_g111 = ( ( tex2D( _NormalMap, UV12_g111, temp_output_10_0_g111, temp_output_12_0_g111 ) * W12_g111 ) + ( tex2D( _NormalMap, UV22_g111, temp_output_10_0_g111, temp_output_12_0_g111 ) * W22_g111 ) + ( tex2D( _NormalMap, UV32_g111, temp_output_10_0_g111, temp_output_12_0_g111 ) * W32_g111 ) );
			   float4 In02_g101 = Output_2D293_g111;
			   float3 localMyCustomExpression2_g101 = MyCustomExpression( In02_g101 );
			   float3 break675 = localMyCustomExpression2_g101;
			   float4 appendResult680 = (float4(( break675.x * _NormalIntensity ) , ( break675.y * _NormalIntensity ) , break675.z , 0.0));
			   float4 normalizeResult684 = normalize( appendResult680 );
			   float localStochasticTiling2_g104 = ( 0.0 );
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float4 staticSwitch1979 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVB1934, 0.0 , 0.0 ) );
			   #else
			   float4 staticSwitch1979 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 );
			   #endif
			   float2 Input_UV145_g104 = staticSwitch1979.rg;
			   float2 UV2_g104 = Input_UV145_g104;
			   float2 UV12_g104 = float2( 0,0 );
			   float2 UV22_g104 = float2( 0,0 );
			   float2 UV32_g104 = float2( 0,0 );
			   float W12_g104 = 0.0;
			   float W22_g104 = 0.0;
			   float W32_g104 = 0.0;
			   StochasticTiling( UV2_g104 , UV12_g104 , UV22_g104 , UV32_g104 , W12_g104 , W22_g104 , W32_g104 );
			   float2 temp_output_10_0_g104 = ddx( Input_UV145_g104 );
			   float2 temp_output_12_0_g104 = ddy( Input_UV145_g104 );
			   float4 Output_2D293_g104 = ( ( tex2D( _NormalMap, UV12_g104, temp_output_10_0_g104, temp_output_12_0_g104 ) * W12_g104 ) + ( tex2D( _NormalMap, UV22_g104, temp_output_10_0_g104, temp_output_12_0_g104 ) * W22_g104 ) + ( tex2D( _NormalMap, UV32_g104, temp_output_10_0_g104, temp_output_12_0_g104 ) * W32_g104 ) );
			   float4 In02_g99 = Output_2D293_g104;
			   float3 localMyCustomExpression2_g99 = MyCustomExpression( In02_g99 );
			   float3 break678 = localMyCustomExpression2_g99;
			   float4 appendResult683 = (float4(( break678.x * _NormalIntensity ) , ( break678.y * _NormalIntensity ) , break678.z , 0.0));
			   float4 normalizeResult685 = normalize( appendResult683 );
			   float4 lerpResult1945 = lerp( normalizeResult684 , normalizeResult685 , FlowUVAlpha1942);
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float4 staticSwitch1983 = lerpResult1945;
			   #else
			   float4 staticSwitch1983 = float4( BlendNormal( normalizeResult684.xyz , normalizeResult685.xyz ) , 0.0 );
			   #endif
			   #ifdef _ENABLEANTITILENORMALS_ON
			   float3 staticSwitch644 = BlendNormal( staticSwitch1983.xyz , RainDropRipples1004.xyz );
			   #else
			   float3 staticSwitch644 = temp_output_747_0;
			   #endif
			   float2 temp_cast_32 = (_MicroNormalSpeedX).xx;
			   float2 texCoord591 = i.uv0.xy * _MicroNormalTiling + float2( 0,0 );
			   float2 panner588 = ( 1.0 * _Time.y * temp_cast_32 + texCoord591);
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float4 staticSwitch1993 = ( float4( panner588, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVA1933, 0.0 , 0.0 ) );
			   #else
			   float4 staticSwitch1993 = ( float4( panner588, 0.0 , 0.0 ) + DistortedUVs1008 );
			   #endif
			   float3 ase_worldPos = i.ase_texcoord3.xyz;
			   float temp_output_1_0_g98 = _MicroNormalsNearFadeDistance;
			   float temp_output_626_0 = ( _MicroNormalIntensity * ( 1.0 - saturate( ( ( length( ( ase_worldPos - _WorldSpaceCameraPos ) ) - temp_output_1_0_g98 ) / ( _MicroNormalsFarFadeDistance - temp_output_1_0_g98 ) ) ) ) );
			   float3 unpack592 = UnpackNormalScale( tex2D( _MicroNormalMap, staticSwitch1993.rg ), temp_output_626_0 );
			   unpack592.z = lerp( 1, unpack592.z, saturate(temp_output_626_0) );
			   float3 tex2DNode592 = unpack592;
			   float2 temp_cast_37 = (_MicroNormalSpeedY).xx;
			   float2 panner587 = ( 1.0 * _Time.y * temp_cast_37 + texCoord591);
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float4 staticSwitch1994 = ( float4( panner587, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVB1934, 0.0 , 0.0 ) );
			   #else
			   float4 staticSwitch1994 = ( float4( panner587, 0.0 , 0.0 ) + DistortedUVs1008 );
			   #endif
			   float3 unpack593 = UnpackNormalScale( tex2D( _MicroNormalMap, staticSwitch1994.rg ), temp_output_626_0 );
			   unpack593.z = lerp( 1, unpack593.z, saturate(temp_output_626_0) );
			   float3 tex2DNode593 = unpack593;
			   float3 lerpResult1948 = lerp( tex2DNode592 , tex2DNode593 , FlowUVAlpha1942);
			   #ifdef _ENABLEFLOWMAPPEDUVS_ON
			   float3 staticSwitch1988 = lerpResult1948;
			   #else
			   float3 staticSwitch1988 = BlendNormal( tex2DNode592 , tex2DNode593 );
			   #endif
			   float3 MicroNormals1006 = BlendNormal( staticSwitch1988 , staticSwitch644 );
			   #ifdef _MICRONORMALS
			   float3 staticSwitch585 = MicroNormals1006;
			   #else
			   float3 staticSwitch585 = staticSwitch644;
			   #endif
			   float3 Normals982 = staticSwitch585;
			   float localCalculateUVsSharp110_g1862 = ( 0.0 );
			   float2 uv_RippleRenderTexture = i.uv0.xy * _RippleRenderTexture_ST.xy + _RippleRenderTexture_ST.zw;
			   float2 temp_output_85_0_g1862 = uv_RippleRenderTexture;
			   float2 UV110_g1862 = temp_output_85_0_g1862;
			   float4 TexelSize110_g1862 = _RippleRenderTexture_TexelSize;
			   float2 UV0110_g1862 = float2( 0,0 );
			   float2 UV1110_g1862 = float2( 0,0 );
			   float2 UV2110_g1862 = float2( 0,0 );
			   {
			   {
			       UV110_g1862.y -= TexelSize110_g1862.y * 0.5;
			       UV0110_g1862 = UV110_g1862;
			       UV1110_g1862 = UV110_g1862 + float2( TexelSize110_g1862.x, 0 );
			       UV2110_g1862 = UV110_g1862 + float2( 0, TexelSize110_g1862.y );
			   }
			   }
			   float4 break134_g1862 = tex2D( _RippleRenderTexture, UV0110_g1862 );
			   float S0128_g1862 = break134_g1862.r;
			   float4 break136_g1862 = tex2D( _RippleRenderTexture, UV1110_g1862 );
			   float S1128_g1862 = break136_g1862.r;
			   float4 break138_g1862 = tex2D( _RippleRenderTexture, UV2110_g1862 );
			   float S2128_g1862 = break138_g1862.r;
			   float temp_output_91_0_g1862 = _DynamicRippleIntensity;
			   float Strength128_g1862 = temp_output_91_0_g1862;
			   float3 localCombineSamplesSharp128_g1862 = CombineSamplesSharp128_g1862( S0128_g1862 , S1128_g1862 , S2128_g1862 , Strength128_g1862 );
			   float3 temp_output_1565_40 = localCombineSamplesSharp128_g1862;
			   #ifdef _ENABLEDYNAMICRIPPLES_ON
			   float3 staticSwitch2072 = BlendNormal( Normals982 , temp_output_1565_40 );
			   #else
			   float3 staticSwitch2072 = Normals982;
			   #endif
			   float3 NormalsFinal1751 = staticSwitch2072;
			   
			   float4 WaterColor1270 = _WaterColor;
			   float4 screenPos = i.ase_texcoord4;
			   float4 ase_screenPosNorm = screenPos / screenPos.w;
			   ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			   float screenDepth2206 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
			   float distanceDepth2206 = saturate( abs( ( screenDepth2206 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
			   #ifdef _ENABLESOFTINTERSECTION_ON
			   float staticSwitch1501 = distanceDepth2206;
			   #else
			   float staticSwitch1501 = WaterColor1270.a;
			   #endif
			   float2 uv_AlphaMask2197 = i.uv0.xy;
			   float smoothstepResult2199 = smoothstep( 0.0 , _AlphaFalloff , tex2D( _AlphaMask, uv_AlphaMask2197 ).a);
			   #ifdef _ENABLEALPHAMASKING_ON
			   float staticSwitch2208 = smoothstepResult2199;
			   #else
			   float staticSwitch2208 = ( 0.0 + 1.0 );
			   #endif
			   float eyeDepth = i.ase_texcoord3.w;
			   float cameraDepthFade2233 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
			   #ifdef _ENABLECAMERADEPTHFADING_ON
			   float staticSwitch2230 = saturate( cameraDepthFade2233 );
			   #else
			   float staticSwitch2230 = 1.0;
			   #endif
			   float Alpha1498 = ( staticSwitch1501 * staticSwitch2208 * WaterColor1270.a * staticSwitch2230 );
			   
			
			
			   half4 normals = half4(0, 0, 0, 1);
			   half3 normalTS = NormalsFinal1751;
			
			// Begin Injection FRAG_NORMALS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				//half4 normalMap = SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, i.uv0XY_bitZ_fog.xy);
				//half3 normalTS = UnpackNormal(normalMap);
				//normalTS = _Normals ? normalTS : half3(0, 0, 1);
			
			
				half3x3 TStoWS = half3x3(
					i.normalWS.w, i.tanYZ_bitXY.z, i.normalWS.x,
					i.tanYZ_bitXY.x, i.tanYZ_bitXY.w, i.normalWS.y,
					i.tanYZ_bitXY.y, i.uv0XY_bitZ_fog.z, i.normalWS.z
					);
				half3 normalWS = mul(TStoWS, normalTS);
				normalWS = normalize(normalWS);
				
				normals = half4(EncodeWSNormalForNormalsTex(normalWS),0);
			// End Injection FRAG_NORMALS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				half alpha = Alpha1498;
				half alphaclip = half(0);
				half alphaclipthresholdshadow = half(0);
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif
				
				#if defined(_ALPHATEST_ON)
					clip(alpha - alphaclip);
				#endif
				
				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif
				
				return normals;
			}
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }
			
			
			Cull Off

			HLSLPROGRAM
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _SLZ_SPECULAR_SETUP
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define ASE_SRP_VERSION -1
			#define REQUIRE_OPAQUE_TEXTURE 1
			#define REQUIRE_DEPTH_TEXTURE 1

			#define _NORMAL_DROPOFF_TS 1
			#define _EMISSION
			#define _NORMALMAP 1

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_META
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			//StandardMeta.hlsl---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//
			//
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------

			#define SHADERPASS SHADERPASS_META
			#define PASS_META

			#if defined(SHADER_API_MOBILE)


			#else


			#endif

			//#pragma shader_feature _ EDITOR_VISUALIZATION


			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _WAVETYPE_NONE _WAVETYPE_GERSTNERWAVES _WAVETYPE_3DTEXTURE _WAVETYPE_GERSTNERAND3DTEXTURE _WAVETYPE_NOISE _WAVETYPE_DYNAMICRIPPLES
			#pragma shader_feature_local _ENABLEDYNAMICRIPPLES_ON
			#pragma shader_feature_local _DEBUGVIEW1_ON
			#pragma shader_feature_local _DEBUGVIEW_ON
			#pragma shader_feature_local _ENABLEFOAM_ON
			#pragma shader_feature_local _ENABLEPOSTPROCESSING_ON
			#pragma shader_feature_local _ENABLEDEPTHCOLORS_ON
			#pragma shader_feature_local _DISTORTIONTYPE_NONE _DISTORTIONTYPE_DEFAULT _DISTORTIONTYPE_CHROMATICABERRATION
			#pragma shader_feature_local _ENABLEDEPTHMASKEDREFRACTION_ON
			#pragma shader_feature_local _ENABLEFLOWMAPPEDUVS_ON
			#pragma shader_feature_local _ENABLEDISTORTEDUVS
			#pragma shader_feature_local _ENABLEANTITILEUVDISTORTION_ON
			#pragma shader_feature_local _ENABLERAINDROPRIPPLES
			#pragma shader_feature_local _DEPTHCOLORMODE_REGULARRECOMMENDED _DEPTHCOLORMODE_DISTANCEBASED
			#pragma shader_feature_local _GRAYSCALE_ON
			#pragma shader_feature_local _MIDTONES_ON
			#pragma shader_feature_local _POSTERIZE_ON
			#pragma shader_feature_local _CONTRAST_ON
			#pragma shader_feature_local _SATURATION_ON
			#pragma shader_feature_local _ENABLEANTITILEFOAM_ON
			#pragma shader_feature_local _ENABLEFOAMDISTORTION_ON
			#pragma shader_feature_local _ENABLEFOAMPARALLAX_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEALPHAMASKING_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON


			//TEXTURE2D(_BaseMap);
			//SAMPLER(sampler_BaseMap);

			// Begin Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------
			//TEXTURE2D(_EmissionMap);
			// End Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------

			CBUFFER_START(UnityPerMaterial)
				float4 _DepthColor;
				float4 _DeepColor;
				float4 _ShallowColor;
				float4 _WaterColor;
				float4 _RippleRenderTexture_TexelSize;
				float4 _RippleRenderTexture_ST;
				float4 _FoamColor;
				float4 _FoamTexture_ST;
				float2 _DistortionTiling;
				float2 _NormalTiling;
				float2 _FoamTiling;
				float2 _RainDropRippleTiling;
				float2 _MicroNormalTiling;
				float2 _NoiseWavesDirection;
				float _FoamStrength;
				float _Blue;
				float _Green;
				float _Red;
				float _FoamSpeedX;
				float _PosterizationIntensity;
				float _ContrastIntensity;
				float _SaturationIntensity;
				float _FoamSpeedY;
				float _FoamDistortion;
				float _FoamParallaxScale;
				float _FoamAlpha;
				float _DebugContrast;
				float _DebugContrast1;
				float _MicroNormalSpeedX;
				float _MicroNormalIntensity;
				float _MicroNormalsNearFadeDistance;
				float _MicroNormalsFarFadeDistance;
				float _MicroNormalSpeedY;
				float _Cull;
				float _Reflectivity;
				float _Smoothness;
				float _SoftIntersectionIntensity;
				float _AlphaFalloff;
				float _DistortedUVInfluence1;
				float _DepthTranslucency;
				float _Steepness;
				float _Murkiness;
				float _Wavelength;
				float _Amplitude;
				float _NumberOfWaves;
				float _Speed;
				float _DisplacementTiling;
				float _WaveSpeed;
				float _WaveHeight;
				float _MixingIntensity;
				float _NoiseWavesSpeed;
				float _NoiseWavesScale;
				float _NoiseWavesSize;
				float _DynamicRippleWaveHeight;
				float _DistortionIntensity;
				float _WaterDepth;
				float _WaterSpeedX;
				float _DistortionSpeedX;
				float _DistortionSpeedY;
				float _Strength;
				float _FlowSpeed;
				float _NormalIntensity;
				float _WaterSpeedY;
				float _RainDropRippleSpeed;
				float _DistortedUVInfluence;
				float _RainDropRippleIntensity;
				float _DynamicRippleIntensity;
				float _RGBOffset;
				float _Clarity;
				float _CDFalloff;
				float _DistortOverlayIntensity;
				float _CDDistance;
				//float4 _BaseMap_ST;
				//half4 _BaseColor;
			// Begin Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			//float4 _DetailMap_ST;
			//half  _Details;
			//half  _Normals;
			// End Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
				float _SSRTemporalMul;
			// End Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_Emission_CBuffer.hlsl ----------------------------------------------------------
				//half  _Emission;
				//half4 _EmissionColor;
				//half  _EmissionFalloff;
				//half  _BakedMutiplier;
			// End Injection MATERIAL_CBUFFER from Injection_Emission_CBuffer.hlsl ----------------------------------------------------------
				//int _Surface;
			CBUFFER_END
			sampler3D _Displacement3DTexture;
			sampler2D _RippleRenderTexture;
			sampler2D _NormalMap;
			sampler2D _Distortion;
			sampler2D _Flowmap;
			sampler2D _BubbleBook;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _FoamTexture;
			sampler2D _AlphaMask;


			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 uv3 : TEXCOORD3;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			
				#ifdef EDITOR_VISUALIZATION
				float4 VizUV : TEXCOORD1;
				float4 LightCoord : TEXCOORD2;
				#endif
			
			
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			
			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			inline float3 MyCustomExpression( half4 In0 )
			{
				return UnpackNormal(In0);;
			}
			
			float3 CombineSamplesSharp128_g1862( float S0, float S1, float S2, float Strength )
			{
				{
				    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
				    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
				    return normalize( cross( va, vb ) );
				}
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			float RBGToLuminance2_g1886( float3 Color )
			{
				float fmin = min(min(Color.r, Color.g), Color.b);
				float fmax = max(max(Color.r, Color.g), Color.b);
				return (fmax + fmin) / 2.0;
			}
			
			inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
			{
				float3 result = 0;
				int stepIndex = 0;
				int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
				float layerHeight = 1.0 / numSteps;
				float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
				uvs.xy += refPlane * plane;
				float2 deltaTex = -plane * layerHeight;
				float2 prevTexOffset = 0;
				float prevRayZ = 1.0f;
				float prevHeight = 0.0f;
				float2 currTexOffset = deltaTex;
				float currRayZ = 1.0f - layerHeight;
				float currHeight = 0.0f;
				float intersection = 0;
				float2 finalTexOffset = 0;
				while ( stepIndex < numSteps + 1 )
				{
				 	currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r;
				 	if ( currHeight > currRayZ )
				 	{
				 	 	stepIndex = numSteps + 1;
				 	}
				 	else
				 	{
				 	 	stepIndex++;
				 	 	prevTexOffset = currTexOffset;
				 	 	prevRayZ = currRayZ;
				 	 	prevHeight = currHeight;
				 	 	currTexOffset += deltaTex;
				 	 	currRayZ -= layerHeight;
				 	}
				}
				int sectionSteps = 2;
				int sectionIndex = 0;
				float newZ = 0;
				float newHeight = 0;
				while ( sectionIndex < sectionSteps )
				{
				 	intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				 	finalTexOffset = prevTexOffset + intersection * deltaTex;
				 	newZ = prevRayZ - intersection * layerHeight;
				 	newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
				 	if ( newHeight > newZ )
				 	{
				 	 	currTexOffset = finalTexOffset;
				 	 	currHeight = newHeight;
				 	 	currRayZ = newZ;
				 	 	deltaTex = intersection * deltaTex;
				 	 	layerHeight = intersection * layerHeight;
				 	}
				 	else
				 	{
				 	 	prevTexOffset = finalTexOffset;
				 	 	prevHeight = newHeight;
				 	 	prevRayZ = newZ;
				 	 	deltaTex = ( 1 - intersection ) * deltaTex;
				 	 	layerHeight = ( 1 - intersection ) * layerHeight;
				 	}
				 	sectionIndex++;
				}
				return uvs.xy + finalTexOffset;
			}
			

			v2f vert(appdata v  )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float temp_output_15_0_g1860 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1860 = _Amplitude;
				float temp_output_1142_0 = ( _NumberOfWaves * -1.0 );
				float temp_output_58_0_g1860 = ( ( _Steepness / ( ( temp_output_15_0_g1860 * temp_output_26_0_g1860 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1860 );
				float3 temp_output_5_0_g1860 = (float4(1,0.8896552,0,1)).rgb;
				float3 normalizeResult4_g1860 = normalize( temp_output_5_0_g1860 );
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 transform69_g1860 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1860 = dot( normalizeResult4_g1860 , (transform69_g1860).xyz );
				float temp_output_21_0_g1860 = ( ( dotResult11_g1860 * temp_output_15_0_g1860 ) + ( ( _Speed * temp_output_15_0_g1860 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1860 = cos( temp_output_21_0_g1860 );
				float4 appendResult54_g1860 = (float4(( temp_output_58_0_g1860 * ( (temp_output_5_0_g1860).x * temp_output_62_0_g1860 ) ) , ( temp_output_58_0_g1860 * ( temp_output_62_0_g1860 * (temp_output_5_0_g1860).y ) ) , ( sin( temp_output_21_0_g1860 ) * ( temp_output_26_0_g1860 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1857 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1857 = _Amplitude;
				float temp_output_58_0_g1857 = ( ( _Steepness / ( ( temp_output_15_0_g1857 * temp_output_26_0_g1857 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1857 );
				float3 temp_output_5_0_g1857 = (( float4(0.7379313,0,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1857 = normalize( temp_output_5_0_g1857 );
				float4 transform69_g1857 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1857 = dot( normalizeResult4_g1857 , (transform69_g1857).xyz );
				float temp_output_21_0_g1857 = ( ( dotResult11_g1857 * temp_output_15_0_g1857 ) + ( ( _Speed * temp_output_15_0_g1857 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1857 = cos( temp_output_21_0_g1857 );
				float4 appendResult54_g1857 = (float4(( temp_output_58_0_g1857 * ( (temp_output_5_0_g1857).x * temp_output_62_0_g1857 ) ) , ( temp_output_58_0_g1857 * ( temp_output_62_0_g1857 * (temp_output_5_0_g1857).y ) ) , ( sin( temp_output_21_0_g1857 ) * ( temp_output_26_0_g1857 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1858 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1858 = _Amplitude;
				float temp_output_58_0_g1858 = ( ( _Steepness / ( ( temp_output_15_0_g1858 * temp_output_26_0_g1858 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1858 );
				float3 temp_output_5_0_g1858 = (( float4(0,0.9586205,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1858 = normalize( temp_output_5_0_g1858 );
				float4 transform69_g1858 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1858 = dot( normalizeResult4_g1858 , (transform69_g1858).xyz );
				float temp_output_21_0_g1858 = ( ( dotResult11_g1858 * temp_output_15_0_g1858 ) + ( ( _Speed * temp_output_15_0_g1858 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1858 = cos( temp_output_21_0_g1858 );
				float4 appendResult54_g1858 = (float4(( temp_output_58_0_g1858 * ( (temp_output_5_0_g1858).x * temp_output_62_0_g1858 ) ) , ( temp_output_58_0_g1858 * ( temp_output_62_0_g1858 * (temp_output_5_0_g1858).y ) ) , ( sin( temp_output_21_0_g1858 ) * ( temp_output_26_0_g1858 * 2.0 ) ) , 0.0));
				float temp_output_15_0_g1859 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_26_0_g1859 = _Amplitude;
				float temp_output_58_0_g1859 = ( ( _Steepness / ( ( temp_output_15_0_g1859 * temp_output_26_0_g1859 ) * ( temp_output_1142_0 * ( 2.0 * PI ) ) ) ) * temp_output_26_0_g1859 );
				float3 temp_output_5_0_g1859 = (( float4(1,0.4344828,0,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1859 = normalize( temp_output_5_0_g1859 );
				float4 transform69_g1859 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1859 = dot( normalizeResult4_g1859 , (transform69_g1859).xyz );
				float temp_output_21_0_g1859 = ( ( dotResult11_g1859 * temp_output_15_0_g1859 ) + ( ( _Speed * temp_output_15_0_g1859 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1859 = cos( temp_output_21_0_g1859 );
				float4 appendResult54_g1859 = (float4(( temp_output_58_0_g1859 * ( (temp_output_5_0_g1859).x * temp_output_62_0_g1859 ) ) , ( temp_output_58_0_g1859 * ( temp_output_62_0_g1859 * (temp_output_5_0_g1859).y ) ) , ( sin( temp_output_21_0_g1859 ) * ( temp_output_26_0_g1859 * 2.0 ) ) , 0.0));
				float4 GerstnerWaves1121 = ( appendResult54_g1860 + appendResult54_g1857 + appendResult54_g1858 + appendResult54_g1859 );
				float mulTime1086 = _TimeParameters.x * _WaveSpeed;
				float3 appendResult1085 = (float3(( ase_worldPos.x * _DisplacementTiling ) , ( ase_worldPos.z * _DisplacementTiling ) , mulTime1086));
				float4 ThreeDTexture1090 = ( tex3Dlod( _Displacement3DTexture, float4( appendResult1085, 0.0) ) * float4( ( float3(0,1,0) * (0.0 + (_WaveHeight - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) ) , 0.0 ) );
				float4 MixedWaves1107 = ( ( GerstnerWaves1121 * _MixingIntensity ) + ( ThreeDTexture1090 * _MixingIntensity ) );
				float mulTime1521 = _TimeParameters.x * _NoiseWavesSpeed;
				float2 texCoord1513 = v.uv0.xy * float2( 1,1 ) + ( mulTime1521 * _NoiseWavesDirection );
				float simplePerlin2D1541 = snoise( texCoord1513*_NoiseWavesScale );
				simplePerlin2D1541 = simplePerlin2D1541*0.5 + 0.5;
				float NoiseWaves1548 = (0.0 + (simplePerlin2D1541 - 0.0) * (1.0 - 0.0) / (_NoiseWavesSize - 0.0));
				float4 temp_cast_7 = (NoiseWaves1548).xxxx;
				float2 uv_RippleRenderTexture = v.uv0.xy * _RippleRenderTexture_ST.xy + _RippleRenderTexture_ST.zw;
				float4 tex2DNode1574 = tex2Dlod( _RippleRenderTexture, float4( uv_RippleRenderTexture, 0, 0.0) );
				#ifdef _ENABLEDYNAMICRIPPLES_ON
				float staticSwitch2073 = ( tex2DNode1574.r * ( _DynamicRippleWaveHeight * 0.1 ) );
				#else
				float staticSwitch2073 = 0.0;
				#endif
				float DynamicRippleWaves1750 = staticSwitch2073;
				float4 temp_cast_8 = (DynamicRippleWaves1750).xxxx;
				#if defined(_WAVETYPE_NONE)
				float4 staticSwitch1066 = float4( 0,0,0,0 );
				#elif defined(_WAVETYPE_GERSTNERWAVES)
				float4 staticSwitch1066 = GerstnerWaves1121;
				#elif defined(_WAVETYPE_3DTEXTURE)
				float4 staticSwitch1066 = ThreeDTexture1090;
				#elif defined(_WAVETYPE_GERSTNERAND3DTEXTURE)
				float4 staticSwitch1066 = MixedWaves1107;
				#elif defined(_WAVETYPE_NOISE)
				float4 staticSwitch1066 = temp_cast_7;
				#elif defined(_WAVETYPE_DYNAMICRIPPLES)
				float4 staticSwitch1066 = temp_cast_8;
				#else
				float4 staticSwitch1066 = float4( 0,0,0,0 );
				#endif
				float4 Waves2060 = staticSwitch1066;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord4.x = eyeDepth;
				o.ase_texcoord4.yzw = ase_worldPos;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord5.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord6.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord7.xyz = ase_worldBitangent;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
				float3 vertexValue = Waves2060.xyz;
				v.vertex.xyz += vertexValue;
			
				o.vertex = UnityMetaVertexPosition(v.vertex.xyz, v.uv1.xy, v.uv2.xy);
				//o.uv = TRANSFORM_TEX(v.uv0.xy, _BaseMap);
			
				o.uv = v.uv0.xy;
				#ifdef EDITOR_VISUALIZATION
					float2 vizUV = 0;
					float4 lightCoord = 0;
					UnityEditorVizData(v.vertex.xyz, v.uv0.xy, v.uv1.xy, v.uv2.xy, vizUV, lightCoord);
					o.VizUV = float4(vizUV, 0, 0);
					o.LightCoord = lightCoord;
				#endif
			
			
				return o;
			}

			half4 frag(v2f i  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				float4 screenPos = i.ase_texcoord3;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 temp_cast_0 = (_WaterSpeedX).xx;
				float2 texCoord576 = i.uv * _NormalTiling + float2( 0,0 );
				float2 panner573 = ( 1.0 * _Time.y * temp_cast_0 + texCoord576);
				float2 appendResult705 = (float2(( _DistortionSpeedX * _TimeParameters.x ) , ( _DistortionSpeedY * _TimeParameters.x )));
				float2 texCoord602 = i.uv * _DistortionTiling + appendResult705;
				float localStochasticTiling2_g1856 = ( 0.0 );
				float2 Input_UV145_g1856 = texCoord602;
				float2 UV2_g1856 = Input_UV145_g1856;
				float2 UV12_g1856 = float2( 0,0 );
				float2 UV22_g1856 = float2( 0,0 );
				float2 UV32_g1856 = float2( 0,0 );
				float W12_g1856 = 0.0;
				float W22_g1856 = 0.0;
				float W32_g1856 = 0.0;
				StochasticTiling( UV2_g1856 , UV12_g1856 , UV22_g1856 , UV32_g1856 , W12_g1856 , W22_g1856 , W32_g1856 );
				float2 temp_output_10_0_g1856 = ddx( Input_UV145_g1856 );
				float2 temp_output_12_0_g1856 = ddy( Input_UV145_g1856 );
				float4 Output_2D293_g1856 = ( ( tex2D( _Distortion, UV12_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W12_g1856 ) + ( tex2D( _Distortion, UV22_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W22_g1856 ) + ( tex2D( _Distortion, UV32_g1856, temp_output_10_0_g1856, temp_output_12_0_g1856 ) * W32_g1856 ) );
				#ifdef _ENABLEANTITILEUVDISTORTION_ON
				float4 staticSwitch1078 = Output_2D293_g1856;
				#else
				float4 staticSwitch1078 = tex2D( _Distortion, texCoord602 );
				#endif
				#ifdef _ENABLEDISTORTEDUVS
				float4 staticSwitch714 = ( _DistortOverlayIntensity * staticSwitch1078 );
				#else
				float4 staticSwitch714 = float4( 0,0,0,0 );
				#endif
				float4 DistortedUVs1008 = staticSwitch714;
				float2 uv_Flowmap1838 = i.uv;
				float3 tex2DNode1838 = UnpackNormalScale( tex2D( _Flowmap, uv_Flowmap1838 ), 1.0f );
				float2 appendResult1833 = (float2(tex2DNode1838.r , tex2DNode1838.g));
				float2 temp_output_1874_0 = ( -appendResult1833 * ( _Strength * -1.0 ) );
				float temp_output_1835_0 = ( _TimeParameters.x * _FlowSpeed );
				float temp_output_1851_0 = frac( temp_output_1835_0 );
				float2 FlowUVA1933 = ( temp_output_1874_0 * ( temp_output_1851_0 - 0.0 ) );
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1971 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVA1933, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1971 = ( float4( panner573, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float3 unpack567 = UnpackNormalScale( tex2D( _NormalMap, staticSwitch1971.rg ), _NormalIntensity );
				unpack567.z = lerp( 1, unpack567.z, saturate(_NormalIntensity) );
				float3 tex2DNode567 = unpack567;
				float2 temp_cast_5 = (_WaterSpeedY).xx;
				float2 panner572 = ( 1.0 * _Time.y * temp_cast_5 + texCoord576);
				float2 FlowUVB1934 = ( float2( 0,0 ) + ( temp_output_1874_0 * ( frac( ( temp_output_1835_0 + 0.5 ) ) - 0.0 ) ) );
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float4 staticSwitch1974 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 + float4( FlowUVB1934, 0.0 , 0.0 ) );
				#else
				float4 staticSwitch1974 = ( float4( panner572, 0.0 , 0.0 ) + DistortedUVs1008 );
				#endif
				float3 unpack579 = UnpackNormalScale( tex2D( _NormalMap, staticSwitch1974.rg ), _NormalIntensity );
				unpack579.z = lerp( 1, unpack579.z, saturate(_NormalIntensity) );
				float3 tex2DNode579 = unpack579;
				float FlowUVAlpha1942 = abs( ( ( temp_output_1851_0 * 2.0 ) + -1.0 ) );
				float3 lerpResult1943 = lerp( tex2DNode567 , tex2DNode579 , FlowUVAlpha1942);
				#ifdef _ENABLEFLOWMAPPEDUVS_ON
				float3 staticSwitch1976 = lerpResult1943;
				#else
				float3 staticSwitch1976 = BlendNormal( tex2DNode567 , tex2DNode579 );
				#endif
				float localStochasticTiling2_g102 = ( 0.0 );
				float2 texCoord797 = i.uv * _RainDropRippleTiling + float2( 0,0 );
				float temp_output_852_0 = ( _RainDropRippleSpeed * -1.0 );
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles809 = 1.0 * 16.0;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset809 = 1.0f / 1.0;
				float fbrowsoffset809 = 1.0f / 16.0;
				// Speed of animation
				float fbspeed809 = _TimeParameters.x * temp_output_852_0;
				// UV Tiling (col and row offset)
				float2 fbtiling809 = float2(fbcolsoffset809, fbrowsoffset809);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex809 = round( fmod( fbspeed809 + 0.0, fbtotaltiles809) );
				fbcurrenttileindex809 += ( fbcurrenttileindex809 < 0) ? fbtotaltiles809 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox809 = round ( fmod ( fbcurrenttileindex809, 1.0 ) );
				// Multiply Offset X by coloffset
				float fboffsetx809 = fblinearindextox809 * fbcolsoffset809;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy809 = round( fmod( ( fbcurrenttileindex809 - fblinearindextox809 ) / 1.0, 16.0 ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy809 = (int)(16.0-1) - fblinearindextoy809;
				// Multiply Offset Y by rowoffset
				float fboffsety809 = fblinearindextoy809 * fbrowsoffset809;
				// UV Offset
				float2 fboffset809 = float2(fboffsetx809, fboffsety809);
				// Flipbook UV
				half2 fbuv809 = texCoord797 * fbtiling809 + fboffset809;
				// *** END Flipbook UV Animation vars ***
				float2 appendResult826 = (float2(frac( fbuv809.x ) , frac( fbuv809.y )));
				float2 Input_UV145_g102 = ( float4( appendResult826, 0.0 , 0.0 ) + ( _DistortedUVInfluence * DistortedUVs1008 ) ).rg;
				float2 UV2_g102 = Input_UV145_g102;
				float2 UV12_g102 = float2( 0,0 );
				float2 UV22_g102 = float2( 0,0 );
				float2 UV32_g102 = float2( 0,0 );
				float W12_g102 = 0.0;
				float W22_g102 = 0.0;
				float W32_g102 = 0.0;
				StochasticTiling( UV2_g102 , UV12_g102 , UV22_g102 , UV32_g102 , W12_g102 , W22_g102 , W32_g102 );
				float2 temp_output_10_0_g102 = ddx( Input_UV145_g102 );
				float2 temp_output_12_0_g102 = ddy( Input_UV145_g102 );
				float4 Output_2D293_g102 = ( ( tex2D( _BubbleBook, UV12_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W12_g102 ) + ( tex2D( _BubbleBook, UV22_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W22_g102 ) + ( tex2D( _BubbleBook, UV32_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W32_g102 ) );
				float localStochasticTiling2_g103 = ( 0.0 );
				float fbtotaltiles810 = 1.0 * 16.0;
				float fbcolsoffset810 = 1.0f / 1.0;
				float fbrowsoffset810 = 1.0f / 16.0;
				float fbspeed810 = ( _TimeParameters.x - 2.0 ) * temp_output_852_0;
				float2 fbtiling810 = float2(fbcolsoffset810, fbrowsoffset810);
				float fbcurrenttileindex810 = round( fmod( fbspeed810 + 0.0, fbtotaltiles810) );
				fbcurrenttileindex810 += ( fbcurrenttileindex810 < 0) ? fbtotaltiles810 : 0;
				float fblinearindextox810 = round ( fmod ( fbcurrenttileindex810, 1.0 ) );
				float fboffsetx810 = fblinearindextox810 * fbcolsoffset810;
				float fblinearindextoy810 = round( fmod( ( fbcurrenttileindex810 - fblinearindextox810 ) / 1.0, 16.0 ) );
				fblinearindextoy810 = (int)(16.0-1) - fblinearindextoy810;
				float fboffsety810 = fblinearindextoy810 * fbrowsoffset810;
				float2 fboffset810 = float2(fboffsetx810, fboffsety810);
				half2 fbuv810 = texCoord797 * fbtiling810 + fboffset810;
				float2 appendResult828 = (float2(frac( fbuv810.x ) , frac( fbuv810.y )));
				float2 Input_UV145_g103 = ( float4( appendResult828, 0.0 , 0.0 ) + ( _DistortedUVInfluence * DistortedUVs1008 ) ).rg;
				float2 UV2_g103 = Input_UV145_g103;
				float2 UV12_g103 = float2( 0,0 );
				float2 UV22_g103 = float2( 0,0 );
				float2 UV32_g103 = float2( 0,0 );
				float W12_g103 = 0.0;
				float W22_g103 = 0.0;
				float W32_g103 = 0.0;
				StochasticTiling( UV2_g103 , UV12_g103 , UV22_g103 , UV32_g103 , W12_g103 , W22_g103 , W32_g103 );
				float2 temp_output_10_0_g103 = ddx( Input_UV145_g103 );
				float2 temp_output_12_0_g103 = ddy( Input_UV145_g103 );
				float4 Output_2D293_g103 = ( ( tex2D( _BubbleBook, UV12_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W12_g103 ) + ( tex2D( _BubbleBook, UV22_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W22_g103 ) + ( tex2D( _BubbleBook, UV32_g103, temp_output_10_0_g103, temp_output_12_0_g103 ) * W32_g103 ) );
				float4 lerpResult814 = lerp( Output_2D293_g102 , Output_2D293_g103 , abs( ( ( 0.5 - frac( ( ( _TimeParameters.x / 4.0 ) + 0.5 ) ) ) / 0.5 ) ));
				float4 In02_g105 = lerpResult814;
				float3 localMyCustomExpression2_g105 = MyCustomExpression( In02_g105 );
				float3 break836 = localMyCustomExpression2_g105;
				float4 appendResult839 = (float4(( break836.x * _RainDropRippleIntensity ) , ( break836.y * _RainDropRippleIntensity ) , break836.z , 0.0));
				float4 normalizeResult840 = normalize( appendResult839 );
				#ifdef _ENABLERAINDROPRIPPLES
				float4 staticSwitch846 = normalizeResult840;
				#else
				float4 staticSwitch846 = float4( staticSwitch1976 , 0.0 );
				#endif
				float4 RainDropRipples1004 = staticSwitch846;
				float3 temp_output_747_0 = BlendNormal( staticSwitch1976 , RainDropRipples1004.xyz );
				float localCalculateUVsSharp110_g1862 = ( 0.0 );
				float2 uv_RippleRenderTexture = i.uv * _RippleRenderTexture_ST.xy + _RippleRenderTexture_ST.zw;
				float2 temp_output_85_0_g1862 = uv_RippleRenderTexture;
				float2 UV110_g1862 = temp_output_85_0_g1862;
				float4 TexelSize110_g1862 = _RippleRenderTexture_TexelSize;
				float2 UV0110_g1862 = float2( 0,0 );
				float2 UV1110_g1862 = float2( 0,0 );
				float2 UV2110_g1862 = float2( 0,0 );
				{
				{
				    UV110_g1862.y -= TexelSize110_g1862.y * 0.5;
				    UV0110_g1862 = UV110_g1862;
				    UV1110_g1862 = UV110_g1862 + float2( TexelSize110_g1862.x, 0 );
				    UV2110_g1862 = UV110_g1862 + float2( 0, TexelSize110_g1862.y );
				}
				}
				float4 break134_g1862 = tex2D( _RippleRenderTexture, UV0110_g1862 );
				float S0128_g1862 = break134_g1862.r;
				float4 break136_g1862 = tex2D( _RippleRenderTexture, UV1110_g1862 );
				float S1128_g1862 = break136_g1862.r;
				float4 break138_g1862 = tex2D( _RippleRenderTexture, UV2110_g1862 );
				float S2128_g1862 = break138_g1862.r;
				float temp_output_91_0_g1862 = _DynamicRippleIntensity;
				float Strength128_g1862 = temp_output_91_0_g1862;
				float3 localCombineSamplesSharp128_g1862 = CombineSamplesSharp128_g1862( S0128_g1862 , S1128_g1862 , S2128_g1862 , Strength128_g1862 );
				float3 temp_output_1565_40 = localCombineSamplesSharp128_g1862;
				float3 NormalsDynamic1571 = temp_output_1565_40;
				#ifdef _ENABLEDYNAMICRIPPLES_ON
				float3 staticSwitch2074 = BlendNormal( temp_output_747_0 , NormalsDynamic1571 );
				#else
				float3 staticSwitch2074 = temp_output_747_0;
				#endif
				float3 DistortionNormals1000 = staticSwitch2074;
				float3 temp_output_1433_0 = ( _DistortionIntensity * DistortionNormals1000 );
				float eyeDepth = i.ase_texcoord4.x;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth28_g1854 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g1854 = ( (DistortionNormals1000).xy * ( _DistortionIntensity / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g1854 - eyeDepth ) ) );
				float eyeDepth2_g1854 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g1854, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g1854 = (( float4( ( temp_output_20_0_g1854 * saturate( ( eyeDepth2_g1854 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				#ifdef _ENABLEDEPTHMASKEDREFRACTION_ON
				float4 staticSwitch1435 = float4( temp_output_32_0_g1854, 0.0 , 0.0 );
				#else
				float4 staticSwitch1435 = ( ase_grabScreenPosNorm + float4( temp_output_1433_0 , 0.0 ) );
				#endif
				float4 fetchOpaqueVal972 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( staticSwitch1435.xy ), 1.0 );
				float4 fetchOpaqueVal968 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( staticSwitch1435 - float4( ( _RGBOffset * float2( 0.002,0 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal967 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( staticSwitch1435 - float4( ( _RGBOffset * float2( 0,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal966 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( staticSwitch1435 - float4( ( _RGBOffset * float2( -0.002,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 appendResult965 = (float4(fetchOpaqueVal968.r , fetchOpaqueVal967.g , fetchOpaqueVal966.b , 0.0));
				#if defined(_DISTORTIONTYPE_NONE)
				float4 staticSwitch1014 = _WaterColor;
				#elif defined(_DISTORTIONTYPE_DEFAULT)
				float4 staticSwitch1014 = ( _WaterColor * fetchOpaqueVal972 );
				#elif defined(_DISTORTIONTYPE_CHROMATICABERRATION)
				float4 staticSwitch1014 = ( _WaterColor * appendResult965 );
				#else
				float4 staticSwitch1014 = ( _WaterColor * fetchOpaqueVal972 );
				#endif
				float4 DistortionType2035 = staticSwitch1014;
				float4 break10_g1866 = float4(1,1,1,1);
				float4 appendResult2_g1866 = (float4(break10_g1866.x , break10_g1866.y , break10_g1866.z , break10_g1866.w));
				float4 break10_g1865 = float4(0,0.5,0.5,1);
				float4 appendResult2_g1865 = (float4(break10_g1865.x , break10_g1865.y , break10_g1865.z , break10_g1865.w));
				float3 DepthColorNormals2027 = temp_output_1433_0;
				float eyeDepth2003 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( DepthColorNormals2027 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float temp_output_2010_0 = saturate( pow( ( abs( ( eyeDepth2003 - ( ase_grabScreenPos + float4( DepthColorNormals2027 , 0.0 ) ).w ) ) * _Clarity ) , 0.3 ) );
				float temp_output_9_0_g1863 = temp_output_2010_0;
				float4 lerpResult7_g1863 = lerp( appendResult2_g1866 , appendResult2_g1865 , ( temp_output_9_0_g1863 * 2.0 ));
				float4 break10_g1867 = float4(0,0,0,1);
				float4 appendResult2_g1867 = (float4(break10_g1867.x , break10_g1867.y , break10_g1867.z , break10_g1867.w));
				float4 lerpResult8_g1863 = lerp( float4( 0,0,0,0 ) , appendResult2_g1867 , temp_output_9_0_g1863);
				float4 lerpResult17_g1863 = lerp( lerpResult7_g1863 , lerpResult8_g1863 , temp_output_9_0_g1863);
				float4 lerpResult2021 = lerp( lerpResult17_g1863 , DistortionType2035 , temp_output_2010_0);
				float4 lerpResult2023 = lerp( lerpResult2021 , _DepthColor , _Murkiness);
				float4 DepthColorRegular2045 = lerpResult2023;
				float eyeDepth1718 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float temp_output_1725_0 = saturate( pow( ( eyeDepth1718 + ( _WaterDepth * 100.0 ) ) , ( _DepthTranslucency * -10.0 ) ) );
				float4 lerpResult1637 = lerp( _DeepColor , _ShallowColor , temp_output_1725_0);
				float4 lerpResult1735 = lerp( lerpResult1637 , DistortionType2035 , temp_output_1725_0);
				float4 DepthColorDistanceBased2047 = lerpResult1735;
				#if defined(_DEPTHCOLORMODE_REGULARRECOMMENDED)
				float4 staticSwitch2041 = DepthColorRegular2045;
				#elif defined(_DEPTHCOLORMODE_DISTANCEBASED)
				float4 staticSwitch2041 = DepthColorDistanceBased2047;
				#else
				float4 staticSwitch2041 = DepthColorRegular2045;
				#endif
				#ifdef _ENABLEDEPTHCOLORS_ON
				float4 staticSwitch1742 = staticSwitch2041;
				#else
				float4 staticSwitch1742 = DistortionType2035;
				#endif
				float4 ColorWithDepthColors2131 = staticSwitch1742;
				float dotResult2124 = dot( float4( float3(0.2126729,0.7151522,0.072175) , 0.0 ) , ColorWithDepthColors2131 );
				float4 temp_cast_32 = (dotResult2124).xxxx;
				float4 lerpResult2123 = lerp( temp_cast_32 , ColorWithDepthColors2131 , _SaturationIntensity);
				#ifdef _SATURATION_ON
				float4 staticSwitch2136 = lerpResult2123;
				#else
				float4 staticSwitch2136 = ColorWithDepthColors2131;
				#endif
				#ifdef _CONTRAST_ON
				float4 staticSwitch2138 = CalculateContrast(_ContrastIntensity,staticSwitch2136);
				#else
				float4 staticSwitch2138 = staticSwitch2136;
				#endif
				float div2106=256.0/float((int)_PosterizationIntensity);
				float4 posterize2106 = ( floor( staticSwitch2138 * div2106 ) / div2106 );
				#ifdef _POSTERIZE_ON
				float4 staticSwitch2152 = posterize2106;
				#else
				float4 staticSwitch2152 = staticSwitch2138;
				#endif
				float4 temp_output_25_0_g1886 = staticSwitch2152;
				float3 Color2_g1886 = temp_output_25_0_g1886.rgb;
				float localRBGToLuminance2_g1886 = RBGToLuminance2_g1886( Color2_g1886 );
				float3 appendResult17_g1886 = (float3(_Red , _Green , _Blue));
				#ifdef _MIDTONES_ON
				float4 staticSwitch2175 = saturate( ( temp_output_25_0_g1886 + float4( ( saturate( ( ( ( localRBGToLuminance2_g1886 - 0.333 ) / 0.25 ) + 0.5 ) ) * saturate( ( 0.5 + ( ( localRBGToLuminance2_g1886 + 0.333 + -1.0 ) / -0.25 ) ) ) * 0.7 * appendResult17_g1886 ) , 0.0 ) ) );
				#else
				float4 staticSwitch2175 = staticSwitch2152;
				#endif
				float grayscale2171 = Luminance(staticSwitch2175.rgb);
				float4 temp_cast_37 = (grayscale2171).xxxx;
				#ifdef _GRAYSCALE_ON
				float4 staticSwitch2172 = temp_cast_37;
				#else
				float4 staticSwitch2172 = staticSwitch2175;
				#endif
				float4 ColorPostProcess2133 = staticSwitch2172;
				#ifdef _ENABLEPOSTPROCESSING_ON
				float4 staticSwitch2098 = ColorPostProcess2133;
				#else
				float4 staticSwitch2098 = staticSwitch1742;
				#endif
				float4 Color991 = staticSwitch2098;
				float3 temp_output_5_0_g1860 = (float4(1,0.8896552,0,1)).rgb;
				float3 normalizeResult4_g1860 = normalize( temp_output_5_0_g1860 );
				float3 ase_worldPos = i.ase_texcoord4.yzw;
				float4 transform69_g1860 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1860 = dot( normalizeResult4_g1860 , (transform69_g1860).xyz );
				float temp_output_15_0_g1860 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1860 = ( ( dotResult11_g1860 * temp_output_15_0_g1860 ) + ( ( _Speed * temp_output_15_0_g1860 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1860 = cos( temp_output_21_0_g1860 );
				float Cosphase76_g1860 = temp_output_62_0_g1860;
				float temp_output_26_0_g1860 = _Amplitude;
				float temp_output_72_0_g1860 = ( Cosphase76_g1860 * temp_output_26_0_g1860 );
				float3 temp_output_5_0_g1857 = (( float4(0.7379313,0,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1857 = normalize( temp_output_5_0_g1857 );
				float4 transform69_g1857 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1857 = dot( normalizeResult4_g1857 , (transform69_g1857).xyz );
				float temp_output_15_0_g1857 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1857 = ( ( dotResult11_g1857 * temp_output_15_0_g1857 ) + ( ( _Speed * temp_output_15_0_g1857 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1857 = cos( temp_output_21_0_g1857 );
				float Cosphase76_g1857 = temp_output_62_0_g1857;
				float temp_output_26_0_g1857 = _Amplitude;
				float temp_output_72_0_g1857 = ( Cosphase76_g1857 * temp_output_26_0_g1857 );
				float3 temp_output_5_0_g1858 = (( float4(0,0.9586205,1,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1858 = normalize( temp_output_5_0_g1858 );
				float4 transform69_g1858 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1858 = dot( normalizeResult4_g1858 , (transform69_g1858).xyz );
				float temp_output_15_0_g1858 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1858 = ( ( dotResult11_g1858 * temp_output_15_0_g1858 ) + ( ( _Speed * temp_output_15_0_g1858 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1858 = cos( temp_output_21_0_g1858 );
				float Cosphase76_g1858 = temp_output_62_0_g1858;
				float temp_output_26_0_g1858 = _Amplitude;
				float temp_output_72_0_g1858 = ( Cosphase76_g1858 * temp_output_26_0_g1858 );
				float3 temp_output_5_0_g1859 = (( float4(1,0.4344828,0,1) * -1.0 )).rgb;
				float3 normalizeResult4_g1859 = normalize( temp_output_5_0_g1859 );
				float4 transform69_g1859 = mul(GetWorldToObjectMatrix(),float4( ase_worldPos , 0.0 ));
				float dotResult11_g1859 = dot( normalizeResult4_g1859 , (transform69_g1859).xyz );
				float temp_output_15_0_g1859 = ( ( 2.0 * PI ) / _Wavelength );
				float temp_output_21_0_g1859 = ( ( dotResult11_g1859 * temp_output_15_0_g1859 ) + ( ( _Speed * temp_output_15_0_g1859 ) * _TimeParameters.x ) );
				float temp_output_62_0_g1859 = cos( temp_output_21_0_g1859 );
				float Cosphase76_g1859 = temp_output_62_0_g1859;
				float temp_output_26_0_g1859 = _Amplitude;
				float temp_output_72_0_g1859 = ( Cosphase76_g1859 * temp_output_26_0_g1859 );
				float temp_output_1148_0 = ( ( temp_output_72_0_g1860 * (normalizeResult4_g1860).x ) + ( temp_output_72_0_g1857 * (normalizeResult4_g1857).x ) + ( temp_output_72_0_g1858 * (normalizeResult4_g1858).x ) + ( temp_output_72_0_g1859 * (normalizeResult4_g1859).x ) );
				float total_dXdY1168 = temp_output_1148_0;
				float temp_output_1157_0 = ( ( temp_output_72_0_g1860 * (normalizeResult4_g1860).z ) + ( temp_output_72_0_g1857 * (normalizeResult4_g1857).z ) + ( temp_output_72_0_g1858 * (normalizeResult4_g1858).z ) + ( temp_output_72_0_g1859 * (normalizeResult4_g1859).z ) );
				float total_dYdZ1169 = temp_output_1157_0;
				float2 appendResult1172 = (float2(total_dXdY1168 , total_dYdZ1169));
				float smoothstepResult1201 = smoothstep( 0.015 , 0.06 , ( length( appendResult1172 ) * _FoamStrength ));
				float FoamMask1239 = saturate( smoothstepResult1201 );
				float2 appendResult1195 = (float2(( _FoamSpeedX * _TimeParameters.x ) , ( _FoamSpeedY * _TimeParameters.x )));
				float2 texCoord1186 = i.uv * _FoamTiling + appendResult1195;
				float4 temp_output_1283_0 = ( float4( texCoord1186, 0.0 , 0.0 ) + ( _DistortedUVInfluence1 * DistortedUVs1008 ) );
				float4 texCoord1344 = float4(i.uv,0,0);
				texCoord1344.xy = float4(i.uv,0,0).xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_worldTangent = i.ase_texcoord5.xyz;
				float3 ase_worldNormal = i.ase_texcoord6.xyz;
				float3 ase_worldBitangent = i.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 OffsetPOM1345 = POM( _FoamTexture, texCoord1344.xy, ddx(texCoord1344.xy), ddy(texCoord1344.xy), ase_worldNormal, ase_worldViewDir, ase_tanViewDir, 8, 8, _FoamParallaxScale, 0, _FoamTexture_ST.xy, float2(0,0), 0 );
				#ifdef _ENABLEFOAMPARALLAX_ON
				float4 staticSwitch1352 = ( float4( OffsetPOM1345, 0.0 , 0.0 ) + temp_output_1283_0 );
				#else
				float4 staticSwitch1352 = temp_output_1283_0;
				#endif
				float2 texCoord1368 = i.uv * float2( -5,-5 ) + float2( 0,0 );
				#ifdef _ENABLEFOAMDISTORTION_ON
				float4 staticSwitch1361 = ( tex2D( _FoamTexture, ( staticSwitch1352 + float4( texCoord1368, 0.0 , 0.0 ) ).rg ) * _FoamDistortion );
				#else
				float4 staticSwitch1361 = staticSwitch1352;
				#endif
				float4 tex2DNode1184 = tex2D( _FoamTexture, staticSwitch1361.rg );
				float4 WaterColor1270 = _WaterColor;
				float localStochasticTiling2_g147 = ( 0.0 );
				float2 Input_UV145_g147 = staticSwitch1361.rg;
				float2 UV2_g147 = Input_UV145_g147;
				float2 UV12_g147 = float2( 0,0 );
				float2 UV22_g147 = float2( 0,0 );
				float2 UV32_g147 = float2( 0,0 );
				float W12_g147 = 0.0;
				float W22_g147 = 0.0;
				float W32_g147 = 0.0;
				StochasticTiling( UV2_g147 , UV12_g147 , UV22_g147 , UV32_g147 , W12_g147 , W22_g147 , W32_g147 );
				float2 temp_output_10_0_g147 = ddx( Input_UV145_g147 );
				float2 temp_output_12_0_g147 = ddy( Input_UV145_g147 );
				float4 Output_2D293_g147 = ( ( tex2D( _FoamTexture, UV12_g147, temp_output_10_0_g147, temp_output_12_0_g147 ) * W12_g147 ) + ( tex2D( _FoamTexture, UV22_g147, temp_output_10_0_g147, temp_output_12_0_g147 ) * W22_g147 ) + ( tex2D( _FoamTexture, UV32_g147, temp_output_10_0_g147, temp_output_12_0_g147 ) * W32_g147 ) );
				#ifdef _ENABLEANTITILEFOAM_ON
				float4 staticSwitch1243 = ( FoamMask1239 * _FoamColor * Output_2D293_g147 * WaterColor1270 );
				#else
				float4 staticSwitch1243 = ( FoamMask1239 * _FoamColor * tex2DNode1184 * WaterColor1270 );
				#endif
				float4 break31_g147 = Output_2D293_g147;
				float temp_output_1217_0 = ( FoamMask1239 * pow( break31_g147.a , _FoamAlpha ) );
				float temp_output_1234_0 = ( FoamMask1239 * pow( tex2DNode1184.a , _FoamAlpha ) );
				#ifdef _ENABLEANTITILEFOAM_ON
				float staticSwitch1260 = ( ( temp_output_1234_0 * 0.0 ) + temp_output_1217_0 );
				#else
				float staticSwitch1260 = ( ( temp_output_1217_0 * 0.0 ) + temp_output_1234_0 );
				#endif
				float FoamAlpha1245 = staticSwitch1260;
				float4 lerpResult1198 = lerp( Color991 , staticSwitch1243 , FoamAlpha1245);
				float4 Foam1267 = lerpResult1198;
				#ifdef _ENABLEFOAM_ON
				float4 staticSwitch1266 = Foam1267;
				#else
				float4 staticSwitch1266 = staticSwitch2098;
				#endif
				float3 DebugFlowmap2077 = tex2DNode1838;
				float4 lerpResult2085 = lerp( staticSwitch1266 , float4( DebugFlowmap2077 , 0.0 ) , _DebugContrast);
				#ifdef _DEBUGVIEW_ON
				float4 staticSwitch2082 = lerpResult2085;
				#else
				float4 staticSwitch2082 = staticSwitch1266;
				#endif
				float4 tex2DNode1574 = tex2D( _RippleRenderTexture, uv_RippleRenderTexture );
				float4 DebugDynamicRipple2091 = tex2DNode1574;
				float4 lerpResult2092 = lerp( staticSwitch2082 , DebugDynamicRipple2091 , _DebugContrast1);
				#ifdef _DEBUGVIEW1_ON
				float4 staticSwitch2087 = lerpResult2092;
				#else
				float4 staticSwitch2087 = staticSwitch2082;
				#endif
				float4 FinalColor2079 = staticSwitch2087;
				
				float3 temp_cast_52 = (_Cull).xxx;
				
				float screenDepth2206 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2206 = saturate( abs( ( screenDepth2206 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch1501 = distanceDepth2206;
				#else
				float staticSwitch1501 = WaterColor1270.a;
				#endif
				float2 uv_AlphaMask2197 = i.uv;
				float smoothstepResult2199 = smoothstep( 0.0 , _AlphaFalloff , tex2D( _AlphaMask, uv_AlphaMask2197 ).a);
				#ifdef _ENABLEALPHAMASKING_ON
				float staticSwitch2208 = smoothstepResult2199;
				#else
				float staticSwitch2208 = ( 0.0 + 1.0 );
				#endif
				float cameraDepthFade2233 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch2230 = saturate( cameraDepthFade2233 );
				#else
				float staticSwitch2230 = 1.0;
				#endif
				float Alpha1498 = ( staticSwitch1501 * staticSwitch2208 * WaterColor1270.a * staticSwitch2230 );
				

				MetaInput metaInput = (MetaInput)0;
			
				float2 uv_main = i.uv;
			
				//half4 albedo = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv) * _BaseColor;
				//metaInput.Albedo = albedo.rgb;
			
			
				///half4 emission = half4(0, 0, 0, 0);
			
			// Begin Injection EMISSION from Injection_Emission_Meta.hlsl ----------------------------------------------------------
				//if (_Emission)
				//{
					//half4 emissionDefault = _EmissionColor * SAMPLE_TEXTURE2D(_EmissionMap, sampler_BaseMap, i.uv);
					//emissionDefault.rgb *= _BakedMutiplier * _Emission;
					//emissionDefault.rgb *= lerp(albedo.rgb, half3(1, 1, 1), emissionDefault.a);
					//emission += emissionDefault;
				//}
			// End Injection EMISSION from Injection_Emission_Meta.hlsl ----------------------------------------------------------
			
				//metaInput.Emission = emission.rgb;
			
				metaInput.Albedo = FinalColor2079.rgb;
				half3 emission = half3(0,0,0);
				half3 bakedemission = temp_cast_52;
				metaInput.Emission = bakedemission.rgb;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = i.VizUV.xy;
					metaInput.LightCoord = i.LightCoord;
				#endif
			
				half alpha = Alpha1498;
				half alphaclip = half(0);
				half alphaclipthresholdshadow = half(0);
				#if defined(_ALPHATEST_ON)
					clip(alpha - alphaclip);
				#endif
				return MetaFragment(metaInput);
			}
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			ENDHLSL
		}

		/*ase_pass*/
		Pass
		{
			
			
			Name "BakedRaytrace"
			Tags{ "LightMode" = "BakedRaytrace" }
			HLSLPROGRAM
			/*ase_pragma_before*/
			#pragma multi_compile _ _EMISSION_ON
			//StandardBakedRT------------------------------------------------------------------------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
			//
			//
			//-----------------------------------------------------------------------------------------------------
			//-----------------------------------------------------------------------------------------------------
					
					
			#define SHADERPASS SHADERPASS_RAYTRACE
					
			#include "UnityRaytracingMeshUtils.cginc"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
					
			/*ase_pragma*/
					
			#pragma raytracing BakeHit
					
			struct RayPayload
			{
			    float4 color;
				float3 dir;
			};
			
			struct AttributeData
			{
			    float2 barycentrics;
			};
			
			struct Vertex
			{
			    float2 texcoord;
			    float3 normal;
			};
			
			// Begin Injection UNIFORMS from Injection_Emission_BakedRT.hlsl ----------------------------------------------------------
			//Texture2D<float4> _BaseMap;
			//SamplerState sampler_BaseMap;
			//Texture2D<float4> _EmissionMap;
			//SamplerState sampler_EmissionMap;
			// End Injection UNIFORMS from Injection_Emission_BakedRT.hlsl ----------------------------------------------------------
			
			CBUFFER_START( UnityPerMaterial )
				/*ase_srp_batcher*/
				//float4 _BaseMap_ST;
				//half4 _BaseColor;
			// Begin Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			//float4 _DetailMap_ST;
			//half  _Details;
			//half  _Normals;
			// End Injection MATERIAL_CBUFFER from Injection_NormalMap_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
				float _SSRTemporalMul;
			// End Injection MATERIAL_CBUFFER from Injection_SSR_CBuffer.hlsl ----------------------------------------------------------
			// Begin Injection MATERIAL_CBUFFER from Injection_Emission_CBuffer.hlsl ----------------------------------------------------------
				//half  _Emission;
				//half4 _EmissionColor;
				//half  _EmissionFalloff;
				//half  _BakedMutiplier;
			// End Injection MATERIAL_CBUFFER from Injection_Emission_CBuffer.hlsl ----------------------------------------------------------
				//int _AlphaPreMult;
			CBUFFER_END
			/*ase_globals*/
			
			/*ase_funcs*/
			
			
			//https://coty.tips/raytracing-in-unity/
			[shader("closesthit")]
			void MyClosestHit(inout RayPayload payload, AttributeData attributes : SV_IntersectionAttributes) {
			
				payload.color = float4(0,0,0,1); //Intializing
				payload.dir = float3(1,0,0);
			
			// Begin Injection CLOSEST_HIT from Injection_Emission_BakedRT.hlsl ----------------------------------------------------------
			uint2 launchIdx = DispatchRaysIndex();
			
			uint primitiveIndex = PrimitiveIndex();
			uint3 triangleIndicies = UnityRayTracingFetchTriangleIndices(primitiveIndex);
			Vertex v0, v1, v2;
			
			v0.texcoord = UnityRayTracingFetchVertexAttribute2(triangleIndicies.x, kVertexAttributeTexCoord0);
			v1.texcoord = UnityRayTracingFetchVertexAttribute2(triangleIndicies.y, kVertexAttributeTexCoord0);
			v2.texcoord = UnityRayTracingFetchVertexAttribute2(triangleIndicies.z, kVertexAttributeTexCoord0);
			
			// v0.normal = UnityRayTracingFetchVertexAttribute3(triangleIndicies.x, kVertexAttributeNormal);
			// v1.normal = UnityRayTracingFetchVertexAttribute3(triangleIndicies.y, kVertexAttributeNormal);
			// v2.normal = UnityRayTracingFetchVertexAttribute3(triangleIndicies.z, kVertexAttributeNormal);
			
			float3 barycentrics = float3(1.0 - attributes.barycentrics.x - attributes.barycentrics.y, attributes.barycentrics.x, attributes.barycentrics.y);
			
			Vertex vInterpolated;
			vInterpolated.texcoord = v0.texcoord * barycentrics.x + v1.texcoord * barycentrics.y + v2.texcoord * barycentrics.z;
			//TODO: Extract normal direction to ignore the backside of emissive objects
			//vInterpolated.normal = v0.normal * barycentrics.x + v1.normal * barycentrics.y + v2.normal * barycentrics.z;
			// if ( dot(vInterpolated.normal, float3(1,0,0) < 0) ) payload.color =  float4(0,10,0,1) ;
			// else payload.color =  float4(10,0,0,1) ;
			
			
			//float4 albedo = float4(_BaseMap.SampleLevel(sampler_BaseMap, vInterpolated.texcoord.xy * _BaseMap_ST.xy + _BaseMap_ST.zw, 0).rgb, 1) * _BaseColor;
			
			//float4 emission = _Emission * _EmissionMap.SampleLevel(sampler_EmissionMap, vInterpolated.texcoord * _BaseMap_ST.xy + _BaseMap_ST.zw, 0) * _EmissionColor;
			
			half3 albedo = /*ase_frag_out:Albedo;Float3;_Albedo*/half3(0.5, 0.5, 0.5)/*end*/;
			half3 emission = /*ase_frag_out:Emission;Float3;_Emission*/half3(0,0,0)/*end*/;
			half3 baked_emission = /*ase_frag_out:Baked Emission;Float3;_EmissionBaked*/emission/*end*/;
			//emission.rgb *= lerp(albedo.rgb, 1, emission.a);
			
			//payload.color.rgb = emission.rgb * _BakedMutiplier;
			// End Injection CLOSEST_HIT from Injection_Emission_BakedRT.hlsl ----------------------------------------------------------
			payload.color.rgb = baked_emission.rgb;
			}
			//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			ENDHLSL
		}
		
	}
	

	CustomEditor "LitMASWaterShaderGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.CommentaryNode;2043;-2726.704,-2952.702;Inherit;False;3286.56;408.9698;Handling of final color output;14;2079;1266;1268;2134;2131;991;1742;2036;2098;2048;2046;2041;2088;2095;Color;0,0.6982255,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2211;-1165.461,-2453.698;Inherit;False;1462.195;636.5582;Handling of Alpha and Soft Intersection and Camera Depth Fade;18;2230;2231;2232;2233;2235;2234;2209;1498;2198;1501;2201;2197;2199;1495;1496;2208;1455;2206;Alpha ;0.8758286,0.4009434,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2186;-2209.001,-1993.253;Inherit;False;131;109;_Cull needs to be registered, so it is plugged into baked emission. I have not found an alternative method to register a variable without plugging it into a flow going into the output of the graph.;1;2184;;0.2916587,0.9245283,0.0566928,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2135;-2716.855,-3534.157;Inherit;False;3909.123;495.9475;Handling of optional post process options;6;2133;2130;2139;2153;2169;2174;Post Processing;1,0.8873018,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2174;450.7332,-3404.783;Inherit;False;490;193.209;;2;2171;2172;Grayscale;1,0.7334805,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2169;-414.269,-3402.396;Inherit;False;835;338;;10;2167;2168;2166;2183;2182;2181;2180;2178;2175;2164;Midtones;1,0.8941435,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2153;-1098.772,-3399.469;Inherit;False;668.0884;255.5698;;5;2148;2106;2152;2154;2155;Posterization;1,0.801486,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2139;-1845.379,-3402.7;Inherit;False;692.9999;231;;5;2146;2145;2107;2137;2138;Contrast;1,0.7300014,0.1933962,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2130;-2686.964,-3424.426;Inherit;False;800.3401;336.75;;8;2136;2132;2129;2125;2124;2123;2143;2144;Saturation;1,0.8911765,0.4764151,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2095;-376.6382,-2880.016;Inherit;False;691.6973;307.093;;6;2093;2094;2092;2087;2096;2097;Dynamic Ripple Debug View;0.3820755,0.4846916,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2088;-1064.638,-2880.016;Inherit;False;675.1346;310.8962;;7;2086;2084;2085;2082;2089;2090;2225;Flowmap Debug View;0.3066038,0.5654374,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1110;-5210.065,295.3688;Inherit;False;2629.134;2182.301;Wave handling;5;1100;1109;1120;1558;2061;Waves;0.9458766,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2061;-3463.944,1811.528;Inherit;False;845.9658;450.9999;Swtich for wave types;7;2060;1066;1752;1539;1108;1099;1067;Final Wave Type Switch;0.9160464,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2044;-1129.082,-1409.508;Inherit;False;2280.138;1576.575;Comment;2;1626;2033;Depth Colors;0.6335542,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2033;-1102.039,-1284.308;Inherit;False;2225.91;814.4901;Comment;29;2051;2050;2049;2028;2002;2020;2018;2019;2007;1999;2003;2004;2005;2006;2010;2009;2017;2012;2016;2015;2014;2013;2045;2025;2023;2021;2026;2039;2011;Regular Depth Color;0.2453315,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1969;-6957.454,1036.626;Inherit;False;1571.623;1032.621;Handling of flowmapped UV's (Credit ASE LS Sample - Flow Mapping);30;1869;1870;1853;1868;1851;1942;1859;1835;1837;1836;1860;1861;1867;1918;1934;1862;1876;1933;1874;1960;1959;1962;1841;1873;1833;1838;1839;1996;2077;2078;Flowmapping;0.7404704,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1746;-2743.177,-1170.967;Inherit;False;1553.901;648.42;Handling of dynamic ripple normals ;17;1571;1751;1561;1576;1997;1575;1574;1750;1566;1565;983;1562;2072;2073;2091;2228;2229;Dynamic Ripple Handling;1,0.5329268,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1558;-5174.779,2015.993;Inherit;False;1679.604;434.1038;Waves via graident noise;10;1541;1513;1520;1521;1549;1548;1515;1519;1550;1551;Noise Waves;0.5834663,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;938;-5439.771,-4766.65;Inherit;False;2634.107;1107.381;;6;2035;1035;1014;955;987;1436;Distortion;1,0,0.5458698,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1436;-5415.651,-4536.892;Inherit;False;1045.885;541.2027;Choose between depth masked refractions or not;8;1432;1435;1423;975;1424;1434;1433;2027;Distortion UV's Option;1,0.1692376,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1223;-2701.829,-5543.855;Inherit;False;3222.701;1879.999;Foam handling;3;1177;1258;1269;Foam;0,0.6754479,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1269;-2678.561,-5030.929;Inherit;False;3148.393;1333.253;Calculating regular foam visuals;4;1351;1355;1356;1366;Regular Foam Calculation;0,0.532712,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1366;-1917.346,-4172.767;Inherit;False;1006.106;332.0193;Optional distortion;6;1368;1359;1369;1358;1360;1370;Foam Distortion;0,0.7331131,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1356;-1265.792,-4945.423;Inherit;False;1694.474;731.7;Bring together foam and anti-tile foam. Sample Foam Alpha;18;1361;1234;1231;1241;1200;1243;992;1267;1198;1246;1240;1271;1196;1210;1221;1220;1217;1184;Final Foam Process;0,0.5922599,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1355;-2650.832,-4404.637;Inherit;False;697.8795;666.2273;Foam UV's with parallax;6;1354;1345;1344;1181;1348;1342;Foam UV's + Parallax;0,0.07963085,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1351;-2649.92,-4944.433;Inherit;False;1356.518;474.9383;;14;1282;1281;1427;1352;1190;1189;1185;1194;1195;1191;1193;1186;1192;1283;Foam UV's;0,0.1161669,0.2264151,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1258;-634.9974,-5422.072;Inherit;False;937.3269;273.4915;Subtracts tiled and anti-tile alphas for correct alpha;7;1245;1260;1264;1262;1261;1263;1254;Factor out other alpha;0,0.250143,0.7075472,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1177;-2673.573,-5440.855;Inherit;False;1389.394;324.6928;;13;1176;1225;1201;1203;1202;1224;1175;1174;1173;1172;1171;1170;1239;Foam Mask;0,0.2467763,0.5,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1120;-5191.141,419.1409;Inherit;False;2334.27;952.4458;Credit to Safemilk on GitHub for custom function (https://github.com/Safemilk/GerstnerWavesUnity);25;1143;1142;1141;1140;1139;1138;1137;1136;1135;1134;1133;1132;1131;1127;1126;1125;1124;1123;1122;1166;1167;1279;1278;1277;1276;Gerstner Wave Calculation;1,0.9039522,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1167;-3969.633,514.4548;Inherit;False;1079.427;402.4642;;8;1148;1157;1159;1158;1163;1161;1168;1169;Wave Normals;0.69775,1,0.514151,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1166;-3972.583,1041.685;Inherit;False;341.0999;204.892;;2;1121;1128;Gerstner Vertex Output;0.6761163,1,0.5896226,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1109;-3728.259,1445.685;Inherit;False;751.9999;292.8452;Gerstner and 3D Texture waves combined;7;1107;1103;1104;1106;1101;1102;1105;Mixed Waves;0.8211809,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1100;-5177.123,1438.436;Inherit;False;1394.437;497.2927;Waves derived from a 3D texture;16;1083;1084;1086;1096;1091;1085;1094;1097;1098;1092;1095;1089;1090;1088;1093;1087;3D Texture Waves;0.9828656,1,0.5990566,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;987;-4262.922,-4646.557;Inherit;False;710.2539;266.1983;Regular distortion handling;7;979;1270;1017;978;972;1019;1018;Regular Distortion;1,0,0.788413,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;864;-6752.671,-3603.265;Inherit;False;3966.649;3729.244;All structures for the processing of normals;3;598;597;849;Normals;0.3638363,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;849;-5775.299,-3437.616;Inherit;False;2631.618;964.2432;Rain drop ripple handling;57;793;802;846;798;797;848;820;847;833;845;840;839;838;837;803;836;844;843;842;823;822;818;821;819;817;816;815;841;801;814;813;830;831;828;829;827;810;811;812;792;834;832;826;825;824;790;789;809;853;852;854;855;1001;1002;1003;1004;1010;Rain Drop Ripples;0,0.1551092,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;597;-5640.995,-972.1204;Inherit;False;2748.782;1060.345;Smaller scale normals for extra detail;27;595;596;590;589;591;588;587;1940;1941;1012;1995;1991;732;1990;731;1994;1993;594;1006;599;1988;1949;1948;586;593;592;652;Micro Normals;0.5801887,0.7805257,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;652;-5605.244,-459.5585;Inherit;False;1259.642;519.0273;Fade micro normals when camera gets too far, fade in when close;10;622;621;626;627;625;620;619;623;624;618;Micro Normals Fading;0.1084906,0.5464684,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;598;-6721.064,-2428.878;Inherit;False;3901.452;1293.243;Normal Map Handling;42;982;585;1987;1986;1985;1976;1974;1975;747;644;1978;1977;1569;748;1570;1000;1005;1972;1944;1943;579;567;1973;1937;1935;1009;728;1971;726;1007;566;575;574;572;573;576;577;578;660;2074;2075;2076;Main Normals;0.04245281,0.4988537,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;609;-7538.209,351.2728;Inherit;False;2192.41;471.358;Optional distortion UV Handling;18;1008;714;600;608;1078;1076;1072;602;1074;710;709;705;708;707;706;603;1080;1081;Distortion UV's;1,0.04313725,0.8645551,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;660;-6376.928,-1737.397;Inherit;False;2498.475;582.9892;Reduces tiling on normals;28;1979;1982;1938;1011;1939;730;1981;729;1980;1984;1983;1945;1947;640;636;638;684;680;679;676;675;637;639;685;683;681;682;678;Anti-Tile;0,0.3965816,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;955;-4266.424,-4319.131;Inherit;False;1074.575;611.3888;Chromatic Aberration distortion handling;14;966;969;962;963;964;965;967;968;961;960;959;958;957;956;Chromatic Aberration;1,0,0,1;0;0
Node;AmplifyShaderEditor.FunctionNode;622;-4938.323,-288.5592;Inherit;False;Inverse Lerp;-1;;98;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;621;-5138.327,-238.5593;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;626;-4507.596,-379.9586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;627;-4762.349,-254.5191;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;625;-4596.025,-257.4593;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;620;-5302.328,-233.5593;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;619;-5495.852,-289.9142;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;618;-5555.243,-123.5317;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;678;-5113.366,-1386.636;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;682;-4951.497,-1299.16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;681;-4945.194,-1411.368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;683;-4785.786,-1406.816;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;685;-4624.888,-1469.116;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;639;-5330.672,-1393.525;Inherit;False;UnpackNormal;-1;;99;d579cc33c6fa60b4ea9cee9e184b62e3;0;1;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;637;-5334.872,-1630.385;Inherit;False;UnpackNormal;-1;;101;d579cc33c6fa60b4ea9cee9e184b62e3;0;1;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;675;-5121.458,-1635.239;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;676;-4947.57,-1658.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;679;-4944.772,-1556.571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;680;-4783.963,-1620.024;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;684;-4622.289,-1565.216;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;809;-5246.671,-3347.735;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;789;-5709.619,-3186.016;Inherit;False;Constant;_Colums;Colums;27;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;790;-5706.619,-3110.018;Inherit;False;Constant;_Rows;Rows;28;0;Create;True;0;0;0;False;0;False;16;16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;824;-5008.819,-3344.516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;825;-5006.216,-3262.373;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;826;-4885.456,-3333.509;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;832;-4823.492,-3119.219;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;792;-5707.546,-2923.958;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;812;-5708.826,-2828.046;Inherit;False;Constant;_MinusTime;MinusTime;31;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;811;-5450.409,-2868.83;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;810;-5253.41,-2924.278;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FractNode;827;-5007.366,-2920.549;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;829;-5005.608,-2833.137;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;828;-4886.331,-2901.93;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;831;-4646.538,-2999.366;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;830;-4639.592,-3151.796;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;813;-4439.104,-3174.05;Inherit;False;Procedural Sample;-1;;102;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.LerpOp;814;-4145.686,-3109.696;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;801;-4441.412,-2972.473;Inherit;False;Procedural Sample;-1;;103;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleDivideOpNode;815;-5507.848,-2695.827;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;816;-5700.786,-2676.91;Inherit;False;Constant;_Float0;Float 0;29;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;817;-5351.211,-2697.3;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;819;-5206.805,-2696.896;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;821;-5001.848,-2694.062;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;822;-4847.388,-2694.556;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;823;-4708.386,-2691.556;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;842;-3892.772,-2966.492;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;843;-3941.482,-2908.653;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;844;-4163.482,-2891.653;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;847;-5046.306,-2618.59;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;820;-5039.155,-2572.402;Inherit;False;Constant;_Float2;Float 2;29;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;848;-4929.306,-2598.59;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;797;-5534.151,-3348.716;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;802;-4739.288,-3387.616;Inherit;True;Property;_BubbleBook;BubbleBook;44;3;[HideInInspector];[NoScaleOffset];[Normal];Create;True;1;Rain Drop Ripples;0;0;False;0;False;760bf7cc2c844e6478d1844e81f23868;760bf7cc2c844e6478d1844e81f23868;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;818;-5529.836,-2584.68;Inherit;False;Constant;_Float1;Float 1;29;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;853;-5449.36,-2952.245;Inherit;False;Constant;_Float3;Float 3;29;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;852;-5394.36,-3111.242;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;855;-5447.553,-3032.337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;854;-5361.553,-2988.337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;638;-5551.946,-1398.886;Inherit;False;Procedural Sample;-1;;104;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.WireNode;841;-4400.389,-2732.997;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1001;-4230.17,-2879.745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;803;-4247.275,-2757.451;Inherit;False;UnpackNormal;-1;;105;d579cc33c6fa60b4ea9cee9e184b62e3;0;1;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;836;-4058.617,-2756.258;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;837;-3925.214,-2754.336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;839;-3775.603,-2753.991;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;838;-3924.415,-2653.528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;840;-3634.895,-2755.184;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;1002;-3649.237,-2689.805;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;1003;-3501.728,-2700.918;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1004;-3350.345,-2657.64;Inherit;False;RainDropRipples;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;956;-3720.009,-4191.133;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;957;-3720.009,-4095.133;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;958;-3720.009,-3999.132;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;959;-3896.01,-4191.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;960;-3896.01,-4095.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;961;-3896.01,-3999.132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;967;-3544.957,-4091.395;Inherit;False;Global;_GrabScreen1;Grab Screen 1;13;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;965;-3329.011,-4125.133;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;964;-4104.012,-4175.133;Inherit;False;Constant;_ROffset;R Offset;31;0;Create;True;0;0;0;False;0;False;0.002,0;-1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;963;-4104.012,-4047.133;Inherit;False;Constant;_GOffset;G Offset;32;0;Create;True;0;0;0;False;0;False;0,-0.002;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;962;-4104.012,-3919.132;Inherit;False;Constant;_BOffset;B Offset;33;0;Create;True;0;0;0;False;0;False;-0.002,-0.002;1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;1018;-3930.922,-4429.423;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1019;-3865.999,-4427.979;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;972;-4241.041,-4582.854;Float;False;Global;_WaterGrab;WaterGrab;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;978;-4029.407,-4600.103;Inherit;False;Property;_WaterColor;Water Color;1;2;[HDR];[Header];Create;True;1;Water Attributes;0;0;False;0;False;8.47419,8.47419,8.47419,1;7.377211,7.377211,7.377211,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;636;-5558.447,-1663.087;Inherit;False;Procedural Sample;-1;;111;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.BlendNormalsNode;640;-4441.637,-1574.444;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1017;-4060.001,-4446.72;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;979;-3772.558,-4507.623;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1010;-5102.172,-3026.602;Inherit;False;1008;DistortedUVs;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;834;-4823.698,-2998.717;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;576;-6599.091,-2167.566;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;573;-6318.993,-2183.925;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;572;-6318.993,-2039.925;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1626;-1100.895,-379.381;Inherit;False;1453.967;527.789;Handling of colors based on screen depth;17;2047;2037;1735;1722;1721;1727;1744;1743;1631;1745;1633;1637;1725;1723;1729;1718;1724;Distance Based Depth Color;0,1,0.1997867,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1170;-2661.573,-5390.856;Inherit;False;1168;total_dXdY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1171;-2657.021,-5293.781;Inherit;False;1169;total_dYdZ;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;1173;-2246.52,-5389.781;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1175;-1946.643,-5386.224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1224;-2016.696,-5321.292;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1202;-1967.481,-5285.273;Inherit;False;Constant;_Min;Min;53;0;Create;True;0;0;0;False;0;False;0.015;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1203;-1966.481,-5209.273;Inherit;False;Constant;_Max;Max;54;0;Create;True;0;0;0;False;0;False;0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1201;-1776.449,-5383.79;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1225;-1798.696,-5228.292;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1239;-1466.921,-5375.583;Inherit;False;FoamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1176;-1612.251,-5379.223;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1254;-615.9218,-5301.284;Inherit;False;Constant;_Float4;Float 4;54;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1263;-468.3106,-5372.237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1261;-470.9105,-5247.436;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1262;-306.8106,-5249.537;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1264;-308.4112,-5368.835;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1245;101.7258,-5334.847;Inherit;False;FoamAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1283;-1749.668,-4825.963;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;1192;-2504.879,-4617.634;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1186;-2014.283,-4872.643;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;1193;-2504.879,-4793.633;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1191;-2328.878,-4697.634;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1195;-2159.174,-4743.281;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1194;-2344.878,-4873.633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1342;-2583.763,-3980.333;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;1181;-2629.052,-4175.151;Inherit;True;Property;_FoamTexture;Foam Texture;57;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;175c9d90377d747449523cd5ccab748c;175c9d90377d747449523cd5ccab748c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;1344;-2622.395,-4354.637;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;1345;-2331.423,-4186.805;Inherit;False;0;8;False;;16;False;;2;0.02;0;False;1,1;False;0,0;8;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;7;SAMPLERSTATE;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1354;-2071.59,-4176.134;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1184;-1096.65,-4886.667;Inherit;True;Property;_TextureSample25;Texture Sample 25;53;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1217;-501.1896,-4421.479;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1221;-923.3495,-4416.966;Inherit;False;Procedural Sample;-1;;147;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1196;-328.7416,-4439.711;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1271;-535.2225,-4504.336;Inherit;False;1270;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1240;-933.9206,-4624.902;Inherit;False;1239;FoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1246;-191.1852,-4524.141;Inherit;False;1245;FoamAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1267;215.9081,-4644.464;Inherit;False;Foam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1241;-455.1428,-4849.655;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;1231;-671.8024,-4636.548;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1234;-510.2884,-4647.91;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1360;-1044.775,-4056.353;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1198;29.19305,-4643.945;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1358;-1369.276,-4131;Inherit;True;Property;_TextureSample26;Texture Sample 26;58;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1369;-1506.091,-4092.566;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1368;-1737.275,-4070.744;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1370;-1905.701,-4068.36;Inherit;False;Constant;_Vector1;Vector 1;60;0;Create;True;0;0;0;False;0;False;-5,-5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;1423;-5083.024,-4213.785;Inherit;True;DepthMaskedRefraction;-1;;1854;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.ScreenColorNode;966;-3539.47,-3907.775;Inherit;False;Global;_GrabScreen2;Grab Screen 2;13;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;1361;-1243.701,-4512.539;Inherit;False;Property;_EnableFoamDistortion;Enable Foam Distortion;69;0;Create;True;0;0;0;False;1;Header(Foam Distortion) ;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;846;-3635.247,-2661.592;Inherit;False;Property;_EnableRainDropRipples;Enable Rain Drop Ripples;39;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;1352;-1628.293,-4725.826;Inherit;False;Property;_EnableFoamParallax;Enable Foam Parallax;67;0;Create;True;0;0;0;False;1;Header(Foam Parallax) ;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;1432;-5316.089,-4486.892;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;708;-7390.132,648.5417;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;705;-7009.309,616.4497;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;709;-7164.985,499.1909;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;710;-7163.206,609.3418;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1072;-6563.615,624.4268;Inherit;False;Procedural Sample;-1;;1856;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;1076;-6595.5,415.0818;Inherit;True;Property;_TextureSample24;Texture Sample 24;39;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;608;-5986.31,502.3518;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1080;-6882.091,622.2478;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;1081;-6866.092,538.2478;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1083;-4856.528,1491.616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1084;-4853.528,1596.617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1086;-4885.528,1694.617;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1096;-5095.832,1490.16;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1091;-4342.538,1701.462;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;1085;-4656.176,1491.617;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;1094;-4678.933,1628.144;Inherit;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;1097;-4394.542,1689.449;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1098;-4523.824,1674.768;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;1092;-4530.801,1728.728;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1089;-4172.292,1490.86;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1090;-4008.685,1488.436;Inherit;False;ThreeDTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1105;-3722.259,1660.529;Inherit;False;Property;_MixingIntensity;Mixing Intensity;55;1;[Header];Create;True;1;Gerstner and 3D Tex Wave Mixing;0;0;False;0;False;1;0.73;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1122;-5105.373,1279.807;Float;False;Constant;_Float5;Float 5;11;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1123;-4517.379,1112.066;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1124;-4664.908,1209.853;Float;False;Constant;_Float9;Float 9;11;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1125;-4546.959,950.5127;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1126;-4725.1,1023.029;Float;False;Constant;_Color6;Color 6;0;0;Create;True;0;0;0;False;0;False;1,0.4344828,0,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;1127;-4729.921,962.4939;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1131;-4515.352,728.3518;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1132;-4673.646,873.5317;Float;False;Constant;_Float6;Float 6;15;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1133;-4727.417,507.8608;Float;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;1,0.8896552,0,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1134;-4726.132,686.7817;Float;False;Constant;_Color4;Color 4;0;0;Create;True;0;0;0;False;0;False;0.7379313,0,1,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1135;-4949.374,1169.808;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1136;-5166.701,1098.034;Float;False;Constant;_Color5;Color 5;0;0;Create;True;0;0;0;False;0;False;0,0.9586205,1,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1137;-5166.355,638.7358;Inherit;False;Constant;_Float7;Float 7;39;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1142;-4889.361,566.1158;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1157;-3936.95,733.9209;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1158;-3636.236,580.0588;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;1161;-3429.837,581.7588;Inherit;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1168;-3797.584,728.6167;Inherit;False;total_dXdY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1169;-3794.584,808.6167;Inherit;False;total_dYdZ;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1159;-3800.237,604.0588;Inherit;False;Property;_Foamblend;Foam blend;64;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1102;-3718.969,1584.411;Inherit;False;1090;ThreeDTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1106;-3464.259,1509.53;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1104;-3422.259,1611.529;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1103;-3284.165,1518.225;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1107;-3162.259,1519.53;Inherit;False;MixedWaves;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;1276;-4338.07,703.8618;Inherit;False;GerstnerWaveFunction;-1;;1857;13f64ad7ca7376e4ca2a506bd44418f6;0;6;19;FLOAT;3200;False;18;FLOAT;200;False;26;FLOAT;32;False;33;FLOAT;32;False;25;FLOAT;0;False;52;COLOR;0.8470588,0.8509804,0.003921569,0;False;3;FLOAT4;0;FLOAT;86;FLOAT;87
Node;AmplifyShaderEditor.FunctionNode;1277;-4336.144,904.3647;Inherit;False;GerstnerWaveFunction;-1;;1858;13f64ad7ca7376e4ca2a506bd44418f6;0;6;19;FLOAT;3200;False;18;FLOAT;200;False;26;FLOAT;32;False;33;FLOAT;32;False;25;FLOAT;0;False;52;COLOR;0.8470588,0.8509804,0.003921569,0;False;3;FLOAT4;0;FLOAT;86;FLOAT;87
Node;AmplifyShaderEditor.FunctionNode;1278;-4342.378,1101.981;Inherit;False;GerstnerWaveFunction;-1;;1859;13f64ad7ca7376e4ca2a506bd44418f6;0;6;19;FLOAT;3200;False;18;FLOAT;200;False;26;FLOAT;32;False;33;FLOAT;32;False;25;FLOAT;0;False;52;COLOR;0.8470588,0.8509804,0.003921569,0;False;3;FLOAT4;0;FLOAT;86;FLOAT;87
Node;AmplifyShaderEditor.FunctionNode;1279;-4346.903,488.6818;Inherit;False;GerstnerWaveFunction;-1;;1860;13f64ad7ca7376e4ca2a506bd44418f6;0;6;19;FLOAT;3200;False;18;FLOAT;200;False;26;FLOAT;32;False;33;FLOAT;32;False;25;FLOAT;0;False;52;COLOR;0.8470588,0.8509804,0.003921569,0;False;3;FLOAT4;0;FLOAT;86;FLOAT;87
Node;AmplifyShaderEditor.GetLocalVarNode;1101;-3715.2,1507.685;Inherit;False;1121;GerstnerWaves;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1148;-3945.133,575.4558;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1163;-3148.707,595.9878;Inherit;False;WaveNormals;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1093;-4504.911,1489.983;Inherit;True;Property;_Displacement3DTexture;Displacement 3D Texture;51;2;[Header];[NoScaleOffset];Create;True;1;3D Texture Wave Settings;0;0;False;0;False;-1;ede26a347e1c6634d9d6c87e30361481;ede26a347e1c6634d9d6c87e30361481;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1128;-3948.167,1097.01;Inherit;False;4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1121;-3824.485,1100.529;Inherit;False;GerstnerWaves;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1541;-4254.975,2112.019;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1513;-4491.527,2065.993;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1520;-4643.006,2114.967;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;1521;-4827.685,2109.982;Inherit;False;1;0;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1549;-3988.47,2113.547;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1548;-3719.173,2107.516;Inherit;False;NoiseWaves;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;566;-6317.77,-2374.846;Inherit;True;Property;_NormalMap;Normal Map;18;3;[Header];[NoScaleOffset];[Normal];Create;True;1;Normals;0;0;False;0;False;fc7df81110c0e4d2498739bf4d47a49d;fc7df81110c0e4d2498739bf4d47a49d;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PowerNode;1220;-672.9089,-4419.173;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1172;-2464.022,-5391.781;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1281;-2123.992,-4557.771;Inherit;False;1008;DistortedUVs;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1282;-1896.519,-4687.887;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;968;-3543.009,-4268.132;Inherit;False;Global;_GrabScreen0;Grab Screen 0;13;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1565;-2201.61,-1021.367;Inherit;False;Normal From Texture;-1;;1862;9728ee98a55193249b513caf9a0f1676;13,149,0,147,0,143,0,141,0,139,0,151,0,137,0,153,0,159,0,157,0,155,0,135,0,108,0;4;87;SAMPLER2D;0;False;85;FLOAT2;0,0;False;74;SAMPLERSTATE;0;False;91;FLOAT;1.5;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;1566;-2722.663,-1105.837;Inherit;True;Property;_RippleRenderTexture;Ripple Render Texture;77;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;602;-6842.792,427.7627;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1008;-5568.408,472.3389;Inherit;False;DistortedUVs;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1947;-4711.63,-1239.966;Inherit;False;1942;FlowUVAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1945;-4422.961,-1298.424;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1869;-6036.489,1817.247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;1870;-5908.489,1817.247;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;1853;-5788.489,1815.247;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1868;-6195.489,1817.247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;1851;-6335.49,1817.247;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1942;-5621.138,1810.7;Inherit;False;FlowUVAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1859;-6331.406,1681.543;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1835;-6492.091,1735.347;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1837;-6669.489,1711.547;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;1860;-6196.468,1684.973;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1861;-6054.686,1683.335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1867;-5904.583,1680.956;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1918;-5764.083,1684.246;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1934;-5630.396,1684.081;Inherit;False;FlowUVB;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1862;-6054.376,1553.099;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1876;-5894.276,1520.047;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1933;-5609.832,1514.248;Inherit;False;FlowUVA;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;1960;-5935.384,1649.262;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;1959;-5941.384,1599.262;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;1962;-5944.384,1512.261;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;1873;-6205.167,1363.395;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1833;-6351.28,1361.071;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1838;-6668.109,1360.243;Inherit;True;Property;_TextureSample30;Texture Sample 30;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;726;-5835.116,-2289.392;Inherit;False;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;728;-5830.717,-2003.091;Inherit;False;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1009;-6103.431,-2094.787;Inherit;False;1008;DistortedUVs;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1935;-6076.255,-2174.074;Inherit;False;1933;FlowUVA;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1937;-6080.246,-1965.53;Inherit;False;1934;FlowUVB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1973;-5831.66,-2384.083;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;567;-5273.611,-2370.596;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;579;-5274.611,-2163.595;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1943;-4893.868,-2095.344;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1944;-5168.626,-1959.873;Inherit;False;1942;FlowUVAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;1972;-4907.148,-2326.319;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1005;-4577.257,-2028.636;Inherit;False;1004;RainDropRipples;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendNormalsNode;748;-4295.707,-2032.636;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;747;-4296.372,-2259.246;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1975;-5830.66,-2110.083;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1974;-5617.66,-2123.083;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1984;-4199.106,-1402.865;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1980;-6023.018,-1698.061;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;729;-6031.116,-1604.181;Inherit;False;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1981;-6038.4,-1429.265;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;730;-6042.716,-1323.88;Inherit;False;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1939;-6322.459,-1514.438;Inherit;False;1934;FlowUVB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1011;-6343.466,-1594.207;Inherit;False;1008;DistortedUVs;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1938;-6324.675,-1673.815;Inherit;False;1933;FlowUVA;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;1979;-5870.38,-1371.851;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1985;-3864.545,-1561.748;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;1986;-3900.545,-1774.748;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;1987;-4315.545,-1809.748;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;1983;-4166.925,-1524.613;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;592;-4277.351,-919.9014;Inherit;True;Property;_TextureSample27;Texture Sample 27;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;593;-4279.229,-718.3681;Inherit;True;Property;_TextureSample28;Texture Sample 28;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;586;-3953.962,-919.9876;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1948;-3838.2,-696.1205;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1949;-4170.87,-524.0583;Inherit;False;1942;FlowUVAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1988;-3661.575,-917.8917;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;599;-3359.738,-919.4213;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1006;-3097.168,-919.775;Inherit;False;MicroNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;594;-4575.622,-915.6357;Inherit;True;Property;_MicroNormalMap;Micro Normal Map;25;2;[NoScaleOffset];[Normal];Create;True;1;Micro Normals;0;0;False;0;False;fc7df81110c0e4d2498739bf4d47a49d;fc7df81110c0e4d2498739bf4d47a49d;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StaticSwitch;1993;-4610.668,-716.7325;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1994;-4612.668,-591.0526;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;731;-4787.059,-814.6704;Inherit;False;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1990;-4788.653,-911.3112;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;732;-4786.953,-574.4272;Inherit;False;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1991;-4788.978,-670.4973;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1995;-4683.118,-723.7775;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1012;-5022.565,-717.3457;Inherit;False;1008;DistortedUVs;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1941;-4996.232,-639.0494;Inherit;False;1934;FlowUVB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1940;-5002.23,-798.0492;Inherit;False;1933;FlowUVA;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;587;-5187.391,-789.8965;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;588;-5187.375,-907.7664;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;591;-5420.391,-906.8965;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;1982;-5863.018,-1634.061;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1976;-4615.35,-2262.596;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1971;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1874;-6053.366,1442.119;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1996;-6204.958,1462.821;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1078;-6280.816,564.3967;Inherit;False;Property;_EnableAntiTileUVDistortion;Enable Anti-Tile UV Distortion;34;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;714;-5834.891,472.6377;Inherit;False;Property;_EnableDistortedUVs;Enable Distorted UV's;32;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;833;-5164.759,-3124.153;Inherit;False;Property;_DistortedUVInfluence;Distorted UV Influence;43;0;Create;False;0;0;0;False;0;False;0.35;0.35;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1574;-2464.124,-828.707;Inherit;True;Property;_TextureSample29;Texture Sample 29;69;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1576;-2600.756,-629.1228;Inherit;False;Property;_DynamicRippleWaveHeight;Dynamic Ripple Wave Height;80;0;Create;True;0;0;0;False;0;False;0.25;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1200;-770.5034,-4882.477;Inherit;False;Property;_FoamColor;Foam Color;60;1;[HDR];Create;True;0;0;0;False;0;False;2.996078,2.996078,2.996078,1;6.883182,6.883182,6.883182,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1427;-2201.578,-4638.122;Inherit;False;Property;_DistortedUVInfluence1;Distorted UV Influence;66;0;Create;False;0;0;0;False;0;False;2.5;0.35;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1348;-2611.671,-3827.041;Inherit;False;Property;_FoamParallaxScale;Foam Parallax Scale;68;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1359;-1343.526,-3932.468;Inherit;False;Property;_FoamDistortion;Foam Distortion;70;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0.15;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1435;-4711.005,-4290.464;Inherit;False;Property;_EnableDepthMaskedRefraction;Enable Depth Masked Refraction ;2;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1434;-4844.434,-4365.185;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1433;-5090.545,-4326.153;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1424;-5376.523,-4187.768;Inherit;False;1000;DistortionNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2027;-4943.968,-4446.647;Inherit;False;DepthColorNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2035;-3013.283,-4665.936;Inherit;False;DistortionType;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1724;-678.6742,-111.8441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;1718;-869.8697,-114.9604;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1729;-671.3485,-4.122078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-10;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1723;-537.0743,-80.24219;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1725;-392.3736,-80.44415;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1637;-221.5944,-137.7814;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1633;-472.4945,-298.28;Float;False;Property;_ShallowColor;Shallow Color;89;0;Create;True;0;0;0;False;0;False;0,0.4078431,0.4352941,1;0,0.8088232,0.8088235,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;1745;-249.6984,-182.2574;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1631;-694.8943,-299.4811;Float;False;Property;_DeepColor;Deep Color;90;0;Create;True;0;0;0;False;0;False;0,0.627451,0.7176471,1;0,0.04310164,0.2499982,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;1743;-497.0984,-324.3572;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1744;-294.0986,-323.3572;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1727;-811.5433,-30.07429;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2011;297.201,-1129.72;Inherit;True;Lerp3point;-1;;1863;75161d8269658b84e99f9b512cad5394;0;4;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;9;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2039;339.0719,-1204.15;Inherit;False;2035;DistortionType;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2026;535.0941,-1008.429;Inherit;False;Property;_DepthColor;Depth Color;93;0;Create;True;0;0;0;False;0;False;0.2313726,0.4352941,0.5490196,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;2021;586.3193,-1128.502;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2023;755.7011,-1129.023;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1735;-52.82932,-137.8506;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2045;910.4605,-1132.013;Inherit;False;DepthColorRegular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2047;102.615,-137.1144;Inherit;False;DepthColorDistanceBased;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;2041;-2426.374,-2815.775;Inherit;False;Property;_DepthColorMode;Depth Color Mode;88;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;RegularRecommended;DistanceBased;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2046;-2668.822,-2848.764;Inherit;False;2045;DepthColorRegular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2048;-2708.721,-2768.441;Inherit;False;2047;DepthColorDistanceBased;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;2013;40.83058,-1061.077;Inherit;False;Color_Float;13;;1865;ee9c4a8ca3fa8d9428fb0ab676796725;0;1;9;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8
Node;AmplifyShaderEditor.FunctionNode;2014;24.77758,-1244.194;Inherit;False;Color_Float;13;;1866;ee9c4a8ca3fa8d9428fb0ab676796725;0;1;9;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8
Node;AmplifyShaderEditor.Vector4Node;2015;-178.6533,-1246.106;Float;False;Constant;_Surfacefiltering;Surface filtering;33;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;2016;-179.1694,-1069.075;Float;False;Constant;_Midfiltering;Mid filtering;33;0;Create;True;0;0;0;False;0;False;0,0.5,0.5,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;2012;42.78937,-879.7804;Inherit;False;Color_Float;13;;1867;ee9c4a8ca3fa8d9428fb0ab676796725;0;1;9;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8
Node;AmplifyShaderEditor.Vector4Node;2017;-179.6976,-868.2284;Float;False;Constant;_Depth_filtering;Depth_filtering;33;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;2009;-68.10744,-699.5594;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2010;89.11547,-701.5204;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2006;-216.9604,-696.5594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;2005;-362.6075,-907.1564;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2004;-506.5815,-906.7885;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;2003;-698.5944,-914.5745;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1999;-639.2194,-836.3704;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;2019;-834.9797,-909.3594;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2018;-1062.787,-911.3904;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;2020;-831.9917,-804.3665;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;2002;-1087.499,-737.6575;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2028;-1087.335,-561.8971;Inherit;False;2027;DepthColorNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2049;-893.2238,-624.5684;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2050;-891.2238,-842.5704;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2051;-865.2238,-704.5695;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1067;-3420.372,1865.579;Inherit;False;1121;GerstnerWaves;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1099;-3420.372,1947.604;Inherit;False;1090;ThreeDTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1108;-3404.372,2025.579;Inherit;False;1107;MixedWaves;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1539;-3404.372,2107.604;Inherit;False;1548;NoiseWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1752;-3452.372,2185.579;Inherit;False;1750;DynamicRippleWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1751;-1381.689,-1096.406;Inherit;False;NormalsFinal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;2072;-1651.093,-1100.437;Inherit;False;Property;_EnableDynamicRipples;Enable Dynamic Ripples;75;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;983;-2120.66,-1117.106;Inherit;False;982;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1571;-1910.265,-879.7819;Inherit;False;NormalsDynamic;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1570;-4194.798,-2341.923;Inherit;False;1571;NormalsDynamic;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;2074;-3674.642,-2296.021;Inherit;False;Property;_Keyword0;Keyword 0;75;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;2072;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2075;-3960.642,-2313.021;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2076;-3740.642,-2306.021;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;1569;-3959.944,-2265.956;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1977;-3987.284,-2062.248;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1000;-3393.843,-2296.277;Inherit;False;DistortionNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1978;-3746.048,-2050.823;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;644;-3675.764,-2077.86;Inherit;False;Property;_EnableAntiTileNormals;Enable Anti-Tile Normals;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;585;-3359.045,-2072.816;Inherit;False;Property;_MicroNormals;Micro Normals;24;0;Create;False;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1007;-3596.983,-1974.028;Inherit;False;1006;MicroNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;982;-3142.452,-2072.044;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;1074;-6843.828,578.1099;Inherit;True;Property;_Distortion;Distortion;33;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;04faf1bd9d207b049a34d8765e3907a9;04faf1bd9d207b049a34d8765e3907a9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StaticSwitch;1971;-5599.054,-2345.652;Inherit;False;Property;_EnableFlowmappedUVs;Enable Flowmapped UV's;81;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1839;-6907.454,1357.111;Inherit;True;Property;_Flowmap;Flowmap;82;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;None;4d0173b04e2b3ba4ca7a8b8e0244a61c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;2077;-6202.3,1269.155;Inherit;False;DebugFlowmap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2078;-6368.3,1336.155;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;2082;-600.6382,-2832.016;Inherit;False;Property;_DebugView;Debug View;85;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2084;-1000.638,-2736.016;Inherit;False;2077;DebugFlowmap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2090;-1048.638,-2768.016;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2089;-808.6382,-2768.016;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;2073;-1915.093,-792.4372;Inherit;False;Property;_Keyword0;Keyword 0;75;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;2072;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1575;-2106.9,-720.9029;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2091;-2141.647,-828.6614;Inherit;False;DebugDynamicRipple;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2085;-776.6382,-2752.016;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2094;-312.6382,-2752.016;Inherit;False;2091;DebugDynamicRipple;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1750;-1623.972,-791.1398;Inherit;False;DynamicRippleWaves;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;2087;103.3618,-2848.016;Inherit;False;Property;_DebugView1;Debug View;78;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2096;-104.6381,-2768.016;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2097;-344.6382,-2784.016;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;992;-179.8835,-4711.97;Inherit;False;991;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;2098;-1667.894,-2815.642;Inherit;False;Property;_EnablePostProcessing;Enable Post Processing;96;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2036;-2272.04,-2889.58;Inherit;False;2035;DistortionType;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1742;-2012.021,-2840.116;Inherit;False;Property;_EnableDepthColors;Enable Depth Colors;87;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;991;-1329.68,-2899.769;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2131;-1667.17,-2898.577;Inherit;False;ColorWithDepthColors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2134;-1951.411,-2736.266;Inherit;False;2133;ColorPostProcess;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2123;-2271.624,-3380.426;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;2124;-2399.624,-3379.426;Inherit;False;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;2125;-2621.624,-3380.426;Inherit;False;Constant;_PerceptualWeights;Perceptual Weights;0;0;Create;True;0;0;0;False;0;False;0.2126729,0.7151522,0.072175;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;2136;-2099.379,-3377.701;Inherit;False;Property;_Saturation;Saturation;98;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;2138;-1351.379,-3359.701;Inherit;False;Property;_Contrast;Contrast;100;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2132;-2647.261,-3236.755;Inherit;False;2131;ColorWithDepthColors;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2143;-2142.607,-3277.691;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2144;-2359.607,-3219.691;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;2107;-1552.851,-3271.145;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2145;-1594.656,-3283.296;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2146;-1837.656,-3303.296;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;2152;-662.6829,-3352.469;Inherit;False;Property;_Posterize;Posterize;102;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;2106;-820.7008,-3281.9;Inherit;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2154;-852.6827,-3292.469;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2155;-1072.683,-3293.469;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;2172;734.7341,-3362.787;Inherit;False;Property;_Grayscale;Grayscale;97;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;2171;534.3894,-3292.578;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2164;-79.26909,-3335.397;Inherit;True;Midtones Control;104;;1886;1862d12003a80d24ab048da83dc4e4d5;0;4;25;COLOR;0,0,0,0;False;26;FLOAT;0;False;27;FLOAT;0;False;28;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;2175;217.1423,-3357.729;Inherit;False;Property;_Midtones;Midtones;106;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2178;170.0984,-3369.354;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2180;-164.9019,-3333.354;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2181;-398.9019,-3354.354;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2182;-120.9019,-3369.354;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2183;50.09832,-3369.354;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2166;-388.2691,-3295.397;Inherit;False;Property;_Red;Red;107;0;Create;True;0;0;0;False;0;False;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2168;-388.2691,-3220.397;Inherit;False;Property;_Green;Green;108;0;Create;True;0;0;0;False;0;False;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2167;-386.2691,-3146.397;Inherit;False;Property;_Blue;Blue;109;0;Create;True;0;0;0;False;0;False;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2133;955.0261,-3365.384;Inherit;False;ColorPostProcess;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1268;-1509.027,-2708.566;Inherit;False;1267;Foam;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1266;-1292.282,-2815.877;Inherit;False;Property;_EnableFoam;Enable Foam;56;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2037;-254.1336,-16.24329;Inherit;False;2035;DistortionType;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1035;-3525.867,-4507.865;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1270;-3771.338,-4602.295;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1762;-2244.177,-2067.813;Inherit;False;1751;NormalsFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;418;-1917.787,-2129.645;Inherit;False;BRDFMap;8;;1887;1affaac2d6e57354aaa8d6573a2b32b8;0;1;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1499;-2220.451,-1715.396;Inherit;False;1498;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2062;-2217.322,-1628.05;Inherit;False;2060;Waves;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1265;-2234.887,-2154.505;Inherit;False;2079;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2184;-2200.001,-1958.253;Inherit;False;Property;_Cull;_Cull;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2192;-1977.759,-2052.11;Float;False;True;-1;2;LitMASWaterShaderGUI;0;14;AtlasShaders/LitMAS Water/LitMAS Water 3;623634af11bd9ab448550ee777f3493e;True;Forward;0;0;Forward;14;False;True;1;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;True;True;0;True;_Cull;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;1;Lightmode=UniversalForward;True;7;False;0;Hidden/InternalErrorShader;0;0;Standard;24;Workflow;0;638996374149308468;Surface;2;638996386781847205;Two Sided;1;638996385806453185;Cast Shadows;0;638996873929805598;  Use Shadow Threshold;0;0;GPU Instancing;0;638996875691260127;Built-in Fog;1;0;Lightmaps;1;0;Volumetrics;1;0;Decals;0;0;Write Depth;0;0;  Early Z (broken);0;0;Vertex Position,InvertActionOnDeselection;1;0;Emission;1;0;PC Reflection Probe;3;0;PC Receive Shadows;1;0;PC Vertex Lights;0;0;PC SSAO;1;0;Q Reflection Probe;0;0;Q Receive Shadows;0;0;Q Vertex Lights;1;0;Q SSAO;0;0;Environment Reflections;1;0;Meta Pass;1;0;0;5;True;True;True;False;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2193;-1899.829,-1793.107;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;14;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthOnly;0;1;DepthOnly;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2194;-1899.829,-1793.107;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;14;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthNormals;0;2;DepthNormals;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2195;-1899.829,-1793.107;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;14;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;ShadowCaster;0;3;ShadowCaster;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2196;-1899.829,-1793.107;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;14;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;Meta;0;4;Meta;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.LerpOp;2092;-56.63815,-2768.016;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2225;-1046.587,-2798.36;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2079;350.6085,-2845.729;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;583;-2325.395,-1790.833;Inherit;False;Property;_Smoothness;Smoothness;11;1;[Header];Create;True;1;Specular;0;0;False;0;False;0.95;0.95;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;614;-2326.905,-1873.085;Inherit;False;Property;_Reflectivity;Reflectivity;12;0;Create;True;0;0;0;False;0;False;0.1;0.65;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1014;-3376.156,-4665.339;Inherit;True;Property;_DistortionType;Distortion Type;15;0;Create;True;0;0;0;False;0;False;0;1;1;True;;KeywordEnum;3;None;Default;ChromaticAberration;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;975;-5406.651,-4288.172;Inherit;False;Property;_DistortionIntensity;Distortion Intensity;16;0;Create;True;0;0;0;False;0;False;0.25;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;969;-4232.014,-4255.132;Inherit;False;Property;_RGBOffset;RGB Offset;17;0;Create;True;1;Chromatic Abberation;0;0;False;0;False;0.4;0.4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2007;-512.8445,-677.7334;Float;False;Property;_Clarity;Clarity;94;0;Create;True;0;0;0;False;0;False;0.7;0.096;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2025;472.1644,-838.2684;Float;False;Property;_Murkiness;Murkiness;95;0;Create;True;0;0;0;False;0;False;0.7;0.096;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1721;-1081.97,-36.36115;Float;False;Property;_WaterDepth;Water Depth;91;0;Create;True;0;0;0;False;0;False;1;0.99;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1722;-954.7697,64.14021;Float;False;Property;_DepthTranslucency;Depth Translucency;92;0;Create;True;0;0;0;False;0;False;0.03;-3.6;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;577;-6712.064,-2345.878;Inherit;False;Property;_NormalTiling;Normal Tiling;20;0;Create;True;1;(Non MV ONLY 0.1 Through 1 Recommended);0;0;False;0;False;2,2;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;578;-6664.392,-1879.566;Inherit;False;Property;_NormalIntensity;Normal Intensity;21;0;Create;True;1;(Non MV ONLY);0;0;False;0;False;0;0.35;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;595;-5626.391,-905.8965;Inherit;False;Property;_MicroNormalTiling;Micro Normal Tiling;26;0;Create;True;1;(Non MV ONLY 0.1 Through 1 Recommended);0;0;False;0;False;50,50;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;596;-5484.391,-618.8965;Inherit;False;Property;_MicroNormalIntensity;Micro Normal Intensity;27;0;Create;True;1;(Non MV ONLY);0;0;False;0;False;0.095;0.095;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;589;-5484.391,-778.8965;Inherit;False;Property;_MicroNormalSpeedX;Micro Normal Speed X;28;0;Create;True;0;0;0;False;0;False;0.05;-0.05;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;590;-5484.391,-698.8965;Inherit;False;Property;_MicroNormalSpeedY;Micro Normal Speed Y;29;0;Create;True;0;0;0;False;0;False;0.05;0.05;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;623;-5304.328,-409.5584;Inherit;False;Property;_MicroNormalsNearFadeDistance;Micro Normals Near Fade Distance;30;0;Create;True;0;0;0;False;0;False;0;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;624;-5305.328,-332.559;Inherit;False;Property;_MicroNormalsFarFadeDistance;Micro Normals Far Fade Distance;31;0;Create;True;0;0;0;False;0;False;4;4;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1561;-2462.817,-931.478;Inherit;False;Property;_DynamicRippleIntensity;Dynamic Ripple Intensity;76;0;Create;True;0;0;0;False;0;False;0.075;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2229;-1935.84,-1119.347;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;2228;-1688.84,-1126.347;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;1562;-1912.982,-1090.314;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1997;-2303.86,-637.5148;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2086;-1051.638,-2653.016;Inherit;False;Property;_DebugContrast;Debug Contrast;86;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2093;-344.6382,-2672.016;Inherit;False;Property;_DebugContrast1;Debug Contrast;79;0;Create;False;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1141;-5166.379,557.7208;Float;False;Property;_NumberOfWaves;Number Of Waves;46;0;Create;True;1;Gerstner Wave Settings;0;0;False;0;False;8;8;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1143;-5165.793,741.3567;Float;False;Property;_Steepness;Steepness;47;0;Create;True;0;0;0;False;0;False;10;20;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1140;-5166.796,824.7639;Float;False;Property;_Wavelength;Wavelength;48;0;Create;True;0;0;0;False;0;False;2.5;3.44;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1139;-5169.095,921.3398;Float;False;Property;_Amplitude;Amplitude;49;0;Create;True;0;0;0;False;0;False;0.05;0.03;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1138;-5166.797,1014.748;Float;False;Property;_Speed;Speed;50;0;Create;True;0;0;0;False;0;False;0.35;0.5;-8;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1088;-5147.123,1641.059;Inherit;False;Property;_DisplacementTiling;Displacement Tiling;52;0;Create;True;0;0;0;False;0;False;0.25;15;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1087;-5146.327,1732.018;Inherit;False;Property;_WaveSpeed;Wave Speed;53;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1095;-4840.962,1788.482;Inherit;False;Property;_WaveHeight;Wave Height;54;0;Create;True;0;0;0;False;0;False;0.25;0.14;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1551;-5124.779,2104.149;Inherit;False;Property;_NoiseWavesSpeed;Noise Waves Speed;71;1;[Header];Create;True;0;0;0;False;0;False;0.075;0.25;0.075;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1519;-4859.685,2186.952;Inherit;False;Property;_NoiseWavesDirection;Noise Waves Direction;74;0;Create;True;0;0;0;False;0;False;0,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1515;-4544.878,2216.142;Inherit;False;Property;_NoiseWavesScale;Noise Waves Scale;72;0;Create;True;0;0;0;False;0;False;10;53.27;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1066;-3168.372,1935.579;Inherit;True;Property;_WaveType;Wave Type;45;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;6;None;GerstnerWaves;3DTexture;Gerstnerand3DTexture;Noise;DynamicRipples;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2060;-2801.406,1935.088;Inherit;False;Waves;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;1185;-2183.308,-4871.187;Inherit;False;Property;_FoamTiling;Foam Tiling;58;0;Create;True;1;(Non MV ONLY 0.1 Through 1 Recommended);0;0;False;0;False;25,25;25,15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;1260;-174.2003,-5334.231;Inherit;False;Property;_EnableAntiTileFoam;Enable Anti-Tile Foam;59;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1243;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1243;-274.1753,-4625.555;Inherit;False;Property;_EnableAntiTileFoam;Enable Anti-Tile Foam;59;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1189;-2616.878,-4873.633;Inherit;False;Property;_FoamSpeedX;Foam Speed X;61;0;Create;True;0;0;0;False;0;False;0.01;0.01;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1190;-2600.879,-4713.635;Inherit;False;Property;_FoamSpeedY;Foam Speed Y;62;0;Create;True;0;0;0;False;0;False;0.05;0.05;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1174;-2251.642,-5287.224;Inherit;False;Property;_FoamStrength;Foam Strength;63;0;Create;True;0;0;0;False;0;False;1;1;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1210;-933.8874,-4527.627;Inherit;False;Property;_FoamAlpha;Foam Alpha;65;0;Create;True;0;0;0;False;0;False;5;5;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1841;-6649.498,1552.594;Inherit;False;Property;_Strength;Strength;84;0;Create;True;0;0;0;False;0;False;0.35;2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1836;-6771.092,1794.846;Inherit;False;Property;_FlowSpeed;Flow Speed;83;0;Create;True;0;0;0;False;0;False;0.6;1;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;600;-6279.17,485.8599;Inherit;False;Property;_DistortOverlayIntensity;Distort Overlay Intensity;35;0;Create;True;0;0;0;False;0;False;0.15;0.05;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;706;-7500.254,470.1128;Inherit;False;Property;_DistortionSpeedX;Distortion Speed X;36;0;Create;True;0;0;0;False;0;False;0;-0.04;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;707;-7496.904,552.4099;Inherit;False;Property;_DistortionSpeedY;Distortion Speed Y;37;0;Create;True;0;0;0;False;0;False;0.008;0.02;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;603;-7035.619,425.1248;Inherit;False;Property;_DistortionTiling;Distortion Tiling;38;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;798;-5754.791,-3355.531;Inherit;False;Property;_RainDropRippleTiling;Rain Drop Ripple Tiling;40;0;Create;True;0;0;0;False;0;False;35,35;30,30;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;845;-4208.363,-2626.463;Inherit;False;Property;_RainDropRippleIntensity;Rain Drop Ripple Intensity;41;0;Create;True;1;(Non MV ONLY);0;0;False;0;False;1;0.676;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;793;-5711.369,-3021.698;Inherit;False;Property;_RainDropRippleSpeed;Rain Drop Ripple Speed;42;0;Create;True;0;0;0;False;0;False;25;22.8;0;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2129;-2677.964,-3161.676;Inherit;False;Property;_SaturationIntensity;Saturation Intensity;99;0;Create;True;0;0;0;False;0;False;1.25;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2137;-1833.379,-3251.701;Inherit;False;Property;_ContrastIntensity;Contrast Intensity;101;0;Create;True;0;0;0;False;0;False;1.1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2148;-1090.771,-3235.522;Inherit;False;Property;_PosterizationIntensity;Posterization Intensity;103;0;Create;True;0;0;0;False;0;False;25;0;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;574;-6663.091,-2039.567;Inherit;False;Property;_WaterSpeedX;Water Speed X;22;0;Create;True;0;0;0;False;0;False;0.01;0.01;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;575;-6663.091,-1959.566;Inherit;False;Property;_WaterSpeedY;Water Speed Y;23;0;Create;True;0;0;0;False;0;False;0.01;-0.01;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;2206;-869.469,-2400.638;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1455;-1146.252,-2388.291;Inherit;False;Property;_SoftIntersectionIntensity;Soft Intersection Intensity;4;0;Create;True;0;0;0;False;1;;False;0.2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;2208;-626.7058,-2300;Inherit;False;Property;_EnableAlphaMasking;Enable Alpha Masking;110;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1496;-476.7058,-2195;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;1495;-639.7058,-2196;Inherit;False;1270;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2199;-828.676,-2185.753;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2197;-1126.891,-2295.518;Inherit;True;Property;_AlphaMask;Alpha Mask;111;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2201;-1104.345,-2107.912;Inherit;False;Property;_AlphaFalloff;Alpha Falloff;112;0;Create;True;0;0;0;False;0;False;0.25;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1501;-638.4878,-2409.919;Inherit;False;Property;_EnableSoftIntersection;Enable Soft Intersection;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2198;-327.6756,-2375.754;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1498;-188.6936,-2362.732;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2209;-789.3249,-2282.522;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1550;-4287.089,2334.096;Inherit;False;Property;_NoiseWavesSize;Noise Waves Height;73;0;Create;False;0;0;0;False;0;False;8;0;2;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;2233;-839.7652,-2016;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2232;-599.7652,-2016;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2231;-599.7652,-1952;Inherit;False;Constant;_Float8;Float 0;22;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;2230;-456.4048,-2012.595;Inherit;False;Property;_EnableCameraDepthFading;Enable Camera Depth Fading;5;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2234;-1111.765,-2016;Inherit;False;Property;_CDFalloff;Falloff;6;1;[Header];Create;False;0;0;0;False;0;False;0.05;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2235;-1111.765,-1941;Inherit;False;Property;_CDDistance;Distance;7;0;Create;False;0;0;0;False;0;False;0.05;0;0;1;0;1;FLOAT;0
WireConnection;622;1;623;0
WireConnection;622;2;624;0
WireConnection;622;3;621;0
WireConnection;621;0;620;0
WireConnection;626;0;596;0
WireConnection;626;1;625;0
WireConnection;627;0;622;0
WireConnection;625;0;627;0
WireConnection;620;0;619;0
WireConnection;620;1;618;0
WireConnection;678;0;639;0
WireConnection;682;0;678;1
WireConnection;682;1;578;0
WireConnection;681;0;678;0
WireConnection;681;1;578;0
WireConnection;683;0;681;0
WireConnection;683;1;682;0
WireConnection;683;2;678;2
WireConnection;685;0;683;0
WireConnection;639;1;638;0
WireConnection;637;1;636;0
WireConnection;675;0;637;0
WireConnection;676;0;675;0
WireConnection;676;1;578;0
WireConnection;679;0;675;1
WireConnection;679;1;578;0
WireConnection;680;0;676;0
WireConnection;680;1;679;0
WireConnection;680;2;675;2
WireConnection;684;0;680;0
WireConnection;809;0;797;0
WireConnection;809;1;789;0
WireConnection;809;2;790;0
WireConnection;809;3;852;0
WireConnection;809;5;792;0
WireConnection;824;0;809;1
WireConnection;825;0;809;2
WireConnection;826;0;824;0
WireConnection;826;1;825;0
WireConnection;832;0;833;0
WireConnection;832;1;1010;0
WireConnection;811;0;792;0
WireConnection;811;1;812;0
WireConnection;810;0;797;0
WireConnection;810;1;789;0
WireConnection;810;2;790;0
WireConnection;810;3;852;0
WireConnection;810;5;811;0
WireConnection;827;0;810;1
WireConnection;829;0;810;2
WireConnection;828;0;827;0
WireConnection;828;1;829;0
WireConnection;831;0;828;0
WireConnection;831;1;834;0
WireConnection;830;0;826;0
WireConnection;830;1;832;0
WireConnection;813;82;802;0
WireConnection;813;5;830;0
WireConnection;814;0;813;0
WireConnection;814;1;801;0
WireConnection;814;2;1001;0
WireConnection;801;82;802;0
WireConnection;801;5;831;0
WireConnection;815;0;792;0
WireConnection;815;1;816;0
WireConnection;817;0;815;0
WireConnection;817;1;818;0
WireConnection;819;0;817;0
WireConnection;821;0;847;0
WireConnection;821;1;819;0
WireConnection;822;0;821;0
WireConnection;822;1;820;0
WireConnection;823;0;822;0
WireConnection;842;0;814;0
WireConnection;843;0;842;0
WireConnection;844;0;843;0
WireConnection;847;0;848;0
WireConnection;848;0;820;0
WireConnection;797;0;798;0
WireConnection;852;0;793;0
WireConnection;852;1;855;0
WireConnection;855;0;854;0
WireConnection;854;0;853;0
WireConnection;638;82;566;0
WireConnection;638;5;1979;0
WireConnection;841;0;823;0
WireConnection;1001;0;841;0
WireConnection;803;1;844;0
WireConnection;836;0;803;0
WireConnection;837;0;836;0
WireConnection;837;1;845;0
WireConnection;839;0;837;0
WireConnection;839;1;838;0
WireConnection;839;2;836;2
WireConnection;838;0;836;1
WireConnection;838;1;845;0
WireConnection;840;0;839;0
WireConnection;1002;0;1003;0
WireConnection;1003;0;840;0
WireConnection;1004;0;846;0
WireConnection;956;0;1435;0
WireConnection;956;1;959;0
WireConnection;957;0;1435;0
WireConnection;957;1;960;0
WireConnection;958;0;1435;0
WireConnection;958;1;961;0
WireConnection;959;0;969;0
WireConnection;959;1;964;0
WireConnection;960;0;969;0
WireConnection;960;1;963;0
WireConnection;961;0;969;0
WireConnection;961;1;962;0
WireConnection;967;0;957;0
WireConnection;965;0;968;1
WireConnection;965;1;967;2
WireConnection;965;2;966;3
WireConnection;1018;0;1017;0
WireConnection;1019;0;1018;0
WireConnection;972;0;1435;0
WireConnection;636;82;566;0
WireConnection;636;5;1982;0
WireConnection;640;0;684;0
WireConnection;640;1;685;0
WireConnection;1017;0;972;0
WireConnection;979;0;978;0
WireConnection;979;1;1019;0
WireConnection;834;0;833;0
WireConnection;834;1;1010;0
WireConnection;576;0;577;0
WireConnection;573;0;576;0
WireConnection;573;2;574;0
WireConnection;572;0;576;0
WireConnection;572;2;575;0
WireConnection;1173;0;1172;0
WireConnection;1175;0;1173;0
WireConnection;1175;1;1224;0
WireConnection;1224;0;1174;0
WireConnection;1201;0;1175;0
WireConnection;1201;1;1202;0
WireConnection;1201;2;1225;0
WireConnection;1225;0;1203;0
WireConnection;1239;0;1176;0
WireConnection;1176;0;1201;0
WireConnection;1263;0;1217;0
WireConnection;1263;1;1254;0
WireConnection;1261;0;1234;0
WireConnection;1261;1;1254;0
WireConnection;1262;0;1261;0
WireConnection;1262;1;1217;0
WireConnection;1264;0;1263;0
WireConnection;1264;1;1234;0
WireConnection;1245;0;1260;0
WireConnection;1283;0;1186;0
WireConnection;1283;1;1282;0
WireConnection;1186;0;1185;0
WireConnection;1186;1;1195;0
WireConnection;1191;0;1190;0
WireConnection;1191;1;1192;0
WireConnection;1195;0;1194;0
WireConnection;1195;1;1191;0
WireConnection;1194;0;1189;0
WireConnection;1194;1;1193;0
WireConnection;1345;0;1344;0
WireConnection;1345;1;1181;0
WireConnection;1345;7;1181;1
WireConnection;1345;2;1348;0
WireConnection;1345;3;1342;0
WireConnection;1354;0;1345;0
WireConnection;1354;1;1283;0
WireConnection;1184;0;1181;0
WireConnection;1184;1;1361;0
WireConnection;1217;0;1240;0
WireConnection;1217;1;1220;0
WireConnection;1221;82;1181;0
WireConnection;1221;5;1361;0
WireConnection;1196;0;1240;0
WireConnection;1196;1;1200;0
WireConnection;1196;2;1221;0
WireConnection;1196;3;1271;0
WireConnection;1267;0;1198;0
WireConnection;1241;0;1240;0
WireConnection;1241;1;1200;0
WireConnection;1241;2;1184;0
WireConnection;1241;3;1271;0
WireConnection;1231;0;1184;4
WireConnection;1231;1;1210;0
WireConnection;1234;0;1240;0
WireConnection;1234;1;1231;0
WireConnection;1360;0;1358;0
WireConnection;1360;1;1359;0
WireConnection;1198;0;992;0
WireConnection;1198;1;1243;0
WireConnection;1198;2;1246;0
WireConnection;1358;0;1181;0
WireConnection;1358;1;1369;0
WireConnection;1369;0;1352;0
WireConnection;1369;1;1368;0
WireConnection;1368;0;1370;0
WireConnection;1423;35;1424;0
WireConnection;1423;37;975;0
WireConnection;966;0;958;0
WireConnection;1361;1;1352;0
WireConnection;1361;0;1360;0
WireConnection;846;1;1976;0
WireConnection;846;0;1002;0
WireConnection;1352;1;1283;0
WireConnection;1352;0;1354;0
WireConnection;705;0;709;0
WireConnection;705;1;710;0
WireConnection;709;0;706;0
WireConnection;709;1;708;0
WireConnection;710;0;707;0
WireConnection;710;1;708;0
WireConnection;1072;82;1074;0
WireConnection;1072;5;602;0
WireConnection;1076;0;1074;0
WireConnection;1076;1;602;0
WireConnection;608;0;600;0
WireConnection;608;1;1078;0
WireConnection;1080;0;705;0
WireConnection;1081;0;1080;0
WireConnection;1083;0;1096;1
WireConnection;1083;1;1088;0
WireConnection;1084;0;1096;3
WireConnection;1084;1;1088;0
WireConnection;1086;0;1087;0
WireConnection;1091;0;1097;0
WireConnection;1091;1;1092;0
WireConnection;1085;0;1083;0
WireConnection;1085;1;1084;0
WireConnection;1085;2;1086;0
WireConnection;1097;0;1098;0
WireConnection;1098;0;1094;0
WireConnection;1092;0;1095;0
WireConnection;1089;0;1093;0
WireConnection;1089;1;1091;0
WireConnection;1090;0;1089;0
WireConnection;1123;0;1126;0
WireConnection;1123;1;1124;0
WireConnection;1125;0;1127;0
WireConnection;1127;0;1135;0
WireConnection;1131;0;1134;0
WireConnection;1131;1;1132;0
WireConnection;1135;0;1136;0
WireConnection;1135;1;1122;0
WireConnection;1142;0;1141;0
WireConnection;1142;1;1137;0
WireConnection;1157;0;1279;87
WireConnection;1157;1;1276;87
WireConnection;1157;2;1277;87
WireConnection;1157;3;1278;87
WireConnection;1158;0;1148;0
WireConnection;1158;1;1159;0
WireConnection;1158;2;1157;0
WireConnection;1161;0;1158;0
WireConnection;1168;0;1148;0
WireConnection;1169;0;1157;0
WireConnection;1106;0;1101;0
WireConnection;1106;1;1105;0
WireConnection;1104;0;1102;0
WireConnection;1104;1;1105;0
WireConnection;1103;0;1106;0
WireConnection;1103;1;1104;0
WireConnection;1107;0;1103;0
WireConnection;1276;19;1140;0
WireConnection;1276;18;1138;0
WireConnection;1276;26;1139;0
WireConnection;1276;33;1142;0
WireConnection;1276;25;1143;0
WireConnection;1276;52;1131;0
WireConnection;1277;19;1140;0
WireConnection;1277;18;1138;0
WireConnection;1277;26;1139;0
WireConnection;1277;33;1142;0
WireConnection;1277;25;1143;0
WireConnection;1277;52;1125;0
WireConnection;1278;19;1140;0
WireConnection;1278;18;1138;0
WireConnection;1278;26;1139;0
WireConnection;1278;33;1142;0
WireConnection;1278;25;1143;0
WireConnection;1278;52;1123;0
WireConnection;1279;19;1140;0
WireConnection;1279;18;1138;0
WireConnection;1279;26;1139;0
WireConnection;1279;33;1142;0
WireConnection;1279;25;1143;0
WireConnection;1279;52;1133;0
WireConnection;1148;0;1279;86
WireConnection;1148;1;1276;86
WireConnection;1148;2;1277;86
WireConnection;1148;3;1278;86
WireConnection;1163;0;1161;0
WireConnection;1093;1;1085;0
WireConnection;1128;0;1279;0
WireConnection;1128;1;1276;0
WireConnection;1128;2;1277;0
WireConnection;1128;3;1278;0
WireConnection;1121;0;1128;0
WireConnection;1541;0;1513;0
WireConnection;1541;1;1515;0
WireConnection;1513;1;1520;0
WireConnection;1520;0;1521;0
WireConnection;1520;1;1519;0
WireConnection;1521;0;1551;0
WireConnection;1549;0;1541;0
WireConnection;1549;2;1550;0
WireConnection;1548;0;1549;0
WireConnection;1220;0;1221;35
WireConnection;1220;1;1210;0
WireConnection;1172;0;1170;0
WireConnection;1172;1;1171;0
WireConnection;1282;0;1427;0
WireConnection;1282;1;1281;0
WireConnection;968;0;956;0
WireConnection;1565;87;1566;0
WireConnection;1565;91;1561;0
WireConnection;602;0;603;0
WireConnection;602;1;1081;0
WireConnection;1008;0;714;0
WireConnection;1945;0;684;0
WireConnection;1945;1;685;0
WireConnection;1945;2;1947;0
WireConnection;1869;0;1868;0
WireConnection;1870;0;1869;0
WireConnection;1853;0;1870;0
WireConnection;1868;0;1851;0
WireConnection;1851;0;1835;0
WireConnection;1942;0;1853;0
WireConnection;1859;0;1835;0
WireConnection;1835;0;1837;0
WireConnection;1835;1;1836;0
WireConnection;1860;0;1859;0
WireConnection;1861;0;1860;0
WireConnection;1867;0;1960;0
WireConnection;1867;1;1861;0
WireConnection;1918;1;1867;0
WireConnection;1934;0;1918;0
WireConnection;1862;0;1851;0
WireConnection;1876;0;1874;0
WireConnection;1876;1;1862;0
WireConnection;1933;0;1876;0
WireConnection;1960;0;1959;0
WireConnection;1959;0;1962;0
WireConnection;1962;0;1874;0
WireConnection;1873;0;1833;0
WireConnection;1833;0;1838;1
WireConnection;1833;1;1838;2
WireConnection;1838;0;1839;0
WireConnection;1838;7;1839;1
WireConnection;726;0;573;0
WireConnection;726;1;1009;0
WireConnection;726;2;1935;0
WireConnection;728;0;572;0
WireConnection;728;1;1009;0
WireConnection;728;2;1937;0
WireConnection;1973;0;573;0
WireConnection;1973;1;1009;0
WireConnection;567;0;566;0
WireConnection;567;1;1971;0
WireConnection;567;5;578;0
WireConnection;579;0;566;0
WireConnection;579;1;1974;0
WireConnection;579;5;578;0
WireConnection;1943;0;567;0
WireConnection;1943;1;579;0
WireConnection;1943;2;1944;0
WireConnection;1972;0;567;0
WireConnection;1972;1;579;0
WireConnection;748;0;1987;0
WireConnection;748;1;1005;0
WireConnection;747;0;1976;0
WireConnection;747;1;1005;0
WireConnection;1975;0;572;0
WireConnection;1975;1;1009;0
WireConnection;1974;1;1975;0
WireConnection;1974;0;728;0
WireConnection;1984;0;1945;0
WireConnection;1980;0;573;0
WireConnection;1980;1;1011;0
WireConnection;729;0;573;0
WireConnection;729;1;1011;0
WireConnection;729;2;1938;0
WireConnection;1981;0;572;0
WireConnection;1981;1;1011;0
WireConnection;730;0;572;0
WireConnection;730;1;1011;0
WireConnection;730;2;1939;0
WireConnection;1979;1;1981;0
WireConnection;1979;0;730;0
WireConnection;1985;0;1983;0
WireConnection;1986;0;1985;0
WireConnection;1987;0;1986;0
WireConnection;1983;1;640;0
WireConnection;1983;0;1984;0
WireConnection;592;0;594;0
WireConnection;592;1;1993;0
WireConnection;592;5;626;0
WireConnection;593;0;594;0
WireConnection;593;1;1994;0
WireConnection;593;5;626;0
WireConnection;586;0;592;0
WireConnection;586;1;593;0
WireConnection;1948;0;592;0
WireConnection;1948;1;593;0
WireConnection;1948;2;1949;0
WireConnection;1988;1;586;0
WireConnection;1988;0;1948;0
WireConnection;599;0;1988;0
WireConnection;599;1;644;0
WireConnection;1006;0;599;0
WireConnection;1993;1;1990;0
WireConnection;1993;0;1995;0
WireConnection;1994;1;1991;0
WireConnection;1994;0;732;0
WireConnection;731;0;588;0
WireConnection;731;1;1012;0
WireConnection;731;2;1940;0
WireConnection;1990;0;588;0
WireConnection;1990;1;1012;0
WireConnection;732;0;587;0
WireConnection;732;1;1012;0
WireConnection;732;2;1941;0
WireConnection;1991;0;587;0
WireConnection;1991;1;1012;0
WireConnection;1995;0;731;0
WireConnection;587;0;591;0
WireConnection;587;2;590;0
WireConnection;588;0;591;0
WireConnection;588;2;589;0
WireConnection;591;0;595;0
WireConnection;1982;1;1980;0
WireConnection;1982;0;729;0
WireConnection;1976;1;1972;0
WireConnection;1976;0;1943;0
WireConnection;1874;0;1873;0
WireConnection;1874;1;1996;0
WireConnection;1996;0;1841;0
WireConnection;1078;1;1076;0
WireConnection;1078;0;1072;0
WireConnection;714;0;608;0
WireConnection;1574;0;1566;0
WireConnection;1435;1;1434;0
WireConnection;1435;0;1423;38
WireConnection;1434;0;1432;0
WireConnection;1434;1;1433;0
WireConnection;1433;0;975;0
WireConnection;1433;1;1424;0
WireConnection;2027;0;1433;0
WireConnection;2035;0;1014;0
WireConnection;1724;0;1718;0
WireConnection;1724;1;1727;0
WireConnection;1729;0;1722;0
WireConnection;1723;0;1724;0
WireConnection;1723;1;1729;0
WireConnection;1725;0;1723;0
WireConnection;1637;0;1745;0
WireConnection;1637;1;1633;0
WireConnection;1637;2;1725;0
WireConnection;1745;0;1744;0
WireConnection;1743;0;1631;0
WireConnection;1744;0;1743;0
WireConnection;1727;0;1721;0
WireConnection;2011;1;2014;0
WireConnection;2011;2;2013;0
WireConnection;2011;3;2012;0
WireConnection;2011;9;2010;0
WireConnection;2021;0;2011;0
WireConnection;2021;1;2039;0
WireConnection;2021;2;2010;0
WireConnection;2023;0;2021;0
WireConnection;2023;1;2026;0
WireConnection;2023;2;2025;0
WireConnection;1735;0;1637;0
WireConnection;1735;1;2037;0
WireConnection;1735;2;1725;0
WireConnection;2045;0;2023;0
WireConnection;2047;0;1735;0
WireConnection;2041;1;2046;0
WireConnection;2041;0;2048;0
WireConnection;2013;9;2016;0
WireConnection;2014;9;2015;0
WireConnection;2012;9;2017;0
WireConnection;2009;0;2006;0
WireConnection;2010;0;2009;0
WireConnection;2006;0;2005;0
WireConnection;2006;1;2007;0
WireConnection;2005;0;2004;0
WireConnection;2004;0;2003;0
WireConnection;2004;1;1999;3
WireConnection;2003;0;2019;0
WireConnection;1999;0;2020;0
WireConnection;2019;0;2050;0
WireConnection;2019;1;2018;0
WireConnection;2020;0;2002;0
WireConnection;2020;1;2051;0
WireConnection;2049;0;2028;0
WireConnection;2050;0;2049;0
WireConnection;2051;0;2028;0
WireConnection;1751;0;2072;0
WireConnection;2072;1;2228;0
WireConnection;2072;0;1562;0
WireConnection;1571;0;1565;40
WireConnection;2074;1;2076;0
WireConnection;2074;0;1569;0
WireConnection;2075;0;747;0
WireConnection;2076;0;2075;0
WireConnection;1569;0;747;0
WireConnection;1569;1;1570;0
WireConnection;1977;0;747;0
WireConnection;1000;0;2074;0
WireConnection;1978;0;1977;0
WireConnection;644;1;1978;0
WireConnection;644;0;748;0
WireConnection;585;1;644;0
WireConnection;585;0;1007;0
WireConnection;982;0;585;0
WireConnection;1971;1;1973;0
WireConnection;1971;0;726;0
WireConnection;2077;0;2078;0
WireConnection;2078;0;1838;0
WireConnection;2082;1;2225;0
WireConnection;2082;0;2085;0
WireConnection;2090;0;1266;0
WireConnection;2089;0;2090;0
WireConnection;2073;0;1575;0
WireConnection;1575;0;1574;1
WireConnection;1575;1;1997;0
WireConnection;2091;0;1574;0
WireConnection;2085;0;2089;0
WireConnection;2085;1;2084;0
WireConnection;2085;2;2086;0
WireConnection;1750;0;2073;0
WireConnection;2087;1;2082;0
WireConnection;2087;0;2092;0
WireConnection;2096;0;2097;0
WireConnection;2097;0;2082;0
WireConnection;2098;1;1742;0
WireConnection;2098;0;2134;0
WireConnection;1742;1;2036;0
WireConnection;1742;0;2041;0
WireConnection;991;0;2098;0
WireConnection;2131;0;1742;0
WireConnection;2123;0;2124;0
WireConnection;2123;1;2132;0
WireConnection;2123;2;2129;0
WireConnection;2124;0;2125;0
WireConnection;2124;1;2132;0
WireConnection;2136;1;2143;0
WireConnection;2136;0;2123;0
WireConnection;2138;1;2136;0
WireConnection;2138;0;2107;0
WireConnection;2143;0;2144;0
WireConnection;2144;0;2132;0
WireConnection;2107;1;2145;0
WireConnection;2107;0;2137;0
WireConnection;2145;0;2146;0
WireConnection;2146;0;2136;0
WireConnection;2152;1;2138;0
WireConnection;2152;0;2106;0
WireConnection;2106;1;2154;0
WireConnection;2106;0;2148;0
WireConnection;2154;0;2155;0
WireConnection;2155;0;2138;0
WireConnection;2172;1;2175;0
WireConnection;2172;0;2171;0
WireConnection;2171;0;2175;0
WireConnection;2164;25;2180;0
WireConnection;2164;26;2166;0
WireConnection;2164;27;2168;0
WireConnection;2164;28;2167;0
WireConnection;2175;1;2178;0
WireConnection;2175;0;2164;0
WireConnection;2178;0;2183;0
WireConnection;2180;0;2152;0
WireConnection;2181;0;2152;0
WireConnection;2182;0;2181;0
WireConnection;2183;0;2182;0
WireConnection;2133;0;2172;0
WireConnection;1266;1;2098;0
WireConnection;1266;0;1268;0
WireConnection;1035;0;978;0
WireConnection;1035;1;965;0
WireConnection;1270;0;978;0
WireConnection;2192;0;1265;0
WireConnection;2192;1;1762;0
WireConnection;2192;3;2184;0
WireConnection;2192;5;614;0
WireConnection;2192;6;583;0
WireConnection;2192;8;1499;0
WireConnection;2192;12;2062;0
WireConnection;2092;0;2096;0
WireConnection;2092;1;2094;0
WireConnection;2092;2;2093;0
WireConnection;2225;0;1266;0
WireConnection;2079;0;2087;0
WireConnection;1014;1;978;0
WireConnection;1014;0;979;0
WireConnection;1014;2;1035;0
WireConnection;2229;0;983;0
WireConnection;2228;0;2229;0
WireConnection;1562;0;983;0
WireConnection;1562;1;1565;40
WireConnection;1997;0;1576;0
WireConnection;1066;0;1067;0
WireConnection;1066;2;1099;0
WireConnection;1066;3;1108;0
WireConnection;1066;4;1539;0
WireConnection;1066;5;1752;0
WireConnection;2060;0;1066;0
WireConnection;1260;1;1264;0
WireConnection;1260;0;1262;0
WireConnection;1243;1;1241;0
WireConnection;1243;0;1196;0
WireConnection;2206;0;1455;0
WireConnection;2208;1;2209;0
WireConnection;2208;0;2199;0
WireConnection;1496;0;1495;0
WireConnection;2199;0;2197;4
WireConnection;2199;2;2201;0
WireConnection;1501;1;1496;3
WireConnection;1501;0;2206;0
WireConnection;2198;0;1501;0
WireConnection;2198;1;2208;0
WireConnection;2198;2;1496;3
WireConnection;2198;3;2230;0
WireConnection;1498;0;2198;0
WireConnection;2233;0;2234;0
WireConnection;2233;1;2235;0
WireConnection;2232;0;2233;0
WireConnection;2230;1;2231;0
WireConnection;2230;0;2232;0
ASEEND*/
//CHKSM=07D9DFB2BEA5E90EA94FC87AD907BE0293572B5E