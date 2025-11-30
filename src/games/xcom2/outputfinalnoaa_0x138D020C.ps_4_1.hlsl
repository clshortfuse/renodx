#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Oct  1 01:04:25 2025

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 SceneShadowsAndDesaturation : packoffset(c6);
  float4 SceneInverseHighLights : packoffset(c7);
  float4 SceneMidTones : packoffset(c8);
  float4 SceneScaledLuminanceWeights : packoffset(c9);
  float4 SceneColorize : packoffset(c10);
  float4 GammaColorScaleAndInverse : packoffset(c11);
  float4 GammaOverlayColor : packoffset(c12);
  float4 RenderTargetExtent : packoffset(c13);
  float4 ImageAdjustments1 : packoffset(c14);
  float4 ImageAdjustments2 : packoffset(c15);
  float4 ImageAdjustments3 : packoffset(c16);
  float InverseGamma : packoffset(c17);
  float3 ColorScale : packoffset(c17.y);
  float4 OverlayColor : packoffset(c18);
}

SamplerState SceneColorTexture_s : register(s0);
Texture2D<float4> SceneColorTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SceneColorTexture.Sample(SceneColorTexture_s, v0.xy).xyzw;
  r1.xyz = ColorScale.xyz * r0.xyz;
  r0.xyz = -r0.xyz * ColorScale.xyz + OverlayColor.xyz;
  o0.w = r0.w;
  r0.xyz = OverlayColor.www * r0.xyz + r1.xyz;
  o0.xyzw = r0.xyzw;
  return;
}