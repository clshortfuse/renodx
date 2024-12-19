#include "./shared.h"

float Uncharted2Inverse(float x) {
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

float3 applyUserToneMap(float3 untonemapped, Texture2D lut_texture, SamplerState lut_sampler) {
  float3 outputColor = untonemapped;

  float vanillaMidGray = (0.18 / Uncharted2Inverse(0.18f)) * 0.18;
  float3 vanillaColor = renodx::tonemap::uncharted2::BT709(untonemapped, 2.2f);

  renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();

  float renoDRTContrast = 1.12f;
  float renoDRTFlare = lerp(0, 0.10, pow(injectedData.colorGradeFlare, 10.f));
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.05f;

  tm_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  if (injectedData.toneMapPerChannel) {
    renoDRTSaturation = 1.f;
  }
  float renoDRTHighlights = 1.2f;

  config.hue_correction_strength = injectedData.toneMapHueCorrection * injectedData.toneMapPerChannel;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel;
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection - 1;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_highlights = renoDRTHighlights;
  config.reno_drt_shadows = renoDRTShadows;
  config.reno_drt_contrast = renoDRTContrast;
  config.reno_drt_saturation = renoDRTSaturation;
  config.reno_drt_dechroma = renoDRTDechroma;
  config.mid_gray_value = vanillaMidGray;
  config.mid_gray_nits = vanillaMidGray * 100.f;
  config.reno_drt_flare = renoDRTFlare;
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_color = vanillaColor;
  config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::DARKTABLE_UCS;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = 2u;


  tm_config.hue_correction_strength = injectedData.toneMapHueCorrection * injectedData.toneMapPerChannel;
  tm_config.reno_drt_per_channel = injectedData.toneMapPerChannel;
  tm_config.type = injectedData.toneMapType;
  tm_config.peak_nits = injectedData.toneMapPeakNits;
  tm_config.game_nits = injectedData.toneMapGameNits;
  tm_config.gamma_correction = injectedData.toneMapGammaCorrection - 1;
  tm_config.exposure = injectedData.colorGradeExposure;
  tm_config.highlights = injectedData.colorGradeHighlights;
  tm_config.shadows = injectedData.colorGradeShadows;
  tm_config.contrast = injectedData.colorGradeContrast;
  tm_config.saturation = injectedData.colorGradeSaturation;
  tm_config.reno_drt_highlights = renoDRTHighlights;
  tm_config.reno_drt_shadows = renoDRTShadows;
  tm_config.reno_drt_contrast = renoDRTContrast;
  tm_config.reno_drt_saturation = renoDRTSaturation;
  tm_config.reno_drt_dechroma = renoDRTDechroma;
  tm_config.mid_gray_value = vanillaMidGray;
  tm_config.mid_gray_nits = vanillaMidGray * 100.f;
  tm_config.reno_drt_flare = renoDRTFlare;
  tm_config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  tm_config.hue_correction_color = vanillaColor;
  tm_config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::DARKTABLE_UCS;
  tm_config.reno_drt_working_color_space = 2u;

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      lut_sampler,
      injectedData.colorGradeLUTStrength,
      0.f,  // Lut scaling not needed
      renodx::lut::config::type::GAMMA_2_2,
      renodx::lut::config::type::GAMMA_2_2,
      16.f);

  if (injectedData.upgradeToneMapPerChannel == 0) {
    outputColor = renodx::tonemap::config::Apply(
        untonemapped,
        tm_config,
        lut_config,
        lut_texture);
  } else {
    if (lut_config.strength == 0.f || tm_config.type == 1.f) {
      outputColor = renodx::tonemap::config::Apply(untonemapped, tm_config);
    } else {
      renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(untonemapped, tm_config);
      float3 color_hdr = tone_maps.color_hdr;
      float3 color_sdr = tone_maps.color_sdr;

      float previous_lut_config_strength = lut_config.strength;
      lut_config.strength = 1.f;
      float3 color_lut = renodx::lut::Sample(lut_texture, lut_config, color_sdr);

      outputColor = UpgradeToneMapPerChannel(color_hdr, color_sdr, color_lut, previous_lut_config_strength);
    }
  }

  if (injectedData.toneMapBlend > 0.f && injectedData.toneMapType != 1.f) {
    float3 vanillaLUTInputColor = min(1.f, pow(vanillaColor, 1.f / 2.2f));
    float3 vanillaLUT = renodx::lut::Sample(lut_texture, lut_sampler, vanillaLUTInputColor).rgb;
    vanillaLUT = pow(vanillaLUT, 2.2f);

    vanillaColor = lerp(vanillaColor, vanillaLUT, injectedData.colorGradeLUTStrength);
    vanillaColor = renodx::color::grade::UserColorGrading(
        vanillaColor,
        injectedData.colorGradeExposure,
        1.f,
        injectedData.colorGradeShadows,
        injectedData.colorGradeContrast,
        injectedData.colorGradeSaturation);

    outputColor = lerp(vanillaColor, outputColor, saturate(vanillaColor));
  }

  if (injectedData.toneMapBlend == 1.f) {
    float3 vanillaLUTInputColor = min(1.f, pow(vanillaColor, 1.f / 2.2f));
    float3 vanillaLUT = renodx::lut::Sample(lutTexture, lutSampler, vanillaLUTInputColor).rgb;
    vanillaLUT = pow(vanillaLUT, 2.2f);

    vanillaColor = lerp(vanillaColor, vanillaLUT, injectedData.colorGradeLUTStrength);
    vanillaColor = renodx::color::grade::UserColorGrading(
        vanillaColor,
        injectedData.colorGradeExposure,
        1.f,
        injectedData.colorGradeShadows,
        injectedData.colorGradeContrast,
        injectedData.colorGradeSaturation);

    outputColor = lerp(vanillaColor, outputColor, saturate(vanillaColor));
  }

  if (injectedData.toneMapGammaCorrection == 0.f) {
    outputColor = renodx::color::correct::GammaSafe(outputColor, true);
  }

  return outputColor;
}
