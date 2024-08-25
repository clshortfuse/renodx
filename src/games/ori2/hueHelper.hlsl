#include "./shared.h"

// Applies the hue shifts from clamping input_color while minimizing broken gradients
float3 Hue(float3 input_color, float correct_amount = 1.f) {
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
