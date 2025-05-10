#include "./common.hlsl"

// Underground
// ---- Created with 3Dmigoto v1.4.1 on Fri Apr 18 00:21:45 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[31];
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
    r0.xyz = Dither(r0.xyz, v1.xy, t0, s0_s, cb0[30]);
  } else {
    r0.xyz = renodx::draw::ToneMapPass(r0.xyz);
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(renodx::color::bt709::clamp::BT2020(r0.xyz));

  o0.w = 1.0;
}
