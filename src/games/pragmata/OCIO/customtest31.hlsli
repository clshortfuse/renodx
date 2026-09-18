#ifndef PSYCHOV_CUSTOMTEST31_HLSLI_
#define PSYCHOV_CUSTOMTEST31_HLSLI_

#include "../common.hlsli"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx {
namespace tonemap {
namespace psychov {

// Test29 constants and functions required by the unmodified Test31 source.
static const float PSYCHO29_EPSILON = 1e-6f;
static const float PSYCHO29_EPSILON2 = PSYCHO29_EPSILON * PSYCHO29_EPSILON;
static const float PSYCHO29_LARGE_SUPPORT = 1e20f;
static const int PSYCHO29_NEUTWO_SUPPORT_SCAN_STEPS = 32;
static const int PSYCHO29_NEUTWO_SUPPORT_REFINE_STEPS = 20;
static const int PSYCHO29_DYNAMIC_Q_REFINE_STEPS = 12;
static const float PSYCHO29_MIN_SUPPORT_Q = 2.f;
static const float PSYCHO29_INFINITY_SUPPORT_Q = 2048.f;
static const float PSYCHO29_MAX_SUPPORT_Q = PSYCHO29_INFINITY_SUPPORT_Q;

static const float3x3 PSYCHO29_BT709_TO_LMS_MAT = mul(
    renodx::color::macleod_boynton::XYZ_TO_LMS_MAT,
    renodx::color::BT709_TO_XYZ_MAT);
static const float3x3 PSYCHO29_LMS_TO_BT709_MAT = mul(
    renodx::color::XYZ_TO_BT709_MAT,
    renodx::color::macleod_boynton::LMS_TO_XYZ_MAT);
static const float3x3 PSYCHO29_BT2020_TO_LMS_MAT = mul(
    renodx::color::macleod_boynton::XYZ_TO_LMS_MAT,
    renodx::color::BT2020_TO_XYZ_MAT);
static const float3x3 PSYCHO29_LMS_TO_BT2020_MAT = mul(
    renodx::color::XYZ_TO_BT2020_MAT,
    renodx::color::macleod_boynton::LMS_TO_XYZ_MAT);

float psycho29_YfFromLMS(float3 lms) {
  return mad(
      lms.x,
      renodx::color::macleod_boynton::LMS_WEIGHTS.x,
      lms.y * renodx::color::macleod_boynton::LMS_WEIGHTS.y);
}

float3 psycho29_LMSFromNormalizedPsychoCoord(
    float3 coord,
    float3 peak_lms) {
  float3 safe_peak_lms = max(
      abs(peak_lms),
      float3(PSYCHO29_EPSILON, PSYCHO29_EPSILON, PSYCHO29_EPSILON));
  float peak_yf = max(
      psycho29_YfFromLMS(safe_peak_lms),
      PSYCHO29_EPSILON);
  float alpha_l = renodx::color::macleod_boynton::LMS_WEIGHTS.x
                  * safe_peak_lms.x / peak_yf;
  float alpha_m = renodx::color::macleod_boynton::LMS_WEIGHTS.y
                  * safe_peak_lms.y / peak_yf;
  float alpha_sum = max(alpha_l + alpha_m, PSYCHO29_EPSILON);
  alpha_l /= alpha_sum;
  alpha_m /= alpha_sum;

  float difference = sqrt(2.f) * coord.x;
  float u_m = coord.y - alpha_l * difference;
  float u_l = coord.y + alpha_m * difference;
  float u_s = 0.5f * (sqrt(6.f) * coord.z + u_l + u_m);
  return float3(u_l, u_m, u_s) * safe_peak_lms;
}

float3 psycho29_OrthonormalConeCoordFromLMS(
    float3 lms,
    float3 peak_lms) {
  float3 u = lms / max(abs(peak_lms), float3(PSYCHO29_EPSILON, PSYCHO29_EPSILON, PSYCHO29_EPSILON));
  return float3(
      (u.x - u.y) * rsqrt(2.f),
      (u.x + u.y + u.z) * rsqrt(3.f),
      (2.f * u.z - u.x - u.y) * rsqrt(6.f));
}

float3 psycho29_LMSFromOrthonormalConeCoord(
    float3 coord,
    float3 peak_lms) {
  float common = coord.y * rsqrt(3.f);
  float x_term = coord.x * rsqrt(2.f);
  float z_term = coord.z * rsqrt(6.f);
  return float3(
             common + x_term - z_term,
             common - x_term - z_term,
             common + 2.f * z_term)
         * max(
             abs(peak_lms),
             float3(PSYCHO29_EPSILON, PSYCHO29_EPSILON, PSYCHO29_EPSILON));
}

float2 psycho29_OrthonormalYfCoefficients(
    float2 direction,
    float3 peak_lms) {
  float3 safe_peak = max(
      abs(peak_lms),
      float3(PSYCHO29_EPSILON, PSYCHO29_EPSILON, PSYCHO29_EPSILON));
  float peak_yf = max(
      psycho29_YfFromLMS(safe_peak),
      PSYCHO29_EPSILON);
  float alpha_l = renodx::color::macleod_boynton::LMS_WEIGHTS.x
                  * safe_peak.x / peak_yf;
  float alpha_m = renodx::color::macleod_boynton::LMS_WEIGHTS.y
                  * safe_peak.y / peak_yf;
  float alpha_sum = max(alpha_l + alpha_m, PSYCHO29_EPSILON);
  alpha_l /= alpha_sum;
  alpha_m /= alpha_sum;
  return float2(
      rsqrt(3.f),
      (alpha_l - alpha_m) * direction.x * rsqrt(2.f)
          - direction.y * rsqrt(6.f));
}

void psycho29_TargetARCoefficients(
    float2 direction,
    float3 peak_lms,
    float3x3 lms_to_target,
    float target_rgb_peak,
    out float3 a_rgb,
    out float3 rho_rgb) {
  a_rgb = mul(
              lms_to_target,
              psycho29_LMSFromNormalizedPsychoCoord(
                  float3(0.f, 1.f, 0.f),
                  peak_lms))
          / max(target_rgb_peak, PSYCHO29_EPSILON);
  rho_rgb = mul(
                lms_to_target,
                psycho29_LMSFromNormalizedPsychoCoord(
                    float3(direction.x, 0.f, direction.y),
                    peak_lms))
            / max(target_rgb_peak, PSYCHO29_EPSILON);
}

void psycho29_NeutwoSupportScales(
    float2 direction,
    float3 peak_lms,
    float3x3 lms_to_target,
    float target_rgb_peak,
    out float k_black,
    out float k_white,
    out uint valid) {
  float3 a_rgb;
  float3 rho_rgb;
  psycho29_TargetARCoefficients(
      direction,
      peak_lms,
      lms_to_target,
      target_rgb_peak,
      a_rgb,
      rho_rgb);
  float3 smooth_abs = sqrt(
      rho_rgb * rho_rgb
      + float3(
          PSYCHO29_EPSILON2,
          PSYCHO29_EPSILON2,
          PSYCHO29_EPSILON2));
  k_white = rcp(max(
      length(0.5f * (smooth_abs + rho_rgb)),
      PSYCHO29_EPSILON));
  k_black = rcp(max(
      length(0.5f * (smooth_abs - rho_rgb)),
      PSYCHO29_EPSILON));
  valid = !any(isnan(a_rgb))
                  && !any(isinf(a_rgb))
                  && !any(isnan(rho_rgb))
                  && !any(isinf(rho_rgb))
                  && k_black > 0.f
                  && k_white > 0.f
                  && !isnan(k_black)
                  && !isinf(k_black)
                  && !isnan(k_white)
                  && !isinf(k_white)
              ? 1u
              : 0u;
}

float psycho29_LqNorm(float3 values, float q) {
  float scale = max(max(values.x, values.y), values.z);
  if (!(scale > 0.f)) return 0.f;
  if (q >= PSYCHO29_INFINITY_SUPPORT_Q) return scale;
  float3 normalized = values / scale;
  float3 powers = pow(normalized, float3(q, q, q));
  return scale * pow(max(powers.x + powers.y + powers.z, PSYCHO29_EPSILON), rcp(q));
}

float psycho29_FaceSupportRatio(
    float normalized_yf,
    float3 black_pressure,
    float3 white_pressure,
    float q) {
  float3 terms_black = black_pressure
                       / max(normalized_yf, PSYCHO29_EPSILON);
  float3 terms_white = white_pressure
                       / max(1.f - normalized_yf, PSYCHO29_EPSILON);
  float scale = max(
      max(max(terms_black.x, terms_black.y), terms_black.z),
      max(max(terms_white.x, terms_white.y), terms_white.z));
  if (!(scale > 0.f)) return 1.f;
  if (q >= PSYCHO29_INFINITY_SUPPORT_Q) return 1.f;
  float3 powers_black = pow(terms_black / scale, float3(q, q, q));
  float3 powers_white = pow(terms_white / scale, float3(q, q, q));
  return pow(
      max(
          powers_black.x + powers_black.y + powers_black.z
              + powers_white.x + powers_white.y + powers_white.z,
          PSYCHO29_EPSILON),
      -rcp(q));
}

float psycho29_PerHueSupportQ(
    float3 black_pressure,
    float3 white_pressure,
    float face_gap) {
  float target_ratio = 1.f - clamp(face_gap, 0.0001f, 0.5f);
  float required_q = PSYCHO29_MIN_SUPPORT_Q;
  [unroll]
  for (int candidate_index = 0; candidate_index < 10; ++candidate_index) {
    float normalized_yf = 0.5f;
    if (candidate_index > 0) {
      int crossing_index = candidate_index - 1;
      float black = black_pressure[crossing_index / 3];
      float white = white_pressure[crossing_index % 3];
      float denominator = black + white;
      if (!(denominator > PSYCHO29_EPSILON)) continue;
      normalized_yf = black / denominator;
    }
    if (!(normalized_yf > 0.f && normalized_yf < 1.f)
        || psycho29_FaceSupportRatio(
               normalized_yf,
               black_pressure,
               white_pressure,
               PSYCHO29_MIN_SUPPORT_Q)
               >= target_ratio) {
      continue;
    }

    float lo = PSYCHO29_MIN_SUPPORT_Q;
    float hi = PSYCHO29_MAX_SUPPORT_Q;
    if (psycho29_FaceSupportRatio(
            normalized_yf,
            black_pressure,
            white_pressure,
            hi)
        < target_ratio) {
      required_q = hi;
      continue;
    }
    [unroll]
    for (int i = 0; i < PSYCHO29_DYNAMIC_Q_REFINE_STEPS; ++i) {
      float mid = 0.5f * (lo + hi);
      if (psycho29_FaceSupportRatio(
              normalized_yf,
              black_pressure,
              white_pressure,
              mid)
          >= target_ratio) {
        hi = mid;
      } else {
        lo = mid;
      }
    }
    required_q = max(required_q, hi);
  }
  return required_q;
}

void psycho29_LqSupportScales(
    float2 direction,
    float3 peak_lms,
    float3x3 lms_to_target,
    float target_rgb_peak,
    float fixed_q,
    float dynamic_face_gap,
    float dynamic_mix,
    float generalized_mix,
    out float q,
    out float k_black,
    out float k_white,
    out uint valid) {
  float dynamic_weight = saturate(dynamic_mix);
  float generalized_weight = saturate(generalized_mix);
  q = lerp(
      PSYCHO29_MIN_SUPPORT_Q,
      clamp(fixed_q, PSYCHO29_MIN_SUPPORT_Q, PSYCHO29_MAX_SUPPORT_Q),
      generalized_weight);
  if (generalized_weight <= 0.f) {
    psycho29_NeutwoSupportScales(
        direction,
        peak_lms,
        lms_to_target,
        target_rgb_peak,
        k_black,
        k_white,
        valid);
    return;
  }

  float3 a_rgb;
  float3 rho_rgb;
  psycho29_TargetARCoefficients(
      direction,
      peak_lms,
      lms_to_target,
      target_rgb_peak,
      a_rgb,
      rho_rgb);
  float3 smooth_abs = sqrt(
      rho_rgb * rho_rgb
      + float3(
          PSYCHO29_EPSILON2,
          PSYCHO29_EPSILON2,
          PSYCHO29_EPSILON2));
  float3 white_pressure = max(
      0.5f * (smooth_abs + rho_rgb),
      float3(0.f, 0.f, 0.f));
  float3 black_pressure = max(
      0.5f * (smooth_abs - rho_rgb),
      float3(0.f, 0.f, 0.f));
  if (dynamic_weight > 0.f) {
    q = lerp(
        q,
        lerp(
            PSYCHO29_MIN_SUPPORT_Q,
            psycho29_PerHueSupportQ(
                black_pressure,
                white_pressure,
                dynamic_face_gap),
            generalized_weight),
        dynamic_weight);
  }
  if (q >= PSYCHO29_INFINITY_SUPPORT_Q) {
    white_pressure = max(rho_rgb, float3(0.f, 0.f, 0.f));
    black_pressure = max(-rho_rgb, float3(0.f, 0.f, 0.f));
  }
  k_white = rcp(max(
      psycho29_LqNorm(white_pressure, q),
      PSYCHO29_EPSILON));
  k_black = rcp(max(
      psycho29_LqNorm(black_pressure, q),
      PSYCHO29_EPSILON));
  valid = !any(isnan(a_rgb))
                  && !any(isinf(a_rgb))
                  && !any(isnan(rho_rgb))
                  && !any(isinf(rho_rgb))
                  && q >= PSYCHO29_MIN_SUPPORT_Q
                  && !isnan(q)
                  && !isinf(q)
                  && k_black > 0.f
                  && k_white > 0.f
                  && !isnan(k_black)
                  && !isinf(k_black)
                  && !isnan(k_white)
                  && !isinf(k_white)
              ? 1u
              : 0u;
}

float psycho29_LqSupportRadius(
    float normalized_yf,
    float k_black,
    float k_white,
    float q) {
  float black_support = k_black * saturate(normalized_yf);
  float white_support = k_white * (1.f - saturate(normalized_yf));
  if (!(black_support > 0.f) || !(white_support > 0.f)) return 0.f;
  if (q >= PSYCHO29_INFINITY_SUPPORT_Q) {
    return min(black_support, white_support);
  }
  if (abs(q - 2.f) <= PSYCHO29_EPSILON) {
    return renodx::tonemap::Neutwo(black_support, white_support);
  }
  float inverse_black = rcp(black_support);
  float inverse_white = rcp(white_support);
  float scale = max(inverse_black, inverse_white);
  float sum = pow(inverse_black / scale, q)
              + pow(inverse_white / scale, q);
  return rcp(scale * pow(max(sum, PSYCHO29_EPSILON), rcp(q)));
}

float psycho29_EvaluateYfCandidate(
    float candidate_yf,
    float desired_c0,
    float desired_rho,
    float2 yf_coefficients,
    float k_black,
    float k_white,
    float q,
    out float candidate_c0,
    out float candidate_rho) {
  float A = saturate(candidate_yf);
  float max_rho = psycho29_LqSupportRadius(A, k_black, k_white, q);
  float safe_axis = renodx::math::CopySign(
      max(abs(yf_coefficients.x), PSYCHO29_EPSILON),
      yf_coefficients.x);
  float inverse_axis = rcp(safe_axis);
  float k = yf_coefficients.y * inverse_axis;
  float offset = A * inverse_axis - desired_c0;
  candidate_rho = clamp(
      (k * offset + desired_rho) / (k * k + 1.f),
      0.f,
      max_rho);
  candidate_c0 = (A - yf_coefficients.y * candidate_rho) * inverse_axis;
  float delta_c0 = candidate_c0 - desired_c0;
  float delta_rho = candidate_rho - desired_rho;
  return delta_c0 * delta_c0 + delta_rho * delta_rho;
}

float3 psycho29_LqYfCeilingSolve(
    float3 desired_coord,
    float response_yf,
    float3 peak_lms,
    float3x3 lms_to_target,
    float target_rgb_peak,
    float fixed_q,
    float dynamic_face_gap,
    float dynamic_mix,
    float generalized_mix,
    out uint valid) {
  valid = !any(isnan(desired_coord))
                  && !any(isinf(desired_coord))
                  && !isnan(response_yf)
                  && !isinf(response_yf)
              ? 1u
              : 0u;
  if (valid == 0u) return float3(0.f, 0.f, 0.f);

  float desired_rho2 = dot(desired_coord.xz, desired_coord.xz);
  float desired_rho = sqrt(max(desired_rho2, 0.f));
  float2 direction = desired_rho2 > PSYCHO29_EPSILON2
                         ? desired_coord.xz * rsqrt(desired_rho2)
                         : float2(1.f, 0.f);
  float2 yf_coefficients = psycho29_OrthonormalYfCoefficients(
      direction,
      peak_lms);
  float k_black;
  float k_white;
  float q;
  uint support_valid;
  psycho29_LqSupportScales(
      direction,
      peak_lms,
      lms_to_target,
      target_rgb_peak,
      fixed_q,
      dynamic_face_gap,
      dynamic_mix,
      generalized_mix,
      q,
      k_black,
      k_white,
      support_valid);
  if (support_valid == 0u) {
    valid = 0u;
    return float3(0.f, 0.f, 0.f);
  }

  float max_a = saturate(response_yf);
  float best_cost = 3.402823466e+38f;
  float best_c0 = 0.f;
  float best_rho = 0.f;
  int best_index = 0;
  [loop]
  for (int i = 0; i <= PSYCHO29_NEUTWO_SUPPORT_SCAN_STEPS; ++i) {
    float candidate_c0;
    float candidate_rho;
    float cost = psycho29_EvaluateYfCandidate(
        max_a * ((float)i / (float)PSYCHO29_NEUTWO_SUPPORT_SCAN_STEPS),
        desired_coord.y,
        desired_rho,
        yf_coefficients,
        k_black,
        k_white,
        q,
        candidate_c0,
        candidate_rho);
    if (cost < best_cost) {
      best_cost = cost;
      best_c0 = candidate_c0;
      best_rho = candidate_rho;
      best_index = i;
    }
  }

  static const float GOLDEN = 0.6180339887498948f;
  float lo = max_a
             * ((float)max(best_index - 1, 0)
                / (float)PSYCHO29_NEUTWO_SUPPORT_SCAN_STEPS);
  float hi = max_a
             * ((float)min(best_index + 1, PSYCHO29_NEUTWO_SUPPORT_SCAN_STEPS)
                / (float)PSYCHO29_NEUTWO_SUPPORT_SCAN_STEPS);
  float x1 = hi - GOLDEN * (hi - lo);
  float x2 = lo + GOLDEN * (hi - lo);
  float c01;
  float rho1;
  float f1 = psycho29_EvaluateYfCandidate(
      x1,
      desired_coord.y,
      desired_rho,
      yf_coefficients,
      k_black,
      k_white,
      q,
      c01,
      rho1);
  float c02;
  float rho2;
  float f2 = psycho29_EvaluateYfCandidate(
      x2,
      desired_coord.y,
      desired_rho,
      yf_coefficients,
      k_black,
      k_white,
      q,
      c02,
      rho2);

  [unroll]
  for (int iteration = 0;
       iteration < PSYCHO29_NEUTWO_SUPPORT_REFINE_STEPS;
       ++iteration) {
    if (f1 > f2) {
      lo = x1;
      x1 = x2;
      f1 = f2;
      c01 = c02;
      rho1 = rho2;
      x2 = lo + GOLDEN * (hi - lo);
      f2 = psycho29_EvaluateYfCandidate(
          x2,
          desired_coord.y,
          desired_rho,
          yf_coefficients,
          k_black,
          k_white,
          q,
          c02,
          rho2);
    } else {
      hi = x2;
      x2 = x1;
      f2 = f1;
      c02 = c01;
      rho2 = rho1;
      x1 = hi - GOLDEN * (hi - lo);
      f1 = psycho29_EvaluateYfCandidate(
          x1,
          desired_coord.y,
          desired_rho,
          yf_coefficients,
          k_black,
          k_white,
          q,
          c01,
          rho1);
    }
  }

  if (f1 < f2) {
    best_c0 = c01;
    best_rho = rho1;
  } else {
    best_c0 = c02;
    best_rho = rho2;
  }
  float3 solved_coord = float3(
      direction.x * max(best_rho, 0.f),
      best_c0,
      direction.y * max(best_rho, 0.f));
  valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
  return valid != 0u ? solved_coord : float3(0.f, 0.f, 0.f);
}

float3 psycho31_LMSFromTest30Coord(
    float3 coord,
    float peak_value) {
  float normalized_a = (2.f * coord.y
                        + 3.f * PSYCHO30_D65_ALPHA_DELTA * coord.x
                        - coord.z)
                       / 6.f;
  float3 bt709 = peak_value
                 * (normalized_a
                    + coord.x * PSYCHO30_BT709_D_RGB
                    + coord.z * PSYCHO30_BT709_T_RGB);
  return mul(PSYCHO30_BT709_TO_LMS_MAT, bt709);
}

float psycho31_YfFromTest30Coord(float3 coord) {
  return (2.f * coord.y
          + 3.f * PSYCHO30_D65_ALPHA_DELTA * coord.x
          - coord.z)
         / 6.f;
}

float3 psycho31_Test30CoordFromDTA(float d, float t, float a) {
  return float3(
      d,
      3.f * a - 1.5f * PSYCHO30_D65_ALPHA_DELTA * d + 0.5f * t,
      t);
}

float3 psycho31_ResponseInputQ(
    float3 source_lms,
    float3 anchor_lms,
    float highlights,
    float shadows,
    float purity_delta) {
  float3 graded_lms;
  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    graded_lms = abs(source_lms);
    float graded_yf = renodx::color::yf::from::LMS(graded_lms);
    float adapted_anchor_yf = renodx::color::yf::from::LMS(anchor_lms);
    float graded_yf_out = psycho30_HighlightsScalar(
        graded_yf,
        highlights,
        adapted_anchor_yf);
    graded_yf_out = psycho30_ShadowsScalar(
        graded_yf_out,
        shadows,
        adapted_anchor_yf);
    graded_lms *= graded_yf_out / graded_yf;
    graded_lms = renodx::math::CopySign(graded_lms, source_lms);
  } else {
    graded_lms = source_lms;
  }
  return psycho30_ApplyAdaptiveRelativePurity(
      graded_lms,
      anchor_lms,
      purity_delta);
}

float3 psycho31_FixedYfL4TargetEndpoint(
    float3 coord,
    float response_yf_ceiling,
    int target_gamut_mode,
    out float normalized_demand) {
  normalized_demand = 0.f;
  float mapped_a = clamp(
      psycho31_YfFromTest30Coord(coord),
      0.f,
      clamp(response_yf_ceiling, 0.f, 1.f));
  float radial_length = sqrt(
      0.5f * coord.x * coord.x
      + coord.z * coord.z / 6.f);
  if (mapped_a <= 0.f
      || mapped_a >= 1.f
      || radial_length <= PSYCHO30_EPSILON) {
    return psycho31_Test30CoordFromDTA(0.f, 0.f, mapped_a);
  }

  float inverse_radial_length = rcp(radial_length);
  float normalized_d = coord.x * inverse_radial_length;
  float normalized_t = coord.z * inverse_radial_length;
  float3 radial_rgb;
  [branch]
  if (target_gamut_mode == 0) {
    radial_rgb = normalized_d * PSYCHO30_BT709_D_RGB
                 + normalized_t * PSYCHO30_BT709_T_RGB;
  } else {
    radial_rgb = normalized_d * PSYCHO30_BT2020_D_RGB
                 + normalized_t * PSYCHO30_BT2020_T_RGB;
  }
  float3 upper_demand = max(radial_rgb, 0.f) / (1.f - mapped_a);
  float3 lower_demand = max(-radial_rgb, 0.f) / mapped_a;
  float demand_scale = max(
      renodx::math::Max(upper_demand),
      renodx::math::Max(lower_demand));
  if (demand_scale <= PSYCHO30_EPSILON) {
    return psycho31_Test30CoordFromDTA(0.f, 0.f, mapped_a);
  }
  float3 normalized_upper = upper_demand / demand_scale;
  float3 normalized_lower = lower_demand / demand_scale;
  float fourth_power_sum = dot(
                               normalized_upper * normalized_upper,
                               normalized_upper * normalized_upper)
                           + dot(
                               normalized_lower * normalized_lower,
                               normalized_lower * normalized_lower);
  float support = rcp(demand_scale * sqrt(sqrt(fourth_power_sum)));
  normalized_demand = radial_length / support;
  float mapped_radius = min(radial_length, support);
  return psycho31_Test30CoordFromDTA(
      normalized_d * mapped_radius,
      normalized_t * mapped_radius,
      mapped_a);
}

float3 psycho31_JointL4TargetEndpoint(
    float3 coord,
    float response_yf_ceiling,
    int target_gamut_mode,
    float target_rgb_peak,
    out uint valid) {
  float3x3 target_to_lms = target_gamut_mode == 0
                               ? PSYCHO29_BT709_TO_LMS_MAT
                               : PSYCHO29_BT2020_TO_LMS_MAT;
  float3x3 lms_to_target = target_gamut_mode == 0
                               ? PSYCHO29_LMS_TO_BT709_MAT
                               : PSYCHO29_LMS_TO_BT2020_MAT;
  float3 target_peak_lms = mul(
      target_to_lms,
      float3(target_rgb_peak, target_rgb_peak, target_rgb_peak));
  float3 desired_ortho = psycho29_OrthonormalConeCoordFromLMS(
      psycho31_LMSFromTest30Coord(coord, target_rgb_peak),
      target_peak_lms);
  float3 solved_ortho = psycho29_LqYfCeilingSolve(
      desired_ortho,
      response_yf_ceiling,
      target_peak_lms,
      lms_to_target,
      target_rgb_peak,
      4.f,
      0.01f,
      0.f,
      1.f,
      valid);
  if (valid == 0u) return 0.f;

  float3 normalized_lms = psycho29_LMSFromOrthonormalConeCoord(
                              solved_ortho,
                              target_peak_lms)
                          / (PSYCHO30_D65_WHITE_LMS * target_rgb_peak);
  float3 solved_coord = float3(
      normalized_lms.x - normalized_lms.y,
      normalized_lms.x + normalized_lms.y + normalized_lms.z,
      2.f * normalized_lms.z - normalized_lms.x - normalized_lms.y);
  valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
  return valid != 0u ? solved_coord : 0.f;
}

float3 psycho31_SourceCoordinateCage(
    float3 desired_coord,
    float3 anchored_source_rgb,
    float3x3 source_to_lms,
    float3 anchor_in_lms,
    float3 adaptation_peak_ratio,
    float highlights,
    float shadows,
    float purity_delta,
    float response_power,
    float response_h,
    int target_gamut_mode,
    float target_rgb_peak,
    out uint valid) {
  valid = 0u;
  float3 source_yf_coefficients = mul(
      renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1],
      source_to_lms);
  float neutral_source_rgb = dot(
                                 source_yf_coefficients,
                                 anchored_source_rgb)
                             / dot(source_yf_coefficients, float3(1.f, 1.f, 1.f));
  if (neutral_source_rgb <= PSYCHO30_EPSILON) return 0.f;

  float3 source_residual = anchored_source_rgb - neutral_source_rgb;
  float3 lower_demand = max(
      -source_residual / neutral_source_rgb,
      0.f);
  float demand_scale = renodx::math::Max(lower_demand);
  if (demand_scale <= PSYCHO30_EPSILON) return 0.f;

  float boundary_fraction = rcp(demand_scale);
  if (boundary_fraction <= PSYCHO30_EPSILON
      || boundary_fraction >= PSYCHO30_LARGE_SUPPORT
      || isnan(boundary_fraction)
      || isinf(boundary_fraction)) {
    return 0.f;
  }

  float3 neutral_q = psycho31_ResponseInputQ(
      mul(
          source_to_lms,
          float3(
              neutral_source_rgb,
              neutral_source_rgb,
              neutral_source_rgb)),
      anchor_in_lms,
      highlights,
      shadows,
      purity_delta);
  float3 boundary_q = psycho31_ResponseInputQ(
      mul(
          source_to_lms,
          neutral_source_rgb + source_residual * boundary_fraction),
      anchor_in_lms,
      highlights,
      shadows,
      purity_delta);
  if (any(neutral_q <= 0.f) || any(boundary_q <= 0.f)) return 0.f;

  float neutral_response_yf;
  psycho30_MeanA2ResponseFromPositiveQ(
      neutral_q,
      adaptation_peak_ratio,
      response_power,
      response_h,
      neutral_response_yf);
  float boundary_response_yf;
  float3 source_boundary_coord = psycho30_MeanA2ResponseFromPositiveQ(
      boundary_q,
      adaptation_peak_ratio,
      response_power,
      response_h,
      boundary_response_yf);
  uint target_endpoint_valid;
  float3 target_endpoint_coord = psycho31_JointL4TargetEndpoint(
      source_boundary_coord,
      boundary_response_yf,
      target_gamut_mode,
      target_rgb_peak,
      target_endpoint_valid);
  if (target_endpoint_valid == 0u) return 0.f;

  float desired_a = psycho31_YfFromTest30Coord(desired_coord);
  float source_boundary_a = psycho31_YfFromTest30Coord(
      source_boundary_coord);
  float source_chord_a = source_boundary_a - neutral_response_yf;
  float source_chord_length2 =
      0.5f * source_boundary_coord.x * source_boundary_coord.x
      + source_boundary_coord.z * source_boundary_coord.z / 6.f
      + source_chord_a * source_chord_a;
  if (source_chord_length2 <= PSYCHO30_EPSILON2) return 0.f;
  float response_progress = saturate(
      (0.5f * desired_coord.x * source_boundary_coord.x
       + desired_coord.z * source_boundary_coord.z / 6.f
       + (desired_a - neutral_response_yf) * source_chord_a)
      / source_chord_length2);
  float mapped_d = response_progress * target_endpoint_coord.x;
  float mapped_t = response_progress * target_endpoint_coord.z;
  float mapped_a = lerp(
      neutral_response_yf,
      psycho31_YfFromTest30Coord(target_endpoint_coord),
      response_progress);
  float3 mapped_coord = psycho31_Test30CoordFromDTA(
      mapped_d,
      mapped_t,
      mapped_a);
  valid = !any(isnan(mapped_coord)) && !any(isinf(mapped_coord)) ? 1u : 0u;
  return valid != 0u ? mapped_coord : 0.f;
}

// CUSTOM FUNCTIONS, EVERYTHING ABOVE HERE IS UNCHANGED

static const int CUSTOM_PSYCHO31_TARGET_GAMUT_BT709 = 0;
static const int CUSTOM_PSYCHO31_TARGET_GAMUT_BT2020 = 1;
static const int CUSTOM_PSYCHO31_TARGET_GAMUT_DISPLAY_P3 = 3;

static const int CUSTOM_PSYCHO31_GAMUT_MAPPING_JOINT_L4 = 0;
static const int CUSTOM_PSYCHO31_GAMUT_MAPPING_FIXED_YF_L4 = 1;
static const int CUSTOM_PSYCHO31_GAMUT_MAPPING_KNEE_FIXED_YF_L4 = 2;
// L4 demand where the source-cage mix starts (1 = L4 boundary). Lower values
// can desaturate near-boundary colors sooner; higher values delay that change.
static const float CUSTOM_PSYCHO31_GAMUT_KNEE_START = 0.8f;
// L4 demand where the source-cage mix becomes full. Lower values compress
// extreme colors sooner; higher values preserve the generic mapping longer.
static const float CUSTOM_PSYCHO31_GAMUT_KNEE_END = 2.f;
// Sharpness of soft min(demand, 1). Lower values round farther inside the
// target and desaturate colors near its edge; higher values hug a harder edge.
static const float CUSTOM_PSYCHO31_SMOOTH_LIMIT_SHARPNESS = 36.f;
// Sharpness of the smooth source-plane max. Higher values sample farther out
// and can make very saturated boundary colors more desaturated after remapping.
static const float CUSTOM_PSYCHO31_SOURCE_MAX_SHARPNESS = 4.f;
// Radius of smooth max(demand, 0). Higher values soften source-face hue
// transitions more broadly but can alter near-boundary color; lower is tighter.
static const float CUSTOM_PSYCHO31_SOURCE_POSITIVE_EPSILON = 0.001f;
// Width of the smooth clamp near chord progress 0 and 1. Higher values make
// near-neutral colors neutral sooner and settle saturated colors onto the
// mapped endpoint sooner; lower values leave more of the chord linear.
static const float CUSTOM_PSYCHO31_PROGRESS_CLAMP_WIDTH = 0.05f;

static const float3x3 CUSTOM_PSYCHO31_LMS_TO_DISPLAY_P3_MAT = mul(
    renodx::color::XYZ_TO_DISPLAYP3_MAT,
    renodx::color::STOCKMAN_CVRL_LMS_TO_XYZ_2DEG_FIT);
static const float3 CUSTOM_PSYCHO31_DISPLAY_P3_D_RGB = mul(
    CUSTOM_PSYCHO31_LMS_TO_DISPLAY_P3_MAT,
    PSYCHO30_D_LMS);
static const float3 CUSTOM_PSYCHO31_DISPLAY_P3_T_RGB = mul(
    CUSTOM_PSYCHO31_LMS_TO_DISPLAY_P3_MAT,
    PSYCHO30_T_LMS);

float3 custom_psycho31_CInfinityTransition(float3 position) {
  position = saturate(position);
  return rcp(1.f + exp2((1.f - 2.f * position) / (position * (1.f - position))));
}

float custom_psycho31_CInfinityTransition(float position) {
  position = saturate(position);
  return rcp(1.f + exp2((1.f - 2.f * position) / (position * (1.f - position))));
}

float custom_psycho31_SmoothUnitLimit(float value) {
  const float sharpness = CUSTOM_PSYCHO31_SMOOTH_LIMIT_SHARPNESS;
  const float zero_offset = 1.f
                            - log2(1.f + exp2(sharpness)) / sharpness;
  float limited = 1.f
                  - log2(1.f + exp2(sharpness * (1.f - value)))
                        / sharpness;
  return (limited - zero_offset) / (1.f - zero_offset);
}

float custom_psycho31_CInfinityClamp01(float value) {
  const float width = CUSTOM_PSYCHO31_PROGRESS_CLAMP_WIDTH;
  float lower_weight = custom_psycho31_CInfinityTransition(
      value / width);
  float lower_clamped = value * lower_weight;
  float upper_weight = custom_psycho31_CInfinityTransition(
      (1.f - lower_clamped) / width);
  return 1.f - (1.f - lower_clamped) * upper_weight;
}

float custom_psycho31_SmoothMax3(float3 values) {
  const float sharpness = CUSTOM_PSYCHO31_SOURCE_MAX_SHARPNESS;
  return log2(
             exp2(sharpness * values.x)
             + exp2(sharpness * values.y)
             + exp2(sharpness * values.z))
         / sharpness;
}

float3 custom_psycho31_ApplyAnchoredTonalGrading(
    float3 color,
    float3 anchor_in,
    float3 anchor_out,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float highlights,
    float shadows) {
  [branch]
  if (contrast == 1.f && flare == 0.f
      && highlight_contrast == 1.f && shadow_contrast == 1.f
      && highlights == 1.f && shadows == 1.f
      && all(anchor_in == anchor_out)) {
    return color;
  }

  float3 normalized = color / anchor_in;
  float3 graded_normalized = normalized;
  [branch]
  if (contrast != 1.f || flare > 0.f) {
    float3 exponent = contrast;
    [branch]
    if (flare > 0.f) {
      float3 shadow_distance = saturate(1.f - normalized);
      float3 flat_shadow_weight = exp2(-normalized / shadow_distance);
      exponent *= mad(flat_shadow_weight, flare / (normalized + flare), 1.f);
    }

    float3 input_stops = log2(normalized);
    float3 highlight_stops = max(input_stops, 0.f);
    float3 output_highlight_stops = highlight_stops;
    [branch]
    if (contrast != 1.f) {
      float3 displacement = (contrast - 1.f) * highlight_stops;
      float3 displacement_magnitude = abs(displacement);
      output_highlight_stops += displacement
                                / mad(
                                    displacement_magnitude,
                                    exp2(-1.f / displacement_magnitude),
                                    1.f);
    }

    graded_normalized = exp2(mad(
        exponent,
        min(input_stops, 0.f),
        output_highlight_stops));
  }

  [branch]
  if (highlight_contrast != 1.f) {
    float3 distance = max(graded_normalized - 1.f, 0.f);
    float3 distance_squared = distance * distance;
    float3 flat_distance = (1.f + distance_squared)
                           * exp2(-1.f / distance_squared);
    graded_normalized += distance
                         * (pow(
                                1.f + flat_distance,
                                0.5f * (highlight_contrast - 1.f))
                            - 1.f);
  }

  [branch]
  if (shadow_contrast != 1.f) {
    float3 distance = saturate(1.f - graded_normalized);
    float3 distance_squared = distance * distance;
    float3 flat_distance = distance_squared * distance
                           * exp2(1.f - 1.f / distance_squared);
    graded_normalized *= pow(1.f + flat_distance, 1.f - shadow_contrast);
  }

  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    static const float TONAL_OFFSET_START_STOPS = 1.f;
    static const float TONAL_OFFSET_END_STOPS = 8.f;
    static const float TONAL_OFFSET_INVERSE_RANGE_STOPS =
        1.f / (TONAL_OFFSET_END_STOPS - TONAL_OFFSET_START_STOPS);

    float3 tonal_stops = log2(graded_normalized);
    float3 tonal_displacement = 0.f;
    [branch]
    if (highlights != 1.f) {
      float adjustment = highlights - 1.f;
      float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      float3 weight = custom_psycho31_CInfinityTransition(
          (tonal_stops - TONAL_OFFSET_START_STOPS)
          * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    [branch]
    if (shadows != 1.f) {
      float adjustment = shadows - 1.f;
      float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      float3 weight = custom_psycho31_CInfinityTransition(
          (-TONAL_OFFSET_START_STOPS - tonal_stops)
          * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    graded_normalized *= exp2(tonal_displacement);
  }
  return graded_normalized * anchor_out;
}

float3 custom_psycho31_GradeLMS(
    float3 grading_source_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float purity_scale,
    float highlight_saturation,
    float dechroma,
    float sdr_eotf_emulation,
    out float3 tonal_input_lms) {
  tonal_input_lms = grading_source_lms;
  [branch]
  if (purity_scale != 1.f || highlight_saturation != 1.f || dechroma != 0.f) {
    float effective_purity_scale = purity_scale;
    [branch]
    if (dechroma != 0.f || highlight_saturation != 1.f) {
      static const float INVERSE_HIGHLIGHT_RANGE_STOPS =
          1.f / (2.75f * log2(10.f));
      static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
      static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

      float source_relative_yf = max(
          renodx::color::yf::from::LMS(grading_source_lms / anchor_in_lms)
              / renodx::color::yf::from::LMS(1.f.xxx),
          0.f);
      float luminance_from_neutral = max(source_relative_yf, 1.f);
      float rolloff_position = saturate(
          log2(luminance_from_neutral) * INVERSE_HIGHLIGHT_RANGE_STOPS);
      float rolloff_position_squared = rolloff_position * rolloff_position;
      float rolloff = rolloff_position_squared * rolloff_position
                      * mad(
                          rolloff_position,
                          mad(6.f, rolloff_position, -15.f),
                          10.f);
      if (dechroma != 0.f) {
        effective_purity_scale *= mad(-dechroma, rolloff, 1.f);
      }
      if (highlight_saturation != 1.f) {
        float highlight_rolloff = rolloff * rolloff
                                  * mad(
                                      HIGHLIGHT_ROLLOFF_CUBIC_BLEND,
                                      rolloff,
                                      1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
        effective_purity_scale *= mad(
            highlight_saturation - 1.f,
            highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH,
            1.f);
      }
    }
    tonal_input_lms = psycho30_ApplyAdaptiveRelativePurity(
                          grading_source_lms,
                          anchor_in_lms,
                          effective_purity_scale)
                      * anchor_in_lms;
  }
  tonal_input_lms = max(tonal_input_lms, 0.f);

  if (sdr_eotf_emulation != 0.f) {
    tonal_input_lms = renodx::color::correct::GammaSafe(
                          tonal_input_lms / PSYCHO30_D65_WHITE_LMS)
                      * PSYCHO30_D65_WHITE_LMS;
  }
  return custom_psycho31_ApplyAnchoredTonalGrading(
      tonal_input_lms,
      anchor_in_lms,
      anchor_out_lms,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      highlights,
      shadows);
}

float3 custom_psycho31_ApplyAnchoredCInfinityShoulder(
    float3 color,
    float3 peak,
    float3 anchor,
    float compression_strength) {
  float3 shoulder_range = peak - anchor;
  float3 distance_from_anchor = max(color - anchor, 0.f);
  float3 flat_weight = exp2(
      -shoulder_range / (compression_strength * distance_from_anchor));
  float3 response_denominator = mad(
      distance_from_anchor,
      flat_weight,
      shoulder_range);
  return mad(
      shoulder_range,
      distance_from_anchor / response_denominator,
      color - distance_from_anchor);
}

float3 custom_psycho31_MeanA2Response(
    float3 source_q,
    float3 response_u,
    out float response_yf,
    out uint valid) {
  valid = all(source_q >= 0.f)
                  && all(response_u >= 0.f)
                  && !any(isnan(source_q))
                  && !any(isinf(source_q))
                  && !any(isnan(response_u))
                  && !any(isinf(response_u))
              ? 1u
              : 0u;
  if (valid == 0u) {
    response_yf = 0.f;
    return 0.f;
  }

  float2 source_dt = psycho30_ScaledA2FromQ(source_q);
  float2 response_dt = psycho30_ScaledA2FromQ(response_u);
  float2 authored_dt = response_dt;
  float source_radius6 = psycho30_ScaledA2Radius6(source_dt);
  float response_radius6 = psycho30_ScaledA2Radius6(response_dt);
  if (source_radius6 > 6.f * PSYCHO30_EPSILON2
      && response_radius6 > 6.f * PSYCHO30_EPSILON2) {
    float inverse_response_radius = rsqrt(response_radius6);
    float response_radius = response_radius6 * inverse_response_radius;
    float2 mean_direction = source_dt * rsqrt(source_radius6)
                            + response_dt * inverse_response_radius;
    float mean_radius6 = psycho30_ScaledA2Radius6(mean_direction);
    if (mean_radius6 > 6.f * PSYCHO30_EPSILON2) {
      authored_dt = mean_direction
                    * (response_radius * rsqrt(mean_radius6));
    }
  }

  response_yf = PSYCHO30_D65_ALPHA_L * response_u.x
                + PSYCHO30_D65_ALPHA_M * response_u.y;
  return float3(
      authored_dt.x,
      response_u.x + response_u.y + response_u.z,
      authored_dt.y);
}

void custom_psycho31_LMSToTargetMatrix(
    int target_gamut_mode,
    out float3x3 lms_to_target) {
  [branch]
  if (target_gamut_mode == CUSTOM_PSYCHO31_TARGET_GAMUT_BT709) {
    lms_to_target = PSYCHO29_LMS_TO_BT709_MAT;
  } else if (target_gamut_mode == CUSTOM_PSYCHO31_TARGET_GAMUT_DISPLAY_P3) {
    lms_to_target = CUSTOM_PSYCHO31_LMS_TO_DISPLAY_P3_MAT;
  } else {
    lms_to_target = PSYCHO29_LMS_TO_BT2020_MAT;
  }
}

float3 custom_psycho31_TargetRGBFromLMS(
    float3 lms,
    int target_gamut_mode) {
  [branch]
  if (target_gamut_mode == CUSTOM_PSYCHO31_TARGET_GAMUT_BT709) {
    return mul(PSYCHO30_LMS_TO_BT709_MAT, lms);
  } else if (target_gamut_mode == CUSTOM_PSYCHO31_TARGET_GAMUT_DISPLAY_P3) {
    return mul(CUSTOM_PSYCHO31_LMS_TO_DISPLAY_P3_MAT, lms);
  } else {
    return mul(PSYCHO30_LMS_TO_BT2020_MAT, lms);
  }
}

float custom_psycho31_TargetNeutralYfLimit(
    float target_rgb_peak,
    float3 anchor_lms,
    int target_gamut_mode) {
  return target_rgb_peak * renodx::color::yf::from::LMS(anchor_lms)
         / renodx::math::Max(custom_psycho31_TargetRGBFromLMS(
             anchor_lms,
             target_gamut_mode));
}

float custom_psycho31_ScaledA2TargetSupport(
    float2 direction,
    float clip_magnitude,
    float physical_yf,
    float3 anchor_lms,
    int target_gamut_mode,
    float target_rgb_peak) {
  if (clip_magnitude <= PSYCHO30_EPSILON) return 0.f;

  float3 neutral_target = custom_psycho31_TargetRGBFromLMS(
      psycho30_LMSFromScaledA2(0.f, physical_yf, anchor_lms),
      target_gamut_mode);
  float3 unit_target = custom_psycho31_TargetRGBFromLMS(
      psycho30_LMSFromScaledA2(direction, physical_yf, anchor_lms),
      target_gamut_mode);
  float3 delta_target = unit_target - neutral_target;
  float support = clip_magnitude;
  [unroll]
  for (int channel = 0; channel < 3; ++channel) {
    [branch]
    if (delta_target[channel] > PSYCHO30_EPSILON) {
      support = min(
          support,
          (target_rgb_peak - neutral_target[channel])
              / delta_target[channel]);
    } else if (delta_target[channel] < -PSYCHO30_EPSILON) {
      support = min(
          support,
          neutral_target[channel] / -delta_target[channel]);
    }
  }
  return max(support, 0.f);
}

float3 custom_psycho31_FixedYfL4TargetEndpoint(
    float3 coord,
    float response_yf_ceiling,
    int target_gamut_mode,
    out float normalized_demand) {
  normalized_demand = 0.f;
  float mapped_a = clamp(
      psycho31_YfFromTest30Coord(coord),
      0.f,
      clamp(response_yf_ceiling, 0.f, 1.f));
  float radial_length = sqrt(
      0.5f * coord.x * coord.x
      + coord.z * coord.z / 6.f);
  if (mapped_a <= 0.f
      || mapped_a >= 1.f
      || radial_length <= PSYCHO30_EPSILON) {
    return psycho31_Test30CoordFromDTA(0.f, 0.f, mapped_a);
  }

  float inverse_radial_length = rcp(radial_length);
  float normalized_d = coord.x * inverse_radial_length;
  float normalized_t = coord.z * inverse_radial_length;
  float3 radial_rgb;
  [branch]
  if (target_gamut_mode == CUSTOM_PSYCHO31_TARGET_GAMUT_BT709) {
    radial_rgb = normalized_d * PSYCHO30_BT709_D_RGB
                 + normalized_t * PSYCHO30_BT709_T_RGB;
  } else if (target_gamut_mode == CUSTOM_PSYCHO31_TARGET_GAMUT_DISPLAY_P3) {
    radial_rgb = normalized_d * CUSTOM_PSYCHO31_DISPLAY_P3_D_RGB
                 + normalized_t * CUSTOM_PSYCHO31_DISPLAY_P3_T_RGB;
  } else {
    radial_rgb = normalized_d * PSYCHO30_BT2020_D_RGB
                 + normalized_t * PSYCHO30_BT2020_T_RGB;
  }
  float3 upper_demand = max(radial_rgb, 0.f) / (1.f - mapped_a);
  float3 lower_demand = max(-radial_rgb, 0.f) / mapped_a;
  float demand_scale = max(
      renodx::math::Max(upper_demand),
      renodx::math::Max(lower_demand));
  if (demand_scale <= PSYCHO30_EPSILON) {
    return psycho31_Test30CoordFromDTA(0.f, 0.f, mapped_a);
  }
  float3 normalized_upper = upper_demand / demand_scale;
  float3 normalized_lower = lower_demand / demand_scale;
  float fourth_power_sum = dot(
                               normalized_upper * normalized_upper,
                               normalized_upper * normalized_upper)
                           + dot(
                               normalized_lower * normalized_lower,
                               normalized_lower * normalized_lower);
  float support = rcp(demand_scale * sqrt(sqrt(fourth_power_sum)));
  normalized_demand = radial_length / support;
  float mapped_radius = min(radial_length, support);
  return psycho31_Test30CoordFromDTA(
      normalized_d * mapped_radius,
      normalized_t * mapped_radius,
      mapped_a);
}

float3 custom_psycho31_SmoothFixedYfL4TargetEndpoint(
    float3 coord,
    float response_yf_ceiling,
    int target_gamut_mode,
    out float normalized_demand) {
  custom_psycho31_FixedYfL4TargetEndpoint(
      coord,
      response_yf_ceiling,
      target_gamut_mode,
      normalized_demand);
  float mapped_a = clamp(
      psycho31_YfFromTest30Coord(coord),
      0.f,
      clamp(response_yf_ceiling, 0.f, 1.f));
  if (!(normalized_demand > PSYCHO30_EPSILON)) {
    return psycho31_Test30CoordFromDTA(0.f, 0.f, mapped_a);
  }

  float mapped_demand = custom_psycho31_SmoothUnitLimit(
      normalized_demand);
  float radial_scale = mapped_demand / normalized_demand;
  return psycho31_Test30CoordFromDTA(
      coord.x * radial_scale,
      coord.z * radial_scale,
      mapped_a);
}

float3 custom_psycho31_YfCeilingSolve(
    float3 desired_coord,
    float response_yf,
    int target_gamut_mode,
    out uint valid) {
  if (target_gamut_mode != CUSTOM_PSYCHO31_TARGET_GAMUT_DISPLAY_P3) {
    valid = 1u;
    return psycho30_YfCeilingSolve(
        desired_coord,
        response_yf,
        target_gamut_mode);
  }

  valid = !any(isnan(desired_coord))
                  && !any(isinf(desired_coord))
                  && !isnan(response_yf)
                  && !isinf(response_yf)
              ? 1u
              : 0u;
  if (valid == 0u) return 0.f;

  float max_a = saturate(response_yf);
  float radial_a_numerator =
      3.f * PSYCHO30_D65_ALPHA_DELTA * desired_coord.x - desired_coord.z;
  float desired_a = (2.f * desired_coord.y + radial_a_numerator) / 6.f;
  float3 radial_rgb = desired_coord.x * CUSTOM_PSYCHO31_DISPLAY_P3_D_RGB
                      + desired_coord.z * CUSTOM_PSYCHO31_DISPLAY_P3_T_RGB;
  float3 desired_target_rgb = desired_a + radial_rgb;
  if (desired_a >= 0.f
      && desired_a <= max_a
      && all(desired_target_rgb >= -PSYCHO30_EPSILON)
      && all(desired_target_rgb <= 1.f + PSYCHO30_EPSILON)) {
    return desired_coord;
  }

  float radial_metric = psycho30_ScaledA2Radius6(desired_coord.xz);
  if (radial_metric <= 6.f * PSYCHO30_EPSILON2) {
    return float3(
        0.f,
        clamp(desired_coord.y, 0.f, 3.f * max_a),
        0.f);
  }

  float positive_pressure = renodx::math::Max(radial_rgb);
  float negative_pressure = -renodx::math::Min(radial_rgb);
  float total_pressure = positive_pressure + negative_pressure;
  bool is_triangle = max_a * total_pressure <= negative_pressure;
  float max_a_radial_scale;
  float upper_a;
  float upper_radial_scale;
  [branch]
  if (is_triangle) {
    max_a_radial_scale = max_a / negative_pressure;
    upper_a = max_a;
    upper_radial_scale = max_a_radial_scale;
  } else {
    max_a_radial_scale = (1.f - max_a) / positive_pressure;
    upper_radial_scale = 1.f / total_pressure;
    upper_a = negative_pressure * upper_radial_scale;
  }

  float2 vertex0 = 0.f;
  float2 vertex1 = float2(3.f * max_a, 0.f);
  float2 vertex2 = float2(
      3.f * max_a - 0.5f * radial_a_numerator * max_a_radial_scale,
      max_a_radial_scale);
  float2 vertex3 = float2(
      3.f * upper_a - 0.5f * radial_a_numerator * upper_radial_scale,
      upper_radial_scale);
  float2 best_c_scale = float2(
      clamp(desired_coord.y, vertex0.x, vertex1.x),
      0.f);
  float2 best_delta = best_c_scale - float2(desired_coord.y, 1.f);
  float best_cost = 2.f * best_delta.x * best_delta.x
                    + radial_metric * best_delta.y * best_delta.y;

  float2 edge_candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      radial_metric,
      vertex1,
      vertex2);
  float2 edge_delta = edge_candidate - float2(desired_coord.y, 1.f);
  float edge_cost = 2.f * edge_delta.x * edge_delta.x
                    + radial_metric * edge_delta.y * edge_delta.y;
  if (edge_cost < best_cost) {
    best_c_scale = edge_candidate;
    best_cost = edge_cost;
  }
  if (!is_triangle) {
    edge_candidate = psycho30_ClosestPointOnScaleSegment(
        desired_coord.y,
        radial_metric,
        vertex2,
        vertex3);
    edge_delta = edge_candidate - float2(desired_coord.y, 1.f);
    edge_cost = 2.f * edge_delta.x * edge_delta.x
                + radial_metric * edge_delta.y * edge_delta.y;
    if (edge_cost < best_cost) {
      best_c_scale = edge_candidate;
      best_cost = edge_cost;
    }
  }
  edge_candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      radial_metric,
      vertex0,
      vertex3);
  edge_delta = edge_candidate - float2(desired_coord.y, 1.f);
  edge_cost = 2.f * edge_delta.x * edge_delta.x
              + radial_metric * edge_delta.y * edge_delta.y;
  if (edge_cost < best_cost) best_c_scale = edge_candidate;

  float3 solved_coord = float3(
      desired_coord.x * best_c_scale.y,
      best_c_scale.x,
      desired_coord.z * best_c_scale.y);
  valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
  return valid != 0u ? solved_coord : 0.f;
}

float3 custom_psycho31_JointL4TargetEndpoint(
    float3 coord,
    float response_yf_ceiling,
    int target_gamut_mode,
    float target_rgb_peak,
    out uint valid) {
  float3x3 lms_to_target;
  custom_psycho31_LMSToTargetMatrix(
      target_gamut_mode,
      lms_to_target);
  float3 target_peak_lms = PSYCHO30_D65_WHITE_LMS * target_rgb_peak;
  float3 desired_ortho = psycho29_OrthonormalConeCoordFromLMS(
      psycho31_LMSFromTest30Coord(coord, target_rgb_peak),
      target_peak_lms);
  float3 solved_ortho = psycho29_LqYfCeilingSolve(
      desired_ortho,
      response_yf_ceiling,
      target_peak_lms,
      lms_to_target,
      target_rgb_peak,
      4.f,
      0.01f,
      0.f,
      1.f,
      valid);
  if (valid == 0u) return 0.f;

  float3 normalized_lms = psycho29_LMSFromOrthonormalConeCoord(
                              solved_ortho,
                              target_peak_lms)
                          / (PSYCHO30_D65_WHITE_LMS * target_rgb_peak);
  float3 solved_coord = float3(
      normalized_lms.x - normalized_lms.y,
      normalized_lms.x + normalized_lms.y + normalized_lms.z,
      2.f * normalized_lms.z - normalized_lms.x - normalized_lms.y);
  valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
  return valid != 0u ? solved_coord : 0.f;
}

float3 custom_psycho31_TargetEndpoint(
    float3 coord,
    float response_yf_ceiling,
    int target_gamut_mode,
    float target_rgb_peak,
    int gamut_mapping_method,
    out uint valid) {
  [branch]
  if (gamut_mapping_method
      == CUSTOM_PSYCHO31_GAMUT_MAPPING_KNEE_FIXED_YF_L4) {
    float unused_normalized_demand;
    float3 solved_coord = custom_psycho31_SmoothFixedYfL4TargetEndpoint(
        coord,
        response_yf_ceiling,
        target_gamut_mode,
        unused_normalized_demand);
    valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
    return valid != 0u ? solved_coord : 0.f;
  } else if (gamut_mapping_method
             == CUSTOM_PSYCHO31_GAMUT_MAPPING_FIXED_YF_L4) {
    float unused_normalized_demand;
    float3 solved_coord = custom_psycho31_FixedYfL4TargetEndpoint(
        coord,
        response_yf_ceiling,
        target_gamut_mode,
        unused_normalized_demand);
    valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
    return valid != 0u ? solved_coord : 0.f;
  }
  return custom_psycho31_JointL4TargetEndpoint(
      coord,
      response_yf_ceiling,
      target_gamut_mode,
      target_rgb_peak,
      valid);
}

float3 custom_psychograde_test31(
    // Extended-range direct linear-light BT.709 transport RGB.
    // The pixel signal and all configuration values are trusted.
    float3 bt709_linear_input,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float highlight_contrast = 1.f,
    float shadow_contrast = 1.f,
    float purity_scale = 1.f,
    float highlight_saturation = 1.f,
    float dechroma = 0.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    int source_boundary = PSYCHO30_SOURCE_BOUNDARY_BT709) {
  float3 exposed_input = bt709_linear_input * exposure;
  float3 input_lms;
  [branch]
  if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_NONE) {
    input_lms = mul(PSYCHO30_BT709_TO_LMS_MAT, exposed_input);
  } else if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_BT2020) {
    float3 source_rgb = mul(
        renodx::color::BT709_TO_BT2020_MAT,
        exposed_input);
    if (all(source_rgb <= 0.f) && !any(isinf(source_rgb))) return 0.f;
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        source_rgb,
        PSYCHO30_BT2020_TO_LMS_MAT,
        PSYCHO30_BT2020_SOURCE_YF_WEIGHTS);
  } else if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_AP1) {
    float3 source_rgb = mul(
        renodx::color::BT709_TO_AP1_MAT,
        exposed_input);
    if (all(source_rgb <= 0.f) && !any(isinf(source_rgb))) return 0.f;
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        source_rgb,
        PSYCHO30_AP1_TO_LMS_MAT,
        PSYCHO30_AP1_SOURCE_YF_WEIGHTS);
  } else {
    if (all(exposed_input <= 0.f) && !any(isinf(exposed_input))) return 0.f;
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        exposed_input,
        PSYCHO30_BT709_TO_LMS_MAT,
        PSYCHO30_BT709_SOURCE_YF_WEIGHTS);
  }
  if (any(input_lms < 0.f)) {
    float input_yf = renodx::color::yf::from::LMS(input_lms);
    if (!(input_yf > PSYCHO30_EPSILON)
        || isnan(input_yf)
        || isinf(input_yf)) {
      return 0.f;
    }
    float3 neutral_lms = PSYCHO30_D65_WHITE_LMS
                         * (input_yf / PSYCHO30_D65_WHITE_YF);
    float3 residual = input_lms - neutral_lms;
    float3 lower_fraction = renodx::math::Select(
        residual < -PSYCHO30_EPSILON,
        neutral_lms / max(-residual, PSYCHO30_EPSILON),
        PSYCHO30_LARGE_SUPPORT);
    input_lms = max(
        neutral_lms
            + residual * min(1.f, renodx::math::Min(lower_fraction)),
        0.f);
  }
  if (all(input_lms == 0.f)) return 0.f;

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms;
  [branch]
  if (all(current_background_state_bt709
          == current_adaptive_state_bt709)) {
    anchor_out_lms = anchor_in_lms;
  } else {
    anchor_out_lms = mul(
        PSYCHO30_BT709_TO_LMS_MAT,
        current_background_state_bt709);
  }
  float3 unused_tonal_input_lms;
  float3 graded_lms = custom_psycho31_GradeLMS(
      input_lms,
      anchor_in_lms,
      anchor_out_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      0.f,
      unused_tonal_input_lms);
  float3 output_bt709 = mul(PSYCHO30_LMS_TO_BT709_MAT, graded_lms);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : 0.f;
}

void custom_psycho31_ResponseState(
    float3 source_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float3 target_peak_lms,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float purity_scale,
    float highlight_saturation,
    float dechroma,
    float sdr_eotf_emulation,
    float compression,
    out float3 source_q,
    out float3 response_u) {
  float3 tonal_input_lms;
  float3 graded_lms = custom_psycho31_GradeLMS(
      source_lms,
      anchor_in_lms,
      anchor_out_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      sdr_eotf_emulation,
      tonal_input_lms);
  float3 response_lms = custom_psycho31_ApplyAnchoredCInfinityShoulder(
      graded_lms,
      target_peak_lms,
      anchor_out_lms,
      compression);

  source_q = tonal_input_lms / anchor_in_lms;
  response_u = response_lms / target_peak_lms;
}

float3 custom_psycho31_ResponseCoord(
    float3 source_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float3 target_peak_lms,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float purity_scale,
    float highlight_saturation,
    float dechroma,
    float sdr_eotf_emulation,
    float compression,
    out float3 source_q,
    out float response_yf,
    out uint valid) {
  float3 response_u;
  custom_psycho31_ResponseState(
      source_lms,
      anchor_in_lms,
      anchor_out_lms,
      target_peak_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      sdr_eotf_emulation,
      compression,
      source_q,
      response_u);
  return custom_psycho31_MeanA2Response(
      source_q,
      response_u,
      response_yf,
      valid);
}

float custom_psycho31_TransformedSourceClipScaledA2Magnitude(
    float2 source_mb,
    float source_physical_yf,
    float target_yf,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float3 target_peak_lms,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float compression) {
  float2 neutral_mb = psycho30_AdaptiveNeutralMB();
  float2 source_offset = source_mb - neutral_mb;
  float source_radius2 = dot(source_offset, source_offset);
  if (source_radius2 <= PSYCHO30_EPSILON2) return 0.f;

  float2 vertices[3];
  [unroll]
  for (int channel = 0; channel < 3; ++channel) {
    float3 primary_lms = float3(
        PSYCHO30_BT709_TO_LMS_MAT[0][channel],
        PSYCHO30_BT709_TO_LMS_MAT[1][channel],
        PSYCHO30_BT709_TO_LMS_MAT[2][channel]);
    vertices[channel] = psycho30_MBFromRelativeLMS(
        primary_lms / anchor_in_lms);
  }
  float2 source_direction = source_offset * rsqrt(source_radius2);
  float source_boundary_radius = min(
      psycho30_RaySegmentRadius(
          neutral_mb,
          source_direction,
          vertices[0],
          vertices[1]),
      min(
          psycho30_RaySegmentRadius(
              neutral_mb,
              source_direction,
              vertices[1],
              vertices[2]),
          psycho30_RaySegmentRadius(
              neutral_mb,
              source_direction,
              vertices[2],
              vertices[0])));
  if (source_boundary_radius >= PSYCHO30_LARGE_SUPPORT) return 0.f;

  float2 boundary_mb = neutral_mb
                       + source_direction * source_boundary_radius;
  const float3 weights = renodx::color::CIE1702_MB_CIE_WEIGHTS;
  float m_fraction = 1.f - boundary_mb.x;
  if (boundary_mb.x <= PSYCHO30_EPSILON
      || m_fraction <= PSYCHO30_EPSILON
      || boundary_mb.y <= PSYCHO30_EPSILON
      || !(source_physical_yf > PSYCHO30_EPSILON)) {
    return 0.f;
  }

  float3 boundary_q_direction = float3(
      boundary_mb.x * weights.y / (m_fraction * weights.x),
      1.f,
      boundary_mb.y * weights.y / (m_fraction * weights.z));
  float boundary_q_m = source_physical_yf
                       / renodx::color::yf::from::LMS(
                           anchor_in_lms * boundary_q_direction);
  float3 boundary_tonal_input_lms = anchor_in_lms
                                    * boundary_q_direction
                                    * boundary_q_m;
  float3 boundary_graded_lms = custom_psycho31_ApplyAnchoredTonalGrading(
      boundary_tonal_input_lms,
      anchor_in_lms,
      anchor_out_lms,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      highlights,
      shadows);
  float3 boundary_response_lms = custom_psycho31_ApplyAnchoredCInfinityShoulder(
      boundary_graded_lms,
      target_peak_lms,
      anchor_out_lms,
      compression);
  float boundary_response_yf = renodx::color::yf::from::LMS(
      boundary_response_lms);
  if (!(boundary_response_yf > PSYCHO30_EPSILON)) return 0.f;

  float3 boundary_q_at_yf = boundary_response_lms
                            * (target_yf / boundary_response_yf)
                            / anchor_in_lms;
  return sqrt(psycho30_ScaledA2Radius6(
      psycho30_ScaledA2FromQ(boundary_q_at_yf)));
}

float3 custom_psycho31_LinearA2Fallback(
    float3 source_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float3 target_peak_lms,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float purity_scale,
    float highlight_saturation,
    float dechroma,
    float sdr_eotf_emulation,
    float compression,
    int target_gamut_mode,
    float target_rgb_peak,
    float target_compression_strength) {
  float3 tonal_input_magnitude;
  float3 graded_magnitude = custom_psycho31_GradeLMS(
      abs(source_lms),
      anchor_in_lms,
      anchor_out_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      sdr_eotf_emulation,
      tonal_input_magnitude);
  float3 response_magnitude = custom_psycho31_ApplyAnchoredCInfinityShoulder(
      graded_magnitude,
      target_peak_lms,
      anchor_out_lms,
      compression);
  float3 tonal_input_lms = renodx::math::CopySign(
      tonal_input_magnitude,
      source_lms);
  float3 response_lms = renodx::math::CopySign(
      response_magnitude,
      source_lms);
  float3 source_q = tonal_input_lms / anchor_in_lms;
  float response_yf = renodx::color::yf::from::LMS(response_lms);

  float2 source_scaled_a2 = psycho30_ScaledA2FromQ(source_q);
  float2 response_scaled_a2 = psycho30_ScaledA2FromQ(
      response_lms / anchor_in_lms);
  float source_radius6 = psycho30_ScaledA2Radius6(source_scaled_a2);
  float response_radius6 = psycho30_ScaledA2Radius6(response_scaled_a2);
  float3 authored_lms = response_lms;
  if (source_radius6 > 6.f * PSYCHO30_EPSILON2
      && response_radius6 > 6.f * PSYCHO30_EPSILON2) {
    float inverse_source_radius = rsqrt(source_radius6);
    float inverse_response_radius = rsqrt(response_radius6);
    float response_radius = response_radius6 * inverse_response_radius;
    float2 midpoint = source_scaled_a2 * inverse_source_radius
                      + response_scaled_a2 * inverse_response_radius;
    float midpoint_radius6 = psycho30_ScaledA2Radius6(midpoint);
    if (midpoint_radius6 > PSYCHO30_EPSILON2) {
      authored_lms = psycho30_LMSFromScaledA2(
          midpoint * rsqrt(midpoint_radius6) * response_radius,
          response_yf,
          anchor_in_lms);
    }
  }

  // The C-infinity shoulder already supplies the finite display response, so
  // its physiological Yf directly replaces the original scalar finite endpoint.
  float target_yf = response_yf;
  float3 desired_lms = authored_lms;
  [branch]
  if (target_compression_strength == 0.f) {
    return desired_lms;
  } else if (target_yf <= 0.f) {
    return desired_lms * (1.f - target_compression_strength);
  } else {
    float2 desired_scaled_a2 = psycho30_ScaledA2FromQ(
        desired_lms / anchor_in_lms);
    float desired_radius6 = psycho30_ScaledA2Radius6(desired_scaled_a2);
    if (desired_radius6 <= 6.f * PSYCHO30_EPSILON2) {
      return anchor_in_lms
             * (target_yf
                / renodx::color::yf::from::LMS(anchor_in_lms));
    }

    float inverse_desired_magnitude = rsqrt(desired_radius6);
    float desired_magnitude = desired_radius6 * inverse_desired_magnitude;
    float2 direction = desired_scaled_a2 * inverse_desired_magnitude;
    float source_clip_magnitude = max(
        custom_psycho31_TransformedSourceClipScaledA2Magnitude(
            psycho30_MBFromRelativeLMS(source_q),
            abs(renodx::color::yf::from::LMS(tonal_input_lms)),
            target_yf,
            anchor_in_lms,
            anchor_out_lms,
            target_peak_lms,
            highlights,
            shadows,
            contrast,
            flare,
            highlight_contrast,
            shadow_contrast,
            compression),
        desired_magnitude);
    float target_support = custom_psycho31_ScaledA2TargetSupport(
        direction,
        source_clip_magnitude,
        target_yf,
        anchor_in_lms,
        target_gamut_mode,
        target_rgb_peak);
    float compressed_magnitude = min(
        psycho30_NeutwoWithClip(
            desired_magnitude,
            target_support,
            max(source_clip_magnitude, target_support),
            compression),
        target_support);
    return psycho30_LMSFromScaledA2(
        direction
            * lerp(
                desired_magnitude,
                compressed_magnitude,
                target_compression_strength),
        target_yf,
        anchor_in_lms);
  }
}

float3 custom_psycho31_SourceCoordinateCage(
    float3 desired_coord,
    float3 anchored_source_rgb,
    float3x3 source_to_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float3 target_peak_lms,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float purity_scale,
    float highlight_saturation,
    float dechroma,
    float sdr_eotf_emulation,
    float compression,
    int gamut_mapping_method,
    int target_gamut_mode,
    float target_rgb_peak,
    out uint valid) {
  valid = 0u;
  float3 source_yf_coefficients = mul(
      renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1],
      source_to_lms);
  float neutral_source_rgb = dot(
                                 source_yf_coefficients,
                                 anchored_source_rgb)
                             / dot(source_yf_coefficients, 1.f.xxx);
  if (neutral_source_rgb <= PSYCHO30_EPSILON) return 0.f;

  float3 source_residual = anchored_source_rgb - neutral_source_rgb;
  float3 raw_lower_demand = -source_residual / neutral_source_rgb;
  float exact_demand_scale = renodx::math::Max(raw_lower_demand);
  if (exact_demand_scale <= PSYCHO30_EPSILON) return 0.f;
  float demand_scale = exact_demand_scale;
  [branch]
  if (gamut_mapping_method
      == CUSTOM_PSYCHO31_GAMUT_MAPPING_KNEE_FIXED_YF_L4) {
    const float smooth_epsilon =
        CUSTOM_PSYCHO31_SOURCE_POSITIVE_EPSILON;
    float3 smooth_lower_demand = 0.5f
                                 * (raw_lower_demand
                                    + sqrt(
                                        raw_lower_demand * raw_lower_demand
                                        + smooth_epsilon * smooth_epsilon));
    demand_scale = custom_psycho31_SmoothMax3(smooth_lower_demand);
  }

  float boundary_fraction = rcp(demand_scale);
  if (boundary_fraction <= PSYCHO30_EPSILON
      || boundary_fraction >= PSYCHO30_LARGE_SUPPORT
      || isnan(boundary_fraction)
      || isinf(boundary_fraction)) {
    return 0.f;
  }

  float3 neutral_source_q;
  float3 neutral_response_u;
  custom_psycho31_ResponseState(
      mul(source_to_lms, neutral_source_rgb.xxx),
      anchor_in_lms,
      anchor_out_lms,
      target_peak_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      sdr_eotf_emulation,
      compression,
      neutral_source_q,
      neutral_response_u);
  uint neutral_valid = all(neutral_source_q >= 0.f)
                               && all(neutral_response_u >= 0.f)
                               && !any(isnan(neutral_source_q))
                               && !any(isinf(neutral_source_q))
                               && !any(isnan(neutral_response_u))
                               && !any(isinf(neutral_response_u))
                           ? 1u
                           : 0u;
  float neutral_response_yf = PSYCHO30_D65_ALPHA_L
                                  * neutral_response_u.x
                              + PSYCHO30_D65_ALPHA_M
                                    * neutral_response_u.y;
  float3 boundary_source_q;
  float boundary_response_yf;
  uint boundary_valid;
  float3 source_boundary_coord = custom_psycho31_ResponseCoord(
      mul(
          source_to_lms,
          neutral_source_rgb + source_residual * boundary_fraction),
      anchor_in_lms,
      anchor_out_lms,
      target_peak_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      sdr_eotf_emulation,
      compression,
      boundary_source_q,
      boundary_response_yf,
      boundary_valid);
  if (neutral_valid == 0u
      || boundary_valid == 0u
      || any(neutral_source_q <= 0.f)
      || any(boundary_source_q <= 0.f)) {
    return 0.f;
  }

  uint target_endpoint_valid;
  float3 target_endpoint_coord = custom_psycho31_TargetEndpoint(
      source_boundary_coord,
      boundary_response_yf,
      target_gamut_mode,
      target_rgb_peak,
      gamut_mapping_method,
      target_endpoint_valid);
  if (target_endpoint_valid == 0u) return 0.f;

  float desired_a = psycho31_YfFromTest30Coord(desired_coord);
  float source_boundary_a = psycho31_YfFromTest30Coord(
      source_boundary_coord);
  float source_chord_a = source_boundary_a - neutral_response_yf;
  float source_chord_length2 =
      0.5f * source_boundary_coord.x * source_boundary_coord.x
      + source_boundary_coord.z * source_boundary_coord.z / 6.f
      + source_chord_a * source_chord_a;
  if (source_chord_length2 <= PSYCHO30_EPSILON2) return 0.f;
  float projected_progress =
      (0.5f * desired_coord.x * source_boundary_coord.x
       + desired_coord.z * source_boundary_coord.z / 6.f
       + (desired_a - neutral_response_yf) * source_chord_a)
      / source_chord_length2;
  float response_progress = gamut_mapping_method
                                    == CUSTOM_PSYCHO31_GAMUT_MAPPING_KNEE_FIXED_YF_L4
                                ? custom_psycho31_CInfinityClamp01(
                                      projected_progress)
                                : saturate(projected_progress);
  float3 mapped_coord = psycho31_Test30CoordFromDTA(
      response_progress * target_endpoint_coord.x,
      response_progress * target_endpoint_coord.z,
      lerp(
          neutral_response_yf,
          psycho31_YfFromTest30Coord(target_endpoint_coord),
          response_progress));
  valid = !any(isnan(mapped_coord)) && !any(isinf(mapped_coord)) ? 1u : 0u;
  return valid != 0u ? mapped_coord : 0.f;
}

float3 custom_psychotm_test31(
    // Extended-range direct linear-light BT.709 transport RGB.
    // The pixel signal and all configuration values are trusted.
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float highlight_contrast = 1.f,
    float shadow_contrast = 1.f,
    float purity_scale = 1.f,
    float highlight_saturation = 1.f,
    float dechroma = 0.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float sdr_eotf_emulation = 0.f,
    float gamut_compression = 1.f,
    int gamut_compression_mode = 1,
    float compression = 1.5f,
    int source_boundary = PSYCHO30_SOURCE_BOUNDARY_BT709,
    float source_awareness = 1.f,
    int gamut_mapping_method = CUSTOM_PSYCHO31_GAMUT_MAPPING_KNEE_FIXED_YF_L4,
    float yf_support_q = PSYCHO29_INFINITY_SUPPORT_Q,
    float yf_dynamic_face_gap = 0.01f,
    float yf_dynamic_mix = 0.f,
    float yf_generalized_mix = 1.f) {
  float3 exposed_input = bt709_linear_input * exposure;
  float3 input_lms;
  float3 anchored_source_rgb = exposed_input;
  float3x3 source_to_lms = PSYCHO30_BT709_TO_LMS_MAT;
  [branch]
  if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_NONE) {
    input_lms = mul(PSYCHO30_BT709_TO_LMS_MAT, exposed_input);
  } else if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_BT2020) {
    float3 source_rgb = mul(
        renodx::color::BT709_TO_BT2020_MAT,
        exposed_input);
    if (all(source_rgb <= 0.f) && !any(isinf(source_rgb))) {
      return float3(0.f, 0.f, 0.f);
    }
    source_to_lms = PSYCHO30_BT2020_TO_LMS_MAT;
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        source_rgb,
        source_to_lms,
        PSYCHO30_BT2020_SOURCE_YF_WEIGHTS,
        anchored_source_rgb);
  } else if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_AP1) {
    float3 source_rgb = mul(
        renodx::color::BT709_TO_AP1_MAT,
        exposed_input);
    if (all(source_rgb <= 0.f) && !any(isinf(source_rgb))) {
      return float3(0.f, 0.f, 0.f);
    }
    source_to_lms = PSYCHO30_AP1_TO_LMS_MAT;
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        source_rgb,
        source_to_lms,
        PSYCHO30_AP1_SOURCE_YF_WEIGHTS,
        anchored_source_rgb);
  } else {
    if (all(exposed_input <= 0.f) && !any(isinf(exposed_input))) {
      return float3(0.f, 0.f, 0.f);
    }
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        exposed_input,
        source_to_lms,
        PSYCHO30_BT709_SOURCE_YF_WEIGHTS,
        anchored_source_rgb);
  }

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms;
  [branch]
  if (all(current_background_state_bt709
          == current_adaptive_state_bt709)) {
    anchor_out_lms = anchor_in_lms;
  } else {
    anchor_out_lms = mul(
        PSYCHO30_BT709_TO_LMS_MAT,
        current_background_state_bt709);
  }
  float target_rgb_peak = peak_value;
  float3 target_peak_lms = PSYCHO30_D65_WHITE_LMS * target_rgb_peak;
  float response_compression;
  [branch]
  if (compression == PSYCHO30_AUTO_COMPRESSION_SENTINEL) {
    response_compression = psycho30_AutoCompressionPower(
        renodx::color::yf::from::LMS(anchor_out_lms),
        custom_psycho31_TargetNeutralYfLimit(
            target_rgb_peak,
            anchor_in_lms,
            gamut_compression_mode));
  } else {
    response_compression = compression;
  }

  bool use_signed_fallback = any(input_lms <= 0.f);
  float3 source_q = 0.f;
  float response_yf = 0.f;
  float3 desired_test30_coord = 0.f;
  [branch]
  if (!use_signed_fallback) {
    uint response_valid;
    desired_test30_coord = custom_psycho31_ResponseCoord(
        input_lms,
        anchor_in_lms,
        anchor_out_lms,
        target_peak_lms,
        highlights,
        shadows,
        contrast,
        flare,
        highlight_contrast,
        shadow_contrast,
        purity_scale,
        highlight_saturation,
        dechroma,
        sdr_eotf_emulation,
        response_compression,
        source_q,
        response_yf,
        response_valid);
    if (response_valid == 0u) return float3(0.f, 0.f, 0.f);
    use_signed_fallback = any(source_q <= 0.f);
  }
  [branch]
  if (use_signed_fallback) {
    float3 fallback_lms = custom_psycho31_LinearA2Fallback(
        input_lms,
        anchor_in_lms,
        anchor_out_lms,
        target_peak_lms,
        highlights,
        shadows,
        contrast,
        flare,
        highlight_contrast,
        shadow_contrast,
        purity_scale,
        highlight_saturation,
        dechroma,
        sdr_eotf_emulation,
        response_compression,
        gamut_compression_mode,
        target_rgb_peak,
        gamut_compression);
    return mul(PSYCHO30_LMS_TO_BT709_MAT, fallback_lms);
  }

  float target_compression_weight = gamut_compression;
  if (target_compression_weight == 0.f) {
    return mul(
        PSYCHO30_LMS_TO_BT709_MAT,
        psycho31_LMSFromTest30Coord(
            desired_test30_coord,
            target_rgb_peak));
  }

  float3 desired_lms = psycho31_LMSFromTest30Coord(
      desired_test30_coord,
      target_rgb_peak);
  bool use_knee_mapping = gamut_mapping_method
                          == CUSTOM_PSYCHO31_GAMUT_MAPPING_KNEE_FIXED_YF_L4;
  float normalized_demand = 0.f;
  float3 knee_mapped_test30_coord = 0.f;
  [branch]
  if (use_knee_mapping) {
    knee_mapped_test30_coord =
        custom_psycho31_SmoothFixedYfL4TargetEndpoint(
            desired_test30_coord,
            response_yf,
            gamut_compression_mode,
            normalized_demand);
  }
  float source_weight = source_boundary != PSYCHO30_SOURCE_BOUNDARY_NONE
                            ? saturate(source_awareness)
                            : 0.f;
  [branch]
  if (source_weight != 0.f && use_knee_mapping) {
    float knee_position =
        (normalized_demand - CUSTOM_PSYCHO31_GAMUT_KNEE_START)
        / (CUSTOM_PSYCHO31_GAMUT_KNEE_END
           - CUSTOM_PSYCHO31_GAMUT_KNEE_START);
    // The flat transition and its constant extensions meet with every
    // derivative equal to zero at both knee endpoints.
    source_weight *= custom_psycho31_CInfinityTransition(knee_position);
  }
  float3 source_aware_test30_coord = 0.f;
  [branch]
  if (source_weight != 0.f) {
    uint cage_valid;
    float3 cage_test30_coord = custom_psycho31_SourceCoordinateCage(
        desired_test30_coord,
        anchored_source_rgb,
        source_to_lms,
        anchor_in_lms,
        anchor_out_lms,
        target_peak_lms,
        highlights,
        shadows,
        contrast,
        flare,
        highlight_contrast,
        shadow_contrast,
        purity_scale,
        highlight_saturation,
        dechroma,
        sdr_eotf_emulation,
        response_compression,
        gamut_mapping_method,
        gamut_compression_mode,
        target_rgb_peak,
        cage_valid);
    [branch]
    if (cage_valid != 0u) {
      source_aware_test30_coord = cage_test30_coord;
    } else {
      uint direct_target_valid;
      source_aware_test30_coord = custom_psycho31_TargetEndpoint(
          desired_test30_coord,
          response_yf,
          gamut_compression_mode,
          target_rgb_peak,
          gamut_mapping_method,
          direct_target_valid);
      [branch]
      if (direct_target_valid == 0u
          && gamut_mapping_method
                 == CUSTOM_PSYCHO31_GAMUT_MAPPING_JOINT_L4) {
        float unused_desired_target_demand;
        source_aware_test30_coord = custom_psycho31_FixedYfL4TargetEndpoint(
            desired_test30_coord,
            response_yf,
            gamut_compression_mode,
            unused_desired_target_demand);
      }
    }
  }

  float3 mapped_lms;
  [branch]
  if (source_weight == 1.f) {
    mapped_lms = psycho31_LMSFromTest30Coord(
        source_aware_test30_coord,
        target_rgb_peak);
  } else {
    uint solve_valid;
    [branch]
    if (use_knee_mapping) {
      solve_valid = !any(isnan(knee_mapped_test30_coord))
                            && !any(isinf(knee_mapped_test30_coord))
                        ? 1u
                        : 0u;
      mapped_lms = psycho31_LMSFromTest30Coord(
          knee_mapped_test30_coord,
          target_rgb_peak);
    } else if (yf_support_q >= PSYCHO29_INFINITY_SUPPORT_Q
               && yf_dynamic_mix == 0.f
               && yf_generalized_mix == 1.f) {
      // Test30's polygon solve is the analytic L-infinity solution in the
      // equivalent orthonormal metric; avoid Test29's 33+20 sample search.
      float3 solved_test30_coord = custom_psycho31_YfCeilingSolve(
          desired_test30_coord,
          response_yf,
          gamut_compression_mode,
          solve_valid);
      mapped_lms = psycho31_LMSFromTest30Coord(
          solved_test30_coord,
          target_rgb_peak);
    } else {
      float3x3 lms_to_target;
      custom_psycho31_LMSToTargetMatrix(
          gamut_compression_mode,
          lms_to_target);
      float3 target_peak_lms = PSYCHO30_D65_WHITE_LMS * target_rgb_peak;
      float3 desired_coord = psycho29_OrthonormalConeCoordFromLMS(
          desired_lms,
          target_peak_lms);
      float3 solved_coord = psycho29_LqYfCeilingSolve(
          desired_coord,
          response_yf,
          target_peak_lms,
          lms_to_target,
          target_rgb_peak,
          yf_support_q,
          yf_dynamic_face_gap,
          yf_dynamic_mix,
          yf_generalized_mix,
          solve_valid);
      mapped_lms = psycho29_LMSFromOrthonormalConeCoord(
          solved_coord,
          target_peak_lms);
    }
    if (solve_valid == 0u) return float3(0.f, 0.f, 0.f);
    [branch]
    if (source_weight != 0.f) {
      mapped_lms = lerp(
          mapped_lms,
          psycho31_LMSFromTest30Coord(
              source_aware_test30_coord,
              target_rgb_peak),
          source_weight);
    }
  }

  float3 output_lms = lerp(
      desired_lms,
      mapped_lms,
      target_compression_weight);
  float3 output_bt709 = mul(PSYCHO30_LMS_TO_BT709_MAT, output_lms);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : float3(0.f, 0.f, 0.f);
}

float3 psychotm_test31(
    // Extended-range direct linear-light BT.709 transport RGB.
    // The pixel signal and all configuration values are trusted.
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float purity_scale = 1.f,
    float bleaching_intensity = 1.f,     // compatibility placeholder
    float clip_point = 100.f,            // compatibility placeholder
    float hue_restore = 1.f,             // compatibility placeholder
    float encoded_response_power = 1.f,  // compatibility placeholder
    int white_curve_mode = 0,            // compatibility placeholder
    float cone_response_exponent = 1.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float gamut_compression = 1.f,
    int gamut_compression_mode = 1,
    float adaptive_normalization = 1.f,  // compatibility placeholder
    float compression = 1.f,
    int source_boundary = PSYCHO30_SOURCE_BOUNDARY_BT709,
    float source_awareness = 1.f,
    float yf_support_q = PSYCHO29_INFINITY_SUPPORT_Q,
    float yf_dynamic_face_gap = 0.01f,
    float yf_dynamic_mix = 0.f,
    float yf_generalized_mix = 1.f) {
  float3 exposed_input = bt709_linear_input * exposure;
  float3 input_lms;
  float3 anchored_source_rgb = exposed_input;
  float3x3 source_to_lms = PSYCHO30_BT709_TO_LMS_MAT;
  [branch]
  if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_NONE) {
    input_lms = mul(PSYCHO30_BT709_TO_LMS_MAT, exposed_input);
  } else if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_BT2020) {
    float3 source_rgb = mul(
        renodx::color::BT709_TO_BT2020_MAT,
        exposed_input);
    if (all(source_rgb <= 0.f) && !any(isinf(source_rgb))) {
      return float3(0.f, 0.f, 0.f);
    }
    source_to_lms = PSYCHO30_BT2020_TO_LMS_MAT;
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        source_rgb,
        source_to_lms,
        PSYCHO30_BT2020_SOURCE_YF_WEIGHTS,
        anchored_source_rgb);
  } else if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_AP1) {
    float3 source_rgb = mul(
        renodx::color::BT709_TO_AP1_MAT,
        exposed_input);
    if (all(source_rgb <= 0.f) && !any(isinf(source_rgb))) {
      return float3(0.f, 0.f, 0.f);
    }
    source_to_lms = PSYCHO30_AP1_TO_LMS_MAT;
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        source_rgb,
        source_to_lms,
        PSYCHO30_AP1_SOURCE_YF_WEIGHTS,
        anchored_source_rgb);
  } else {
    if (all(exposed_input <= 0.f) && !any(isinf(exposed_input))) {
      return float3(0.f, 0.f, 0.f);
    }
    input_lms = psycho30_AnchorSourceBoundaryToYf(
        exposed_input,
        source_to_lms,
        PSYCHO30_BT709_SOURCE_YF_WEIGHTS,
        anchored_source_rgb);
  }

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms;
  [branch]
  if (all(current_background_state_bt709
          == current_adaptive_state_bt709)) {
    anchor_out_lms = anchor_in_lms;
  } else {
    anchor_out_lms = mul(
        PSYCHO30_BT709_TO_LMS_MAT,
        current_background_state_bt709);
  }
  float response_power = contrast * cone_response_exponent;
  float purity_delta = purity_scale / contrast;
  float3 response_input_q = psycho31_ResponseInputQ(
      input_lms,
      anchor_in_lms,
      highlights,
      shadows,
      purity_delta);
  float target_rgb_peak = peak_value;
  float response_h;
  [branch]
  if (compression == PSYCHO30_AUTO_COMPRESSION_SENTINEL) {
    response_h = psycho30_AutoCompressionPower(
        renodx::color::yf::from::LMS(anchor_out_lms),
        psycho30_TargetNeutralYfLimit(
            target_rgb_peak,
            anchor_in_lms,
            gamut_compression_mode));
  } else {
    response_h = compression;
  }

  [branch]
  if (any(response_input_q <= 0.f)) {
    float3 fallback_lms = psycho30_LinearA2Fallback(
        response_input_q,
        anchor_in_lms,
        anchor_out_lms,
        gamut_compression_mode,
        target_rgb_peak,
        response_power,
        response_h,
        gamut_compression);
    return mul(PSYCHO30_LMS_TO_BT709_MAT, fallback_lms);
  }

  float response_yf;
  float3 adaptation_peak_ratio = anchor_out_lms
                                 / (PSYCHO30_D65_WHITE_LMS
                                    * target_rgb_peak);
  float3 desired_test30_coord = psycho30_MeanA2ResponseFromPositiveQ(
      response_input_q,
      adaptation_peak_ratio,
      response_power,
      response_h,
      response_yf);

  float target_compression_weight = gamut_compression;
  if (target_compression_weight == 0.f) {
    return mul(
        PSYCHO30_LMS_TO_BT709_MAT,
        psycho31_LMSFromTest30Coord(
            desired_test30_coord,
            target_rgb_peak));
  }

  float3 desired_lms = psycho31_LMSFromTest30Coord(
      desired_test30_coord,
      target_rgb_peak);
  float source_weight = source_boundary != PSYCHO30_SOURCE_BOUNDARY_NONE
                            ? saturate(source_awareness)
                            : 0.f;
  float3 source_aware_test30_coord = 0.f;
  [branch]
  if (source_weight != 0.f) {
    uint cage_valid;
    float3 cage_test30_coord = psycho31_SourceCoordinateCage(
        desired_test30_coord,
        anchored_source_rgb,
        source_to_lms,
        anchor_in_lms,
        adaptation_peak_ratio,
        highlights,
        shadows,
        purity_delta,
        response_power,
        response_h,
        gamut_compression_mode,
        target_rgb_peak,
        cage_valid);
    [branch]
    if (cage_valid != 0u) {
      source_aware_test30_coord = cage_test30_coord;
    } else {
      uint direct_target_valid;
      source_aware_test30_coord = psycho31_JointL4TargetEndpoint(
          desired_test30_coord,
          response_yf,
          gamut_compression_mode,
          target_rgb_peak,
          direct_target_valid);
      [branch]
      if (direct_target_valid == 0u) {
        float unused_desired_target_demand;
        source_aware_test30_coord = psycho31_FixedYfL4TargetEndpoint(
            desired_test30_coord,
            response_yf,
            gamut_compression_mode,
            unused_desired_target_demand);
      }
    }
  }

  float3 mapped_lms;
  [branch]
  if (source_weight == 1.f) {
    mapped_lms = psycho31_LMSFromTest30Coord(
        source_aware_test30_coord,
        target_rgb_peak);
  } else {
    float3x3 target_to_lms = gamut_compression_mode == 0
                                 ? PSYCHO29_BT709_TO_LMS_MAT
                                 : PSYCHO29_BT2020_TO_LMS_MAT;
    float3x3 lms_to_target = gamut_compression_mode == 0
                                 ? PSYCHO29_LMS_TO_BT709_MAT
                                 : PSYCHO29_LMS_TO_BT2020_MAT;
    float3 target_peak_lms = mul(
        target_to_lms,
        float3(target_rgb_peak, target_rgb_peak, target_rgb_peak));
    float3 desired_coord = psycho29_OrthonormalConeCoordFromLMS(
        desired_lms,
        target_peak_lms);
    uint solve_valid;
    float3 solved_coord = psycho29_LqYfCeilingSolve(
        desired_coord,
        response_yf,
        target_peak_lms,
        lms_to_target,
        target_rgb_peak,
        yf_support_q,
        yf_dynamic_face_gap,
        yf_dynamic_mix,
        yf_generalized_mix,
        solve_valid);
    if (solve_valid == 0u) return float3(0.f, 0.f, 0.f);
    mapped_lms = psycho29_LMSFromOrthonormalConeCoord(
        solved_coord,
        target_peak_lms);
    [branch]
    if (source_weight != 0.f) {
      mapped_lms = lerp(
          mapped_lms,
          psycho31_LMSFromTest30Coord(
              source_aware_test30_coord,
              target_rgb_peak),
          source_weight);
    }
  }

  float3 output_lms = lerp(
      desired_lms,
      mapped_lms,
      target_compression_weight);
  float3 output_bt709 = mul(PSYCHO30_LMS_TO_BT709_MAT, output_lms);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : float3(0.f, 0.f, 0.f);
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

#endif  // PSYCHOV_CUSTOMTEST31_HLSLI_