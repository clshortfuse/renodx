#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar 22 17:32:28 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    float2 w2: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[5].xy * cb1[0].yy + v2.xy;
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.x = r0.x * r0.w;
  r0.xy = r0.xy * float2(2, 2) + float2(-1, -1);
  r0.xy = cb0[2].xx * r0.xy;
  r0.xy = cb0[6].xy * r0.xy;
  r0.xy = r0.xy * v1.zz + v1.xy;
  r0.xy = r0.xy / v1.ww;
  o0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
