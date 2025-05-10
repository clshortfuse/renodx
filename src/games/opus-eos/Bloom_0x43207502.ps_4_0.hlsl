#include "./shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Mon Apr 14 14:24:10 2025
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
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.x = 1;
  r1.z = cb0[29].x;  // Sampling radius (?)
  r1.xyzw = cb0[28].xyxy * r1.xxzz;
  r2.zw = float2(-1, 0);
  r2.x = cb0[29].x;
  r3.xyzw = saturate(-r1.xywy * r2.xxwx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r3.xyzw = r3.xyzw * float4(2, 2, 2, 2) + r4.xyzw;
  r4.xy = saturate(-r1.zy * r2.zx + v1.xy);
  r4.xy = cb0[26].xx * r4.xy;
  r4.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = saturate(r1.zwxw * r2.zwxw + v1.xyxy);
  r5.xyzw = saturate(r1.zywy * r2.zxwx + v1.xyxy);
  r1.xy = saturate(r1.xy * r2.xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r2.xyzw = cb0[26].xxxx * r5.xyzw;
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r4.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r3.xyzw = r5.xyzw * float4(2, 2, 2, 2) + r3.xyzw;
  r0.xyzw = r0.xyzw * float4(4, 4, 4, 4) + r3.xyzw;
  r0.xyzw = r4.xyzw * float4(2, 2, 2, 2) + r0.xyzw;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r2.xyzw * float4(2, 2, 2, 2) + r0.xyzw * shader_injection.bloom_radius;  // Bloom intensity? - TODO: rename to whatever this actually is
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  o0.xyzw = r0.xyzw * float4(0.0625, 0.0625, 0.0625, 0.0625) + r1.xyzw * pow(shader_injection.bloom_intensity, 2.f);  // Bloom Intensity
}
