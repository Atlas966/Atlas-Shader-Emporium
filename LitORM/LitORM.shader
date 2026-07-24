// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Force reimport: 2
Shader "AtlasShaders/LitORM"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Space(20)][Header(BRDF Lut)][Space(10)][Toggle(_BRDFMAP)] BRDFMAP("Enable BRDF map", Float) = 0
		[NoScaleOffset][SingleLineTexture]g_tBRDFMap("BRDF map", 2D) = "white" {}
		[Header(Color)]_BaseMap("Albedo", 2D) = "white" {}
		_BaseColor("Color", Color) = (1,1,1,0)
		[Toggle(_ANTITILE_ON)] _AntiTile("Anti-Tile", Float) = 0
		_Cutoff("Alpha Clipping", Range( 0 , 1)) = 0
		[Header(Normals)]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 5)) = 1
		[Header(ORM Metallic)]_OcclusionRoughnessMap("ORM Map", 2D) = "white" {}
		_Glossiness("Smoothness", Range( 0 , 2)) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_OcclusionStrength("_OcclusionStrength", Range( 0 , 5)) = 1
		[Header(Emission)][NoScaleOffset]_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissionFalloff("Emission Falloff", Range( 0 , 15)) = 0
		_BakedMutiplier("Emission Baked Multiplier", Range( 0 , 15)) = 1
		[ASEEnd][Toggle(_EMITALBEDO_ON)] _EmitAlbedo("Emit Albedo", Float) = 0

		[Space(30)][Header(Screen Space Reflections)][Space(10)][Toggle(_NO_SSR)] _SSROff("Disable SSR", Float) = 0
		[Header(This should be 0 for skinned meshes)]
		_SSRTemporalMul("Temporal Accumulation Factor", Range(0, 2)) = 1.0
		//[Toggle(_SM6_QUAD)] _SM6_Quad("Quad-avg SSR", Float) = 0


	}
	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Blend One Zero
		ZWrite On
		Cull Back
		ZTest LEqual
		Offset 0 , 0
		ColorMask RGBA
		//LOD 100
		

		
		Pass
		{

			

			Name "Forward"
			Tags { "Lightmode"="UniversalForward" }
			
			HLSLPROGRAM
			#define _SurfaceOpaque
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION -1

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
					
					
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ANTITILE_ON
			#pragma shader_feature_local _EMITALBEDO_ON

					
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
				float4 _BaseColor;
				float4 _EmissionColor;
				float _NormalScale;
				float _EmissionFalloff;
				float _BakedMutiplier;
				float _Metallic;
				float _Glossiness;
				float _OcclusionStrength;
				float _Cutoff;
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
			sampler2D _BaseMap;
			sampler2D _BumpMap;
			sampler2D _EmissionMap;
			sampler2D _OcclusionRoughnessMap;

			
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
			
			float4 EmissionCalculation99( float4 EmissionMap, float4 EmissionColor, float4 Albedo, float LuhAcceptor )
			{
				float4 emissionOutput = EmissionMap * EmissionColor;
				#if _EMITALBEDO_ON
				emissionOutput *= Albedo;
				#endif
				return emissionOutput;
			}
			
			float4 EmissionFallingOff103( float4 EmissionInput, float3 ViewDir, float3 WorldNormal, float EmissionFalloff )
			{
				return EmissionInput * saturate(pow(saturate(dot(ViewDir, WorldNormal)), EmissionFalloff * 2));
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
			
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.normal);
				o.ase_texcoord7.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.w = 0;
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
				float4 texCoord16 = float4(i.uv0XY_bitZ_fog.xy,0,0);
				texCoord16.xy = float4(i.uv0XY_bitZ_fog.xy,0,0).xy * float2( 1,1 ) + float2( 0,0 );
				float4 UVs73 = texCoord16;
				float4 tex2DNode54 = tex2D( _BaseMap, UVs73.xy );
				float localStochasticTiling2_g3 = ( 0.0 );
				float2 Input_UV145_g3 = UVs73.xy;
				float2 UV2_g3 = Input_UV145_g3;
				float2 UV12_g3 = float2( 0,0 );
				float2 UV22_g3 = float2( 0,0 );
				float2 UV32_g3 = float2( 0,0 );
				float W12_g3 = 0.0;
				float W22_g3 = 0.0;
				float W32_g3 = 0.0;
				StochasticTiling( UV2_g3 , UV12_g3 , UV22_g3 , UV32_g3 , W12_g3 , W22_g3 , W32_g3 );
				float2 temp_output_10_0_g3 = ddx( Input_UV145_g3 );
				float2 temp_output_12_0_g3 = ddy( Input_UV145_g3 );
				float4 Output_2D293_g3 = ( ( tex2D( _BaseMap, UV12_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W12_g3 ) + ( tex2D( _BaseMap, UV22_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W22_g3 ) + ( tex2D( _BaseMap, UV32_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W32_g3 ) );
				#ifdef _ANTITILE_ON
				float4 staticSwitch53 = ( _BaseColor * Output_2D293_g3 );
				#else
				float4 staticSwitch53 = ( tex2DNode54 * _BaseColor );
				#endif
				float4 Color92 = staticSwitch53;
				
				float3 unpack64 = UnpackNormalScale( tex2D( _BumpMap, UVs73.xy ), _NormalScale );
				unpack64.z = lerp( 1, unpack64.z, saturate(_NormalScale) );
				float localStochasticTiling2_g102 = ( 0.0 );
				float2 Input_UV145_g102 = UVs73.xy;
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
				float4 Output_2D293_g102 = ( ( tex2D( _BumpMap, UV12_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W12_g102 ) + ( tex2D( _BumpMap, UV22_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W22_g102 ) + ( tex2D( _BumpMap, UV32_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W32_g102 ) );
				float4 In02_g101 = Output_2D293_g102;
				float3 localMyCustomExpression2_g101 = MyCustomExpression( In02_g101 );
				float3 break67 = localMyCustomExpression2_g101;
				float4 appendResult70 = (float4(( break67.x * _NormalScale ) , ( break67.y * _NormalScale ) , break67.z , 0.0));
				float4 normalizeResult71 = normalize( appendResult70 );
				#ifdef _ANTITILE_ON
				float4 staticSwitch62 = normalizeResult71;
				#else
				float4 staticSwitch62 = float4( unpack64 , 0.0 );
				#endif
				float4 Normals89 = staticSwitch62;
				
				float4 EmissionMap99 = tex2D( _EmissionMap, UVs73.xy );
				float4 EmissionColor99 = _EmissionColor;
				float4 Albedo99 = Color92;
				#ifdef _EMITALBEDO_ON
				float staticSwitch101 = 0.0;
				#else
				float staticSwitch101 = 0.0;
				#endif
				float LuhAcceptor99 = staticSwitch101;
				float4 localEmissionCalculation99 = EmissionCalculation99( EmissionMap99 , EmissionColor99 , Albedo99 , LuhAcceptor99 );
				float4 EmissionInput103 = localEmissionCalculation99;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - i.wPos.xyz );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ViewDir103 = ase_worldViewDir;
				float3 ase_worldNormal = i.ase_texcoord7.xyz;
				float3 WorldNormal103 = ase_worldNormal;
				float EmissionFalloff103 = _EmissionFalloff;
				float4 localEmissionFallingOff103 = EmissionFallingOff103( EmissionInput103 , ViewDir103 , WorldNormal103 , EmissionFalloff103 );
				float4 Emission110 = localEmissionFallingOff103;
				
				float4 BakedEmission154 = ( localEmissionCalculation99 * _BakedMutiplier );
				
				float localStochasticTiling2_g2 = ( 0.0 );
				float2 Input_UV145_g2 = UVs73.xy;
				float2 UV2_g2 = Input_UV145_g2;
				float2 UV12_g2 = float2( 0,0 );
				float2 UV22_g2 = float2( 0,0 );
				float2 UV32_g2 = float2( 0,0 );
				float W12_g2 = 0.0;
				float W22_g2 = 0.0;
				float W32_g2 = 0.0;
				StochasticTiling( UV2_g2 , UV12_g2 , UV22_g2 , UV32_g2 , W12_g2 , W22_g2 , W32_g2 );
				float2 temp_output_10_0_g2 = ddx( Input_UV145_g2 );
				float2 temp_output_12_0_g2 = ddy( Input_UV145_g2 );
				float4 Output_2D293_g2 = ( ( tex2D( _OcclusionRoughnessMap, UV12_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W12_g2 ) + ( tex2D( _OcclusionRoughnessMap, UV22_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W22_g2 ) + ( tex2D( _OcclusionRoughnessMap, UV32_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W32_g2 ) );
				#ifdef _ANTITILE_ON
				float4 staticSwitch60 = Output_2D293_g2;
				#else
				float4 staticSwitch60 = tex2D( _OcclusionRoughnessMap, UVs73.xy );
				#endif
				float4 break61 = staticSwitch60;
				float Metallic85 = ( _Metallic + break61.b );
				
				float Smoothness82 = ( ( 1.0 - saturate( break61.g ) ) * _Glossiness );
				
				float clampResult37 = clamp( pow( break61.r , _OcclusionStrength ) , 0.0 , 1.0 );
				float AO83 = clampResult37;
				
				float Alpha93 = tex2DNode54.a;
				
			
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
			
				half3 albedo3 = Color92.rgb;
				half3 normalTS = Normals89.xyz;
				half3 emission = Emission110.xyz;
				half3 emissionbaked = BakedEmission154.xyz;
			
			// Begin Injection NORMAL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
				//normalMap = SAMPLE_TEXTURE2D(_BumpMap, sampler_BaseMap, uv_main);
				//normalTS = UnpackNormal(normalMap);
				//normalTS = _Normals ? normalTS : half3(0, 0, 1);
				//geoSmooth = _Normals ? normalMap.b : 1.0;
				//smoothness = saturate(smoothness + geoSmooth - 1.0);
			// End Injection NORMAL_MAP from Injection_NormalMaps.hlsl ----------------------------------------------------------
				half metallic = Metallic85;
				half3 specular = half3(0.5, 0.5, 0.5);
				half smoothness = Smoothness82;
				half ao = AO83;
				half alpha = Alpha93;
				half alphaclip = _Cutoff;
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
			#define _SurfaceOpaque
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION -1

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
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
			    float4 vertex : SV_POSITION;
			
				float4 ase_texcoord : TEXCOORD0;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			    UNITY_VERTEX_OUTPUT_STEREO
			};
			sampler2D _BaseMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _BaseColor;
			float4 _EmissionColor;
			float _NormalScale;
			float _EmissionFalloff;
			float _BakedMutiplier;
			float _Metallic;
			float _Glossiness;
			float _OcclusionStrength;
			float _Cutoff;
			CBUFFER_END


			
			v2f vert(appdata v )
			{
			    v2f o;
			    UNITY_SETUP_INSTANCE_ID(v);
			    UNITY_TRANSFER_INSTANCE_ID(v, o);
			    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

			    o.ase_texcoord = v.ase_texcoord;
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
			    float4 texCoord16 = i.ase_texcoord;
			    texCoord16.xy = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			    float4 UVs73 = texCoord16;
			    float4 tex2DNode54 = tex2D( _BaseMap, UVs73.xy );
			    float Alpha93 = tex2DNode54.a;
			    
			
				half alpha = Alpha93;
				half alphaclip = _Cutoff;
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
			#define _SurfaceOpaque
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION -1

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
			#pragma shader_feature_local _ANTITILE_ON

					
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			// Begin Injection UNIFORMS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
				//TEXTURE2D(_BumpMap);
				//SAMPLER(sampler_BumpMap);
			// End Injection UNIFORMS from Injection_NormalMap_DepthNormals.hlsl ----------------------------------------------------------
			
			CBUFFER_START(UnityPerMaterial)
				float4 _BaseColor;
				float4 _EmissionColor;
				float _NormalScale;
				float _EmissionFalloff;
				float _BakedMutiplier;
				float _Metallic;
				float _Glossiness;
				float _OcclusionStrength;
				float _Cutoff;
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
			sampler2D _BaseMap;

				
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
			
			
			v2f vert(appdata v  )
			{
			
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			
			
				
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
			   float4 texCoord16 = float4(i.uv0.xy,0,0);
			   texCoord16.xy = float4(i.uv0.xy,0,0).xy * float2( 1,1 ) + float2( 0,0 );
			   float4 UVs73 = texCoord16;
			   float3 unpack64 = UnpackNormalScale( tex2D( _BumpMap, UVs73.xy ), _NormalScale );
			   unpack64.z = lerp( 1, unpack64.z, saturate(_NormalScale) );
			   float localStochasticTiling2_g102 = ( 0.0 );
			   float2 Input_UV145_g102 = UVs73.xy;
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
			   float4 Output_2D293_g102 = ( ( tex2D( _BumpMap, UV12_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W12_g102 ) + ( tex2D( _BumpMap, UV22_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W22_g102 ) + ( tex2D( _BumpMap, UV32_g102, temp_output_10_0_g102, temp_output_12_0_g102 ) * W32_g102 ) );
			   float4 In02_g101 = Output_2D293_g102;
			   float3 localMyCustomExpression2_g101 = MyCustomExpression( In02_g101 );
			   float3 break67 = localMyCustomExpression2_g101;
			   float4 appendResult70 = (float4(( break67.x * _NormalScale ) , ( break67.y * _NormalScale ) , break67.z , 0.0));
			   float4 normalizeResult71 = normalize( appendResult70 );
			   #ifdef _ANTITILE_ON
			   float4 staticSwitch62 = normalizeResult71;
			   #else
			   float4 staticSwitch62 = float4( unpack64 , 0.0 );
			   #endif
			   float4 Normals89 = staticSwitch62;
			   
			   float4 tex2DNode54 = tex2D( _BaseMap, UVs73.xy );
			   float Alpha93 = tex2DNode54.a;
			   
			
			
			   half4 normals = half4(0, 0, 0, 1);
			   half3 normalTS = Normals89.xyz;
			
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
				half alpha = Alpha93;
				half alphaclip = _Cutoff;
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
			
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			
			
			
			
			ColorMask 0

			HLSLPROGRAM
			#define _SurfaceOpaque
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION -1

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			//ShadowCaster---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			#define SHADERPASS SHADERPASS_SHADOWCASTER


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZExtentions.hlsl"

			#pragma shader_feature_local_fragment _BRDFMAP

			// Shadow Casting Light geometric parameters. These variables are used when applying the shadow Normal Bias and are set by UnityEngine.Rendering.Universal.ShadowUtils.SetupShadowCasterConstantBuffer in com.unity.render-pipelines.universal/Runtime/ShadowUtils.cs
			// For Directional lights, _LightDirection is used when applying shadow Normal Bias.
			// For Spot lights and Point lights, _LightPosition is used to compute the actual light direction because it is different at each shadow caster geometry vertex.
			float3 _LightDirection;
			float3 _LightPosition;

			struct Attributes
			{
			    float4 positionOS   : POSITION;
			    float3 normalOS     : NORMAL;
			    float4 ase_texcoord : TEXCOORD0;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
			    float4 positionCS   : SV_POSITION;
			    float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			sampler2D _BaseMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _BaseColor;
			float4 _EmissionColor;
			float _NormalScale;
			float _EmissionFalloff;
			float _BakedMutiplier;
			float _Metallic;
			float _Glossiness;
			float _OcclusionStrength;
			float _Cutoff;
			CBUFFER_END


			
			float4 GetShadowPositionHClip(Attributes input)
			{
			    float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
			    float3 normalWS = TransformObjectToWorldNormal(input.normalOS);
			
			#if _CASTING_PUNCTUAL_LIGHT_SHADOW
			    float3 lightDirectionWS = normalize(_LightPosition - positionWS);
			#else
			    float3 lightDirectionWS = _LightDirection;
			#endif
			    float2 vShadowOffsets = GetShadowOffsets(normalWS, lightDirectionWS);
			    //positionWS.xyz -= vShadowOffsets.x * normalWS.xyz * .01;
			    positionWS.xyz -= vShadowOffsets.y * lightDirectionWS.xyz * .01;
			    float4 positionCS = TransformObjectToHClip(float4(mul(unity_WorldToObject, float4(positionWS.xyz, 1.0)).xyz, 1.0));
			    //float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));
			
			#if UNITY_REVERSED_Z
			    positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
			#else
			    positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
			#endif
			
			    return positionCS;
			}

			Varyings vert(Attributes input )
			{
			    Varyings output;
			    UNITY_SETUP_INSTANCE_ID(input);
			    output.ase_texcoord1 = input.ase_texcoord;
			
			    input.normalOS.xyz = input.normalOS.xyz;
			    #ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif
			
			    output.positionCS = GetShadowPositionHClip(input);
			
			    return output;
			}
			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(Varyings input 
			    #ifdef ASE_DEPTH_WRITE_ON
			    , out float outputDepth : ASE_SV_DEPTH
			    #endif
			    ) : SV_TARGET
			{
			    UNITY_SETUP_INSTANCE_ID( input );
			    float4 texCoord16 = input.ase_texcoord1;
			    texCoord16.xy = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
			    float4 UVs73 = texCoord16;
			    float4 tex2DNode54 = tex2D( _BaseMap, UVs73.xy );
			    float Alpha93 = tex2DNode54.a;
			    

				half alpha = Alpha93;
				half alphaclip = _Cutoff;
				half alphaclipthresholdshadow = half(0);
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
				#endif
				#if defined(_ALPHATEST_ON)
					#ifdef _ALPHATEST_SHADOW_ON
						clip(alpha - alphaclipthresholdshadow);
					#else
						clip(alpha - alphaclip);
					#endif
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
			
			Name "Meta"
			Tags { "LightMode"="Meta" }
			
			
			Cull Off

			HLSLPROGRAM
			#define _SurfaceOpaque
			#pragma multi_compile_fog
			#define LITMAS_FEATURE_LIGHTMAPPING
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define LITMAS_FEATURE_EMISSION
			#define PC_REFLECTION_PROBE_BLENDING
			#define PC_REFLECTION_PROBE_BOX_PROJECTION
			#define PC_RECEIVE_SHADOWS
			#define PC_SSAO
			#define MOBILE_LIGHTS_VERTEX
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION -1

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

			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ANTITILE_ON
			#pragma shader_feature_local _EMITALBEDO_ON


			//TEXTURE2D(_BaseMap);
			//SAMPLER(sampler_BaseMap);

			// Begin Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------
			//TEXTURE2D(_EmissionMap);
			// End Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------

			CBUFFER_START(UnityPerMaterial)
				float4 _BaseColor;
				float4 _EmissionColor;
				float _NormalScale;
				float _EmissionFalloff;
				float _BakedMutiplier;
				float _Metallic;
				float _Glossiness;
				float _OcclusionStrength;
				float _Cutoff;
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
			sampler2D _BaseMap;
			sampler2D _EmissionMap;


			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 uv3 : TEXCOORD3;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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
			
			float4 EmissionCalculation99( float4 EmissionMap, float4 EmissionColor, float4 Albedo, float LuhAcceptor )
			{
				float4 emissionOutput = EmissionMap * EmissionColor;
				#if _EMITALBEDO_ON
				emissionOutput *= Albedo;
				#endif
				return emissionOutput;
			}
			
			float4 EmissionFallingOff103( float4 EmissionInput, float3 ViewDir, float3 WorldNormal, float EmissionFalloff )
			{
				return EmissionInput * saturate(pow(saturate(dot(ViewDir, WorldNormal)), EmissionFalloff * 2));
			}
			

			v2f vert(appdata v  )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				o.ase_texcoord3.xyz = ase_worldPos;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
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
				float4 texCoord16 = float4(i.uv,0,0);
				texCoord16.xy = float4(i.uv,0,0).xy * float2( 1,1 ) + float2( 0,0 );
				float4 UVs73 = texCoord16;
				float4 tex2DNode54 = tex2D( _BaseMap, UVs73.xy );
				float localStochasticTiling2_g3 = ( 0.0 );
				float2 Input_UV145_g3 = UVs73.xy;
				float2 UV2_g3 = Input_UV145_g3;
				float2 UV12_g3 = float2( 0,0 );
				float2 UV22_g3 = float2( 0,0 );
				float2 UV32_g3 = float2( 0,0 );
				float W12_g3 = 0.0;
				float W22_g3 = 0.0;
				float W32_g3 = 0.0;
				StochasticTiling( UV2_g3 , UV12_g3 , UV22_g3 , UV32_g3 , W12_g3 , W22_g3 , W32_g3 );
				float2 temp_output_10_0_g3 = ddx( Input_UV145_g3 );
				float2 temp_output_12_0_g3 = ddy( Input_UV145_g3 );
				float4 Output_2D293_g3 = ( ( tex2D( _BaseMap, UV12_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W12_g3 ) + ( tex2D( _BaseMap, UV22_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W22_g3 ) + ( tex2D( _BaseMap, UV32_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W32_g3 ) );
				#ifdef _ANTITILE_ON
				float4 staticSwitch53 = ( _BaseColor * Output_2D293_g3 );
				#else
				float4 staticSwitch53 = ( tex2DNode54 * _BaseColor );
				#endif
				float4 Color92 = staticSwitch53;
				
				float4 EmissionMap99 = tex2D( _EmissionMap, UVs73.xy );
				float4 EmissionColor99 = _EmissionColor;
				float4 Albedo99 = Color92;
				#ifdef _EMITALBEDO_ON
				float staticSwitch101 = 0.0;
				#else
				float staticSwitch101 = 0.0;
				#endif
				float LuhAcceptor99 = staticSwitch101;
				float4 localEmissionCalculation99 = EmissionCalculation99( EmissionMap99 , EmissionColor99 , Albedo99 , LuhAcceptor99 );
				float4 EmissionInput103 = localEmissionCalculation99;
				float3 ase_worldPos = i.ase_texcoord3.xyz;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ViewDir103 = ase_worldViewDir;
				float3 ase_worldNormal = i.ase_texcoord4.xyz;
				float3 WorldNormal103 = ase_worldNormal;
				float EmissionFalloff103 = _EmissionFalloff;
				float4 localEmissionFallingOff103 = EmissionFallingOff103( EmissionInput103 , ViewDir103 , WorldNormal103 , EmissionFalloff103 );
				float4 Emission110 = localEmissionFallingOff103;
				
				float4 BakedEmission154 = ( localEmissionCalculation99 * _BakedMutiplier );
				
				float Alpha93 = tex2DNode54.a;
				

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
			
				metaInput.Albedo = Color92.rgb;
				half3 emission = Emission110.xyz;
				half3 bakedemission = BakedEmission154.xyz;
				metaInput.Emission = bakedemission.rgb;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = i.VizUV.xy;
					metaInput.LightCoord = i.LightCoord;
				#endif
			
				half alpha = Alpha93;
				half alphaclip = _Cutoff;
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
	

	CustomEditor "UnityEditor.ShaderGraphUnlitGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.CommentaryNode;112;-1753.446,1323.063;Inherit;False;1428.302;835.762;;15;99;74;102;104;105;103;17;27;106;101;110;113;152;153;154;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;98;-2199.114,60.39958;Inherit;False;1861.707;513.5607;;13;63;88;64;55;66;67;68;69;70;71;62;65;89;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1605.104,-627.4587;Inherit;False;1261.306;640.3146;;10;54;91;51;50;13;52;12;53;92;93;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;96;-2156.176,-326.5799;Inherit;False;506.8228;260.1711;;2;16;73;UV's;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;79;-2056.169,644.1152;Inherit;False;1750.163;581.0919;;19;114;56;33;35;36;82;83;37;32;25;40;49;85;78;41;61;60;59;58;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthNormals;0;2;DepthNormals;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;Meta;0;4;Meta;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;ShadowCaster;0;3;ShadowCaster;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthOnly;0;1;DepthOnly;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.SamplerNode;58;-1751.608,763.4773;Inherit;True;Property;_TextureSample25;Texture Sample 25;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;59;-1757.226,974.4733;Inherit;False;Procedural Sample;-1;;2;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.StaticSwitch;60;-1434.129,875.7994;Inherit;False;Property;_Keyword0;Keyword 0;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;53;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;61;-1229.794,880.4851;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;78;-1948.238,958.9513;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-896.1302,779.6622;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1043.386,779.9793;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;40;-1083.017,1018.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;-936.0172,1020.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-763.0173,1022.115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;37;-762.0173,900.1154;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-617.1758,898.2147;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-620.1758,1019.214;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;36;-936.0172,898.1154;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-2106.176,-273.4088;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1873.352,-276.5797;Inherit;False;UVs;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;54;-1295.366,-577.459;Inherit;True;Property;_TextureSample24;Texture Sample 24;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1496.04,-377.507;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;50;-1297.816,-377.8021;Inherit;False;Procedural Sample;-1;;3;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-918.767,-369.858;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-910.7799,-470.7631;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-974.4817,-257.9576;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-2048.281,307.9176;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;64;-1826.817,110.3997;Inherit;True;Property;_TextureSample26;Texture Sample 26;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-2149.114,399.7589;Inherit;False;Property;_NormalScale;Normal Scale;8;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;66;-1619.736,365.147;Inherit;False;UnpackNormal;-1;;101;d579cc33c6fa60b4ea9cee9e184b62e3;0;1;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;67;-1406.321,360.293;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1232.433,337.1511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1229.635,438.9602;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-1068.827,375.5078;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;71;-907.1497,430.3151;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;62;-772.8287,126.1658;Inherit;False;Property;_Keyword0;Keyword 0;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;53;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;65;-1821.821,314.1994;Inherit;False;Procedural Sample;-1;;102;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-561.4067,127.6581;Inherit;False;Normals;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;13;-1300.904,-199.1445;Inherit;False;Property;_BaseColor;Color;4;0;Create;False;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1098.517,1117.457;Inherit;False;Property;_Glossiness;Smoothness;10;0;Create;False;0;0;0;False;0;False;1;0.81;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;99;-1143.639,1473.617;Inherit;False;float4 emissionOutput = EmissionMap * EmissionColor@$#if _EMITALBEDO_ON$emissionOutput *= Albedo@$#endif$return emissionOutput@;4;Create;4;True;EmissionMap;FLOAT4;0,0,0,0;In;;Inherit;False;True;EmissionColor;FLOAT4;0,0,0,0;In;;Inherit;False;True;Albedo;FLOAT4;0,0,0,0;In;;Inherit;False;True;LuhAcceptor;FLOAT;0;In;;Inherit;False;Emission Calculation;True;False;0;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-1703.446,1381.064;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-1381.582,1729.05;Inherit;False;92;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;104;-1071.181,1629.412;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;105;-1081.281,1781.612;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;103;-820.1649,1475.252;Inherit;False;return EmissionInput * saturate(pow(saturate(dot(ViewDir, WorldNormal)), EmissionFalloff * 2))@;4;Create;4;True;EmissionInput;FLOAT4;0,0,0,0;In;;Inherit;False;True;ViewDir;FLOAT3;0,0,0;In;;Inherit;False;True;WorldNormal;FLOAT3;0,0,0;In;;Inherit;False;True;EmissionFalloff;FLOAT;0;In;;Inherit;False;Emission Falling Off;True;False;0;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-1166.281,1920.612;Inherit;False;Property;_EmissionFalloff;Emission Falloff;15;0;Create;True;0;0;0;False;0;False;0;1;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;101;-1427.717,1807.728;Inherit;False;Property;_EmitAlbedo;Emit Albedo;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-549.1442,1471.821;Inherit;False;Emission;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StickyNoteNode;113;-686.6581,1685.994;Inherit;False;264;100;Credit;;1,1,1,1;Credit to ShortStak and Evro for emission handling framework$;0;0
Node;AmplifyShaderEditor.StaticSwitch;53;-764.2839,-443.8303;Inherit;False;Property;_AntiTile;Anti-Tile;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-567.7988,-440.1166;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;51;-1555.105,-571.3382;Inherit;True;Property;_BaseMap;Albedo;3;1;[Header];Create;False;1;Color;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;63;-2108.652,111.2987;Inherit;True;Property;_BumpMap;Normal Map;7;1;[Header];Create;False;1;Normals;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;56;-2006.168,761.2069;Inherit;True;Property;_OcclusionRoughnessMap;ORM Map;9;1;[Header];Create;False;1;ORM Metallic;0;0;False;0;False;46279b4b29bae7e4ea63421cb33f3897;46279b4b29bae7e4ea63421cb33f3897;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StickyNoteNode;114;-690.0746,740.3125;Inherit;False;370;100;Credit;;1,1,1,1;To shortstak for ORM Metallic handling setup;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-885.9769,1914.827;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-747.0911,1919.221;Inherit;False;BakedEmission;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-1171.205,1998.616;Inherit;False;Property;_BakedMutiplier;Emission Baked Multiplier;16;0;Create;False;0;0;0;False;0;False;1;1;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1506.003,1355.063;Inherit;True;Property;_EmissionMap;Emission Map;13;2;[Header];[NoScaleOffset];Create;True;1;Emission;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;206.2472,560.3292;Float;False;True;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;14;AtlasShaders/LitORM;623634af11bd9ab448550ee777f3493e;True;Forward;0;0;Forward;14;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;True;True;0;False;_Cull;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;False;False;False;True;1;Lightmode=UniversalForward;True;7;False;0;Hidden/InternalErrorShader;0;0;Standard;24;Workflow;1;0;Surface;0;0;Two Sided;1;638697990467180020;Cast Shadows;1;0;  Use Shadow Threshold;0;0;GPU Instancing;0;0;Built-in Fog;1;0;Lightmaps;1;0;Volumetrics;1;0;Decals;0;0;Write Depth;0;0;  Early Z (broken);0;0;Vertex Position,InvertActionOnDeselection;1;0;Emission;1;0;PC Reflection Probe;3;0;PC Receive Shadows;1;0;PC Vertex Lights;0;0;PC SSAO;1;0;Q Reflection Probe;0;0;Q Receive Shadows;0;0;Q Vertex Lights;1;0;Q SSAO;0;0;Environment Reflections;1;0;Meta Pass;1;0;0;5;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-91.46371,737.0524;Inherit;False;82;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-66.37292,899.0284;Inherit;False;93;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-169.984,978.882;Inherit;False;Property;_Cutoff;Alpha Clipping;6;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-109.3143,579.5114;Inherit;False;154;BakedEmission;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-77.04413,502.5033;Inherit;False;110;Emission;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-76.69754,427.4149;Inherit;False;89;Normals;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-74.37292,351.0284;Inherit;False;92;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;-1417.971,1558.746;Inherit;False;Property;_EmissionColor;Emission Color;14;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;86;-77.46371,661.0525;Inherit;False;85;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1369.646,777.0847;Inherit;False;Property;_Metallic;Metallic;11;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-70.84393,813.795;Inherit;False;83;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1306.017,694.1152;Inherit;False;Property;_OcclusionStrength;_OcclusionStrength;12;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;156;268.1814,482.2;Inherit;False;BRDFMap;0;;103;1affaac2d6e57354aaa8d6573a2b32b8;0;1;3;FLOAT;0;False;1;FLOAT;0
WireConnection;58;0;56;0
WireConnection;58;1;78;0
WireConnection;59;82;56;0
WireConnection;59;5;78;0
WireConnection;60;1;58;0
WireConnection;60;0;59;0
WireConnection;61;0;60;0
WireConnection;85;0;49;0
WireConnection;49;0;41;0
WireConnection;49;1;61;2
WireConnection;40;0;61;1
WireConnection;25;0;40;0
WireConnection;32;0;25;0
WireConnection;32;1;33;0
WireConnection;37;0;36;0
WireConnection;83;0;37;0
WireConnection;82;0;32;0
WireConnection;36;0;61;0
WireConnection;36;1;35;0
WireConnection;73;0;16;0
WireConnection;54;0;51;0
WireConnection;54;1;91;0
WireConnection;50;82;51;0
WireConnection;50;5;91;0
WireConnection;52;0;13;0
WireConnection;52;1;50;0
WireConnection;12;0;54;0
WireConnection;12;1;13;0
WireConnection;93;0;54;4
WireConnection;64;0;63;0
WireConnection;64;1;88;0
WireConnection;64;5;55;0
WireConnection;66;1;65;0
WireConnection;67;0;66;0
WireConnection;68;0;67;0
WireConnection;68;1;55;0
WireConnection;69;0;67;1
WireConnection;69;1;55;0
WireConnection;70;0;68;0
WireConnection;70;1;69;0
WireConnection;70;2;67;2
WireConnection;71;0;70;0
WireConnection;62;1;64;0
WireConnection;62;0;71;0
WireConnection;65;82;63;0
WireConnection;65;5;88;0
WireConnection;89;0;62;0
WireConnection;99;0;17;0
WireConnection;99;1;27;0
WireConnection;99;2;102;0
WireConnection;99;3;101;0
WireConnection;103;0;99;0
WireConnection;103;1;104;0
WireConnection;103;2;105;0
WireConnection;103;3;106;0
WireConnection;110;0;103;0
WireConnection;53;1;12;0
WireConnection;53;0;52;0
WireConnection;92;0;53;0
WireConnection;153;0;99;0
WireConnection;153;1;152;0
WireConnection;154;0;153;0
WireConnection;17;1;74;0
WireConnection;0;0;95;0
WireConnection;0;1;90;0
WireConnection;0;2;81;0
WireConnection;0;3;155;0
WireConnection;0;4;86;0
WireConnection;0;6;87;0
WireConnection;0;7;84;0
WireConnection;0;8;94;0
WireConnection;0;9;48;0
ASEEND*/
//CHKSM=A7D3618C1259EFF2A38A125B4C2DDED8A87DB6E6