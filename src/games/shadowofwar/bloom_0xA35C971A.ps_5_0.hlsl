#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 05 23:49:44 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = min(cb3[0].zw, v1.xy);
  r1.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
  r0.xyz = t1.SampleLevel(s0_s, r0.xy, 0).xyz;
  o0.xyz = max(r1.xyz, r0.xyz) * injectedData.fxBloom;
  o0.w = 1;
  return;
}