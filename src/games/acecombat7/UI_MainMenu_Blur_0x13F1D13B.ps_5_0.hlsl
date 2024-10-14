// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 11 21:12:59 2024
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  linear noperspective float4 v1 : TEXCOORD1,
  linear noperspective float4 v2 : TEXCOORD2,
  linear noperspective float4 v3 : TEXCOORD3,
  linear noperspective float4 v4 : TEXCOORD4,
  linear noperspective float4 v5 : TEXCOORD5,
  linear noperspective float4 v6 : TEXCOORD6,
  linear noperspective float4 v7 : TEXCOORD7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.zw, 0).xyzw;
  r0.xyzw = cb0[26].xyzw * r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[25].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v2.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[27].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v2.zw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[28].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v3.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[29].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v3.zw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[30].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v4.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[31].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v4.zw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[32].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v5.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[33].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v5.zw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[34].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v6.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[35].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v6.zw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[36].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v7.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[37].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v7.zw, 0).xyzw;
  o0.xyzw = r1.xyzw * cb0[38].xyzw + r0.xyzw;

  
  return;
}