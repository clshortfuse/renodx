// ---- Created with 3Dmigoto v1.3.16 on Tue Nov  5 00:45:39 2024
// Our final shader, where we scale up ui nits + gamma

#include "./shared.h"

SamplerState BlitSampler_s : register(s0);
Texture2D<float4> BlitTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0 : TEXCOORD0,
    float4 v1 : SV_POSITION0,
    out float4 o0 : SV_Target0) {
  o0.xyzw = BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw;

  o0.rgb = renodx::color::correct::GammaSafe(o0.rgb);  // The entire game is Linear, so we don't need pow 2.2 here

  o0.rgb *= injectedData.toneMapGameNits / 80.f;

  // o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);

  return;
}