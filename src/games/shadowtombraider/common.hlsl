#include "./shared.h"

float3 applyUserToneMap(float3 untonemapped) {
  renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();

  float vanillaMidGray = 0.1f;  // ACES mid gray is 10%

  // RENOCES
  float renoDRTHighlights = 0.95f;
  float renoDRTShadows = 1.f;
  float renoDRTContrast = 1.725f;
  float renoDRTSaturation = 3.65f;
  // float renoDRTDechroma = 0.8f;

  if (RENODX_TONE_MAP_TYPE != 2) {  // AP1 highlight hue correction
    float3 incorrect_hue_ap1 = renodx::color::ap1::from::BT709(untonemapped * 0.1f / 0.18f);
    float3 correct_hue = renodx::color::bt709::from::AP1(
        renodx::tonemap::ExponentialRollOff(incorrect_hue_ap1, vanillaMidGray, 2.f));

    tm_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
    tm_config.hue_correction_color = correct_hue;
    tm_config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
    tm_config.reno_drt_hue_correction_method = RENODX_TONE_MAP_HUE_PROCESSOR;
  } else {  // No hue correction if using ACES
    tm_config.hue_correction_strength = 0.0f;
  }

  tm_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  tm_config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0;
  tm_config.type = RENODX_TONE_MAP_TYPE;
  tm_config.peak_nits = RENODX_PEAK_WHITE_NITS;
  tm_config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  tm_config.gamma_correction = 0;
  tm_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  tm_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  tm_config.shadows = RENODX_TONE_MAP_SHADOWS;
  tm_config.contrast = RENODX_TONE_MAP_CONTRAST;
  tm_config.saturation = RENODX_TONE_MAP_SATURATION;
  tm_config.reno_drt_highlights = renoDRTHighlights;
  tm_config.reno_drt_shadows = renoDRTShadows;
  tm_config.reno_drt_contrast = renoDRTContrast;
  tm_config.reno_drt_saturation = renoDRTSaturation;
  tm_config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  tm_config.reno_drt_blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  tm_config.mid_gray_value = vanillaMidGray;
  tm_config.mid_gray_nits = vanillaMidGray * 100.f;
  tm_config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  tm_config.reno_drt_working_color_space = RENODX_TONE_MAP_WORKING_COLOR_SPACE;

  float3 tonemapped = renodx::tonemap::config::Apply(untonemapped, tm_config);

  return tonemapped;
}
