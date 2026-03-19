// ---- Created with 3Dmigoto v1.4.1 on Tue Jan 27 19:44:20 2026

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

  r0.xy = cmp(v3.xy >= cb0[4].xy);
  r0.zw = cmp(cb0[4].zw >= v3.xy);
  r0.xyzw = r0.xyzw ? float4(1,1,1,1) : 0;
  r0.xy = r0.xy * r0.zw;
  r0.x = r0.x * r0.y;
  r0.y = t1.Sample(s1_s, v2.xy).w;
  r0.y = cb0[3].w + r0.y;
  r0.y = v1.w * r0.y;
  o0.w = r0.y * r0.x;
  r0.xyz = t0.SampleLevel(s0_s, v4.xy, 0).xyz;
  r0.xyz = v1.xyz * r0.xyz;
  o0.xyz = cb0[6].xxx * r0.xyz;

  if (UI_VISIBILITY < 0.5f) o0 = 0;

  return;
}