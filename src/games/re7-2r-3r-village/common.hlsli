#ifndef COMMON_HLSLI
#define COMMON_HLSLI

#include "./macleod_boynton.hlsli"
#include "./shared.h"

float ContrastAndFlare(float x, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray = 0.18f) {
  if (contrast == 1.f && flare == 0.f && contrast_highlights == 1.f && contrast_shadows == 1.f) return x;

  const float x_normalized = x / mid_gray;
  const float split_contrast = renodx::math::Select(x < mid_gray, contrast_shadows, contrast_highlights);
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  float exponent = contrast * split_contrast * flare_ratio;
  return pow(x_normalized, exponent) * mid_gray;
}

float3 ApplyGammaCorrection(float3 color_input) {
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    return renodx::color::correct::GammaSafe(color_input);
  } else {
    return color_input;
  }
}

float4 GenerateOutput(float3 color_bt709, float diffuse_nits, float peak_nits) {
  color_bt709 = renodx::color::bt709::clamp::AP1(color_bt709);

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
  }

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);

  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_GRAPHICS_WHITE_NITS);

  return float4(color_pq, 1.f);
}

#endif  // COMMON_HLSLI
