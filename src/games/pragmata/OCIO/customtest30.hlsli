#ifndef PSYCHOV_CUSTOMTEST30_HLSLI_
#define PSYCHOV_CUSTOMTEST30_HLSLI_

#ifndef PSYCHO30_CUSTOM_EXTERNAL_COMMON
#include "../common.hlsli"
#endif

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx {
namespace tonemap {
namespace psychov {

// Game-facing extensions layered on the shared PsychoV30 implementation.
static const float PSYCHO30_CUSTOM_MAX_FINITE_INPUT = 65504.f;
static const int PSYCHO30_TARGET_GAMUT_BT709 = 0;
static const int PSYCHO30_TARGET_GAMUT_BT2020 = 1;
static const int PSYCHO30_TARGET_GAMUT_DISPLAY_P3 = 3;

#ifndef PSYCHO30_CUSTOM_SKIP_SANITIZATION
#define PSYCHO30_CUSTOM_SKIP_SANITIZATION 0
#endif

static const int PSYCHO30_CUSTOM_GAMUT_MAPPING_EXACT_PROJECTION = 0;
static const int PSYCHO30_CUSTOM_GAMUT_MAPPING_SOFT_RADIAL = 1;
static const float PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE = 0.9f;
// (0, 1] guarantees monotonic containment; 1 is the firmest valid response.
static const float PSYCHO30_CUSTOM_GAMUT_COMPRESSION_FIRMNESS = 0.65f;
static const float PSYCHO30_CUSTOM_GAMUT_COMPRESSION_EXP2_SCALE =
    PSYCHO30_CUSTOM_GAMUT_COMPRESSION_FIRMNESS / log(2.f);

static const float3x3 PSYCHO30_LMS_TO_DISPLAY_P3_MAT = mul(
    renodx::color::XYZ_TO_DISPLAYP3_MAT,
    renodx::color::STOCKMAN_CVRL_LMS_TO_XYZ_2DEG_FIT);
static const float3 PSYCHO30_DISPLAY_P3_D_RGB = mul(
    PSYCHO30_LMS_TO_DISPLAY_P3_MAT,
    PSYCHO30_D_LMS);
static const float3 PSYCHO30_DISPLAY_P3_T_RGB = mul(
    PSYCHO30_LMS_TO_DISPLAY_P3_MAT,
    PSYCHO30_T_LMS);

// Keep the custom source inside the positive AP1 gamut cone, then trace any
// remaining non-positive cone response toward same-Yf D65 until LMS is valid.
float3 psycho30_ClampSourceAP1ToPositiveLMS(float3 source_bt709) {
  float3 source_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      renodx::color::bt709::clamp::AP1(source_bt709));
  if (all(source_lms >= 0.f)) return source_lms;

  float source_yf = renodx::color::yf::from::LMS(source_lms);
  if (!(source_yf > PSYCHO30_EPSILON)
      || isnan(source_yf)
      || isinf(source_yf)) {
    return 0.f;
  }

  float3 neutral_lms = PSYCHO30_D65_WHITE_LMS
                       * (source_yf / PSYCHO30_D65_WHITE_YF);
  float3 residual = source_lms - neutral_lms;
  float3 lower_fraction = renodx::math::Select(
      residual < -PSYCHO30_EPSILON,
      neutral_lms / max(-residual, PSYCHO30_EPSILON),
      PSYCHO30_LARGE_SUPPORT);
  return max(
      neutral_lms + residual * min(1.f, renodx::math::Min(lower_fraction)),
      0.f);
}

float3 psycho30_CustomCInfinityTransition(float3 position) {
  position = saturate(position);
  return rcp(1.f + exp2((1.f - 2.f * position) / (position * (1.f - position))));
}

float3 psycho30_ApplyAnchoredTonalGrading(
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

  // Power contrast below the anchor and bounded log-domain contrast above it.
  // Flare increases only the deep-shadow exponent.
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
                                / mad(displacement_magnitude,
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
    float3 flat_distance = (1.f + distance_squared) * exp2(-1.f / distance_squared);
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
      float3 weight = psycho30_CustomCInfinityTransition(
          (tonal_stops - TONAL_OFFSET_START_STOPS)
          * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    [branch]
    if (shadows != 1.f) {
      float adjustment = shadows - 1.f;
      float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      float3 weight = psycho30_CustomCInfinityTransition(
          (-TONAL_OFFSET_START_STOPS - tonal_stops)
          * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    graded_normalized *= exp2(tonal_displacement);
  }

  return graded_normalized * anchor_out;
}

// Shared grading stage for the grading-only and complete tonemap paths.
float3 psycho30_GradeCustomLMS(
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

    // Author the highlight controls in the same adaptation-relative Yf
    // coordinate used by the shared LMS purity interpolation.
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

  // Grade the three physical LMS cone components independently after purity.
  if (sdr_eotf_emulation != 0.f) {
    tonal_input_lms = renodx::color::correct::GammaSafe(
                          tonal_input_lms / PSYCHO30_D65_WHITE_LMS)
                      * PSYCHO30_D65_WHITE_LMS;
  }

  return psycho30_ApplyAnchoredTonalGrading(
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

float3 psycho30_ApplyAnchoredCInfinityShoulder(
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

// Construct the shared scaled-A2 response coordinate from a custom response.
// Source weight 0 selects response direction; 1 selects the exact midpoint.
float3 psycho30_MeanA2ResponseFromCustomResponse(
    float3 source_q,
    float3 response_u,
    float source_direction_weight,
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
    float2 mean_direction = mad(
        source_dt,
        rsqrt(source_radius6) * source_direction_weight,
        response_dt * inverse_response_radius);
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

// Preserve the authored scaled-A2 direction and physiological A while smoothly
// reducing radius against all six target RGB-cube planes.
float3 psycho30_ApplyCustomSoftRadialGamutCompression(
    float3 desired_coord,
    float response_yf,
    int target_gamut_mode,
    out uint valid) {
  valid = !any(isnan(desired_coord))
                  && !any(isinf(desired_coord))
                  && !isnan(response_yf)
                  && !isinf(response_yf)
              ? 1u
              : 0u;
  if (valid == 0u) return 0.f;

  float radial_a_numerator =
      3.f * PSYCHO30_D65_ALPHA_DELTA * desired_coord.x - desired_coord.z;
  float desired_a = (2.f * desired_coord.y + radial_a_numerator) / 6.f;
  float mapped_a = clamp(desired_a, 0.f, saturate(response_yf));
  float3 radial_rgb;
  [branch]
  if (target_gamut_mode == PSYCHO30_TARGET_GAMUT_BT709) {
    radial_rgb = desired_coord.x * PSYCHO30_BT709_D_RGB
                 + desired_coord.z * PSYCHO30_BT709_T_RGB;
  } else if (target_gamut_mode == PSYCHO30_TARGET_GAMUT_DISPLAY_P3) {
    radial_rgb = desired_coord.x * PSYCHO30_DISPLAY_P3_D_RGB
                 + desired_coord.z * PSYCHO30_DISPLAY_P3_T_RGB;
  } else {
    radial_rgb = desired_coord.x * PSYCHO30_BT2020_D_RGB
                 + desired_coord.z * PSYCHO30_BT2020_T_RGB;
  }

  float positive_pressure = renodx::math::Max(radial_rgb);
  float negative_pressure = -renodx::math::Min(radial_rgb);
  if (positive_pressure
          <= PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE * (1.f - mapped_a)
      && negative_pressure
             <= PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE * mapped_a) {
    return float3(
        desired_coord.x,
        3.f * mapped_a - 0.5f * radial_a_numerator,
        desired_coord.z);
  }

  float support_scale = PSYCHO30_LARGE_SUPPORT;
  if (positive_pressure > PSYCHO30_EPSILON) {
    support_scale = min(
        support_scale,
        (1.f - mapped_a) / positive_pressure);
  }
  if (negative_pressure > PSYCHO30_EPSILON) {
    support_scale = min(
        support_scale,
        mapped_a / negative_pressure);
  }
  if (!(support_scale < PSYCHO30_LARGE_SUPPORT)) {
    return float3(
        desired_coord.x,
        3.f * mapped_a - 0.5f * radial_a_numerator,
        desired_coord.z);
  }

  support_scale = max(support_scale, 0.f);
  float knee_scale = PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE * support_scale;
  float headroom = support_scale - knee_scale;
  float excess = 1.f - knee_scale;
  float headroom_per_excess = headroom * rcp(excess);
  float flat_weight = exp2(
      -PSYCHO30_CUSTOM_GAMUT_COMPRESSION_EXP2_SCALE * headroom_per_excess);
  float mapped_scale = knee_scale
                       + headroom * rcp(headroom_per_excess + flat_weight);
  mapped_scale = clamp(mapped_scale, 0.f, min(1.f, support_scale));

  float2 mapped_dt = desired_coord.xz * mapped_scale;
  float mapped_c = 3.f * mapped_a
                   - 0.5f * radial_a_numerator * mapped_scale;
  float3 mapped_coord = float3(mapped_dt.x, mapped_c, mapped_dt.y);
  valid = !any(isnan(mapped_coord)) && !any(isinf(mapped_coord)) ? 1u : 0u;
  return valid != 0u ? mapped_coord : 0.f;
}

// Extend the shared exact scaled-A2 target solve to Display P3.
float3 psycho30_CustomYfCeilingSolve(
    float3 desired_coord,
    float response_yf,
    int target_gamut_mode,
    out uint valid) {
  if (target_gamut_mode != PSYCHO30_TARGET_GAMUT_DISPLAY_P3) {
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
  float3 radial_rgb = desired_coord.x * PSYCHO30_DISPLAY_P3_D_RGB
                      + desired_coord.z * PSYCHO30_DISPLAY_P3_T_RGB;
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
  if (edge_cost < best_cost) {
    best_c_scale = edge_candidate;
  }

  float3 solved_coord = float3(
      desired_coord.x * best_c_scale.y,
      best_c_scale.x,
      desired_coord.z * best_c_scale.y);
  valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
  return valid != 0u ? solved_coord : 0.f;
}

// Grading-only custom path. Input and output are direct linear-light BT.709.
float3 psychograde_custom_test30(
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
    float3 current_background_state_bt709 = 0.18f) {
#if PSYCHO30_CUSTOM_SKIP_SANITIZATION
  float3 source_bt709 = bt709_linear_input * exposure;
#else
  float3 finite_input = renodx::math::ZeroNaN(bt709_linear_input);
  finite_input = renodx::math::Select(
      isinf(finite_input),
      renodx::math::CopySign(PSYCHO30_CUSTOM_MAX_FINITE_INPUT, finite_input),
      finite_input);
  float3 source_bt709 = finite_input * exposure;
#endif
  float3 source_lms = psycho30_ClampSourceAP1ToPositiveLMS(source_bt709);
  if (all(source_lms == 0.f)) return 0.f;

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_background_state_bt709);
  float3 tonal_input_lms;
  float3 graded_lms = psycho30_GradeCustomLMS(
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
      0.f,
      tonal_input_lms);

  float3 output_bt709 = mul(PSYCHO30_LMS_TO_BT709_MAT, graded_lms);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : 0.f;
}

float3 psychotm_custom_test30(
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
    int gamut_compression_mode = PSYCHO30_TARGET_GAMUT_BT2020,
    float compression = 1.5f,
    float mean_a2_source_weight = 0.7f,
    int gamut_mapping_method = PSYCHO30_CUSTOM_GAMUT_MAPPING_SOFT_RADIAL) {
#if PSYCHO30_CUSTOM_SKIP_SANITIZATION
  float3 source_bt709 = bt709_linear_input * exposure;
#else
  float3 finite_input = renodx::math::ZeroNaN(bt709_linear_input);
  finite_input = renodx::math::Select(
      isinf(finite_input),
      renodx::math::CopySign(PSYCHO30_CUSTOM_MAX_FINITE_INPUT, finite_input),
      finite_input);
  float3 source_bt709 = finite_input * exposure;
#endif
  float3 source_lms = psycho30_ClampSourceAP1ToPositiveLMS(source_bt709);
  if (all(source_lms == 0.f)) return 0.f;

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_background_state_bt709);
  float3 target_peak_lms = PSYCHO30_D65_WHITE_LMS * peak_value;

  // Preserve the pre-tonal LMS state for source-direction authoring.
  float3 tonal_input_lms;
  float3 graded_lms = psycho30_GradeCustomLMS(
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
  float3 response_lms = psycho30_ApplyAnchoredCInfinityShoulder(
      graded_lms,
      target_peak_lms,
      anchor_out_lms,
      compression);

  float3 source_q = tonal_input_lms / anchor_in_lms;
  float3 response_u = response_lms / target_peak_lms;
  float response_yf;
  uint response_valid;
  float3 desired_coord = psycho30_MeanA2ResponseFromCustomResponse(
      source_q,
      response_u,
      mean_a2_source_weight,
      response_yf,
      response_valid);
  if (response_valid == 0u) return 0.f;

  float3 selected_coord = desired_coord;
  if (gamut_compression != 0.f) {
    uint solve_valid;
    float3 solved_coord;
    [branch]
    if (gamut_mapping_method == PSYCHO30_CUSTOM_GAMUT_MAPPING_EXACT_PROJECTION) {
      solved_coord = psycho30_CustomYfCeilingSolve(
          desired_coord,
          response_yf,
          gamut_compression_mode,
          solve_valid);
    } else {
      solved_coord = psycho30_ApplyCustomSoftRadialGamutCompression(
          desired_coord,
          response_yf,
          gamut_compression_mode,
          solve_valid);
    }
    if (solve_valid == 0u) return 0.f;
    selected_coord = gamut_compression == 1.f
                         ? solved_coord
                         : lerp(
                               desired_coord,
                               solved_coord,
                               gamut_compression);
  }

  float output_a = (2.f * selected_coord.y
                    + 3.f * PSYCHO30_D65_ALPHA_DELTA * selected_coord.x
                    - selected_coord.z)
                   / 6.f;
  float3 output_bt709 = peak_value
                        * (output_a
                           + selected_coord.x * PSYCHO30_BT709_D_RGB
                           + selected_coord.z * PSYCHO30_BT709_T_RGB);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : 0.f;
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

#endif  // PSYCHOV_CUSTOMTEST30_HLSLI_
