// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of having to manage a wall of code in multiple files

#include "./shared.h"

float3 fast_reinhard(float3 color, float y_max = 1.f, float y_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  float x = (y_max * (y_min * gray_out + y_min - gray_out))
            / (gray_in * (gray_out - y_max));
  float y = x / y_max;
  float z = y_min;
  float w = 1 - y_min;

  return (color * x + z) / (color * y + w);
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;

  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(untonemapped);
  } else {
    outputColor = untonemapped;
  }

  // float vanillaMidGray = 0.1f; //0.18f old default
  float vanillaMidGray = 0.18f;  // Sophie1 has no tonemapper, just running 0.18f/default
  float renoDRTContrast = 1.f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = 0.f;
  // float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.f;  //
  float renoDRTHighlights = 1.f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 1;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;

  // Start hue correction if
  // Reinhard (Default)
  if (injectedData.toneMapHueCorrection == 1.f) {
    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
    config.hue_correction_color = lerp(
        untonemapped,
        renodx::tonemap::Reinhard(untonemapped),
        1.f);
    config.hue_correction_strength = 1.f;
  }
  // Uncharted 2
  if (injectedData.toneMapHueCorrection == 2.f) {
    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
    config.hue_correction_color = lerp(
        untonemapped,
        renodx::tonemap::uncharted2::BT709(untonemapped),
        1.f);
    config.hue_correction_strength = 1.f;
  }

  // fast_reinhard
  // if (injectedData.toneMapHueCorrection == 2.f)
  //{
  //    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  //    config.hue_correction_color = lerp(
  //  untonemapped,
  //  fast_reinhard(untonemapped, injectedData.toneMapPeakNits / injectedData.toneMapGameNits),
  //  1.f);
  //    config.hue_correction_strength = 1.f;
  //}

  config.reno_drt_highlights = renoDRTHighlights;
  config.reno_drt_shadows = renoDRTShadows;
  config.reno_drt_contrast = renoDRTContrast;
  config.reno_drt_saturation = renoDRTSaturation;
  config.reno_drt_dechroma = renoDRTDechroma;
  config.mid_gray_value = vanillaMidGray;
  config.mid_gray_nits = vanillaMidGray * 100.f;
  config.reno_drt_flare = renoDRTFlare;

  outputColor = renodx::tonemap::config::Apply(outputColor, config);

  if (injectedData.toneMapType != 0) {
  }

  return outputColor;
}
// End applyUserTonemap