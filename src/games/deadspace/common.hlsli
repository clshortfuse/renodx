#ifndef DEADSPACE_COMMON_HLSLI
#define DEADSPACE_COMMON_HLSLI
#include "./shared.h"

float3 psycho20_ApplyAdaptiveMBPurity(
    float3 lms_input,
    float3 adaptive_neutral_lms,
    float purity_scale) {
  if (abs(purity_scale - 1.f) <= 1e-5f) {
    return lms_input;
  }

  float3 relative_weighted =
      renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(
          lms_input,
          adaptive_neutral_lms);

  float3 mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          relative_weighted);

  float3 mb_neutral =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx);

  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_scale);

  float3 relative_weighted_out =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(
          relative_weighted_out,
          adaptive_neutral_lms));
}

float Highlights(float x, float highlights, float mid_gray = 0.18f) {
  if (highlights == 1.f) return x;
  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {
    float b = mid_gray * pow(x / mid_gray, 2.f - highlights);
    float t = min(x, 1.f);
    return min(x, renodx::math::DivideSafe(x * x, lerp(x, b, t), x));
  }
}

float Shadows(float x, float shadows, float mid_gray = 0.18f) {
  if (shadows == 1.f) return x;
  float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  float base_term = x * mid_gray;
  float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float ContrastAndFlare(float x, float contrast, float flare, float mid_gray = 0.18f) {
  if (contrast == 1.f && flare == 0.f) return x;
  float x_normalized = x / mid_gray;
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  return pow(x_normalized, contrast * flare_ratio) * mid_gray;
}

float3 ApplyLuminanceAndPurityGradingLMS(
    float3 color_lms,
    float exposure,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float purity_scale,
    float purity_highlights,
    float dechroma,
    float mid_gray = 0.18f) {
  float mid_gray_yf = mid_gray;
  float3 mid_gray_lms = renodx::color::lms::from::BT709(mid_gray.xxx);
  float yf = max(0.f, renodx::color::yf::from::LMS(color_lms));
  float lum_target = yf;

  float yf_adjusted = yf * exposure;
  yf_adjusted = Highlights(yf_adjusted, highlights, mid_gray_yf);
  yf_adjusted = Shadows(yf_adjusted, shadows, mid_gray_yf);
  yf_adjusted = ContrastAndFlare(yf_adjusted, contrast, flare, mid_gray_yf);
  color_lms *= renodx::math::DivideSafe(yf_adjusted, yf, 1.f);

  if (purity_scale == 1.f && purity_highlights == 0.f && dechroma == 0.f) return color_lms;

  if (dechroma != 0.f) {
    purity_scale *= lerp(1.f, 0.f, saturate(pow(lum_target / (10000.f / 100.f), 1.f - dechroma)));
  }

  if (purity_highlights != 0.f) {
    float percent_max = saturate(lum_target * 100.f / 10000.f);
    float blowout_change = pow(1.f - percent_max, 100.f * abs(purity_highlights));
    if (purity_highlights < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    purity_scale *= blowout_change;
  }

  if (purity_scale != 1.f) {
    color_lms = psycho20_ApplyAdaptiveMBPurity(color_lms, mid_gray_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyLuminanceAndPurityGradingBT709(
    float3 color_bt709,
    float exposure,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float purity_scale,
    float purity_highlights,
    float dechroma,
    float mid_gray = 0.18f) {
  float3 color_lms = renodx::color::lms::from::BT709(color_bt709);
  color_lms = ApplyLuminanceAndPurityGradingLMS(
      color_lms,
      exposure,
      highlights,
      shadows,
      contrast,
      flare,
      purity_scale,
      purity_highlights,
      dechroma,
      mid_gray);
  return renodx::color::bt709::from::LMS(color_lms);
}

#endif  // DEADSPACE_COMMON_HLSLI