// ---- Created with 3Dmigoto v1.3.16 on Thu May 14 14:08:19 2026

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
  float4 g_ConstColor : packoffset(c128);
  float4 g_ConstColorAdd : packoffset(c129);
  float4 g_TextBlurWeights : packoffset(c130);
  float4 g_ConstColorMul : packoffset(c131);
  float4 g_DistanceFieldFloatArray[5] : packoffset(c132);
}

SamplerState s0_s : register(s0);
Texture2D<float4> s0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(g_DistanceFieldFloatArray[0].x == -1.000000);
  if (r0.x != 0) {
    r0.y = s0.Sample(s0_s, v1.xy).w;
    r0.x = 1;
    o0.xyzw = r0.xxxy * g_ConstColorMul.xyzw + g_ConstColorAdd.xyzw;
    o0.xyz = ApplyAC3RUIBrightness(o0.xyz);
    return;
  }
  r0.x = s0.Sample(s0_s, v1.xy).w;
  r0.x = 1 + -r0.x;
  r0.y = cmp(g_DistanceFieldFloatArray[1].x != -1.000000);
  if (r0.y != 0) {
    r0.yz = cmp(g_DistanceFieldFloatArray[1].zw != float2(0,0));
    r0.y = (int)r0.z | (int)r0.y;
    if (r0.y != 0) {
      r0.yz = g_DistanceFieldFloatArray[1].zw + v1.xy;
      r0.y = s0.Sample(s0_s, r0.yz).w;
      r0.y = 1 + -r0.y;
    } else {
      r0.y = r0.x;
    }
    r0.z = cmp(r0.y >= g_DistanceFieldFloatArray[1].x);
    r0.w = cmp(r0.y < g_DistanceFieldFloatArray[1].y);
    r1.x = g_DistanceFieldFloatArray[1].y + -g_DistanceFieldFloatArray[1].x;
    r0.y = -g_DistanceFieldFloatArray[1].x + r0.y;
    r1.x = 1 / r1.x;
    r0.y = saturate(r1.x * r0.y);
    r1.x = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r1.x * r0.y;
    r0.y = r0.w ? r0.y : 1;
    r1.xyz = g_DistanceFieldFloatArray[3].xyz + -g_ConstColor.xyz;
    r1.xyz = r0.yyy * r1.xyz + g_ConstColor.xyz;
    r1.xyz = r0.zzz ? r1.xyz : g_ConstColor.xyz;
  } else {
    r1.xyz = g_ConstColor.xyz;
  }
  r0.y = cmp(g_DistanceFieldFloatArray[0].x != g_DistanceFieldFloatArray[0].y);
  r0.z = g_DistanceFieldFloatArray[0].x + -g_DistanceFieldFloatArray[0].y;
  r0.w = -g_DistanceFieldFloatArray[0].y + r0.x;
  r0.z = 1 / r0.z;
  r0.z = saturate(r0.w * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.w = cmp(g_DistanceFieldFloatArray[0].y >= r0.x);
  r0.w = r0.w ? 1.000000 : 0;
  r1.w = r0.y ? r0.z : r0.w;
  r0.y = cmp(g_DistanceFieldFloatArray[2].x != -1.000000);
  if (r0.y != 0) {
    r0.yz = cmp(g_DistanceFieldFloatArray[2].zw != float2(0,0));
    r0.y = (int)r0.z | (int)r0.y;
    if (r0.y != 0) {
      r0.yz = g_DistanceFieldFloatArray[2].zw + v1.xy;
      r0.y = s0.Sample(s0_s, r0.yz).w;
      r0.x = 1 + -r0.y;
    }
    r0.y = cmp(g_DistanceFieldFloatArray[2].y >= r0.x);
    r0.z = cmp(g_DistanceFieldFloatArray[2].x < r0.x);
    r0.w = g_DistanceFieldFloatArray[2].x + -g_DistanceFieldFloatArray[2].y;
    r0.x = -g_DistanceFieldFloatArray[2].y + r0.x;
    r0.w = 1 / r0.w;
    r0.x = saturate(r0.x * r0.w);
    r0.w = r0.x * -2 + 3;
    r0.x = r0.x * r0.x;
    r0.x = r0.w * r0.x;
    r2.w = r0.z ? r0.x : 1;
    r2.xyz = g_DistanceFieldFloatArray[4].xyz;
    r3.xyzw = -r2.xyzw + r1.xyzw;
    r2.xyzw = r1.wwww * r3.xyzw + r2.xyzw;
    r1.xyzw = r0.yyyy ? r2.xyzw : r1.xyzw;
  }
  o0.xyzw = r1.xyzw * g_ConstColorMul.xyzw + g_ConstColorAdd.xyzw;
  o0.xyz = ApplyAC3RUIBrightness(o0.xyz);
  return;
}
