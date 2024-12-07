#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.1f;      // Approximately 44%

renodx::tonemap::Config getCommonConfig() {
  float vanillaMidGray = 0.18f;
  float renoDRTContrast = 1.f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.f;
  float renoDRTHighlights = 1.f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();

  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  // We apply these in final shader
  /* config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation; */

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

float3 pqTosRGB(float3 input_pq) {
  float3 output = input_pq;
  if (injectedData.toneMapType > 1.f) {
    output = renodx::color::pq::Decode(input_pq, injectedData.toneMapGameNits);
  }

  return output;
}

float3 upgradePostProcess(float3 tonemappedRender, float3 post_processed) {
  float3 output = post_processed;
  if (injectedData.toneMapType > 1.f) {
    output = renodx::tonemap::UpgradeToneMap(tonemappedRender, saturate(tonemappedRender), saturate(post_processed), injectedData.radiationOverlayStrength);
    output = renodx::color::pq::Encode(output, injectedData.toneMapGameNits);
  } else if (injectedData.toneMapType == 1.f) {
    output = tonemappedRender;
  }

  return output;
}
