#include "./DICE.hlsl"
#include "./shared.h"

/// Applies DICE tonemapper to the untonemapped HDR color.
///
/// @param untonemapped - The untonemapped color.
/// @return The HDR color tonemapped with DICE.
float3 applyDICE(float3 untonemapped, float peakWhite, float paperWhite) {
  // Declare DICE parameters
  DICESettings config = DefaultDICESettings();
  config.Type = 3;
  config.ShoulderStart = 0.35f;
  const float dicePaperWhite = paperWhite / renodx::color::srgb::REFERENCE_WHITE;
  const float dicePeakWhite = peakWhite / renodx::color::srgb::REFERENCE_WHITE;

  // multiply paper white in for tonemapping and out for output
  return DICETonemap(untonemapped * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
}

float3 DisplayMapAndScale(float3 color) {
  color = max(0, color);
  if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::gamma::Decode(color, 2.2f);
    if (injectedData.toneMapType == 1) {
      color = applyDICE(color, injectedData.toneMapPeakNits, injectedData.toneMapGameNits);
    }
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::gamma::Encode(color, 2.2f);
  } else {
    color = renodx::color::srgb::Decode(color);
    if (injectedData.toneMapType == 1) {
      color = applyDICE(color, injectedData.toneMapPeakNits, injectedData.toneMapGameNits);
    }
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::srgb::Encode(color);
  }
  return color;
}

float3 FinalizeOutput(float3 color) {
  if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  color *= injectedData.toneMapUINits;

  color /= 80.f;  // or PQ
  return color;
}

/// Applies a customized version of RenoDRT tonemapper that tonemaps down to 1.0.
/// This function is used to compress HDR color to SDR range for use alongside `UpgradeToneMap`.
///
/// @param lutInputColor The color input that needs to be tonemapped.
/// @return The tonemapped color compressed to the SDR range, ensuring that it can be applied to SDR color grading with `UpgradeToneMap`.
float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.05f;
  renodrt_config.saturation = 1.03f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.hue_correction_strength = 0.f;
  // renodrt_config.hue_correction_source = renodx::tonemap::uncharted2::BT709(untonemapped);
  renodrt_config.hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
  renodrt_config.working_color_space = 2u;
  renodrt_config.per_channel = false;

  float3 renoDRTColor = renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
  renoDRTColor = lerp(untonemapped, renoDRTColor, saturate(renodx::color::y::from::BT709(untonemapped) / renodrt_config.mid_gray_value));

  return saturate(renoDRTColor);
}
