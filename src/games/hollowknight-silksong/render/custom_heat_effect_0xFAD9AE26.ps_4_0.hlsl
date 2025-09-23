#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 23 10:10:12 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

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
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1, 1) + -w2.xy;
  r0.xyzw = t0.Sample(s2_s, r0.xy).xyzw;
  r0.y = cb0[2].x * v1.z;
  r0.x = r0.y * r0.x;
  r0.x = 0.001953125 * r0.x;
  r0.yz = cb0[6].xy * cb1[0].yy + v2.xy;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r1.x = r1.x * r1.w;
  r0.yz = r1.xy * float2(2, 2) + float2(-1, -1);
  r0.xy = r0.yz * r0.xx + v1.xy;
  r0.xy = r0.xy / v1.ww;
  o0.xyzw = t2.Sample(s0_s, r0.xy).xyzw;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    // o0 = max(0, o0);
    o0 = saturate(o0);
  }
  return;
}
