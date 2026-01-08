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

// Applies the hue shifts from clamping input_color while minimizing broken gradients
float3 clampedHueOKLab(float3 input_color, float correct_amount = 1.f) {
  // If no correction is needed, return the original color
  if (correct_amount == 0) {
    return input_color;
  } else {
    // Calculate average channel values of the original (unclamped) input_color
    float avg_unclamped = renodx::math::Average(input_color);

    // calculate average channel values for the clamped input_color
    float3 clamped_color = saturate(input_color);
    float avg_clamped = renodx::math::Average(clamped_color);

    // Compute the hue clipping percentage based on the difference in averages
    float hue_clip_percentage = saturate((avg_unclamped - avg_clamped) / max(avg_unclamped, renodx::math::FLT_MIN));  // Prevent division by zero

    // Interpolate hue components (a, b in OkLab) based on correct_amount using clamped_color
    float3 correct_lab = renodx::color::oklab::from::BT709(clamped_color);
    float3 incorrect_lab = renodx::color::oklab::from::BT709(input_color);
    float3 new_lab = incorrect_lab;

    // Apply hue correction based on clipping percentage and interpolate based on correct_amount
    new_lab.yz = lerp(incorrect_lab.yz, correct_lab.yz, hue_clip_percentage);
    new_lab.yz = lerp(incorrect_lab.yz, new_lab.yz, abs(correct_amount));

    // Restore original chrominance from input_color in OkLCh space
    float3 incorrect_lch = renodx::color::oklch::from::OkLab(incorrect_lab);
    float3 new_lch = renodx::color::oklch::from::OkLab(new_lab);
    new_lch[1] = incorrect_lch[1];

    // Convert back to linear BT.709 space
    float3 color = renodx::color::bt709::from::OkLCh(new_lch);
    return color;
  }
}

// Emulates hue shifts caused by clamping to SDR while minimizing artifacts.
// This function dynamically adjusts the hue of the HDR input color to align
// with the hue shifts observed in clamped SDR colors, while preserving luminance
// and chrominance balance to avoid broken gradients or oversaturation.
float3 clampedHueICtCp(float3 input_color, float correct_amount = 1.f) {
  // Return the original color if no correction is needed.
  if (correct_amount == 0.f) return input_color;

  // Calculate the average luminance of the unclamped (HDR) input color.
  float avg_unclamped = renodx::color::y::from::BT709(input_color);

  // Clamp the input color to SDR range [0, 1] and calculate its average luminance.
  float3 clamped_color = saturate(input_color);
  float avg_clamped = renodx::color::y::from::BT709(clamped_color);

  // Compute the hue clipping percentage by comparing the luminance difference
  // between the unclamped and clamped colors. Use safe division to avoid divide-by-zero.
  float hue_clip_percentage = saturate(renodx::math::DivideSafe(avg_unclamped - avg_clamped, avg_unclamped, 0.f));

  // Convert the clamped and input colors to the ICTCP color space for hue manipulation.
  float3 correct_perceptual = renodx::color::ictcp::from::BT709(clamped_color);
  float3 incorrect_perceptual = renodx::color::ictcp::from::BT709(input_color);

  // Measure the initial chrominance magnitude of the input color (distance from neutral).
  float chrominance_pre_adjust = distance(incorrect_perceptual.yz, 0);

  // Interpolate the chroma components (CT, CP) of the input color towards the clamped color's chroma.
  // This creates a smooth hue transition proportional to the clipping percentage.
  incorrect_perceptual.yz = lerp(incorrect_perceptual.yz, correct_perceptual.yz, hue_clip_percentage);

  // Further interpolate based on the correction strength to control the intensity of the hue shift.
  incorrect_perceptual.yz = lerp(incorrect_perceptual.yz, correct_perceptual.yz, abs(correct_amount));

  // Recalculate the chrominance magnitude after adjustment to ensure it remains balanced.
  float chrominance_post_adjust = distance(incorrect_perceptual.yz, 0);

  // Scale the chroma components to preserve the original chrominance magnitude, preventing oversaturation.
  incorrect_perceptual.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);

  // Convert the adjusted ICTCP color back to the linear BT.709 color space.
  float3 color = renodx::color::bt709::from::ICtCp(incorrect_perceptual);

  // Clamp the final output to ensure it remains within the valid gamut of BT.709/AP1.
  color = renodx::color::bt709::clamp::AP1(color);

  return color;
}

