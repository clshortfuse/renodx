// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 27 02:42:00 2025

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
  float4 FogDepthGradient : packoffset(c129);
  float4 FogDistanceGradient : packoffset(c130);
  float FogMaxDepth : packoffset(c131);
  float FogMaxDistance : packoffset(c132);
  float4 FogTexturesParams : packoffset(c133);
}

SamplerState DepthSampler_s : register(s9);
SamplerState FogRampSampler_s : register(s10);
SamplerState FogExtinctionRampSampler_s : register(s11);
Texture2D<float4> DepthSampler : register(t9);
Texture2D<float4> FogRampSampler : register(t10);
Texture2D<float4> FogExtinctionRampSampler : register(t11);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * g_VPosToUV.xy + g_VPosToUV.zw;
  r0.zw = r0.xy * g_VPOSReverseParams.xy + g_VPOSReverseParams.zw;
  r1.xyzw = DepthSampler.SampleLevel(DepthSampler_s, r0.xy, 0).xyzw;
  r0.x = g_ReverseProjectionParams.z + r1.x;
  r1.z = g_ReverseProjectionParams.w / r0.x;
  r1.xy = r1.zz * r0.zw;
  r1.w = 1;
  r0.x = dot(r1.xyzw, g_ViewToWorld._m00_m10_m20_m30);
  r0.y = dot(r1.xyzw, g_ViewToWorld._m01_m11_m21_m31);
  r0.z = dot(r1.xyzw, g_ViewToWorld._m02_m12_m22_m32);
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = sqrt(r0.w);
  r1.xyz = -g_EyePosition.xyz + r0.xyz;
  r0.y = saturate(-r0.z / FogMaxDepth);
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r1.x = saturate(dot(g_SunDirection.xyz, r1.xyz));
  r1.x = log2(r1.x);
  r1.x = 64 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = r1.x * 0.5 + 1;
  r0.x = r0.y * r0.y;
  r0.z = 1;
  r0.x = saturate(dot(FogDepthGradient.xyz, r0.xyz));
  r2.xyzw = FogRampSampler.SampleLevel(FogRampSampler_s, r0.xx, 0).xyzw;
  r0.y = 1 + -r0.x;
  o0.xyz = r2.xyz * r1.xxx;
  r0.z = FogMaxDistance * r2.w;
  r0.z = max(1, r0.z);
  r0.z = r0.w / r0.z;
  r1.y = min(1, r0.z);
  r1.x = r1.y * r1.y;
  r1.z = 1;
  r0.x = saturate(dot(FogDistanceGradient.xyz, r1.xyz));
  r0.xyzw = FogExtinctionRampSampler.SampleLevel(FogExtinctionRampSampler_s, r0.xy, 0).xyzw;
  o0.w = 1 + -r0.w;

  //o0.rgb = max(0, o0.rgb);
  //o0.w = saturate(o0.w);
  return;
}