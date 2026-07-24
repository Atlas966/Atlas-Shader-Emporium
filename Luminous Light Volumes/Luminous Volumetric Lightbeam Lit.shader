// Made with Amplify Shader Editor v1.9.9.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AtlasShaders/Luminous Light Volumes/Luminous Volumetric Lightbeam Lit"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _Cutoff("Alpha Cutoff", Range(0, 1)) = 0.5
		[Space(20)][Header(BRDF Lut)][Space(10)][Toggle( _BRDFMAP )] BRDFMAP( "Enable BRDF map", Float ) = 0
		[NoScaleOffset][SingleLineTexture] g_tBRDFMap( "BRDF map", 2D ) = "white" {}
		[Header(Base Attributes)] _BeamColor( "Beam Color", Color ) = ( 1, 1, 1, 1 )
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
		[Header(Blue Noise)][Toggle( _ENABLEBLUENOISE_ON )] _EnableBlueNoise( "Enable Blue Noise", Float ) = 1
		_BlueNoise( "Blue Noise", Range( 0, 10 ) ) = 2
		[Header(Quest Depth Fade)] _QuestDepthFade( "Quest Depth Fade", Range( 0, 3 ) ) = 0.025
		[Toggle( _PCDEBUG_ON )] _PCDebug( "PC Debug", Float ) = 0

		[HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
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
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off
		
		HLSLINCLUDE
		#pragma target 3.0

		#pragma prefer_hlslcc gles
		

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
			Tags { "LightMode"="UniversalForward" }
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ColorMask RGBA
			

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLEWHITEEDGEFALLOFF_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DefaultLitVariants.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif



			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _QuestDepthFade;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
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
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord9.x = eyeDepth;
				
				o.ase_texcoord8 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.yzw = 0;
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
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
				o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif
				
				
				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL) || defined(ASE_TERRAIN_INSTANCING)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				
				o.clipPos = positionCS;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				o.screenPos = ComputeScreenPos(positionCS);
				#endif
				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
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
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
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
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif
				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif
	
				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float4 temp_cast_0 = (1.0).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord8.xyz;
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
				float4 temp_cast_1 = (0.5).xxxx;
				float4 BeamColor143 = _BeamColor;
				float dotResult3 = dot( WorldViewDirection , WorldNormal );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float4 ase_positionSSNorm = ScreenPos / ScreenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ScreenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord9.x;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord8.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float4 lerpResult7 = lerp( temp_cast_1 , BeamColor143 , float4( AlphaMult178 , 0.0 ));
				#ifdef _ENABLEWHITEEDGEFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = ( lerpResult7 * BeamColor143 );
				#endif
				float4 Color186 = ( staticSwitch95 * staticSwitch147 );
				
				float3 Alpha176 = saturate( AlphaMult178 );
				
				float4 unityObjectToClipPos20_g79 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g80 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g80 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g80 = GetScreenNoiseRGBASlice27_g80( screenUV27_g80 , offsetFrame27_g80 );
				float4 temp_output_23_0_g79 = localGetScreenNoiseRGBASlice27_g80;
				float temp_output_21_0_g79 = ( unityObjectToClipPos20_g79.w + ( (temp_output_23_0_g79).w * 0.0 ) );
				float lerpResult5_g79 = lerp( ( ( (temp_output_23_0_g79).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g77 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g78 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g78 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g78 = GetScreenNoiseRGBASlice27_g78( screenUV27_g78 , offsetFrame27_g78 );
				float4 temp_output_23_0_g77 = localGetScreenNoiseRGBASlice27_g78;
				float temp_output_21_0_g77 = ( unityObjectToClipPos20_g77.w + ( (temp_output_23_0_g77).w * _QuestDepthFade ) );
				float lerpResult5_g77 = lerp( ( ( (temp_output_23_0_g77).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_209_0 = ( ( ( 1.0 - ( temp_output_21_0_g77 * _ZBufferParams.w ) ) / ( temp_output_21_0_g77 * _ZBufferParams.z ) ) * ceil( lerpResult5_g77 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch206 = temp_output_209_0;
				#else
				float staticSwitch206 = ( ( ( 1.0 - ( temp_output_21_0_g79 * _ZBufferParams.w ) ) / ( temp_output_21_0_g79 * _ZBufferParams.z ) ) * ceil( lerpResult5_g79 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch207 = temp_output_209_0;
				#else
				float staticSwitch207 = staticSwitch206;
				#endif
				float QuestDepthFade208 = staticSwitch207;
				
				float3 Albedo = Color186.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
#if 0
				float3 BakedEmission = 0;
#endif
				float3 Specular = 0.5;
				float Metallic = (float)0;
				float Smoothness = (float)0;
				float Occlusion = 1;
				float Alpha = Alpha176.x;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade208;
				#endif
				
				#ifdef _CLEARCOAT
				float CoatMask = 0;
				float CoatSmoothness = 0;
				#endif

				#if defined(_FLUORESCENCE)
				float4 Fluorescence = 0;
				float4 Absorbance = 0;
				#endif


				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
					inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
					inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
					inputData.normalWS = Normal;
					#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif


				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzww; //TODO: Shuffle things in vertex streams so we get full RGBA color rather than RGBB here
				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)

				#ifdef LIGHTMAP_ON
				float4 encodedGI =  SAMPLE_GI_DIR(IN.lightmapUVOrVertexSH.xyz, IN.dynamicLightmapUV.xy, IN.vertexSH, inputData.normalWS, Smoothness, WorldViewDirection);
				inputData.bakedGI = encodedGI.rgb;
				float BakedSpecular = encodedGI.w;

				#else
				inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, IN.vertexSH , inputData.normalWS);
				#endif

				#else
				#ifdef LIGHTMAP_ON
				float4 encodedGI = SAMPLE_GI_DIR(IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS, Smoothness, WorldViewDirection);
				inputData.bakedGI = encodedGI.rgb;
				float BakedSpecular = encodedGI.w;

				#else
				inputData.bakedGI = SAMPLE_GI_DIR(IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS, Smoothness, WorldViewDirection);
				#endif				
				#endif



				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				
				inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif

					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = Albedo;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif
				#if defined(_FLUORESCENCE)
					surfaceData.fluorescence 		= Fluorescence;
					surfaceData.absorbance			= Absorbance;
				#endif

				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.clipPos, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);

				#ifdef LIGHTMAP_ON
				float3 MetalSpec = lerp(kDieletricSpec.rgb, surfaceData.albedo , surfaceData.metallic);
				color.rgb += BakedSpecular * surfaceData.occlusion * MetalSpec * inputData.bakedGI.rgb;
				#endif

				#ifdef _TRANSMISSION_ASE
				{
					float shadow = _TransmissionShadow;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += Albedo * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += Albedo * transmission;
						}
					#endif
				}
				#endif

				#ifdef _TRANSLUCENCY_ASE
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );

					half3 mainLightDir = mainLight.direction + inputData.normalWS * normal;
					half mainVdotL = pow( saturate( dot( inputData.viewDirectionWS, -mainLightDir ) ), scattering );
					half3 mainTranslucency = mainAtten * ( mainVdotL * direct + inputData.bakedGI * ambient ) * Translucency;
					color.rgb += Albedo * mainTranslucency * strength;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 lightDir = light.direction + inputData.normalWS * normal;
							half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );
							half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;
							color.rgb += Albedo * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef _REFRACTION_ASE
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, -inputData.viewDirectionWS, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				    color = Volumetrics( color, inputData.positionWS);


				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return color;
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
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _QuestDepthFade;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

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
			

			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

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

				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);


			#if _CASTING_PUNCTUAL_LIGHT_SHADOW
				float3 lightDirectionWS = normalize(_LightPosition - positionWS);
			#else
				float3 lightDirectionWS = _LightDirection;
			#endif
				float2 vShadowOffsets = GetShadowOffsets( normalWS, lightDirectionWS );				
				positionWS.xyz -= vShadowOffsets.y * lightDirectionWS.xyz * .01;
				float4 clipPos = TransformObjectToHClip( float4( mul( unity_WorldToObject, float4( positionWS.xyz, 1.0 ) ).xyz, 1.0 ) );
				//float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));
			
			#if UNITY_REVERSED_Z
				clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
			#else
				clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
			#endif

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
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

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual  
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN 
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
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

				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord2.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord4.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float3 Alpha176 = saturate( AlphaMult178 );
				
				float4 unityObjectToClipPos20_g79 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord4.xyz ).xyz ) );
				float2 screenUV27_g80 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g80 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g80 = GetScreenNoiseRGBASlice27_g80( screenUV27_g80 , offsetFrame27_g80 );
				float4 temp_output_23_0_g79 = localGetScreenNoiseRGBASlice27_g80;
				float temp_output_21_0_g79 = ( unityObjectToClipPos20_g79.w + ( (temp_output_23_0_g79).w * 0.0 ) );
				float lerpResult5_g79 = lerp( ( ( (temp_output_23_0_g79).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g77 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord4.xyz ).xyz ) );
				float2 screenUV27_g78 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g78 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g78 = GetScreenNoiseRGBASlice27_g78( screenUV27_g78 , offsetFrame27_g78 );
				float4 temp_output_23_0_g77 = localGetScreenNoiseRGBASlice27_g78;
				float temp_output_21_0_g77 = ( unityObjectToClipPos20_g77.w + ( (temp_output_23_0_g77).w * _QuestDepthFade ) );
				float lerpResult5_g77 = lerp( ( ( (temp_output_23_0_g77).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_209_0 = ( ( ( 1.0 - ( temp_output_21_0_g77 * _ZBufferParams.w ) ) / ( temp_output_21_0_g77 * _ZBufferParams.z ) ) * ceil( lerpResult5_g77 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch206 = temp_output_209_0;
				#else
				float staticSwitch206 = ( ( ( 1.0 - ( temp_output_21_0_g79 * _ZBufferParams.w ) ) / ( temp_output_21_0_g79 * _ZBufferParams.z ) ) * ceil( lerpResult5_g79 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch207 = temp_output_209_0;
				#else
				float staticSwitch207 = staticSwitch206;
				#endif
				float QuestDepthFade208 = staticSwitch207;
				
				float Alpha = Alpha176.x;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade208;
				#endif

				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
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
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY
        
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _QuestDepthFade;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

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
			half4 frag(	VertexOutput IN 
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
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
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord4.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float3 Alpha176 = saturate( AlphaMult178 );
				
				float4 unityObjectToClipPos20_g79 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord4.xyz ).xyz ) );
				float2 screenUV27_g80 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g80 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g80 = GetScreenNoiseRGBASlice27_g80( screenUV27_g80 , offsetFrame27_g80 );
				float4 temp_output_23_0_g79 = localGetScreenNoiseRGBASlice27_g80;
				float temp_output_21_0_g79 = ( unityObjectToClipPos20_g79.w + ( (temp_output_23_0_g79).w * 0.0 ) );
				float lerpResult5_g79 = lerp( ( ( (temp_output_23_0_g79).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g77 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord4.xyz ).xyz ) );
				float2 screenUV27_g78 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g78 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g78 = GetScreenNoiseRGBASlice27_g78( screenUV27_g78 , offsetFrame27_g78 );
				float4 temp_output_23_0_g77 = localGetScreenNoiseRGBASlice27_g78;
				float temp_output_21_0_g77 = ( unityObjectToClipPos20_g77.w + ( (temp_output_23_0_g77).w * _QuestDepthFade ) );
				float lerpResult5_g77 = lerp( ( ( (temp_output_23_0_g77).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_209_0 = ( ( ( 1.0 - ( temp_output_21_0_g77 * _ZBufferParams.w ) ) / ( temp_output_21_0_g77 * _ZBufferParams.z ) ) * ceil( lerpResult5_g77 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch206 = temp_output_209_0;
				#else
				float staticSwitch206 = ( ( ( 1.0 - ( temp_output_21_0_g79 * _ZBufferParams.w ) ) / ( temp_output_21_0_g79 * _ZBufferParams.z ) ) * ceil( lerpResult5_g79 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch207 = temp_output_209_0;
				#else
				float staticSwitch207 = staticSwitch206;
				#endif
				float QuestDepthFade208 = staticSwitch207;
				
				float Alpha = Alpha176.x;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade208;
				#endif

				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}
		
		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/PlatformCompiler.hlsl"
			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature _ EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLEWHITEEDGEFALLOFF_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
				#ifdef EDITOR_VISUALIZATION
				float4 VizUV : TEXCOORD2;
				float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _QuestDepthFade;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
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
				o.ase_texcoord5.xyz = ase_normalWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord6 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord5.w = eyeDepth;
				
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

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

			#ifdef EDITOR_VISUALIZATION
				float2 VizUV = 0;
				float4 LightCoord = 0;
				UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
				o.VizUV = float4(VizUV, 0, 0);
				o.LightCoord = LightCoord;
			#endif

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
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
				o.texcoord0 = v.texcoord0;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
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
				o.texcoord0 = patch[0].texcoord0 * bary.x + patch[1].texcoord0 * bary.y + patch[2].texcoord0 * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
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

				float4 temp_cast_0 = (1.0).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord4.xyz;
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
				float4 temp_cast_1 = (0.5).xxxx;
				float4 BeamColor143 = _BeamColor;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord5.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float4 screenPos = IN.ase_texcoord6;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord5.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord4.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float4 lerpResult7 = lerp( temp_cast_1 , BeamColor143 , float4( AlphaMult178 , 0.0 ));
				#ifdef _ENABLEWHITEEDGEFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = ( lerpResult7 * BeamColor143 );
				#endif
				float4 Color186 = ( staticSwitch95 * staticSwitch147 );
				
				float3 Alpha176 = saturate( AlphaMult178 );
				
				
				float3 Albedo = Color186.rgb;
				float3 Emission = 0;
				float Alpha = Alpha176.x;
				float AlphaClipThreshold = 0.5;

				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
			#ifdef EDITOR_VISUALIZATION
				metaInput.VizUV = IN.VizUV.xy;
				metaInput.LightCoord = IN.LightCoord;
			#endif
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		/*ase_pass*/
		Pass
		{
			
            Name "BakedRaytrace"
            Tags{ "LightMode" = "BakedRaytrace" }
			HLSLPROGRAM

			/*ase_pragma_before*/

			#define SHADERPASS SHADERPASS_RAYTRACE

            #include "UnityRaytracingMeshUtils.cginc"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#define _EMISSION
            #pragma raytracing test
			#pragma shader_feature_local __ _ALBEDOMULTIPLY_ON
			#pragma shader_feature_local __ _EMISSION_ON

			/*ase_pragma*/

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

            Texture2D<float4> _BaseMap;
            SamplerState sampler_BaseMap;
            
			CBUFFER_START( UnityPerMaterial )
            /*ase_srp_batcher*/
            Texture2D<float4> _EmissionMap;
            SamplerState sampler_EmissionMap;			
 
			float4 _EmissionColor;
			float4 _BaseMap_ST;
			float _BakedMutiplier = 1;
			CBUFFER_END

			/*ase_globals*/

			/*ase_funcs*/
  
            //https://coty.tips/raytracing-in-unity/
            [shader("closesthit")]
            void MyClosestHit(inout RayPayload payload,
                AttributeData attributes : SV_IntersectionAttributes) {

				payload.color = float4(0,0,0,1); //Intializing
				payload.dir = float3(1,0,0);

		//	#if _EMISSION_ON  
                uint2 launchIdx = DispatchRaysIndex();
            //    ShadingData shade = getShadingData( PrimitiveIndex(), attribs );

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

				//TODO: Figure out how to tie Amplify into using Texture2d and SamplerState instead of the bundled sampler2D. Forcing names for now.
			//#if _ALBEDOMULTIPLY_ON
				float4 albedo = float4(_BaseMap.SampleLevel(sampler_BaseMap, vInterpolated.texcoord.xy * _BaseMap_ST.xy + _BaseMap_ST.zw, 0 ).rgb , 1) ;
			// #else
			// 	float4 albedo = float4(1,1,1,1);
			// #endif

                payload.color =  float4( (_EmissionMap.SampleLevel(sampler_EmissionMap, vInterpolated.texcoord *   _BaseMap_ST.xy + _BaseMap_ST.zw,0) ).rgb * _EmissionColor.rgb * albedo.rgb * _BakedMutiplier  , 1 );
			// #else
		    //     payload.color = float4(0,0,0,1);

		 //  #endif
		    }
            ENDHLSL

        }

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ColorMask RGBA

			HLSLPROGRAM
			
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			
			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_2D
        
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLEWHITEEDGEFALLOFF_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
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
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _QuestDepthFade;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
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
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_normalWS = TransformObjectToWorldNormal( v.ase_normal );
				o.ase_texcoord3.xyz = ase_normalWS;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord4 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.w = eyeDepth;
				
				o.ase_texcoord2 = v.vertex;
				
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

				float4 temp_cast_0 = (1.0).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord2.xyz;
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
				float4 temp_cast_1 = (0.5).xxxx;
				float4 BeamColor143 = _BeamColor;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord3.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord3.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord2.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float4 lerpResult7 = lerp( temp_cast_1 , BeamColor143 , float4( AlphaMult178 , 0.0 ));
				#ifdef _ENABLEWHITEEDGEFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = ( lerpResult7 * BeamColor143 );
				#endif
				float4 Color186 = ( staticSwitch95 * staticSwitch147 );
				
				float3 Alpha176 = saturate( AlphaMult178 );
				
				
				float3 Albedo = Color186.rgb;
				float Alpha = Alpha176.x;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
            ZTest LEqual
            ZWrite On

			HLSLPROGRAM
			
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define ASE_VERSION 19908
			#define ASE_SRP_VERSION -1
			#define REQUIRE_DEPTH_TEXTURE 1

			
			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				
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
				float3 worldNormal : TEXCOORD2;
				float4 worldTangent : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _QuestDepthFade;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

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
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord4 = screenPos;
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord5.x = eyeDepth;
				
				o.ase_texcoord6 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.yzw = 0;
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
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 tangentWS = float4(TransformObjectToWorldDir( v.ase_tangent.xyz), v.ase_tangent.w);
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				
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
				o.ase_tangent = v.ase_tangent;
				
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
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				
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
			half4 frag(	VertexOutput IN 
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float dotResult3 = dot( ase_viewDirWS , WorldNormal );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord5.x;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord6.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float3 Alpha176 = saturate( AlphaMult178 );
				
				float4 unityObjectToClipPos20_g79 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord6.xyz ).xyz ) );
				float2 screenUV27_g80 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g80 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g80 = GetScreenNoiseRGBASlice27_g80( screenUV27_g80 , offsetFrame27_g80 );
				float4 temp_output_23_0_g79 = localGetScreenNoiseRGBASlice27_g80;
				float temp_output_21_0_g79 = ( unityObjectToClipPos20_g79.w + ( (temp_output_23_0_g79).w * 0.0 ) );
				float lerpResult5_g79 = lerp( ( ( (temp_output_23_0_g79).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g77 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord6.xyz ).xyz ) );
				float2 screenUV27_g78 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g78 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g78 = GetScreenNoiseRGBASlice27_g78( screenUV27_g78 , offsetFrame27_g78 );
				float4 temp_output_23_0_g77 = localGetScreenNoiseRGBASlice27_g78;
				float temp_output_21_0_g77 = ( unityObjectToClipPos20_g77.w + ( (temp_output_23_0_g77).w * _QuestDepthFade ) );
				float lerpResult5_g77 = lerp( ( ( (temp_output_23_0_g77).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_209_0 = ( ( ( 1.0 - ( temp_output_21_0_g77 * _ZBufferParams.w ) ) / ( temp_output_21_0_g77 * _ZBufferParams.z ) ) * ceil( lerpResult5_g77 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch206 = temp_output_209_0;
				#else
				float staticSwitch206 = ( ( ( 1.0 - ( temp_output_21_0_g79 * _ZBufferParams.w ) ) / ( temp_output_21_0_g79 * _ZBufferParams.z ) ) * ceil( lerpResult5_g79 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch207 = temp_output_209_0;
				#else
				float staticSwitch207 = staticSwitch206;
				#endif
				float QuestDepthFade208 = staticSwitch207;
				
				float3 Normal = float3(0, 0, 1);
				float Alpha = Alpha176.x;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade208;
				#endif

				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				
				#ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
				#endif
				
				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					return half4(packedNormalWS, 0.0);
				#else
					
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif

					return half4(EncodeWSNormalForNormalsTex(NormalizeNormalPerPixel(normalWS)), 0.0);
				#endif
			}
			ENDHLSL
		}

				
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="None" }
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ColorMask RGBA
			

			HLSLPROGRAM
#define _NORMAL_DROPOFF_TS 1#pragma multi_compile_fog#define ASE_FOG 1#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED#define ASE_DEPTH_WRITE_ON#define ASE_VERSION 19908#define ASE_SRP_VERSION -1#define REQUIRE_DEPTH_TEXTURE 1
#if FALSE
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE 
			//_MAIN_LIGHT_SHADOWS_SCREEN
			
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION

			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			//#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile _ _GBUFFER_NORMALS_OCT
			//#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile _ _RENDER_PASS_ENABLED

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"


			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLEWHITEEDGEFALLOFF_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SLZBlueNoise.hlsl"


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
			float _QuestDepthFade;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
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
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord9.x = eyeDepth;
				
				o.ase_texcoord8 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.yzw = 0;
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
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#if defined(DYNAMICLIGHTMAP_ON)
				o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				
				o.clipPos = positionCS;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				o.screenPos = ComputeScreenPos(positionCS);
				#endif
				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
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
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
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
			FragmentOutput frag ( VertexOutput IN 
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif
				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif


	
				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float4 temp_cast_0 = (1.0).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord8.xyz;
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
				float4 temp_cast_1 = (0.5).xxxx;
				float4 BeamColor143 = _BeamColor;
				float dotResult3 = dot( WorldViewDirection , WorldNormal );
				float BeamMask92 = dotResult3;
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float4 ase_positionSSNorm = ScreenPos / ScreenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ScreenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord9.x;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord8.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float4 lerpResult7 = lerp( temp_cast_1 , BeamColor143 , float4( AlphaMult178 , 0.0 ));
				#ifdef _ENABLEWHITEEDGEFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = ( lerpResult7 * BeamColor143 );
				#endif
				float4 Color186 = ( staticSwitch95 * staticSwitch147 );
				
				float3 Alpha176 = saturate( AlphaMult178 );
				
				float4 unityObjectToClipPos20_g79 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g80 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g80 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g80 = GetScreenNoiseRGBASlice27_g80( screenUV27_g80 , offsetFrame27_g80 );
				float4 temp_output_23_0_g79 = localGetScreenNoiseRGBASlice27_g80;
				float temp_output_21_0_g79 = ( unityObjectToClipPos20_g79.w + ( (temp_output_23_0_g79).w * 0.0 ) );
				float lerpResult5_g79 = lerp( ( ( (temp_output_23_0_g79).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g77 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g78 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g78 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g78 = GetScreenNoiseRGBASlice27_g78( screenUV27_g78 , offsetFrame27_g78 );
				float4 temp_output_23_0_g77 = localGetScreenNoiseRGBASlice27_g78;
				float temp_output_21_0_g77 = ( unityObjectToClipPos20_g77.w + ( (temp_output_23_0_g77).w * _QuestDepthFade ) );
				float lerpResult5_g77 = lerp( ( ( (temp_output_23_0_g77).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_209_0 = ( ( ( 1.0 - ( temp_output_21_0_g77 * _ZBufferParams.w ) ) / ( temp_output_21_0_g77 * _ZBufferParams.z ) ) * ceil( lerpResult5_g77 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch206 = temp_output_209_0;
				#else
				float staticSwitch206 = ( ( ( 1.0 - ( temp_output_21_0_g79 * _ZBufferParams.w ) ) / ( temp_output_21_0_g79 * _ZBufferParams.z ) ) * ceil( lerpResult5_g79 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch207 = temp_output_209_0;
				#else
				float staticSwitch207 = staticSwitch206;
				#endif
				float QuestDepthFade208 = staticSwitch207;
				
				float3 Albedo = Color186.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = (float)0;
				float Smoothness = (float)0;
				float Occlusion = 1;
				float Alpha = Alpha176.x;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade208;
				#endif

				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.clipPos;
				inputData.shadowCoord = ShadowCoords;



				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
					inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
					inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
					inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif
					
				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );



				#ifdef ASE_FOG
					inputData.fogCoord = InitializeInputDataFog(float4(WorldPosition, 1.0),  IN.fogFactorAndVertexLight.x);
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				

				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.clipPos,
						Albedo,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(Albedo, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;
				
				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif
				
				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif
				
				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb);
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
        
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
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
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
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
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
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
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float3 Alpha176 = saturate( AlphaMult178 );
				
				surfaceDescription.Alpha = Alpha176.x;
				surfaceDescription.AlphaClipThreshold = 0.5;


				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
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

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
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
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
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
			float4 _BeamColor;
			float _3DNoiseTiling;
			float _3DNoiseSpeed;
			float _3DNoiseIntensity;
			float _EdgeFalloff;
			float _Transluency;
			float _SoftIntersection;
			float _BlueNoise;
			float _Falloff;
			float _Distance;
			float _Length;
			float _LengthFalloff;
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
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth34 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth34 = saturate( abs( ( screenDepth34 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				#ifdef _ENABLESOFTINTERSECTION_ON
				float staticSwitch60 = distanceDepth34;
				#else
				float staticSwitch60 = 1.0;
				#endif
				float DepthFade63 = staticSwitch60;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g4 = (ase_grabScreenPosNorm).xy;
				float offsetFrame27_g4 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g4 = GetScreenNoiseRGBASlice27_g4( screenUV27_g4 , offsetFrame27_g4 );
				#ifdef _ENABLEBLUENOISE_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g4).xyz - float3( 0.5,0.5,0.5 ) ) * ( _BlueNoise * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float eyeDepth = IN.ase_texcoord.w;
				float cameraDepthFade57 = (( eyeDepth -_ProjectionParams.y - _Distance ) / _Falloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch61 = saturate( cameraDepthFade57 );
				#else
				float staticSwitch61 = 1.0;
				#endif
				float DepthFadeCamera64 = staticSwitch61;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 AlphaMult178 = ( pow( clampResult5 , _EdgeFalloff ) * _Transluency * ( DepthFade63 + ( clampResult5 * BlueNoise133 ) ) * DepthFadeCamera64 * LengthLimit136 );
				float3 Alpha176 = saturate( AlphaMult178 );
				
				surfaceDescription.Alpha = Alpha176.x;
				surfaceDescription.AlphaClipThreshold = 0.5;


				#if defined(_ALPHATEST_ON) && !defined(ASE_TERRAIN)
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
		
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19908
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-1492.544,-441.8547;Inherit;False;1158.052;324.533;Depth fading options for realistic beam behavior;13;63;64;58;193;192;59;56;55;35;60;61;34;57;Register Depth Faders;1,0,0.217732,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;175;-1288.922,877.6448;Inherit;False;1229.327;684.6145;Handling of alpha output;20;178;47;176;40;137;66;10;11;68;142;5;134;141;139;49;45;65;93;138;140;Alpha;0,1,0.9731083,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;135;-2835.207,-444.115;Inherit;False;1258.726;359.8922;;10;136;80;174;173;172;84;85;83;89;73;Length Limiter;0.3820755,1,0.4680587,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;132;-2472.916,664.1954;Inherit;False;1123.053;158.1138;;4;133;189;43;41;Blue Noise;0.3349057,0.7946209,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-2230.756,239.7418;Inherit;False;671;382.4999;Mask setup for beam;5;92;91;3;4;2;Beam Mask;1,0.6099074,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-1475.744,-393.8547;Inherit;False;Property;_SoftIntersection;Soft Intersection;10;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-1203.744,-393.8547;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-2210.256,479.242;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-2775.365,-301.6229;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;142;-968.17,1095.9;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;-2820.207,-393.5437;Inherit;False;Property;_Length;Length;7;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-2460.716,717.1954;Inherit;False;Property;_BlueNoise;Blue Noise;21;0;Create;True;0;0;0;False;0;False;2;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-2208.756,287.7419;Float;True;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-1988.656,425.4263;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-2554.309,-394.1151;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-2587.365,-300.6229;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;141;-1076.17,1114.9;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-2198.816,718.2955;Inherit;False;Blue Noise Diffusion;-1;;2;5e6df176aa279d846818294540ea1f3f;0;1;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;192;-976.9519,-327.2974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;172;-2411.813,-296.0561;Inherit;False;Property;_LengthFalloff;Length Falloff;8;0;Create;True;0;0;0;False;0;False;1.5;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;-1475.744,-281.8546;Inherit;False;Property;_Falloff;Falloff;12;0;Create;True;0;0;0;False;0;False;0.2;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-1475.744,-201.8546;Inherit;False;Property;_Distance;Distance;13;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-1203.744,-265.8546;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-1941.755,288.0418;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;138;-1120.17,1170.9;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-962.7437,-392.8547;Inherit;False;Constant;_Float2;Float 2;22;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;193;-864.9519,-328.2974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;189;-1780.577,718.8551;Inherit;False;Property;_EnableBlueNoise;Enable Blue Noise;20;0;Create;True;0;0;0;False;1;Header(Blue Noise);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;173;-2140.413,-295.2561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.0001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-2413.365,-396.6229;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;174;-2016.512,-398.7558;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;140;-1130.17,1262.9;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-806.7437,-393.8547;Inherit;False;Property;_EnableSoftIntersection;Enable Soft Intersection;9;0;Create;True;0;0;0;False;1;Header(Depth Fade Options);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-960.7437,-265.8546;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-1741.655,287.4262;Inherit;False;BeamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;-1533.901,718.6751;Inherit;False;BlueNoise;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-803.7437,-281.8546;Inherit;False;Property;_EnableCameraDepthFading;Enable Camera Depth Fading;11;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;-1898.981,-399.3061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-1277.922,1006.406;Inherit;False;92;BeamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;139;-1079.17,1315.9;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;134;-1228.661,1326.155;Inherit;False;133;BlueNoise;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-523.9436,-393.1547;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;136;-1764.65,-398.4165;Inherit;False;LengthLimit;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;-1090.281,1232.571;Inherit;False;63;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-1044.968,1310.045;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-1092.224,1004.135;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-539.9435,-281.8546;Inherit;False;DepthFadeCamera;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-1220.999,928.6857;Float;False;Property;_EdgeFalloff;Edge Falloff;6;1;[Header];Create;True;1;Beam Settings;0;0;False;0;False;3.5;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-920.6369,1226.187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-936.4994,932.2857;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;-1023.318,1411.466;Inherit;False;64;DepthFadeCamera;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;137;-986.985,1484.495;Inherit;False;136;LengthLimit;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;68;-1070.739,1152.656;Inherit;False;Property;_Transluency;Transluency;5;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-699.8916,931.6737;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;178;-570.9592,931.6657;Inherit;False;AlphaMult;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-384.148,932.6447;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;188;-1285.949,378.2485;Inherit;False;1165.179;441.6383;Calculate color output;14;184;185;147;146;181;9;179;183;7;113;186;99;95;131;Color;0,0.5004339,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;182;-2221.25,-37.66224;Inherit;False;402.0696;227.1717;;2;143;8;Register Color;1,0.9888224,0.08018869,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-1539.411,-25.02447;Inherit;False;1594.626;341.2918;Handling of 3D Noise;15;112;127;128;109;106;100;94;111;105;104;102;103;110;101;108;3D Noise;1,0,0.3390222,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;176;-252.1451,934.1167;Inherit;False;Alpha;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;205;-2736,896;Inherit;False;1378.496;251.9352;;7;212;211;210;209;208;207;206;Quest Depth Fade;1,0.3646275,0,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-1519.439,22.9755;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-1055.439,22.9755;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-879.4388,22.9755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-879.4388,134.9755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-703.4388,22.9755;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-911.4388,230.9759;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-735.4388,134.9755;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;-559.4388,22.9755;Inherit;True;Property;_3DNoise;3D Noise;16;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;bdcd046c508f95a46b93458a4ed846f7;bdcd046c508f95a46b93458a4ed846f7;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;False;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;143;-2007.182,12.33772;Inherit;False;BeamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;131;-846.7093,429.0157;Float;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;177;-193.6165,-354.9323;Inherit;False;176;Alpha;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;187;-197.1949,-434.8115;Inherit;False;186;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;127;-262.2029,23.77666;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-880.245,502.291;Inherit;False;112;Noise3D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-1021.899,580.1848;Inherit;False;3;0;COLOR;0.5,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;183;-1271.849,662.7379;Inherit;False;143;BeamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;179;-1269.69,737.7869;Inherit;False;178;AlphaMult;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-1244.466,581.5088;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;181;-1039.762,697.3157;Inherit;False;143;BeamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;-846.6217,579.5365;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;-696.3622,578.5692;Inherit;False;Property;_EnableWhiteEdgeFalloff;Enable White Edge Falloff;4;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;185;-747.8494,668.7379;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;184;-861.8494,670.7379;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-2210.25,12.50941;Float;False;Property;_BeamColor;Beam Color;3;1;[Header];Create;True;1;Base Attributes;0;0;False;0;False;1,1,1,1;0.04811453,0.3712184,0.9272981,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;-1511.439,165.976;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1327.439,22.9755;Inherit;False;Property;_WorldSpaceNoise;World Space Noise;17;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-441.1082,429.0773;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;186;-309.6703,430.5374;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-692.2535,429.6743;Inherit;False;Property;_Enable3DNoise;Enable 3D Noise;14;0;Create;True;0;0;0;False;1;Header(3D Noise);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-131.0386,25.2755;Inherit;False;Noise3D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;-542.491,213.7486;Inherit;False;Property;_3DNoiseIntensity;3D Noise Intensity;15;0;Create;True;0;0;0;False;0;False;2;1;0.5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-1201.439,147.976;Inherit;False;Property;_3DNoiseTiling;3D Noise Tiling;18;0;Create;True;0;0;0;False;0;False;0.1;0.2;0.0001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;-1197.439,224.9759;Inherit;False;Property;_3DNoiseSpeed;3D Noise Speed;19;0;Create;True;0;0;0;False;0;False;0.025;0.3;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;204;52.57889,-512.7777;Inherit;False;BRDFMap;0;;5;1affaac2d6e57354aaa8d6573a2b32b8;0;1;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;206;-2032,944;Inherit;False;Property;_SHADER_API_MOBILE;SHADER_API_MOBILE;33;0;Create;True;0;0;0;False;0;False;0;0;0;False;SHADER_API_MOBILE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;207;-1776,944;Inherit;False;Property;_PCDebug;PC Debug;23;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;208;-1568,944;Inherit;False;QuestDepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;209;-2416,1040;Inherit;False;BlueNoiseFakeTransparencyDepthOffset;-1;;77;e0e0f8e10bf068a43b805df662b593ba;0;2;1;FLOAT;1;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;210;-2416,944;Inherit;False;BlueNoiseFakeTransparencyDepthOffset;-1;;79;e0e0f8e10bf068a43b805df662b593ba;0;2;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;211;-1840,1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;212;-2704,1040;Inherit;False;Property;_QuestDepthFade;Quest Depth Fade;22;1;[Header];Create;True;1;Quest Depth Fade;0;0;False;0;False;0.025;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;214;-160,-272;Inherit;False;Constant;_0;0;22;0;Create;True;0;0;0;False;0;False;0;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;213;-224,-192;Inherit;False;208;QuestDepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;194;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;195;-8.438074,-433.7911;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;15;AtlasShaders/Luminous Light Volumes/Luminous Volumetric Lightbeam Lit;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;23;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;48;Workflow;1;0;Surface;1;639035039466155084;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Fragment Normal Space;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;0;0;LOD CrossFade;0;0;Built-in Fog;1;0;Lightmaps;1;0;Volumetrics;1;0;Decals;0;0;Screen Space Occlusion;1;0;Reflection Probe Blend/Projection;1;0;Light Layers;0;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;GBuffer Pass;0;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;1;639204510499550874;  Early Z;0;0;Vertex Position;1;0;Debug Display;0;0;Clear Coat;0;0;Fluorescence;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;196;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;197;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;198;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;199;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;200;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;201;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;1;LightMode=None;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;202;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;203;-8.438074,-433.7911;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;34;0;35;0
WireConnection;142;0;5;0
WireConnection;91;0;4;0
WireConnection;89;0;73;0
WireConnection;83;0;85;0
WireConnection;141;0;142;0
WireConnection;41;8;43;0
WireConnection;192;0;34;0
WireConnection;57;0;55;0
WireConnection;57;1;56;0
WireConnection;3;0;2;0
WireConnection;3;1;91;0
WireConnection;138;0;141;0
WireConnection;193;0;192;0
WireConnection;189;0;41;0
WireConnection;173;0;172;0
WireConnection;84;0;89;0
WireConnection;84;1;83;0
WireConnection;174;0;84;0
WireConnection;174;1;173;0
WireConnection;140;0;138;0
WireConnection;60;1;59;0
WireConnection;60;0;193;0
WireConnection;58;0;57;0
WireConnection;92;0;3;0
WireConnection;133;0;189;0
WireConnection;61;1;59;0
WireConnection;61;0;58;0
WireConnection;80;0;174;0
WireConnection;139;0;140;0
WireConnection;63;0;60;0
WireConnection;136;0;80;0
WireConnection;49;0;139;0
WireConnection;49;1;134;0
WireConnection;5;0;93;0
WireConnection;64;0;61;0
WireConnection;45;0;65;0
WireConnection;45;1;49;0
WireConnection;10;0;5;0
WireConnection;10;1;11;0
WireConnection;40;0;10;0
WireConnection;40;1;68;0
WireConnection;40;2;45;0
WireConnection;40;3;66;0
WireConnection;40;4;137;0
WireConnection;178;0;40;0
WireConnection;47;0;178;0
WireConnection;176;0;47;0
WireConnection;110;0;109;0
WireConnection;103;0;110;0
WireConnection;103;1;100;0
WireConnection;102;0;110;2
WireConnection;102;1;100;0
WireConnection;104;0;103;0
WireConnection;104;1;102;0
WireConnection;104;2;111;0
WireConnection;105;0;106;0
WireConnection;111;0;105;0
WireConnection;94;1;104;0
WireConnection;143;0;8;0
WireConnection;127;0;94;0
WireConnection;127;1;128;0
WireConnection;7;0;9;0
WireConnection;7;1;183;0
WireConnection;7;2;179;0
WireConnection;146;0;7;0
WireConnection;146;1;181;0
WireConnection;147;1;146;0
WireConnection;147;0;185;0
WireConnection;185;0;184;0
WireConnection;184;0;7;0
WireConnection;109;1;108;0
WireConnection;109;0;101;0
WireConnection;99;0;95;0
WireConnection;99;1;147;0
WireConnection;186;0;99;0
WireConnection;95;1;131;0
WireConnection;95;0;113;0
WireConnection;112;0;127;0
WireConnection;206;1;210;0
WireConnection;206;0;209;0
WireConnection;207;1;206;0
WireConnection;207;0;211;0
WireConnection;208;0;207;0
WireConnection;209;2;212;0
WireConnection;211;0;209;0
WireConnection;195;0;187;0
WireConnection;195;3;214;0
WireConnection;195;4;214;0
WireConnection;195;6;177;0
WireConnection;195;17;213;0
ASEEND*/
//CHKSM=11E6F261E7623CD18893E20DA06D119D4E004437