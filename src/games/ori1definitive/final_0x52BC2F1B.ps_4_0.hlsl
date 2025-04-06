#include "./shared.h"
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[25];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    float2 v2: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xyz = r0.xyz * cb0[24].xxx + cb0[24].yyy;
  o0.w = r0.w;

  o0 = renodx::math::SignPow(o0, 2.2f);
  o0.rgb *= RENODX_GRAPHICS_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);
  return;
}
