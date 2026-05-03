/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#ifndef RENODX_SHADERS_TONEMAP_PSYCHOV_17_HLSL_
#define RENODX_SHADERS_TONEMAP_PSYCHOV_17_HLSL_

// How to use:
//   - Include this file directly; it has no dependencies.
//   - Use SDR(color, cone_response) for SDR output with BT.709 gamut compression.
//   - Use HDR(color, peak, cone_response) for HDR output with BT.2020 gamut compression.
//   - For full control, call psychov_17(...) directly.

namespace renodx {
namespace tonemap {
namespace psycho {

float psycho17_Select(bool condition, float true_value, float false_value) {
#ifdef __SHADER_TARGET_MAJOR
#if __SHADER_TARGET_MAJOR >= 6
  return select(condition, true_value, false_value);
#else
  [flatten]
  if (condition) {
    return true_value;
  } else {
    return false_value;
  }
#endif
#else
  [flatten]
  if (condition) {
    return true_value;
  } else {
    return false_value;
  }
#endif
}

float psycho17_DivideSafe(float dividend, float divisor, float fallback) {
  return psycho17_Select(divisor == 0.f, fallback, dividend / divisor);
}

float3 psycho17_DivideSafe(float3 dividend, float3 divisor, float3 fallback) {
  return float3(
      psycho17_DivideSafe(dividend.x, divisor.x, fallback.x),
      psycho17_DivideSafe(dividend.y, divisor.y, fallback.y),
      psycho17_DivideSafe(dividend.z, divisor.z, fallback.z));
}

float3x3 psycho17_Invert3x3(float3x3 m) {
  float a = m[0][0], b = m[0][1], c = m[0][2];
  float d = m[1][0], e = m[1][1], f = m[1][2];
  float g = m[2][0], h = m[2][1], i = m[2][2];

  float A = (e * i - f * h);
  float B = -(d * i - f * g);
  float C = (d * h - e * g);
  float D = -(b * i - c * h);
  float E = (a * i - c * g);
  float F = -(a * h - b * g);
  float G = (b * f - c * e);
  float H = -(a * f - c * d);
  float I = (a * e - b * d);

  float det = a * A + b * B + c * C;
  float invDet = psycho17_DivideSafe(1.0, det, 0.0);

  return float3x3(
             A, D, G,
             B, E, H,
             C, F, I)
         * invDet;
}

static const float psycho17_EPSILON = 1e-20f;
static const float psycho17_MB_NEAR_WHITE_EPSILON = 1e-14f;
static const float psycho17_INTERVAL_MAX = 3.402823466e+38f;
static const float psycho17_CIE1702_RAY_T_MAX = 1e20f;
static const uint psycho17_FLT32_SIGN = 0x80000000u;
static const uint psycho17_FLT32_MAGNITUDE = 0x7FFFFFFFu;
static const float3x3 psycho17_STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT = float3x3(
    1.94735469f, -1.41445123f, 0.36476327f,
    0.68990272f, 0.34832189f, 0.00000000f,
    0.00000000f, 0.00000000f, 1.93485343f);
static const float3 psycho17_LMS_WEIGHTS = float3(
    psycho17_STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1][0],
    psycho17_STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1][1],
    0.0371597069161f);
static const float3x3 psycho17_BT709_TO_XYZ_MAT = float3x3(
    0.4123907993f, 0.3575843394f, 0.1804807884f,
    0.2126390059f, 0.7151686788f, 0.0721923154f,
    0.0193308187f, 0.1191947798f, 0.9505321522f);
static const float3x3 psycho17_XYZ_TO_BT709_MAT = float3x3(
    3.2409699419f, -1.5373831776f, -0.4986107603f,
    -0.9692436363f, 1.8759675015f, 0.0415550574f,
    0.0556300797f, -0.2039769589f, 1.0569715142f);
static const float3x3 psycho17_BT2020_TO_XYZ_MAT = float3x3(
    0.6369580483f, 0.1446169036f, 0.1688809752f,
    0.2627002120f, 0.6779980715f, 0.0593017165f,
    0.0000000000f, 0.0280726930f, 1.0609850577f);
static const float3x3 psycho17_XYZ_TO_LMS_MAT = float3x3(
    0.2670502842655792, 0.8471990148492798, -0.03470416612462053,
    -0.38706882411220156, 1.165429935890458, 0.10302286696614202,
    0.026727793989083093, -0.02729131667566509, 0.5333267257603284);
static const float3x3 psycho17_LMS_TO_XYZ_MAT = psycho17_Invert3x3(psycho17_XYZ_TO_LMS_MAT);
static const float3x3 psycho17_LMS_TO_LMS_WEIGHTED_MAT = float3x3(
    psycho17_LMS_WEIGHTS.x, 0.f, 0.f,
    0.f, psycho17_LMS_WEIGHTS.y, 0.f,
    0.f, 0.f, psycho17_LMS_WEIGHTS.z);
static const float3x3 psycho17_XYZ_TO_LMS_WEIGHTED_MAT = float3x3(
    mul(psycho17_LMS_TO_LMS_WEIGHTED_MAT, psycho17_XYZ_TO_LMS_MAT));
static const float3x3 psycho17_BT709_TO_LMS_WEIGHTED_MAT =
    mul(psycho17_XYZ_TO_LMS_WEIGHTED_MAT, psycho17_BT709_TO_XYZ_MAT);
static const float3x3 psycho17_BT2020_TO_LMS_WEIGHTED_MAT =
    mul(psycho17_XYZ_TO_LMS_WEIGHTED_MAT, psycho17_BT2020_TO_XYZ_MAT);

float psycho17_CopySign(float mag, float sgn) {
#ifdef __SHADER_TARGET_MAJOR
#if __SHADER_TARGET_MAJOR <= 3
  float abs_value = abs(mag);
  return psycho17_Select(sgn < 0.f, -abs_value, abs_value);
#else
  uint sign_bits = asuint(sgn) & psycho17_FLT32_SIGN;
  uint mag_bits = asuint(mag) & psycho17_FLT32_MAGNITUDE;
  return asfloat(sign_bits | mag_bits);
#endif
#else
  uint sign_bits = asuint(sgn) & psycho17_FLT32_SIGN;
  uint mag_bits = asuint(mag) & psycho17_FLT32_MAGNITUDE;
  return asfloat(sign_bits | mag_bits);
#endif
}

float3 psycho17_CopySign(float3 mag, float3 sgn) {
#ifdef __SHADER_TARGET_MAJOR
#if __SHADER_TARGET_MAJOR <= 3
  float3 abs_value = abs(mag);
  return float3(
      psycho17_Select(sgn.x < 0.f, -abs_value.x, abs_value.x),
      psycho17_Select(sgn.y < 0.f, -abs_value.y, abs_value.y),
      psycho17_Select(sgn.z < 0.f, -abs_value.z, abs_value.z));
#else
  uint3 sign_bits = asuint(sgn) & psycho17_FLT32_SIGN;
  uint3 mag_bits = asuint(mag) & psycho17_FLT32_MAGNITUDE;
  float3 result = asfloat(sign_bits | mag_bits);
  return result;
#endif
#else
  uint3 sign_bits = asuint(sgn) & psycho17_FLT32_SIGN;
  uint3 mag_bits = asuint(mag) & psycho17_FLT32_MAGNITUDE;
  float3 result = asfloat(sign_bits | mag_bits);
  return result;
#endif
}

float psycho17_SignPow(float x, float exponent) {
  return psycho17_CopySign(pow(abs(x), exponent), x);
}

float psycho17_ContrastSafe(float x, float contrast, float mid_gray) {
  return psycho17_SignPow(x / mid_gray, contrast) * mid_gray;
}

float psycho17_Highlights(float x, float highlights, float mid_gray) {
  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
  } else if (highlights < 1.f) {
    return min(x, x / (1.f + mid_gray * pow(x / mid_gray, 2.f - highlights) - x));
  }
  return x;
}

float psycho17_Shadows(float x, float shadows, float mid_gray) {
  if (shadows > 1.f) {
    return max(x, x * (1.f + (x * mid_gray / pow(x / mid_gray, shadows))));
  } else if (shadows < 1.f) {
    return clamp(x * (1.f - (x * mid_gray / pow(x / mid_gray, 2.f - shadows))), 0.f, x);
  }
  return x;
}

float3 psycho17_BT709ToLMS(float3 bt709) {
  return mul(psycho17_XYZ_TO_LMS_MAT, mul(psycho17_BT709_TO_XYZ_MAT, bt709));
}

float3 psycho17_XYZFromxyY(float3 xyY) {
  float3 xyz;
  xyz.xz = float2(xyY.x, 1.f - xyY.x - xyY.y) / xyY.y * xyY.z;
  xyz.y = xyY.z;
  return xyz;
}

float3 psycho17_LMSToBT709(float3 lms) {
  return mul(psycho17_XYZ_TO_BT709_MAT, mul(psycho17_LMS_TO_XYZ_MAT, lms));
}

float psycho17_YFFromLMS(float3 lms) {
  return mul(psycho17_STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT, lms).y;
}

float psycho17_YFFromBT709(float3 bt709) {
  return psycho17_YFFromLMS(psycho17_BT709ToLMS(bt709));
}

float3 psycho17_WeighLMS(float3 lms) {
  return lms * psycho17_LMS_WEIGHTS;
}

float3 psycho17_UnweighLMS(float3 lms_weighted) {
  return lms_weighted / psycho17_LMS_WEIGHTS;
}

float3 psycho17_WeightedLMSFromMacleodBoynton(float2 mb, float l_plus_m) {
  return float3(mb.x, 1.f - mb.x, mb.y) * l_plus_m;
}

float3 psycho17_WeightedLMSFromMacleodBoynton(float3 mb) {
  return psycho17_WeightedLMSFromMacleodBoynton(mb.xy, mb.z);
}

float3 psycho17_MacleodBoyntonFromWeightedLMS(float3 weighted_lms) {
  float y_mb = max(weighted_lms.x + weighted_lms.y, 0.f);
  float inv = psycho17_DivideSafe(1.f, y_mb, 0.f);
  return float3(weighted_lms.x * inv, weighted_lms.z * inv, y_mb);
}

float3 psycho17_MacleodBoyntonFromLMS(float3 lms) {
  return psycho17_MacleodBoyntonFromWeightedLMS(psycho17_WeighLMS(lms));
}

float3 psycho17_LMSFromMacleodBoynton(float3 mb) {
  return psycho17_WeightedLMSFromMacleodBoynton(mb) / psycho17_LMS_WEIGHTS;
}

float2 psycho17_D65MacleodBoyntonXY() {
  return psycho17_MacleodBoyntonFromWeightedLMS(
             mul(psycho17_LMS_TO_LMS_WEIGHTED_MAT,
                 mul(psycho17_XYZ_TO_LMS_MAT, psycho17_XYZFromxyY(float3(float2(0.31272, 0.32903), 1.f)))))
      .xy;
}

float psycho17_Cross2(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

bool psycho17_RaySegmentHit2D(float2 origin, float2 direction, float2 a, float2 b, out float t_hit) {
  t_hit = 0.f;
  float2 edge = b - a;
  float denom = psycho17_Cross2(direction, edge);
  if (abs(denom) <= psycho17_EPSILON) return false;

  float2 a_origin = a - origin;
  float t = psycho17_Cross2(a_origin, edge) / denom;
  float u = psycho17_Cross2(a_origin, direction) / denom;
  if (t < 0.f || u < 0.f || u > 1.f) return false;

  t_hit = t;
  return true;
}

float psycho17_RayMaxT_RGBTriangleInMB(
    float2 origin,
    float2 direction,
    float2 r,
    float2 g,
    float2 b,
    out bool has_solution) {
  has_solution = false;
  if (dot(direction, direction) <= psycho17_MB_NEAR_WHITE_EPSILON) return 0.f;

  float t_best = psycho17_INTERVAL_MAX;
  float t_hit;
  bool hit_any = false;

  if (psycho17_RaySegmentHit2D(origin, direction, r, g, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }
  if (psycho17_RaySegmentHit2D(origin, direction, g, b, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }
  if (psycho17_RaySegmentHit2D(origin, direction, b, r, t_hit)) {
    t_best = min(t_best, t_hit);
    hit_any = true;
  }

  has_solution = hit_any;
  return hit_any ? max(t_best, 0.f) : 0.f;
}

float psycho17_NeutwoPeakClip(float x, float peak, float clip) {
  float peak_safe = max(peak, 0.f);
  float clip_safe = max(clip, peak_safe);
  float x2 = x * x;
  float clip2 = clip_safe * clip_safe;
  float peak2 = peak_safe * peak_safe;
  float denominator_squared = mad(x2, clip2 - peak2, clip2 * peak2);
  return (clip_safe * peak_safe * x) * rsqrt(max(denominator_squared, 1e-20f));
}

float psycho17_NeutwoScaleFromRayT(float t_peak, float t_clip) {
  float t_peak_safe = max(t_peak, 0.f);
  float t_clip_safe = max(t_clip, t_peak_safe);
  return saturate(psycho17_NeutwoPeakClip(1.f, t_peak_safe, t_clip_safe));
}

float psycho17_SoftCompressionActivationFromRayT(float t_peak, float knee = 0.08f) {
  float outside = 1.f - saturate(t_peak);
  return psycho17_DivideSafe(outside, outside + max(knee, 1e-6f), 0.f);
}

float3 psycho17_NakaRushton(
    float3 x,
    float3 peak,
    float3 anchor_in,
    float3 anchor_out,
    float cone_response_exponent) {
  float3 peak_minus_anchor_out = peak - anchor_out;
  float3 n = cone_response_exponent * peak / peak_minus_anchor_out;
  float3 contrasted = anchor_out * pow(abs(x) / anchor_in, n);
  float3 saturated = peak * contrasted / (contrasted + peak_minus_anchor_out);
  return psycho17_CopySign(saturated, x);
}

float psycho17_RayExitTCIE1702(float2 origin, float2 direction) {
  if (dot(direction, direction) <= psycho17_MB_NEAR_WHITE_EPSILON) {
    return psycho17_CIE1702_RAY_T_MAX;
  }

  static const int kEdgeCount = 7;
  static const float2 kHalfspaceNormals[kEdgeCount] = {
    float2(-0.043889f, -0.006807f),
    float2(-0.007821f, -0.008564f),
    float2(-0.000604f, -0.007942f),
    float2(0.f, -0.080835f),
    float2(0.953597f, 0.307020f),
    float2(-0.060969f, 0.019752f),
    float2(-0.106895f, 0.004035f),
  };
  static const float kHalfspaceNumerators[kEdgeCount] = {
    0.0065035249f,
    0.00104900495f,
    0.000207697044f,
    0.00165556648f,
    0.252472349f,
    0.0241967351f,
    0.0199621232f,
  };

  float2 white_to_origin = psycho17_D65MacleodBoyntonXY() - origin;
  float t_best = psycho17_CIE1702_RAY_T_MAX;
  bool hit_any = false;

  [unroll]
  for (int i = 0; i < kEdgeCount; ++i) {
    float2 halfspace_normal = kHalfspaceNormals[i];
    float denom = dot(halfspace_normal, direction);
    float numerator = kHalfspaceNumerators[i] + dot(halfspace_normal, white_to_origin);
    float t = denom > 1e-8f ? numerator * rcp(denom) : psycho17_CIE1702_RAY_T_MAX;
    t_best = min(t_best, t);
    hit_any = hit_any || (denom > 1e-8f);
  }

  return hit_any ? max(t_best, 0.f) : psycho17_CIE1702_RAY_T_MAX;
}

float psycho17_HueRelativePuritySignalFromTClip(float t_clip) {
  return saturate(psycho17_DivideSafe(1.f, t_clip, 0.f));
}

float psycho17_AdaptiveHueSensitivityFromTClip(float t_clip) {
  static const float kMeanD65RayDistance = 0.20139844f;
  static const float kMaxD65RayDistance = 1.02634534f;
  static const float kMinSensitivity = 0.35f;

  float long_ray_weight = saturate(psycho17_DivideSafe(
      t_clip - kMeanD65RayDistance,
      kMaxD65RayDistance - kMeanD65RayDistance,
      0.f));
  return lerp(1.f, kMinSensitivity, long_ray_weight);
}

float psycho17_HueRelativePuritySignalFromMB(float2 mb_xy, float2 mb_anchor) {
  float2 direction = mb_xy - mb_anchor;
  if (dot(direction, direction) <= psycho17_MB_NEAR_WHITE_EPSILON) {
    return 0.f;
  }

  return psycho17_HueRelativePuritySignalFromTClip(
      psycho17_RayExitTCIE1702(mb_anchor, direction));
}

float psycho17_HueRelativePuritySignalFromMB(float3 mb, float2 mb_anchor) {
  if (!(mb.z > psycho17_EPSILON)) {
    return 0.f;
  }

  return psycho17_HueRelativePuritySignalFromMB(mb.xy, mb_anchor);
}

float psycho17_HueRelativePuritySignal(float3 lms_input, float2 mb_anchor) {
  float3 lms_weighted = psycho17_WeighLMS(max(lms_input, 0.f));
  float3 mb = psycho17_MacleodBoyntonFromWeightedLMS(lms_weighted);
  if (!(mb.z > psycho17_EPSILON)) {
    return 0.f;
  }

  return psycho17_HueRelativePuritySignalFromMB(mb, mb_anchor);
}

float psycho17_D65HueSensitivity(float2 mb_xy) {
  float2 mb_white = psycho17_D65MacleodBoyntonXY();
  float2 direction = mb_xy - mb_white;
  if (dot(direction, direction) <= psycho17_MB_NEAR_WHITE_EPSILON) {
    return 1.f;
  }

  return psycho17_AdaptiveHueSensitivityFromTClip(
      psycho17_RayExitTCIE1702(mb_white, direction));
}

float3 psycho17_ToAdaptiveRelativeLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return psycho17_DivideSafe(lms_input, current_adaptive_state_lms, 0.f.xxx);
}

float3 psycho17_FromAdaptiveRelativeLMS(float3 lms_relative, float3 current_adaptive_state_lms) {
  return lms_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 psycho17_ToAdaptiveRelativeWeightedLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return psycho17_DivideSafe(
      psycho17_WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho17_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float2 psycho17_MBFromWeightedPrimary(float3 weighted_lms_primary) {
  return psycho17_MacleodBoyntonFromWeightedLMS(weighted_lms_primary).xy;
}

float3 psycho17_RGBToWeightedLMSPrimaryColumn(float3x3 rgb_to_lms_weighted_mat, uint primary_index) {
  return float3(
      rgb_to_lms_weighted_mat[0][primary_index],
      rgb_to_lms_weighted_mat[1][primary_index],
      rgb_to_lms_weighted_mat[2][primary_index]);
}

float3 psycho17_RGBToAdaptiveWeightedLMSPrimaryColumn(
    float3x3 rgb_to_lms_weighted_mat,
    uint primary_index,
    float3 current_adaptive_state_lms) {
  return psycho17_RGBToWeightedLMSPrimaryColumn(rgb_to_lms_weighted_mat, primary_index) / current_adaptive_state_lms;
}

void psycho17_MakeRGBTriangleInMBFromWeightedPrimaries(
    float3 weighted_r,
    float3 weighted_g,
    float3 weighted_b,
    out float2 r,
    out float2 g,
    out float2 b) {
  r = psycho17_MBFromWeightedPrimary(weighted_r);
  g = psycho17_MBFromWeightedPrimary(weighted_g);
  b = psycho17_MBFromWeightedPrimary(weighted_b);
}

void psycho17_MakeRGBTriangleInMBAdaptiveWeighted(
    float3x3 rgb_to_lms_weighted_mat,
    float3 current_adaptive_state_lms,
    out float2 r,
    out float2 g,
    out float2 b) {
  psycho17_MakeRGBTriangleInMBFromWeightedPrimaries(
      psycho17_RGBToAdaptiveWeightedLMSPrimaryColumn(
          rgb_to_lms_weighted_mat, 0, current_adaptive_state_lms),
      psycho17_RGBToAdaptiveWeightedLMSPrimaryColumn(
          rgb_to_lms_weighted_mat, 1, current_adaptive_state_lms),
      psycho17_RGBToAdaptiveWeightedLMSPrimaryColumn(
          rgb_to_lms_weighted_mat, 2, current_adaptive_state_lms),
      r,
      g,
      b);
}

float3 psycho17_ClampWeightedLMSToCIE1702(float3 lms_weighted_input, float purity_max = 1.f) {
  float3 lms_weighted_clamped = max(lms_weighted_input, 0.f);
  float3 mb = psycho17_MacleodBoyntonFromWeightedLMS(lms_weighted_clamped);
  float y_mb = mb.z;
  float2 ls = mb.xy;
  if (!(y_mb > psycho17_EPSILON)) {
    return float3(lms_weighted_clamped.x, lms_weighted_clamped.y, 0.f);
  }

  float2 mb_white = psycho17_D65MacleodBoyntonXY();
  float2 direction = ls - mb_white;
  if (dot(direction, direction) <= psycho17_MB_NEAR_WHITE_EPSILON) {
    return lms_weighted_clamped;
  }

  float t_clip = psycho17_RayExitTCIE1702(mb_white, direction);
  float t_final = min(1.f, max(purity_max, 0.f) * t_clip);
  float2 ls_out = mb_white + direction * t_final;
  return psycho17_WeightedLMSFromMacleodBoynton(ls_out, y_mb);
}

float3 psycho17_GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
    float3 lms_weighted_input,
    float2 bound_r,
    float2 bound_g,
    float2 bound_b,
    float strength) {
  float3 lms_weighted_clamped = psycho17_ClampWeightedLMSToCIE1702(max(lms_weighted_input, 0.f));
  float3 mb = psycho17_MacleodBoyntonFromWeightedLMS(lms_weighted_clamped);
  float y_mb = mb.z;
  float2 ls = mb.xy;
  if (!(y_mb > psycho17_EPSILON)) {
    return float3(lms_weighted_clamped.x, lms_weighted_clamped.y, 0.f);
  }

  float2 mb_white = psycho17_D65MacleodBoyntonXY();
  float2 direction = ls - mb_white;
  if (dot(direction, direction) <= psycho17_MB_NEAR_WHITE_EPSILON) {
    return lms_weighted_clamped;
  }

  bool has_peak = false;
  float t_peak = psycho17_RayMaxT_RGBTriangleInMB(
      mb_white, direction, bound_r, bound_g, bound_b, has_peak);
  float t_clip = psycho17_RayExitTCIE1702(mb_white, direction);
  if (!has_peak) {
    t_peak = t_clip;
  }

  float t_hard = saturate(t_peak);
  float t_soft = psycho17_NeutwoScaleFromRayT(min(t_peak, t_clip), t_clip);
  float soft_mix = saturate(strength) * psycho17_SoftCompressionActivationFromRayT(t_peak);
  float t_final = lerp(t_hard, t_soft, soft_mix);

  float2 ls_out = mb_white + t_final * direction;
  return psycho17_WeightedLMSFromMacleodBoynton(ls_out, y_mb);
}

float3 psycho17_GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
    float3 lms_weighted_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float2 bound_r;
  float2 bound_g;
  float2 bound_b;
  psycho17_MakeRGBTriangleInMBAdaptiveWeighted(
      bound_rgb_to_lms_weighted_mat,
      current_adaptive_state_lms,
      bound_r,
      bound_g,
      bound_b);
  return psycho17_GamutCompressWeightedLMSCoreRGBBoundFromWeightedInput(
      lms_weighted_input,
      bound_r,
      bound_g,
      bound_b,
      strength);
}

float3 psycho17_GamutCompressLMSBoundAdaptive(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float3 lms_weighted_relative =
      psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, current_adaptive_state_lms);
  float3 lms_weighted_relative_out =
      psycho17_GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
          lms_weighted_relative,
          current_adaptive_state_lms,
          bound_rgb_to_lms_weighted_mat,
          strength);
  return psycho17_UnweighLMS(
      psycho17_FromAdaptiveRelativeWeightedLMS(
          lms_weighted_relative_out,
          current_adaptive_state_lms));
}

float3 psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
    float3 lms_weighted_relative_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  return psycho17_GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
      lms_weighted_relative_input,
      current_adaptive_state_lms,
      bound_rgb_to_lms_weighted_mat,
      strength);
}

float psycho17_AdaptiveHueSensitivity(float2 mb_xy, float2 mb_anchor) {
  float2 direction = mb_xy - mb_anchor;
  if (dot(direction, direction) <= psycho17_MB_NEAR_WHITE_EPSILON) {
    return 1.f;
  }

  return psycho17_AdaptiveHueSensitivityFromTClip(
      psycho17_RayExitTCIE1702(mb_anchor, direction));
}

// psychov-14
//
// Objective:
// psychov-14 first targets the observer-side bend of the scene:
// - what state the eye adapts to,
// - how the scene is converted to contrast around that adapted state,
// - how the response is shaped around that adapted state,
// - which nonlinear curve applies at each stage.
// The human observer is not a linear gain system, so the first job of this
// test is to model how a cone/adaptation/opponent/normalization cascade bends
// scene light before any device mapping is considered.
//
// psychov-14 therefore treats the problem as two coupled but distinct systems:
// - observer flow: approximate the ordered flow of the human cone visual
//   pathway with a literature-backed cascade, so each stage in the code
//   corresponds to a recognizable stage in human vision rather than an
//   arbitrary tone curve,
// - device-hull mapping: tonemap the observer-domain result into the display's
//   luminance / gamut hull as plausibly as possible.
// Tonemapping itself remains a device-hull problem, not an eye model, but the
// observer model decides which scene differences remain perceptually important
// enough to preserve when the device hull forces compression.
//
// Intended human-flow model and supporting references:
// 1) Receptor basis:
//    Stockman-Sharpe LMS with CIE 170-2 physiological luminance Yf / weighted
//    LMS bookkeeping, not CIE 1931 Y.
//    Reference split:
//    - Brainard, "Colorimetry" (chapter 10): the cone stage / color match
//      foundation. Chapter 11 explicitly points back to this chapter when it
//      says "The first stage of color vision is now well understood (see
//      Chap. 10)." For psychov, this is the source for step 1:
//      scene RGB/XYZ -> absolute cone excitations L, M, S.
//    - Stockman & Brainard (chapter 11): builds on that receptor basis for
//      first-site and second-site adaptation.
//    Sources:
//    https://color2.psych.upenn.edu/brainard/papers/Brainard_Stockman_Colorimetry.pdf
//    https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//    CVRL background notes that cone signals are formed only after
//    prereceptoral filtering by the ocular media and macular pigment, both of
//    which absorb mainly at short wavelengths and vary substantially across
//    observers. The current repo plumbing should therefore be understood as an
//    average-observer receptor basis unless those filters are modeled
//    explicitly.
//    Reference: CVRL background hub; "Macular and lens pigments"
//    (http://www.cvrl.org/background.htm,
//     http://www.cvrl.org/database/text/intros/intromaclens.htm).
//    MacLeod-Boynton is important here: it is not itself the cortical flow,
//    but a weighted cone-chromaticity representation in an equal-luminance
//    plane with a separately carried achromatic scale term. In repo notation:
//      l = Lw / (Lw + Mw)
//      s = Sw / (Lw + Mw)
//      y = Lw + Mw
//    The weights here are fixed observer-transform coefficients used to form
//    weighted LMS, Yf-like achromatic response, and MB coordinates from LMS.
//    They are not adaptation, gain, or bleaching terms. CVRL describes the
//    CIE physiological functions as linear transformations of the Stockman &
//    Sharpe cone fundamentals, and Mantiuk et al. describe a practical LMS
//    scaling "so that the sum of L and M cone responses corresponds to
//    luminance". That is the math role of the weights in this stage.
//    Reference: MacLeod & Boynton (1979, doi:10.1364/JOSA.69.001183); modern
//    CIE 170-2 implementations replace ad hoc weights with standardized
//    physiological cone-fundamental / luminance weights.
//    Citation split for the weights used in this file:
//    - Explicit CIE 170-2 / physiological-weight usage:
//      CIE / CVRL physiological functions; Psychtoolbox LMSToMacBoyn; this
//      repo's stockman_macleod_boynton.hlsl wiring.
//    - Classic or modified MacLeod-Boynton without an explicit CIE 170-2
//      coefficient claim:
//      MacLeod & Boynton (1979); Webster & Leonard (2008).
//    - LMS scaled so the achromatic term is L+M, but without an explicit
//      CIE 170-2 MacLeod-Boynton coefficient claim:
//      Mantiuk et al. (2020).
//    So classic MB, modified MB, and plain L+M-scaled LMS should not be cited
//    as if they automatically justify the exact CIE 170-2 coefficients used
//    here.
//    Sources:
//    http://www.cvrl.org/ciexyzpr.htm
//    https://psychtoolbox.org/docs/LMSToMacBoyn
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC2657039/
//    https://www.cl.cam.ac.uk/~rkm38/pdfs/mantiuk2020practical_csf.pdf
// 2) Early cone adaptation:
//    Maintain an adapting background state (L0, M0, S0, Yf0), then express the
//    stimulus relative to that background before any postreceptoral transform.
//    Chapter split:
//    - chapter 10 gives the absolute cone excitations,
//    - chapter 11 then defines how those cone excitations depend on the
//      adapting background and are converted to a contrast representation.
//    Source-backed first-site math is cone-specific contrast / gain control,
//    not a rule that every adapted background is mapped to one fixed output
//    level. Stockman & Brainard write the first-site cone contrast for the
//    L-cone as:
//      C_L = ΔL / (L_b + L_0)
//    with analogous forms for M and S. Equivalently, a background-dependent
//    gain g_L = 1 / (L_b + L_0) acts on the increment:
//      g_L * (L - L_b) = ΔL / (L_b + L_0)
//    Thus the observer is approximately normalizing cone signals by the
//    adapted background, not forcing all backgrounds to one arbitrary response
//    value. First-site adaptation is also not complete or instantaneous, and
//    later second-site adaptation further reshapes postreceptoral signals.
//    References: Stockman & Brainard (2010); Stockman et al. (JOV 2006,
//    doi:10.1167/6.11.5).
//    Webster & Leonard (2008) add an important structural point, but their
//    terms need to stay separate. Their "response norm" is the adapting level
//    that does not bias white judgments, while their "perceptual norm" is the
//    stimulus that appears white. Those psychophysical norms tracked each
//    other closely in their experiments, but they are not the same term as the
//    background cone excitations L_b / M_b / S_b in Stockman & Brainard or
//    the background responses L0 / M0 / S0 in Mantiuk et al. For psychov, the
//    directly modeled early state is therefore best named the adapted
//    background reference (L0, M0, S0, optional Yf0), while Webster's
//    response-norm / perceptual-norm language remains useful as higher-level
//    interpretation of why that adapted reference acts as the current neutral
//    coding state. Webster & Leonard also argue that steady uniform-field
//    chromatic adaptation appeared to arise largely at early stages affected
//    by adaptation.
//    Source:
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC2657039/
//    CVRL further notes that luminosity functions are strongly dependent on
//    chromatic adaptation and observing conditions, whereas cone spectral
//    sensitivities remain fixed until photopigment bleaching becomes
//    significant. That is the reason to keep Yf / luminosity bookkeeping tied
//    to the adapted observer state rather than treating a single photometric Y
//    curve as condition-invariant.
//    Reference: CVRL "Luminosity functions"
//    (http://www.cvrl.org/database/text/intros/introvl.htm).
// 2a) Dim cone-noise regime:
//    Before true rod-dominated vision, cone-mediated detection can already be
//    limited by quantal / transduction noise. In this dim-but-still-cone
//    regime, threshold cone contrast follows approximately De Vries-Rose
//    behavior: in log-log space, threshold contrast decreases with retinal
//    illuminance with slope near -0.5. At higher light levels the system moves
//    toward Weber-like behavior, where threshold contrast is roughly constant
//    relative to the adapted background. This matters for psychov because
//    weak scene differences can disappear into a cone-noise-limited threshold
//    floor before rod vision becomes dominant.
//    Reference direction:
//    - Stockman & Brainard (2010): cone-contrast space is most useful when
//      first-site adaptation is in the Weber regime, and less useful when
//      adaptation falls short of Weber's law at lower levels.
//    - Angueyra & Rieke (2013): primate cone photoreceptors exhibit measurable
//      phototransduction noise, giving a photoreceptor-level source for the
//      dim-light threshold floor.
//    Sources:
//    https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC3815624/
// 2b) High-light bleaching:
//    At sufficiently high retinal illuminance, reduce per-cone pigment
//    availability with a Rushton-Henry-style law in trolands:
//      p(I) = 1 / (1 + I / I0)
//    This is the complementary "available pigment" form of the more commonly
//    cited fraction-bleached law:
//      p_bleached(I) = I / (I + I0)
//    with I0 ~ 10^4.3 Td for cones.
//    Then apply that availability to cone excursions around an adapted white
//    anchor. In the current repo bleaching helper this is implemented as
//    per-cone attenuation of LMS deltas around a white-at-achromatic-level
//    anchor, so availability -> 0 drives the response toward equal white at the
//    same carried achromatic level. That is the desired "intensely bright tends
//    to bleach to white" behavior for this test.
//    Source and attribution:
//    - Stockman et al. (JOV 2006, doi:10.1167/6.11.5): high-light sensitivity
//      regulation is maintained mainly by photopigment bleaching.
//    - Stockman et al. (JOV 2018, 18(6):12): appendix states the steady-state
//      bleaching law p = I / (I + I0), I0 = 10^4.3 Td, citing Rushton & Henry
//      (1968).
//    - CVRL "Bleaching": bleaching reduces effective pigment concentration and
//      narrows spectral sensitivity without changing lambda_max; in cones this
//      matters enough to affect chromatic adaptation and color matching, so a
//      pure scalar availability model is only a first-order approximation.
//      (http://www.cvrl.org/database/text/intros/introbleaches.htm)
//    - The final white-relative application used here is the repo's rendering
//      interpretation of that availability law for color signals; see
//      color/bleaching.hlsl for the exact helper.
//    Placement in the overall flow:
//    - bleaching belongs inside the observer model,
//    - after the adapting background state is defined,
//    - before postreceptoral opponent encoding and pooled cortical gain,
//    - and therefore before any device-hull tonemapping / gamut compression.
// 3) Background-normalized opponent drive:
//    Convert cone-domain responses into ACC / DKL-style opponent coordinates
//    using a background-referenced, weighted-LMS achromatic axis.
//    Reference direction: derive postreceptoral opponent coordinates from the
//    adapted cone-domain state and keep this stage clearly separated from the
//    receptor / adaptation math above.
//    Important distinction: MacLeod-Boynton describes chromaticity on the
//    equal-luminance plane, while ACC / DKL are opponent combinations of cone
//    increments around a background. MB is therefore the right place to carry
//    hue / gamut geometry and achromatic Yf bookkeeping; ACC / DKL is the
//    better place to describe postreceptoral opponent response and gain.
// 4) Saturating contrast response:
//    Use a Michaelis-Menten / Naka-Rushton-like nonlinearity for receptor or
//    early cortical contrast response. A supersaturating variant may be needed
//    later for some cortical fits.
//    Reference: Peirce (JOV 2007, doi:10.1167/7.6.13).
// 5) ON/OFF separation:
//    Split increments and decrements with half-wave rectification before the
//    pooled gain stage.
//    Reference: Schiller (1992).
// 6) Pooled cortical gain:
//    Apply divisive normalization, potentially with energy-like pooling across
//    achromatic and chromatic channels.
//    Reference: Heeger (1992); Carandini & Heeger (2012); Bun & Horwitz
//    (2023); Li et al. (2022).
// 7) Device-hull tonemapping / gamut mapping:
//    Map the observer-domain result into the display hull in a space that keeps
//    enough achromatic and chromatic contrast / JND energy to preserve the
//    scene plausibly on the target device. White is one valid attractor when
//    bleaching or the achromatic optimum dominates, but it is not the only
//    valid out-of-hull destination.
//    Inference for RGB display hulls:
//    - many device hulls can produce more total achromatic output by combining
//      primaries than they can produce at the same brightness with a high-purity
//      chromatic excursion,
//    - therefore an out-of-hull observer response may need to trade chromatic
//      shape / purity toward the achromatic axis if that is what the device
//      hull allows,
//    - the preferred mapping is not blind clipping to white, but the in-hull
//      point that preserves the most plausible observer-domain contrast energy.
//    Engineering direction inferred from the sources above:
//    - use MB / weighted-LMS to carry achromatic Yf and hue geometry,
//    - use ACC / opponent space to judge postreceptoral contrast structure,
//    - construct or project to a display hull in that combined space rather
//      than clipping in RGB.
//    Coupling constraint:
//    - hue preservation and device-hull compression are not independent steps,
//    - a hue change applied after hull compression can push the result back out
//      of the device hull,
//    - therefore hue-preserving motion should either be solved inside the hull
//      projection itself or followed by another explicit in-hull reprojection.
//    Reference direction: MacLeod-Boynton / CIE 170-2 geometry;
//    repo weighted-LMS / MB geometry plus the device-hull notes above.
// 7a) Optional hue model inside the device-hull solve:
//    If gamut compression or display desaturation bends hue in a way that
//    looks wrong, the hull solve can preserve hue by an "equivalent Gaussian
//    peak" proxy rather than by preserving a raw opponent angle. The idea is
//    that at short and medium wavelengths, perceived hue can behave more like a
//    constant spectral peak of an equivalent Gaussian than a constant cone
//    ratio when purity changes.
//    Practical form:
//    - offline, map weighted LMS / MB chromaticities to an equivalent Gaussian
//      peak parameter mu_eq using a spectral forward model,
//    - online, preserve mu_eq during gamut compression / display mapping while
//      carrying Yf separately,
//    - do not apply an unconstrained post-hoc hue shift after final hull
//      compression unless the result is reprojected back into the device hull.
//    This is not a separate chronological eye stage after stage 7. It is an
//    optional hue objective used inside the device-hull mapping stage.
//    Reference: Mizokami et al. (JOV 2006, doi:10.1167/6.9.12);
//    O'Neil et al. (JOSAA 2012, doi:10.1364/JOSAA.29.00A165).
//
// Mermaid source map of planned psychov inputs, derived states, and outputs:
// ```mermaid
// flowchart TB
//   classDef raw fill:#223041,stroke:#7aa2d2,color:#e8f0ff
//   classDef func fill:#3c2a4d,stroke:#b48ef7,color:#f5ecff
//   classDef state fill:#294436,stroke:#77c79a,color:#effff5
//   classDef out fill:#5a3a1f,stroke:#f2bc6b,color:#fff6e8
//
//   subgraph inputs["Raw inputs / assumptions"]
//     direction TB
//     rgb["Scene-linear R / G / B"]:::raw
//     src_color["Source colorimetry\nprimaries + white + RGB->XYZ/LMS"]:::raw
//     abs_scale["Absolute scene scale\nscene-linear -> nits"]:::raw
//     local_bg["Adaptation drivers\nrolling average + local background"]:::raw
//     scene_range["Late image context\nluminance range / percentile span"]:::raw
//     retinal["Retinal context\npupil area + trolands"]:::raw
//     observer_basis["Observer basis assumptions\nStockman/CVRL LMS + lens/macula"]:::raw
//     display["Display/device context\nprimaries + white + peak + black + hull"]:::raw
//   end
//
//   subgraph pipeline["Observer pipeline"]
//     direction TB
//     src_to_lms["RGB -> receptor LMS"]:::func
//     abs_lms["Absolute cone-energy state\nL, M, S"]:::state
//     adapt_fn["Estimate adapted background reference"]:::func
//     adapt["Adapted background reference\nL0, M0, S0, optional Yf0"]:::state
//     cone_contrast_fn["Form per-cone background-relative signal"]:::func
//     cone_contrast["Per-cone contrast state\nDeltaL/(Lb+L0), DeltaM/(Mb+M0), DeltaS/(Sb+S0)"]:::state
//     bleach_fn["Apply per-cone bleaching availability"]:::func
//     bleach["Bleaching availability state"]:::state
//     cone_nl_fn["Apply per-cone Naka-Rushton"]:::func
//     cone_nl["Per-cone nonlinear response"]:::state
//     noise_fn["Apply dim cone-noise threshold"]:::func
//     noise_floor["Visibility-limited cone response"]:::state
//     weighted_basis_fn["Optional weighted LMS / Yf / MB transform"]:::func
//     weighted_basis["Observer-summary basis state"]:::state
//     opponent_fn["Recombine to opponent / achromatic channels"]:::func
//     opponent["Opponent / achromatic response"]:::state
//     onoff_fn["Split ON / OFF pathways"]:::func
//     onoff["ON / OFF responses"]:::state
//     late_gain_fn["Apply late polarity / range gain"]:::func
//     late_gain["Late polarity / range-gated response"]:::state
//     pool_fn["Apply pooling / divisive normalization"]:::func
//     pooled["Pooled / normalized response"]:::state
//     observer_out["Observer-domain response"]:::state
//   end
//
//   subgraph device_map["Device-hull mapping"]
//     direction TB
//     hue_obj_fn["Optional hue objective\nMB / ACC / mu_eq"]:::func
//     hue_obj["Hue-preserving objective state"]:::state
//     hull_fn["Solve device-hull tone + gamut mapping"]:::func
//     hull["Display-hull output"]:::out
//   end
// ```
//
// Current implementation status:
// - This file currently implements the stage-3 to stage-6 scaffold plus a
//   first-pass receptor front end:
//   absolute Stockman LMS -> explicit adapted background reference input ->
//   per-cone bleaching availability -> local receptor Naka-Rushton ->
//   cone-contrast coding -> weighted-LMS ACC placeholder.
// - The full planned early-cone model is still incomplete:
//   rolling scene / local surround adaptation plumbing and dim-light noise
//   thresholding are not wired into test14 yet.
// - The device-hull tonemapping stage is also not wired into test14 yet.
// - The intended receptor basis should be read as an average-observer, mainly
//   foveal Stockman / CVRL basis with prereceptoral lens and macular filtering
//   already folded into the standard functions, not a personalized observer
//   model with explicit lens / macular / eccentricity variation.
// - The adapted background is now an explicit input with a default
//   diffuse-gray proxy, but the caller still needs to supply a real rolling
//   scene / local surround estimate before this can count as a complete
//   adaptation model.
// - The scalar defaults below are unit-normalized test settings and are not
//   yet fitted to a specific physiology dataset.
// - The optional Abney / equivalent-Gaussian hue stage is not implemented yet;
//   if used later, it should be bounded because the Gaussian account works best
//   at short and medium wavelengths and breaks down toward yellow / red.
//
// Secondary seminar notes (useful framing, not primary citation):
// - "Bright lights ... bleach the cones" and make them less sensitive, with
//   slow recovery. This supports the placement of bleaching in the observer
//   model before device mapping.
// - "Gamut ... is the technical container." This supports treating tonemapping
//   as a device-hull problem distinct from the eye model.
// - Diffuse white and peak luminance were discussed separately, which supports
//   keeping display white / diffuse white as explicit anchors in the hull solve.
// Source: "Mythbusting: Colour, Camera, Cinema" (Colorist Society,
// Camerimage 2024 panel with Andrew Stockman / Charles Poynton / Dirk Meier),
// YouTube transcript dated January 13, 2025.
// Ordered summary:
//   scene RGB
//   -> absolute Stockman LMS (chapter 10 receptor basis)
//   -> early cone adaptation (chapter 11 first-site background L0/M0/S0/Yf0)
//   -> high-light bleaching
//   -> opponent drive
//   -> saturating response / ON-OFF / pooled gain
//   -> observer-domain result
//   -> device-hull mapping

float3 psychov_17(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float purity_scale = 1.f,
    float bleaching_intensity = 1.f,
    float clip_point = 100.f,
    float hue_restore = 1.f,
    float adaptation_contrast = 1.f,
    int white_curve_mode = 0,
    float cone_response_exponent = 1.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float gamut_compression = 1.f,
    int gamut_compression_mode = 1,
    float adaptive_normalization = 1.f) {
  float3 bt709_scene = bt709_linear_input * exposure;

  float3 lms_in = psycho17_BT709ToLMS(bt709_scene);
  float3 lms_peak = psycho17_BT709ToLMS(float(peak_value).xxx);
  float3 current_adaptive_state_lms = psycho17_BT709ToLMS(current_adaptive_state_bt709);
  float3 desired_background_state_lms = psycho17_BT709ToLMS(current_background_state_bt709);
  float3 lms_working = lms_in;
  if (true) {
    // noop
  } else if (gamut_compression == 0) {
    lms_working = psycho17_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        psycho17_LMS_TO_LMS_WEIGHTED_MAT,
        1.f);
  } else if (gamut_compression_mode == 0) {
    lms_working = psycho17_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        psycho17_BT709_TO_LMS_WEIGHTED_MAT,
        1.f);
  } else {
    lms_working = psycho17_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        psycho17_BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }

  float yf_input = psycho17_YFFromLMS(lms_working);
  float yf_midgray = psycho17_YFFromBT709(0.18f.xxx);
  float yf_target = yf_input;

  // Stage 1: apply UI highlight/shadow/contrast controls in luminosity space.
  if (highlights != 1.f) {
    yf_target = psycho17_Highlights(yf_target, highlights, yf_midgray);
  }
  if (shadows != 1.f) {
    yf_target = psycho17_Shadows(yf_target, shadows, yf_midgray);
  }
  if (contrast != 1.f) {
    yf_target = psycho17_ContrastSafe(yf_target, contrast, yf_midgray);
  }

  float yf_scale = psycho17_DivideSafe(yf_target, yf_input, 1.f);

  float3 lms_graded = lms_working * yf_scale;
  if (purity_scale != 1.f) {
    float3 lms_graded_relative = psycho17_ToAdaptiveRelativeLMS(
        lms_graded,
        current_adaptive_state_lms);
    float3 mb = psycho17_MacleodBoyntonFromLMS(lms_graded_relative);
    float2 mb_white = psycho17_MacleodBoyntonFromLMS(1.f.xxx).xy;
    float2 mb_scaled = lerp(mb_white, mb.xy, purity_scale);
    lms_graded = psycho17_FromAdaptiveRelativeLMS(
        psycho17_LMSFromMacleodBoynton(float3(mb_scaled, mb.z)),
        current_adaptive_state_lms);
  }

  float3 lms_cones = lms_graded;

  if (bleaching_intensity != 0.f) {
    float3 stimulus_trolands = max(current_adaptive_state_lms, 0.f) * 203.f * 4.f;
    float3 availability = 1.f.xxx / (1.f.xxx + stimulus_trolands / 20000.f);
    availability = lerp(1.f.xxx, availability, bleaching_intensity);

    float y = lms_cones.x + lms_cones.y;
    float white_y = current_adaptive_state_lms.x + current_adaptive_state_lms.y;
    float3 white_at_y = current_adaptive_state_lms * (y / white_y);
    float3 delta = (lms_cones - white_at_y) * availability;
    lms_cones = white_at_y + delta;
  }

  // Naka-Rushton is scale-equivariant if input, peak, and anchors are all
  // normalized by the same adaptive LMS state, so keep the absolute-LMS form.
  float3 display_scaled = psycho17_NakaRushton(
      lms_cones,
      lms_peak,
      current_adaptive_state_lms,
      desired_background_state_lms,
      cone_response_exponent);
  float3 display_scaled_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(
      display_scaled,
      current_adaptive_state_lms);

  if (hue_restore > 0.f) {
    float3 lms_cones_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(
        lms_cones,
        current_adaptive_state_lms);
    float3 mb_source =
        psycho17_MacleodBoyntonFromWeightedLMS(lms_cones_relative_weighted);
    float3 mb_display_target =
        psycho17_MacleodBoyntonFromWeightedLMS(display_scaled_relative_weighted);
    float3 mb_adapted_bg = psycho17_MacleodBoyntonFromLMS(1.f.xxx);

    float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
    float2 display_target_offset = mb_display_target.xy - mb_adapted_bg.xy;
    float src2 = dot(source_offset, source_offset);
    float display_tgt2 = dot(display_target_offset, display_target_offset);
    if (src2 > 1e-7 && display_tgt2 > 1e-7) {
      float inv_target_radius = rsqrt(display_tgt2);
      float target_radius = display_tgt2 * inv_target_radius;
      float source_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, source_offset);
      float display_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, display_target_offset);
      // Scale hue restoration by purity loss relative to the adapted neutral anchor.
      float source_purity_signal = psycho17_HueRelativePuritySignalFromTClip(source_t_clip);
      float display_purity_signal = psycho17_HueRelativePuritySignalFromTClip(display_t_clip);
      float purity_signal_loss = saturate(display_purity_signal / source_purity_signal);
      float hue_sensitivity = psycho17_AdaptiveHueSensitivityFromTClip(display_t_clip);
      float restore_weight = hue_sensitivity * hue_restore * purity_signal_loss;
      if (restore_weight > 0.f) {
        float inv_source_radius = rsqrt(src2);
        float2 source_dir = source_offset * inv_source_radius;
        float2 display_target_dir = display_target_offset * inv_target_radius;
        float2 blended_dir = lerp(display_target_dir, source_dir, restore_weight);
        float blended_len2 = dot(blended_dir, blended_dir);
        if (blended_len2 > 1e-7) {
          blended_dir *= rsqrt(blended_len2);
        } else {
          blended_dir = display_target_dir;
        }

        // Keep display-scaled chroma radius and y_MB; only replace hue direction.
        float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
        float3 mb_restored = float3(mb_restored_xy, mb_display_target.z);
        display_scaled_relative_weighted =
            psycho17_WeightedLMSFromMacleodBoynton(mb_restored);
      }
    }
  }

  if (gamut_compression != 0.f) {
    if (gamut_compression_mode == 0) {
      display_scaled_relative_weighted = psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          psycho17_BT709_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    } else if (gamut_compression_mode == 1) {
      display_scaled_relative_weighted = psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          psycho17_BT2020_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    }
  }

  // Scale back from first-site adaptation;
  return psycho17_LMSToBT709(
      psycho17_UnweighLMS(
          psycho17_FromAdaptiveRelativeWeightedLMS(
              display_scaled_relative_weighted,
              current_adaptive_state_lms)));
}

float3 SDR(float3 bt709_input, float cone_response = 1.0f) {
  return psychov_17(
      bt709_input,    // BT709 input
      1.f,            // SDR peak
      1.f,            // Exposure
      1.f,            // Highlights
      1.f,            // Shadows
      1.f,            // Contrast
      1.f,            // Purity scale
      1.f,            // Bleaching intensity
      100.f,          // Clip point
      1.f,            // Hue restore
      1.f,            // Adaptation contrast
      0,              // White curve mode
      cone_response,  // Cone response exponent
      0.18f,          // Current adaptive state BT709
      0.18f,          // Current background state BT709
      1.f,            // Gamut compression
      0);             // BT709 gamut compression mode
}

float3 HDR(float3 bt709_input, float peak = 1000.f / 203.f, float cone_response = 1.0f) {
  return psychov_17(
      bt709_input,     // BT709 input
      peak,            // HDR peak relative to SDR white
      1.f,             // Exposure
      1.f,             // Highlights
      1.f,             // Shadows
      1.f,             // Contrast
      1.f,             // Purity scale
      1.f,             // Bleaching intensity
      100.f,           // Clip point
      1.f,             // Hue restore
      1.f,             // Adaptation contrast
      0,               // White curve mode
      cone_response);  // Cone response exponent
}

}  // namespace psycho
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_PSYCHOV_17_HLSL_
