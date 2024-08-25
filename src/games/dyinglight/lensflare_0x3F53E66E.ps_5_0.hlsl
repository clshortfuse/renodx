#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:05 2024
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s0_s, v2.zw).xyz;
  r0.xyz = v1.xyz * r0.xyz;
  r0.w = t1.SampleLevel(s1_s, v2.xy, 0).x;
  r0.xyz = r0.xyz * r0.www;
  r1.xy = t2.SampleLevel(s2_s, v2.xy, 0).zw;
  r1.x = saturate(cb0[0].y * r1.x + r1.y);
  r0.w = v1.w;
  o0.xyzw = -r0.xyzw * r1.xxxx + r0.xyzw * injectedData.fxLensFlare;
  return;
}