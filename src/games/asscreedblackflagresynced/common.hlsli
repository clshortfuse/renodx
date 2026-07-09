#include "./shared.h"

float ContrastAndFlare(float x, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray = 0.18f) {
  if (contrast == 1.f && flare == 0.f && contrast_highlights == 1.f && contrast_shadows == 1.f) return x;

  const float x_normalized = x / mid_gray;
  const float split_contrast = renodx::math::Select(x < mid_gray, contrast_shadows, contrast_highlights);
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  float exponent = contrast * split_contrast * flare_ratio;
  return pow(x_normalized, exponent) * mid_gray;
}

float3 ApplyAdaptiveMBPurity(float3 lms_input, float3 adaptive_neutral_lms, float purity_scale) {
  if (abs(purity_scale - 1.f) <= 1e-5f) return lms_input;

  float3 relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, adaptive_neutral_lms);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(relative_weighted);
  float3 mb_neutral = renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_scale);
  float3 relative_weighted_out = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(relative_weighted_out, adaptive_neutral_lms));
}

float ApplyLuminanceGradingChannel(float channel, float gamma, float exposure, float highlights, float shadows, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray = 0.18f) {
  float channel_adjusted = channel * exposure;
  if (gamma != 1.f) {
    channel_adjusted = renodx::math::Select(channel_adjusted < 1.f, pow(channel_adjusted, gamma), channel_adjusted);
  }
  channel_adjusted = renodx::color::grade::Highlights(channel_adjusted, highlights, mid_gray);
  channel_adjusted = renodx::color::grade::Shadows(channel_adjusted, shadows, mid_gray);
  channel_adjusted = ContrastAndFlare(channel_adjusted, contrast, contrast_highlights, contrast_shadows, flare, mid_gray);
  return channel_adjusted;
}

float3 ApplyLuminanceGradingAP1(float3 color, float gamma, float exposure, float highlights, float shadows, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray = 0.18f) {
  float y = max(0.f, renodx::color::yf::from::AP1(color));
  float y_adjusted = ApplyLuminanceGradingChannel(y, gamma, exposure, highlights, shadows, contrast, contrast_highlights, contrast_shadows, flare, mid_gray);
  float3 color_adjusted = color * renodx::math::DivideSafe(y_adjusted, y, 1.f);

  color_adjusted = renodx::lut::RecolorUnclamped(color, color_adjusted);

  return color_adjusted;
}

float3 ApplyPurityGradingLMS(float3 color_lms, float purity_scale, float purity_highlights, float dechroma, float3 mid_gray_lms = 0.18f) {
  if (purity_scale == 1.f && purity_highlights == 0.f && dechroma == 0.f) return color_lms;

  float lum_target = max(0.f, renodx::color::yf::from::LMS(color_lms));

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
    color_lms = ApplyAdaptiveMBPurity(color_lms, mid_gray_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyUserGradingAP1(float3 color_ap1, float mid_gray = 0.18f) {
  color_ap1 = ApplyLuminanceGradingAP1(color_ap1,
                                       1.f,
                                       RENODX_TONE_MAP_EXPOSURE,
                                       RENODX_TONE_MAP_HIGHLIGHTS,
                                       RENODX_TONE_MAP_SHADOWS,
                                       RENODX_TONE_MAP_CONTRAST,
                                       1.f,
                                       1.f,
                                       0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                       mid_gray);

  float3 color_lms = renodx::color::lms::from::AP1(color_ap1);
  color_lms = ApplyPurityGradingLMS(
      color_lms,
      RENODX_TONE_MAP_SATURATION,
      -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
      RENODX_TONE_MAP_DECHROMA,
      renodx::color::lms::from::AP1(mid_gray.xxx));

  return renodx::color::ap1::from::LMS(color_lms);
}
