#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 03 03:28:36 2025

SamplerState textureSampler_s : register(s0);
Texture2D<float4> textureSampler : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = textureSampler.Sample(textureSampler_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;
  return;
}