#include "./shared.h"

float3 applyRenoDice(float3 color) {
  const float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float highlightsShoulderStart = paperWhite;
  return renodx::tonemap::dice::BT709(color.rgb * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
}

float3 applyToneMap(float3 color) {
  color = renodx::color::srgb::DecodeSafe(color);

  if (RENODX_TONE_MAP_TYPE) {
    color = renodx::color::bt709::from::BT2020(color);
    color = renodx::color::correct::Hue(color, saturate(renodx::tonemap::dice::BT709(color, 1.f, 0.5f)), RENODX_TONE_MAP_HUE_CORRECTION);
    color = renodx::color::bt2020::from::BT709(color);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.peak_white_nits = 10000.f;
    draw_config.tone_map_hue_correction = 0.f;
    draw_config.tone_map_hue_shift = 0.f;

    color = renodx::draw::ToneMapPass(color, draw_config);

    color = applyRenoDice(color);
  } else {
    color = saturate(color);
  }

  color = renodx::draw::RenderIntermediatePass(color);

  return color;
}