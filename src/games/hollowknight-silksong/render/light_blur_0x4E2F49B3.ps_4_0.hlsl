#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:26 2025
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

  r0.xz = v1.xx;
  r1.xyzw = cb0[2].yyyy * float4(1.38461494, 3.23076892, -0.615384996, -2.76923108) + v1.yyyy;

  if (CUSTOM_BLUR_FIX == 1.f) {
    // Custom: Fix offset by averaging
    r1.xyzw -= cb0[2].y * (1.38461494 + 3.23076892 + -0.615384996 + -2.76923108) / 4.0;
  } else if (CUSTOM_BLUR_FIX == 2.f) {
    // https://www.rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
    // GaussianOffset(3, 4, 220, 066);  // 3.230769230769231
    // GaussianOffset(1, 2, 792, 495);  // 1.3846153846153846
    // GaussianOffset(2, 4, 792, 495);  // 2.769230769230769
    // GaussianOffset(1, 0, 792, 495);  // 0.615384996
    r1.xyzw = cb0[2].yyyy * float4(1.38461494, 3.23076892, -3.23076892, -1.38461494) + v1.yyyy;
  }

  r0.yw = r1.xz;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = float3(0.316260993, 0.316260993, 0.316260993) * r0.xyz;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r2.xyz * float3(0.227026999, 0.227026999, 0.227026999) + r0.xyz;
  r1.xz = v1.xx;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  o0.xyz = r1.xyz * float3(0.0702700019, 0.0702700019, 0.0702700019) + r0.xyz;
  o0.w = 1;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}
