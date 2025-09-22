#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Mon Sep 22 13:32:04 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[5];
}

cbuffer cb1 : register(b1) {
  float4 cb1[3];
}

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0: TEXCOORD0,
    float2 w0: TEXCOORD2,
    float4 v1: SV_POSITION0,
    float4 v2: COLOR0,
    nointerpolation uint v3: SV_InstanceID0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, w0.xy).xyzw;
  r1.x = (int)v3.x + asint(cb0[0].x);
  r1.y = (uint)r1.x << 1;
  r1.x = (uint)r1.x << 2;
  r0.xyzw = cb1[r1.y + 0].xyzw * r0.xyzw;
  r0.xyzw = v2.xyzw * r0.xyzw;
  r2.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyzw = cb2[r1.x + 0].xyzw * r2.xyzw;
  r0.xyzw = r1.xyzw * v2.xyzw + r0.xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    // o0 = max(0, o0);
    o0 = saturate(o0);
  }
  return;
}
