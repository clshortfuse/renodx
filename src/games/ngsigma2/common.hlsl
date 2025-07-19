#include "./shared.h"

float3 applyRenoDice(float3 color) {
  const float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  const float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  //const float highlightsShoulderStart = paperWhite;
  const float highlightsShoulderStart = 1.f;
  return renodx::tonemap::dice::BT709(color.rgb * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
}

float3 applyToneMap(float3 color) {
  color = renodx::color::srgb::DecodeSafe(color);

  if (RENODX_TONE_MAP_TYPE) {
    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.peak_white_nits = 10000.f;

    color = renodx::draw::ToneMapPass(color, draw_config);

    color = applyRenoDice(color);
  } else {
    color = saturate(color);
  }

  color = renodx::draw::RenderIntermediatePass(color);

  return color;
}