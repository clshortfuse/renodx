#include "../shared.h"
// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:27 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  float2 adjustedv1 = v1;
  if (CUSTOM_BLUR_FIX == 1.f) {
    // https://www.rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
    // GaussianOffset(3, 4, 220, 066);  // 3.230769230769231
    // GaussianOffset(1, 2, 792, 495);  // 1.3846153846153846
    // GaussianOffset(2, 4, 792, 495);  // 2.769230769230769
    // GaussianOffset(1, 0, 792, 495);  // 0.615384996
    // float weight1 = 0.316260993;
    // float weight2 = 0.0702700019;
    // float offset = -(weight1 * (1.38461494f + -0.615384996) + (weight2 * (3.23076892f + -2.76923108))) / 2.0f;
    float offset = -0.137854845;
    adjustedv1 += cb0[2].xy * offset;
  }

  r0.xyzw = cb0[2].xxxx * float4(3.23076892, 1.38461494, -2.76923108, -0.615384996) + adjustedv1.xxxx;

  r1.xz = r0.yw;
  r1.yw = adjustedv1.yy;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = float3(0.316260993, 0.316260993, 0.316260993) * r1.xyz;
  r2.xyzw = t0.Sample(s0_s, adjustedv1.xy).xyzw;
  r1.xyz = r2.xyz * float3(0.227026999, 0.227026999, 0.227026999) + r1.xyz;
  r0.yw = adjustedv1.yy;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  o0.xyz = r0.xyz * float3(0.0702700019, 0.0702700019, 0.0702700019) + r1.xyz;
  o0.w = 1;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
