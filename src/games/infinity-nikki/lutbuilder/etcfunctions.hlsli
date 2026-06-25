#ifndef INCLUDE_ETCFUNCTIONS
#define INCLUDE_ETCFUNCTIONS

#include "../shared.h"

// Lerp in LMS
// BT709 linear In -- BT709 Linear Out
float3 LerpInLMS(float3 bt709_a, float3 bt709_b, float t) {
  float3 lms_a = renodx::color::lms::from::BT709(bt709_a);
  float3 lms_b = renodx::color::lms::from::BT709(bt709_b);

  float3 blended = lerp(lms_a, lms_b, saturate(t));

  return renodx::color::bt709::from::LMS(blended);
}

// NRG
float3 NeutwoBT709WhiteForEnergy(float3 bt709_linear, float peak = 1.f) {
  float peak_ref = max(peak, 1e-6f);

  float3x3 xyz_to_lms = renodx::color::XYZ_TO_STOCKMAN_SHARP_LMS_MAT;
  float3x3 lms_to_xyz = renodx::math::Invert3x3(xyz_to_lms);
  float3 xyz = renodx::color::xyz::from::BT709(bt709_linear);
  float3 lms = mul(xyz_to_lms, xyz);

  float3 d65_xyz = renodx::color::xyz::from::xyY(float3(renodx::color::WHITE_POINT_D65, 1.f));
  float3 lms_white = mul(xyz_to_lms, d65_xyz);

  float3 lms_norm_input = lms / lms_white;
  float scalar_raw_input = lms_norm_input.x + lms_norm_input.y + lms_norm_input.z;

  const float units = 1.f;  // Use 3.f for broken values
  float scalar_input = scalar_raw_input / units;

  float3 lms_peak = lms_white * peak_ref;
  float3 lms_norm_peak = lms_peak / lms_white;
  float scalar_raw_peak = lms_norm_peak.x + lms_norm_peak.y + lms_norm_peak.z;
  float scalar_peak = scalar_raw_peak / units;

  float scalar_output = renodx::tonemap::Neutwo(scalar_input, scalar_peak);

  float scalar_input_raw = scalar_input * units;
  float scalar_output_raw = scalar_output * units;

  float d65_gray = 0.18f;
  float3 gray_xyz = renodx::color::xyz::from::xyY(float3(renodx::color::WHITE_POINT_D65, d65_gray));
  float3 lms_gray = mul(xyz_to_lms, gray_xyz);
  float3 lms_gray_in = lms_gray * (scalar_input_raw / units);
  float3 lms_gray_out = lms_gray * (scalar_output_raw / units);
  float3 lms_chroma = lms - lms_gray_in;
  float available_white = saturate(renodx::math::DivideSafe(
      scalar_peak - scalar_output,
      scalar_peak,
      0.f));
  float3 lms_out = lms_gray_out + lms_chroma * available_white;

  float3 lms_norm_out = lms_out / lms_white;
  float scalar_out_raw = lms_norm_out.x + lms_norm_out.y + lms_norm_out.z;
  lms_out *= renodx::math::DivideSafe(scalar_output_raw, scalar_out_raw, 0.f);

  float3 xyz_out = mul(lms_to_xyz, lms_out);
  return renodx::color::bt709::from::XYZ(xyz_out);
}

// Reconstruct target LMS with source hue direction at matched V* anchors.
// This preserves hue angle while retaining target achromatic level + chroma strength.
float3 PreserveLMSHueAtMatchedVStar(
    float3 lms_source,
    float3 lms_target,
    float3 lms_white_unit,
    float vstar_white_unit,
    float amount) {
  if (amount <= 0.f) {
    return lms_target;
  }

  float vstar_source = 1.55f * lms_source.x + lms_source.y;
  float vstar_target = 1.55f * lms_target.x + lms_target.y;

  float3 lms_white_source = lms_white_unit * renodx::math::DivideSafe(vstar_source, vstar_white_unit, 0.f);
  float3 lms_white_target = lms_white_unit * renodx::math::DivideSafe(vstar_target, vstar_white_unit, 0.f);

  float3 dir_source = lms_source - lms_white_source;
  float3 dir_target = lms_target - lms_white_target;

  float len_source = length(dir_source);
  float len_target = length(dir_target);

  if (len_source <= 0.f || len_target <= 0.f) {
    return lms_target;
  }

  float chroma_scale = renodx::math::DivideSafe(len_target, len_source, 0.f);
  float3 lms_hue_preserved = lms_white_target + dir_source * chroma_scale;

  return lerp(lms_target, lms_hue_preserved, amount);
}

// PsychoTM Beta4 (With N2 Per-Channel -- Neutral)
float3 psychotm_test4(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float purity_scale = 1.f,
    float bleaching_intensity = 0.f,
    float hue_restore = 1.f,
    float adaptation_contrast = 1.f,
    float cone_response_exponent = 1.f) {
  const float kEps = 1e-6f;
  float3 bt2020 = renodx::color::bt2020::from::BT709(bt709_linear_input * exposure);
  static const float3x3 XYZ_TO_LMS_2006 = renodx::color::XYZ_TO_STOCKMAN_SHARP_LMS_MAT;
  static const float3x3 XYZ_FROM_LMS_2006 = renodx::math::Invert3x3(XYZ_TO_LMS_2006);

  // Match BT709WithBT2020 slider behavior for brightness-domain controls.
  float3 midgray_xyz = renodx::color::xyz::from::BT2020(0.18f);
  float3 midgray_lms = mul(XYZ_TO_LMS_2006, midgray_xyz);
  float mid_gray_luminosity = 1.55f * midgray_lms.x + midgray_lms.y;

  float3 color_xyz = renodx::color::xyz::from::BT2020(bt2020);
  float3 color_lms = mul(XYZ_TO_LMS_2006, color_xyz);
  float current_luminosity = 1.55f * color_lms.x + color_lms.y;
  float luminosity = current_luminosity;

  if (highlights != 1.f) {
    luminosity = renodx::color::grade::Highlights(luminosity, highlights, mid_gray_luminosity);
  }
  if (shadows != 1.f) {
    luminosity = renodx::color::grade::Shadows(luminosity, shadows, mid_gray_luminosity);
  }
  if (contrast != 1.f) {
    luminosity = renodx::color::grade::ContrastSafe(luminosity, contrast, mid_gray_luminosity);
  }

  float luminosity_scale = renodx::math::DivideSafe(luminosity, current_luminosity, 1.f);
  bt2020 *= luminosity_scale;

  // Fixed white basis: D65.
  float3 lms_raw = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(bt2020));
  float3 lms_white = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(1.f));
  float vstar_white = 1.55f * lms_white.x + lms_white.y;
  float3 midgray_lms_anchor = lms_white * 0.18f;

  // Saturation in ACC chroma plane (.yz) around same-V* white anchor.
  if (purity_scale != 1.f) {
    float vstar_input_sat = 1.55f * lms_raw.x + lms_raw.y;
    float3 lms_white_sat = lms_white * renodx::math::DivideSafe(vstar_input_sat, vstar_white, 0.f);

    float3 base_sat = max(lms_white_sat, kEps.xxx);
    float3 cone_contrast = (lms_raw - base_sat) / base_sat;

    float3 white_safe = max(lms_white, kEps.xxx);
    float mc1 = white_safe.x / white_safe.y;
    float mc2 = (white_safe.x + white_safe.y) / white_safe.z;
    float3x3 lms_to_acc = float3x3(
        1.f, 1.f, 0.f,
        1.f, -mc1, 0.f,
        -1.f, -1.f, mc2);
    float3x3 acc_to_lms = renodx::math::Invert3x3(lms_to_acc);

    float3 acc = mul(lms_to_acc, cone_contrast);
    acc.yz *= purity_scale;
    float3 cone_contrast_scaled = mul(acc_to_lms, acc);
    lms_raw = lms_white_sat * (1.f + cone_contrast_scaled);
  }

  float3 lms_raw_source = lms_raw;

  // Adaptation-level contrast in LMS (inline Naka-Rushton around sigma).
  if (adaptation_contrast != 1.f) {
    float3 lms_sigma = max(midgray_lms_anchor, kEps.xxx);
    float exponent = max(adaptation_contrast, kEps);
    float3 ax = abs(lms_raw);
    float3 ax_n = pow(ax, exponent);
    float3 s_n = pow(lms_sigma, exponent);
    float3 response_target = ax_n / max(ax_n + s_n, kEps.xxx);
    float3 response_baseline = ax / max(ax + lms_sigma, kEps.xxx);
    float3 gain = response_target / max(response_baseline, kEps.xxx);
    float3 sign_raw = float3(
        lms_raw.x < 0.f ? -1.f : 1.f,
        lms_raw.y < 0.f ? -1.f : 1.f,
        lms_raw.z < 0.f ? -1.f : 1.f);
    lms_raw = sign_raw * (ax * gain);

    // Inline hue-preserve at matched V* anchors.
    if (hue_restore > 0.f) {
      float vstar_source = 1.55f * lms_raw_source.x + lms_raw_source.y;
      float vstar_target = 1.55f * lms_raw.x + lms_raw.y;
      float3 lms_white_source = lms_white * renodx::math::DivideSafe(vstar_source, vstar_white, 0.f);
      float3 lms_white_target = lms_white * renodx::math::DivideSafe(vstar_target, vstar_white, 0.f);
      float3 dir_source = lms_raw_source - lms_white_source;
      float3 dir_target = lms_raw - lms_white_target;
      float len_source = length(dir_source);
      float len_target = length(dir_target);
      if (len_source > 0.f && len_target > 0.f) {
        float chroma_scale = renodx::math::DivideSafe(len_target, len_source, 0.f);
        float3 lms_hue_preserved = lms_white_target + dir_source * chroma_scale;
        lms_raw = lerp(lms_raw, lms_hue_preserved, hue_restore);
      }
    }
  }

  float3 lms = lms_raw;

  // D65 bleaching path inline (no white-basis branching).
  if (bleaching_intensity != 0.f) {
    float blend = bleaching_intensity;
    float diffuse_white_nits = 100.f;
    float pupil_area_mm2 = 4.f;
    float half_bleach_trolands = 20000.f;

    // Adapted white proxy (same as previous path): neutral at adapted V*.
    float adapted_vstar = max(1.55f * max(lms.x, 0.f) + max(lms.y, 0.f), 0.18f);
    float3 adapted_lms = lms_white * adapted_vstar;

    // Compute per-cone availability from adapted LMS:
    // p(I) = 1 / (1 + I / I0)
    float3 stimulus_nits = max(adapted_lms, 0.f) * max(diffuse_white_nits, 0.f);
    float3 stimulus_trolands = stimulus_nits * max(pupil_area_mm2, 0.f);
    float half_bleach_safe = max(half_bleach_trolands, kEps);
    float3 availability_raw = 1.f / (1.f + stimulus_trolands / half_bleach_safe);
    float3 availability = lerp(1.f, availability_raw, blend);

    // White-relative per-cone attenuation in LMS.
    float y_lm = lms.x + lms.y;
    float white_y_lm = lms_white.x + lms_white.y;
    if (y_lm > kEps && white_y_lm > kEps) {
      float3 white_at_y = lms_white * (y_lm / white_y_lm);
      float3 delta = lms - white_at_y;
      delta *= max(availability, 0.f);
      lms = white_at_y + delta;
    }
  }

  // // Fixed white curve: Naka-Rushton to peak, per LMS channel (inline equation).
  // float3 lms_peak = lms_white * peak_value;
  // float exponent_tone = max(cone_response_exponent, kEps);
  // float3 p = max(lms_peak, kEps.xxx);
  // float3 g = clamp(midgray_lms_anchor, kEps.xxx, p - kEps.xxx);
  // float3 n = exponent_tone * p / max(p - g, kEps.xxx);
  // float3 sign_lms = float3(
  //     lms.x < 0.f ? -1.f : 1.f,
  //     lms.y < 0.f ? -1.f : 1.f,
  //     lms.z < 0.f ? -1.f : 1.f);
  // float3 ax_lms = abs(lms);
  // float3 sigma_n = pow(g, n - 1.f) * (p - g);
  // float3 x_n = pow(ax_lms, n);
  // float3 y = p * (x_n / max(x_n + sigma_n, kEps.xxx));
  // float3 lms_toned = sign_lms * y;

  // Trying out Per-Channel N2 in LMS
  float3 lms_peak = lms_white * peak_value;
  float exponent_tone = max(cone_response_exponent, kEps);
  float3 peak = max(lms_peak, kEps.xxx);
  float3 sign_lms = float3(
      lms.x < 0.f ? -1.f : 1.f,
      lms.y < 0.f ? -1.f : 1.f,
      lms.z < 0.f ? -1.f : 1.f);
  float3 abs_lms = abs(lms);
  float3 n2_lms = renodx::tonemap::neutwo::PerChannel(abs_lms, peak);
  float3 lms_toned = sign_lms * n2_lms;

  // Inline hue-preserve after tonemap.
  if (hue_restore > 0.f) {
    float vstar_source = 1.55f * lms.x + lms.y;
    float vstar_target = 1.55f * lms_toned.x + lms_toned.y;
    float3 lms_white_source = lms_white * renodx::math::DivideSafe(vstar_source, vstar_white, 0.f);
    float3 lms_white_target = lms_white * renodx::math::DivideSafe(vstar_target, vstar_white, 0.f);
    float3 dir_source = lms - lms_white_source;
    float3 dir_target = lms_toned - lms_white_target;
    float len_source = length(dir_source);
    float len_target = length(dir_target);
    if (len_source > 0.f && len_target > 0.f) {
      float chroma_scale = renodx::math::DivideSafe(len_target, len_source, 0.f);
      float3 lms_hue_preserved = lms_white_target + dir_source * chroma_scale;
      lms_toned = lerp(lms_toned, lms_hue_preserved, hue_restore);
    }
  }

  float3 bt2020_toned = renodx::color::bt2020::from::XYZ(mul(XYZ_FROM_LMS_2006, lms_toned));
  // bt2020_toned = BT2020MapAnyToBoundsLMS(bt2020_toned, 0.f);
  return renodx::color::bt709::from::BT2020(bt2020_toned);
}

// PsychoTM Beta4 (With N2 Per-Channel -- Neutral) [displaymap only]
// Basically N2 "By Luminosity"
float3 psychotm_test4_onlymap(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float hue_restore = 0.f) {
  const float kEps = 1e-6f;
  float3 bt2020 = renodx::color::bt2020::from::BT709(bt709_linear_input * 1.f);  // Used to be exposure, hardcoded to 1.f
  static const float3x3 XYZ_TO_LMS_2006 = renodx::color::XYZ_TO_STOCKMAN_SHARP_LMS_MAT;
  static const float3x3 XYZ_FROM_LMS_2006 = renodx::math::Invert3x3(XYZ_TO_LMS_2006);

  // Match BT709WithBT2020 slider behavior for brightness-domain controls.
  float3 midgray_xyz = renodx::color::xyz::from::BT2020(0.18f);
  float3 midgray_lms = mul(XYZ_TO_LMS_2006, midgray_xyz);
  float mid_gray_luminosity = 1.55f * midgray_lms.x + midgray_lms.y;

  float3 color_xyz = renodx::color::xyz::from::BT2020(bt2020);
  float3 color_lms = mul(XYZ_TO_LMS_2006, color_xyz);
  float current_luminosity = 1.55f * color_lms.x + color_lms.y;
  float luminosity = current_luminosity;

  float luminosity_scale = renodx::math::DivideSafe(luminosity, current_luminosity, 1.f);
  bt2020 *= luminosity_scale;

  // Fixed white basis: D65.
  float3 lms_raw = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(bt2020));
  float3 lms_white = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(1.f));
  float vstar_white = 1.55f * lms_white.x + lms_white.y;
  float3 midgray_lms_anchor = lms_white * 0.18f;

  float3 lms_raw_source = lms_raw;

  float3 lms = lms_raw;

  // // Fixed white curve: Naka-Rushton to peak, per LMS channel (inline equation).
  // float3 lms_peak = lms_white * peak_value;
  // float exponent_tone = max(cone_response_exponent, kEps);
  // float3 p = max(lms_peak, kEps.xxx);
  // float3 g = clamp(midgray_lms_anchor, kEps.xxx, p - kEps.xxx);
  // float3 n = exponent_tone * p / max(p - g, kEps.xxx);
  // float3 sign_lms = float3(
  //     lms.x < 0.f ? -1.f : 1.f,
  //     lms.y < 0.f ? -1.f : 1.f,
  //     lms.z < 0.f ? -1.f : 1.f);
  // float3 ax_lms = abs(lms);
  // float3 sigma_n = pow(g, n - 1.f) * (p - g);
  // float3 x_n = pow(ax_lms, n);
  // float3 y = p * (x_n / max(x_n + sigma_n, kEps.xxx));
  // float3 lms_toned = sign_lms * y;

  // Trying out Per-Channel N2 in LMS
  float3 lms_peak = lms_white * peak_value;
  float3 peak = max(lms_peak, kEps.xxx);
  float3 sign_lms = float3(
      lms.x < 0.f ? -1.f : 1.f,
      lms.y < 0.f ? -1.f : 1.f,
      lms.z < 0.f ? -1.f : 1.f);
  float3 abs_lms = abs(lms);
  float3 n2_lms = renodx::tonemap::neutwo::PerChannel(abs_lms, peak);
  float3 lms_toned = sign_lms * n2_lms;

  // Inline hue-preserve after tonemap.
  if (hue_restore > 0.f) {
    float vstar_source = 1.55f * lms.x + lms.y;
    float vstar_target = 1.55f * lms_toned.x + lms_toned.y;
    float3 lms_white_source = lms_white * renodx::math::DivideSafe(vstar_source, vstar_white, 0.f);
    float3 lms_white_target = lms_white * renodx::math::DivideSafe(vstar_target, vstar_white, 0.f);
    float3 dir_source = lms - lms_white_source;
    float3 dir_target = lms_toned - lms_white_target;
    float len_source = length(dir_source);
    float len_target = length(dir_target);
    if (len_source > 0.f && len_target > 0.f) {
      float chroma_scale = renodx::math::DivideSafe(len_target, len_source, 0.f);
      float3 lms_hue_preserved = lms_white_target + dir_source * chroma_scale;
      lms_toned = lerp(lms_toned, lms_hue_preserved, hue_restore);
    }
  }

  float3 bt2020_toned = renodx::color::bt2020::from::XYZ(mul(XYZ_FROM_LMS_2006, lms_toned));
  // bt2020_toned = BT2020MapAnyToBoundsLMS(bt2020_toned, 0.f);
  return renodx::color::bt709::from::BT2020(bt2020_toned);
}

// Minimal LMS per ch (N2)
// bt709 linear in -> bt709 linear out
float3 N2LMSPerCH(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f) {
  // smol episolon
  const float kEps = 1e-6f;

  float3 bt2020 = renodx::color::bt2020::from::BT709(bt709_linear_input);

  // Conversion Matrixes
  static const float3x3 XYZ_TO_LMS_2006 = renodx::color::XYZ_TO_STOCKMAN_SHARP_LMS_MAT;
  static const float3x3 XYZ_FROM_LMS_2006 = renodx::math::Invert3x3(XYZ_TO_LMS_2006);

  float3 color_xyz = renodx::color::xyz::from::BT2020(bt2020);
  float3 color_lms = mul(XYZ_TO_LMS_2006, color_xyz);

  // Fixed white basis: D65.
  float3 lms_raw = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(bt2020));
  float3 lms_white = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(1.f));

  float3 lms = lms_raw;

  // Trying out Per-Channel N2 in LMS
  float3 lms_peak = lms_white * peak_value;
  float3 peak = max(lms_peak, kEps.xxx);
  float3 sign_lms = float3(
      lms.x < 0.f ? -1.f : 1.f,
      lms.y < 0.f ? -1.f : 1.f,
      lms.z < 0.f ? -1.f : 1.f);
  float3 abs_lms = abs(lms);
  float3 n2_lms = renodx::tonemap::neutwo::PerChannel(abs_lms, peak);
  float3 lms_toned = sign_lms * n2_lms;

  float3 bt2020_toned = renodx::color::bt2020::from::XYZ(mul(XYZ_FROM_LMS_2006, lms_toned));
  return renodx::color::bt709::from::BT2020(bt2020_toned);
}

#endif  // INCLUDE_ETCFUNCTIONS