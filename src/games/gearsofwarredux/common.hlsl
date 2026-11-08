#ifndef SRC_GAMES_GEARSOFWARREDUX_COMMON_HLSL_
#define SRC_GAMES_GEARSOFWARREDUX_COMMON_HLSL_

#include "./shared.h"
#include "../../shaders/tonemap/psychov/psychov.hlsl"
#include "./prismTM.hlsl"

// The game applies its grade and gamma before this call. Both SDR clamps are
// bypassed for HDR, so decoding here retains the real scene's highlight range.
float3 GearsToneMap(float3 linear_color) {
  // One shared grade, as in CODWW2. The mappers receive the same signal;
  // Psycho's cone response remains independent of the grading sliders.
  float3 mapped = renodx::color::grade::UserColorGrading(
      linear_color, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST,
      RENODX_TONE_MAP_SATURATION, 0.f, 0.f);
  [branch]
  if (RENODX_TONE_MAP_TYPE == GEARS_TONE_MAP_VANILLA) return mapped;
  float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  [branch]
  if (RENODX_TONE_MAP_TYPE == GEARS_TONE_MAP_SIMPLE) {
    // Preserve the authored SDR range and hue; only roll off bright highlights.
    // One max-channel shoulder avoids per-channel perceptual color processing.
    float maximum = max(max(mapped.r, mapped.g), mapped.b);
    float knee = min(1.f, peak * 0.5f);
    float shoulder = max(maximum - knee, 0.f);
    float compressed = knee + shoulder / (1.f + shoulder / (peak - knee));
    mapped *= maximum > knee ? compressed / maximum : 1.f;
  } else if (RENODX_TONE_MAP_TYPE == GEARS_TONE_MAP_PSYCHOV30) {
    mapped = renodx::tonemap::psychov::psychotm_test30(
        mapped, peak, 1.f, 1.f, 1.f, 1.f, 1.f,
        1.f, 100.f, 1.f, 1.f, 0,
        shader_injection.psychov_cone_response, 0.18f, 0.18f,
        shader_injection.psychov_gamut_compression, 1, 1.f,
        shader_injection.psychov_compression);
  } else if (RENODX_TONE_MAP_TYPE == GEARS_TONE_MAP_PRISM) {
    mapped = prism(mapped, peak);
  } else {
    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.tone_map_type = GEARS_TONE_MAP_RENODRT;
    config.tone_map_exposure = 1.f;
    config.tone_map_highlights = 1.f;
    config.tone_map_shadows = 1.f;
    config.tone_map_contrast = 1.f;
    config.tone_map_saturation = 1.f;
    config.tone_map_highlight_saturation = 1.f;
    config.tone_map_blowout = 0.f;
    // Compress AP1 channels independently so bright colored lights approach
    // white like Prism/Psycho, rather than retaining constant RGB saturation.
    // Bound in that working space before converting back to BT.709; the common
    // RGB bound below then contains any gamut-conversion overshoot.
    config.tone_map_per_channel = 1.f;
    config.tone_map_working_color_space = renodx::color::convert::COLOR_SPACE_AP1;
    config.tone_map_hue_correction = 0.f;
    config.tone_map_clamp_peak = renodx::color::convert::COLOR_SPACE_AP1;
    mapped = renodx::draw::ToneMapPass(mapped, config);
  }
  [branch]
  if (RENODX_TONE_MAP_BLOWOUT != 0.f || RENODX_TONE_MAP_HIGHLIGHT_SATURATION != 1.f) {
    // All HDR mappers use the same chroma controls after mapping.
    mapped = renodx::color::grade::config::ApplyUserColorGrading(
        mapped, renodx::color::grade::config::Create(
            1.f, 1.f, 1.f, 1.f, 0.f, 1.f, RENODX_TONE_MAP_BLOWOUT,
            0.f, 0.f, renodx::color::grade::config::hue_correction_type::INPUT,
            1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION));
  }
  // Prism's outset and chroma adjustments can overshoot. Use one RGB scale
  // for every mapper, instead of RenoDRT's former independent channel clips.
  mapped *= min(1.f, peak / max(max(mapped.r, max(mapped.g, mapped.b)), 1e-6f));
  return mapped;
}

#endif  // SRC_GAMES_GEARSOFWARREDUX_COMMON_HLSL_
