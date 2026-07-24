// Made with Amplify Shader Editor v1.9.9.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AtlasShaders/Luminous Light Volumes/Luminous Volumetric Lightbeam"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _Cutoff("Alpha Cutoff", Range(0, 1)) = 0.5
		[Header(Base Attributes)] _BeamColor( "Beam Color", Color ) = ( 1, 1, 1 )
		[Toggle( _ENABLEWHITEEDGEFALLOFF_ON )] _EnableWhiteEdgeFalloff( "Enable White Edge Falloff", Float ) = 1
		_Transluency( "Transluency", Range( 0, 1 ) ) = 0.75
		[Header(Beam Settings)] _EdgeFalloff( "Edge Falloff", Range( 0, 10 ) ) = 3.5
		_Length( "Length", Range( 0, 1 ) ) = 1
		_LengthFalloff( "Length Falloff", Range( 0, 3 ) ) = 1.5
		[Header(Depth Fade Options)][Toggle( _ENABLESOFTINTERSECTION_ON )] _EnableSoftIntersection( "Enable Soft Intersection", Float ) = 1
		_SoftIntersection( "Soft Intersection", Range( 0, 10 ) ) = 1
		[Toggle( _ENABLECAMERADEPTHFADING_ON )] _EnableCameraDepthFading( "Enable Camera Depth Fading", Float ) = 1
		_Falloff( "Falloff", Range( 0, 0.5 ) ) = 0.2
		_Distance( "Distance", Range( 0, 1 ) ) = 0.1
		[Header(3D Noise)][Toggle( _ENABLE3DNOISE_ON )] _Enable3DNoise( "Enable 3D Noise", Float ) = 0
		_3DNoiseIntensity( "3D Noise Intensity", Range( 0.5, 5 ) ) = 2
		[NoScaleOffset] _3DNoise( "3D Noise", 3D ) = "white" {}
		[Toggle( _WORLDSPACENOISE_ON )] _WorldSpaceNoise( "World Space Noise", Float ) = 1
		_3DNoiseTiling( "3D Noise Tiling", Range( 0.0001, 1 ) ) = 0.1
		_3DNoiseSpeed( "3D Noise Speed", Range( 0.01, 1 ) ) = 0.025
		[Toggle( _FACTORNOISEINTOALPHA_ON )] _FactorNoiseIntoAlpha( "Factor Noise Into Alpha", Float ) = 0
		_3DNoiseAlphaFalloff( "3D Noise Alpha Falloff", Range( 0, 4 ) ) = 0
		[Header(Blue Noise)][Toggle( _ENABLEBLUENOISE_ON )] _EnableBlueNoise( "Enable Blue Noise", Float ) = 1
		_BlueNoise( "Blue Noise", Range( 0, 10 ) ) = 10
		[Header(Quest Depth Fade)] _QuestDepthFade( "Quest Depth Fade", Range( 0, 3 ) ) = 0.025
		[Toggle( _PCDEBUG_ON )] _PCDebug( "PC Debug", Float ) = 0

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
		
		Cull Back
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
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			
			#pragma multi_compile_instancing
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			
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


			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLEWHITEEDGEFALLOFF_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _PCDEBUG_ON
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
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float3 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _BlueNoise;
			float _SoftIntersection;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _3DNoiseAlphaFalloff;
			float _QuestDepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler3D _3DNoise;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g4( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g80( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g78( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_normalWS = TransformObjectToWorldNormal( v.ase_normal );
				o.ase_texcoord4.xyz = ase_normalWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord5 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord4.w = eyeDepth;
				
				o.ase_texcoord3 = v.vertex;
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

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag ( VertexOutput IN
				#ifdef ASE_DEPTH_WRITE_ON
				, out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
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
				float4 temp_cast_0 = (1.0).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord3.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float4 Noise3D112 = ( tex3D( _3DNoise, appendResult104 ) * _3DNoiseIntensity );
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch95 = Noise3D112;
				#else
				float4 staticSwitch95 = temp_cast_0;
				#endif
				float3 temp_cast_1 = (0.5).xxx;
				float3 BeamColor143 = _BeamColor;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord4.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				int One222 = 1;
				float3 temp_cast_2 = One222;
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult234 = lerp( BlueNoise133 , float3( 1,1,1 ) , distanceDepth34);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch60 = ( lerpResult234 * distanceDepth34 );
				#else
				float3 staticSwitch60 = temp_cast_2;
				#endif
				float3 DepthFade63 = staticSwitch60;
				float eyeDepth = IN.ase_texcoord4.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float4 temp_cast_5 = One222;
				float4 temp_cast_6 = One222;
				float4 temp_cast_7 = (_3DNoiseAlphaFalloff).xxxx;
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_7 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_6;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_5;
				#endif
				float4 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * float4( DepthFade63 , 0.0 ) * DepthFadeCamera64 * LengthLimit136 * staticSwitch227 );
				float3 lerpResult7 = lerp( temp_cast_1 , BeamColor143 , AlphaMult178.rgb);
				#ifdef _ENABLEWHITEEDGEFALLOFF_ON
				float3 staticSwitch147 = lerpResult7;
				#else
				float3 staticSwitch147 = ( lerpResult7 * BeamColor143 );
				#endif
				float4 Color186 = ( staticSwitch95 * float4( staticSwitch147 , 0.0 ) );
				
				float4 Alpha176 = saturate( AlphaMult178 );
				
				float4 unityObjectToClipPos20_g79 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord3.xyz ).xyz ) );
				float2 screenUV27_g80 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g80 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g80 = GetScreenNoiseRGBASlice27_g80( screenUV27_g80 , offsetFrame27_g80 );
				float4 temp_output_23_0_g79 = localGetScreenNoiseRGBASlice27_g80;
				float temp_output_21_0_g79 = ( unityObjectToClipPos20_g79.w + ( (temp_output_23_0_g79).w * 0.0 ) );
				float lerpResult5_g79 = lerp( ( ( (temp_output_23_0_g79).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g77 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord3.xyz ).xyz ) );
				float2 screenUV27_g78 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g78 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g78 = GetScreenNoiseRGBASlice27_g78( screenUV27_g78 , offsetFrame27_g78 );
				float4 temp_output_23_0_g77 = localGetScreenNoiseRGBASlice27_g78;
				float temp_output_21_0_g77 = ( unityObjectToClipPos20_g77.w + ( (temp_output_23_0_g77).w * _QuestDepthFade ) );
				float lerpResult5_g77 = lerp( ( ( (temp_output_23_0_g77).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_198_0 = ( ( ( 1.0 - ( temp_output_21_0_g77 * _ZBufferParams.w ) ) / ( temp_output_21_0_g77 * _ZBufferParams.z ) ) * ceil( lerpResult5_g77 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch195 = temp_output_198_0;
				#else
				float staticSwitch195 = ( ( ( 1.0 - ( temp_output_21_0_g79 * _ZBufferParams.w ) ) / ( temp_output_21_0_g79 * _ZBufferParams.z ) ) * ceil( lerpResult5_g79 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch196 = temp_output_198_0;
				#else
				float staticSwitch196 = staticSwitch195;
				#endif
				float QuestDepthFade197 = staticSwitch196;
				
				half3 BakedAlbedo = 0;
				half3 BakedEmission = 0;
				half3 Color = Color186.rgb;
				half Alpha = Alpha176.r;
				half AlphaClipThreshold = 0.5;
				half AlphaClipThresholdShadow = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade197;
				#endif

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

				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif

				return output;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float3 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _BlueNoise;
			float _SoftIntersection;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _3DNoiseAlphaFalloff;
			float _QuestDepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler3D _3DNoise;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g4( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_normalWS = TransformObjectToWorldNormal( v.ase_normal );
				o.ase_texcoord2.xyz = ase_normalWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord3 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord2.w = eyeDepth;
				
				o.ase_texcoord4 = v.vertex;
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

				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord2.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				int One222 = 1;
				float3 temp_cast_0 = One222;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult234 = lerp( BlueNoise133 , float3( 1,1,1 ) , distanceDepth34);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch60 = ( lerpResult234 * distanceDepth34 );
				#else
				float3 staticSwitch60 = temp_cast_0;
				#endif
				float3 DepthFade63 = staticSwitch60;
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord4.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float4 temp_cast_3 = One222;
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord4.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float4 Noise3D112 = ( tex3D( _3DNoise, appendResult104 ) * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_5 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_4;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_3;
				#endif
				float4 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * float4( DepthFade63 , 0.0 ) * DepthFadeCamera64 * LengthLimit136 * staticSwitch227 );
				float4 Alpha176 = saturate( AlphaMult178 );
				
				float Alpha = Alpha176.r;
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
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
#pragma multi_compile_instancing#define _RECEIVE_SHADOWS_OFF 1#define ASE_DEPTH_WRITE_ON#define ASE_VERSION 19908#define ASE_SRP_VERSION -1#define REQUIRE_DEPTH_TEXTURE 1
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


			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLEWHITEEDGEFALLOFF_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
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
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float3 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _BlueNoise;
			float _SoftIntersection;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _3DNoiseAlphaFalloff;
			float _QuestDepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler3D _3DNoise;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g4( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_normalWS = TransformObjectToWorldNormal( v.ase_normal );
				o.ase_texcoord4.xyz = ase_normalWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord5 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord4.w = eyeDepth;
				
				o.ase_texcoord3 = v.vertex;
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
				float4 temp_cast_0 = (1.0).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord3.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float4 Noise3D112 = ( tex3D( _3DNoise, appendResult104 ) * _3DNoiseIntensity );
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch95 = Noise3D112;
				#else
				float4 staticSwitch95 = temp_cast_0;
				#endif
				float3 temp_cast_1 = (0.5).xxx;
				float3 BeamColor143 = _BeamColor;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord4.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				int One222 = 1;
				float3 temp_cast_2 = One222;
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult234 = lerp( BlueNoise133 , float3( 1,1,1 ) , distanceDepth34);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch60 = ( lerpResult234 * distanceDepth34 );
				#else
				float3 staticSwitch60 = temp_cast_2;
				#endif
				float3 DepthFade63 = staticSwitch60;
				float eyeDepth = IN.ase_texcoord4.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float4 temp_cast_5 = One222;
				float4 temp_cast_6 = One222;
				float4 temp_cast_7 = (_3DNoiseAlphaFalloff).xxxx;
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_7 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_6;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_5;
				#endif
				float4 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * float4( DepthFade63 , 0.0 ) * DepthFadeCamera64 * LengthLimit136 * staticSwitch227 );
				float3 lerpResult7 = lerp( temp_cast_1 , BeamColor143 , AlphaMult178.rgb);
				#ifdef _ENABLEWHITEEDGEFALLOFF_ON
				float3 staticSwitch147 = lerpResult7;
				#else
				float3 staticSwitch147 = ( lerpResult7 * BeamColor143 );
				#endif
				float4 Color186 = ( staticSwitch95 * float4( staticSwitch147 , 0.0 ) );
				
				float4 Alpha176 = saturate( AlphaMult178 );
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = Color186.rgb;
				float Alpha = Alpha176.r;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

        
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
        
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
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
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float3 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _BlueNoise;
			float _SoftIntersection;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _3DNoiseAlphaFalloff;
			float _QuestDepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler3D _3DNoise;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g4( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			

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


				float3 ase_positionWS = TransformObjectToWorld( ( v.vertex ).xyz );
				o.ase_texcoord.xyz = ase_positionWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( v.ase_normal );
				o.ase_texcoord1.xyz = ase_normalWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord2 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord.w = eyeDepth;
				
				o.ase_texcoord3 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
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
				float3 ase_positionWS = IN.ase_texcoord.xyz;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord1.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				int One222 = 1;
				float3 temp_cast_0 = One222;
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult234 = lerp( BlueNoise133 , float3( 1,1,1 ) , distanceDepth34);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch60 = ( lerpResult234 * distanceDepth34 );
				#else
				float3 staticSwitch60 = temp_cast_0;
				#endif
				float3 DepthFade63 = staticSwitch60;
				float eyeDepth = IN.ase_texcoord.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float4 temp_cast_3 = One222;
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = ase_positionWS;
				#else
				float3 staticSwitch109 = IN.ase_texcoord3.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float4 Noise3D112 = ( tex3D( _3DNoise, appendResult104 ) * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_5 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_4;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_3;
				#endif
				float4 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * float4( DepthFade63 , 0.0 ) * DepthFadeCamera64 * LengthLimit136 * staticSwitch227 );
				float4 Alpha176 = saturate( AlphaMult178 );
				
				surfaceDescription.Alpha = Alpha176.r;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1


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
        
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
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
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float3 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _BlueNoise;
			float _SoftIntersection;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _3DNoiseAlphaFalloff;
			float _QuestDepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler3D _3DNoise;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g4( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			

        
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


				float3 ase_positionWS = TransformObjectToWorld( ( v.vertex ).xyz );
				o.ase_texcoord.xyz = ase_positionWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( v.ase_normal );
				o.ase_texcoord1.xyz = ase_normalWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord2 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord.w = eyeDepth;
				
				o.ase_texcoord3 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
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
				float3 ase_positionWS = IN.ase_texcoord.xyz;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord1.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				int One222 = 1;
				float3 temp_cast_0 = One222;
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult234 = lerp( BlueNoise133 , float3( 1,1,1 ) , distanceDepth34);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch60 = ( lerpResult234 * distanceDepth34 );
				#else
				float3 staticSwitch60 = temp_cast_0;
				#endif
				float3 DepthFade63 = staticSwitch60;
				float eyeDepth = IN.ase_texcoord.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float4 temp_cast_3 = One222;
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = ase_positionWS;
				#else
				float3 staticSwitch109 = IN.ase_texcoord3.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float4 Noise3D112 = ( tex3D( _3DNoise, appendResult104 ) * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_5 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_4;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_3;
				#endif
				float4 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * float4( DepthFade63 , 0.0 ) * DepthFadeCamera64 * LengthLimit136 * staticSwitch227 );
				float4 Alpha176 = saturate( AlphaMult178 );
				
				surfaceDescription.Alpha = Alpha176.r;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			
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
        
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
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
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float3 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _BlueNoise;
			float _SoftIntersection;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _3DNoiseAlphaFalloff;
			float _QuestDepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler3D _3DNoise;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g4( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
      
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

				float3 ase_positionWS = TransformObjectToWorld( ( v.vertex ).xyz );
				o.ase_texcoord1.xyz = ase_positionWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord2 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord1.w = eyeDepth;
				
				o.ase_texcoord3 = v.vertex;
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
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float dotResult3 = dot( ase_viewDirWS , IN.normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				int One222 = 1;
				float3 temp_cast_0 = One222;
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult234 = lerp( BlueNoise133 , float3( 1,1,1 ) , distanceDepth34);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch60 = ( lerpResult234 * distanceDepth34 );
				#else
				float3 staticSwitch60 = temp_cast_0;
				#endif
				float3 DepthFade63 = staticSwitch60;
				float eyeDepth = IN.ase_texcoord1.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float4 temp_cast_3 = One222;
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = ase_positionWS;
				#else
				float3 staticSwitch109 = IN.ase_texcoord3.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float4 Noise3D112 = ( tex3D( _3DNoise, appendResult104 ) * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_5 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_4;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_3;
				#endif
				float4 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * float4( DepthFade63 , 0.0 ) * DepthFadeCamera64 * LengthLimit136 * staticSwitch227 );
				float4 Alpha176 = saturate( AlphaMult178 );
				
				surfaceDescription.Alpha = Alpha176.r;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

        
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
        
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
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
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
        
			CBUFFER_START(UnityPerMaterial)
			float3 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _BlueNoise;
			float _SoftIntersection;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _3DNoiseAlphaFalloff;
			float _QuestDepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler3D _3DNoise;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g4( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			

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

				float3 ase_positionWS = TransformObjectToWorld( ( v.vertex ).xyz );
				o.ase_texcoord1.xyz = ase_positionWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord2 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord1.w = eyeDepth;
				
				o.ase_texcoord3 = v.vertex;
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
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float dotResult3 = dot( ase_viewDirWS , IN.normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				int One222 = 1;
				float3 temp_cast_0 = One222;
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult234 = lerp( BlueNoise133 , float3( 1,1,1 ) , distanceDepth34);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch60 = ( lerpResult234 * distanceDepth34 );
				#else
				float3 staticSwitch60 = temp_cast_0;
				#endif
				float3 DepthFade63 = staticSwitch60;
				float eyeDepth = IN.ase_texcoord1.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float4 temp_cast_3 = One222;
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = ase_positionWS;
				#else
				float3 staticSwitch109 = IN.ase_texcoord3.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float4 Noise3D112 = ( tex3D( _3DNoise, appendResult104 ) * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_5 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_4;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_3;
				#endif
				float4 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * float4( DepthFade63 , 0.0 ) * DepthFadeCamera64 * LengthLimit136 * staticSwitch227 );
				float4 Alpha176 = saturate( AlphaMult178 );
				
				surfaceDescription.Alpha = Alpha176.r;
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
	
	CustomEditor "UnityEditor.ShaderGraphUnlitGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19908
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-1539.411,-25.02447;Inherit;False;1594.626;341.2918;Handling of 3D Noise;15;112;127;128;109;106;100;94;111;105;104;102;103;110;101;108;3D Noise;1,0,0.3390222,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-1520,16;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;-1520,160;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1328,16;Inherit;False;Property;_WorldSpaceNoise;World Space Noise;14;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;-1216,224;Inherit;False;Property;_3DNoiseSpeed;3D Noise Speed;16;0;Create;True;0;0;0;False;0;False;0.025;0.3;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;132;-2608,672;Inherit;False;1174.123;156.3527;;4;133;189;41;239;Blue Noise;0.3349057,0.7946209,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-2768,720;Inherit;False;Property;_BlueNoise;Blue Noise;20;0;Create;True;0;0;0;False;0;False;10;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-1056,16;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-1216,144;Inherit;False;Property;_3DNoiseTiling;3D Noise Tiling;15;0;Create;True;0;0;0;False;0;False;0.1;0.2;0.0001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-928,224;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;239;-2480,720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-735.4388,134.9755;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-896,128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-896,16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-2336,720;Inherit;False;Blue Noise Diffusion;-1;;2;5e6df176aa279d846818294540ea1f3f;0;1;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;135;-2835.207,-444.115;Inherit;False;1258.726;359.8922;;10;136;80;174;173;172;84;85;83;89;73;Length Limiter;0.3820755,1,0.4680587,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-2230.756,239.7418;Inherit;False;671;382.4999;Mask setup for beam;5;92;91;3;4;2;Beam Mask;1,0.6099074,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-720,16;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;189;-1920,720;Inherit;False;Property;_EnableBlueNoise;Enable Blue Noise;19;0;Create;True;0;0;0;False;1;Header(Blue Noise);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-1492.544,-441.8547;Inherit;False;1158.052;324.533;Depth fading options for realistic beam behavior;7;64;58;56;55;61;57;238;Register Depth Faders;1,0,0.217732,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-2210.256,479.242;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-2775.365,-301.6229;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;-2820.207,-393.5437;Inherit;False;Property;_Length;Length;4;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;-576,16;Inherit;True;Property;_3DNoise;3D Noise;13;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;bdcd046c508f95a46b93458a4ed846f7;bdcd046c508f95a46b93458a4ed846f7;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;False;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;-576,208;Inherit;False;Property;_3DNoiseIntensity;3D Noise Intensity;12;0;Create;True;0;0;0;False;0;False;2;1;0.5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;-1648,720;Inherit;False;BlueNoise;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;226;-2480,1408;Inherit;False;436;163;;2;223;222;One;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-1568,-848;Inherit;False;Property;_SoftIntersection;Soft Intersection;7;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;-1475.744,-281.8546;Inherit;False;Property;_Falloff;Falloff;9;0;Create;True;0;0;0;False;0;False;0.2;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-1475.744,-201.8546;Inherit;False;Property;_Distance;Distance;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-2208.756,287.7419;Float;True;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-1988.656,425.4263;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-2554.309,-394.1151;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-2587.365,-300.6229;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;172;-2411.813,-296.0561;Inherit;False;Property;_LengthFalloff;Length Falloff;5;0;Create;True;0;0;0;False;0;False;1.5;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;127;-288,16;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-1264,-848;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;134;-1264,-704;Inherit;False;133;BlueNoise;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;223;-2432,1456;Inherit;False;Constant;_One;One;22;0;Create;True;0;0;0;False;0;False;1;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.CameraDepthFade, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-1203.744,-265.8546;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;175;-1296,880;Inherit;False;1916.172;965.5122;Handling of alpha output;19;225;228;221;227;220;224;219;176;47;178;40;10;68;137;66;11;5;65;93;Alpha;0,1,0.9731083,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-1941.755,288.0418;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;173;-2140.413,-295.2561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.0001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-2413.365,-396.6229;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-144,16;Inherit;False;Noise3D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;222;-2288,1456;Inherit;False;One;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;234;-992,-752;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;174;-2016.512,-398.7558;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-960.7437,-265.8546;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-1741.655,287.4262;Inherit;False;BeamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;219;-1168,1568;Inherit;False;112;Noise3D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;225;-1264,1648;Inherit;False;Property;_3DNoiseAlphaFalloff;3D Noise Alpha Falloff;18;0;Create;True;0;0;0;False;0;False;0;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;237;-866.4523,-933.9307;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;238;-1024,-352;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;236;-768,-688;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-803.7437,-281.8546;Inherit;False;Property;_EnableCameraDepthFading;Enable Camera Depth Fading;8;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;-1898.981,-399.3061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-688,1008;Inherit;False;92;BeamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;224;-976,1568;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;221;-976,1488;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-656,-848;Inherit;False;Property;_EnableSoftIntersection;Enable Soft Intersection;6;0;Create;True;0;0;0;False;1;Header(Depth Fade Options);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;136;-1764.65,-398.4165;Inherit;False;LengthLimit;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-539.9435,-281.8546;Inherit;False;DepthFadeCamera;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-496,1008;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-640,928;Float;False;Property;_EdgeFalloff;Edge Falloff;3;1;[Header];Create;True;1;Beam Settings;0;0;False;0;False;3.5;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;220;-784,1488;Inherit;False;Property;_FactorNoiseIntoAlpha;Factor Noise Into Alpha;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;228;-688,1584;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-368,-848;Inherit;False;DepthFade;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;68;-480,1152;Inherit;False;Property;_Transluency;Transluency;2;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-336,928;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;-416,1328;Inherit;False;64;DepthFadeCamera;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;137;-384,1408;Inherit;False;136;LengthLimit;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;227;-480,1488;Inherit;False;Property;_FactorNoiseIntoAlpha;Factor Noise Into Alpha;11;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;95;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;-400,1232;Inherit;False;63;DepthFade;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-112,928;Inherit;False;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;178;32,928;Inherit;False;AlphaMult;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;240,928;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;188;-1285.949,378.2485;Inherit;False;1207.179;436.6383;Calculate color output;14;186;99;113;95;184;185;147;146;181;9;179;183;7;131;Color;0,0.5004339,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;182;-2221.25,-37.66224;Inherit;False;402.0696;227.1717;;2;143;8;Register Color;1,0.9888224,0.08018869,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;194;-2736,880;Inherit;False;1378.496;251.9352;;7;201;200;199;198;197;196;195;Quest Depth Fade;1,0.3646275,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;176;384,928;Inherit;False;Alpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;240;-944,-560;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;241;-736.5137,-517.0071;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;143;-2007.182,12.33772;Inherit;False;BeamColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;131;-846.7093,429.0157;Float;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-1021.899,580.1848;Inherit;False;3;0;FLOAT3;0.5,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;183;-1271.849,662.7379;Inherit;False;143;BeamColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;179;-1269.69,737.7869;Inherit;False;178;AlphaMult;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-1244.466,581.5088;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;181;-1039.762,697.3157;Inherit;False;143;BeamColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;-846.6217,579.5365;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;-696.3622,578.5692;Inherit;False;Property;_EnableWhiteEdgeFalloff;Enable White Edge Falloff;1;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;185;-747.8494,668.7379;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;184;-861.8494,670.7379;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-692.2535,429.6743;Inherit;False;Property;_Enable3DNoise;Enable 3D Noise;11;0;Create;True;0;0;0;False;1;Header(3D Noise);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;195;-2032,928;Inherit;False;Property;_SHADER_API_MOBILE;SHADER_API_MOBILE;33;0;Create;True;0;0;0;False;0;False;0;0;0;False;SHADER_API_MOBILE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;196;-1776,928;Inherit;False;Property;_PCDebug;PC Debug;22;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;197;-1568,928;Inherit;False;QuestDepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;198;-2416,1024;Inherit;False;BlueNoiseFakeTransparencyDepthOffset;-1;;77;e0e0f8e10bf068a43b805df662b593ba;0;2;1;FLOAT;1;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;199;-2416,928;Inherit;False;BlueNoiseFakeTransparencyDepthOffset;-1;;79;e0e0f8e10bf068a43b805df662b593ba;0;2;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;200;-1840,1024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;201;-2704,1024;Inherit;False;Property;_QuestDepthFade;Quest Depth Fade;21;1;[Header];Create;True;1;Quest Depth Fade;0;0;False;0;False;0.025;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-880,496;Inherit;False;112;Noise3D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;187;-192,-432;Inherit;False;186;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;177;-193.6165,-354.9323;Inherit;False;176;Alpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;212;-224,-272;Inherit;False;197;QuestDepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-2210.25,12.50941;Float;False;Property;_BeamColor;Beam Color;0;1;[Header];Create;True;1;Base Attributes;0;0;False;0;False;1,1,1,1;0.04811453,0.3712184,0.9272981,1;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;186;-304,432;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-448,432;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;202;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;204;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;205;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;206;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;207;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;False;;True;True;0;False;;0;False;;False;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;208;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;209;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;ScenePickingPass;0;7;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;210;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;DepthNormals;0;8;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=DepthNormalsOnly;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;211;-8.438074,-433.7911;Float;False;False;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;6cdc246191bcab64b98a12a2f745caec;True;DepthNormalsOnly;0;9;DepthNormalsOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=DepthNormalsOnly;False;True;9;d3d11;metal;vulkan;xboxone;xboxseries;playstation;ps4;ps5;switch;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;203;-16,-432;Float;False;True;-1;3;UnityEditor.ShaderGraphUnlitGUI;0;13;AtlasShaders/Luminous Light Volumes/Luminous Volumetric Lightbeam;6cdc246191bcab64b98a12a2f745caec;True;Forward;0;1;Forward;9;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;_Cull;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;7;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;0;False;;True;True;0;False;;0;False;;False;True;1;LightMode=UniversalForwardOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;24;Surface;1;639204507953498148;  Blend;0;0;Two Sided;1;0;Cast Shadows;0;639204507965218770;  Use Shadow Threshold;0;0;Receive Shadows;0;639204507969979213;GPU Instancing;1;0;LOD CrossFade;0;0;Built-in Fog;0;0;Volumetrics;0;0;DOTS Instancing;0;0;Meta Pass;0;0;Extra Pre Pass;0;0;Tessellation;0;0;Write Depth;1;639204507984265845;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Vertex Position;1;0;0;10;False;True;False;True;False;True;True;True;True;True;False;;False;0
WireConnection;109;1;108;0
WireConnection;109;0;101;0
WireConnection;110;0;109;0
WireConnection;105;0;106;0
WireConnection;239;0;43;0
WireConnection;111;0;105;0
WireConnection;102;0;110;2
WireConnection;102;1;100;0
WireConnection;103;0;110;0
WireConnection;103;1;100;0
WireConnection;41;8;239;0
WireConnection;104;0;103;0
WireConnection;104;1;102;0
WireConnection;104;2;111;0
WireConnection;189;0;41;0
WireConnection;94;1;104;0
WireConnection;133;0;189;0
WireConnection;91;0;4;0
WireConnection;89;0;73;0
WireConnection;83;0;85;0
WireConnection;127;0;94;0
WireConnection;127;1;128;0
WireConnection;34;0;35;0
WireConnection;57;0;55;0
WireConnection;57;1;56;0
WireConnection;3;0;2;0
WireConnection;3;1;91;0
WireConnection;173;0;172;0
WireConnection;84;0;89;0
WireConnection;84;1;83;0
WireConnection;112;0;127;0
WireConnection;222;0;223;0
WireConnection;234;0;134;0
WireConnection;234;2;34;0
WireConnection;174;0;84;0
WireConnection;174;1;173;0
WireConnection;58;0;57;0
WireConnection;92;0;3;0
WireConnection;236;0;234;0
WireConnection;236;1;34;0
WireConnection;61;1;238;0
WireConnection;61;0;58;0
WireConnection;80;0;174;0
WireConnection;224;0;219;0
WireConnection;224;2;225;0
WireConnection;60;1;237;0
WireConnection;60;0;236;0
WireConnection;136;0;80;0
WireConnection;64;0;61;0
WireConnection;5;0;93;0
WireConnection;220;1;221;0
WireConnection;220;0;224;0
WireConnection;63;0;60;0
WireConnection;10;0;5;0
WireConnection;10;1;11;0
WireConnection;227;1;228;0
WireConnection;227;0;220;0
WireConnection;40;0;10;0
WireConnection;40;1;68;0
WireConnection;40;2;65;0
WireConnection;40;3;66;0
WireConnection;40;4;137;0
WireConnection;40;5;227;0
WireConnection;178;0;40;0
WireConnection;47;0;178;0
WireConnection;176;0;47;0
WireConnection;240;0;134;0
WireConnection;240;2;57;0
WireConnection;241;0;240;0
WireConnection;241;1;57;0
WireConnection;143;0;8;0
WireConnection;7;0;9;0
WireConnection;7;1;183;0
WireConnection;7;2;179;0
WireConnection;146;0;7;0
WireConnection;146;1;181;0
WireConnection;147;1;146;0
WireConnection;147;0;185;0
WireConnection;185;0;184;0
WireConnection;184;0;7;0
WireConnection;95;1;131;0
WireConnection;95;0;113;0
WireConnection;195;1;199;0
WireConnection;195;0;198;0
WireConnection;196;1;195;0
WireConnection;196;0;200;0
WireConnection;197;0;196;0
WireConnection;198;2;201;0
WireConnection;200;0;198;0
WireConnection;186;0;99;0
WireConnection;99;0;95;0
WireConnection;99;1;147;0
WireConnection;203;2;187;0
WireConnection;203;3;177;0
WireConnection;203;8;212;0
ASEEND*/
//CHKSM=5B2D5A4D3FC8C3C20CB3E21F336BE12196BBA478