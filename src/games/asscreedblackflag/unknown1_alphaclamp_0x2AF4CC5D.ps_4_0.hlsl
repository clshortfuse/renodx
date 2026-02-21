// ---- Created with 3Dmigoto v1.4.1 on Mon Nov 24 15:24:54 2025

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
  float4 g_PlaneConstants : packoffset(c128);
  float4 g_blurConstants : packoffset(c129);
}

SamplerState Source_s : register(s0);
SamplerState BlurredSource_s : register(s1);
SamplerState DepthSurface_s : register(s2);
Texture2D<float4> Source : register(t0);
Texture2D<float4> BlurredSource : register(t1);
Texture2D<float4> DepthSurface : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = DepthSurface.SampleLevel(DepthSurface_s, v1.xy, 0).xyzw;
  r0.x = g_ReverseProjectionParams.z + r0.x;
  r0.x = g_ReverseProjectionParams.w / r0.x;
  r0.y = g_PlaneConstants.y + g_PlaneConstants.w;
  r0.z = -r0.x + -r0.y;
  r0.w = g_PlaneConstants.z + -r0.y;
  r0.y = cmp(r0.y < -r0.x);
  r0.z = saturate(r0.z / r0.w);
  r1.xy = g_blurConstants.xz + -g_blurConstants.yy;
  r0.z = r0.z * r1.y + g_blurConstants.y;
  r0.y = r0.y ? r0.z : g_blurConstants.y;
  r0.z = g_PlaneConstants.y + -g_PlaneConstants.w;
  r0.w = r0.z + r0.x;
  r0.x = cmp(-r0.x < r0.z);
  r0.z = -g_PlaneConstants.x + r0.z;
  r0.z = saturate(r0.w / r0.z);
  r0.z = r0.z * r1.x + g_blurConstants.y;
  r0.x = saturate(r0.x ? r0.z : r0.y);
  r1.xyzw = BlurredSource.Sample(BlurredSource_s, v1.xy).xyzw;
  r2.xyzw = Source.Sample(Source_s, v1.xy).xyzw;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  o0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;

  //o0.rgb = max(0, o0.rgb);
  o0.w = saturate(o0.w);
  return;
}