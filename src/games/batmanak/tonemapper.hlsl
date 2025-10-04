#include "./shared.h"

float arkhamKnightInverse(float x) {
  // Precomputed constants from Wolfram Alpha output
  float factor = -0.681818f;
  float offset = 0.11086f;
  float denominatorOffset = 1.60747f;
  float discriminantFactor = 1.95606e-6f;
  float a = 5.02194e10f;
  float b = 8.76404e10f;
  float c = 1.49321e9f;

  // Calculate the numerator and denominator
  float numerator = factor * (x - offset);
  float denominator = x - denominatorOffset;

  // Calculate the discriminant
  float discriminant = sqrt(a * x * x + b * x + c);

  // Compute the positive and negative roots
  float positiveRoot = (numerator + discriminantFactor * discriminant) / denominator;
  float negativeRoot = (numerator - discriminantFactor * discriminant) / denominator;

  // Return the positive root (preferred for tonemapping contexts)
  return max(positiveRoot, negativeRoot);
}

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

float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength, uint working_color_space = 2u, uint hue_processor = 2u) {
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

float3 Apply(float3 color_input, renodx::tonemap::Config tm_config, renodx::lut::Config lut_config, Texture2D lut_texture) {
  renodx::tonemap::Config sdr_config = tm_config;

  sdr_config.reno_drt_highlights = 1.2f / tm_config.highlights;
  sdr_config.reno_drt_shadows = 1.f / tm_config.shadows;
  sdr_config.reno_drt_contrast = 1.125f / tm_config.contrast;
  sdr_config.reno_drt_saturation = (1.15f / 1.1f);
  sdr_config.reno_drt_blowout = -0.25f;
  sdr_config.peak_nits = 100.f;
  sdr_config.game_nits = 100.f;
  sdr_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;

  renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(color_input, tm_config, sdr_config);
  float3 color_hdr = tone_maps.color_hdr;
  float3 color_sdr = tone_maps.color_sdr;

  float previous_lut_config_strength = lut_config.strength;
  lut_config.strength = 1.f;

  float3 color_lut = renodx::lut::Sample(lut_texture, lut_config, color_sdr);

  color_lut = renodx::color::gamma::EncodeSafe(color_lut, 2.2f);  // Back to LUT output
  color_lut = renodx::color::srgb::DecodeSafe(color_lut);         // Delinearize as vanilla HDR

  return UpgradeToneMapPerChannel(color_hdr, color_sdr, color_lut, previous_lut_config_strength, 1u, 1u);
}

float3 applyUserToneMap(float3 untonemapped, Texture2D lut_texture, SamplerState lut_sampler) {
  untonemapped = max(0, untonemapped);
  float3 outputColor = untonemapped;

  float vanillaMidGray = renodx::tonemap::uncharted2::BT709(0.18f, 2.2f);
  float3 vanillaColor = renodx::tonemap::uncharted2::BT709(untonemapped, 2.2f);

  renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();

  float renoDRTContrast = 1.12f;
  float renoDRTFlare = lerp(0, 0.10, pow(RENODX_TONE_MAP_FLARE, 10.f));
  float renoDRTShadows = 1.f;
  float renoDRTBlowout = RENODX_TONE_MAP_BLOWOUT;
  float renoDRTHighlights = 1.02f;
  float RenoDRTSaturation = 1.1f;

  tm_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  tm_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  tm_config.reno_drt_per_channel = true;
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
  tm_config.reno_drt_saturation = RenoDRTSaturation;
  tm_config.reno_drt_dechroma = 0.f;
  tm_config.reno_drt_blowout = renoDRTBlowout;
  tm_config.mid_gray_value = vanillaMidGray;
  tm_config.mid_gray_nits = vanillaMidGray * 100.f;
  tm_config.reno_drt_flare = renoDRTFlare;
  tm_config.hue_correction_color = vanillaColor;
  tm_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
  tm_config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  tm_config.reno_drt_working_color_space = 0u;

  if (CUSTOM_TONE_MAP_STRATEGY == 1.f && RENODX_TONE_MAP_TYPE != 1.f) {
    tm_config.exposure = 1.f;
    tm_config.shadows = 1.f;
    tm_config.contrast = 1.f;
    tm_config.saturation = 1.f;
    tm_config.reno_drt_flare = 0.f;
  }
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  lut_config.size = 16;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;

  if (CUSTOM_TONE_MAP_STRATEGY == 2.f && RENODX_TONE_MAP_TYPE == 3.f) {
    float3 true_vanilla = renodx::lut::Sample(vanillaColor, lut_config, lut_texture);
    true_vanilla = renodx::color::gamma::EncodeSafe(true_vanilla, 2.2f);  // Back to LUT output
    true_vanilla = renodx::color::srgb::DecodeSafe(true_vanilla);         // Delinearize as vanilla HDR

    // Vanilla goes to 2.2 for LUT sampling and output
    vanillaColor = renodx::color::correct::GammaSafe(vanillaColor, true);
    untonemapped *= vanillaMidGray / 0.18f;
    return renodx::draw::ToneMapPass(untonemapped, true_vanilla);
  }

  outputColor = Apply(
      untonemapped,
      tm_config,
      lut_config,
      lut_texture);

  if (CUSTOM_TONE_MAP_STRATEGY == 1.f && RENODX_TONE_MAP_TYPE != 1.f) {
    float3 vanillaLUTInputColor = min(1.f, pow(vanillaColor, 1.f / 2.2f));
    float3 vanillaLUT = renodx::lut::Sample(lut_texture, lut_sampler, vanillaLUTInputColor).rgb;
    vanillaLUT = pow(vanillaLUT, 2.2f);

    vanillaColor = lerp(vanillaColor, vanillaLUT, CUSTOM_LUT_STRENGTH);

    float3 negHDR = min(0, outputColor);
    outputColor = lerp(vanillaColor, max(0, outputColor), saturate(vanillaColor)) + negHDR;
  }

  return outputColor;
}
