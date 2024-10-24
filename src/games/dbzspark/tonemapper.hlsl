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

// Here so we have a central function once we figure out a better way
float3 clampForSRGB(float3 color) {
  // clamp so colors don't go NaN, and didn't want to clamp to 1
  // value derived from testing main menu
  return min(float3(1.f, 1.f, 1.f) * 3.15f, color);
}

float3 pqTosRGB(float3 input_pq, bool clamp = false) {
  float3 output;
  renodx::tonemap::Config config = getCommonConfig();
  if (injectedData.toneMapType > 1.f) {
    output = renodx::color::pq::Decode(input_pq, 100.f);
    if (clamp) {
      output = clampForSRGB(output);
    }
    output = renodx::color::bt709::from::BT2020(output);
    output = renodx::color::srgb::EncodeSafe(output);
  } else {
    output = input_pq;
  }

  return output;
}

float3 upgradeSRGBtoPQ(float3 tonemappedPQ, float3 post_srgb) {
  float3 hdr, post, output;

  if (injectedData.toneMapType == 0.f) {
    // post_srgb is PQ here
    output = post_srgb;
  } else if (injectedData.toneMapType == 1.f) {
    output = tonemappedPQ;
  } else {
    hdr = renodx::color::pq::Decode(tonemappedPQ, 100.f);
    hdr = renodx::color::bt709::from::BT2020(hdr);

    post = renodx::color::srgb::DecodeSafe(post_srgb);
    post = clampForSRGB(post);

    output = renodx::tonemap::UpgradeToneMap(hdr, saturate(hdr), post, injectedData.colorGradeLUTStrength);
    output = renodx::color::bt2020::from::BT709(output);
    output = renodx::color::pq::Encode(output, 100.f);
  }

  return output;
}
