#include "./shared.h"

// Common functions

void tonemap(in float3 ap1_graded_color, in float3 ap1_aces_colored, out float3 hdr_color, out float3 sdr_color, inout float3 sdr_ap1_color) {
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  // config.peak_nits = 10000.f;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 1.f;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  if (injectedData.toneMapType == 3.f) {
    config.contrast = injectedData.colorGradeContrast;
  }
  config.saturation = injectedData.colorGradeSaturation;

  config.reno_drt_highlights = 1.0f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 1.1f;
  config.reno_drt_saturation = 1.1f;
  config.reno_drt_dechroma = 0;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.05f;
  config.reno_drt_working_color_space = 2u;

  if (injectedData.toneMapPerChannel) {
    config.reno_drt_per_channel = true;
  }

  config.reno_drt_hue_correction_method = (uint)injectedData.ToneMapHueProcessor;

  float3 bt709_graded_color = renodx::color::bt709::from::AP1(ap1_graded_color);
  float3 bt709_aces_color = renodx::color::bt709::from::AP1(ap1_aces_colored);

  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  // config.hue_correction_color = color;
  if (injectedData.toneMapHueCorrectionMethod == 1.f) {
    config.hue_correction_color = renodx::tonemap::ACESFittedAP1(bt709_graded_color);
  } else if (injectedData.toneMapHueCorrectionMethod == 2.f) {
    config.hue_correction_color = renodx::tonemap::uncharted2::BT709(bt709_graded_color * 2.f);
  } else if (injectedData.toneMapHueCorrectionMethod == 3.f) {
    config.hue_correction_color = bt709_aces_color;
  } else {
    config.hue_correction_type =
        renodx::tonemap::config::hue_correction_type::INPUT;
  }

  renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(bt709_graded_color, config);
  hdr_color = dual_tone_map.color_hdr;
  sdr_color = dual_tone_map.color_sdr;
  sdr_ap1_color = renodx::color::ap1::from::BT709(sdr_color);
}

float3 scalePaperWhite(float3 color) {
  color = renodx::color::srgb::EncodeSafe(color);
  color = renodx::math::PowSafe(color, 1.f / 2.2f);  //
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  color = renodx::math::PowSafe(color, 2.2f);  //

  return color.rgb;
}