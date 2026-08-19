// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of having to manage a wall of code in multiple files

#include "./shared.h"

float3 applyUserTonemap(float3 untonemapped, float3 vanillaColor, float midGray) {
  float3 outputColor;

  if (injectedData.toneMapType == 0.f) {
    outputColor = vanillaColor;
    outputColor = max(0, outputColor);  // clamps to 709/no negative colors for the vanilla tonemapper
  } else {
    outputColor = untonemapped;
  }

  // float vanillaMidGray = 0.1f; //0.18f old default
  float vanillaMidGray = midGray;  // calculate mid grey from the second hable run
  float renoDRTContrast = 1.f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  // float renoDRTDechroma = 0.8f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
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
  config.reno_drt_per_channel = true;  // per channel true fixs blue clouds/blow out related issues

  //  Start hue correction if
  if (injectedData.toneMapHueCorrection == 1.f) {  // Vanilla
    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
    config.hue_correction_color = vanillaColor;
    config.hue_correction_strength = 0.5f;
  }

  else if (injectedData.toneMapHueCorrection == 2.f) {  // RenoDRT Neutral SDR (Default)
    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
    config.hue_correction_color = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
    config.hue_correction_strength = 0.5f;
  }

  // if (injectedData.toneMapHueCorrection == 1.f) {
  //   config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::ICTCP;
  //   config.hue_correction_strength = 1.f;
  // }

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
    if (injectedData.blend)  // HDR/SDR blend for color correction
    {
      outputColor = lerp(vanillaColor, outputColor, saturate(vanillaColor));  // combine tonemappers
    }
  }

  return outputColor;
}
