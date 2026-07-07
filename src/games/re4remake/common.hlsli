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

float3 ApplyResidentEvilToneMap(
    float3 color,
    float contrast,
    float linearBegin,
    float linearStart,
    float toe,
    float maxNit,
    float displayMaxNitSubContrastFactor,
    float contrastFactor,
    float mulLinearStartContrastFactor,
    float invLinearBegin,
    float madLinearStartContrastFactor) {
  if (!isfinite(renodx::math::Max(color))) {
    return 1.f;
  }

  // Normalize by linearBegin for toe math
  float3 t = color * invLinearBegin;

  // toe: below linearBegin
  float3 toe_weight = select(color >= linearBegin, 0.f, 1.f - (t * t) * (3.f - 2.f * t));
  float3 toe_value = pow(t, toe) * linearBegin;

  // shoulder: above linearStart
  float3 shoulder_weight = select(color < linearStart, 0.f, 1.f);
  float3 shoulder_value = maxNit - exp2(contrastFactor * color + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor;

  // linear: remainder
  float3 linear_weight = 1.f - shoulder_weight - toe_weight;
  float3 linear_value = contrast * color + madLinearStartContrastFactor;

  return linear_value * linear_weight
         + toe_value * toe_weight
         + shoulder_value * shoulder_weight;
}
