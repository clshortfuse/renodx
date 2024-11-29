#include "./DICE.hlsl"
#include "./shared.h"

static const float DEFAULT_PQ_DECODE = 100.f;  // 50%
static const float DEFAULT_BRIGHTNESS = 0.f;   // 50%
static const float DEFAULT_CONTRAST = 1.f;     // 50%
static const float DEFAULT_GAMMA = 1.f;        // 50%
static const uint OUTPUT_OVERRIDE = 4u;        // TONEMAPPER_OUTPUT_ACES2000nitST2084

renodx::tonemap::Config getCommonConfig() {
  // Too contrasty at 0.18
  float vanillaMidGray = injectedData.toneMapGameNits / 1000.f;
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
  return min(float3(1.f, 1.f, 1.f) * 10.f, color);
}

// input is always PQ, even for vanilla+
float3 pqTosRGB(float3 input, float customDecode = 0.f, bool clamp = false) {
  float3 output;
  renodx::tonemap::Config config = getCommonConfig();
  if (injectedData.toneMapType == 1.f) {
    output = input;
  } else {
    output = renodx::color::pq::Decode(input, customDecode != 0.f ? customDecode : injectedData.toneMapGameNits);
    if (clamp) {
      output = clampForSRGB(output);
    }
    output = renodx::color::bt709::from::BT2020(output);
    output = renodx::color::srgb::Encode(output);
  }

  return output;
}

float3 upgradeSRGBtoPQ(float3 tonemapped, float3 post_srgb, float customDecode = 0.f, float strength = 1.f) {
  float3 hdr, post, output;

  if (injectedData.toneMapType == 1.f) {
    output = tonemapped;
  } else {
    hdr = renodx::color::pq::Decode(tonemapped, customDecode != 0.f ? customDecode : injectedData.toneMapGameNits);
    hdr = renodx::color::bt709::from::BT2020(hdr);

    post = post_srgb;
    post = renodx::color::srgb::Decode(post);

    output = renodx::tonemap::UpgradeToneMap(hdr, saturate(hdr), post, strength);
    output = renodx::color::bt2020::from::BT709(output);  // Maybe change this to post
    output = renodx::color::pq::Encode(output, customDecode != 0.f ? customDecode : injectedData.toneMapGameNits);
  }

  return output;
}

float3 displayTonemap(float3 color) {
  float peak = injectedData.toneMapPeakNits;
  float tonemapper = injectedData.toneMapDisplay;
  /* I'm not dividing by 80.f because I'm using tonemapGameNits for encoding/decoding PQ
  Not sure if that's correct though */
  const float dicePaperWhite = injectedData.toneMapGameNits;
  const float dicePeakWhite = peak;
  const float highlightsShoulderStart = 0.25;  // Low shoulders cuz game is too bright overall, with sharp highlights
  const float frostReinPeak = peak / injectedData.toneMapGameNits;

  // Tonemap adjustments from color correctors
  if (tonemapper == 1.f) {
    DICESettings config = DefaultDICESettings();
    config.Type = 1;
    config.ShoulderStart = highlightsShoulderStart;

    color.rgb = DICETonemap(color.rgb * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
  } else if (tonemapper == 2.f) {
    color.rgb = renodx::tonemap::ReinhardScalable(color.rgb, frostReinPeak);
  } else if (tonemapper == 3.f) {
    color.rgb = renodx::tonemap::frostbite::BT709(color.rgb, frostReinPeak);
  }

  return color;
}
