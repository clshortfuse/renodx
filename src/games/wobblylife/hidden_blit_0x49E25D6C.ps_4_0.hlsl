#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Fri Feb  6 21:12:54 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xyzw = cb0[3].xyzw * r0.xyzw;
  o0.a = saturate(o0.a);

  if (RENODX_TONE_MAP_TYPE != 0.f && CUSTOM_IS_WARDROBE_RENDER == 1.f) {
    o0.rgb = renodx::color::srgb::Decode(max(0, o0.rgb));
    o0.rgb = WobblyApplyOutputToneMap(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }
  return;
}
