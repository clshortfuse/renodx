// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of having to manage a wall of code in multiple files

#include "./shared.h"

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;
  if (injectedData.toneMapType == 0.f) {
    outputColor = max(0, untonemapped);  // clamps to 709/no negative colors for the vanilla tonemapper
  } else {
    outputColor = untonemapped;
  }

  float vanillaMidGray = 0.18f;
  float renoDRTContrast = 1.1f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = 0.5f;
  float renoDRTSaturation = 1.15f;
  float renoDRTHighlights = 1.f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create(
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      0,
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      vanillaMidGray,
      vanillaMidGray * 100.f,
      renoDRTHighlights,
      renoDRTShadows,
      renoDRTContrast,
      renoDRTSaturation,
      renoDRTDechroma,
      renoDRTFlare);

  outputColor = renodx::tonemap::config::Apply(outputColor, config);
  outputColor = renodx::color::correct::PowerGammaCorrect(outputColor);  // 2.2 power gamma; might not be needed; but no harm leaving it in

  outputColor *= injectedData.toneMapGameNits;  // Scale by user nits

  outputColor.rgb /= 80.f;

  return outputColor;
}