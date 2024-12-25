#include "./shared.h"

/// Inverse of the Reinhard tonemapping function used in RDR1.
///
/// Reconstructs the original linear HDR value from its Extended Reinhard
/// tone-mapped result.
/// Uses the positive root for a valid HDR value.
///
/// @param x - The tone-mapped value.
/// @param whitePoint - The white point scaling factor.
/// @return The original linear HDR value.
float RDR1ReinardInverse(float x, float whitePoint) {
  // Calculate the two roots of the inverse
  float term1 = 0.5 * (whitePoint * x - whitePoint);
  float term2 = 0.5 * sqrt(whitePoint) * sqrt((whitePoint * x * x) - (2.0 * whitePoint * x) + whitePoint + 4.0 * x);

  // Use the positive root, as it's the physically meaningful solution
  return term1 + term2;
}

/// Computes the mid-gray point for the Reinhard tonemapping function.
///
/// This function calculates the linear HDR input value that corresponds to the
/// standard scene referred mid-gray (18%) in the Reinhard tone-mapped space.
/// This value is crucial for aligning the mid-gray points of untonemapped and
/// Reinhard-tonemapped images during blending.
///
/// @param whitePoint - The white point scaling factor used in the tonemapping.
/// @return The linear HDR mid-gray value.
float RDR1ReinhardMidgray(float whitePoint) {
  return RDR1ReinardInverse(0.18, whitePoint);
}

/// Computes the scale factor for aligning mid-gray levels in RDR1.
///
/// This function returns a scaling factor to map the untonemapped image's scene referred
/// mid-gray to align with the Reinhard tone-mapped's scene referred mid-gray.
/// This ensures that the blended result retains the original game's visual art direction
/// while enabling HDR highlights.
///
/// @param whitePoint - The white point scaling factor used in the tonemapping.
/// @return The scale factor for aligning mid-gray levels.
float RDR1ReinhardMidgrayScale(float whitePoint) {
  return 0.18 / RDR1ReinhardMidgray(whitePoint);
}

/// Applies a customized version of RenoDRT tonemapper that tonemaps down to 1.0.
/// This function is used to compress HDR color to SDR range for use alongside `UpgradeToneMap`.
///
/// @param untonemapped The color input that needs to be tonemapped.
/// @return The tonemapped color compressed to the SDR range, ensuring that it can be applied to SDR color grading with `UpgradeToneMap`.
float3 renoDRTSmoothClamp(float3 untonemapped) {
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
  renodrt_config.blowout = -1.f;
  renodrt_config.hue_correction_strength = 0.f;
  renodrt_config.hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::ICTCP;
  renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
  renodrt_config.working_color_space = 0u;
  renodrt_config.per_channel = true;

  float3 renoDRTColor = renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
  renoDRTColor = lerp(untonemapped, renoDRTColor, saturate(renodx::color::y::from::BT709(untonemapped)));

  return saturate(renoDRTColor);
}
