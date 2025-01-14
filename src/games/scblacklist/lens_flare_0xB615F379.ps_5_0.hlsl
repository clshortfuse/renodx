#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 11 03:32:00 2025

cbuffer CB_PerFrame : register(b13) {
  float4 gCameraFadeAlpha : packoffset(c0);
  float4 gCameraFadeShadow : packoffset(c1);
  float4 gColorControl : packoffset(c2);
  float3 cBoostCol : packoffset(c3);
  float cHdrControl : packoffset(c3.w);
  float gAOControl : packoffset(c4);
}

cbuffer CB_PS_FlareMaterial_Static : register(b7) {
  float4 cDiffCol : packoffset(c0);
  float4 cDistance : packoffset(c1);
  float cAlphaTest : packoffset(c2);
}

SamplerState sDiffuseMap_s : register(s0);
Texture2D<float4> sDiffuseMap : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = sDiffuseMap.Sample(sDiffuseMap_s, v1.xy).xyz;
  r0.xyw = r0.xyz * r0.xyz;
  r1.x = r0.x + r0.y;
  o0.xyz = cDiffCol.xyz * r0.xyw * CUSTOM_LENS_FLARE;
  r0.x = r0.z * r0.z + r1.x;
  r0.x = min(1, r0.x);
  r0.x = cDiffCol.w * r0.x;
  o0.w = gColorControl.w * r0.x;
  return;
}
