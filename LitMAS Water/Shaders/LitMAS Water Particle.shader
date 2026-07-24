// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Force reimport: 2
Shader "AtlasShaders/LitMAS Water Particle"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Toggle(_MULTIPLYALBEDO_ON)] _MultiplyAlbedo("Multiply Albedo", Float) = 0
		_AlbedoIntensity("Albedo Intensity", Float) = 0
		[HDR]_Color("Color", Color) = (0.1333333,0.1333333,0.1333333,1)
		_Albedo("Albedo", 2D) = "white" {}
		_SoftIntersectionIntensity("Soft Intersection Intensity", Range( 0 , 2)) = 0.2
		[Header(Normal Input)][NoScaleOffset][Normal]_BumpMap("Normal", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 10)) = 0.8
		_NormalTiling("Normal Tiling", Vector) = (2,2,0,0)
		_WaterSpeedX("Water Speed X", Range( -0.1 , 0.1)) = 0.01
		_WaterSpeedY("Water Speed Y", Range( -0.1 , 0.1)) = 0.01
		[HDR]_DisrtortionColor("Disrtortion Color", Color) = (0.1333333,0.1333333,0.1333333,1)
		[Header(Water Attributes)]_WaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0.75
		_WaterReflectivity("Water Reflectivity", Float) = 0
		[Header(Distortion)][Toggle(_DISTORTION_ON)] _Distortion("Distortion", Float) = 1
		_DistortionIntensity("Distortion Intensity", Range( 0 , 1)) = 0.05
		[Header(Chromatic Abberation)][Toggle(_USECHROMATICABBERATION_ON)] _UseChromaticAbberation("Use Chromatic Abberation", Float) = 0
		_RGBOffset("RGB Offset", Range( 0 , 10)) = 0.5
		[Header(Alpha Masking)]_AlphaMask("Alpha Mask", 2D) = "white" {}
		_Falloff("Falloff", Float) = 1
		[Space(20)][Header(BRDF Lut)][Space(10)][Toggle(_BRDFMAP)] BRDFMAP("Enable BRDF map", Float) = 0
		[ASEEnd][NoScaleOffset][SingleLineTexture]g_tBRDFMap("BRDF map", 2D) = "white" {}
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
		ZWrite Off
		Cull Off
		ZTest LEqual
		Offset 0,0
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
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#pragma multi_compile_instancing
			#define _ENVIRONMENTREFLECTIONS_OFF
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define _SLZ_SPECULAR_SETUP
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
					
					
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _MULTIPLYALBEDO_ON
			#pragma shader_feature_local _DISTORTION_ON
			#pragma shader_feature_local _USECHROMATICABBERATION_ON

					
			struct VertIn
			{
				float4 vertex   : POSITION;
				float3 normal    : NORMAL;
				float4 tangent   : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_color : COLOR;
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
			
				float4 ase_color : COLOR;
				float4 ase_texcoord7 : TEXCOORD7;
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
				float4 _Color;
				float4 _Albedo_ST;
				float4 _DisrtortionColor;
				float4 _AlphaMask_ST;
				float2 _NormalTiling;
				float _AlbedoIntensity;
				float _WaterSpeedX;
				float _NormalIntensity;
				float _WaterSpeedY;
				float _DistortionIntensity;
				float _RGBOffset;
				float _WaterReflectivity;
				float _WaterSmoothness;
				float _Falloff;
				float _SoftIntersectionIntensity;
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
			sampler2D _Albedo;
			sampler2D _BumpMap;
			sampler2D _AlphaMask;
			uniform float4 _CameraDepthTexture_TexelSize;

			
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
			
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord7 = screenPos;
				
				o.ase_color = v.ase_color;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
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
				float2 uv_Albedo = i.uv0XY_bitZ_fog.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 temp_output_643_0 = ( _Color * tex2D( _Albedo, uv_Albedo ) );
				float4 screenPos = i.ase_texcoord7;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 temp_cast_0 = (_WaterSpeedX).xx;
				float2 texCoord401 = i.uv0XY_bitZ_fog.xy * _NormalTiling + float2( 0,0 );
				float2 panner402 = ( 1.0 * _Time.y * temp_cast_0 + texCoord401);
				float3 unpack326 = UnpackNormalScale( tex2D( _BumpMap, panner402 ), _NormalIntensity );
				unpack326.z = lerp( 1, unpack326.z, saturate(_NormalIntensity) );
				float2 temp_cast_1 = (_WaterSpeedY).xx;
				float2 panner403 = ( 1.0 * _Time.y * temp_cast_1 + texCoord401);
				float3 unpack328 = UnpackNormalScale( tex2D( _BumpMap, panner403 ), _NormalIntensity );
				unpack328.z = lerp( 1, unpack328.z, saturate(_NormalIntensity) );
				float3 temp_output_325_0 = BlendNormal( unpack326 , unpack328 );
				float4 fetchOpaqueVal606 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( (ase_grabScreenPosNorm).xyzw + float4( ( temp_output_325_0 * _DistortionIntensity ) , 0.0 ) ).xy ), 1.0 );
				float4 temp_output_579_0 = ( (ase_grabScreenPosNorm).xyzw + float4( ( temp_output_325_0 * _DistortionIntensity ) , 0.0 ) );
				float4 fetchOpaqueVal591 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( temp_output_579_0 - float4( ( _RGBOffset * float2( 0.002,0 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal592 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( temp_output_579_0 - float4( ( _RGBOffset * float2( 0,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal593 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( temp_output_579_0 - float4( ( _RGBOffset * float2( -0.002,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 appendResult594 = (float4(fetchOpaqueVal591.r , fetchOpaqueVal592.g , fetchOpaqueVal593.b , 0.0));
				#ifdef _USECHROMATICABBERATION_ON
				float4 staticSwitch610 = appendResult594;
				#else
				float4 staticSwitch610 = fetchOpaqueVal606;
				#endif
				#ifdef _DISTORTION_ON
				float4 staticSwitch635 = staticSwitch610;
				#else
				float4 staticSwitch635 = _DisrtortionColor;
				#endif
				float4 temp_output_642_0 = ( _DisrtortionColor * staticSwitch635 );
				#ifdef _MULTIPLYALBEDO_ON
				float4 staticSwitch636 = ( temp_output_643_0 * temp_output_642_0 * i.ase_color );
				#else
				float4 staticSwitch636 = ( ( temp_output_643_0 * i.ase_color ) + ( _AlbedoIntensity * temp_output_642_0 ) );
				#endif
				
				float3 temp_cast_14 = (_WaterReflectivity).xxx;
				
				float2 uv_AlphaMask = i.uv0XY_bitZ_fog.xy * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth633 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth633 = saturate( abs( ( screenDepth633 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
				float smoothstepResult629 = smoothstep( 0.0 , _Falloff , ( _DisrtortionColor.a * tex2D( _AlphaMask, uv_AlphaMask ).a * i.ase_color.a * distanceDepth633 ));
				
			
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
			
				half3 albedo3 = staticSwitch636.rgb;
				half3 normalTS = temp_output_325_0;
				half3 emission = half3(0,0,0);
				half3 emissionbaked = half3(0,0,0);
			
			// Begin Injection NORMAL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
				//normalMap = SAMPLE_TEXTURE2D(_BumpMap, sampler_BaseMap, uv_main);
				//normalTS = UnpackNormal(normalMap);
				//normalTS = _Normals ? normalTS : half3(0, 0, 1);
				//geoSmooth = _Normals ? normalMap.b : 1.0;
				//smoothness = saturate(smoothness + geoSmooth - 1.0);
			// End Injection NORMAL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
				half metallic = half(0);
				half3 specular = temp_cast_14;
				half smoothness = _WaterSmoothness;
				half ao = half(1);
				half alpha = saturate( smoothstepResult629 );
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
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#pragma multi_compile_instancing
			#define _ENVIRONMENTREFLECTIONS_OFF
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define _SLZ_SPECULAR_SETUP
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

			#pragma shader_feature_local_fragment _BRDFMAP


			struct appdata
			{
			    float4 vertex : POSITION;
			
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
			    float4 vertex : SV_POSITION;
			
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			    UNITY_VERTEX_OUTPUT_STEREO
			};
			sampler2D _AlphaMask;
			uniform float4 _CameraDepthTexture_TexelSize;
			CBUFFER_START( UnityPerMaterial )
			float4 _Color;
			float4 _Albedo_ST;
			float4 _DisrtortionColor;
			float4 _AlphaMask_ST;
			float2 _NormalTiling;
			float _AlbedoIntensity;
			float _WaterSpeedX;
			float _NormalIntensity;
			float _WaterSpeedY;
			float _DistortionIntensity;
			float _RGBOffset;
			float _WaterReflectivity;
			float _WaterSmoothness;
			float _Falloff;
			float _SoftIntersectionIntensity;
			CBUFFER_END


			
			v2f vert(appdata v )
			{
			    v2f o;
			    UNITY_SETUP_INSTANCE_ID(v);
			    UNITY_TRANSFER_INSTANCE_ID(v, o);
			    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

			    float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
			    float4 screenPos = ComputeScreenPos(ase_clipPos);
			    o.ase_texcoord1 = screenPos;
			    
			    o.ase_texcoord.xy = v.ase_texcoord.xy;
			    o.ase_color = v.ase_color;
			    
			    //setting value to unused interpolator channels and avoid initialization warnings
			    o.ase_texcoord.zw = 0;
			    #ifdef ASE_ABSOLUTE_VERTEX_POS
			        float3 defaultVertexValue = v.vertex.xyz;
			    #else
			        float3 defaultVertexValue = float3(0, 0, 0);
			    #endif
			    float3 vertexValue = defaultVertexValue;
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
			    float2 uv_AlphaMask = i.ase_texcoord.xy * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
			    float4 screenPos = i.ase_texcoord1;
			    float4 ase_screenPosNorm = screenPos / screenPos.w;
			    ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			    float screenDepth633 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
			    float distanceDepth633 = saturate( abs( ( screenDepth633 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
			    float smoothstepResult629 = smoothstep( 0.0 , _Falloff , ( _DisrtortionColor.a * tex2D( _AlphaMask, uv_AlphaMask ).a * i.ase_color.a * distanceDepth633 ));
			    
			
				half alpha = saturate( smoothstepResult629 );
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
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#pragma multi_compile_instancing
			#define _ENVIRONMENTREFLECTIONS_OFF
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define _SLZ_SPECULAR_SETUP
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
					
			#pragma shader_feature_local_fragment _BRDFMAP

					
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			// Begin Injection VERTEX_IN from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				float4 tangent : TANGENT;
				float2 uv0 : TEXCOORD0;
			// End Injection VERTEX_IN from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				float4 ase_color : COLOR;
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
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			// Begin Injection UNIFORMS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				//TEXTURE2D(_BumpMap);
				//SAMPLER(sampler_BumpMap);
			// End Injection UNIFORMS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
			
			CBUFFER_START(UnityPerMaterial)
				float4 _Color;
				float4 _Albedo_ST;
				float4 _DisrtortionColor;
				float4 _AlphaMask_ST;
				float2 _NormalTiling;
				float _AlbedoIntensity;
				float _WaterSpeedX;
				float _NormalIntensity;
				float _WaterSpeedY;
				float _DistortionIntensity;
				float _RGBOffset;
				float _WaterReflectivity;
				float _WaterSmoothness;
				float _Falloff;
				float _SoftIntersectionIntensity;
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
			sampler2D _BumpMap;
			sampler2D _AlphaMask;
			uniform float4 _CameraDepthTexture_TexelSize;

				
						
			v2f vert(appdata v  )
			{
			
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			
			
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_color = v.ase_color;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
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
			   float2 texCoord401 = i.uv0.xy * _NormalTiling + float2( 0,0 );
			   float2 panner402 = ( 1.0 * _Time.y * temp_cast_0 + texCoord401);
			   float3 unpack326 = UnpackNormalScale( tex2D( _BumpMap, panner402 ), _NormalIntensity );
			   unpack326.z = lerp( 1, unpack326.z, saturate(_NormalIntensity) );
			   float2 temp_cast_1 = (_WaterSpeedY).xx;
			   float2 panner403 = ( 1.0 * _Time.y * temp_cast_1 + texCoord401);
			   float3 unpack328 = UnpackNormalScale( tex2D( _BumpMap, panner403 ), _NormalIntensity );
			   unpack328.z = lerp( 1, unpack328.z, saturate(_NormalIntensity) );
			   float3 temp_output_325_0 = BlendNormal( unpack326 , unpack328 );
			   
			   float2 uv_AlphaMask = i.uv0.xy * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
			   float4 screenPos = i.ase_texcoord3;
			   float4 ase_screenPosNorm = screenPos / screenPos.w;
			   ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			   float screenDepth633 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
			   float distanceDepth633 = saturate( abs( ( screenDepth633 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
			   float smoothstepResult629 = smoothstep( 0.0 , _Falloff , ( _DisrtortionColor.a * tex2D( _AlphaMask, uv_AlphaMask ).a * i.ase_color.a * distanceDepth633 ));
			   
			
			
			   half4 normals = half4(0, 0, 0, 1);
			   half3 normalTS = temp_output_325_0;
			
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
				half alpha = saturate( smoothstepResult629 );
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
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#pragma multi_compile_instancing
			#define _ENVIRONMENTREFLECTIONS_OFF
			#define _ISTRANSPARENT
			#define _SurfaceFade
			#define _SLZ_SPECULAR_SETUP
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

			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _MULTIPLYALBEDO_ON
			#pragma shader_feature_local _DISTORTION_ON
			#pragma shader_feature_local _USECHROMATICABBERATION_ON


			//TEXTURE2D(_BaseMap);
			//SAMPLER(sampler_BaseMap);

			// Begin Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------
			//TEXTURE2D(_EmissionMap);
			// End Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------

			CBUFFER_START(UnityPerMaterial)
				float4 _Color;
				float4 _Albedo_ST;
				float4 _DisrtortionColor;
				float4 _AlphaMask_ST;
				float2 _NormalTiling;
				float _AlbedoIntensity;
				float _WaterSpeedX;
				float _NormalIntensity;
				float _WaterSpeedY;
				float _DistortionIntensity;
				float _RGBOffset;
				float _WaterReflectivity;
				float _WaterSmoothness;
				float _Falloff;
				float _SoftIntersectionIntensity;
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
			sampler2D _Albedo;
			sampler2D _BumpMap;
			sampler2D _AlphaMask;
			uniform float4 _CameraDepthTexture_TexelSize;


			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 uv3 : TEXCOORD3;
				float4 ase_color : COLOR;
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
			
			
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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
			

			v2f vert(appdata v  )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_color = v.ase_color;
				float3 vertexValue = float3(0,0,0);
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
				float2 uv_Albedo = i.uv * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 temp_output_643_0 = ( _Color * tex2D( _Albedo, uv_Albedo ) );
				float4 screenPos = i.ase_texcoord3;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 temp_cast_0 = (_WaterSpeedX).xx;
				float2 texCoord401 = i.uv * _NormalTiling + float2( 0,0 );
				float2 panner402 = ( 1.0 * _Time.y * temp_cast_0 + texCoord401);
				float3 unpack326 = UnpackNormalScale( tex2D( _BumpMap, panner402 ), _NormalIntensity );
				unpack326.z = lerp( 1, unpack326.z, saturate(_NormalIntensity) );
				float2 temp_cast_1 = (_WaterSpeedY).xx;
				float2 panner403 = ( 1.0 * _Time.y * temp_cast_1 + texCoord401);
				float3 unpack328 = UnpackNormalScale( tex2D( _BumpMap, panner403 ), _NormalIntensity );
				unpack328.z = lerp( 1, unpack328.z, saturate(_NormalIntensity) );
				float3 temp_output_325_0 = BlendNormal( unpack326 , unpack328 );
				float4 fetchOpaqueVal606 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( (ase_grabScreenPosNorm).xyzw + float4( ( temp_output_325_0 * _DistortionIntensity ) , 0.0 ) ).xy ), 1.0 );
				float4 temp_output_579_0 = ( (ase_grabScreenPosNorm).xyzw + float4( ( temp_output_325_0 * _DistortionIntensity ) , 0.0 ) );
				float4 fetchOpaqueVal591 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( temp_output_579_0 - float4( ( _RGBOffset * float2( 0.002,0 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal592 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( temp_output_579_0 - float4( ( _RGBOffset * float2( 0,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 fetchOpaqueVal593 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( temp_output_579_0 - float4( ( _RGBOffset * float2( -0.002,-0.002 ) ), 0.0 , 0.0 ) ).xy ), 1.0 );
				float4 appendResult594 = (float4(fetchOpaqueVal591.r , fetchOpaqueVal592.g , fetchOpaqueVal593.b , 0.0));
				#ifdef _USECHROMATICABBERATION_ON
				float4 staticSwitch610 = appendResult594;
				#else
				float4 staticSwitch610 = fetchOpaqueVal606;
				#endif
				#ifdef _DISTORTION_ON
				float4 staticSwitch635 = staticSwitch610;
				#else
				float4 staticSwitch635 = _DisrtortionColor;
				#endif
				float4 temp_output_642_0 = ( _DisrtortionColor * staticSwitch635 );
				#ifdef _MULTIPLYALBEDO_ON
				float4 staticSwitch636 = ( temp_output_643_0 * temp_output_642_0 * i.ase_color );
				#else
				float4 staticSwitch636 = ( ( temp_output_643_0 * i.ase_color ) + ( _AlbedoIntensity * temp_output_642_0 ) );
				#endif
				
				float2 uv_AlphaMask = i.uv * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth633 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth633 = saturate( abs( ( screenDepth633 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftIntersectionIntensity ) ) );
				float smoothstepResult629 = smoothstep( 0.0 , _Falloff , ( _DisrtortionColor.a * tex2D( _AlphaMask, uv_AlphaMask ).a * i.ase_color.a * distanceDepth633 ));
				

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
			
				metaInput.Albedo = staticSwitch636.rgb;
				half3 emission = half3(0,0,0);
				half3 bakedemission = emission;
				metaInput.Emission = bakedemission.rgb;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = i.VizUV.xy;
					metaInput.LightCoord = i.LightCoord;
				#endif
			
				half alpha = saturate( smoothstepResult629 );
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
	

	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;174;1838.601,-748.1998;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;13;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthOnly;0;1;DepthOnly;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;175;1838.601,-748.1998;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;13;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthNormals;0;2;DepthNormals;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;176;1838.601,-748.1998;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;13;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;ShadowCaster;0;3;ShadowCaster;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;177;1838.601,-748.1998;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;13;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;Meta;0;4;Meta;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.CommentaryNode;313;-4923.913,-2069.874;Inherit;False;1418.059;651.8691;Blend Normals;11;325;402;403;327;328;415;326;401;419;464;465;Blend Normals;0.007145643,1,0,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;401;-4730.275,-2002.708;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;328;-4061.564,-1765.025;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;1;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;403;-4370.68,-1854.107;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;402;-4372.35,-1988.381;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;325;-3709.443,-1860.127;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;601;-4180.854,-2422.718;Inherit;False;671.6011;320.6005;;5;579;578;577;548;576;Grab Screen Pos;0,0.1718073,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;578;-3876.853,-2278.719;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;579;-3716.854,-2358.719;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;602;-3461.721,-2708.506;Inherit;False;1094.166;627.9772;;14;594;597;553;554;563;600;599;598;560;558;559;591;592;593;Scene Color Split and Append;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;559;-2933.721,-2580.506;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;558;-2933.721,-2484.506;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;560;-2933.721,-2388.506;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;598;-3109.721,-2580.506;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;599;-3109.721,-2484.506;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;600;-3109.721,-2388.506;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;594;-2501.721,-2484.506;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;576;-4144.455,-2377.518;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;577;-3922.053,-2378.918;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;593;-2743.621,-2280.806;Inherit;False;Global;_GrabScreen2;Grab Screen 2;13;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;592;-2743.621,-2447.306;Inherit;False;Global;_GrabScreen1;Grab Screen 1;13;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;591;-2743.621,-2659.407;Inherit;False;Global;_GrabScreen0;Grab Screen 0;13;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;603;-3139.284,-1994.087;Inherit;False;753.0967;378.1498;;5;611;605;607;606;604;Scene Pos/Color No Chromatic;1,1,1,1;0;0
Node;AmplifyShaderEditor.GrabScreenPosition;604;-3078.68,-1945.728;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;606;-2554.19,-1886.786;Float;False;Global;_WaterGrab;WaterGrab;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;607;-2714.69,-1831.986;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;605;-2846.927,-1925.046;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;611;-2855.767,-1748.765;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;465;-4743.603,-1788.669;Inherit;False;Property;_WaterSpeedY;Water Speed Y;9;0;Create;True;0;0;0;False;0;False;0.01;20;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;326;-4070.624,-1987.363;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;327;-4413.507,-1643.854;Float;True;Property;_BumpMap;Normal;5;3;[Header];[NoScaleOffset];[Normal];Create;False;1;Normal Input;0;0;False;0;False;None;fc7df81110c0e4d2498739bf4d47a49d;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;423;-2206.751,-2070.8;Inherit;False;Property;_WaterSmoothness;Water Smoothness;11;1;[Header];Create;True;1;Water Attributes;0;0;False;0;False;0.75;0.192;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;548;-4154.255,-2189.718;Inherit;False;Property;_DistortionIntensity;Distortion Intensity;14;0;Create;True;0;0;0;False;0;False;0.05;0.151;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;464;-4738.603,-1870.669;Inherit;False;Property;_WaterSpeedX;Water Speed X;8;0;Create;True;0;0;0;False;0;False;0.01;20;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;419;-4900.971,-2007.05;Inherit;False;Property;_NormalTiling;Normal Tiling;7;0;Create;True;1;(Non MV ONLY 0.1 Through 1 Recommended);0;0;False;0;False;2,2;0.2,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;415;-4465.933,-1727.554;Inherit;False;Property;_NormalIntensity;Normal Intensity;6;0;Create;True;1;(Non MV ONLY);0;0;False;0;False;0.8;0.6;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;623;-2030.586,-1956.86;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;612;-2367.605,-1964.635;Inherit;True;Property;_AlphaMask;Alpha Mask;17;1;[Header];Create;True;1;Alpha Masking;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;625;-2247.461,-1770.856;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;613;-1524.605,-1790.635;Inherit;False;Property;_AlphaClip;Alpha Clip;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;630;-1986.461,-1828.356;Inherit;False;Property;_Falloff;Falloff;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;597;-3445.721,-2644.506;Inherit;False;Property;_RGBOffset;RGB Offset;16;0;Create;True;1;Chromatic Abberation;0;0;False;0;False;0.5;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;610;-2455.624,-2269.898;Inherit;False;Property;_UseChromaticAbberation;Use Chromatic Abberation;15;0;Create;True;0;0;0;False;1;Header(Chromatic Abberation);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;553;-3317.721,-2564.506;Inherit;False;Constant;_ROffset;R Offset;17;0;Create;True;0;0;0;False;0;False;0.002,0;-1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;554;-3317.721,-2436.506;Inherit;False;Constant;_GOffset;G Offset;18;0;Create;True;0;0;0;False;0;False;0,-0.002;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;563;-3317.721,-2308.506;Inherit;False;Constant;_BOffset;B Offset;19;0;Create;True;0;0;0;False;0;False;-0.002,-0.002;1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;173;-1071.25,-2280.815;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;14;AtlasShaders/LitMAS Water Particle;623634af11bd9ab448550ee777f3493e;True;Forward;0;0;Forward;14;False;True;1;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;1;Lightmode=UniversalForward;True;7;False;0;Hidden/InternalErrorShader;0;0;Standard;24;Workflow;0;639054853084371791;Surface;2;639054820675377010;Two Sided;0;638631752336588731;Cast Shadows;0;638625370991696133;  Use Shadow Threshold;0;0;GPU Instancing;1;638630934546427872;Built-in Fog;1;0;Lightmaps;1;0;Volumetrics;1;0;Decals;0;0;Write Depth;0;638630934308364846;  Early Z (broken);0;0;Vertex Position,InvertActionOnDeselection;1;0;Emission;1;0;PC Reflection Probe;3;0;PC Receive Shadows;0;638712063267761024;PC Vertex Lights;0;0;PC SSAO;1;0;Q Reflection Probe;0;0;Q Receive Shadows;0;0;Q Vertex Lights;1;0;Q SSAO;0;0;Environment Reflections;0;638712065049414746;Meta Pass;1;0;0;5;True;True;True;False;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;626;-1197.236,-2035.146;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;629;-1474.236,-1908.646;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;631;-1330.236,-2193.146;Inherit;False;Property;_WaterReflectivity;Water Reflectivity;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;634;-1673.592,-2366.699;Inherit;False;Property;_SoftIntersectionIntensity;Soft Intersection Intensity;4;0;Create;True;0;0;0;False;1;;False;0.2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;466;-1378.792,-2469.082;Inherit;False;BRDFMap;20;;1;1affaac2d6e57354aaa8d6573a2b32b8;0;1;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;633;-1396.809,-2379.046;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;635;-2139.546,-2414.083;Inherit;False;Property;_Distortion;Distortion;13;0;Create;True;0;0;0;False;1;Header(Distortion);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;621;-2318.261,-2758.681;Inherit;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;229;-2348,-2522;Inherit;False;Property;_DisrtortionColor;Disrtortion Color;10;1;[HDR];Create;True;1;Colors;0;0;False;0;False;0.1333333,0.1333333,0.1333333,1;1.605559,1.605559,1.605559,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;641;-2282.912,-2960.779;Inherit;False;Property;_Color;Color;2;1;[HDR];Create;True;1;Colors;0;0;False;0;False;0.1333333,0.1333333,0.1333333,1;1.605559,1.605559,1.605559,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;643;-2036.912,-2861.779;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;642;-1906.912,-2527.779;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;636;-1193.27,-2960.876;Inherit;False;Property;_MultiplyAlbedo;Multiply Albedo;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;637;-1691.27,-2883.876;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;638;-1358.912,-2989.779;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;-1493,-2599;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-1621.912,-2760.779;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;640;-1852.912,-2753.779;Inherit;False;Property;_AlbedoIntensity;Albedo Intensity;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;401;0;419;0
WireConnection;328;0;327;0
WireConnection;328;1;403;0
WireConnection;328;5;415;0
WireConnection;403;0;401;0
WireConnection;403;2;465;0
WireConnection;402;0;401;0
WireConnection;402;2;464;0
WireConnection;325;0;326;0
WireConnection;325;1;328;0
WireConnection;578;0;325;0
WireConnection;578;1;548;0
WireConnection;579;0;577;0
WireConnection;579;1;578;0
WireConnection;559;0;579;0
WireConnection;559;1;598;0
WireConnection;558;0;579;0
WireConnection;558;1;599;0
WireConnection;560;0;579;0
WireConnection;560;1;600;0
WireConnection;598;0;597;0
WireConnection;598;1;553;0
WireConnection;599;0;597;0
WireConnection;599;1;554;0
WireConnection;600;0;597;0
WireConnection;600;1;563;0
WireConnection;594;0;591;1
WireConnection;594;1;592;2
WireConnection;594;2;593;3
WireConnection;577;0;576;0
WireConnection;593;0;560;0
WireConnection;592;0;558;0
WireConnection;591;0;559;0
WireConnection;606;0;607;0
WireConnection;607;0;605;0
WireConnection;607;1;611;0
WireConnection;605;0;604;0
WireConnection;611;0;325;0
WireConnection;611;1;548;0
WireConnection;326;0;327;0
WireConnection;326;1;402;0
WireConnection;326;5;415;0
WireConnection;623;0;229;4
WireConnection;623;1;612;4
WireConnection;623;2;625;4
WireConnection;623;3;633;0
WireConnection;610;1;606;0
WireConnection;610;0;594;0
WireConnection;173;0;636;0
WireConnection;173;1;325;0
WireConnection;173;5;631;0
WireConnection;173;6;423;0
WireConnection;173;8;626;0
WireConnection;626;0;629;0
WireConnection;629;0;623;0
WireConnection;629;2;630;0
WireConnection;633;0;634;0
WireConnection;635;1;229;0
WireConnection;635;0;610;0
WireConnection;643;0;641;0
WireConnection;643;1;621;0
WireConnection;642;0;229;0
WireConnection;642;1;635;0
WireConnection;636;1;638;0
WireConnection;636;0;231;0
WireConnection;637;0;643;0
WireConnection;637;1;625;0
WireConnection;638;0;637;0
WireConnection;638;1;639;0
WireConnection;231;0;643;0
WireConnection;231;1;642;0
WireConnection;231;2;625;0
WireConnection;639;0;640;0
WireConnection;639;1;642;0
ASEEND*/
//CHKSM=69C091B3BCED3980381E07E0812B7B4605C20690