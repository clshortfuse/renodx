#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar  1 00:56:55 2025

SamplerState s0_s : register(s0);
Texture2D<float4> texture0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  o0.xyzw = texture0.Sample(s0_s, v1.xy).xyzw;

  // prevents artifacts
  o0.rgb = renodx::color::gamma::EncodeSafe(renodx::color::bt709::clamp::BT2020(renodx::color::gamma::DecodeSafe(o0.rgb)));
  o0.w = max(0, o0.w);
  return;
}
