#include "./shared.h"

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 3.f) {
    renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();

    float vanillaMidGray = 0.1f;  // ACES mid gray is 10%

    // RENOCES
    float renoDRTHighlights = 0.95f;
    float renoDRTShadows = 1.f;
    float renoDRTContrast = 1.725f;
    float renoDRTSaturation = 3.65f;
    // float renoDRTDechroma = 0.8f;

    if (RENODX_TONE_MAP_TYPE != 2) {  // AP1 highlight hue correction
      float3 incorrect_hue_ap1 = renodx::color::ap1::from::BT709(untonemapped_bt709 * 0.1f / 0.18f);
      float3 correct_hue = renodx::color::bt709::from::AP1(
          renodx::tonemap::ExponentialRollOff(incorrect_hue_ap1, vanillaMidGray, 2.f));

      tm_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
      tm_config.hue_correction_color = correct_hue;
      tm_config.hue_correction_strength = 0.5f;
      tm_config.reno_drt_hue_correction_method = 0u;
    } else {  // No hue correction if using ACES
      tm_config.hue_correction_strength = 0.5f;
    }

    tm_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
    tm_config.reno_drt_per_channel = false;
    tm_config.type = 3.f;
    tm_config.peak_nits = peak_nits;
    tm_config.game_nits = diffuse_white_nits;
    tm_config.gamma_correction = 0;
    tm_config.exposure = 1.f;
    tm_config.highlights = 1.f;
    tm_config.shadows = 1.f;
    tm_config.contrast = 1.f;
    tm_config.saturation = 1.f;
    tm_config.reno_drt_highlights = renoDRTHighlights;
    tm_config.reno_drt_shadows = renoDRTShadows;
    tm_config.reno_drt_contrast = renoDRTContrast;
    tm_config.reno_drt_saturation = renoDRTSaturation;
    tm_config.reno_drt_dechroma = .93f;
    tm_config.reno_drt_blowout = -1.f * (1.f - 1.f);
    tm_config.mid_gray_value = vanillaMidGray;
    tm_config.mid_gray_nits = vanillaMidGray * 100.f;
    tm_config.reno_drt_flare = 0.10f * pow(0.f, 10.f);
    tm_config.reno_drt_working_color_space = 2u;

    tonemapped = renodx::tonemap::config::Apply(untonemapped_bt709, tm_config);

  } else if (RENODX_TONE_MAP_TYPE == 2.f) {
    const float ACES_MIN = 0.0001f;
    float aces_min = ACES_MIN / diffuse_white_nits;
    float aces_max = (peak_nits / diffuse_white_nits);

#if RENODX_GAME_GAMMA_CORRECTION
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

    tonemapped = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f);
    tonemapped /= 48.f;
  } else {
    tonemapped = untonemapped_bt709;
  }

#if RENODX_GAME_GAMMA_CORRECTION
  tonemapped = renodx::color::correct::GammaSafe(tonemapped);
#endif

  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped), diffuse_white_nits);

  return pq_color;
}
