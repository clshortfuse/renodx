// ---- Created with 3Dmigoto v1.3.16 on Sat May 16 21:59:02 2026

#include "./common.hlsli"

cbuffer _Globals : register(b0)
{
  float4 g_AmbientCube[6] : packoffset(c0);
  float4 g_LayeredSkyUserColor : packoffset(c6);
  float4 g_LayeredSkyUserColor1 : packoffset(c7);
  float4 g_LayeredSkyUserColor2 : packoffset(c8);
  float4 g_LayeredSkyUserColor3 : packoffset(c9);
  float4 g_LayeredSkyUserColor4 : packoffset(c10);
  float4 g_CurrentTime : packoffset(c11);
  float4 g_SunColor : packoffset(c12);
  float4 g_SunDirection : packoffset(c13);
  float4 g_WorldLoadingRange : packoffset(c14);
  float4 g_GlobalWindPS : packoffset(c15);
  float4 g_VPOSReverseParams : packoffset(c16);
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
  float4 g_FogParams2 : packoffset(c36);
  float4 g_FogParams1 : packoffset(c37);
  float4 g_MainPlayerPosition : packoffset(c38);
  float4 g_EyeDirection : packoffset(c39);
  float4 g_EyePosition : packoffset(c40);
  float4 g_DisolveFactor : packoffset(c41);
  float4 g_LightShaftColor : packoffset(c42);
  float4 g_LightShaftFade : packoffset(c43);
  float4 g_LightShaftFade2 : packoffset(c44);
  float4 g_EagleVisionColor : packoffset(c45);
  float4x4 g_World : packoffset(c49);
  float4 g_SnowParams : packoffset(c53);
  float3 g_FogReferenceTranslation : packoffset(c59);
  float4 g_FogColor : packoffset(c60);
  float4 g_FogAlbedoExtinction : packoffset(c61);
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
  float4 g_PickingID : packoffset(c124);
  float4 g_EntityLODLevelCol : packoffset(c125);
  float4 g_TexelDensityParams : packoffset(c126);
  float g_EngineTime : packoffset(c127);
  float4 ConstantColor_1 : packoffset(c128);
  float4 ConstantTileOffset_2 : packoffset(c129);
  float4 ConstantTileRatio_3 : packoffset(c130);
}

SamplerState BaseTexture_0_s : register(s0);
SamplerState AlphaTexture_1_s : register(s1);
Texture2D<float4> BaseTexture_0 : register(t0);
Texture2D<float4> AlphaTexture_1 : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1,-1) + float2(0,1);
  r0.xy = r0.xy * ConstantTileRatio_3.xy + ConstantTileOffset_2.xy;
  r0.x = AlphaTexture_1.Sample(AlphaTexture_1_s, r0.xy).w;
  r1.xyzw = BaseTexture_0.Sample(BaseTexture_0_s, v1.xy).xyzw;
  r1.w = r1.w * r0.x;
  r0.xyzw = ConstantColor_1.xyzw * v2.xyzw;
  o0.xyzw = r0.xyzw * r1.xyzw;
  o0.xyz = ApplyAC3RUIBrightness(o0.xyz);
  return;
}
