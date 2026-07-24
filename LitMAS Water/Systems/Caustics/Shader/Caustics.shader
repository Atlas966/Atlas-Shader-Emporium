// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AtlasShaders/LitMAS Water/Caustics"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HDR][Header(Caustics)]_Color("Color", Color) = (1,1,1,0)
		[NoScaleOffset]_Caustics("Caustics", 2D) = "white" {}
		[Toggle(_ENABLEANTITILE_ON)] _EnableAntiTile("Enable Anti-Tile", Float) = 0
		_CausticScale("Caustic Scale", Vector) = (1,1,0,0)
		_FlowAXYSpeed("Flow A (XY = Speed)", Vector) = (0,0,0,0)
		_FlowBXYSpeed("Flow B (XY = Speed)", Vector) = (0,0,0,0)
		_Falloff("Falloff", Range( 1 , 20)) = 1
		_CircleMask("Circle Mask", Range( 1 , 20)) = 1.5
		[Toggle(_CHROMATICABERRATION_ON)] _ChromaticAberration("Chromatic Aberration", Float) = 0
		_RGBOffset1("RGB Offset", Range( 0 , 10)) = 0.5
		[Toggle(_ENABLEDISTORTEDUVS_ON)] _EnableDistortedUVs("Enable Distorted UV's", Float) = 0
		_DistortionStrength("Distortion Strength", Range( 0 , 3)) = 0.2
		[NoScaleOffset]_Distortion("Distortion", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_OffsetXYSpeed("Offset (XY = Speed)", Vector) = (0,0,0,0)
		[Toggle(_ENABLEBLUENOISE_ON)] _EnableBlueNoise("Enable Blue Noise", Float) = 0
		_NoiseDefusion("Noise Defusion", Range( 0 , 1)) = 0.025
		[Toggle(_ENABLEPOSTPROCESSING_ON)] _EnablePostProcessing("Enable Post Processing", Float) = 0
		[Toggle(_GRAYSCALE_ON)] _Grayscale("Grayscale", Float) = 0
		[Toggle(_SATURATION_ON)] _Saturation("Saturation", Float) = 0
		_SaturationIntensity("Saturation Intensity", Range( 0 , 10)) = 1
		[Toggle(_CONTRAST_ON)] _Contrast("Contrast", Float) = 0
		[ASEEnd]_ContrastIntensity("Contrast Intensity", Range( 0 , 3)) = 1

		[HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Cull Front
		AlphaToMask Off
		
		HLSLINCLUDE
		#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
		#pragma target 5.0

		//#pragma prefer_hlslcc gles
		
			

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS

		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForwardOnly" }
			
			Blend One One, One OneMinusSrcAlpha
			ZWrite Off
			ZTest Always
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1
			#define ASE_USING_SAMPLING_MACROS 1

			
			//#pragma multi_compile _ LIGHTMAP_ON
			//#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			//#pragma shader_feature _ _SAMPLE_GI
			//#pragma multi_compile _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			//#pragma multi_compile _ DEBUG_DISPLAY
			#define SHADERPASS SHADERPASS_UNLIT


			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging3D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceData.hlsl"


			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _ENABLEPOSTPROCESSING_ON
			#pragma shader_feature_local _ENABLEANTITILE_ON
			#pragma shader_feature_local _CHROMATICABERRATION_ON
			#pragma shader_feature_local _ENABLEDISTORTEDUVS_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _GRAYSCALE_ON
			#pragma shader_feature_local _CONTRAST_ON
			#pragma shader_feature_local _SATURATION_ON
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_Caustics);
			uniform float4 _CameraDepthTexture_TexelSize;
			TEXTURE2D(_Distortion);
			SAMPLER(sampler_Distortion);
			SAMPLER(sampler_Caustics);


			float4x4 Inverse4x4(float4x4 input)
			{
				#define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
				float4x4 cofactors = float4x4(
				minor( _22_23_24, _32_33_34, _42_43_44 ),
				-minor( _21_23_24, _31_33_34, _41_43_44 ),
				minor( _21_22_24, _31_32_34, _41_42_44 ),
				-minor( _21_22_23, _31_32_33, _41_42_43 ),
			
				-minor( _12_13_14, _32_33_34, _42_43_44 ),
				minor( _11_13_14, _31_33_34, _41_43_44 ),
				-minor( _11_12_14, _31_32_34, _41_42_44 ),
				minor( _11_12_13, _31_32_33, _41_42_43 ),
			
				minor( _12_13_14, _22_23_24, _42_43_44 ),
				-minor( _11_13_14, _21_23_24, _41_43_44 ),
				minor( _11_12_14, _21_22_24, _41_42_44 ),
				-minor( _11_12_13, _21_22_23, _41_42_43 ),
			
				-minor( _12_13_14, _22_23_24, _32_33_34 ),
				minor( _11_13_14, _21_23_24, _31_33_34 ),
				-minor( _11_12_14, _21_22_24, _31_32_34 ),
				minor( _11_12_13, _21_22_23, _31_32_33 ));
				#undef minor
				return transpose( cofactors ) / determinant( input );
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
			
			inline float4 GetScreenNoiseRGBASlice27_g1879( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
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
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
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
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif
				float4 temp_cast_0 = (_Falloff).xxxx;
				float4 CausticsColor409 = _Color;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth6_g1877 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float4x4 invertVal5_g1878 = Inverse4x4( UNITY_MATRIX_M );
				float dotResult4_g1877 = dot( ase_worldViewDir , -mul( UNITY_MATRIX_M, float4( (transpose( mul( invertVal5_g1878, UNITY_MATRIX_I_V ) )[2]).xyz , 0.0 ) ).xyz );
				float3 worldToView72_g1877 = mul( UNITY_MATRIX_V, float4( WorldPosition, 1 ) ).xyz;
				float clampDepth65_g1877 = SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch68_g1877 = ( 1.0 - clampDepth65_g1877 );
				#else
				float staticSwitch68_g1877 = clampDepth65_g1877;
				#endif
				float lerpResult69_g1877 = lerp( _ProjectionParams.y , _ProjectionParams.z , staticSwitch68_g1877);
				float3 appendResult73_g1877 = (float3(worldToView72_g1877.xy , -lerpResult69_g1877));
				float3 viewToWorld74_g1877 = mul( UNITY_MATRIX_I_V, float4( appendResult73_g1877, 1 ) ).xyz;
				float3 ReconstructedWorldPos311 = ( unity_OrthoParams.w < 1.0 ? ( ( eyeDepth6_g1877 * ( ase_worldViewDir / dotResult4_g1877 ) ) + _WorldSpaceCameraPos ) : viewToWorld74_g1877 );
				float3 worldToObjDir262 = mul( GetWorldToObjectMatrix(), float4( ReconstructedWorldPos311, 0 ) ).xyz;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float2 ProjectionUVs307 = (( worldToObjDir262 * ase_objectScale )).xz;
				#ifdef _ENABLEDISTORTEDUVS_ON
				float4 staticSwitch293 = ( _DistortionStrength * SAMPLE_TEXTURE2D( _Distortion, sampler_Distortion, ( ( _OffsetXYSpeed * _TimeParameters.x ) + ( _Tiling * ( ProjectionUVs307 + float2( 0.5,0.5 ) ) ) ) ) );
				#else
				float4 staticSwitch293 = float4( 0,0,0,0 );
				#endif
				float4 UVDistorted316 = staticSwitch293;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g1879 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g1879 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g1879 = GetScreenNoiseRGBASlice27_g1879( screenUV27_g1879 , offsetFrame27_g1879 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch328 = ( ( (localGetScreenNoiseRGBASlice27_g1879).xyz - float3( 0.5,0.5,0.5 ) ) * ( _NoiseDefusion * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch328 = float3( 0,0,0 );
				#endif
				float3 UVBlueNoise329 = staticSwitch328;
				float4 UVSetA369 = ( float4( ( _FlowAXYSpeed * _TimeParameters.x ), 0.0 , 0.0 ) + float4( ( _CausticScale * ( ProjectionUVs307 + float2( 0.5,0.5 ) ) ), 0.0 , 0.0 ) + UVDistorted316 + float4( UVBlueNoise329 , 0.0 ) );
				float4 UVSetB368 = ( float4( ( _FlowBXYSpeed * _TimeParameters.x ), 0.0 , 0.0 ) + float4( ( _CausticScale * ( ProjectionUVs307 + float2( 0.5,0.5 ) ) ), 0.0 , 0.0 ) + UVDistorted316 + float4( UVBlueNoise329 , 0.0 ) );
				float3 worldToObj278 = mul( GetWorldToObjectMatrix(), float4( ReconstructedWorldPos311, 1 ) ).xyz;
				float smoothstepResult281 = smoothstep( 0.0 , 1.0 , ( 1.0 - length( ( ( worldToObj278 * 2 ) * _CircleMask * worldToObj278 ) ) ));
				float CircleMask305 = smoothstepResult281;
				float ChromaticOffset401 = _RGBOffset1;
				float temp_output_19_0_g1875 = ChromaticOffset401;
				float3 temp_output_20_0_g1875 = UVSetA369.rgb;
				float4 appendResult3_g1875 = (float4(SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1875 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1875 ).xy ).r , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1875 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1875 ).xy ).g , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1875 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1875 ).xy ).b , 0.0));
				float temp_output_19_0_g1876 = ChromaticOffset401;
				float3 temp_output_20_0_g1876 = UVSetB368.rgb;
				float4 appendResult3_g1876 = (float4(SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1876 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1876 ).xy ).r , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1876 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1876 ).xy ).g , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1876 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1876 ).xy ).b , 0.0));
				#ifdef _CHROMATICABERRATION_ON
				float4 staticSwitch421 = ( appendResult3_g1875 * appendResult3_g1876 * CausticsColor409 * CircleMask305 );
				#else
				float4 staticSwitch421 = ( CausticsColor409 * ( SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, UVSetA369.rg ) * SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, UVSetB368.rg ) ) * CircleMask305 );
				#endif
				float4 CausticsRegular445 = staticSwitch421;
				float localStochasticTiling2_g1873 = ( 0.0 );
				float2 Input_UV145_g1873 = UVSetA369.rg;
				float2 UV2_g1873 = Input_UV145_g1873;
				float2 UV12_g1873 = float2( 0,0 );
				float2 UV22_g1873 = float2( 0,0 );
				float2 UV32_g1873 = float2( 0,0 );
				float W12_g1873 = 0.0;
				float W22_g1873 = 0.0;
				float W32_g1873 = 0.0;
				StochasticTiling( UV2_g1873 , UV12_g1873 , UV22_g1873 , UV32_g1873 , W12_g1873 , W22_g1873 , W32_g1873 );
				float2 temp_output_10_0_g1873 = ddx( Input_UV145_g1873 );
				float2 temp_output_12_0_g1873 = ddy( Input_UV145_g1873 );
				float4 Output_2D293_g1873 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1873, temp_output_10_0_g1873, temp_output_12_0_g1873 ) * W12_g1873 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1873, temp_output_10_0_g1873, temp_output_12_0_g1873 ) * W22_g1873 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1873, temp_output_10_0_g1873, temp_output_12_0_g1873 ) * W32_g1873 ) );
				float localStochasticTiling2_g1874 = ( 0.0 );
				float2 Input_UV145_g1874 = UVSetB368.rg;
				float2 UV2_g1874 = Input_UV145_g1874;
				float2 UV12_g1874 = float2( 0,0 );
				float2 UV22_g1874 = float2( 0,0 );
				float2 UV32_g1874 = float2( 0,0 );
				float W12_g1874 = 0.0;
				float W22_g1874 = 0.0;
				float W32_g1874 = 0.0;
				StochasticTiling( UV2_g1874 , UV12_g1874 , UV22_g1874 , UV32_g1874 , W12_g1874 , W22_g1874 , W32_g1874 );
				float2 temp_output_10_0_g1874 = ddx( Input_UV145_g1874 );
				float2 temp_output_12_0_g1874 = ddy( Input_UV145_g1874 );
				float4 Output_2D293_g1874 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1874, temp_output_10_0_g1874, temp_output_12_0_g1874 ) * W12_g1874 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1874, temp_output_10_0_g1874, temp_output_12_0_g1874 ) * W22_g1874 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1874, temp_output_10_0_g1874, temp_output_12_0_g1874 ) * W32_g1874 ) );
				float localStochasticTiling2_g1866 = ( 0.0 );
				float temp_output_19_0_g1865 = ChromaticOffset401;
				float3 temp_output_20_0_g1865 = UVSetA369.rgb;
				float2 Input_UV145_g1866 = ( float3( ( temp_output_19_0_g1865 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1865 ).xy;
				float2 UV2_g1866 = Input_UV145_g1866;
				float2 UV12_g1866 = float2( 0,0 );
				float2 UV22_g1866 = float2( 0,0 );
				float2 UV32_g1866 = float2( 0,0 );
				float W12_g1866 = 0.0;
				float W22_g1866 = 0.0;
				float W32_g1866 = 0.0;
				StochasticTiling( UV2_g1866 , UV12_g1866 , UV22_g1866 , UV32_g1866 , W12_g1866 , W22_g1866 , W32_g1866 );
				float2 temp_output_10_0_g1866 = ddx( Input_UV145_g1866 );
				float2 temp_output_12_0_g1866 = ddy( Input_UV145_g1866 );
				float4 Output_2D293_g1866 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1866, temp_output_10_0_g1866, temp_output_12_0_g1866 ) * W12_g1866 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1866, temp_output_10_0_g1866, temp_output_12_0_g1866 ) * W22_g1866 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1866, temp_output_10_0_g1866, temp_output_12_0_g1866 ) * W32_g1866 ) );
				float4 break31_g1866 = Output_2D293_g1866;
				float localStochasticTiling2_g1867 = ( 0.0 );
				float2 Input_UV145_g1867 = ( float3( ( temp_output_19_0_g1865 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1865 ).xy;
				float2 UV2_g1867 = Input_UV145_g1867;
				float2 UV12_g1867 = float2( 0,0 );
				float2 UV22_g1867 = float2( 0,0 );
				float2 UV32_g1867 = float2( 0,0 );
				float W12_g1867 = 0.0;
				float W22_g1867 = 0.0;
				float W32_g1867 = 0.0;
				StochasticTiling( UV2_g1867 , UV12_g1867 , UV22_g1867 , UV32_g1867 , W12_g1867 , W22_g1867 , W32_g1867 );
				float2 temp_output_10_0_g1867 = ddx( Input_UV145_g1867 );
				float2 temp_output_12_0_g1867 = ddy( Input_UV145_g1867 );
				float4 Output_2D293_g1867 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1867, temp_output_10_0_g1867, temp_output_12_0_g1867 ) * W12_g1867 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1867, temp_output_10_0_g1867, temp_output_12_0_g1867 ) * W22_g1867 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1867, temp_output_10_0_g1867, temp_output_12_0_g1867 ) * W32_g1867 ) );
				float4 break31_g1867 = Output_2D293_g1867;
				float localStochasticTiling2_g1868 = ( 0.0 );
				float2 Input_UV145_g1868 = ( float3( ( temp_output_19_0_g1865 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1865 ).xy;
				float2 UV2_g1868 = Input_UV145_g1868;
				float2 UV12_g1868 = float2( 0,0 );
				float2 UV22_g1868 = float2( 0,0 );
				float2 UV32_g1868 = float2( 0,0 );
				float W12_g1868 = 0.0;
				float W22_g1868 = 0.0;
				float W32_g1868 = 0.0;
				StochasticTiling( UV2_g1868 , UV12_g1868 , UV22_g1868 , UV32_g1868 , W12_g1868 , W22_g1868 , W32_g1868 );
				float2 temp_output_10_0_g1868 = ddx( Input_UV145_g1868 );
				float2 temp_output_12_0_g1868 = ddy( Input_UV145_g1868 );
				float4 Output_2D293_g1868 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1868, temp_output_10_0_g1868, temp_output_12_0_g1868 ) * W12_g1868 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1868, temp_output_10_0_g1868, temp_output_12_0_g1868 ) * W22_g1868 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1868, temp_output_10_0_g1868, temp_output_12_0_g1868 ) * W32_g1868 ) );
				float4 break31_g1868 = Output_2D293_g1868;
				float4 appendResult3_g1865 = (float4(break31_g1866.r , break31_g1867.g , break31_g1868.b , 0.0));
				float localStochasticTiling2_g1870 = ( 0.0 );
				float temp_output_19_0_g1869 = ChromaticOffset401;
				float3 temp_output_20_0_g1869 = UVSetB368.rgb;
				float2 Input_UV145_g1870 = ( float3( ( temp_output_19_0_g1869 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1869 ).xy;
				float2 UV2_g1870 = Input_UV145_g1870;
				float2 UV12_g1870 = float2( 0,0 );
				float2 UV22_g1870 = float2( 0,0 );
				float2 UV32_g1870 = float2( 0,0 );
				float W12_g1870 = 0.0;
				float W22_g1870 = 0.0;
				float W32_g1870 = 0.0;
				StochasticTiling( UV2_g1870 , UV12_g1870 , UV22_g1870 , UV32_g1870 , W12_g1870 , W22_g1870 , W32_g1870 );
				float2 temp_output_10_0_g1870 = ddx( Input_UV145_g1870 );
				float2 temp_output_12_0_g1870 = ddy( Input_UV145_g1870 );
				float4 Output_2D293_g1870 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1870, temp_output_10_0_g1870, temp_output_12_0_g1870 ) * W12_g1870 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1870, temp_output_10_0_g1870, temp_output_12_0_g1870 ) * W22_g1870 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1870, temp_output_10_0_g1870, temp_output_12_0_g1870 ) * W32_g1870 ) );
				float4 break31_g1870 = Output_2D293_g1870;
				float localStochasticTiling2_g1871 = ( 0.0 );
				float2 Input_UV145_g1871 = ( float3( ( temp_output_19_0_g1869 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1869 ).xy;
				float2 UV2_g1871 = Input_UV145_g1871;
				float2 UV12_g1871 = float2( 0,0 );
				float2 UV22_g1871 = float2( 0,0 );
				float2 UV32_g1871 = float2( 0,0 );
				float W12_g1871 = 0.0;
				float W22_g1871 = 0.0;
				float W32_g1871 = 0.0;
				StochasticTiling( UV2_g1871 , UV12_g1871 , UV22_g1871 , UV32_g1871 , W12_g1871 , W22_g1871 , W32_g1871 );
				float2 temp_output_10_0_g1871 = ddx( Input_UV145_g1871 );
				float2 temp_output_12_0_g1871 = ddy( Input_UV145_g1871 );
				float4 Output_2D293_g1871 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1871, temp_output_10_0_g1871, temp_output_12_0_g1871 ) * W12_g1871 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1871, temp_output_10_0_g1871, temp_output_12_0_g1871 ) * W22_g1871 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1871, temp_output_10_0_g1871, temp_output_12_0_g1871 ) * W32_g1871 ) );
				float4 break31_g1871 = Output_2D293_g1871;
				float localStochasticTiling2_g1872 = ( 0.0 );
				float2 Input_UV145_g1872 = ( float3( ( temp_output_19_0_g1869 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1869 ).xy;
				float2 UV2_g1872 = Input_UV145_g1872;
				float2 UV12_g1872 = float2( 0,0 );
				float2 UV22_g1872 = float2( 0,0 );
				float2 UV32_g1872 = float2( 0,0 );
				float W12_g1872 = 0.0;
				float W22_g1872 = 0.0;
				float W32_g1872 = 0.0;
				StochasticTiling( UV2_g1872 , UV12_g1872 , UV22_g1872 , UV32_g1872 , W12_g1872 , W22_g1872 , W32_g1872 );
				float2 temp_output_10_0_g1872 = ddx( Input_UV145_g1872 );
				float2 temp_output_12_0_g1872 = ddy( Input_UV145_g1872 );
				float4 Output_2D293_g1872 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1872, temp_output_10_0_g1872, temp_output_12_0_g1872 ) * W12_g1872 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1872, temp_output_10_0_g1872, temp_output_12_0_g1872 ) * W22_g1872 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1872, temp_output_10_0_g1872, temp_output_12_0_g1872 ) * W32_g1872 ) );
				float4 break31_g1872 = Output_2D293_g1872;
				float4 appendResult3_g1869 = (float4(break31_g1870.r , break31_g1871.g , break31_g1872.b , 0.0));
				#ifdef _CHROMATICABERRATION_ON
				float4 staticSwitch424 = ( appendResult3_g1865 * appendResult3_g1869 * CausticsColor409 * CircleMask305 );
				#else
				float4 staticSwitch424 = ( CausticsColor409 * ( Output_2D293_g1873 * Output_2D293_g1874 ) * CircleMask305 );
				#endif
				float4 CausticsAntiTile443 = staticSwitch424;
				#ifdef _ENABLEANTITILE_ON
				float4 staticSwitch337 = CausticsAntiTile443;
				#else
				float4 staticSwitch337 = CausticsRegular445;
				#endif
				float4 smoothstepResult449 = smoothstep( float4( 0,0,0,0 ) , temp_cast_0 , staticSwitch337);
				float4 CombinedCaustics467 = smoothstepResult449;
				float dotResult460 = dot( float4( float3(0.2126729,0.7151522,0.072175) , 0.0 ) , CombinedCaustics467 );
				float4 temp_cast_43 = (dotResult460).xxxx;
				float4 lerpResult459 = lerp( temp_cast_43 , CombinedCaustics467 , _SaturationIntensity);
				#ifdef _SATURATION_ON
				float4 staticSwitch458 = lerpResult459;
				#else
				float4 staticSwitch458 = CombinedCaustics467;
				#endif
				#ifdef _CONTRAST_ON
				float4 staticSwitch454 = CalculateContrast(_ContrastIntensity,staticSwitch458);
				#else
				float4 staticSwitch454 = staticSwitch458;
				#endif
				float grayscale453 = Luminance(staticSwitch454.rgb);
				float4 temp_cast_45 = (grayscale453).xxxx;
				#ifdef _GRAYSCALE_ON
				float4 staticSwitch452 = temp_cast_45;
				#else
				float4 staticSwitch452 = staticSwitch454;
				#endif
				#ifdef _ENABLEPOSTPROCESSING_ON
				float4 staticSwitch466 = staticSwitch452;
				#else
				float4 staticSwitch466 = CombinedCaustics467;
				#endif
				float4 FinalColor303 = staticSwitch466;
				
				half3 BakedAlbedo = 0;
				half3 BakedEmission = 0;
				half3 Color = FinalColor303.rgb;
				half Alpha = 1;
				half AlphaClipThreshold = 0.5;
				half AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#if defined(_DBUFFER)
					ApplyDecalToBaseColor(IN.clipPos, Color);
				#endif

				#if defined(_ALPHAPREMULTIPLY_ON)
				Color *= Alpha;
				#endif


				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				
				#ifdef ASE_FOG
					//Color = MixFog( Color, IN.fogFactor );
					half3 viewDirectionWS = normalize(IN.worldPos - _WorldSpaceCameraPos);
					Color.rgb = MixFog(Color.rgb, viewDirectionWS, IN.fogFactor);
				#endif
				half4 output = half4(Color, Alpha);
				#ifdef _VOLUMETRICS_ENABLED
					output = Volumetrics(output, IN.worldPos);
				#endif

				return output;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM
			
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION -1
			#define ASE_USING_SAMPLING_MACROS 1

			
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
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

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir( v.ase_normal );

			#if _CASTING_PUNCTUAL_LIGHT_SHADOW
				float3 lightDirectionWS = normalize(_LightPosition - positionWS);
			#else
				float3 lightDirectionWS = _LightDirection;
			#endif
				float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));
			#if UNITY_REVERSED_Z
				clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
			#else
				clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
			#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;

				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION -1
			#define ASE_USING_SAMPLING_MACROS 1

			
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
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

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = TransformWorldToHClip( positionWS );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }
			
			Blend One One, One OneMinusSrcAlpha
			ZWrite Off
			ZTest Always
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
#pragma multi_compile_instancing#define ASE_SRP_VERSION -1#define REQUIRE_DEPTH_TEXTURE 1#define ASE_USING_SAMPLING_MACROS 1
#if FALSE
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma shader_feature _ _SAMPLE_GI
			#pragma multi_compile _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile _ DEBUG_DISPLAY
			#define SHADERPASS SHADERPASS_UNLIT


			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging3D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceData.hlsl"


			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _ENABLEPOSTPROCESSING_ON
			#pragma shader_feature_local _ENABLEANTITILE_ON
			#pragma shader_feature_local _CHROMATICABERRATION_ON
			#pragma shader_feature_local _ENABLEDISTORTEDUVS_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _GRAYSCALE_ON
			#pragma shader_feature_local _CONTRAST_ON
			#pragma shader_feature_local _SATURATION_ON
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D(_Caustics);
			uniform float4 _CameraDepthTexture_TexelSize;
			TEXTURE2D(_Distortion);
			SAMPLER(sampler_Distortion);
			SAMPLER(sampler_Caustics);


			float4x4 Inverse4x4(float4x4 input)
			{
				#define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
				float4x4 cofactors = float4x4(
				minor( _22_23_24, _32_33_34, _42_43_44 ),
				-minor( _21_23_24, _31_33_34, _41_43_44 ),
				minor( _21_22_24, _31_32_34, _41_42_44 ),
				-minor( _21_22_23, _31_32_33, _41_42_43 ),
			
				-minor( _12_13_14, _32_33_34, _42_43_44 ),
				minor( _11_13_14, _31_33_34, _41_43_44 ),
				-minor( _11_12_14, _31_32_34, _41_42_44 ),
				minor( _11_12_13, _31_32_33, _41_42_43 ),
			
				minor( _12_13_14, _22_23_24, _42_43_44 ),
				-minor( _11_13_14, _21_23_24, _41_43_44 ),
				minor( _11_12_14, _21_22_24, _41_42_44 ),
				-minor( _11_12_13, _21_22_23, _41_42_43 ),
			
				-minor( _12_13_14, _22_23_24, _32_33_34 ),
				minor( _11_13_14, _21_23_24, _31_33_34 ),
				-minor( _11_12_14, _21_22_24, _31_32_34 ),
				minor( _11_12_13, _21_22_23, _31_32_33 ));
				#undef minor
				return transpose( cofactors ) / determinant( input );
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
			
			inline float4 GetScreenNoiseRGBASlice27_g1879( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
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
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
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
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif
				float4 temp_cast_0 = (_Falloff).xxxx;
				float4 CausticsColor409 = _Color;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth6_g1877 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float4x4 invertVal5_g1878 = Inverse4x4( UNITY_MATRIX_M );
				float dotResult4_g1877 = dot( ase_worldViewDir , -mul( UNITY_MATRIX_M, float4( (transpose( mul( invertVal5_g1878, UNITY_MATRIX_I_V ) )[2]).xyz , 0.0 ) ).xyz );
				float3 worldToView72_g1877 = mul( UNITY_MATRIX_V, float4( WorldPosition, 1 ) ).xyz;
				float clampDepth65_g1877 = SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch68_g1877 = ( 1.0 - clampDepth65_g1877 );
				#else
				float staticSwitch68_g1877 = clampDepth65_g1877;
				#endif
				float lerpResult69_g1877 = lerp( _ProjectionParams.y , _ProjectionParams.z , staticSwitch68_g1877);
				float3 appendResult73_g1877 = (float3(worldToView72_g1877.xy , -lerpResult69_g1877));
				float3 viewToWorld74_g1877 = mul( UNITY_MATRIX_I_V, float4( appendResult73_g1877, 1 ) ).xyz;
				float3 ReconstructedWorldPos311 = ( unity_OrthoParams.w < 1.0 ? ( ( eyeDepth6_g1877 * ( ase_worldViewDir / dotResult4_g1877 ) ) + _WorldSpaceCameraPos ) : viewToWorld74_g1877 );
				float3 worldToObjDir262 = mul( GetWorldToObjectMatrix(), float4( ReconstructedWorldPos311, 0 ) ).xyz;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float2 ProjectionUVs307 = (( worldToObjDir262 * ase_objectScale )).xz;
				#ifdef _ENABLEDISTORTEDUVS_ON
				float4 staticSwitch293 = ( _DistortionStrength * SAMPLE_TEXTURE2D( _Distortion, sampler_Distortion, ( ( _OffsetXYSpeed * _TimeParameters.x ) + ( _Tiling * ( ProjectionUVs307 + float2( 0.5,0.5 ) ) ) ) ) );
				#else
				float4 staticSwitch293 = float4( 0,0,0,0 );
				#endif
				float4 UVDistorted316 = staticSwitch293;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g1879 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g1879 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g1879 = GetScreenNoiseRGBASlice27_g1879( screenUV27_g1879 , offsetFrame27_g1879 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch328 = ( ( (localGetScreenNoiseRGBASlice27_g1879).xyz - float3( 0.5,0.5,0.5 ) ) * ( _NoiseDefusion * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch328 = float3( 0,0,0 );
				#endif
				float3 UVBlueNoise329 = staticSwitch328;
				float4 UVSetA369 = ( float4( ( _FlowAXYSpeed * _TimeParameters.x ), 0.0 , 0.0 ) + float4( ( _CausticScale * ( ProjectionUVs307 + float2( 0.5,0.5 ) ) ), 0.0 , 0.0 ) + UVDistorted316 + float4( UVBlueNoise329 , 0.0 ) );
				float4 UVSetB368 = ( float4( ( _FlowBXYSpeed * _TimeParameters.x ), 0.0 , 0.0 ) + float4( ( _CausticScale * ( ProjectionUVs307 + float2( 0.5,0.5 ) ) ), 0.0 , 0.0 ) + UVDistorted316 + float4( UVBlueNoise329 , 0.0 ) );
				float3 worldToObj278 = mul( GetWorldToObjectMatrix(), float4( ReconstructedWorldPos311, 1 ) ).xyz;
				float smoothstepResult281 = smoothstep( 0.0 , 1.0 , ( 1.0 - length( ( ( worldToObj278 * 2 ) * _CircleMask * worldToObj278 ) ) ));
				float CircleMask305 = smoothstepResult281;
				float ChromaticOffset401 = _RGBOffset1;
				float temp_output_19_0_g1875 = ChromaticOffset401;
				float3 temp_output_20_0_g1875 = UVSetA369.rgb;
				float4 appendResult3_g1875 = (float4(SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1875 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1875 ).xy ).r , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1875 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1875 ).xy ).g , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1875 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1875 ).xy ).b , 0.0));
				float temp_output_19_0_g1876 = ChromaticOffset401;
				float3 temp_output_20_0_g1876 = UVSetB368.rgb;
				float4 appendResult3_g1876 = (float4(SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1876 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1876 ).xy ).r , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1876 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1876 ).xy ).g , SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, ( float3( ( temp_output_19_0_g1876 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1876 ).xy ).b , 0.0));
				#ifdef _CHROMATICABERRATION_ON
				float4 staticSwitch421 = ( appendResult3_g1875 * appendResult3_g1876 * CausticsColor409 * CircleMask305 );
				#else
				float4 staticSwitch421 = ( CausticsColor409 * ( SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, UVSetA369.rg ) * SAMPLE_TEXTURE2D( _Caustics, sampler_Caustics, UVSetB368.rg ) ) * CircleMask305 );
				#endif
				float4 CausticsRegular445 = staticSwitch421;
				float localStochasticTiling2_g1873 = ( 0.0 );
				float2 Input_UV145_g1873 = UVSetA369.rg;
				float2 UV2_g1873 = Input_UV145_g1873;
				float2 UV12_g1873 = float2( 0,0 );
				float2 UV22_g1873 = float2( 0,0 );
				float2 UV32_g1873 = float2( 0,0 );
				float W12_g1873 = 0.0;
				float W22_g1873 = 0.0;
				float W32_g1873 = 0.0;
				StochasticTiling( UV2_g1873 , UV12_g1873 , UV22_g1873 , UV32_g1873 , W12_g1873 , W22_g1873 , W32_g1873 );
				float2 temp_output_10_0_g1873 = ddx( Input_UV145_g1873 );
				float2 temp_output_12_0_g1873 = ddy( Input_UV145_g1873 );
				float4 Output_2D293_g1873 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1873, temp_output_10_0_g1873, temp_output_12_0_g1873 ) * W12_g1873 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1873, temp_output_10_0_g1873, temp_output_12_0_g1873 ) * W22_g1873 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1873, temp_output_10_0_g1873, temp_output_12_0_g1873 ) * W32_g1873 ) );
				float localStochasticTiling2_g1874 = ( 0.0 );
				float2 Input_UV145_g1874 = UVSetB368.rg;
				float2 UV2_g1874 = Input_UV145_g1874;
				float2 UV12_g1874 = float2( 0,0 );
				float2 UV22_g1874 = float2( 0,0 );
				float2 UV32_g1874 = float2( 0,0 );
				float W12_g1874 = 0.0;
				float W22_g1874 = 0.0;
				float W32_g1874 = 0.0;
				StochasticTiling( UV2_g1874 , UV12_g1874 , UV22_g1874 , UV32_g1874 , W12_g1874 , W22_g1874 , W32_g1874 );
				float2 temp_output_10_0_g1874 = ddx( Input_UV145_g1874 );
				float2 temp_output_12_0_g1874 = ddy( Input_UV145_g1874 );
				float4 Output_2D293_g1874 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1874, temp_output_10_0_g1874, temp_output_12_0_g1874 ) * W12_g1874 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1874, temp_output_10_0_g1874, temp_output_12_0_g1874 ) * W22_g1874 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1874, temp_output_10_0_g1874, temp_output_12_0_g1874 ) * W32_g1874 ) );
				float localStochasticTiling2_g1866 = ( 0.0 );
				float temp_output_19_0_g1865 = ChromaticOffset401;
				float3 temp_output_20_0_g1865 = UVSetA369.rgb;
				float2 Input_UV145_g1866 = ( float3( ( temp_output_19_0_g1865 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1865 ).xy;
				float2 UV2_g1866 = Input_UV145_g1866;
				float2 UV12_g1866 = float2( 0,0 );
				float2 UV22_g1866 = float2( 0,0 );
				float2 UV32_g1866 = float2( 0,0 );
				float W12_g1866 = 0.0;
				float W22_g1866 = 0.0;
				float W32_g1866 = 0.0;
				StochasticTiling( UV2_g1866 , UV12_g1866 , UV22_g1866 , UV32_g1866 , W12_g1866 , W22_g1866 , W32_g1866 );
				float2 temp_output_10_0_g1866 = ddx( Input_UV145_g1866 );
				float2 temp_output_12_0_g1866 = ddy( Input_UV145_g1866 );
				float4 Output_2D293_g1866 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1866, temp_output_10_0_g1866, temp_output_12_0_g1866 ) * W12_g1866 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1866, temp_output_10_0_g1866, temp_output_12_0_g1866 ) * W22_g1866 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1866, temp_output_10_0_g1866, temp_output_12_0_g1866 ) * W32_g1866 ) );
				float4 break31_g1866 = Output_2D293_g1866;
				float localStochasticTiling2_g1867 = ( 0.0 );
				float2 Input_UV145_g1867 = ( float3( ( temp_output_19_0_g1865 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1865 ).xy;
				float2 UV2_g1867 = Input_UV145_g1867;
				float2 UV12_g1867 = float2( 0,0 );
				float2 UV22_g1867 = float2( 0,0 );
				float2 UV32_g1867 = float2( 0,0 );
				float W12_g1867 = 0.0;
				float W22_g1867 = 0.0;
				float W32_g1867 = 0.0;
				StochasticTiling( UV2_g1867 , UV12_g1867 , UV22_g1867 , UV32_g1867 , W12_g1867 , W22_g1867 , W32_g1867 );
				float2 temp_output_10_0_g1867 = ddx( Input_UV145_g1867 );
				float2 temp_output_12_0_g1867 = ddy( Input_UV145_g1867 );
				float4 Output_2D293_g1867 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1867, temp_output_10_0_g1867, temp_output_12_0_g1867 ) * W12_g1867 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1867, temp_output_10_0_g1867, temp_output_12_0_g1867 ) * W22_g1867 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1867, temp_output_10_0_g1867, temp_output_12_0_g1867 ) * W32_g1867 ) );
				float4 break31_g1867 = Output_2D293_g1867;
				float localStochasticTiling2_g1868 = ( 0.0 );
				float2 Input_UV145_g1868 = ( float3( ( temp_output_19_0_g1865 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1865 ).xy;
				float2 UV2_g1868 = Input_UV145_g1868;
				float2 UV12_g1868 = float2( 0,0 );
				float2 UV22_g1868 = float2( 0,0 );
				float2 UV32_g1868 = float2( 0,0 );
				float W12_g1868 = 0.0;
				float W22_g1868 = 0.0;
				float W32_g1868 = 0.0;
				StochasticTiling( UV2_g1868 , UV12_g1868 , UV22_g1868 , UV32_g1868 , W12_g1868 , W22_g1868 , W32_g1868 );
				float2 temp_output_10_0_g1868 = ddx( Input_UV145_g1868 );
				float2 temp_output_12_0_g1868 = ddy( Input_UV145_g1868 );
				float4 Output_2D293_g1868 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1868, temp_output_10_0_g1868, temp_output_12_0_g1868 ) * W12_g1868 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1868, temp_output_10_0_g1868, temp_output_12_0_g1868 ) * W22_g1868 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1868, temp_output_10_0_g1868, temp_output_12_0_g1868 ) * W32_g1868 ) );
				float4 break31_g1868 = Output_2D293_g1868;
				float4 appendResult3_g1865 = (float4(break31_g1866.r , break31_g1867.g , break31_g1868.b , 0.0));
				float localStochasticTiling2_g1870 = ( 0.0 );
				float temp_output_19_0_g1869 = ChromaticOffset401;
				float3 temp_output_20_0_g1869 = UVSetB368.rgb;
				float2 Input_UV145_g1870 = ( float3( ( temp_output_19_0_g1869 * float2( 0.002,0 ) ) ,  0.0 ) + temp_output_20_0_g1869 ).xy;
				float2 UV2_g1870 = Input_UV145_g1870;
				float2 UV12_g1870 = float2( 0,0 );
				float2 UV22_g1870 = float2( 0,0 );
				float2 UV32_g1870 = float2( 0,0 );
				float W12_g1870 = 0.0;
				float W22_g1870 = 0.0;
				float W32_g1870 = 0.0;
				StochasticTiling( UV2_g1870 , UV12_g1870 , UV22_g1870 , UV32_g1870 , W12_g1870 , W22_g1870 , W32_g1870 );
				float2 temp_output_10_0_g1870 = ddx( Input_UV145_g1870 );
				float2 temp_output_12_0_g1870 = ddy( Input_UV145_g1870 );
				float4 Output_2D293_g1870 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1870, temp_output_10_0_g1870, temp_output_12_0_g1870 ) * W12_g1870 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1870, temp_output_10_0_g1870, temp_output_12_0_g1870 ) * W22_g1870 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1870, temp_output_10_0_g1870, temp_output_12_0_g1870 ) * W32_g1870 ) );
				float4 break31_g1870 = Output_2D293_g1870;
				float localStochasticTiling2_g1871 = ( 0.0 );
				float2 Input_UV145_g1871 = ( float3( ( temp_output_19_0_g1869 * float2( 0,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1869 ).xy;
				float2 UV2_g1871 = Input_UV145_g1871;
				float2 UV12_g1871 = float2( 0,0 );
				float2 UV22_g1871 = float2( 0,0 );
				float2 UV32_g1871 = float2( 0,0 );
				float W12_g1871 = 0.0;
				float W22_g1871 = 0.0;
				float W32_g1871 = 0.0;
				StochasticTiling( UV2_g1871 , UV12_g1871 , UV22_g1871 , UV32_g1871 , W12_g1871 , W22_g1871 , W32_g1871 );
				float2 temp_output_10_0_g1871 = ddx( Input_UV145_g1871 );
				float2 temp_output_12_0_g1871 = ddy( Input_UV145_g1871 );
				float4 Output_2D293_g1871 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1871, temp_output_10_0_g1871, temp_output_12_0_g1871 ) * W12_g1871 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1871, temp_output_10_0_g1871, temp_output_12_0_g1871 ) * W22_g1871 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1871, temp_output_10_0_g1871, temp_output_12_0_g1871 ) * W32_g1871 ) );
				float4 break31_g1871 = Output_2D293_g1871;
				float localStochasticTiling2_g1872 = ( 0.0 );
				float2 Input_UV145_g1872 = ( float3( ( temp_output_19_0_g1869 * float2( -0.002,-0.002 ) ) ,  0.0 ) + temp_output_20_0_g1869 ).xy;
				float2 UV2_g1872 = Input_UV145_g1872;
				float2 UV12_g1872 = float2( 0,0 );
				float2 UV22_g1872 = float2( 0,0 );
				float2 UV32_g1872 = float2( 0,0 );
				float W12_g1872 = 0.0;
				float W22_g1872 = 0.0;
				float W32_g1872 = 0.0;
				StochasticTiling( UV2_g1872 , UV12_g1872 , UV22_g1872 , UV32_g1872 , W12_g1872 , W22_g1872 , W32_g1872 );
				float2 temp_output_10_0_g1872 = ddx( Input_UV145_g1872 );
				float2 temp_output_12_0_g1872 = ddy( Input_UV145_g1872 );
				float4 Output_2D293_g1872 = ( ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV12_g1872, temp_output_10_0_g1872, temp_output_12_0_g1872 ) * W12_g1872 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV22_g1872, temp_output_10_0_g1872, temp_output_12_0_g1872 ) * W22_g1872 ) + ( SAMPLE_TEXTURE2D_GRAD( _Caustics, sampler_Caustics, UV32_g1872, temp_output_10_0_g1872, temp_output_12_0_g1872 ) * W32_g1872 ) );
				float4 break31_g1872 = Output_2D293_g1872;
				float4 appendResult3_g1869 = (float4(break31_g1870.r , break31_g1871.g , break31_g1872.b , 0.0));
				#ifdef _CHROMATICABERRATION_ON
				float4 staticSwitch424 = ( appendResult3_g1865 * appendResult3_g1869 * CausticsColor409 * CircleMask305 );
				#else
				float4 staticSwitch424 = ( CausticsColor409 * ( Output_2D293_g1873 * Output_2D293_g1874 ) * CircleMask305 );
				#endif
				float4 CausticsAntiTile443 = staticSwitch424;
				#ifdef _ENABLEANTITILE_ON
				float4 staticSwitch337 = CausticsAntiTile443;
				#else
				float4 staticSwitch337 = CausticsRegular445;
				#endif
				float4 smoothstepResult449 = smoothstep( float4( 0,0,0,0 ) , temp_cast_0 , staticSwitch337);
				float4 CombinedCaustics467 = smoothstepResult449;
				float dotResult460 = dot( float4( float3(0.2126729,0.7151522,0.072175) , 0.0 ) , CombinedCaustics467 );
				float4 temp_cast_43 = (dotResult460).xxxx;
				float4 lerpResult459 = lerp( temp_cast_43 , CombinedCaustics467 , _SaturationIntensity);
				#ifdef _SATURATION_ON
				float4 staticSwitch458 = lerpResult459;
				#else
				float4 staticSwitch458 = CombinedCaustics467;
				#endif
				#ifdef _CONTRAST_ON
				float4 staticSwitch454 = CalculateContrast(_ContrastIntensity,staticSwitch458);
				#else
				float4 staticSwitch454 = staticSwitch458;
				#endif
				float grayscale453 = Luminance(staticSwitch454.rgb);
				float4 temp_cast_45 = (grayscale453).xxxx;
				#ifdef _GRAYSCALE_ON
				float4 staticSwitch452 = temp_cast_45;
				#else
				float4 staticSwitch452 = staticSwitch454;
				#endif
				#ifdef _ENABLEPOSTPROCESSING_ON
				float4 staticSwitch466 = staticSwitch452;
				#else
				float4 staticSwitch466 = CombinedCaustics467;
				#endif
				float4 FinalColor303 = staticSwitch466;
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = FinalColor303.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#if defined(_DBUFFER)
					ApplyDecalToBaseColor(IN.clipPos, Color);
				#endif

				#if defined(_ALPHAPREMULTIPLY_ON)
				Color *= Alpha;
				#endif


				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				return half4( Color, Alpha );
			}
#endif
			ENDHLSL
		}


		
        Pass
        {
			
            Name "SceneSelectionPass"
            Tags { "LightMode"="SceneSelectionPass" }
        
			Cull Off

			HLSLPROGRAM
        
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION -1
			#define ASE_USING_SAMPLING_MACROS 1

        
			#pragma only_renderers d3d11 glcore gles gles3 
			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			

			
			int _ObjectId;
			int _PassValue;

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};
        
			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

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
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				o.clipPos = TransformWorldToHClip(positionWS);
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif
			
			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;
				
				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;


				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}

			ENDHLSL
        }

		
        Pass
        {
			
            Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }
        
			HLSLPROGRAM

			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION -1
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma only_renderers d3d11 glcore gles gles3 
			#pragma vertex vert
			#pragma fragment frag

        
			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY
			

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			

			
        
			float4 _SelectionID;

        
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};
        
			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

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
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				o.clipPos = TransformWorldToHClip(positionWS);
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;
				
				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;


				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;
				outColor = _SelectionID;
				
				return outColor;
			}
        
			ENDHLSL
        }
		
		
        Pass
        {
			
            Name "DepthNormals"
            Tags { "LightMode"="DepthNormalsOnly" }

			ZTest LEqual
			ZWrite On

        
			HLSLPROGRAM
			
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION -1
			#define ASE_USING_SAMPLING_MACROS 1

			
			#pragma only_renderers d3d11 glcore gles gles3 
			//#pragma multi_compile_fog
			#pragma instancing_options renderinglayer
			#pragma vertex vert
			#pragma fragment frag

        
			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define VARYINGS_NEED_NORMAL_WS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float3 normalWS : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			      
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};
        
			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

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
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal(v.ase_normal);

				o.clipPos = TransformWorldToHClip(positionWS);
				o.normalWS.xyz =  normalWS;

				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;
				
				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				float3 normalWS = IN.normalWS;
				return half4(EncodeWSNormalForNormalsTex(NormalizeNormalPerPixel(normalWS)), 0.0);

			}
        
			ENDHLSL
        }

		
        Pass
        {
			
            Name "DepthNormalsOnly"
            Tags { "LightMode"="DepthNormalsOnly" }
        
			ZTest LEqual
			ZWrite On
        
        
			HLSLPROGRAM
        
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION -1
			#define ASE_USING_SAMPLING_MACROS 1

        
			#pragma exclude_renderers glcore gles gles3 
			#pragma vertex vert
			#pragma fragment frag
        
			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define ATTRIBUTES_NEED_TEXCOORD1
			#define VARYINGS_NEED_NORMAL_WS
			#define VARYINGS_NEED_TANGENT_WS
        
			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float3 normalWS : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float4 _Color;
			float2 _FlowAXYSpeed;
			float2 _CausticScale;
			float2 _OffsetXYSpeed;
			float2 _Tiling;
			float2 _FlowBXYSpeed;
			float _Falloff;
			float _DistortionStrength;
			float _NoiseDefusion;
			float _CircleMask;
			float _RGBOffset1;
			float _SaturationIntensity;
			float _ContrastIntensity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};
      
			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

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
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal(v.ase_normal);

				o.clipPos = TransformWorldToHClip(positionWS);
				o.normalWS.xyz =  normalWS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;
				
				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;
				
				#if _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				float3 normalWS = IN.normalWS;
				return half4(EncodeWSNormalForNormalsTex(NormalizeNormalPerPixel(normalWS)), 0.0);

			}

			ENDHLSL
        }
		
	}
	
	CustomEditor "LitMASWaterCausticsGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.CommentaryNode;319;1141.364,-2031.305;Inherit;False;3582.607;1921.126;Process color and post processing;5;441;442;447;448;471;Color;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;471;1685.264,-623.1355;Inherit;False;2949.406;456.9633;Handling of optional post processing;7;466;470;468;464;457;451;472;Post Processing;0.8587747,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;472;4274.153,-564.364;Inherit;False;274;166;;1;303;Final Color;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;448;1697.575,-985.5943;Inherit;False;872.3379;242.3618;Swtich between regular and anti-tiled;6;467;449;450;337;444;446;Switch;1,0,0.3180475,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;447;1169.115,-990.8813;Inherit;False;469.2996;492.8;Register variables used in color handling;6;392;401;259;409;331;395;Register Variables;0.6721401,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;442;2494.011,-1958.63;Inherit;False;1352.83;913.8839;Regular caustics texture handling;23;445;421;260;306;366;410;408;402;407;423;422;418;417;406;405;403;400;396;373;397;374;349;332;Caustics Regular;1,0,0.5719805,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;441;1151.759,-1959.635;Inherit;False;1308.698;899.1371;Caustics texture handling with anti-tiling;24;443;425;424;399;381;416;415;379;398;375;378;376;367;431;429;432;430;428;427;434;433;438;437;136;Anti-Tile;1,0,0.9445124,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;372;23.02452,-1848.444;Inherit;False;1040.1;931.4997;Create UV's for projection;23;369;368;353;352;351;350;357;360;359;358;272;330;317;265;271;371;370;309;266;270;361;273;362;Projection UV's;0.236347,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;327;-993.4081,-2538.461;Inherit;False;1328.001;320.9999;Optional Blue Noise for interesting visuals;9;329;328;326;325;324;323;322;321;320;Blue Noise;0,0.3482039,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;318;375.8288,-2537.952;Inherit;False;1725.172;358.1264;Handling of optional UV distortion for interesting visuals;14;316;293;274;275;276;308;298;299;301;300;390;391;296;295;Optional UV Distortion;1,0.4198113,0.4198113,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;315;-1014.181,-1829.394;Inherit;False;981.699;334;Create projection space for UV's;6;307;264;261;263;262;312;Projection Space;0.7975758,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;314;-1014.689,-1426.699;Inherit;False;557.5913;126.3992;;2;311;267;Register Reconstructed World Pos;0.7752525,0.4292453,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;302;-1170.513,-2161.544;Inherit;False;1561.235;237.8785;Mask out caustics outside of circle;11;284;292;313;305;291;278;282;283;279;280;281;Circle Mask;0.514151,0.8226985,1,1;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;136;1706.903,-1771.166;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;362;559.1243,-1701.445;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;273;320.1246,-1798.445;Inherit;False;Property;_FlowAXYSpeed;Flow A (XY = Speed);4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;361;366.1246,-1672.445;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;564.3243,-1585.345;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;266;435.3246,-1582.345;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;237.3246,-1576.345;Inherit;False;307;ProjectionUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;370;527.5147,-1600.501;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;371;314.5148,-1608.501;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;271;43.12463,-1675.445;Inherit;False;Property;_CausticScale;Caustic Scale;3;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;265;266.1247,-1500.445;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;330;513.1243,-1397.445;Inherit;False;329;UVBlueNoise;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;272;724.1242,-1704.445;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;358;709.5239,-1234.244;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;359;559.5245,-1231.244;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;360;372.5248,-1198.244;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;357;328.5248,-1326.244;Inherit;False;Property;_FlowBXYSpeed;Flow B (XY = Speed);5;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;563.5245,-1130.245;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;351;427.5248,-1115.245;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;352;200.5248,-1126.245;Inherit;False;307;ProjectionUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;353;226.5248,-1043.245;Inherit;False;Constant;_Vector3;Vector 3;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;317;518.2835,-1472.126;Inherit;False;316;UVDistorted;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;369;865.124,-1488.21;Inherit;False;UVSetA;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;368;844.5239,-1235.244;Inherit;False;UVSetB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;138;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.CommentaryNode;457;2547.562,-568.1354;Inherit;False;692.9999;231;;11;456;455;454;145;144;143;142;141;140;139;138;Contrast;1,0.5235849,0.9003567,1;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;139;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;140;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;141;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;True;1;1;False;;1;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;7;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;142;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;143;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ScenePickingPass;0;7;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;144;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthNormals;0;8;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormalsOnly;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;145;2560,-470;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthNormalsOnly;0;9;DepthNormalsOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormalsOnly;False;True;9;d3d11;metal;vulkan;xboxone;xboxseries;playstation;ps4;ps5;switch;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.FunctionNode;437;1404.502,-1516.648;Inherit;False;ChromaticAberration (Procedural);-1;;1865;0a6c77a017e9dc54a8fb32ebcc7d5158;0;3;21;SAMPLER2D;;False;20;FLOAT3;0,0,0;False;19;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;438;1405.077,-1397.953;Inherit;False;ChromaticAberration (Procedural);-1;;1869;0a6c77a017e9dc54a8fb32ebcc7d5158;0;3;21;SAMPLER2D;;False;20;FLOAT3;0,0,0;False;19;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;433;1503.105,-1280.332;Inherit;False;409;CausticsColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;434;1520.956,-1210.624;Inherit;False;305;CircleMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;427;1176.934,-1516.581;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;428;1218.292,-1445.546;Inherit;False;369;UVSetA;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;430;1186.964,-1290.867;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;432;1228.322,-1219.834;Inherit;False;368;UVSetB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;429;1178.591,-1370.847;Inherit;False;401;ChromaticOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;431;1188.622,-1145.134;Inherit;False;401;ChromaticOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;367;1386.94,-1909.635;Inherit;False;Procedural Sample;-1;;1873;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.FunctionNode;376;1386.032,-1715.179;Inherit;False;Procedural Sample;-1;;1874;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;378;1221.611,-1637.587;Inherit;False;368;UVSetB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;375;1211.634,-1829.822;Inherit;False;369;UVSetA;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;1175.834,-1905.097;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;379;1654.569,-1818.712;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;415;1596.992,-1905.247;Inherit;False;409;CausticsColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;1616.192,-1718.047;Inherit;False;305;CircleMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;1843.151,-1857.734;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;399;1181.834,-1713.098;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;332;2716.906,-1906.159;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;349;2716.664,-1705.534;Inherit;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;374;2553.209,-1624.413;Inherit;False;368;UVSetB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;2515.058,-1700.566;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;373;2548.093,-1825.192;Inherit;False;369;UVSetA;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;396;2510.058,-1905.566;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;400;2519.937,-1510.68;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;403;2561.296,-1439.646;Inherit;False;369;UVSetA;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;405;2529.966,-1284.967;Inherit;False;395;CausticsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;406;2571.324,-1213.933;Inherit;False;368;UVSetB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;417;2821.108,-1256.432;Inherit;False;409;CausticsColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;418;2836.958,-1171.724;Inherit;False;305;CircleMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;422;2778.86,-1504.169;Inherit;False;ChromaticAberration;-1;;1875;88ea3ffa8f3a64a45a39e677c304e66a;0;3;21;SAMPLER2D;;False;20;FLOAT3;0,0,0;False;19;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;423;2780.89,-1376.456;Inherit;False;ChromaticAberration;-1;;1876;88ea3ffa8f3a64a45a39e677c304e66a;0;3;21;SAMPLER2D;;False;20;FLOAT3;0,0,0;False;19;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;407;2536.932,-1139.958;Inherit;False;401;ChromaticOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;402;2526.902,-1365.671;Inherit;False;401;ChromaticOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;408;3229.075,-1571.23;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;425;1841.874,-1583.722;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;410;3007.519,-1904.615;Inherit;False;409;CausticsColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;366;3070.399,-1827.42;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;3027.406,-1734.043;Inherit;False;305;CircleMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;260;3226.658,-1854.614;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;443;2267.761,-1714.126;Inherit;False;CausticsAntiTile;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;395;1415.961,-940.8813;Inherit;False;CausticsTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;331;1184.624,-940.7422;Inherit;True;Property;_Caustics;Caustics;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;409;1385.782,-672.0122;Inherit;False;CausticsColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;259;1187.634,-671.0923;Inherit;False;Property;_Color;Color;0;2;[HDR];[Header];Create;True;1;Caustics;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;401;1447.402,-750.5828;Inherit;False;ChromaticOffset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;1185.295,-750.5339;Inherit;False;Property;_RGBOffset1;RGB Offset;9;0;Create;False;1;Chromatic Abberation;0;0;False;0;False;0.5;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;281;26.72297,-2112.43;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;280;-122.2769,-2111.43;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;279;-251.2769,-2112.43;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;283;-379.9693,-2113.544;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleNode;282;-527.2772,-2113.43;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;291;-401.7376,-1975.999;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;305;195.5022,-2113.311;Inherit;False;CircleMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;267;-1005.689,-1383.7;Inherit;False;Reconstruct World Pos from Depth VR;-1;;1877;474d2b03c8647914986393f8dfbd9fe4;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;-694.0977,-1380.3;Inherit;False;ReconstructedWorldPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-999.1807,-1782.116;Inherit;False;311;ReconstructedWorldPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;262;-754.8099,-1782.394;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-538.8089,-1779.394;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectScaleNode;261;-704.8089,-1638.394;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;264;-404.8093,-1779.394;Inherit;False;True;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-217.4814,-1777.826;Inherit;False;ProjectionUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;320;-410.4077,-2296.46;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;321;-410.4077,-2392.46;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;323;-666.4077,-2488.461;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;324;-522.4077,-2488.461;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;-234.408,-2440.46;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;146.1876,-2439.753;Inherit;False;UVBlueNoise;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;295;570.2112,-2475.952;Inherit;False;Property;_Tiling;Tiling;13;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;296;730.7432,-2476.895;Inherit;False;Property;_OffsetXYSpeed;Offset (XY = Speed);14;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;391;773.2272,-2350.675;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;390;951.9588,-2376.942;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;810.163,-2274.066;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;301;1085.725,-2286.922;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;639.747,-2275.139;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;298;418.7473,-2308.139;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;308;392.11,-2382.102;Inherit;False;307;ProjectionUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;276;1205.973,-2383.209;Inherit;True;Property;_Distortion;Distortion;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;149d5ad66f4b804458821058042fd00d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;1513.813,-2376.854;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;316;1905.393,-2374.575;Inherit;False;UVDistorted;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;322;-970.4081,-2488.461;Inherit;True;Global Blue Noise Sample;-1;;1879;65496ced1d1d0a041969a9ecf9b0b6ad;0;2;8;FLOAT2;0,0;False;10;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;424;1992.092,-1714.68;Inherit;False;Property;_ChromaticAberration;Chromatic Aberration;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;421;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;445;3658.696,-1729.525;Inherit;False;CausticsRegular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;137;2496.7,-2396.027;Float;False;True;-1;2;LitMASWaterCausticsGUI;0;13;AtlasShaders/LitMAS Water/Caustics;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;1;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;7;True;12;all;0;False;True;1;1;False;;1;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;7;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForwardOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;23;Surface;1;638819921712762670;  Blend;2;638996936354394931;Two Sided;2;638819934355759207;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;0;Built-in Fog;0;0;Volumetrics;0;0;DOTS Instancing;0;0;Meta Pass;0;638819934523704958;Extra Pre Pass;0;638819934539342757;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Vertex Position,InvertActionOnDeselection;1;0;0;10;False;True;True;True;False;True;True;True;True;True;False;;True;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;2320.271,-2396.428;Inherit;False;303;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformPositionNode;278;-915.2778,-2116.43;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;313;-1164.487,-2120.856;Inherit;False;311;ReconstructedWorldPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;292;-666.7376,-1982.999;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;451;3274.57,-567.2692;Inherit;False;490;193.209;;2;453;452;Grayscale;0.9729495,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;464;1701.561,-573.1354;Inherit;False;813.3401;359.75;;6;463;469;458;461;460;459;Saturation;1,0,0.9427495,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;446;1704.371,-933.0992;Inherit;False;445;CausticsRegular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;444;1703.272,-856.925;Inherit;False;443;CausticsAntiTile;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;337;1910.954,-932.3484;Inherit;False;Property;_EnableAntiTile;Enable Anti-Tile;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;450;1912.617,-825.5662;Inherit;False;Property;_Falloff;Falloff;6;0;Create;True;0;0;0;False;0;False;1;0;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;449;2190.617,-932.5663;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;452;3562.569,-519.2691;Inherit;False;Property;_Grayscale;Grayscale;18;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;453;3354.57,-455.2692;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;455;2835.561,-440.1354;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;456;2563.562,-424.1354;Inherit;False;Property;_ContrastIntensity;Contrast Intensity;22;0;Create;True;0;0;0;False;0;False;1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;459;2130.562,-525.1354;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;460;2002.562,-525.1354;Inherit;False;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;461;1778.561,-525.1354;Inherit;False;Constant;_PerceptualWeights;Perceptual Weights;0;0;Create;True;0;0;0;False;0;False;0.2126729,0.7151522,0.072175;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;454;3043.562,-536.1354;Inherit;False;Property;_Contrast;Contrast;21;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;458;2304.562,-525.1354;Inherit;False;Property;_Saturation;Saturation;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;1767.033,-377.5229;Inherit;False;467;CombinedCaustics;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;463;1714.561,-299.1354;Inherit;False;Property;_SaturationIntensity;Saturation Intensity;20;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;468;3776.734,-566.5978;Inherit;False;467;CombinedCaustics;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;470;3949.145,-491.1855;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;467;2357.803,-916.8467;Inherit;False;CombinedCaustics;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;303;4314.153,-509.364;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;275;1225.645,-2460.406;Inherit;False;Property;_DistortionStrength;Distortion Strength;11;0;Create;True;0;0;0;False;0;False;0.2;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;293;1645.457,-2376.07;Inherit;False;Property;_EnableDistortedUVs;Enable Distorted UV's;10;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;421;3388.794,-1733.008;Inherit;False;Property;_ChromaticAberration;Chromatic Aberration;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;328;-94.81219,-2442.753;Inherit;False;Property;_EnableBlueNoise;Enable Blue Noise;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;466;4001.698,-565.4567;Inherit;False;Property;_EnablePostProcessing;Enable Post Processing;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;326;-682.4075,-2392.46;Inherit;False;Property;_NoiseDefusion;Noise Defusion;16;0;Create;True;1;Blue Noise;0;0;False;0;False;0.025;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;284;-648.1937,-2046.927;Inherit;False;Property;_CircleMask;Circle Mask;7;0;Create;True;0;0;0;False;0;False;1.5;-1.19;1;20;0;1;FLOAT;0
WireConnection;362;0;273;0
WireConnection;362;1;361;0
WireConnection;270;0;370;0
WireConnection;270;1;266;0
WireConnection;266;0;309;0
WireConnection;266;1;265;0
WireConnection;370;0;371;0
WireConnection;371;0;271;0
WireConnection;272;0;362;0
WireConnection;272;1;270;0
WireConnection;272;2;317;0
WireConnection;272;3;330;0
WireConnection;358;0;359;0
WireConnection;358;1;350;0
WireConnection;358;2;317;0
WireConnection;358;3;330;0
WireConnection;359;0;357;0
WireConnection;359;1;360;0
WireConnection;350;0;271;0
WireConnection;350;1;351;0
WireConnection;351;0;352;0
WireConnection;351;1;353;0
WireConnection;369;0;272;0
WireConnection;368;0;358;0
WireConnection;437;21;427;0
WireConnection;437;20;428;0
WireConnection;437;19;429;0
WireConnection;438;21;430;0
WireConnection;438;20;432;0
WireConnection;438;19;431;0
WireConnection;367;82;398;0
WireConnection;367;5;375;0
WireConnection;376;82;399;0
WireConnection;376;5;378;0
WireConnection;379;0;367;0
WireConnection;379;1;376;0
WireConnection;381;0;415;0
WireConnection;381;1;379;0
WireConnection;381;2;416;0
WireConnection;332;0;396;0
WireConnection;332;1;373;0
WireConnection;349;0;397;0
WireConnection;349;1;374;0
WireConnection;422;21;400;0
WireConnection;422;20;403;0
WireConnection;422;19;402;0
WireConnection;423;21;405;0
WireConnection;423;20;406;0
WireConnection;423;19;407;0
WireConnection;408;0;422;0
WireConnection;408;1;423;0
WireConnection;408;2;417;0
WireConnection;408;3;418;0
WireConnection;425;0;437;0
WireConnection;425;1;438;0
WireConnection;425;2;433;0
WireConnection;425;3;434;0
WireConnection;366;0;332;0
WireConnection;366;1;349;0
WireConnection;260;0;410;0
WireConnection;260;1;366;0
WireConnection;260;2;306;0
WireConnection;443;0;424;0
WireConnection;395;0;331;0
WireConnection;409;0;259;0
WireConnection;401;0;392;0
WireConnection;281;0;280;0
WireConnection;280;0;279;0
WireConnection;279;0;283;0
WireConnection;283;0;282;0
WireConnection;283;1;284;0
WireConnection;283;2;291;0
WireConnection;282;0;278;0
WireConnection;291;0;292;0
WireConnection;305;0;281;0
WireConnection;311;0;267;0
WireConnection;262;0;312;0
WireConnection;263;0;262;0
WireConnection;263;1;261;0
WireConnection;264;0;263;0
WireConnection;307;0;264;0
WireConnection;321;0;326;0
WireConnection;323;0;322;0
WireConnection;324;0;323;0
WireConnection;325;0;324;0
WireConnection;325;1;321;0
WireConnection;325;2;320;0
WireConnection;329;0;328;0
WireConnection;390;0;296;0
WireConnection;390;1;391;0
WireConnection;300;0;295;0
WireConnection;300;1;299;0
WireConnection;301;0;390;0
WireConnection;301;1;300;0
WireConnection;299;0;308;0
WireConnection;299;1;298;0
WireConnection;276;1;301;0
WireConnection;274;0;275;0
WireConnection;274;1;276;0
WireConnection;316;0;293;0
WireConnection;424;1;381;0
WireConnection;424;0;425;0
WireConnection;445;0;421;0
WireConnection;137;2;304;0
WireConnection;278;0;313;0
WireConnection;292;0;278;0
WireConnection;337;1;446;0
WireConnection;337;0;444;0
WireConnection;449;0;337;0
WireConnection;449;2;450;0
WireConnection;452;1;454;0
WireConnection;452;0;453;0
WireConnection;453;0;454;0
WireConnection;455;1;458;0
WireConnection;455;0;456;0
WireConnection;459;0;460;0
WireConnection;459;1;469;0
WireConnection;459;2;463;0
WireConnection;460;0;461;0
WireConnection;460;1;469;0
WireConnection;454;1;458;0
WireConnection;454;0;455;0
WireConnection;458;1;469;0
WireConnection;458;0;459;0
WireConnection;470;0;452;0
WireConnection;467;0;449;0
WireConnection;303;0;466;0
WireConnection;293;0;274;0
WireConnection;421;1;260;0
WireConnection;421;0;408;0
WireConnection;328;0;325;0
WireConnection;466;1;468;0
WireConnection;466;0;470;0
ASEEND*/
//CHKSM=C442B6C517A9877CAAC7472F509825D54EC4A1B9