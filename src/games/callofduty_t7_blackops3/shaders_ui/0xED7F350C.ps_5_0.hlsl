// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 11:48:19 2025

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = max(float2(9.99999968e-021,9.99999968e-021), cb3[0].xy);
  r0.zw = float2(0.5,0.5) + -cb3[0].zw;
  r0.xy = r0.xy * r0.zw;
  r1.xy = -r0.xy * float2(2,2) + v2.xy;
  r1.zw = -r0.xy * float2(4,4) + float2(1,1);
  r1.xy = r1.xy / r1.zw;
  r2.xyzw = float4(0.5,0.5,-0.5,-0.5) + cb3[0].zwzw;
  r1.zw = r2.xy + -r0.zw;
  r1.xy = r1.xy * r1.zw + r0.zw;
  r1.zw = cmp(r0.xy < float2(0.25,0.25));
  r1.xy = r1.zw ? r1.xy : 0;
  r1.zw = -r0.xy * float2(2,2) + float2(1,1);
  r0.xy = r0.xy + r0.xy;
  r1.zw = cmp(v2.xy >= r1.zw);
  r1.zw = r1.zw ? float2(1,1) : 0;
  r2.xy = cmp(r0.xy >= v2.xy);
  r2.xy = r2.xy ? float2(1,1) : 0;
  r3.xy = r2.xy + r1.zw;
  r3.xy = min(float2(1,1), r3.xy);
  r3.xy = float2(1,1) + -r3.xy;
  r1.xy = r3.xy * r1.xy;
  r3.xy = v2.xy / r0.xy;
  r0.zw = r3.xy * r0.zw;
  r0.zw = r2.xy * r0.zw + r1.xy;
  r1.xy = float2(1,1) + -v2.xy;
  r0.xy = r1.xy / r0.xy;
  r0.xy = r0.xy * r2.zw + float2(1,1);
  r0.xy = r1.zw * r0.xy + r0.zw;
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;
  return;
}