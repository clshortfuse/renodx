#include "./shared.h"

float3 ChrominanceOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 correct_ab = correct_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(correct_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);
  incorrect_lab.yz = incorrect_ab * scale;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 ApplyUserToneMap(float3 untonemapped_bt709, float mid_gray) {
  renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();

  float vanillaMidGray = mid_gray;  // ACES mid gray is 10%
  const float diffuse_white_nits = 100.f;
  const float peak_nits = 10000.f;

  const float ACES_MIN = 0.0001f;
  const float ACES_MID_GRAY = 0.10f;
  // const float mid_gray_scale = (0.18f / ACES_MID_GRAY);
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);
  // aces_max /= mid_gray_scale;
  // aces_min /= mid_gray_scale;

#if 1
  aces_max = renodx::color::correct::Gamma(aces_max, true);
  aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

  float3 tonemapped_aces = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f) / 48.f;
  // tonemapped_aces *= mid_gray_scale;

  // RENOCES
  float renoDRTHighlights = 0.8f;
  float renoDRTShadows = 1.f;
  float renoDRTContrast = 1.46f;
  float renoDRTSaturation = 7.35f;
  float renoDRTDechroma = 0.98;

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

  float3 tonemapped_renodrt = renodx::tonemap::config::Apply(untonemapped_bt709, tm_config);

  float y = renodx::color::y::from::BT709(tonemapped_renodrt);
  float blending_ratio = 0.6f;
  float3 tonemapped_blended = lerp(tonemapped_renodrt, tonemapped_aces, saturate(y / blending_ratio));

  return tonemapped_blended;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = max(0, renodx::color::y::from::BT709(incorrect_color));
  const float y_out = renodx::color::correct::Gamma(y_in);

  float3 lum = renodx::color::correct::Luminance(incorrect_color, y_in, y_out);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 uncorrected) {
#if GAMMA_CORRECTION_HUE_PRESERVING
  float3 corrected_color = GammaCorrectHuePreserving(uncorrected);
#else
  float3 corrected_color = renodx::color::correct::GammaSafe(uncorrected);
#endif

  return corrected_color;
}
