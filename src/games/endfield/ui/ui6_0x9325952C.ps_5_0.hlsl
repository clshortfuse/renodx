// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 11:53:21 2026
#include "../shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.SampleLevel(s0_s, v4.xy, 0).xyz;
  r0.xyz = v1.xyz * r0.xyz;
  o0.xyz = cb0[6].xxx * r0.xyz;
  r0.x = t1.Sample(s1_s, v2.xy).w;
  r0.x = cb0[3].w + r0.x;
  o0.w = v1.w * r0.x;
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  return;
}