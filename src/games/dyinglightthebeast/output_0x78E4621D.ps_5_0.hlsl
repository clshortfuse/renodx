#include "./common.hlsli"
// ---- Created with 3Dmigoto v1.4.1 on Thu Sep 18 12:45:04 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    linear noperspective float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.w = r0.w;
  // r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  // r0.xyz = log2(abs(r0.xyz));
  // r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // r1.xyzw = r0.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
  // r0.xy = r0.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
  // r0.x = r0.x / r0.y;
  // r0.x = log2(r0.x);
  // r0.x = 78.84375 * r0.x;
  // o0.z = exp2(r0.x);
  // r0.xy = r1.xz / r1.yw;
  // r0.xy = log2(r0.xy);
  // r0.xy = float2(78.84375, 78.84375) * r0.xy;
  // o0.xy = exp2(r0.xy);
  o0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 1.f);
  return;
}
