#include "./shared.h"

float3 HueCorrectBT2020(float3 incorrect_color_bt2020, float3 correct_color_bt2020, float hue_correct_strength = 0.5f) {
  float3 incorrect_color_bt709 = renodx::color::bt709::from::BT2020(incorrect_color_bt2020);
  float3 correct_color_bt709 = renodx::color::bt709::from::BT2020(correct_color_bt2020);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(incorrect_color_bt709, correct_color_bt709, hue_correct_strength, 0u);
  float3 corrected_color_bt2020 = renodx::color::bt2020::from::BT709(corrected_color_bt709);
  return corrected_color_bt2020;
}

#include "./shared.h"

float3 ApplyUserToneMap(float3 untonemapped, float mid_gray) {
  renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();

  float vanillaMidGray = mid_gray;  // ACES mid gray is 10%

  // RENOCES
  float renoDRTHighlights = 0.8f;
  float renoDRTShadows = 1.f;
  float renoDRTContrast = 1.46f;
  float renoDRTSaturation = 7.35f;
  float renoDRTDechroma = 0.98;

  if (RENODX_TONE_MAP_TYPE != 2) {  // AP1 highlight hue correction
    float3 incorrect_hue_ap1 = renodx::color::ap1::from::BT709(untonemapped * vanillaMidGray / 0.18f);
    float3 correct_hue = renodx::color::bt709::from::AP1(
        renodx::tonemap::ExponentialRollOff(incorrect_hue_ap1, vanillaMidGray, 2.f));

    tm_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
    tm_config.hue_correction_color = correct_hue;
    tm_config.hue_correction_strength = 0.25f;
    tm_config.reno_drt_hue_correction_method = 0u;
  } else {  // No hue correction if using ACES
    tm_config.hue_correction_strength = 0.0f;
  }

  tm_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  tm_config.reno_drt_per_channel = true;
  tm_config.type = 3u;
  tm_config.peak_nits = 10000.f;
  tm_config.game_nits = 100.f;
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
  tm_config.reno_drt_dechroma = renoDRTDechroma;
  tm_config.reno_drt_blowout = -1.f * (1.25f - 1.f);
  tm_config.mid_gray_value = vanillaMidGray;
  tm_config.mid_gray_nits = vanillaMidGray * 100.f;
  tm_config.reno_drt_flare = 0.10f * pow(0.47f, 10.f);
  tm_config.reno_drt_working_color_space = 2u;

  float3 tonemapped = renodx::tonemap::config::Apply(untonemapped, tm_config);

  return tonemapped;
}