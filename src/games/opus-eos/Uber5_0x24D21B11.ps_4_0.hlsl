#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 17:52:33 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[37];
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

  r0.xyzw = t1.Sample(s1_s, w1.xy).xyzw;

  r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);

  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xxx * r0.xyz;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = Vanilla(r0.rgb, t3, s3_s, cb0[36].xyz, v1.xy, t0, s0_s, cb0[30]);
  } else {
    o0.rgb = ApplyUserTonemap(r0.rgb, t3, s3_s, cb0[36].xyz);
  }

  o0.w = 1;
  return;
}
