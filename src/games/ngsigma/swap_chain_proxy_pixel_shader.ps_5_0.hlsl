#include "./shared.h"

float3 applyRenoDice(float3 color) {
  const float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float highlightsShoulderStart = paperWhite;
  return renodx::tonemap::dice::BT709(color.rgb * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
}

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 SV_Target = t0.Sample(s0, uv);

  if (RENODX_TONE_MAP_TYPE) {
    SV_Target.rgb = renodx::color::srgb::DecodeSafe(SV_Target.rgb);

    SV_Target.rgb = renodx::color::bt709::from::AP1(SV_Target.rgb);
    SV_Target.rgb = renodx::color::correct::Hue(SV_Target.rgb, saturate(renodx::tonemap::dice::BT709(SV_Target.rgb, 1.f, 0.5f)), RENODX_TONE_MAP_HUE_CORRECTION);
    SV_Target.rgb = renodx::color::ap1::from::BT709(SV_Target.rgb);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.peak_white_nits = 10000.f;
    draw_config.tone_map_hue_correction = 0.f;
    draw_config.tone_map_hue_shift = 0.f;

    SV_Target.rgb = renodx::draw::ToneMapPass(SV_Target.rgb, draw_config);

    SV_Target.rgb = applyRenoDice(SV_Target.rgb);

    SV_Target.rgb = renodx::color::srgb::EncodeSafe(SV_Target.rgb);
  } else {
    SV_Target = saturate(SV_Target);
  }
  
  return renodx::draw::SwapChainPass(SV_Target);
}
