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
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[0].xyz * v1.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.x = -r2.w + r1.x;
  r2.w = cb1[0].x * r1.x + r2.w;
  r0.w = v1.w;
  r0.xyzw = r2.xyzw * r0.xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
