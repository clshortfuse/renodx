#include "./shared.h"

float UpgradeToneMapRatio(float color_hdr, float color_sdr, float post_process_color) {
  [branch]
  if (color_hdr < color_sdr) {
    // If subtracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return color_hdr / color_sdr;
  } else {
    float delta = color_hdr - color_sdr;
    delta = max(0, delta);  // Cleans up NaN
    const float ap1_new = post_process_color + delta;

    const bool ap1_valid = (post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / post_process_color) : 0;
  }
}

float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength, uint working_color_space = 1u, uint hue_processor = 0u) {
  // float ratio = 1.f;

  float3 working_hdr, working_sdr, working_post_process;

  [branch]
  if (working_color_space == 2u) {
    working_hdr = max(0, renodx::color::ap1::from::BT709(color_hdr));
    working_sdr = max(0, renodx::color::ap1::from::BT709(color_sdr));
    working_post_process = max(0, renodx::color::ap1::from::BT709(post_process_color));
  } else
    [branch] if (working_color_space == 1u) {
      working_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
      working_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
      working_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));
    }
  else {
    working_hdr = max(0, color_hdr);
    working_sdr = max(0, color_sdr);
    working_post_process = max(0, post_process_color);
  }

  float3 ratio = float3(
      UpgradeToneMapRatio(working_hdr.r, working_sdr.r, working_post_process.r),
      UpgradeToneMapRatio(working_hdr.g, working_sdr.g, working_post_process.g),
      UpgradeToneMapRatio(working_hdr.b, working_sdr.b, working_post_process.b));

  float3 color_scaled = max(0, working_post_process * ratio);

  [branch]
  if (working_color_space == 2u) {
    color_scaled = renodx::color::bt709::from::AP1(color_scaled);
  } else
    [branch] if (working_color_space == 1u) {
      color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
    }

  float peak_correction;
  [branch]
  if (working_color_space == 2u) {
    peak_correction = saturate(1.f - renodx::color::y::from::AP1(working_post_process));
  } else
    [branch] if (working_color_space == 1u) {
      peak_correction = saturate(1.f - renodx::color::y::from::BT2020(working_post_process));
    }
  else {
    peak_correction = saturate(1.f - renodx::color::y::from::BT709(working_post_process));
  }

  [branch]
  if (hue_processor == 2u) {
    color_scaled = renodx::color::correct::HuedtUCS(color_scaled, post_process_color, peak_correction);
  } else
    [branch] if (hue_processor == 1u) {
      color_scaled = renodx::color::correct::HueICtCp(color_scaled, post_process_color, peak_correction);
    }
  else {
    color_scaled = renodx::color::correct::HueOKLab(color_scaled, post_process_color, peak_correction);
  }
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

float3 UpgradeToneMap(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  if (RENODX_TONE_MAP_RESTORATION_METHOD == 1.f) {
    return UpgradeToneMapPerChannel(color_hdr, color_sdr, post_process_color, post_process_strength);
  }
  return UpgradeToneMapByLuminance(color_hdr, color_sdr, post_process_color, post_process_strength);
}

float3 DisplayMapAndScale(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 FinalizeOutput(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  color = renodx::color::bt709::clamp::AP1(color);
  color *= RENODX_GRAPHICS_WHITE_NITS;

  color /= 80.f;  // or PQ
  return color;
}

/// Applies a customized version of RenoDRT tonemapper that tonemaps down to 1.0.
/// This function is used to compress HDR color to SDR range for use alongside `UpgradeToneMap`.
///
/// @param lutInputColor The color input that needs to be tonemapped.
/// @return The tonemapped color compressed to the SDR range, ensuring that it can be applied to SDR color grading with `UpgradeToneMap`.
float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.05f;
  renodrt_config.saturation = 1.03f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.hue_correction_strength = 0.f;
  // renodrt_config.hue_correction_source = renodx::tonemap::uncharted2::BT709(untonemapped);
  renodrt_config.hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
  renodrt_config.working_color_space = 1u;
  renodrt_config.per_channel = false;

  float3 renoDRTColor = renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
  renoDRTColor = lerp(untonemapped, renoDRTColor, saturate(renodx::color::y::from::BT709(untonemapped) / renodrt_config.mid_gray_value));

  return saturate(renoDRTColor);
}

renodx::tonemap::config::DualToneMap ToneMap(float3 color, float3 vanillaColor, float vanillaMidGray) {
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = RENODX_TONE_MAP_TYPE;
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION - 1;
  config.mid_gray_value = vanillaMidGray;
  config.mid_gray_nits = vanillaMidGray * 100.f;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;

  // RenoDRT Settings
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0;
  config.reno_drt_highlights = 0.84f;
  config.reno_drt_contrast = 1.64f;
  config.reno_drt_saturation = 1.04f;
  config.reno_drt_flare = lerp(0, 0.008f, pow(RENODX_TONE_MAP_FLARE, 10.f));
  config.reno_drt_shadows = 1.f;
  config.reno_drt_working_color_space = 0u;
  config.reno_drt_blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  // config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = 0.f;
  // config.hue_correction_color = vanillaColor;

  renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(color, config);
  dual_tone_map.color_sdr = saturate(dual_tone_map.color_sdr);

  return dual_tone_map;
}
