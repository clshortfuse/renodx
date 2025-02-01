#ifndef SRC_FF7REMAKE_COMMON_HLSL_
#define SRC_FF7REMAKE_COMMON_HLSL_

#include "./shared.h"

float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrt_config =
      renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.05f;
  renodrt_config.saturation = 1.05f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.hue_correction_strength = 0.f;
  renodrt_config.tone_map_method =
      renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.working_color_space = 2u;

  return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
}

float3 UpgradeToneMapPerceptual(float3 untonemapped, float3 tonemapped, float3 post_processed, float strength) {
  float3 lab_untonemapped = renodx::color::ictcp::from::BT709(untonemapped);
  float3 lab_tonemapped = renodx::color::ictcp::from::BT709(tonemapped);
  float3 lab_post_processed = renodx::color::ictcp::from::BT709(post_processed);

  float3 lch_untonemapped = renodx::color::oklch::from::OkLab(lab_untonemapped);
  float3 lch_tonemapped = renodx::color::oklch::from::OkLab(lab_tonemapped);
  float3 lch_post_processed = renodx::color::oklch::from::OkLab(lab_post_processed);

  float3 lch_upgraded = lch_untonemapped;
  lch_upgraded.xz *= renodx::math::DivideSafe(lch_post_processed.xz, lch_tonemapped.xz, 0.f);

  float3 lab_upgraded = renodx::color::oklab::from::OkLCh(lch_upgraded);

  float c_untonemapped = length(lab_untonemapped.yz);
  float c_tonemapped = length(lab_tonemapped.yz);
  float c_post_processed = length(lab_post_processed.yz);

  if (c_untonemapped > 0) {
    float new_chrominance = c_untonemapped;
    new_chrominance = min(max(c_untonemapped, 0.25f), c_untonemapped * (c_post_processed / c_tonemapped));
    if (new_chrominance > 0) {
      lab_upgraded.yz *= new_chrominance / c_untonemapped;
    }
  }

  float3 upgraded = renodx::color::bt709::from::ICtCp(lab_upgraded);
  return lerp(untonemapped, upgraded, strength);
}

float3 ToneMap(float3 color, float3 graded_aces, float2 position) {
  color = color * 1.5f;
  // color = renodx::color::correct::GammaSafe(color);

  if (CUSTOM_LUT_STRENGTH != 0) {
    graded_aces = renodx::color::bt709::from::BT2020(graded_aces / (250.f));
    if (CUSTOM_LUT_EXTRACTION == 1.f) {
      const float ACES_MID_GRAY = 0.10f;
      const float ACES_MIN = 0.005f;
      const float mid_gray_scale = (0.18f / ACES_MID_GRAY);
      float aces_min = ACES_MIN / 250.f;
      float aces_max = (1000.f / 250.f);
      aces_max /= mid_gray_scale;
      aces_min /= mid_gray_scale;
      float3 reference_aces = renodx::tonemap::aces::RRTAndODT(color, aces_min * 48.f, aces_max * 48.f);
      reference_aces /= 48.f;
      reference_aces *= mid_gray_scale;

      color = UpgradeToneMapPerceptual(
          color,
          max(0, reference_aces),
          graded_aces,
          CUSTOM_LUT_STRENGTH);

    } else {
      // 0
      renodx::tonemap::renodrt::Config lut_scale_config = renodx::tonemap::renodrt::config::Create();
      float peak = 1000.f / 250.f;
      lut_scale_config.nits_peak = peak * 100.f;
      lut_scale_config.mid_gray_value = 0.18f;
      lut_scale_config.mid_gray_nits = 18.f;
      lut_scale_config.exposure = 1.0f;
      lut_scale_config.contrast = 1.0f;
      lut_scale_config.saturation = 1.0f;
      lut_scale_config.highlights = 1.0f;
      lut_scale_config.shadows = 1.0f;
      lut_scale_config.blowout = 0;
      lut_scale_config.dechroma = 0;
      lut_scale_config.flare = 0;

      color = renodx::tonemap::UpgradeToneMap(
          color,
          renodx::tonemap::renodrt::BT709(color, lut_scale_config),
          graded_aces,
          CUSTOM_LUT_STRENGTH);
    }
  }

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = RENODX_TONE_MAP_TYPE;
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;

  config.reno_drt_highlights = 1.0f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 1.0f;
  config.reno_drt_saturation = 1.0f;
  config.reno_drt_blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0;

  config.reno_drt_hue_correction_method = (uint)RENODX_TONE_MAP_HUE_PROCESSOR;

  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  config.hue_correction_color = color;
  if (CUSTOM_HUE_CORRECTION_METHOD == 1.f) {
    config.hue_correction_color = renodx::tonemap::ACESFittedAP1(color);
  } else if (CUSTOM_HUE_CORRECTION_METHOD == 2.f) {
    config.hue_correction_color = renodx::tonemap::uncharted2::BT709(color * 2.f);
  } else if (CUSTOM_HUE_CORRECTION_METHOD == 3.f) {
    config.hue_correction_color = RenoDRTSmoothClamp(color);
  } else {
    config.hue_correction_type =
        renodx::tonemap::config::hue_correction_type::INPUT;
  }

  color = renodx::tonemap::config::Apply(color, config);

  if (RENODX_GAMMA_CORRECTION == 1) {
    color = renodx::color::correct::GammaSafe(color);
  } else if (RENODX_GAMMA_CORRECTION == 2) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  }

  if (RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE == renodx::draw::COLOR_SPACE_CUSTOM_BT709D93) {
    color = renodx::color::bt709::from::BT709D93(color);
  }

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    color = renodx::effects::ApplyFilmGrain(
        color.rgb,
        position.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }

  color = renodx::color::bt2020::from::BT709(color);

  color = max(0, color);
  return color * RENODX_DIFFUSE_WHITE_NITS;
}

#endif  // SRC_FF7REMAKE_COMMON_HLSL_
