#include "./shared.h"

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

