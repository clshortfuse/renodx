#ifndef PRAGMATA_COMMON_HLSLI
#define PRAGMATA_COMMON_HLSLI

#include "./macleod_boynton.hlsli"
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
  psycho17_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  psycho17_config.contrast_highlights = 1.f;
  psycho17_config.contrast_shadows = 1.f;
  psycho17_config.purity_scale = RENODX_TONE_MAP_SATURATION;
  psycho17_config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  psycho17_config.dechroma = RENODX_TONE_MAP_DECHROMA;
  psycho17_config.adaptation_contrast = 1.f;
  psycho17_config.bleaching_intensity = 0.f;
  psycho17_config.hue_emulation = 0.f;
  psycho17_config.pre_gamut_compress = false;
  psycho17_config.post_gamut_compress = true;
  psycho17_config.apply_tonemap = false;

  float3 graded_bt2020 = renodx_custom::tonemap::psycho::ApplyTest17BT2020(ungraded_bt2020, ungraded_bt2020, psycho17_config);

  graded = renodx::color::ap1::from::BT2020(graded_bt2020);

  return graded;
}

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float cbuffer_peak_nits, float cbuffer_diffuse_white_nits, float2 uv) {
  untonemapped_ap1 = ApplyCustomGradingAP1(untonemapped_ap1);

  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  float3 tonemapped_bt2020;

  float ACES_MID;
  if (TONE_MAP_TYPE == 1.f) {
    ACES_MID = 10.f;
  } else {
    ACES_MID = 4.8f;
  }
  const float ACES_DIFFUSE = ACES_MID * 10.f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  // float aces_max = (100.f);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    aces_min /= 10.f;
  }

  renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, ACES_DIFFUSE, 0.02f);

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / ACES_DIFFUSE;
  if (TONE_MAP_TYPE == 1.f) {
    tonemapped_ap1 = lerp(renodx::color::y::from::AP1(tonemapped_ap1), tonemapped_ap1, 0.96);
  }
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
    // tonemapped_bt2020 = CorrectHueAndPurityMB_BT2020(tonemapped_lum_bt2020, tonemapped_bt2020, hue_amount, 1.f);
  }

  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    tonemapped_bt2020 = renodx::effects::ApplyFilmGrain(
        tonemapped_bt2020, uv, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.06f,
        1.f, false, renodx::color::BT2020_TO_XYZ_MAT);
  }

  return renodx::color::pq::EncodeSafe(tonemapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
}

#endif  // PRAGMATA_COMMON_HLSLI
