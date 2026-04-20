#ifndef RE9REQUIEM_COMMON_HLSLI
#define RE9REQUIEM_COMMON_HLSLI

#include "./psycho_test17_custom.hlsli"
#include "./shared.h"

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 ApplyCustomGradingAP1(float3 ungraded) {
  float3 graded = ungraded;

  float3 ungraded_bt2020 = renodx::color::bt2020::from::AP1(ungraded);

  renodx_custom::tonemap::psycho::config17::Config psycho17_config =
      renodx_custom::tonemap::psycho::config17::Create();
  psycho17_config.peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  psycho17_config.clip_point = 100.f;
  psycho17_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  psycho17_config.gamma = RENODX_TONE_MAP_GAMMA;
  psycho17_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  psycho17_config.shadows = RENODX_TONE_MAP_SHADOWS;
  psycho17_config.contrast = RENODX_TONE_MAP_CONTRAST;
  psycho17_config.flare_lms = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  psycho17_config.contrast_highlights = RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS;
  psycho17_config.contrast_shadows = RENODX_TONE_MAP_CONTRAST_SHADOWS;
  psycho17_config.purity_scale = RENODX_TONE_MAP_SATURATION;
  psycho17_config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  psycho17_config.dechroma = RENODX_TONE_MAP_DECHROMA;
  psycho17_config.adaptation_contrast = RENODX_TONE_MAP_ADAPTATION_CONTRAST;
  psycho17_config.bleaching_intensity = 0.f;
  psycho17_config.hue_emulation = 0.f;
  psycho17_config.pre_gamut_compress = false;
  psycho17_config.post_gamut_compress = true;
  psycho17_config.apply_tonemap = false;

  float3 graded_bt2020 = renodx_custom::tonemap::psycho::ApplyTest17BT2020(ungraded_bt2020, ungraded_bt2020, psycho17_config);

  graded = renodx::color::ap1::from::BT2020(graded_bt2020);

  return graded;
}

// User grading -> ACES -> 2.2 EOTF emulation -> apply per channel purity onto luminance curve -> grain -> diffuse white scale + PQ encode
float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float cbuffer_peak_nits, float cbuffer_diffuse_white_nits, float2 uv) {
  untonemapped_ap1 = ApplyCustomGradingAP1(untonemapped_ap1);

  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  float3 tonemapped_bt2020;

  // In order to change ACES_MID, we use The Academy's exp-shift system
  // The curve is built around 4.8 ACES_MID however, so changing it causes the curve to break
  // Values other than 4.8 make it so that increasing peak causes midtones to compress and vice-versa
  // We fix this by basing the exp-shifted curve on reference ACES_MAX and ACES_MIN values
  // We then scale brightness like SDR as a linear scalar
  // ACES_MAX and ACES_MIN are pre-adjusted in order to account for the post-tonemap diffuse white scalar which we define as `10.f * ACES_MID`
  float ACES_MID;
  float EXP_SHIFT_REFERENCE_MAX;
  float EXP_SHIFT_REFERENCE_MIN;
  if (TONE_MAP_ACES_MID_GRAY == 0.f) {
    ACES_MID = 4.8f;
    EXP_SHIFT_REFERENCE_MAX = 48.f;
    EXP_SHIFT_REFERENCE_MIN = 0.02f;
  } else if (TONE_MAP_ACES_MID_GRAY == 1.f) {
    ACES_MID = 10.f;
    EXP_SHIFT_REFERENCE_MAX = 100.f;
    EXP_SHIFT_REFERENCE_MIN = 0.02f;
  } else {
    ACES_MID = 15.f;
    EXP_SHIFT_REFERENCE_MAX = 1000.f;
    EXP_SHIFT_REFERENCE_MIN = 0.0001f;
  }
  const float ACES_DIFFUSE = ACES_MID * 10.f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    aces_min /= 3.f;
  }

  renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / ACES_DIFFUSE;
  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
  }

  tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);

  if (RENODX_TONE_MAP_SCALING == 0.f) {
    float untonemapped_yf = renodx::color::yf::from::AP1(untonemapped_ap1);
    float tonemapped_yf = renodx::tonemap::aces::ODTToneMap(untonemapped_yf, ODT_config) / ACES_DIFFUSE;
    if (RENODX_GAMMA_CORRECTION == 1.f) {
      tonemapped_yf = renodx::color::correct::GammaSafe(tonemapped_yf);
    }
    float3 tonemapped_lum_bt2020 = renodx::color::bt2020::from::AP1(max(0, renodx::color::correct::Luminance(untonemapped_ap1, untonemapped_yf, tonemapped_yf)));

    float t = saturate((tonemapped_yf - 0.1f) / 0.9f);  // 0 at <= 0.1, 1 at >= 1.0
    float hue_amount = lerp(0.5f, 1.0f, t);             // 0.5 in shadows, ramps to 1.0
    tonemapped_bt2020 = renodx_custom::tonemap::psycho::psycho17_ApplyPurityAndHueFromBT2020(
        tonemapped_bt2020, tonemapped_lum_bt2020, 1.f, hue_amount);
  }

  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    tonemapped_bt2020 = renodx::effects::ApplyFilmGrain(
        tonemapped_bt2020, uv, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.06f,
        1.f, false, renodx::color::BT2020_TO_XYZ_MAT);
  }

  return renodx::color::pq::EncodeSafe(tonemapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
}

#endif  // RE9REQUIEM_COMMON_HLSLI
