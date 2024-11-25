#include "./shared.h"

renodx::tonemap::Config getCommonConfig() {
  float vanillaMidGray = 0.30f;  // UUU shows game is using 30.f for mid gray
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

float3 pqTosRGB(float3 input_pq) {
  float3 output;
  if (injectedData.toneMapType > 1.f) {
    output = renodx::color::pq::Decode(input_pq, injectedData.toneMapGameNits);
    output = renodx::color::bt709::from::BT2020(output);
    output = renodx::color::srgb::EncodeSafe(output);
  } else {
    output = input_pq;
  }

  return output;
}

float3 upgradeSRGBtoPQ(float3 tonemappedPQ, float3 post_srgb) {
  float3 hdr, post, output;
  output = post_srgb;

  if (injectedData.toneMapType > 1.f) {
    hdr = renodx::color::pq::Decode(tonemappedPQ, injectedData.toneMapGameNits);
    hdr = renodx::color::bt709::from::BT2020(hdr);

    post = renodx::color::srgb::DecodeSafe(post_srgb);
    
    output = renodx::tonemap::UpgradeToneMap(hdr, saturate(hdr), saturate(post), injectedData.colorGradeLUTStrength);
    output = renodx::color::bt2020::from::BT709(output);
    output = renodx::color::pq::Encode(output, injectedData.toneMapGameNits);
  }

  return output;
}
