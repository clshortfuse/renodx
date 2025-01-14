#include "./shared.h"

float3 applyUserToneMap(float3 untonemapped, float vanillaMidGray) {
  renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();

  // ShortFuse's previous values
  // float renoDRTHighlights = 1.20f;
  // float renoDRTShadows = 1.0f;
  // float renoDRTContrast = 1.80f;
  // float renoDRTSaturation = 1.40f;
  // float renoDRTDechroma = 0.60f;
  // float renoDRTFlare = 0.f;

  // RENOCES
  float renoDRTHighlights = 0.925f;
  float renoDRTShadows = 1.f;
  float renoDRTContrast = 1.485f;
  float renoDRTSaturation = 1.225f;
  float renoDRTDechroma = 0.f;
  float renoDRTFlare = 0.0205f;

  tm_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  tm_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  tm_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
  tm_config.hue_correction_color = renodx::tonemap::ACESFittedAP1(untonemapped);
  tm_config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL;
  tm_config.type = RENODX_TONE_MAP_TYPE;
  tm_config.peak_nits = RENODX_PEAK_WHITE_NITS;
  tm_config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  tm_config.gamma_correction = RENODX_GAMMA_CORRECTION;
  tm_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  tm_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  tm_config.shadows = RENODX_TONE_MAP_SHADOWS;
  tm_config.contrast = RENODX_TONE_MAP_CONTRAST;
  tm_config.saturation = RENODX_TONE_MAP_SATURATION;
  tm_config.reno_drt_highlights = renoDRTHighlights;
  tm_config.reno_drt_shadows = renoDRTShadows;
  tm_config.reno_drt_contrast = renoDRTContrast;
  tm_config.reno_drt_saturation = renoDRTSaturation;
  tm_config.reno_drt_dechroma = renoDRTDechroma;
  tm_config.reno_drt_blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  tm_config.mid_gray_value = vanillaMidGray;
  tm_config.mid_gray_nits = vanillaMidGray * 100.f;
  tm_config.reno_drt_flare = renoDRTFlare;
  tm_config.reno_drt_working_color_space = RENODX_TONE_MAP_WORKING_COLOR_SPACE;

  return renodx::tonemap::config::Apply(untonemapped, tm_config);
}
