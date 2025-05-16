#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[50];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  linear noperspective float4 v1 : TEXCOORD1,
  linear noperspective float4 v2 : TEXCOORD2,
  linear noperspective float4 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.zw, 0).xyzw;
  r0.xyzw = cb0[45].xyzw * r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[44].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v2.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[46].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v2.zw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[47].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v3.xy, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[48].xyzw + r0.xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v3.zw, 0).xyzw;
  r0.xyzw = r1.xyzw * cb0[49].xyzw + r0.xyzw;
  r1.xyzw = t1.SampleLevel(s1_s, v0.xy, 0).xyzw;
  o0.xyzw = r1.xyzw + r0.xyzw;

  o0.rgb *= CUSTOM_BLOOM;
  return;
}