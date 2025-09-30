#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 14:18:19 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  o0.xyzw = t0.SampleLevel(s0_s, w1.xy, 0).xyzw;
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);

    o0.rgb = renodx::color::srgb::Decode(o0.rgb);

  } else {
    float4 sampled_color = o0;
    o0.a = sampled_color.a;

    float3 gamma_color = sampled_color.rgb;

    float3 untonemapped = renodx::color::srgb::Decode(gamma_color.rgb);

    o0.rgb = renodx::draw::ToneMapPass(untonemapped);

    [branch]
    if (CUSTOM_GRAIN_STRENGTH != 0.f) {
      o0.rgb = renodx::effects::ApplyFilmGrain(
          o0.rgb,
          v1.xy,
          CUSTOM_RANDOM,
          CUSTOM_GRAIN_STRENGTH * 0.03f,
          1.f);
    }
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}
