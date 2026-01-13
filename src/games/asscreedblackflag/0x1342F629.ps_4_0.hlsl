// ---- Created with 3Dmigoto v1.4.1 on Mon Dec  1 16:39:13 2025

cbuffer _Globals : register(b0)
{
  float4 g_AmbientCube[3] : packoffset(c0);
  float4 g_LayeredSkyUserColor : packoffset(c3);
  float4 g_LayeredSkyUserColor3 : packoffset(c4);
  float4 g_LayeredSkyUserColor4 : packoffset(c5);
  float4 g_CurrentTime : packoffset(c6);
  float4 g_HorizonTextureBlend : packoffset(c7);
  float4 g_SunColor : packoffset(c8);
  float4 g_SunDirection : packoffset(c9);
  float4 g_WorldLoadingRange : packoffset(c10);
  float4 g_GlobalWindPS : packoffset(c11);
  float4 g_SkySpritePosition : packoffset(c12);
  float4 g_VPOSReverseParams : packoffset(c13);
  float4 RainUVScroll : packoffset(c15);
  float4 g_RenderingReflections : packoffset(c17);
  float4 g_ViewportScaleOffset : packoffset(c18);
  float4 g_VPosToUV : packoffset(c19);
  float4 g_ReverseProjectionParams : packoffset(c20);
  float2 g_ReverseProjectionParams2 : packoffset(c21);
  float4x4 g_ViewToWorld : packoffset(c22);
  float4x4 g_WorldToView : packoffset(c26);
  float4 g_WorldEntityPosition : packoffset(c30);
  float4 g_EntityRandomSeed : packoffset(c31);
  float4 g_BoundingVolumeSize : packoffset(c32);
  float4 g_EntityToCameraDistance : packoffset(c33);
  float4 g_LODBlendFactor : packoffset(c34);
  float4 g_WeatherInfo : packoffset(c35);
  float4 g_FogWeatherParams : packoffset(c36);
  float4 g_FogParams : packoffset(c37);
  float4 g_MainPlayerPosition : packoffset(c38);
  float4 g_EyeDirection : packoffset(c39);
  float4 g_EyePosition : packoffset(c40);
  float4 g_DisolveFactor : packoffset(c41);
  float4 g_LightShaftColor : packoffset(c42);
  float4 g_LightShaftFade : packoffset(c43);
  float4 g_LightShaftFade2 : packoffset(c44);
  float4 g_EagleVisionColor : packoffset(c45);
  float4 g_FogColor : packoffset(c60);
  float4 g_FogSunBackColor : packoffset(c61);
  float g_AlphaTestValue : packoffset(c62);
  float4 g_NormalScale : packoffset(c63);

  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
  } g_OmniLights[4] : packoffset(c64);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
  } g_DirectLights[2] : packoffset(c72);


  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
    float4 m_Direction;
    float4 m_ConeAngles;
  } g_SpotLights[2] : packoffset(c76);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
    float3 m_SpecularDirection;
  } g_ShadowedDirect : packoffset(c84);

  float4 g_ProjWorldToLight[8] : packoffset(c87);
  float4 g_LightingIrradianceCoeffsR : packoffset(c95);
  float4 g_LightingIrradianceCoeffsG : packoffset(c96);
  float4 g_LightingIrradianceCoeffsB : packoffset(c97);
  float4 g_ProjShadowParams[2] : packoffset(c98);
  float4 g_EntityUniqueIDCol : packoffset(c120);
  float4 g_MaterialUniqueIDCol : packoffset(c121);
  float4 g_ShaderUniqueIDCol : packoffset(c122);
  float4 g_SelectionOverlayCol : packoffset(c123);
  float4 g_ConstDebugReferencePS : packoffset(c124);
  float4 g_PickingID : packoffset(c125);

  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
  } g_DeferredOmniLight : packoffset(c128);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
  } g_DeferredDirectLight : packoffset(c130);


  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
    float4 m_Direction;
    float4 m_ConeAngles;
  } g_DeferredSpotLight : packoffset(c132);

  float4 g_DeferredProjWorldToLight[4] : packoffset(c136);
  float4 g_DeferredProjShadowParams : packoffset(c140);
  float4 g_DeferredBackgroundColor : packoffset(c141);
  float4 g_DepthParams : packoffset(c150);
  float4 g_WorldLightMapParameters1 : packoffset(c155);
  float4 g_WorldLightMapParameters2 : packoffset(c156);
  float4 g_WorldLightMapParameters3 : packoffset(c157);
  float4 g_WorldLightMapUVParameters : packoffset(c158);
  float4 g_WorldAOParameters : packoffset(c144);
  float4 g_WorldAORangeParameters : packoffset(c145);
  float4 g_CausticParameters : packoffset(c142);
  float4 g_WeatherExposedParams : packoffset(c143);
  float4 g_DebugValue : packoffset(c159) = {0,0,0,0};
}

cbuffer ShadowConstscb : register(b1)
{

  struct
  {
    float4 m_CloudUVScaleOffset;
    float4 m_CloudShadowsParams;
    float4 m_ShadowMapSize;
    float4 m_OffsetsY;
    float4 m_OffsetsX;
    float4 m_ScalesY;
    float4 m_ScalesX;
    float4 m_OffsetsZ;
    float4 m_ScalesZ;
    float4 m_OffsetsW;
    float4 m_ScalesW;
    float4 m_NoiseScale;
    float4 m_NearFar;
    float4 m_FadeParams;
    float4 m_CascadesRangesMax;
    float4 m_ShadowContrast;
    float4x4 m_WorldToLightProj;
  } g_Shadows : packoffset(c0);

}

SamplerState DepthSurface_s : register(s2);
SamplerState g_PointClampSampler_NG_s : register(s3);
SamplerState g_WeatherReflectionCubeMap_s : register(s5);
SamplerState g_CloudShadowSampler_s : register(s6);
SamplerState g_WorldLightmapIndirectSampler_s : register(s7);
SamplerState g_WorldLightMapDirectSampler_s : register(s12);
SamplerState g_AmbientTexture_s : register(s13);
Texture2D<float4> g_Albedo_NG : register(t0);
Texture2D<float4> g_Normals_NG : register(t1);
Texture2D<float4> DepthSurface : register(t2);
Texture2D<float4> g_LightingAccumulation_NG : register(t3);
TextureCube<float4> g_WeatherReflectionCubeMap : register(t5);
Texture2D<float4> g_CloudShadowSampler : register(t6);
Texture2D<float4> g_WorldLightmapIndirectSampler : register(t7);
Texture2D<float4> g_WorldLightMapDirectSampler : register(t12);
Texture2D<float4> g_AmbientTexture : register(t13);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0,0);
  r1.xy = v1.xy / v1.ww;
  r1.xy = r1.xy * g_ViewportScaleOffset.xy + g_ViewportScaleOffset.zw;
  r2.xyzw = DepthSurface.SampleLevel(DepthSurface_s, r1.xy, 0).xyzw;
  r0.w = g_ReverseProjectionParams.z + r2.x;
  r0.w = g_ReverseProjectionParams.w / r0.w;
  r2.xyz = v2.xyz * r0.www + v3.xyz;
  r1.zw = r2.xy * g_WorldLightMapUVParameters.zw + g_WorldLightMapUVParameters.xy;
  r3.xyzw = g_WorldLightMapDirectSampler.SampleLevel(g_WorldLightMapDirectSampler_s, r1.zw, 0).xyzw;
  r1.zw = r3.xy * float2(2,2) + float2(-1,-1);
  r4.xy = g_WorldLightMapParameters1.ww * r1.zw;
  r0.z = r3.z * g_WorldLightMapParameters1.x + g_WorldLightMapParameters1.y;
  r4.z = -r2.z;
  r0.xyz = r4.xyz + r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyw = r0.xyz * r0.www;
  r0.z = g_WorldLightMapParameters1.z * abs(r0.z);
  r0.z = -r0.z * r0.z + 1;
  r0.z = saturate(r3.w * r0.z);
  r3.xyz = g_WorldLightMapParameters3.xyz * r0.zzz;
  r4.xyw = g_EyePosition.xyz + -r2.xyz;
  r0.z = dot(r4.xyw, r4.xyw);
  r1.z = rsqrt(r0.z);
  r0.z = sqrt(r0.z);
  r0.z = saturate(g_CausticParameters.w * r0.z);
  r0.z = 1 + -r0.z;
  r5.xyz = r4.xyw * r1.zzz + r0.xyw;
  r1.w = dot(r5.xyz, r5.xyz);
  r1.w = rsqrt(r1.w);
  r5.xyz = r5.xyz * r1.www;
  r6.xyzw = g_Normals_NG.Sample(g_PointClampSampler_NG_s, r1.xy).xyzw;
  r6.xyz = r6.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.w = r6.w + r6.w;
  r2.w = dot(r6.xyz, r6.xyz);
  r2.w = rsqrt(r2.w);
  r7.xyz = r6.xyz * r2.www;
  r2.w = dot(g_DeferredDirectLight.m_Direction.xyz, r6.xyz);
  r3.w = saturate(dot(r7.xyz, r5.xyz));
  r3.w = log2(r3.w);
  r5.xyz = r4.xyw * r1.zzz;
  r4.xyw = r4.xyw * r1.zzz + g_DeferredDirectLight.m_Direction.xyz;
  r1.z = saturate(dot(r5.xyz, r7.xyz));
  r1.z = -r2.z * r1.z + g_WeatherExposedParams.w;
  r6.xyzw = g_Albedo_NG.Sample(g_PointClampSampler_NG_s, r1.xy).xyzw;
  r1.z = saturate(dot(r1.zz, r6.ww));
  r1.z = max(r6.w, r1.z);
  r1.z = r1.z * 2 + -1;
  r2.z = r7.z * 0.5 + r1.z;
  r1.z = saturate(g_WeatherExposedParams.z + r1.z);
  r2.z = saturate(0.5 + r2.z);
  r1.z = r2.z * r1.z;
  r8.xyzw = g_LightingAccumulation_NG.Sample(g_PointClampSampler_NG_s, r1.xy).xyzw;
  r9.xyzw = g_AmbientTexture.Sample(g_AmbientTexture_s, r1.xy).xyzw;
  r1.x = 1 + -r8.w;
  r1.x = r1.z * r1.x;
  r1.y = r1.x * r8.w;
  r1.x = -r1.x * 0.5 + 1;
  r1.y = saturate(r1.y * 1.5 + r8.w);
  r1.z = 8.47996902 * r1.y;
  r1.z = exp2(r1.z);
  r2.z = r1.z * r3.w;
  r2.z = exp2(r2.z);
  r0.x = saturate(dot(r7.xyz, r0.xyw));
  r0.y = r0.x * r2.z;
  r0.w = r1.z * 2 + -2;
  r0.w = 0.125 * r0.w;
  r0.y = r0.y * r0.w;
  r10.xyz = r0.yyy * r3.xyz;
  r10.xyz = float3(0.0599999987,0.0599999987,0.0599999987) * r10.xyz;
  r11.xy = r7.xy * g_WorldLightMapParameters2.xx + r2.xy;
  r11.xy = r11.xy * g_WorldLightMapUVParameters.zw + g_WorldLightMapUVParameters.xy;
  r11.xyzw = g_WorldLightmapIndirectSampler.SampleLevel(g_WorldLightmapIndirectSampler_s, r11.xy, 0).xyzw;
  r0.y = r11.w * g_WorldLightMapParameters1.x + g_WorldLightMapParameters1.y;
  r0.y = r0.y + r4.z;
  r2.xy = r2.xy * g_Shadows.m_CloudUVScaleOffset.xy + g_Shadows.m_CloudUVScaleOffset.zw;
  r12.xyzw = g_CloudShadowSampler.SampleLevel(g_CloudShadowSampler_s, r2.xy, 0).xyzw;
  r2.x = saturate(-g_Shadows.m_CloudShadowsParams.y + r12.x);
  r2.x = saturate(g_Shadows.m_CloudShadowsParams.x + r2.x);
  r2.xyz = g_CausticParameters.xyz * r2.xxx;
  r0.y = r7.z * g_WorldLightMapParameters2.y + r0.y;
  r0.y = g_WorldLightMapParameters1.z * abs(r0.y);
  r0.y = -r0.y * r0.y + 1;
  r0.y = max(0, r0.y);
  r0.y = g_WorldLightMapParameters3.w * r0.y;
  r11.xyz = r11.xyz * r0.yyy;
  r3.xyz = r0.xxx * r3.xyz + r11.xyz;
  r0.x = dot(-r5.xyz, r7.xyz);
  r0.x = r0.x + r0.x;
  r5.xyz = r7.xzy * -r0.xxx + -r5.xzy;
  r0.x = dot(r5.xyz, r5.xyz);
  r0.x = rsqrt(r0.x);
  r5.xyz = r5.xyz * r0.xxx;
  r0.x = 1 + -r1.y;
  o0.w = r1.y;
  r0.x = 6 * r0.x;
  r5.xyzw = g_WeatherReflectionCubeMap.SampleLevel(g_WeatherReflectionCubeMap_s, r5.xyz, r0.x).xyzw;
  r5.xyz = r5.xyz + r5.xyz;
  r5.xyz = r6.xyz * r1.xxx + r5.xyz;
  r5.xyz = float3(-1,-1,-1) + r5.xyz;
  r3.xyz = r3.xyz * r5.xyz + r10.xyz;
  r3.xyz = r8.xyz + r3.xyz;
  r0.x = saturate(r7.z);
  r0.x = r0.x * r0.x;
  r2.xyz = r2.xyz * r0.xxx;
  r0.xyz = r2.xyz * r0.zzz;
  r0.xyz = r0.xyz * r9.www + r3.xyz;
  r1.x = 0.300000012 + -r2.w;
  r2.w = saturate(r2.w);
  r1.x = r1.w * r1.x;
  r1.x = max(0, r1.x);
  r1.x = r2.w + r1.x;
  r2.xyz = g_DeferredDirectLight.m_Color.xyz * r5.xyz;
  r3.xyz = saturate(r9.xyz * r5.xyz);
  r2.xyz = r2.xyz * r9.www;
  r1.xyw = r2.xyz * r1.xxx + r3.xyz;
  r2.x = dot(r4.xyw, r4.xyw);
  r2.x = rsqrt(r2.x);
  r2.xyz = r4.xyw * r2.xxx;
  r2.x = saturate(dot(r7.xyz, r2.xyz));
  r2.x = log2(r2.x);
  r1.z = r2.x * r1.z;
  r1.z = exp2(r1.z);
  r1.z = r2.w * r1.z;
  r0.w = r1.z * r0.w;
  r2.xyz = g_DeferredDirectLight.m_Color.xyz * r0.www;
  r2.xyz = r2.xyz * r9.www;
  r1.xyz = r2.xyz * float3(0.0599999987,0.0599999987,0.0599999987) + r1.xyw;
  o0.xyz = r1.xyz + r0.xyz;

  o0.w = saturate(o0.w);
  return;
}