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

float UpgradeToneMapRatio(float ap1_color_hdr, float ap1_color_sdr, float ap1_post_process_color) {
  if (ap1_color_hdr < ap1_color_sdr) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return ap1_color_hdr / ap1_color_sdr;
  } else {
    float ap1_delta = ap1_color_hdr - ap1_color_sdr;
    ap1_delta = max(0, ap1_delta);  // Cleans up NaN
    const float ap1_new = ap1_post_process_color + ap1_delta;

    const bool ap1_valid = (ap1_post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / ap1_post_process_color) : 0;
  }
}
float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

  float3 ap1_hdr = max(0, renodx::color::ap1::from::BT709(color_hdr));
  float3 ap1_sdr = max(0, renodx::color::ap1::from::BT709(color_sdr));
  float3 ap1_post_process = max(0, renodx::color::ap1::from::BT709(post_process_color));

  float3 ratio = float3(
      UpgradeToneMapRatio(ap1_hdr.r, ap1_sdr.r, ap1_post_process.r),
      UpgradeToneMapRatio(ap1_hdr.g, ap1_sdr.g, ap1_post_process.g),
      UpgradeToneMapRatio(ap1_hdr.b, ap1_sdr.b, ap1_post_process.b));

  float3 color_scaled = max(0, ap1_post_process * ratio);
  color_scaled = renodx::color::bt709::from::AP1(color_scaled);
  float peak_correction = saturate(1.f - renodx::color::y::from::AP1(ap1_post_process));
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color, peak_correction);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 UpgradeToneMapByLuminance(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

  float3 bt2020_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
  float3 bt2020_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
  float3 bt2020_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));

  float ratio = UpgradeToneMapRatio(
      renodx::color::y::from::BT2020(bt2020_hdr),
      renodx::color::y::from::BT2020(bt2020_sdr),
      renodx::color::y::from::BT2020(bt2020_post_process));

  float3 color_scaled = max(0, bt2020_post_process * ratio);
  color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 ToneMap(float3 color, float2 position) {
  color *= 1.0f;

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

  config.reno_drt_highlights = 1.20f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 1.1f;
  config.reno_drt_saturation = 1.0f;
  config.reno_drt_dechroma = 0;  // 0.80f;  // 0.80f
  config.reno_drt_blowout = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_flare = 0.10 * RENODX_TONE_MAP_FLARE;
  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0;

  // config.reno_drt_highlights = 1.00f;
  // config.reno_drt_shadows = 1.0f;
  // config.reno_drt_contrast = 2.0f;
  // config.reno_drt_saturation = 3.0f * .73 * 2.f;
  // config.reno_drt_dechroma = 2.f * 0.472f * 2.f * injectedData.colorGradeBlowout;
  // config.reno_drt_flare = 0.f;

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
