// Made with Amplify Shader Editor v1.9.9.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Force reimport: 2
Shader "AtlasShaders/LitORM ColorTint"
{
	Properties
	{
		[Header(Color)] _BaseMap( "Albedo", 2D ) = "white" {}
		_BaseColor( "Color", Color ) = ( 1, 1, 1, 0 )
		[Toggle( _ANTITILE_ON )] _AntiTile( "Anti-Tile", Float ) = 0
		_Cutoff( "Alpha Clipping", Range( 0, 1 ) ) = 0
		[Header(Normals)] _BumpMap( "Normal Map", 2D ) = "bump" {}
		_NormalScale( "Normal Scale", Range( 0, 5 ) ) = 1
		[Header(ORM Metallic)] _OcclusionRoughnessMap( "ORM Map", 2D ) = "white" {}
		_Glossiness( "Smoothness", Range( 0, 2 ) ) = 1
		_Metallic( "Metallic", Range( 0, 1 ) ) = 0
		_OcclusionStrength( "_OcclusionStrength", Range( 0, 5 ) ) = 0
		[Header(Emission)][NoScaleOffset] _EmissionMap( "Emission Map", 2D ) = "white" {}
		[HDR] _EmissionColor( "Emission Color", Color ) = ( 0, 0, 0, 0 )
		_EmissionFalloff( "Emission Falloff", Range( 0, 15 ) ) = 0
		[Toggle( _EMITALBEDO_ON )] _EmitAlbedo( "Emit Albedo", Float ) = 0
		[Header(Color Tint)][NoScaleOffset] _ColorMask( "Color Tint", 2D ) = "white" {}
		_ColorShift1( "_ColorShift1", Color ) = ( 1, 1, 1, 1 )
		_ColorShift2( "_ColorShift2", Color ) = ( 1, 1, 1, 1 )
		_ColorShift3( "_ColorShift3", Color ) = ( 1, 1, 1, 1 )
		[Space(20)][Header(BRDF Lut)][Space(10)][Toggle( _BRDFMAP )] BRDFMAP( "Enable BRDF map", Float ) = 0
		[NoScaleOffset][SingleLineTexture] g_tBRDFMap( "BRDF map", 2D ) = "white" {}
		[HideInInspector] _Cull( "_Cull", Int ) = 2
		_ColorShift4( "_ColorShift4", Color ) = ( 1, 1, 1, 1 )

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
			#define ASE_VERSION 19908
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
					
					
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
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
				float4 _ColorShift1;
				float4 _ColorShift2;
				float4 _ColorShift3;
				float4 _ColorShift4;
				float4 _BaseColor;
				float4 _EmissionColor;
				int _Cull;
				float _NormalScale;
				float _EmissionFalloff;
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
			sampler2D _ColorMask;
			sampler2D _BaseMap;
			sampler2D _BumpMap;
			sampler2D _EmissionMap;
			sampler2D _OcclusionRoughnessMap;

			
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
			
				float3 ase_normalWS = TransformObjectToWorldNormal( v.normal );
				o.ase_texcoord7.xyz = ase_normalWS;
				
				
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
				float2 texCoord124 = i.uv0XY_bitZ_fog.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode119 = tex2D( _ColorMask, texCoord124 );
				float4 lerpResult118 = lerp( float4( 1,1,1,1 ) , _ColorShift1 , tex2DNode119.r);
				float4 lerpResult120 = lerp( float4( 1,1,1,1 ) , _ColorShift2 , tex2DNode119.g);
				float4 lerpResult121 = lerp( float4( 1,1,1,1 ) , _ColorShift3 , tex2DNode119.b);
				float4 lerpResult122 = lerp( float4( 1,1,1,1 ) , _ColorShift4 , tex2DNode119.a);
				float4 ColorTint130 = ( lerpResult118 * lerpResult120 * lerpResult121 * lerpResult122 );
				float4 texCoord16 = float4(i.uv0XY_bitZ_fog.xy,0,0);
				texCoord16.xy = float4(i.uv0XY_bitZ_fog.xy,0,0).xy * float2( 1,1 ) + float2( 0,0 );
				float4 UVs73 = texCoord16;
				float4 tex2DNode54 = tex2D( _BaseMap, UVs73.xy );
				float2 Input_UV145_g362 = UVs73.xy;
				float2 UV100_g363 = Input_UV145_g362;
				float2 temp_output_51_0_g363 = mul( float2x2( 1, 0, -0.5773503, 1.154701 ), ( UV100_g363 * float2( 3.464,3.464 ) ) );
				float2 break55_g363 = frac( temp_output_51_0_g363 );
				float temp_output_56_0_g363 = ( ( 1.0 - break55_g363.x ) - break55_g363.y );
				float2 temp_output_52_0_g363 = floor( temp_output_51_0_g363 );
				float2 temp_output_125_0_g363 = ( temp_output_52_0_g363 + float2( 1,1 ) );
				float2 ifLocalVar87_g363 = 0;
				if( temp_output_56_0_g363 > 0.0 )
				ifLocalVar87_g363 = temp_output_52_0_g363;
				else if( temp_output_56_0_g363 == 0.0 )
				ifLocalVar87_g363 = temp_output_125_0_g363;
				else if( temp_output_56_0_g363 < 0.0 )
				ifLocalVar87_g363 = temp_output_125_0_g363;
				float3 temp_output_7_0_g364 = frac( ( (ifLocalVar87_g363).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g364 = dot( temp_output_7_0_g364 , ( (temp_output_7_0_g364).yzx + 33.33 ) );
				float3 temp_output_12_0_g364 = ( temp_output_7_0_g364 + dotResult8_g364 );
				float2 temp_output_10_0_g362 = ddx( Input_UV145_g362 );
				float2 temp_output_12_0_g362 = ddy( Input_UV145_g362 );
				float temp_output_65_0_g363 = ( 0.0 - temp_output_56_0_g363 );
				float ifLocalVar59_g363 = 0;
				if( temp_output_56_0_g363 <= 0.0 )
				ifLocalVar59_g363 = temp_output_65_0_g363;
				else
				ifLocalVar59_g363 = temp_output_56_0_g363;
				float2 temp_output_90_0_g363 = ( temp_output_52_0_g363 + float2( 0,1 ) );
				float2 temp_output_123_0_g363 = ( temp_output_52_0_g363 + float2( 1,0 ) );
				float2 ifLocalVar88_g363 = 0;
				if( temp_output_56_0_g363 > 0.0 )
				ifLocalVar88_g363 = temp_output_90_0_g363;
				else if( temp_output_56_0_g363 == 0.0 )
				ifLocalVar88_g363 = temp_output_123_0_g363;
				else if( temp_output_56_0_g363 < 0.0 )
				ifLocalVar88_g363 = temp_output_123_0_g363;
				float3 temp_output_7_0_g365 = frac( ( (ifLocalVar88_g363).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g365 = dot( temp_output_7_0_g365 , ( (temp_output_7_0_g365).yzx + 33.33 ) );
				float3 temp_output_12_0_g365 = ( temp_output_7_0_g365 + dotResult8_g365 );
				float temp_output_66_0_g363 = ( 1.0 - break55_g363.y );
				float ifLocalVar60_g363 = 0;
				if( temp_output_56_0_g363 <= 0.0 )
				ifLocalVar60_g363 = temp_output_66_0_g363;
				else
				ifLocalVar60_g363 = break55_g363.y;
				float2 ifLocalVar89_g363 = 0;
				if( temp_output_56_0_g363 > 0.0 )
				ifLocalVar89_g363 = temp_output_123_0_g363;
				else if( temp_output_56_0_g363 == 0.0 )
				ifLocalVar89_g363 = temp_output_90_0_g363;
				else if( temp_output_56_0_g363 < 0.0 )
				ifLocalVar89_g363 = temp_output_90_0_g363;
				float3 temp_output_7_0_g366 = frac( ( (ifLocalVar89_g363).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g366 = dot( temp_output_7_0_g366 , ( (temp_output_7_0_g366).yzx + 33.33 ) );
				float3 temp_output_12_0_g366 = ( temp_output_7_0_g366 + dotResult8_g366 );
				float temp_output_67_0_g363 = ( 1.0 - break55_g363.x );
				float ifLocalVar61_g363 = 0;
				if( temp_output_56_0_g363 <= 0.0 )
				ifLocalVar61_g363 = temp_output_67_0_g363;
				else
				ifLocalVar61_g363 = break55_g363.x;
				float4 Output_2D293_g362 = ( ( tex2D( _BaseMap, ( UV100_g363 + frac( ( ( (temp_output_12_0_g364).xx + (temp_output_12_0_g364).yz ) * (temp_output_12_0_g364).zy ) ) ), temp_output_10_0_g362, temp_output_12_0_g362 ) * ifLocalVar59_g363 ) + ( tex2D( _BaseMap, ( UV100_g363 + frac( ( ( (temp_output_12_0_g365).xx + (temp_output_12_0_g365).yz ) * (temp_output_12_0_g365).zy ) ) ), temp_output_10_0_g362, temp_output_12_0_g362 ) * ifLocalVar60_g363 ) + ( tex2D( _BaseMap, ( UV100_g363 + frac( ( ( (temp_output_12_0_g366).xx + (temp_output_12_0_g366).yz ) * (temp_output_12_0_g366).zy ) ) ), temp_output_10_0_g362, temp_output_12_0_g362 ) * ifLocalVar61_g363 ) );
				#ifdef _ANTITILE_ON
				float4 staticSwitch53 = ( ColorTint130 * ( _BaseColor * Output_2D293_g362 ) );
				#else
				float4 staticSwitch53 = ( ColorTint130 * ( tex2DNode54 * _BaseColor ) );
				#endif
				float4 Color92 = staticSwitch53;
				
				float3 unpack64 = UnpackNormalScale( tex2D( _BumpMap, UVs73.xy ), _NormalScale );
				unpack64.z = lerp( 1, unpack64.z, saturate(_NormalScale) );
				float2 Input_UV145_g328 = UVs73.xy;
				float2 UV100_g329 = Input_UV145_g328;
				float2 temp_output_51_0_g329 = mul( float2x2( 1, 0, -0.5773503, 1.154701 ), ( UV100_g329 * float2( 3.464,3.464 ) ) );
				float2 break55_g329 = frac( temp_output_51_0_g329 );
				float temp_output_56_0_g329 = ( ( 1.0 - break55_g329.x ) - break55_g329.y );
				float2 temp_output_52_0_g329 = floor( temp_output_51_0_g329 );
				float2 temp_output_125_0_g329 = ( temp_output_52_0_g329 + float2( 1,1 ) );
				float2 ifLocalVar87_g329 = 0;
				if( temp_output_56_0_g329 > 0.0 )
				ifLocalVar87_g329 = temp_output_52_0_g329;
				else if( temp_output_56_0_g329 == 0.0 )
				ifLocalVar87_g329 = temp_output_125_0_g329;
				else if( temp_output_56_0_g329 < 0.0 )
				ifLocalVar87_g329 = temp_output_125_0_g329;
				float3 temp_output_7_0_g330 = frac( ( (ifLocalVar87_g329).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g330 = dot( temp_output_7_0_g330 , ( (temp_output_7_0_g330).yzx + 33.33 ) );
				float3 temp_output_12_0_g330 = ( temp_output_7_0_g330 + dotResult8_g330 );
				float2 temp_output_10_0_g328 = ddx( Input_UV145_g328 );
				float2 temp_output_12_0_g328 = ddy( Input_UV145_g328 );
				float temp_output_65_0_g329 = ( 0.0 - temp_output_56_0_g329 );
				float ifLocalVar59_g329 = 0;
				if( temp_output_56_0_g329 <= 0.0 )
				ifLocalVar59_g329 = temp_output_65_0_g329;
				else
				ifLocalVar59_g329 = temp_output_56_0_g329;
				float2 temp_output_90_0_g329 = ( temp_output_52_0_g329 + float2( 0,1 ) );
				float2 temp_output_123_0_g329 = ( temp_output_52_0_g329 + float2( 1,0 ) );
				float2 ifLocalVar88_g329 = 0;
				if( temp_output_56_0_g329 > 0.0 )
				ifLocalVar88_g329 = temp_output_90_0_g329;
				else if( temp_output_56_0_g329 == 0.0 )
				ifLocalVar88_g329 = temp_output_123_0_g329;
				else if( temp_output_56_0_g329 < 0.0 )
				ifLocalVar88_g329 = temp_output_123_0_g329;
				float3 temp_output_7_0_g331 = frac( ( (ifLocalVar88_g329).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g331 = dot( temp_output_7_0_g331 , ( (temp_output_7_0_g331).yzx + 33.33 ) );
				float3 temp_output_12_0_g331 = ( temp_output_7_0_g331 + dotResult8_g331 );
				float temp_output_66_0_g329 = ( 1.0 - break55_g329.y );
				float ifLocalVar60_g329 = 0;
				if( temp_output_56_0_g329 <= 0.0 )
				ifLocalVar60_g329 = temp_output_66_0_g329;
				else
				ifLocalVar60_g329 = break55_g329.y;
				float2 ifLocalVar89_g329 = 0;
				if( temp_output_56_0_g329 > 0.0 )
				ifLocalVar89_g329 = temp_output_123_0_g329;
				else if( temp_output_56_0_g329 == 0.0 )
				ifLocalVar89_g329 = temp_output_90_0_g329;
				else if( temp_output_56_0_g329 < 0.0 )
				ifLocalVar89_g329 = temp_output_90_0_g329;
				float3 temp_output_7_0_g332 = frac( ( (ifLocalVar89_g329).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g332 = dot( temp_output_7_0_g332 , ( (temp_output_7_0_g332).yzx + 33.33 ) );
				float3 temp_output_12_0_g332 = ( temp_output_7_0_g332 + dotResult8_g332 );
				float temp_output_67_0_g329 = ( 1.0 - break55_g329.x );
				float ifLocalVar61_g329 = 0;
				if( temp_output_56_0_g329 <= 0.0 )
				ifLocalVar61_g329 = temp_output_67_0_g329;
				else
				ifLocalVar61_g329 = break55_g329.x;
				float4 Output_2D293_g328 = ( ( tex2D( _BumpMap, ( UV100_g329 + frac( ( ( (temp_output_12_0_g330).xx + (temp_output_12_0_g330).yz ) * (temp_output_12_0_g330).zy ) ) ), temp_output_10_0_g328, temp_output_12_0_g328 ) * ifLocalVar59_g329 ) + ( tex2D( _BumpMap, ( UV100_g329 + frac( ( ( (temp_output_12_0_g331).xx + (temp_output_12_0_g331).yz ) * (temp_output_12_0_g331).zy ) ) ), temp_output_10_0_g328, temp_output_12_0_g328 ) * ifLocalVar60_g329 ) + ( tex2D( _BumpMap, ( UV100_g329 + frac( ( ( (temp_output_12_0_g332).xx + (temp_output_12_0_g332).yz ) * (temp_output_12_0_g332).zy ) ) ), temp_output_10_0_g328, temp_output_12_0_g328 ) * ifLocalVar61_g329 ) );
				float4 In02_g327 = Output_2D293_g328;
				float3 localMyCustomExpression2_g327 = MyCustomExpression( In02_g327 );
				float3 break67 = localMyCustomExpression2_g327;
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
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - i.wPos.xyz : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ViewDir103 = ase_viewDirWS;
				float3 ase_normalWS = i.ase_texcoord7.xyz;
				float3 WorldNormal103 = ase_normalWS;
				float EmissionFalloff103 = _EmissionFalloff;
				float4 localEmissionFallingOff103 = EmissionFallingOff103( EmissionInput103 , ViewDir103 , WorldNormal103 , EmissionFalloff103 );
				float4 Emission110 = localEmissionFallingOff103;
				
				float2 Input_UV145_g2 = UVs73.xy;
				float2 UV100_g292 = Input_UV145_g2;
				float2 temp_output_51_0_g292 = mul( float2x2( 1, 0, -0.5773503, 1.154701 ), ( UV100_g292 * float2( 3.464,3.464 ) ) );
				float2 break55_g292 = frac( temp_output_51_0_g292 );
				float temp_output_56_0_g292 = ( ( 1.0 - break55_g292.x ) - break55_g292.y );
				float2 temp_output_52_0_g292 = floor( temp_output_51_0_g292 );
				float2 temp_output_125_0_g292 = ( temp_output_52_0_g292 + float2( 1,1 ) );
				float2 ifLocalVar87_g292 = 0;
				if( temp_output_56_0_g292 > 0.0 )
				ifLocalVar87_g292 = temp_output_52_0_g292;
				else if( temp_output_56_0_g292 == 0.0 )
				ifLocalVar87_g292 = temp_output_125_0_g292;
				else if( temp_output_56_0_g292 < 0.0 )
				ifLocalVar87_g292 = temp_output_125_0_g292;
				float3 temp_output_7_0_g293 = frac( ( (ifLocalVar87_g292).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g293 = dot( temp_output_7_0_g293 , ( (temp_output_7_0_g293).yzx + 33.33 ) );
				float3 temp_output_12_0_g293 = ( temp_output_7_0_g293 + dotResult8_g293 );
				float2 temp_output_10_0_g2 = ddx( Input_UV145_g2 );
				float2 temp_output_12_0_g2 = ddy( Input_UV145_g2 );
				float temp_output_65_0_g292 = ( 0.0 - temp_output_56_0_g292 );
				float ifLocalVar59_g292 = 0;
				if( temp_output_56_0_g292 <= 0.0 )
				ifLocalVar59_g292 = temp_output_65_0_g292;
				else
				ifLocalVar59_g292 = temp_output_56_0_g292;
				float2 temp_output_90_0_g292 = ( temp_output_52_0_g292 + float2( 0,1 ) );
				float2 temp_output_123_0_g292 = ( temp_output_52_0_g292 + float2( 1,0 ) );
				float2 ifLocalVar88_g292 = 0;
				if( temp_output_56_0_g292 > 0.0 )
				ifLocalVar88_g292 = temp_output_90_0_g292;
				else if( temp_output_56_0_g292 == 0.0 )
				ifLocalVar88_g292 = temp_output_123_0_g292;
				else if( temp_output_56_0_g292 < 0.0 )
				ifLocalVar88_g292 = temp_output_123_0_g292;
				float3 temp_output_7_0_g294 = frac( ( (ifLocalVar88_g292).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g294 = dot( temp_output_7_0_g294 , ( (temp_output_7_0_g294).yzx + 33.33 ) );
				float3 temp_output_12_0_g294 = ( temp_output_7_0_g294 + dotResult8_g294 );
				float temp_output_66_0_g292 = ( 1.0 - break55_g292.y );
				float ifLocalVar60_g292 = 0;
				if( temp_output_56_0_g292 <= 0.0 )
				ifLocalVar60_g292 = temp_output_66_0_g292;
				else
				ifLocalVar60_g292 = break55_g292.y;
				float2 ifLocalVar89_g292 = 0;
				if( temp_output_56_0_g292 > 0.0 )
				ifLocalVar89_g292 = temp_output_123_0_g292;
				else if( temp_output_56_0_g292 == 0.0 )
				ifLocalVar89_g292 = temp_output_90_0_g292;
				else if( temp_output_56_0_g292 < 0.0 )
				ifLocalVar89_g292 = temp_output_90_0_g292;
				float3 temp_output_7_0_g295 = frac( ( (ifLocalVar89_g292).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g295 = dot( temp_output_7_0_g295 , ( (temp_output_7_0_g295).yzx + 33.33 ) );
				float3 temp_output_12_0_g295 = ( temp_output_7_0_g295 + dotResult8_g295 );
				float temp_output_67_0_g292 = ( 1.0 - break55_g292.x );
				float ifLocalVar61_g292 = 0;
				if( temp_output_56_0_g292 <= 0.0 )
				ifLocalVar61_g292 = temp_output_67_0_g292;
				else
				ifLocalVar61_g292 = break55_g292.x;
				float4 Output_2D293_g2 = ( ( tex2D( _OcclusionRoughnessMap, ( UV100_g292 + frac( ( ( (temp_output_12_0_g293).xx + (temp_output_12_0_g293).yz ) * (temp_output_12_0_g293).zy ) ) ), temp_output_10_0_g2, temp_output_12_0_g2 ) * ifLocalVar59_g292 ) + ( tex2D( _OcclusionRoughnessMap, ( UV100_g292 + frac( ( ( (temp_output_12_0_g294).xx + (temp_output_12_0_g294).yz ) * (temp_output_12_0_g294).zy ) ) ), temp_output_10_0_g2, temp_output_12_0_g2 ) * ifLocalVar60_g292 ) + ( tex2D( _OcclusionRoughnessMap, ( UV100_g292 + frac( ( ( (temp_output_12_0_g295).xx + (temp_output_12_0_g295).yz ) * (temp_output_12_0_g295).zy ) ) ), temp_output_10_0_g2, temp_output_12_0_g2 ) * ifLocalVar61_g292 ) );
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
				half3 emissionbaked = half3(0,0,0);
			
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
			#define ASE_VERSION 19908
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

			#define ASE_NEEDS_TEXTURE_COORDINATES0
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
			float4 _ColorShift1;
			float4 _ColorShift2;
			float4 _ColorShift3;
			float4 _ColorShift4;
			float4 _BaseColor;
			float4 _EmissionColor;
			int _Cull;
			float _NormalScale;
			float _EmissionFalloff;
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
			#define ASE_VERSION 19908
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
					
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
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
				float4 _ColorShift1;
				float4 _ColorShift2;
				float4 _ColorShift3;
				float4 _ColorShift4;
				float4 _BaseColor;
				float4 _EmissionColor;
				int _Cull;
				float _NormalScale;
				float _EmissionFalloff;
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
			   float2 Input_UV145_g328 = UVs73.xy;
			   float2 UV100_g329 = Input_UV145_g328;
			   float2 temp_output_51_0_g329 = mul( float2x2( 1, 0, -0.5773503, 1.154701 ), ( UV100_g329 * float2( 3.464,3.464 ) ) );
			   float2 break55_g329 = frac( temp_output_51_0_g329 );
			   float temp_output_56_0_g329 = ( ( 1.0 - break55_g329.x ) - break55_g329.y );
			   float2 temp_output_52_0_g329 = floor( temp_output_51_0_g329 );
			   float2 temp_output_125_0_g329 = ( temp_output_52_0_g329 + float2( 1,1 ) );
			   float2 ifLocalVar87_g329 = 0;
			   if( temp_output_56_0_g329 > 0.0 )
			   ifLocalVar87_g329 = temp_output_52_0_g329;
			   else if( temp_output_56_0_g329 == 0.0 )
			   ifLocalVar87_g329 = temp_output_125_0_g329;
			   else if( temp_output_56_0_g329 < 0.0 )
			   ifLocalVar87_g329 = temp_output_125_0_g329;
			   float3 temp_output_7_0_g330 = frac( ( (ifLocalVar87_g329).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
			   float dotResult8_g330 = dot( temp_output_7_0_g330 , ( (temp_output_7_0_g330).yzx + 33.33 ) );
			   float3 temp_output_12_0_g330 = ( temp_output_7_0_g330 + dotResult8_g330 );
			   float2 temp_output_10_0_g328 = ddx( Input_UV145_g328 );
			   float2 temp_output_12_0_g328 = ddy( Input_UV145_g328 );
			   float temp_output_65_0_g329 = ( 0.0 - temp_output_56_0_g329 );
			   float ifLocalVar59_g329 = 0;
			   if( temp_output_56_0_g329 <= 0.0 )
			   ifLocalVar59_g329 = temp_output_65_0_g329;
			   else
			   ifLocalVar59_g329 = temp_output_56_0_g329;
			   float2 temp_output_90_0_g329 = ( temp_output_52_0_g329 + float2( 0,1 ) );
			   float2 temp_output_123_0_g329 = ( temp_output_52_0_g329 + float2( 1,0 ) );
			   float2 ifLocalVar88_g329 = 0;
			   if( temp_output_56_0_g329 > 0.0 )
			   ifLocalVar88_g329 = temp_output_90_0_g329;
			   else if( temp_output_56_0_g329 == 0.0 )
			   ifLocalVar88_g329 = temp_output_123_0_g329;
			   else if( temp_output_56_0_g329 < 0.0 )
			   ifLocalVar88_g329 = temp_output_123_0_g329;
			   float3 temp_output_7_0_g331 = frac( ( (ifLocalVar88_g329).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
			   float dotResult8_g331 = dot( temp_output_7_0_g331 , ( (temp_output_7_0_g331).yzx + 33.33 ) );
			   float3 temp_output_12_0_g331 = ( temp_output_7_0_g331 + dotResult8_g331 );
			   float temp_output_66_0_g329 = ( 1.0 - break55_g329.y );
			   float ifLocalVar60_g329 = 0;
			   if( temp_output_56_0_g329 <= 0.0 )
			   ifLocalVar60_g329 = temp_output_66_0_g329;
			   else
			   ifLocalVar60_g329 = break55_g329.y;
			   float2 ifLocalVar89_g329 = 0;
			   if( temp_output_56_0_g329 > 0.0 )
			   ifLocalVar89_g329 = temp_output_123_0_g329;
			   else if( temp_output_56_0_g329 == 0.0 )
			   ifLocalVar89_g329 = temp_output_90_0_g329;
			   else if( temp_output_56_0_g329 < 0.0 )
			   ifLocalVar89_g329 = temp_output_90_0_g329;
			   float3 temp_output_7_0_g332 = frac( ( (ifLocalVar89_g329).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
			   float dotResult8_g332 = dot( temp_output_7_0_g332 , ( (temp_output_7_0_g332).yzx + 33.33 ) );
			   float3 temp_output_12_0_g332 = ( temp_output_7_0_g332 + dotResult8_g332 );
			   float temp_output_67_0_g329 = ( 1.0 - break55_g329.x );
			   float ifLocalVar61_g329 = 0;
			   if( temp_output_56_0_g329 <= 0.0 )
			   ifLocalVar61_g329 = temp_output_67_0_g329;
			   else
			   ifLocalVar61_g329 = break55_g329.x;
			   float4 Output_2D293_g328 = ( ( tex2D( _BumpMap, ( UV100_g329 + frac( ( ( (temp_output_12_0_g330).xx + (temp_output_12_0_g330).yz ) * (temp_output_12_0_g330).zy ) ) ), temp_output_10_0_g328, temp_output_12_0_g328 ) * ifLocalVar59_g329 ) + ( tex2D( _BumpMap, ( UV100_g329 + frac( ( ( (temp_output_12_0_g331).xx + (temp_output_12_0_g331).yz ) * (temp_output_12_0_g331).zy ) ) ), temp_output_10_0_g328, temp_output_12_0_g328 ) * ifLocalVar60_g329 ) + ( tex2D( _BumpMap, ( UV100_g329 + frac( ( ( (temp_output_12_0_g332).xx + (temp_output_12_0_g332).yz ) * (temp_output_12_0_g332).zy ) ) ), temp_output_10_0_g328, temp_output_12_0_g328 ) * ifLocalVar61_g329 ) );
			   float4 In02_g327 = Output_2D293_g328;
			   float3 localMyCustomExpression2_g327 = MyCustomExpression( In02_g327 );
			   float3 break67 = localMyCustomExpression2_g327;
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
			#define ASE_VERSION 19908
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

			#define ASE_NEEDS_TEXTURE_COORDINATES0
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
			float4 _ColorShift1;
			float4 _ColorShift2;
			float4 _ColorShift3;
			float4 _ColorShift4;
			float4 _BaseColor;
			float4 _EmissionColor;
			int _Cull;
			float _NormalScale;
			float _EmissionFalloff;
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
			#define ASE_VERSION 19908
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

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ANTITILE_ON
			#pragma shader_feature_local _EMITALBEDO_ON


			//TEXTURE2D(_BaseMap);
			//SAMPLER(sampler_BaseMap);

			// Begin Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------
			//TEXTURE2D(_EmissionMap);
			// End Injection UNIFORMS from Injection_Emission_Meta.hlsl ----------------------------------------------------------

			CBUFFER_START(UnityPerMaterial)
				float4 _ColorShift1;
				float4 _ColorShift2;
				float4 _ColorShift3;
				float4 _ColorShift4;
				float4 _BaseColor;
				float4 _EmissionColor;
				int _Cull;
				float _NormalScale;
				float _EmissionFalloff;
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
			sampler2D _ColorMask;
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
				float3 ase_positionWS = TransformObjectToWorld( ( v.vertex ).xyz );
				o.ase_texcoord3.xyz = ase_positionWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( v.ase_normal );
				o.ase_texcoord4.xyz = ase_normalWS;
				
				
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
				float2 texCoord124 = i.uv * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode119 = tex2D( _ColorMask, texCoord124 );
				float4 lerpResult118 = lerp( float4( 1,1,1,1 ) , _ColorShift1 , tex2DNode119.r);
				float4 lerpResult120 = lerp( float4( 1,1,1,1 ) , _ColorShift2 , tex2DNode119.g);
				float4 lerpResult121 = lerp( float4( 1,1,1,1 ) , _ColorShift3 , tex2DNode119.b);
				float4 lerpResult122 = lerp( float4( 1,1,1,1 ) , _ColorShift4 , tex2DNode119.a);
				float4 ColorTint130 = ( lerpResult118 * lerpResult120 * lerpResult121 * lerpResult122 );
				float4 texCoord16 = float4(i.uv,0,0);
				texCoord16.xy = float4(i.uv,0,0).xy * float2( 1,1 ) + float2( 0,0 );
				float4 UVs73 = texCoord16;
				float4 tex2DNode54 = tex2D( _BaseMap, UVs73.xy );
				float2 Input_UV145_g362 = UVs73.xy;
				float2 UV100_g363 = Input_UV145_g362;
				float2 temp_output_51_0_g363 = mul( float2x2( 1, 0, -0.5773503, 1.154701 ), ( UV100_g363 * float2( 3.464,3.464 ) ) );
				float2 break55_g363 = frac( temp_output_51_0_g363 );
				float temp_output_56_0_g363 = ( ( 1.0 - break55_g363.x ) - break55_g363.y );
				float2 temp_output_52_0_g363 = floor( temp_output_51_0_g363 );
				float2 temp_output_125_0_g363 = ( temp_output_52_0_g363 + float2( 1,1 ) );
				float2 ifLocalVar87_g363 = 0;
				if( temp_output_56_0_g363 > 0.0 )
				ifLocalVar87_g363 = temp_output_52_0_g363;
				else if( temp_output_56_0_g363 == 0.0 )
				ifLocalVar87_g363 = temp_output_125_0_g363;
				else if( temp_output_56_0_g363 < 0.0 )
				ifLocalVar87_g363 = temp_output_125_0_g363;
				float3 temp_output_7_0_g364 = frac( ( (ifLocalVar87_g363).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g364 = dot( temp_output_7_0_g364 , ( (temp_output_7_0_g364).yzx + 33.33 ) );
				float3 temp_output_12_0_g364 = ( temp_output_7_0_g364 + dotResult8_g364 );
				float2 temp_output_10_0_g362 = ddx( Input_UV145_g362 );
				float2 temp_output_12_0_g362 = ddy( Input_UV145_g362 );
				float temp_output_65_0_g363 = ( 0.0 - temp_output_56_0_g363 );
				float ifLocalVar59_g363 = 0;
				if( temp_output_56_0_g363 <= 0.0 )
				ifLocalVar59_g363 = temp_output_65_0_g363;
				else
				ifLocalVar59_g363 = temp_output_56_0_g363;
				float2 temp_output_90_0_g363 = ( temp_output_52_0_g363 + float2( 0,1 ) );
				float2 temp_output_123_0_g363 = ( temp_output_52_0_g363 + float2( 1,0 ) );
				float2 ifLocalVar88_g363 = 0;
				if( temp_output_56_0_g363 > 0.0 )
				ifLocalVar88_g363 = temp_output_90_0_g363;
				else if( temp_output_56_0_g363 == 0.0 )
				ifLocalVar88_g363 = temp_output_123_0_g363;
				else if( temp_output_56_0_g363 < 0.0 )
				ifLocalVar88_g363 = temp_output_123_0_g363;
				float3 temp_output_7_0_g365 = frac( ( (ifLocalVar88_g363).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g365 = dot( temp_output_7_0_g365 , ( (temp_output_7_0_g365).yzx + 33.33 ) );
				float3 temp_output_12_0_g365 = ( temp_output_7_0_g365 + dotResult8_g365 );
				float temp_output_66_0_g363 = ( 1.0 - break55_g363.y );
				float ifLocalVar60_g363 = 0;
				if( temp_output_56_0_g363 <= 0.0 )
				ifLocalVar60_g363 = temp_output_66_0_g363;
				else
				ifLocalVar60_g363 = break55_g363.y;
				float2 ifLocalVar89_g363 = 0;
				if( temp_output_56_0_g363 > 0.0 )
				ifLocalVar89_g363 = temp_output_123_0_g363;
				else if( temp_output_56_0_g363 == 0.0 )
				ifLocalVar89_g363 = temp_output_90_0_g363;
				else if( temp_output_56_0_g363 < 0.0 )
				ifLocalVar89_g363 = temp_output_90_0_g363;
				float3 temp_output_7_0_g366 = frac( ( (ifLocalVar89_g363).xyx * float3( 0.1031, 0.103, 0.0973 ) ) );
				float dotResult8_g366 = dot( temp_output_7_0_g366 , ( (temp_output_7_0_g366).yzx + 33.33 ) );
				float3 temp_output_12_0_g366 = ( temp_output_7_0_g366 + dotResult8_g366 );
				float temp_output_67_0_g363 = ( 1.0 - break55_g363.x );
				float ifLocalVar61_g363 = 0;
				if( temp_output_56_0_g363 <= 0.0 )
				ifLocalVar61_g363 = temp_output_67_0_g363;
				else
				ifLocalVar61_g363 = break55_g363.x;
				float4 Output_2D293_g362 = ( ( tex2D( _BaseMap, ( UV100_g363 + frac( ( ( (temp_output_12_0_g364).xx + (temp_output_12_0_g364).yz ) * (temp_output_12_0_g364).zy ) ) ), temp_output_10_0_g362, temp_output_12_0_g362 ) * ifLocalVar59_g363 ) + ( tex2D( _BaseMap, ( UV100_g363 + frac( ( ( (temp_output_12_0_g365).xx + (temp_output_12_0_g365).yz ) * (temp_output_12_0_g365).zy ) ) ), temp_output_10_0_g362, temp_output_12_0_g362 ) * ifLocalVar60_g363 ) + ( tex2D( _BaseMap, ( UV100_g363 + frac( ( ( (temp_output_12_0_g366).xx + (temp_output_12_0_g366).yz ) * (temp_output_12_0_g366).zy ) ) ), temp_output_10_0_g362, temp_output_12_0_g362 ) * ifLocalVar61_g363 ) );
				#ifdef _ANTITILE_ON
				float4 staticSwitch53 = ( ColorTint130 * ( _BaseColor * Output_2D293_g362 ) );
				#else
				float4 staticSwitch53 = ( ColorTint130 * ( tex2DNode54 * _BaseColor ) );
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
				float3 ase_positionWS = i.ase_texcoord3.xyz;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ViewDir103 = ase_viewDirWS;
				float3 ase_normalWS = i.ase_texcoord4.xyz;
				float3 WorldNormal103 = ase_normalWS;
				float EmissionFalloff103 = _EmissionFalloff;
				float4 localEmissionFallingOff103 = EmissionFallingOff103( EmissionInput103 , ViewDir103 , WorldNormal103 , EmissionFalloff103 );
				float4 Emission110 = localEmissionFallingOff103;
				
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
				half3 bakedemission = emission;
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
	

	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19908
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;137;-1926.43,-1673.348;Inherit;False;1587.26;1698.928;;15;53;128;92;93;52;129;132;131;12;51;13;50;91;54;133;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;-1873.928,-1533.294;Inherit;False;1387.376;950;;13;114;115;116;117;118;120;121;122;123;124;130;119;136;ColorTint;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;96;-2464.01,-313.8857;Inherit;False;506.8228;260.1711;;2;16;73;UV's;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;124;-1823.928,-1451.294;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-2414.01,-260.7146;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-1519.928,-1131.294;Float;False;Property;_ColorShift2;_ColorShift2;16;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.8867924,0.8161001,0.7822179,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;115;-1519.928,-955.2941;Float;False;Property;_ColorShift3;_ColorShift3;17;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;116;-1519.928,-795.2943;Float;False;Property;_ColorShift4;_ColorShift4;22;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;117;-1519.928,-1291.294;Float;False;Property;_ColorShift1;_ColorShift1;15;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.2039216,0.4926736,0.5764706,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;119;-1599.928,-1483.294;Inherit;True;Property;_ColorMask;Color Tint;14;2;[Header];[NoScaleOffset];Create;False;1;Color Tint;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;-2181.186,-263.8855;Inherit;False;UVs;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;118;-1151.928,-1227.294;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;120;-1151.928,-1099.294;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;121;-1151.928,-971.2942;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;122;-1151.928,-859.2943;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-1753.446,1323.063;Inherit;False;1428.302;835.762;;12;99;74;102;104;105;103;17;27;106;101;110;113;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;123;-927.9281,-1099.294;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-1817.876,-342.2685;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-1876.941,-536.0996;Inherit;True;Property;_BaseMap;Albedo;0;1;[Header];Create;False;1;Color;0;0;False;0;False;None;None;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;74;-1703.446,1381.064;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;130;-785.5513,-1097.525;Inherit;False;ColorTint;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-1617.202,-542.2204;Inherit;True;Property;_TextureSample24;Texture Sample 24;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-1619.652,-342.5636;Inherit;False;Procedural Sample;-1;;362;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;74;SAMPLERSTATE;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;-1622.74,-163.9061;Inherit;False;Property;_BaseColor;Color;1;0;Create;False;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-1381.582,1729.05;Inherit;False;92;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-1507.003,1373.063;Inherit;True;Property;_EmissionMap;Emission Map;10;2;[Header];[NoScaleOffset];Create;True;1;Emission;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-1417.971,1558.746;Inherit;False;Property;_EmissionColor;Emission Color;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;-1427.717,1807.728;Inherit;False;Property;_EmitAlbedo;Emit Albedo;13;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-1063.245,-434.2335;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;131;-1096.218,-521.9628;Inherit;False;130;ColorTint;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;132;-1090.636,-333.2542;Inherit;False;130;ColorTint;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;52;-1055.955,-249.397;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-1143.639,1473.617;Inherit;False;float4 emissionOutput = EmissionMap * EmissionColor@$#if _EMITALBEDO_ON$emissionOutput *= Albedo@$#endif$return emissionOutput@;4;Create;4;True;EmissionMap;FLOAT4;0,0,0,0;In;;Inherit;False;True;EmissionColor;FLOAT4;0,0,0,0;In;;Inherit;False;True;Albedo;FLOAT4;0,0,0,0;In;;Inherit;False;True;LuhAcceptor;FLOAT;0;In;;Inherit;False;Emission Calculation;True;False;0;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-1071.181,1629.412;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-1081.281,1781.612;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;-1166.281,1920.612;Inherit;False;Property;_EmissionFalloff;Emission Falloff;12;0;Create;True;0;0;0;False;0;False;0;1;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;129;-906.663,-330.8652;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;-910.8555,-504.4612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-820.1649,1475.252;Inherit;False;return EmissionInput * saturate(pow(saturate(dot(ViewDir, WorldNormal)), EmissionFalloff * 2))@;4;Create;4;True;EmissionInput;FLOAT4;0,0,0,0;In;;Inherit;False;True;ViewDir;FLOAT3;0,0,0;In;;Inherit;False;True;WorldNormal;FLOAT3;0,0,0;In;;Inherit;False;True;EmissionFalloff;FLOAT;0;In;;Inherit;False;Emission Falling Off;True;False;0;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;-754.1761,-449.309;Inherit;False;Property;_AntiTile;Anti-Tile;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;-2199.114,60.39958;Inherit;False;1861.707;513.5607;;13;63;88;64;55;66;67;68;69;70;71;62;65;89;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;79;-2056.169,644.1152;Inherit;False;1750.947;580.6316;;19;82;83;138;56;33;35;36;37;32;25;40;49;85;78;41;61;60;59;58;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-549.1442,1471.821;Inherit;False;Emission;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-1327.308,-447.3973;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-540.6559,-446.694;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;139;-200.2579,1429.922;Inherit;False;983.089;362.0812;;6;152;151;150;149;142;141;Non-Linear Probe;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;140;-203.093,767.7761;Inherit;False;748;567;;7;155;148;147;146;145;144;143;Mono SH;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-1751.608,763.4773;Inherit;True;Property;_TextureSample25;Texture Sample 25;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-1757.226,974.4733;Inherit;False;Procedural Sample;-1;;2;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;74;SAMPLERSTATE;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-1434.129,875.7994;Inherit;False;Property;_Keyword0;Keyword 0;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;53;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-1229.794,880.4851;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1369.646,777.0847;Inherit;False;Property;_Metallic;Metallic;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;-1948.238,958.9513;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-896.1302,779.6622;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-1043.386,779.9793;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-1083.017,1018.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-936.0172,1020.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-763.0173,1022.115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-762.0173,900.1154;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-936.0172,898.1154;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-2048.281,307.9176;Inherit;False;73;UVs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-1826.817,110.3997;Inherit;True;Property;_TextureSample26;Texture Sample 26;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;-2149.114,399.7589;Inherit;False;Property;_NormalScale;Normal Scale;5;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;-1619.736,365.147;Inherit;False;UnpackNormal;-1;;327;d579cc33c6fa60b4ea9cee9e184b62e3;0;1;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;67;-1406.321,360.293;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;68;-1232.433,337.1511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;69;-1229.635,438.9602;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;70;-1068.827,375.5078;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;71;-907.1497,430.3151;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-772.8287,126.1658;Inherit;False;Property;_Keyword0;Keyword 0;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;53;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;-1821.821,314.1994;Inherit;False;Procedural Sample;-1;;328;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;74;SAMPLERSTATE;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-561.4067,127.6581;Inherit;False;Normals;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-1306.017,694.1152;Inherit;False;Property;_OcclusionStrength;_OcclusionStrength;9;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-1098.517,1117.457;Inherit;False;Property;_Glossiness;Smoothness;7;0;Create;False;0;0;0;False;0;False;1;0.81;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-840.6581,1774.994;Inherit;False;475;100;Credit;;1,1,1,1;Credit to ShortStak and Evro for emission handling framework$;0;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-2108.652,111.2987;Inherit;True;Property;_BumpMap;Normal Map;4;1;[Header];Create;False;1;Normals;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-2006.168,761.2069;Inherit;True;Property;_OcclusionRoughnessMap;ORM Map;6;1;[Header];Create;False;1;ORM Metallic;0;0;False;0;False;46279b4b29bae7e4ea63421cb33f3897;46279b4b29bae7e4ea63421cb33f3897;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;136;-988.9963,-1381.108;Inherit;False;428;100;Credit;;1,1,1,1;Credit to ShortStak and Evro for colortinting framework$;0;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-128.4522,-41.2725;Inherit;False;89;Normals;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-127.1276,-128.659;Inherit;False;92;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;138;-696.9687,760.1531;Inherit;False;370;100;Credit;;1,1,1,1;To shortstak for ORM Metallic handling setup;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-617.1758,898.2147;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;-620.1758,1019.214;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;141;137.7421,1543.922;Inherit;False;BakeryNonLinearLightProbe;29;;396;c510387f01015ab478517ff0d72607db;0;4;5;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;10;FLOAT;0;False;9;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;142;489.7421,1623.922;Inherit;False;Property;_NonLinearLightProbeSH;Non-Linear Light Probe SH;32;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;143;-166.093,828.7761;Inherit;False;89;Normals;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;144;-166.093,906.7761;Inherit;False;92;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;145;-181.093,984.7761;Inherit;False;82;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;-159.093,1057.776;Inherit;False;85;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;-157.093,1132.776;Inherit;False;83;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;148;-153.093,1210.776;Inherit;False;110;Emission;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;149;-86.25787,1478.922;Inherit;False;92;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;150;-86.25787,1555.922;Inherit;False;89;Normals;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;151;-83.25787,1635.922;Inherit;False;83;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;152;-82.25787,1709.922;Inherit;False;110;Emission;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Compare, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;153;671.907,1009.776;Inherit;False;0;4;0;INT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;154;915.6094,1054.254;Inherit;False;monoSHEmission;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;155;116.907,907.7761;Inherit;False;BakeryMonoSH;23;;398;29c9468cd28079b448a58bef1fb32cb5;0;6;8;FLOAT3;0,0,0;False;9;FLOAT3;0,0,0;False;10;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;13;FLOAT3;0,0,0;False;2;FLOAT3;0;INT;31
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;86;-121.2184,139.3651;Inherit;False;85;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;87;-135.2184,215.3651;Inherit;False;82;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-114.5986,292.1077;Inherit;False;83;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;-110.1276,377.341;Inherit;False;93;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-213.7387,457.1946;Inherit;False;Property;_Cutoff;Alpha Clipping;3;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;81;-170.7988,41.81591;Inherit;False;110;Emission;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;157;224,-48;Inherit;False;BRDFMap;18;;402;1affaac2d6e57354aaa8d6573a2b32b8;0;1;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;156;256,-128;Inherit;False;Property;_Cull;_Cull;21;1;[HideInInspector];Create;True;0;0;0;True;0;False;2;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthNormals;0;2;DepthNormals;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;Meta;0;4;Meta;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;ShadowCaster;0;3;ShadowCaster;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;623634af11bd9ab448550ee777f3493e;True;DepthOnly;0;1;DepthOnly;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;Lightmode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;160,32;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;AtlasShaders/LitORM ColorTint;623634af11bd9ab448550ee777f3493e;True;Forward;0;0;Forward;14;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;True;True;0;True;_Cull;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;False;False;False;False;True;1;Lightmode=UniversalForward;True;7;False;0;Hidden/InternalErrorShader;0;0;Standard;24;Workflow;1;0;Surface;0;0;Two Sided;1;638697990467180020;Cast Shadows;1;0;  Use Shadow Threshold;0;0;GPU Instancing;0;0;Built-in Fog;1;0;Lightmaps;1;0;Volumetrics;1;0;Decals;0;0;Write Depth;0;0;  Early Z (broken);0;0;Vertex Position;1;0;Emission;1;0;PC Reflection Probe;3;0;PC Receive Shadows;1;0;PC Vertex Lights;0;0;PC SSAO;1;0;Q Reflection Probe;0;0;Q Receive Shadows;0;0;Q Vertex Lights;1;0;Q SSAO;0;0;Environment Reflections;1;0;Meta Pass;1;0;0;5;True;True;True;True;True;False;;False;0
WireConnection;119;1;124;0
WireConnection;73;0;16;0
WireConnection;118;1;117;0
WireConnection;118;2;119;1
WireConnection;120;1;114;0
WireConnection;120;2;119;2
WireConnection;121;1;115;0
WireConnection;121;2;119;3
WireConnection;122;1;116;0
WireConnection;122;2;119;4
WireConnection;123;0;118;0
WireConnection;123;1;120;0
WireConnection;123;2;121;0
WireConnection;123;3;122;0
WireConnection;130;0;123;0
WireConnection;54;0;51;0
WireConnection;54;1;91;0
WireConnection;50;82;51;0
WireConnection;50;5;91;0
WireConnection;17;1;74;0
WireConnection;12;0;54;0
WireConnection;12;1;13;0
WireConnection;52;0;13;0
WireConnection;52;1;50;0
WireConnection;99;0;17;0
WireConnection;99;1;27;0
WireConnection;99;2;102;0
WireConnection;99;3;101;0
WireConnection;129;0;132;0
WireConnection;129;1;52;0
WireConnection;128;0;131;0
WireConnection;128;1;12;0
WireConnection;103;0;99;0
WireConnection;103;1;104;0
WireConnection;103;2;105;0
WireConnection;103;3;106;0
WireConnection;53;1;128;0
WireConnection;53;0;129;0
WireConnection;110;0;103;0
WireConnection;93;0;54;4
WireConnection;92;0;53;0
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
WireConnection;36;0;61;0
WireConnection;36;1;35;0
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
WireConnection;83;0;37;0
WireConnection;82;0;32;0
WireConnection;141;5;149;0
WireConnection;141;1;150;0
WireConnection;141;10;151;0
WireConnection;141;9;152;0
WireConnection;142;1;152;0
WireConnection;142;0;141;0
WireConnection;153;0;155;31
WireConnection;153;2;155;0
WireConnection;153;3;142;0
WireConnection;154;0;153;0
WireConnection;155;8;143;0
WireConnection;155;9;144;0
WireConnection;155;10;145;0
WireConnection;155;11;146;0
WireConnection;155;12;147;0
WireConnection;155;13;148;0
WireConnection;0;0;95;0
WireConnection;0;1;90;0
WireConnection;0;2;81;0
WireConnection;0;4;86;0
WireConnection;0;6;87;0
WireConnection;0;7;84;0
WireConnection;0;8;94;0
WireConnection;0;9;48;0
ASEEND*/
//CHKSM=2EA09B2D7A8D625FA77E2A9F9A33B7BE81F968BC