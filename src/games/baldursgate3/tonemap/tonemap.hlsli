#include "../common.hlsli"
#include "./test20.hlsli"

namespace renodx_custom {
namespace tonemap {
namespace aces {

renodx::tonemap::aces::ODTConfig CreateODTConfig(
    float min_y,
    float max_y,
    float mid_y,
    bool stable_peak_exp_shift = false,
    float exp_shift_max_reference = 1000.f,
    float exp_shift_min_reference = 0.0001f) {
  renodx::tonemap::aces::ODTConfig config = renodx::tonemap::aces::CreateODTConfig(min_y, max_y);

  if (mid_y != 4.8f) {
    renodx::tonemap::aces::ODTConfig exp_shift_config;

    // derive exp-shift from a fixed reference curve so peak changes are stable
    const bool use_stable_reference =
        stable_peak_exp_shift && (exp_shift_max_reference != max_y || exp_shift_min_reference != min_y);
    if (use_stable_reference) {
      exp_shift_config = renodx::tonemap::aces::CreateODTConfig(exp_shift_min_reference, exp_shift_max_reference);
    } else {
      exp_shift_config = config;
    }
    float exp_shift = log2(renodx::tonemap::aces::InvSSTS(mid_y, exp_shift_config)) - log2(0.18f);
    float shift_log10 = exp_shift * log10(2.f);

    config.y_min.x -= shift_log10;
    config.y_mid.x -= shift_log10;
    config.y_max.x -= shift_log10;
  }

  return config;
}

}  // namespace aces
}  // namespace tonemap
}  // namespace renodx

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

float3 ApplyLuminanceGradingLMS(float3 color_lms, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float yf = max(0.f, renodx::color::yf::from::LMS(color_lms));
  float yf_adjusted = yf * exposure;
  yf_adjusted = Highlights(yf_adjusted, highlights, mid_gray_yf);
  yf_adjusted = Shadows(yf_adjusted, shadows, mid_gray_yf);
  yf_adjusted = ContrastAndFlare(yf_adjusted, contrast, flare, mid_gray_yf);
  return color_lms * renodx::math::DivideSafe(yf_adjusted, yf, 1.f);
}

float3 ApplyLuminanceGradingBT2020(float3 color_bt2020, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyLuminanceGradingLMS(color_lms, exposure, highlights, shadows, contrast, flare, mid_gray_yf);
  return renodx::color::bt2020::from::LMS(color_lms);
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
    color_lms = renodx::tonemap::psychovtest20::psycho20_ApplyAdaptiveMBPurity(color_lms, mid_gray_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyPurityGradingBT2020(float3 color_bt2020, float purity_scale, float purity_highlights, float dechroma) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyPurityGradingLMS(color_lms, purity_scale, purity_highlights, dechroma, renodx::color::lms::from::BT2020(0.18f.xxx));
  return renodx::color::bt2020::from::LMS(color_lms);
}

float3 ApplyAnchoredAdaptationContrast(float3 color, float contrast,
                                       float3 anchor_in = 0.18f, float3 anchor_out = 0.18f,
                                       float flare = 0.f) {
  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 flare_ratio = renodx::math::DivideSafe(normalized + flare, normalized, 1.f);
  float3 exponent = contrast * flare_ratio;

  float3 ax_n = pow(ax, exponent);
  float3 s_n = pow(anchor_in, exponent);
  float3 response_target = ax_n / (ax_n + s_n);
  float3 response_baseline = ax / (ax + anchor_in);
  float3 gain = renodx::math::DivideSafe(response_target, response_baseline, 0.f);

  float3 contrasted = renodx::math::CopySign(ax * gain, color);
  return contrasted * (anchor_out / anchor_in);
}

static const float3x3 DISPLAYP3_TO_LMS_WEIGHTED_MAT = mul(renodx::color::macleod_boynton::XYZ_TO_LMS_WEIGHTED_MAT, renodx::color::DISPLAYP3_TO_XYZ_MAT);

float4 GenerateLUTbuilderOutput(float3 untonemapped_ap1) {
#if 1  // ODT + desat LMS

  const float3 AP1_WHITE = renodx::color::lms::from::AP1(1.f);
  float3 untonemapped_lms_normalized = renodx::color::lms::from::AP1(untonemapped_ap1) / AP1_WHITE;

  // In order to change ACES_MID, we use The Academy's exp-shift system
  // The curve is built around 4.8 ACES_MID however, so changing it causes the curve to break
  // Values other than 4.8 make it so that increasing peak causes midtones to compress and vice-versa
  // We fix this by basing the exp-shifted curve on reference ACES_MAX and ACES_MIN values
  // We then scale brightness like SDR as a linear scalar
  // ACES_MAX and ACES_MIN are pre-adjusted in order to account for the post-tonemap diffuse white scalar which we define as `10.f * ACES_MID`
  float ACES_MID = 50.f;
  float EXP_SHIFT_REFERENCE_MAX = 500.f;
  float EXP_SHIFT_REFERENCE_MIN = 0.0001f;

  const float ACES_DIFFUSE = ACES_MID * 10.f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / 100.f;
  float aces_max = (10000.f / 100.f);

  if (true) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }

  renodx::tonemap::aces::ODTConfig ODT_config = renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);
  float3 tonemapped_lms_normalized = renodx::tonemap::aces::ODTToneMap(untonemapped_lms_normalized, ODT_config) / ACES_DIFFUSE;

  if (true) {
    tonemapped_lms_normalized = renodx::color::correct::GammaSafe(tonemapped_lms_normalized);
  }

  float3 tonemapped_lms = tonemapped_lms_normalized * AP1_WHITE;

  // lerp to yf to desat
  float tonemapped_yf = renodx::color::yf::from::LMS(tonemapped_lms);
  tonemapped_lms = lerp(tonemapped_yf, tonemapped_lms, 0.96f);

  const float MID_GRAY_IN = 0.18f;
  const float MID_GRAY_OUT = 0.10f;
  {  // gamut compression
    float3 current_adaptive_state_lms = AP1_WHITE * MID_GRAY_IN;
    float3 desired_background_state_lms = AP1_WHITE * MID_GRAY_OUT;

    // Convert source to adapted weighted LMS.
    float3 source_relative_weighted = renodx::tonemap::psychovtest20::psycho20_ToAdaptiveRelativeWeightedLMS(
        untonemapped_lms_normalized * AP1_WHITE,
        current_adaptive_state_lms);

    // Convert target to adapted weighted LMS.
    float3 display_scaled_relative_weighted = renodx::tonemap::psychovtest20::psycho20_ToAdaptiveRelativeWeightedLMS(
        tonemapped_lms,
        desired_background_state_lms);

    // psychotm_test20-style MB hue direction restore.
    {
      float3 mb_source = renodx::color::macleod_boynton::from::WeightedLMS(source_relative_weighted);
      float3 mb_display_target = renodx::color::macleod_boynton::from::WeightedLMS(display_scaled_relative_weighted);
      float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f);

      float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
      float2 display_target_offset = mb_display_target.xy - mb_adapted_bg.xy;

      float src2 = dot(source_offset, source_offset);
      float display_tgt2 = dot(display_target_offset, display_target_offset);

      if (src2 > 1e-7f && display_tgt2 > 1e-7f) {
        float target_radius = sqrt(display_tgt2);
        float2 source_dir = source_offset * rsqrt(src2);
        float2 display_target_dir = display_target_offset * rsqrt(display_tgt2);

        float restore_weight = 0.5f;

        float2 blended_dir = lerp(display_target_dir, source_dir, restore_weight);
        float blended_len2 = dot(blended_dir, blended_dir);
        blended_dir = (blended_len2 > 1e-7f) ? (blended_dir * rsqrt(blended_len2)) : display_target_dir;

        float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
        float3 mb_restored = float3(mb_restored_xy, mb_display_target.z);

        display_scaled_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);
      }
    }

    // psychotm_test20-style BT.2020-bound adaptive weighted LMS gamut compression.
    display_scaled_relative_weighted = renodx::tonemap::psychovtest20::psycho20_GamutCompressAdaptiveRelativeWeightedLMSBound(
        display_scaled_relative_weighted,
        desired_background_state_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);

    // Return compressed target to LMS.
    tonemapped_lms = renodx::color::macleod_boynton::UnweighLMS(
        renodx::tonemap::psychovtest20::psycho20_FromAdaptiveRelativeWeightedLMS(display_scaled_relative_weighted, desired_background_state_lms));
  }

  float3 tonemapped_bt2020 = renodx::color::bt2020::from::LMS(tonemapped_lms);

  return float4(renodx::color::pq::EncodeSafe(tonemapped_bt2020, 100.f), 1.f);

#elif 0  // RRT + ODT AP1

  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  // In order to change ACES_MID, we use The Academy's exp-shift system
  // The curve is built around 4.8 ACES_MID however, so changing it causes the curve to break
  // Values other than 4.8 make it so that increasing peak causes midtones to compress and vice-versa
  // We fix this by basing the exp-shifted curve on reference ACES_MAX and ACES_MIN values
  // We then scale brightness like SDR as a linear scalar
  // ACES_MAX and ACES_MIN are pre-adjusted in order to account for the post-tonemap diffuse white scalar which we define as `10.f * ACES_MID`
  float ACES_MID;
  float EXP_SHIFT_REFERENCE_MAX;
  float EXP_SHIFT_REFERENCE_MIN;
  if (false) {
    ACES_MID = 4.8f;
    EXP_SHIFT_REFERENCE_MAX = 48.f;
    EXP_SHIFT_REFERENCE_MIN = 0.02f;
  } else if (false) {
    ACES_MID = 10.f;
    EXP_SHIFT_REFERENCE_MAX = 100.f;
    EXP_SHIFT_REFERENCE_MIN = 0.02f;
  } else {
    ACES_MID = 45.f;
    EXP_SHIFT_REFERENCE_MAX = 450.f;
    EXP_SHIFT_REFERENCE_MIN = 0.0001f;
  }
  const float ACES_DIFFUSE = ACES_MID * 10.f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / 100.f;
  float aces_max = (10000.f / 100.f);

  if (true) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }

  renodx::tonemap::aces::ODTConfig ODT_config = renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);
  float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / ACES_DIFFUSE;
  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

  if (true) {
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
  }

  float3 tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);

  return float4(renodx::color::pq::EncodeSafe(tonemapped_bt2020, 100.f), 1.f);
#endif
}

float3 psycho_ComputeReinhardScale(float3 peak = 1.f, float minimum = 0.f, float3 gray_in = 0.18f, float3 gray_out = 0.18f) {
  //  s = (p * y - p * m) / (x * p - x * y)

  float3 num = peak * (gray_out - minimum);  // p * (y - m)
  float3 den = gray_in * (peak - gray_out);  // x * (p - y)

  return num / den;
}

float3 psycho_ReinhardPiecewise(float3 x, float3 x_max = 1.f, float3 shoulder = 0.18f) {
  const float x_min = 0.f;
  float3 exposure = psycho_ComputeReinhardScale(x_max, x_min, shoulder, shoulder);
  float3 tonemapped = mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);

  return lerp(x, tonemapped, step(shoulder, x));
}
