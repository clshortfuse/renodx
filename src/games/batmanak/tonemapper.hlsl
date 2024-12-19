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

float3 applyUserToneMap(float3 untonemapped, Texture2D lutTexture, SamplerState lutSampler) {
  float3 outputColor = untonemapped;

  float vanillaMidGray = (0.18 / Uncharted2Inverse(0.18f)) * 0.18;
  float3 vanillaColor = renodx::tonemap::uncharted2::BT709(untonemapped, 2.2f);

  renodx::tonemap::Config config = renodx::tonemap::config::Create();

  float renoDRTContrast = 1.12f;
  float renoDRTFlare = lerp(0, 0.10, pow(injectedData.colorGradeFlare, 10.f));
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation;
  float renoDRTHighlights = 1.2f;
  if (injectedData.toneMapPerChannel == 1.f) {
    renoDRTSaturation = 1.14f;
    // hue correction requires per channel display mapping or highlights will have artifacts
    config.hue_correction_strength = injectedData.toneMapHueCorrection;
    config.reno_drt_per_channel = true;
  } else {
    renoDRTSaturation = 1.05f;
    config.hue_correction_strength = 0.f;
  }
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

  outputColor = renodx::tonemap::config::Apply(
      untonemapped,
      config,
      renodx::lut::config::Create(
          lutSampler,
          injectedData.colorGradeLUTStrength,
          0.f,  // Lut scaling not needed
          renodx::lut::config::type::GAMMA_2_2,
          renodx::lut::config::type::GAMMA_2_2,
          16.f),
      lutTexture);

  if (injectedData.toneMapBlend == 1.f && injectedData.toneMapType != 1.f) {
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
