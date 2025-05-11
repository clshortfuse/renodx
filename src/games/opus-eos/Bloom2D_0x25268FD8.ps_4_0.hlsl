#include "./shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Mon Apr 14 21:43:06 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[30];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-1, -1, 1, 1) * cb0[28].xyxy;
  r1.x = 0.5 * cb0[29].x;
  r2.xyzw = saturate(r0.xyzy * r1.xxxx + v1.xyxy);
  r0.xyzw = saturate(r0.xwzw * r1.xxxx + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r1.xyzw = cb0[26].xxxx * r2.xyzw;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  o0.xyzw = r0.xyzw * float4(0.25, 0.25, 0.25, 0.25) * shader_injection.bloom_radius + r1.xyzw * pow(shader_injection.bloom_intensity, 2.f);  // Bloom radius and intensity
  return;
}
