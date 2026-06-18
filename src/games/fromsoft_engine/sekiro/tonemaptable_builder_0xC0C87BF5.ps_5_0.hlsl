// ---- Created with 3Dmigoto v1.4.1 on Sat Jan  4 19:22:57 2025

cbuffer cbToneMap : register(b1)
{
  float3 g_ToneMapInvSceneLumScale : packoffset(c0);
  float4 g_ReinhardParam : packoffset(c1);
  float4 g_ToneMapParam : packoffset(c2);
  float4 g_ToneMapSceneLumScale : packoffset(c3);
  float4 g_AdaptParam : packoffset(c4);
  float4 g_AdaptCenterWeight : packoffset(c5);
  float4 g_BrightPassThreshold : packoffset(c6);
  float4 g_GlareLuminance : packoffset(c7);
  float4 g_BloomBoostColor : packoffset(c8);
  float4 g_vBloomFinalColor : packoffset(c9);
  float4 g_vBloomScaleParam : packoffset(c10);
  float4x3 g_mtxColorMultiplyer : packoffset(c11);
  float4 g_vChromaticAberrationRG : packoffset(c14);
  float4 g_vChromaticAberrationB : packoffset(c15);
  bool4 g_bEnableFlags : packoffset(c16);
  float4 g_vFeedBackBlurParam : packoffset(c17);
  float4 g_vVignettingParam : packoffset(c18);
  float4 g_vHDRDisplayParam : packoffset(c19);
  float4 g_vChromaticAberrationShapeParam : packoffset(c20);
  float4 g_vScreenSize : packoffset(c21);
  float4 g_vSampleDistanceAdjust : packoffset(c22);
  uint4 g_vMaxSampleCount : packoffset(c23);
  float4 g_vScenePreExposure : packoffset(c24);
  float4 g_vCameraParam : packoffset(c25);
}



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float3 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.200000003 * v1.x;
  r0.y = 1 + -v1.x;
  r0.x = r0.x / r0.y;

  
  r0.x = g_ReinhardParam.y * r0.x;
  r0.x = pow(r0.x, g_ReinhardParam.x);
  r0.x = r0.x / (1 + r0.x);
  o0.rgb = pow(r0.x, 1 / g_ToneMapParam.y).xxx;
  o0.w = 1;
  return;
}