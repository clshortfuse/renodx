#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jun 21 11:20:03 2025

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts[6] : packoffset(c0);
}

SamplerState SceneTexture_s : register(s0);
Texture2D<float4> SceneTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SceneTexture.SampleLevel(SceneTexture_s, v1.xy, 0).xyzw;
  //r0.xyz = log2(r0.xyz);
  //o0.w = r0.w;
  //r0.xyz = InstanceConsts[0].yyy * r0.xyz;
  //o0.xyz = exp2(r0.xyz);
  o0 = r0;
  return;
}