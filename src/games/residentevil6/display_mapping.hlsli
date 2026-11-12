#ifndef RENODX_RE6_DISPLAY_MAPPING_HLSLI_
#define RENODX_RE6_DISPLAY_MAPPING_HLSLI_

#include "./color_grade.hlsli"

float3 MapGameTone(float3 scene, float mode) {
  [branch]
  if (mode == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.f) peak = renodx::color::correct::GammaSafe(peak, true, 2.2f);
    if (RENODX_GAMMA_CORRECTION == 2.f) peak = renodx::color::correct::GammaSafe(peak, true, 2.4f);
    return renodx::tonemap::psychov::psychotm_test30(
        scene, peak, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS, max(RENODX_TONE_MAP_CONTRAST, 0.01f), RENODX_TONE_MAP_SATURATION,
        1.f, 100.f, 1.f, 1.f, 0, max(RENODX_PSYCHOV30_CONE_RESPONSE, 0.01f),
        0.18f.xxx, 0.18f.xxx, RENODX_PSYCHOV30_GAMUT_COMPRESSION,
        RENODX_PSYCHOV30_GAMUT_MODE >= 0.5f ? 1 : 0, 1.f, RENODX_PSYCHOV30_COMPRESSION);
  }
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.tone_map_type = RENODX_TONE_MAP_TYPE_RENODRT;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;

  // RenoDRT's Hermite spline ends at its scene white limit. Hold that endpoint
  // for inputs beyond it so the spline cannot bend back down in extreme highlights.
  float3 working = renodx::color::convert::ColorSpaces(
      scene, renodx::color::convert::COLOR_SPACE_BT709, config.tone_map_working_color_space);
  if (config.tone_map_working_color_space == renodx::color::convert::COLOR_SPACE_AP1) working = max(working, 0.f);
  float driver = config.tone_map_per_channel == 1.f ? renodx::math::Max(working)
      : renodx::color::convert::Luminance(working, config.tone_map_working_color_space);
  float limit = config.reno_drt_white_clip;
  scene *= limit / max(limit, driver * config.tone_map_exposure);
  return renodx::draw::ToneMapPass(scene, config);
}

#endif
