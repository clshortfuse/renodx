#include "./shared.h"

renodx::tonemap::Config getCommonConfig() {
  float vanillaMidGray = 0.18f;  // calculate mid grey from the second hable run
  float renoDRTContrast = 1.f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.f;  //
  float renoDRTHighlights = 1.f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
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

  return config;
}