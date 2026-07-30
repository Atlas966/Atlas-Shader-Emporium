// Made with Amplify Shader Editor v1.9.9.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AtlasShaders/Luminous Light Volumes/Luminous Lightbeam Lit"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _Cutoff("Alpha Cutoff", Range(0, 1)) = 0.5
		[HDR][Header(Base Attributes)] _BeamColor( "Beam Color", Color ) = ( 1, 1, 1, 1 )
		_GlobalIntensity( "Global Intensity", Range( 0, 2 ) ) = 1
		[Header (Edge Color Falloff)][Toggle( _ENABLEEDGECOLORFALLOFF_ON )] _EnableEdgeColorFalloff( "Enable Edge Color Falloff", Float ) = 0
		[HDR] _EdgeColorFalloff( "Edge Color Falloff", Color ) = ( 1, 0, 0, 1 )
		_ColorEdgeBlend( "Color Edge Blend", Range( 0, 2 ) ) = 1
		_ColorEdgeFalloff( "Color Edge Falloff", Range( 0, 5 ) ) = 0.25
		[Header (Gradient)][Toggle( _ENABLEGRADIENT_ON )] _EnableGradient( "Enable Gradient", Float ) = 0
		[NoScaleOffset][Gradient] _Gradient( "Gradient", 2D ) = "white" {}
		_GradientScrollSpeed( "Gradient Scroll Speed", Range( -2, 2 ) ) = 0
		[Space (10)][Header (Beam Settings)] _EdgeFalloff( "Edge Falloff", Range( 0, 10 ) ) = 3.5
		_Length( "Length", Range( 0, 1 ) ) = 1
		_LengthFalloff( "Length Falloff", Range( 0, 3 ) ) = 0.65
		[Space (10)][Header(Soft Intersection Options)][Toggle( _ENABLESOFTINTERSECTION_ON )] _EnableSoftIntersection( "Enable Soft Intersection", Float ) = 1
		_SoftIntersection( "Soft Intersection", Range( 0, 5 ) ) = 1.3
		_DepthFadeBlueNoise( "Depth Fade Blue Noise", Range( 0, 5 ) ) = 1.5
		_DepthFadeBlueNoiseSize( "Blue Noise Size", Range( 0, 1 ) ) = 1
		[Space (10)][Toggle( _ENABLECAMERADEPTHFADING_ON )] _EnableCameraDepthFading( "Enable Camera Depth Fading", Float ) = 1
		_CDFalloff( "Falloff", Range( 0, 1 ) ) = 0.5
		_CDDistance( "Distance", Range( 0, 1 ) ) = 0.2
		[Space (10)][Header(Blue Noise)][Toggle( _ENABLEBLUENOISEOVERLAY_ON )] _EnableBlueNoiseOverlay( "Enable Blue Noise Overlay", Float ) = 0
		_BlueNoise( "Blue Noise", Range( 0, 1 ) ) = 0.5
		[Space (10)][Header(3D Noise)][Toggle( _ENABLE3DNOISE_ON )] _Enable3DNoise( "Enable 3D Noise", Float ) = 0
		[KeywordEnum( 3DTexture,Generated )] _NoiseType( "Noise Type", Float ) = 0
		_3DNoiseIntensity( "3D Noise Intensity", Range( 0.5, 5 ) ) = 2
		[NoScaleOffset] _3DNoise( "3D Noise", 3D ) = "white" {}
		_NoiseVelocity( "Noise Velocity", Vector ) = ( 0, 0, 0, 0 )
		[Toggle( _WORLDSPACENOISE_ON )] _WorldSpaceNoise( "World Space Noise", Float ) = 1
		_3DNoiseTiling( "3D Noise Tiling", Range( 0.0001, 1 ) ) = 0.1
		_3DNoiseSpeed( "3D Noise Speed", Range( 0.01, 1 ) ) = 0.025
		[Toggle( _FACTORNOISEINTOALPHA_ON )] _FactorNoiseIntoAlpha( "Factor Noise Into Alpha", Float ) = 0
		_3DNoiseAlphaFalloff( "3D Noise Alpha Falloff", Range( 0, 4 ) ) = 0.5
		[Space (10)][Header (Cookie Projection)][Toggle( _ENABLECOOKIEPROJECTION_ON )] _EnableCookieProjection( "Enable Cookie Projection", Float ) = 0
		[HDR] _CookieColor( "Cookie Color", Color ) = ( 1, 1, 1 )
		[NoScaleOffset] _Cookie( "Cookie", 2D ) = "white" {}
		[Toggle( _COOKIEALPHACONTRIBUTION_ON )] _CookieAlphaContribution( "Cookie Alpha Contribution", Float ) = 1
		_CookieLength( "Cookie Length", Range( 0, 15 ) ) = 2
		_CookieBlending( "Cookie Blending", Range( 0, 1 ) ) = 0.5
		_Saturation( "Saturation", Range( 0, 4 ) ) = 1
		[Space (10)][Header (Quest Depth Fade)] _QuestDepthFade( "Quest Depth Fade", Range( 0, 3 ) ) = 2
		_QuestDepthFadeBlueNoiseSize( "Blue Noise Size", Range( 0, 1 ) ) = 1
		[Toggle( _PCDEBUG_ON )] _PCDebug( "PC Debug", Float ) = 0
		[Space(20)][Header(BRDF Lut)][Space(10)][Toggle( _BRDFMAP )] BRDFMAP( "Enable BRDF map", Float ) = 0
		[NoScaleOffset][SingleLineTexture] g_tBRDFMap( "BRDF map", 2D ) = "white" {}

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
			
			Blend One One, One OneMinusSrcAlpha
			ColorMask RGBA
			

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define _SPECULAR_SETUP 1
			#define _DISABLE_REFLECTIONPROBES
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
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLEGRADIENT_ON
			#pragma shader_feature_local _ENABLEEDGECOLORFALLOFF_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61514( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61512( float2 screenUV, float offsetFrame )
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

				int One222 = 1;
				float4 temp_cast_0 = One222;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord8.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_1 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_1;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch95 = Noise3D112;
				#else
				float4 staticSwitch95 = temp_cast_0;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord8.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord8.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_3 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_3 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float4 lerpResult326 = lerp( float4( CookieColor340 , 0.0 ) , staticSwitch95 , _CookieBlending);
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float4 staticSwitch327 = lerpResult326;
				#else
				float4 staticSwitch327 = staticSwitch95;
				#endif
				float3 BeamColor143 = _BeamColor.rgb;
				float4 temp_output_146_0 = ( staticSwitch327 * float4( BeamColor143 , 0.0 ) );
				float4 temp_cast_6 = (_ColorEdgeFalloff).xxxx;
				float dotResult3 = dot( WorldViewDirection , WorldNormal );
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				float eyeDepth = IN.ase_texcoord9.x;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord8.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_8 = One222;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ScreenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = ScreenPos / ScreenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_8;
				#endif
				float3 temp_cast_9 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_9;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_11 = One222;
				float4 temp_cast_12 = One222;
				float4 temp_cast_13 = (_3DNoiseAlphaFalloff).xxxx;
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_13 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_12;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_11;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord8.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 ColorFalloffAlpha432 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * GradientAlpha395 * ColorAlpha411 );
				float4 smoothstepResult434 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , ColorFalloffAlpha432);
				float4 lerpResult7 = lerp( ( _ColorEdgeBlend * _EdgeColorFalloff ) , temp_output_146_0 , saturate( smoothstepResult434 ));
				#ifdef _ENABLEEDGECOLORFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = temp_output_146_0;
				#endif
				float4 Gradient392 = tex2DNode374;
				#ifdef _ENABLEGRADIENT_ON
				float4 staticSwitch402 = ( staticSwitch147 * Gradient392 );
				#else
				float4 staticSwitch402 = staticSwitch147;
				#endif
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				float4 FinalColor328 = ( staticSwitch402 * Alpha176 );
				
				float3 temp_cast_18 = 0;
				
				float4 unityObjectToClipPos20_g61513 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g61514 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61514 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61514 = GetScreenNoiseRGBASlice27_g61514( screenUV27_g61514 , offsetFrame27_g61514 );
				float4 temp_output_23_0_g61513 = localGetScreenNoiseRGBASlice27_g61514;
				float temp_output_21_0_g61513 = ( unityObjectToClipPos20_g61513.w + ( (temp_output_23_0_g61513).w * 0.0 ) );
				float lerpResult5_g61513 = lerp( ( ( (temp_output_23_0_g61513).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g61511 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g61512 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _QuestDepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61512 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61512 = GetScreenNoiseRGBASlice27_g61512( screenUV27_g61512 , offsetFrame27_g61512 );
				float4 temp_output_23_0_g61511 = localGetScreenNoiseRGBASlice27_g61512;
				float temp_output_21_0_g61511 = ( unityObjectToClipPos20_g61511.w + ( (temp_output_23_0_g61511).w * _QuestDepthFade ) );
				float lerpResult5_g61511 = lerp( ( ( (temp_output_23_0_g61511).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_264_0 = ( ( ( 1.0 - ( temp_output_21_0_g61511 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61511 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61511 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch258 = temp_output_264_0;
				#else
				float staticSwitch258 = ( ( ( 1.0 - ( temp_output_21_0_g61513 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61513 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61513 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch259 = temp_output_264_0;
				#else
				float staticSwitch259 = staticSwitch258;
				#endif
				float QuestDepthFade197 = staticSwitch259;
				
				float3 Albedo = FinalColor328.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
#if 0
				float3 BakedEmission = 0;
#endif
				float3 Specular = temp_cast_18;
				float Metallic = 0;
				float Smoothness = (float)0;
				float Occlusion = 1;
				float Alpha = Alpha176.r;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade197;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define _SPECULAR_SETUP 1
			#define _DISABLE_REFLECTIONPROBES
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
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61514( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61512( float2 screenUV, float offsetFrame )
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
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord2.w = eyeDepth;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord4 = screenPos;
				
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
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				int One222 = 1;
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord3.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_1 = One222;
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_1;
				#endif
				float3 temp_cast_2 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_2;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = One222;
				float4 temp_cast_6 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord3.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_7 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_7;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_5;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_4;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord3.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord3.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_11 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_11 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord3.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				
				float4 unityObjectToClipPos20_g61513 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord3.xyz ).xyz ) );
				float2 screenUV27_g61514 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61514 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61514 = GetScreenNoiseRGBASlice27_g61514( screenUV27_g61514 , offsetFrame27_g61514 );
				float4 temp_output_23_0_g61513 = localGetScreenNoiseRGBASlice27_g61514;
				float temp_output_21_0_g61513 = ( unityObjectToClipPos20_g61513.w + ( (temp_output_23_0_g61513).w * 0.0 ) );
				float lerpResult5_g61513 = lerp( ( ( (temp_output_23_0_g61513).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g61511 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord3.xyz ).xyz ) );
				float2 screenUV27_g61512 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _QuestDepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61512 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61512 = GetScreenNoiseRGBASlice27_g61512( screenUV27_g61512 , offsetFrame27_g61512 );
				float4 temp_output_23_0_g61511 = localGetScreenNoiseRGBASlice27_g61512;
				float temp_output_21_0_g61511 = ( unityObjectToClipPos20_g61511.w + ( (temp_output_23_0_g61511).w * _QuestDepthFade ) );
				float lerpResult5_g61511 = lerp( ( ( (temp_output_23_0_g61511).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_264_0 = ( ( ( 1.0 - ( temp_output_21_0_g61511 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61511 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61511 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch258 = temp_output_264_0;
				#else
				float staticSwitch258 = ( ( ( 1.0 - ( temp_output_21_0_g61513 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61513 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61513 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch259 = temp_output_264_0;
				#else
				float staticSwitch259 = staticSwitch258;
				#endif
				float QuestDepthFade197 = staticSwitch259;
				
				float Alpha = Alpha176.r;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade197;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define _SPECULAR_SETUP 1
			#define _DISABLE_REFLECTIONPROBES
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
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLEGRADIENT_ON
			#pragma shader_feature_local _ENABLEEDGECOLORFALLOFF_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
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
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord5.w = eyeDepth;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord6 = screenPos;
				
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

				int One222 = 1;
				float4 temp_cast_0 = One222;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord4.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_1 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_1;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch95 = Noise3D112;
				#else
				float4 staticSwitch95 = temp_cast_0;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord4.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord4.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_3 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_3 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float4 lerpResult326 = lerp( float4( CookieColor340 , 0.0 ) , staticSwitch95 , _CookieBlending);
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float4 staticSwitch327 = lerpResult326;
				#else
				float4 staticSwitch327 = staticSwitch95;
				#endif
				float3 BeamColor143 = _BeamColor.rgb;
				float4 temp_output_146_0 = ( staticSwitch327 * float4( BeamColor143 , 0.0 ) );
				float4 temp_cast_6 = (_ColorEdgeFalloff).xxxx;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord5.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				float eyeDepth = IN.ase_texcoord5.w;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord4.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_8 = One222;
				float4 screenPos = IN.ase_texcoord6;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_8;
				#endif
				float3 temp_cast_9 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_9;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_11 = One222;
				float4 temp_cast_12 = One222;
				float4 temp_cast_13 = (_3DNoiseAlphaFalloff).xxxx;
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_13 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_12;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_11;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord4.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 ColorFalloffAlpha432 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * GradientAlpha395 * ColorAlpha411 );
				float4 smoothstepResult434 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , ColorFalloffAlpha432);
				float4 lerpResult7 = lerp( ( _ColorEdgeBlend * _EdgeColorFalloff ) , temp_output_146_0 , saturate( smoothstepResult434 ));
				#ifdef _ENABLEEDGECOLORFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = temp_output_146_0;
				#endif
				float4 Gradient392 = tex2DNode374;
				#ifdef _ENABLEGRADIENT_ON
				float4 staticSwitch402 = ( staticSwitch147 * Gradient392 );
				#else
				float4 staticSwitch402 = staticSwitch147;
				#endif
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				float4 FinalColor328 = ( staticSwitch402 * Alpha176 );
				
				
				float3 Albedo = FinalColor328.rgb;
				float3 Emission = 0;
				float Alpha = Alpha176.r;
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

			Blend One One, One OneMinusSrcAlpha
			ColorMask RGBA

			HLSLPROGRAM
			
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED
			#define ASE_DEPTH_WRITE_ON
			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define _SPECULAR_SETUP 1
			#define _DISABLE_REFLECTIONPROBES
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
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLEGRADIENT_ON
			#pragma shader_feature_local _ENABLEEDGECOLORFALLOFF_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
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
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.w = eyeDepth;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord4 = screenPos;
				
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

				int One222 = 1;
				float4 temp_cast_0 = One222;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord2.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_1 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_1;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch95 = Noise3D112;
				#else
				float4 staticSwitch95 = temp_cast_0;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord2.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord2.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_3 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_3 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float4 lerpResult326 = lerp( float4( CookieColor340 , 0.0 ) , staticSwitch95 , _CookieBlending);
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float4 staticSwitch327 = lerpResult326;
				#else
				float4 staticSwitch327 = staticSwitch95;
				#endif
				float3 BeamColor143 = _BeamColor.rgb;
				float4 temp_output_146_0 = ( staticSwitch327 * float4( BeamColor143 , 0.0 ) );
				float4 temp_cast_6 = (_ColorEdgeFalloff).xxxx;
				float3 ase_viewVectorWS = ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - WorldPosition : UNITY_MATRIX_V[ 2 ].xyz );
				float3 ase_viewDirWS = normalize( ase_viewVectorWS );
				float3 ase_normalWS = IN.ase_texcoord3.xyz;
				float dotResult3 = dot( ase_viewDirWS , ase_normalWS );
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				float eyeDepth = IN.ase_texcoord3.w;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord2.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_8 = One222;
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_8;
				#endif
				float3 temp_cast_9 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_9;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_11 = One222;
				float4 temp_cast_12 = One222;
				float4 temp_cast_13 = (_3DNoiseAlphaFalloff).xxxx;
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_13 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_12;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_11;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord2.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 ColorFalloffAlpha432 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * GradientAlpha395 * ColorAlpha411 );
				float4 smoothstepResult434 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , ColorFalloffAlpha432);
				float4 lerpResult7 = lerp( ( _ColorEdgeBlend * _EdgeColorFalloff ) , temp_output_146_0 , saturate( smoothstepResult434 ));
				#ifdef _ENABLEEDGECOLORFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = temp_output_146_0;
				#endif
				float4 Gradient392 = tex2DNode374;
				#ifdef _ENABLEGRADIENT_ON
				float4 staticSwitch402 = ( staticSwitch147 * Gradient392 );
				#else
				float4 staticSwitch402 = staticSwitch147;
				#endif
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				float4 FinalColor328 = ( staticSwitch402 * Alpha176 );
				
				
				float3 Albedo = FinalColor328.rgb;
				float Alpha = Alpha176.r;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define _SPECULAR_SETUP 1
			#define _DISABLE_REFLECTIONPROBES
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
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61514( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61512( float2 screenUV, float offsetFrame )
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
				o.ase_texcoord4.x = eyeDepth;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord6 = screenPos;
				
				o.ase_texcoord5 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.yzw = 0;
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
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				int One222 = 1;
				float eyeDepth = IN.ase_texcoord4.x;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord5.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_1 = One222;
				float4 screenPos = IN.ase_texcoord6;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_1;
				#endif
				float3 temp_cast_2 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_2;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = One222;
				float4 temp_cast_6 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord5.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_7 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_7;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_5;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_4;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord5.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord5.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_11 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_11 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord5.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				
				float4 unityObjectToClipPos20_g61513 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord5.xyz ).xyz ) );
				float2 screenUV27_g61514 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61514 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61514 = GetScreenNoiseRGBASlice27_g61514( screenUV27_g61514 , offsetFrame27_g61514 );
				float4 temp_output_23_0_g61513 = localGetScreenNoiseRGBASlice27_g61514;
				float temp_output_21_0_g61513 = ( unityObjectToClipPos20_g61513.w + ( (temp_output_23_0_g61513).w * 0.0 ) );
				float lerpResult5_g61513 = lerp( ( ( (temp_output_23_0_g61513).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g61511 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord5.xyz ).xyz ) );
				float2 screenUV27_g61512 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _QuestDepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61512 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61512 = GetScreenNoiseRGBASlice27_g61512( screenUV27_g61512 , offsetFrame27_g61512 );
				float4 temp_output_23_0_g61511 = localGetScreenNoiseRGBASlice27_g61512;
				float temp_output_21_0_g61511 = ( unityObjectToClipPos20_g61511.w + ( (temp_output_23_0_g61511).w * _QuestDepthFade ) );
				float lerpResult5_g61511 = lerp( ( ( (temp_output_23_0_g61511).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_264_0 = ( ( ( 1.0 - ( temp_output_21_0_g61511 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61511 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61511 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch258 = temp_output_264_0;
				#else
				float staticSwitch258 = ( ( ( 1.0 - ( temp_output_21_0_g61513 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61513 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61513 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch259 = temp_output_264_0;
				#else
				float staticSwitch259 = staticSwitch258;
				#endif
				float QuestDepthFade197 = staticSwitch259;
				
				float3 Normal = float3(0, 0, 1);
				float Alpha = Alpha176.r;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade197;
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
			
			Blend One One, One OneMinusSrcAlpha
			ColorMask RGBA
			

			HLSLPROGRAM
#define _NORMAL_DROPOFF_TS 1#pragma multi_compile_fog#define ASE_FOG 1#pragma multi_compile_fragment _ _VOLUMETRICS_ENABLED#define ASE_DEPTH_WRITE_ON#define _RECEIVE_SHADOWS_OFF 1#pragma multi_compile_instancing#define _SPECULAR_SETUP 1#define _DISABLE_REFLECTIONPROBES#define ASE_VERSION 19908#define ASE_SRP_VERSION -1#define REQUIRE_DEPTH_TEXTURE 1
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
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLEGRADIENT_ON
			#pragma shader_feature_local _ENABLEEDGECOLORFALLOFF_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61514( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61512( float2 screenUV, float offsetFrame )
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

				int One222 = 1;
				float4 temp_cast_0 = One222;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = WorldPosition;
				#else
				float3 staticSwitch109 = IN.ase_texcoord8.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_1 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_1;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch95 = Noise3D112;
				#else
				float4 staticSwitch95 = temp_cast_0;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord8.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord8.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_3 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_3 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float4 lerpResult326 = lerp( float4( CookieColor340 , 0.0 ) , staticSwitch95 , _CookieBlending);
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float4 staticSwitch327 = lerpResult326;
				#else
				float4 staticSwitch327 = staticSwitch95;
				#endif
				float3 BeamColor143 = _BeamColor.rgb;
				float4 temp_output_146_0 = ( staticSwitch327 * float4( BeamColor143 , 0.0 ) );
				float4 temp_cast_6 = (_ColorEdgeFalloff).xxxx;
				float dotResult3 = dot( WorldViewDirection , WorldNormal );
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				float eyeDepth = IN.ase_texcoord9.x;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord8.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_8 = One222;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ScreenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = ScreenPos / ScreenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_8;
				#endif
				float3 temp_cast_9 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_9;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_11 = One222;
				float4 temp_cast_12 = One222;
				float4 temp_cast_13 = (_3DNoiseAlphaFalloff).xxxx;
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_13 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_12;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_11;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord8.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 ColorFalloffAlpha432 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * GradientAlpha395 * ColorAlpha411 );
				float4 smoothstepResult434 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , ColorFalloffAlpha432);
				float4 lerpResult7 = lerp( ( _ColorEdgeBlend * _EdgeColorFalloff ) , temp_output_146_0 , saturate( smoothstepResult434 ));
				#ifdef _ENABLEEDGECOLORFALLOFF_ON
				float4 staticSwitch147 = lerpResult7;
				#else
				float4 staticSwitch147 = temp_output_146_0;
				#endif
				float4 Gradient392 = tex2DNode374;
				#ifdef _ENABLEGRADIENT_ON
				float4 staticSwitch402 = ( staticSwitch147 * Gradient392 );
				#else
				float4 staticSwitch402 = staticSwitch147;
				#endif
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				float4 FinalColor328 = ( staticSwitch402 * Alpha176 );
				
				float3 temp_cast_18 = 0;
				
				float4 unityObjectToClipPos20_g61513 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g61514 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61514 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61514 = GetScreenNoiseRGBASlice27_g61514( screenUV27_g61514 , offsetFrame27_g61514 );
				float4 temp_output_23_0_g61513 = localGetScreenNoiseRGBASlice27_g61514;
				float temp_output_21_0_g61513 = ( unityObjectToClipPos20_g61513.w + ( (temp_output_23_0_g61513).w * 0.0 ) );
				float lerpResult5_g61513 = lerp( ( ( (temp_output_23_0_g61513).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float4 unityObjectToClipPos20_g61511 = TransformWorldToHClip( TransformObjectToWorld( ( IN.ase_texcoord8.xyz ).xyz ) );
				float2 screenUV27_g61512 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _QuestDepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61512 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61512 = GetScreenNoiseRGBASlice27_g61512( screenUV27_g61512 , offsetFrame27_g61512 );
				float4 temp_output_23_0_g61511 = localGetScreenNoiseRGBASlice27_g61512;
				float temp_output_21_0_g61511 = ( unityObjectToClipPos20_g61511.w + ( (temp_output_23_0_g61511).w * _QuestDepthFade ) );
				float lerpResult5_g61511 = lerp( ( ( (temp_output_23_0_g61511).w - 1.0 ) * 2.0 ) , 0.5 , 1.0);
				float temp_output_264_0 = ( ( ( 1.0 - ( temp_output_21_0_g61511 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61511 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61511 ) );
				#ifdef SHADER_API_MOBILE
				float staticSwitch258 = temp_output_264_0;
				#else
				float staticSwitch258 = ( ( ( 1.0 - ( temp_output_21_0_g61513 * _ZBufferParams.w ) ) / ( temp_output_21_0_g61513 * _ZBufferParams.z ) ) * ceil( lerpResult5_g61513 ) );
				#endif
				#ifdef _PCDEBUG_ON
				float staticSwitch259 = temp_output_264_0;
				#else
				float staticSwitch259 = staticSwitch258;
				#endif
				float QuestDepthFade197 = staticSwitch259;
				
				float3 Albedo = FinalColor328.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
				float3 Specular = temp_cast_18;
				float Metallic = 0;
				float Smoothness = (float)0;
				float Occlusion = 1;
				float Alpha = Alpha176.r;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;
				#ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = QuestDepthFade197;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define _SPECULAR_SETUP 1
			#define _DISABLE_REFLECTIONPROBES
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
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
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
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord.w = eyeDepth;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord2 = v.vertex;
				
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
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				int One222 = 1;
				float eyeDepth = IN.ase_texcoord.w;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord2.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_1 = One222;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_1;
				#endif
				float3 temp_cast_2 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_2;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = One222;
				float4 temp_cast_6 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = ase_positionWS;
				#else
				float3 staticSwitch109 = IN.ase_texcoord2.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_7 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_7;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_5;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_4;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord2.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord2.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_11 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_11 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord2.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				
				surfaceDescription.Alpha = Alpha176.r;
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
			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define _SPECULAR_SETUP 1
			#define _DISABLE_REFLECTIONPROBES
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
			#pragma shader_feature_local_fragment _BRDFMAP
			#pragma shader_feature_local _ENABLECAMERADEPTHFADING_ON
			#pragma shader_feature_local _PCDEBUG_ON
			#pragma shader_feature_local _ENABLESOFTINTERSECTION_ON
			#pragma shader_feature_local _ENABLEBLUENOISEOVERLAY_ON
			#pragma shader_feature_local _ENABLE3DNOISE_ON
			#pragma shader_feature_local _FACTORNOISEINTOALPHA_ON
			#pragma shader_feature_local _NOISETYPE_3DTEXTURE _NOISETYPE_GENERATED
			#pragma shader_feature_local _WORLDSPACENOISE_ON
			#pragma shader_feature_local _ENABLECOOKIEPROJECTION_ON
			#pragma shader_feature_local _COOKIEALPHACONTRIBUTION_ON
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
			float4 _EdgeColorFalloff;
			float3 _NoiseVelocity;
			float3 _CookieColor;
			float _3DNoiseTiling;
			float _GradientScrollSpeed;
			float _3DNoiseAlphaFalloff;
			float _BlueNoise;
			float _SoftIntersection;
			float _DepthFadeBlueNoise;
			float _DepthFadeBlueNoiseSize;
			float _LengthFalloff;
			float _Length;
			float _CDDistance;
			float _EdgeFalloff;
			float _GlobalIntensity;
			float _QuestDepthFadeBlueNoiseSize;
			float _ColorEdgeFalloff;
			float _ColorEdgeBlend;
			float _CookieBlending;
			float _Saturation;
			float _CookieLength;
			float _3DNoiseIntensity;
			float _3DNoiseSpeed;
			float _CDFalloff;
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
			sampler2D _Cookie;
			sampler2D _Gradient;


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
			
			inline float4 GetScreenNoiseRGBASlice27_g61510( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			inline float4 GetScreenNoiseRGBASlice27_g61507( float2 screenUV, float offsetFrame )
			{
				return GetScreenNoiseRGBAOffset(screenUV, offsetFrame);
			}
			
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
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
				float3 objectToViewPos = TransformWorldToView( TransformObjectToWorld( v.vertex.xyz ) );
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord.w = eyeDepth;
				float4 ase_positionCS = TransformObjectToHClip( ( v.vertex ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord2 = v.vertex;
				
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
				float BeamMask92 = abs( dotResult3 );
				float clampResult5 = clamp( BeamMask92 , 0.0 , 1.0 );
				float temp_output_10_0 = pow( clampResult5 , _EdgeFalloff );
				int One222 = 1;
				float eyeDepth = IN.ase_texcoord.w;
				float cameraDepthFade14_g61508 = (( eyeDepth -_ProjectionParams.y - _CDDistance ) / _CDFalloff);
				#ifdef _ENABLECAMERADEPTHFADING_ON
				float staticSwitch255 = saturate( cameraDepthFade14_g61508 );
				#else
				float staticSwitch255 = (float)One222;
				#endif
				float DepthFadeCamera64 = staticSwitch255;
				float LengthLimit136 = saturate( ( ( ( _Length * 2.2 ) - length( IN.ase_texcoord2.xyz ) ) / max( _LengthFalloff, 0.0001 ) ) );
				float3 temp_cast_1 = One222;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 screenUV27_g61510 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * _DepthFadeBlueNoiseSize ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61510 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61510 = GetScreenNoiseRGBASlice27_g61510( screenUV27_g61510 , offsetFrame27_g61510 );
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth4_g61508 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ),_ZBufferParams);
				float distanceDepth4_g61508 = saturate( abs( ( screenDepth4_g61508 - LinearEyeDepth( ase_positionSSNorm.z,_ZBufferParams ) ) / ( _SoftIntersection ) ) );
				float3 lerpResult6_g61508 = lerp( ( ( (localGetScreenNoiseRGBASlice27_g61510).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _DepthFadeBlueNoise * 9.0 ) * 0.1 ) * 2.0 ) , float3( 1,1,1 ) , distanceDepth4_g61508);
				#ifdef _ENABLESOFTINTERSECTION_ON
				float3 staticSwitch252 = saturate( ( lerpResult6_g61508 * distanceDepth4_g61508 ) );
				#else
				float3 staticSwitch252 = temp_cast_1;
				#endif
				float3 temp_cast_2 = One222;
				#ifdef _PCDEBUG_ON
				float3 staticSwitch256 = temp_cast_2;
				#else
				float3 staticSwitch256 = staticSwitch252;
				#endif
				float3 DepthFade63 = staticSwitch256;
				float2 screenUV27_g61507 = ( ( ( (ase_grabScreenPosNorm).xy - float2( 0.5,0.5 ) ) * 1.0 ) + float2( 0.5,0.5 ) );
				float offsetFrame27_g61507 = 0.0;
				float4 localGetScreenNoiseRGBASlice27_g61507 = GetScreenNoiseRGBASlice27_g61507( screenUV27_g61507 , offsetFrame27_g61507 );
				#ifdef _ENABLEBLUENOISEOVERLAY_ON
				float3 staticSwitch189 = ( ( (localGetScreenNoiseRGBASlice27_g61507).xyz - float3( 0.5,0.5,0.5 ) ) * ( ( _BlueNoise * 5.0 ) * 0.1 ) * 2.0 );
				#else
				float3 staticSwitch189 = float3( 0,0,0 );
				#endif
				float3 BlueNoise133 = staticSwitch189;
				float3 temp_output_272_0 = ( DepthFade63 + ( clampResult5 * BlueNoise133 ) );
				float4 temp_cast_4 = One222;
				float4 temp_cast_5 = One222;
				float4 temp_cast_6 = (_3DNoiseAlphaFalloff).xxxx;
				#ifdef _WORLDSPACENOISE_ON
				float3 staticSwitch109 = ase_positionWS;
				#else
				float3 staticSwitch109 = IN.ase_texcoord2.xyz;
				#endif
				float3 break110 = staticSwitch109;
				float mulTime105 = _TimeParameters.x * _3DNoiseSpeed;
				float3 appendResult104 = (float3(( break110.x * _3DNoiseTiling ) , ( break110.z * _3DNoiseTiling ) , mulTime105));
				float3 temp_output_491_0 = ( appendResult104 + ( ( _NoiseVelocity * _TimeParameters.x ) * float3( 0.2,0.2,0.2 ) ) );
				float simplePerlin3D487 = snoise( temp_output_491_0*3.0 );
				simplePerlin3D487 = simplePerlin3D487*0.5 + 0.5;
				float4 temp_cast_7 = (simplePerlin3D487).xxxx;
				#if defined( _NOISETYPE_3DTEXTURE )
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#elif defined( _NOISETYPE_GENERATED )
				float4 staticSwitch488 = temp_cast_7;
				#else
				float4 staticSwitch488 = tex3D( _3DNoise, temp_output_491_0 );
				#endif
				float4 Noise3D112 = ( staticSwitch488 * _3DNoiseIntensity );
				float4 smoothstepResult224 = smoothstep( float4( 0,0,0,0 ) , temp_cast_6 , Noise3D112);
				#ifdef _FACTORNOISEINTOALPHA_ON
				float4 staticSwitch220 = smoothstepResult224;
				#else
				float4 staticSwitch220 = temp_cast_5;
				#endif
				#ifdef _ENABLE3DNOISE_ON
				float4 staticSwitch227 = staticSwitch220;
				#else
				float4 staticSwitch227 = temp_cast_4;
				#endif
				float2 appendResult279 = (float2(( ( IN.ase_texcoord2.xyz.x / _CookieLength ) + 0.5 ) , ( ( IN.ase_texcoord2.xyz.y / _CookieLength ) + 0.5 )));
				float3 temp_output_12_0_g61505 = tex2D( _Cookie, appendResult279 ).rgb;
				float dotResult28_g61505 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g61505 );
				float3 temp_cast_11 = (dotResult28_g61505).xxx;
				float temp_output_21_0_g61505 = _Saturation;
				float3 lerpResult31_g61505 = lerp( temp_cast_11 , temp_output_12_0_g61505 , temp_output_21_0_g61505);
				float3 CookieColor340 = ( lerpResult31_g61505 * _CookieColor );
				float luminance334 = Luminance(CookieColor340);
				#ifdef _COOKIEALPHACONTRIBUTION_ON
				float staticSwitch345 = luminance334;
				#else
				float staticSwitch345 = (float)One222;
				#endif
				#ifdef _ENABLECOOKIEPROJECTION_ON
				float staticSwitch355 = staticSwitch345;
				#else
				float staticSwitch355 = (float)One222;
				#endif
				float2 appendResult375 = (float2(( ( IN.ase_texcoord2.xyz.z / -2.0 ) + ( _TimeParameters.x * _GradientScrollSpeed ) ) , 0.5));
				float4 tex2DNode374 = tex2D( _Gradient, appendResult375 );
				float GradientAlpha395 = tex2DNode374.a;
				float ColorAlpha411 = _BeamColor.a;
				float4 Alpha176 = ( temp_output_10_0 * _GlobalIntensity * DepthFadeCamera64 * LengthLimit136 * float4( temp_output_272_0 , 0.0 ) * staticSwitch227 * staticSwitch355 * GradientAlpha395 * ColorAlpha411 );
				
				surfaceDescription.Alpha = Alpha176.r;
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
	
	CustomEditor "LuminousLightbeamGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19908
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-1520,880;Inherit;False;2421.412;466.3688;Handling of 3D Noise;25;499;497;488;112;127;496;128;487;94;491;492;493;495;111;489;104;103;102;100;105;110;106;109;101;108;3D Noise;1,0,0.3390222,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-1504,928;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;-1504,1072;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;361;-3296,992;Inherit;False;1720.238;466.8435;;15;340;338;339;343;344;278;279;298;297;304;296;293;291;294;295;Cookie Projection;0,0.8746934,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1312,928;Inherit;False;Property;_WorldSpaceNoise;World Space Noise;26;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;-1200,1136;Inherit;False;Property;_3DNoiseSpeed;3D Noise Speed;28;0;Create;True;0;0;0;False;0;False;0.025;0.3;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;295;-2944,1152;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;291;-3184,1056;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;294;-3280,1200;Inherit;False;Property;_CookieLength;Cookie Length;35;0;Create;True;0;0;0;False;0;False;2;0;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-1040,928;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-912,1136;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-1200,1056;Inherit;False;Property;_3DNoiseTiling;3D Noise Tiling;27;0;Create;True;0;0;0;False;0;False;0.1;0.2;0.0001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-880,1040;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;489;-688,1056;Inherit;False;Property;_NoiseVelocity;Noise Velocity;25;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;493;-688,1200;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;293;-2944,1056;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;296;-2800,1152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-880,928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-720,1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;495;-736,1024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;492;-496,1056;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;304;-2704,1136;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;297;-2800,1056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-656,928;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;497;-112,1040;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;499;-352,1056;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.2,0.2,0.2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;132;-2800,400;Inherit;False;1236.123;155.3527;;5;43;239;41;189;133;Blue Noise;0.3349057,0.7946209,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;242;-1520,384;Inherit;False;1627.349;455.2128;;18;256;255;252;251;249;248;247;246;245;244;243;63;64;404;405;406;407;408;Depth Fading;1,0.7118232,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-2432,-48;Inherit;False;877;409.4999;Mask setup for beam;6;3;91;2;4;441;92;Beam Mask;1,0.6099074,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;410;-2928,1504;Inherit;False;1352.345;457.417;;12;452;368;449;367;450;375;392;374;395;456;458;459;Gradient;1,0,0,1;0;0
Node;AmplifyShaderEditor.SamplerStateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;298;-2672,1152;Inherit;False;1;1;1;1;-1;None;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;279;-2640,1056;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;491;-224,928;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;487;0,1120;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;135;-2832,-448;Inherit;False;1281.726;360.8922;;10;136;80;174;84;173;172;83;89;73;85;Length Limiter;0.3820755,1,0.4680587,1;0;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;278;-2496,1056;Inherit;True;Property;_Cookie;Cookie;33;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;474d4a1526b69344f91dd52cf46c22bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;344;-2496,1248;Inherit;False;Property;_Saturation;Saturation;37;0;Create;True;0;0;0;False;0;False;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;406;-768,624;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;-2400,192;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-2784,448;Inherit;False;Property;_BlueNoise;Blue Noise;20;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;452;-2800,1872;Inherit;False;Property;_GradientScrollSpeed;Gradient Scroll Speed;8;0;Create;True;0;0;0;False;0;False;0;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;-48,928;Inherit;True;Property;_3DNoise;3D Noise;24;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;bdcd046c508f95a46b93458a4ed846f7;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;False;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;496;224,1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;226;-3392,1504;Inherit;False;436;163;;2;223;222;One;0,0,0,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-2784,-304;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;-2816,-400;Inherit;False;Property;_Length;Length;10;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;239;-2512,448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;343;-2208,1056;Inherit;False;Saturation;-1;;61505;4f383aa3b2a7ef640be83276d286e709;1,51,0;2;12;FLOAT3;0,0,0;False;21;FLOAT;0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;407;-640,624;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-2400,0;Float;True;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-2192,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;339;-2208,1152;Inherit;False;Property;_CookieColor;Cookie Color;32;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;367;-2912,1568;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;449;-2704,1792;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;459;-2496,1808;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;256,1024;Inherit;False;Property;_3DNoiseIntensity;3D Noise Intensity;23;0;Create;True;0;0;0;False;0;False;2;1;0.5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;488;288,928;Inherit;False;Property;_NoiseType;Noise Type;22;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;3DTexture;Generated;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;175;-1520,1408;Inherit;False;1734.086;1304.177;Handling of alpha output;34;40;396;10;355;66;227;137;272;68;358;345;228;220;65;267;11;5;359;334;224;221;270;266;93;357;341;225;219;269;346;412;431;432;176;Alpha;0,1,0.9731083,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-2560,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-2592,-304;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-2352,448;Inherit;False;Blue Noise Diffusion;-1;;61506;5e6df176aa279d846818294540ea1f3f;0;2;8;FLOAT;0;False;9;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;338;-1984,1056;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;408;-528,624;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;244;-1504,672;Inherit;False;Property;_CDFalloff;Falloff;17;1;[Header];Create;False;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;243;-1504,752;Inherit;False;Property;_CDDistance;Distance;18;0;Create;False;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;172;-2416,-304;Inherit;False;Property;_LengthFalloff;Length Falloff;11;0;Create;True;0;0;0;False;0;False;0.65;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;368;-2720,1568;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;450;-2512,1696;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;223;-3344,1552;Inherit;False;Constant;_One;One;22;0;Create;True;0;0;0;False;0;False;1;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-2128,0;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;127;544,928;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;245;-1216,576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;246;-1184,592;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;173;-2144,-288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.0001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-2416,-400;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;252;-752,432;Inherit;False;Property;_EnableSoftIntersection;Enable Soft Intersection;12;0;Create;True;0;0;0;False;2;Space (10);Header(Soft Intersection Options);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;189;-2048,448;Inherit;False;Property;_EnableBlueNoiseOverlay;Enable Blue Noise Overlay;19;0;Create;True;0;0;0;False;2;Space (10);Header(Blue Noise);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;346;-1216,2384;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;340;-1792,1056;Inherit;False;CookieColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;405;-480,608;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;247;-1504,592;Inherit;False;Property;_SoftIntersection;Soft Intersection;13;0;Create;True;0;0;0;False;0;False;1.3;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;249;-1504,512;Inherit;False;Property;_DepthFadeBlueNoiseSize;Blue Noise Size;15;0;Create;False;1;Blue Noise;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;248;-1504,432;Inherit;False;Property;_DepthFadeBlueNoise;Depth Fade Blue Noise;14;0;Create;True;1;Blue Noise;0;0;False;0;False;1.5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;456;-2384,1568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;222;-3200,1552;Inherit;False;One;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;441;-1920,0;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;688,928;Inherit;False;Noise3D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;182;-2896,-48;Inherit;False;441.6897;249.273;;3;8;411;143;Register Color;1,0.9888224,0.08018869,1;0;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;251;-1200,432;Inherit;False;Depth Faders;-1;;61508;d82d20eda006c484093d6adf8fee07db;0;5;28;FLOAT;0;False;30;FLOAT;1;False;24;FLOAT;0;False;25;FLOAT;0;False;26;FLOAT;0;False;2;FLOAT3;0;FLOAT;23
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;174;-2016,-400;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;256;-384,432;Inherit;False;Property;_Keyword0;Keyword 0;40;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;259;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;-1776,448;Inherit;False;BlueNoise;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;269;-576,1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;219;-1360,2208;Inherit;False;112;Noise3D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;341;-1376,2464;Inherit;False;340;CookieColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;357;-1040,2336;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;404;-976,608;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;225;-1456,2288;Inherit;False;Property;_3DNoiseAlphaFalloff;3D Noise Alpha Falloff;30;0;Create;True;0;0;0;False;0;False;0.5;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;375;-2256,1568;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerStateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;458;-2288,1664;Inherit;False;0;0;0;1;-1;None;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-1760,0;Inherit;False;BeamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-896,1536;Inherit;False;92;BeamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;-1904,-400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;255;-752,528;Inherit;False;Property;_EnableCameraDepthFading;Enable Camera Depth Fading;16;0;Create;True;0;0;0;False;1;Space (10);False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-144,432;Inherit;False;DepthFade;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;266;-912,1856;Inherit;False;133;BlueNoise;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;270;-752,1680;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;221;-1168,2128;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;224;-1168,2208;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LuminanceNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;334;-1200,2464;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;359;-896,2336;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-2864,0;Float;False;Property;_BeamColor;Beam Color;0;2;[HDR];[Header];Create;True;1;Base Attributes;0;0;False;0;False;1,1,1,1;0.04811453,0.3712184,0.9272981,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;374;-2064,1568;Inherit;True;Property;_Gradient;Gradient;7;1;[NoScaleOffset];Create;True;0;0;0;False;1;Gradient;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ClampOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-704,1536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-848,1456;Float;False;Property;_EdgeFalloff;Edge Falloff;9;0;Create;True;0;0;0;False;2;Space (10);Header (Beam Settings);False;3.5;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;136;-1760,-400;Inherit;False;LengthLimit;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-384,528;Inherit;False;DepthFadeCamera;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;267;-688,1840;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;-720,1760;Inherit;False;63;DepthFade;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;220;-976,2128;Inherit;False;Property;_FactorNoiseIntoAlpha;Factor Noise Into Alpha;29;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;228;-880,2224;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;345;-1024,2384;Inherit;False;Property;_CookieAlphaContribution;Cookie Alpha Contribution;34;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;358;-768,2336;Inherit;False;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;411;-2656,80;Inherit;False;ColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;395;-1792,1696;Inherit;False;GradientAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-512,1456;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;412;-640,2576;Inherit;False;411;ColorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;-624,1952;Inherit;False;64;DepthFadeCamera;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;137;-592,2032;Inherit;False;136;LengthLimit;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;272;-528,1760;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;227;-688,2128;Inherit;False;Property;_FactorNoiseIntoAlpha;Factor Noise Into Alpha;21;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;95;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;396;-672,2496;Inherit;False;395;GradientAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;68;-688,1680;Inherit;False;Property;_GlobalIntensity;Global Intensity;1;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;355;-736,2384;Inherit;False;Property;_CookieAlphaContribution;Cookie Alpha Contribution;31;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;327;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-304,1456;Inherit;False;9;9;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;5;COLOR;0,0,0,0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;188;-1520,-448;Inherit;False;2423.813;769.0358;Calculate color output;25;443;177;435;9;416;7;419;402;401;393;147;146;421;434;179;327;181;301;414;403;113;326;398;95;328;Color;0,0.5004339,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;257;-2960,592;Inherit;False;1386.622;350.7966;;8;265;264;263;262;260;259;258;197;Quest Depth Fade;1,0.3646275,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;176;-160,1456;Inherit;False;Alpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;260;-2064,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;264;-2640,768;Inherit;False;BlueNoiseFakeTransparencyDepthOffset;-1;;61511;e0e0f8e10bf068a43b805df662b593ba;0;3;1;FLOAT;1;False;2;FLOAT;0;False;24;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;265;-2640,640;Inherit;False;BlueNoiseFakeTransparencyDepthOffset;-1;;61513;e0e0f8e10bf068a43b805df662b593ba;0;3;1;FLOAT;1;False;2;FLOAT;0;False;24;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;259;-2000,640;Inherit;False;Property;_PCDebug;PC Debug;40;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;197;-1792,656;Inherit;False;QuestDepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;258;-2256,640;Inherit;False;Property;_SHADER_API_MOBILE;SHADER_API_MOBILE;33;0;Create;True;0;0;0;False;0;False;0;0;0;False;SHADER_API_MOBILE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;143;-2656,0;Inherit;False;BeamColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-1312,-400;Inherit;False;Property;_Enable3DNoise;Enable 3D Noise;21;0;Create;True;0;0;0;False;2;Space (10);Header(3D Noise);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;398;-1056,-288;Inherit;False;340;CookieColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;326;-864,-288;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-1488,-320;Inherit;False;112;Noise3D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;403;-1488,-400;Inherit;False;222;One;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;414;-1088,-240;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;431;-304,1728;Inherit;False;8;8;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;5;COLOR;0,0,0,0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;432;-160,1728;Inherit;False;ColorFalloffAlpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;181;-624,-304;Inherit;False;143;BeamColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;327;-736,-400;Inherit;False;Property;_EnableCookieProjection;Enable Cookie Projection;31;0;Create;True;0;0;0;False;2;Space (10);Header (Cookie Projection);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;179;-832,144;Inherit;False;432;ColorFalloffAlpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;434;-592,144;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;421;-416,144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;-432,-400;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;-128,-400;Inherit;False;Property;_EnableEdgeColorFalloff;Enable Edge Color Falloff;2;0;Create;True;0;0;0;False;1;Header (Edge Color Falloff);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;393;-64,-240;Inherit;False;392;Gradient;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;401;128,-272;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;402;256,-400;Inherit;False;Property;_EnableGradient;Enable Gradient;6;0;Create;True;0;0;0;False;1;Header (Gradient);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;419;-416,-224;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-256,-304;Inherit;False;3;0;COLOR;0.5,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;416;-640,-64;Inherit;False;Property;_EdgeColorFalloff;Edge Color Falloff;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;435;-896,224;Inherit;False;Property;_ColorEdgeFalloff;Color Edge Falloff;5;0;Create;True;0;0;0;False;0;False;0.25;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;301;-1152,-176;Inherit;False;Property;_CookieBlending;Cookie Blending;36;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;263;-2944,768;Inherit;False;Property;_QuestDepthFade;Quest Depth Fade;38;1;[Header];Create;True;0;0;0;False;2;Space (10);Header (Quest Depth Fade);False;2;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;262;-2944,848;Inherit;False;Property;_QuestDepthFadeBlueNoiseSize;Blue Noise Size;39;0;Create;False;1;Quest Depth Fade;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-704,-224;Float;False;Property;_ColorEdgeBlend;Color Edge Blend;4;0;Create;True;0;0;0;False;0;False;1;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;392;-1792,1568;Inherit;False;Gradient;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;177;352,-304;Inherit;False;176;Alpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;443;544,-400;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;328;688,-400;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;329;288,464;Inherit;False;328;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;510;320,544;Inherit;False;Constant;_0;0;41;0;Create;True;0;0;0;False;0;False;0;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;511;288,624;Inherit;False;176;Alpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;212;256,704;Inherit;False;197;QuestDepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;512;544,384;Inherit;False;BRDFMap;41;;61515;1affaac2d6e57354aaa8d6573a2b32b8;0;1;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;500;480,464;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;501;480,464;Float;False;True;-1;3;LuminousLightbeamGUI;0;15;AtlasShaders/Luminous Light Volumes/Luminous Lightbeam Lit;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;23;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;True;12;all;0;False;True;1;1;False;;1;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;48;Workflow;0;639207679052410894;Surface;1;639207677083751135;  Refraction Model;0;0;  Blend;2;639207678742723961;Two Sided;1;639207678772290125;Fragment Normal Space;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;0;639207677028298809;  Use Shadow Threshold;0;0;Receive Shadows;0;639207677035791573;GPU Instancing;1;639207677050946964;LOD CrossFade;0;0;Built-in Fog;1;0;Lightmaps;1;0;Volumetrics;1;0;Decals;0;0;Screen Space Occlusion;1;639207676982868948;Reflection Probe Blend/Projection;0;639207683959547225;Light Layers;0;0;_FinalColorxAlpha;0;0;Meta Pass;1;639210206326980667;GBuffer Pass;0;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;1;639207676891684478;  Early Z;0;0;Vertex Position;1;0;Debug Display;0;0;Clear Coat;0;0;Fluorescence;0;0;0;10;False;True;False;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;502;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;503;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;504;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;505;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;1;False;;1;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;506;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;507;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;True;1;1;False;;1;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;1;LightMode=None;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;508;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;509;464,416;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;True;4;d3d11;glcore;gles;gles3;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;109;1;108;0
WireConnection;109;0;101;0
WireConnection;295;0;291;2
WireConnection;295;1;294;0
WireConnection;110;0;109;0
WireConnection;105;0;106;0
WireConnection;102;0;110;2
WireConnection;102;1;100;0
WireConnection;293;0;291;1
WireConnection;293;1;294;0
WireConnection;296;0;295;0
WireConnection;103;0;110;0
WireConnection;103;1;100;0
WireConnection;111;0;105;0
WireConnection;495;0;102;0
WireConnection;492;0;489;0
WireConnection;492;1;493;0
WireConnection;304;0;296;0
WireConnection;297;0;293;0
WireConnection;104;0;103;0
WireConnection;104;1;495;0
WireConnection;104;2;111;0
WireConnection;497;0;491;0
WireConnection;499;0;492;0
WireConnection;279;0;297;0
WireConnection;279;1;304;0
WireConnection;491;0;104;0
WireConnection;491;1;499;0
WireConnection;487;0;497;0
WireConnection;278;1;279;0
WireConnection;278;7;298;0
WireConnection;406;0;404;0
WireConnection;94;1;491;0
WireConnection;496;0;487;0
WireConnection;239;0;43;0
WireConnection;343;12;278;0
WireConnection;343;21;344;0
WireConnection;407;0;406;0
WireConnection;91;0;4;0
WireConnection;459;0;452;0
WireConnection;488;1;94;0
WireConnection;488;0;496;0
WireConnection;89;0;73;0
WireConnection;83;0;85;0
WireConnection;41;8;239;0
WireConnection;338;0;343;0
WireConnection;338;1;339;0
WireConnection;408;0;407;0
WireConnection;368;0;367;3
WireConnection;450;0;449;0
WireConnection;450;1;459;0
WireConnection;3;0;2;0
WireConnection;3;1;91;0
WireConnection;127;0;488;0
WireConnection;127;1;128;0
WireConnection;245;0;244;0
WireConnection;246;0;243;0
WireConnection;173;0;172;0
WireConnection;84;0;89;0
WireConnection;84;1;83;0
WireConnection;252;1;404;0
WireConnection;252;0;251;0
WireConnection;189;0;41;0
WireConnection;340;0;338;0
WireConnection;405;0;408;0
WireConnection;456;0;368;0
WireConnection;456;1;450;0
WireConnection;222;0;223;0
WireConnection;441;0;3;0
WireConnection;112;0;127;0
WireConnection;251;28;248;0
WireConnection;251;30;249;0
WireConnection;251;24;247;0
WireConnection;251;25;245;0
WireConnection;251;26;246;0
WireConnection;174;0;84;0
WireConnection;174;1;173;0
WireConnection;256;1;252;0
WireConnection;256;0;405;0
WireConnection;133;0;189;0
WireConnection;269;0;5;0
WireConnection;357;0;346;0
WireConnection;375;0;456;0
WireConnection;92;0;441;0
WireConnection;80;0;174;0
WireConnection;255;1;404;0
WireConnection;255;0;251;23
WireConnection;63;0;256;0
WireConnection;270;0;269;0
WireConnection;224;0;219;0
WireConnection;224;2;225;0
WireConnection;334;0;341;0
WireConnection;359;0;357;0
WireConnection;374;1;375;0
WireConnection;374;7;458;0
WireConnection;5;0;93;0
WireConnection;136;0;80;0
WireConnection;64;0;255;0
WireConnection;267;0;270;0
WireConnection;267;1;266;0
WireConnection;220;1;221;0
WireConnection;220;0;224;0
WireConnection;345;1;346;0
WireConnection;345;0;334;0
WireConnection;358;0;359;0
WireConnection;411;0;8;4
WireConnection;395;0;374;4
WireConnection;10;0;5;0
WireConnection;10;1;11;0
WireConnection;272;0;65;0
WireConnection;272;1;267;0
WireConnection;227;1;228;0
WireConnection;227;0;220;0
WireConnection;355;1;358;0
WireConnection;355;0;345;0
WireConnection;40;0;10;0
WireConnection;40;1;68;0
WireConnection;40;2;66;0
WireConnection;40;3;137;0
WireConnection;40;4;272;0
WireConnection;40;5;227;0
WireConnection;40;6;355;0
WireConnection;40;7;396;0
WireConnection;40;8;412;0
WireConnection;176;0;40;0
WireConnection;260;0;264;0
WireConnection;264;2;263;0
WireConnection;264;24;262;0
WireConnection;259;1;258;0
WireConnection;259;0;260;0
WireConnection;197;0;259;0
WireConnection;258;1;265;0
WireConnection;258;0;264;0
WireConnection;143;0;8;5
WireConnection;95;1;403;0
WireConnection;95;0;113;0
WireConnection;326;0;398;0
WireConnection;326;1;414;0
WireConnection;326;2;301;0
WireConnection;414;0;95;0
WireConnection;431;0;10;0
WireConnection;431;1;68;0
WireConnection;431;2;66;0
WireConnection;431;3;137;0
WireConnection;431;4;272;0
WireConnection;431;5;227;0
WireConnection;431;6;396;0
WireConnection;431;7;412;0
WireConnection;432;0;431;0
WireConnection;327;1;95;0
WireConnection;327;0;326;0
WireConnection;434;0;179;0
WireConnection;434;2;435;0
WireConnection;421;0;434;0
WireConnection;146;0;327;0
WireConnection;146;1;181;0
WireConnection;147;1;146;0
WireConnection;147;0;7;0
WireConnection;401;0;147;0
WireConnection;401;1;393;0
WireConnection;402;1;147;0
WireConnection;402;0;401;0
WireConnection;419;0;9;0
WireConnection;419;1;416;0
WireConnection;7;0;419;0
WireConnection;7;1;146;0
WireConnection;7;2;421;0
WireConnection;392;0;374;0
WireConnection;443;0;402;0
WireConnection;443;1;177;0
WireConnection;328;0;443;0
WireConnection;501;0;329;0
WireConnection;501;9;510;0
WireConnection;501;4;510;0
WireConnection;501;6;511;0
WireConnection;501;17;212;0
ASEEND*/
//CHKSM=E0FD2C2C2A5B2B87ADA860B57A9399869E3961DD