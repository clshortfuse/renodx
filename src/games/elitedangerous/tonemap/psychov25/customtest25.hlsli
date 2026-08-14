#ifndef RENODX_SHADERS_TONEMAP_PSYCHOV_TEST25_HLSL_
#define RENODX_SHADERS_TONEMAP_PSYCHOV_TEST25_HLSL_

#include "../../common.hlsli"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx {
namespace tonemap {
namespace psychov {

static const float PSYCHO25_EPSILON = 1e-6f;
static const float PSYCHO25_LARGE = 1e20f;
static const float PSYCHO25_LOWER_PLANE_COMPRESSION_KNEE = 0.9f;
static const float PSYCHO25_LOWER_PLANE_NEUTRAL_RELEASE_FRACTION = 0.75f;
static const float PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON = 1e-5f;
static const float PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER = 256.f;
static const float PSYCHO25_REFERENCE_SOURCE_DIRECTION_OCCUPANCY = 0.8f;
static const float PSYCHO25_SOURCE_HUE_SUPPORT_FRACTION = 0.25f;
static const float PSYCHO25_SOURCE_DIRECTION_BLEND_POWER = 2.f;

static const int PSYCHO25_TARGET_GAMUT_BT709 = 0;
static const int PSYCHO25_TARGET_GAMUT_BT2020 = 1;
static const int PSYCHO25_TARGET_GAMUT_DISPLAY_P3 = 3;

static const float3x3 PSYCHO25_LMS_WEIGHTED_TO_DISPLAY_P3_MAT = mul(renodx::color::XYZ_TO_DISPLAYP3_MAT, renodx::color::macleod_boynton::LMS_WEIGHTED_TO_XYZ_MAT);

float psycho25_SignedYfFromLMS(float3 lms) {
  float3 weighted_lms = renodx::color::macleod_boynton::WeighLMS(lms);
  return weighted_lms.x + weighted_lms.y;
}

float psycho25_YfFromLMS(float3 lms) {
  return max(psycho25_SignedYfFromLMS(lms), PSYCHO25_EPSILON);
}

float3 psycho25_ToAdaptiveRelativeWeightedLMS(
    float3 lms_input,
    float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho25_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative
         * max(current_adaptive_state_lms, PSYCHO25_EPSILON.xxx);
}

float3 psycho25_LMSFromAdaptiveMB(
    float3 mb,
    float3 current_adaptive_state_lms) {
  float3 relative_weighted =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb);
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho25_FromAdaptiveRelativeWeightedLMS(
          relative_weighted,
          current_adaptive_state_lms));
}

float3 psycho25_ApplyAdaptiveMBPurity(
    float3 lms_input,
    float3 adaptive_neutral_lms,
    float purity_delta) {
  if (abs(purity_delta - 1.f) <= 1e-5f) return lms_input;

  float3 relative_weighted = psycho25_ToAdaptiveRelativeWeightedLMS(
      lms_input,
      adaptive_neutral_lms);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(
      relative_weighted);
  float3 mb_neutral = renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_delta);
  float3 relative_weighted_out =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          float3(mb_scaled_xy, mb.z));
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho25_FromAdaptiveRelativeWeightedLMS(
          relative_weighted_out,
          adaptive_neutral_lms));
}

float3x3 psycho25_WeightedLMSToRGBMatrix(int gamut_mode) {
  if (gamut_mode == PSYCHO25_TARGET_GAMUT_BT709) {
    return renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT709_MAT;
  }
  if (gamut_mode == PSYCHO25_TARGET_GAMUT_DISPLAY_P3) {
    return PSYCHO25_LMS_WEIGHTED_TO_DISPLAY_P3_MAT;
  }
  return renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT2020_MAT;
}

float3 psycho25_TargetRGBFromLMS(float3 lms, int gamut_mode) {
  return mul(
      psycho25_WeightedLMSToRGBMatrix(gamut_mode),
      renodx::color::macleod_boynton::WeighLMS(lms));
}

float psycho25_TargetLowerPlaneBoundaryFraction(
    float3 candidate_target_rgb,
    float3 neutral_target_rgb) {
  float boundary_fraction = PSYCHO25_LARGE;
  if (candidate_target_rgb.x < neutral_target_rgb.x) {
    boundary_fraction = min(
        boundary_fraction,
        neutral_target_rgb.x
            / (neutral_target_rgb.x - candidate_target_rgb.x));
  }
  if (candidate_target_rgb.y < neutral_target_rgb.y) {
    boundary_fraction = min(
        boundary_fraction,
        neutral_target_rgb.y
            / (neutral_target_rgb.y - candidate_target_rgb.y));
  }
  if (candidate_target_rgb.z < neutral_target_rgb.z) {
    boundary_fraction = min(
        boundary_fraction,
        neutral_target_rgb.z
            / (neutral_target_rgb.z - candidate_target_rgb.z));
  }
  return boundary_fraction;
}

float psycho25_CompressTargetLowerPlaneRadius(float boundary_fraction) {
  float knee = PSYCHO25_LOWER_PLANE_COMPRESSION_KNEE * boundary_fraction;
  float headroom = boundary_fraction - knee;
  float excess = max(1.f - knee, 0.f);
  return 1.f - excess
         + renodx::math::DivideSafe(
             headroom * excess,
             headroom + excess,
             0.f);
}

float psycho25_SmoothPositive(float value) {
  float smooth_length = sqrt(
      value * value
      + PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON
            * PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON);
  float normalized_value = value / smooth_length;
  return 0.5f * value * normalized_value * (1.f + normalized_value);
}

float psycho25_IntersectTargetPlaneSupports(float a, float b) {
  float normalization = max(a, b);
  float normalized_a = a / normalization;
  float normalized_b = b / normalization;
  float denominator = normalization
                      * pow(
                          pow(normalized_a, PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER)
                              + pow(normalized_b, PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER),
                          rcp(PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER));
  return a * b / denominator;
}

float psycho25_IntersectTargetPlaneSupports(float3 support) {
  return psycho25_IntersectTargetPlaneSupports(
      support.x,
      psycho25_IntersectTargetPlaneSupports(support.y, support.z));
}

float psycho25_TargetLowerPlaneRadiusForDirection(
    float2 direction,
    float2 adapted_neutral_mb,
    float3 current_adaptive_state_lms,
    int target_gamut_mode) {
  float3 neutral_lms = psycho25_LMSFromAdaptiveMB(
      float3(adapted_neutral_mb, 1.f),
      current_adaptive_state_lms);
  float3 unit_radius_lms = psycho25_LMSFromAdaptiveMB(
      float3(adapted_neutral_mb + direction, 1.f),
      current_adaptive_state_lms);
  float3 neutral_target_rgb = psycho25_TargetRGBFromLMS(
      neutral_lms,
      target_gamut_mode);
  float3 direction_target_rgb = psycho25_TargetRGBFromLMS(
      unit_radius_lms - neutral_lms,
      target_gamut_mode);
  float3 lower_support = neutral_target_rgb
                         / (float3(
                                psycho25_SmoothPositive(-direction_target_rgb.x),
                                psycho25_SmoothPositive(-direction_target_rgb.y),
                                psycho25_SmoothPositive(-direction_target_rgb.z))
                            + PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON);
  return psycho25_IntersectTargetPlaneSupports(lower_support);
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

float3 ComputeCInfinityTransition(float3 position) {
  position = saturate(position);
  return 1.f / (1.f + exp2((1.f - 2.f * position) / (position * (1.f - position))));
}

// Monotonic and C-infinity continuous anchored tonal grading
float3 ApplyAnchoredTonalGrading(
    float3 color,
    float3 anchor_in = 0.18f,
    float3 anchor_out = 0.18f,
    float contrast = 1.f,
    float flare = 0.f,
    float highlight_contrast = 1.f,
    float shadow_contrast = 1.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  [branch]
  if (contrast == 1.f
      && flare == 0.f
      && highlight_contrast == 1.f
      && shadow_contrast == 1.f
      && highlights == 1.f
      && shadows == 1.f
      && all(anchor_in == anchor_out)) {
    return color;
  }

  float3 ax = abs(color);
  float3 normalized = ax / anchor_in;
  float3 contrasted_normalized = normalized;

  // Power contrast and shadow flare, optionally bounding contrast on highlights.
  [branch]
  if (contrast != 1.f || flare > 0.f) {
    float3 exponent = contrast;

    [branch]
    if (flare > 0.f) {
      float3 shadow_distance = saturate(1.f - normalized);
      float3 flat_shadow_weight = exp2(-normalized / shadow_distance);
      exponent *= mad(flat_shadow_weight, flare / (normalized + flare), 1.f);
    }

#if 1
    float3 input_stops = log2(normalized);
    float3 highlight_stops = max(input_stops, 0.f);
    float3 output_highlight_stops = highlight_stops;

    [branch]
    if (contrast != 1.f) {
      float3 contrast_displacement = (contrast - 1.f) * highlight_stops;
      float3 displacement_magnitude = abs(contrast_displacement);
      output_highlight_stops += contrast_displacement / mad(displacement_magnitude, exp2(-1.f / displacement_magnitude), 1.f);
    }

    contrasted_normalized = exp2(mad(exponent, min(input_stops, 0.f), output_highlight_stops));
#else
    contrasted_normalized = pow(normalized, exponent);
#endif
  }

  // broad highlight contrast.
  [branch]
  if (highlight_contrast != 1.f) {
    float3 highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    float3 highlight_distance_squared = highlight_distance * highlight_distance;
    float3 flat_highlight_distance = (1.f + highlight_distance_squared) * exp2(-1.f / highlight_distance_squared);
    contrasted_normalized += highlight_distance * (pow(1.f + flat_highlight_distance, 0.5f * (highlight_contrast - 1.f)) - 1.f);
  }

  // broad shadow contrast.
  [branch]
  if (shadow_contrast != 1.f) {
    float3 shadow_distance = saturate(1.f - contrasted_normalized);
    float3 shadow_distance_squared = shadow_distance * shadow_distance;
    float3 flat_shadow_distance = shadow_distance_squared * shadow_distance * exp2(1.f - 1.f / shadow_distance_squared);
    contrasted_normalized *= pow(1.f + flat_shadow_distance, shadow_contrast - 1.f);
  }

  // Mirror offsets about the anchor over the declared stop range.
  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    static const float TONAL_OFFSET_START_STOPS = 1.f;
    static const float TONAL_OFFSET_END_STOPS = 8.f;
    static const float TONAL_OFFSET_INVERSE_RANGE_STOPS = 1.f / (TONAL_OFFSET_END_STOPS - TONAL_OFFSET_START_STOPS);

    float3 tonal_stops = log2(contrasted_normalized);
    float3 tonal_displacement = 0.f;

    [branch]
    if (highlights != 1.f) {
      float highlight_adjustment = highlights - 1.f;
      float highlight_displacement = highlight_adjustment * mad(1.5f, abs(highlight_adjustment), 0.5f);
      float3 highlight_weight = ComputeCInfinityTransition((tonal_stops - TONAL_OFFSET_START_STOPS) * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(highlight_displacement, highlight_weight, tonal_displacement);
    }

    [branch]
    if (shadows != 1.f) {
      float shadow_adjustment = shadows - 1.f;
      float shadow_displacement = shadow_adjustment * mad(1.5f, abs(shadow_adjustment), 0.5f);
      float3 shadow_weight = ComputeCInfinityTransition((-TONAL_OFFSET_START_STOPS - tonal_stops) * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(shadow_displacement, shadow_weight, tonal_displacement);
    }

    contrasted_normalized *= exp2(tonal_displacement);
  }

  return renodx::math::CopySign(contrasted_normalized * anchor_out, color);
}

/// Identity through anchor to every derivative; then approaches peak
/// monotonically and concave down. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(T)                                                      \
  T ApplyAnchoredCInfinityShoulder(T color, T peak, T anchor, float compression_strength) {                \
    T shoulder_range = peak - anchor;                                                                      \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                  \
    T flat_weight = exp2(-shoulder_range / (compression_strength * distance_from_anchor));                 \
    T response_denominator = mad(distance_from_anchor, flat_weight, shoulder_range);                       \
    return mad(shoulder_range, distance_from_anchor / response_denominator, color - distance_from_anchor); \
  }

APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float)
APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR(float3)
#undef APPLYANCHORED_CINFINITY_SHOULDER_GENERATOR

float ApplyAnchoredCInfinityShoulderMaxChannelScale(float3 color, float peak, float anchor, float compression_strength) {
  float max_channel = renodx::math::Max(abs(color));
  float compressed_max = ApplyAnchoredCInfinityShoulder(max_channel, peak, anchor, compression_strength);
  return renodx::math::DivideSafe(compressed_max, max_channel, 1.f);
}

// PsychoV25 target-hull path: Fast60 hue guidance, Reference Scale,
// full target-gamut lower/upper-plane enforcement, and a black upper-hull pivot.
float3 CompressPsychoV25ReferenceScaleHull(
    float3 desired_lms,
    float3 direction_source_lms,
    float3 adaptive_state_lms,
    float3 background_state_lms,
    float3 target_lms_peak,
    float pre_shoulder_hue_linearity,
    float post_shoulder_source_hue_recovery_strength,
    float compression,
    float peak_value,
    int target_gamut_mode) {
  float3 desired_weighted_lms = renodx::color::macleod_boynton::WeighLMS(desired_lms);
  float desired_yf = desired_weighted_lms.x + desired_weighted_lms.y;
  if (desired_yf <= renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    return 0.f.xxx;
  }

  float adaptive_yf = renodx::tonemap::psychov::psycho25_YfFromLMS(adaptive_state_lms);
  float background_yf = renodx::tonemap::psychov::psycho25_YfFromLMS(background_state_lms);
  float target_peak_yf = renodx::tonemap::psychov::psycho25_SignedYfFromLMS(target_lms_peak);
  float3 safe_adaptive_state_lms = max(
      adaptive_state_lms,
      renodx::tonemap::psychov::PSYCHO25_EPSILON.xxx);
  float2 adapted_neutral_mb = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float3 source_mb = renodx::color::macleod_boynton::from::WeightedLMS(
      renodx::tonemap::psychov::psycho25_ToAdaptiveRelativeWeightedLMS(
          direction_source_lms,
          adaptive_state_lms));

  // Hue linearity authors the shoulder input rather than correcting its
  // output. Blend the desired adaptive-MB direction toward the source while
  // retaining the desired radius and Yf, then run the per-cone shoulder.
  float3 shoulder_input_lms = desired_lms;
  float3 desired_mb = renodx::color::macleod_boynton::from::WeightedLMS(
      renodx::tonemap::psychov::psycho25_ToAdaptiveRelativeWeightedLMS(
          desired_lms,
          adaptive_state_lms));
  float2 desired_offset = desired_mb.xy - adapted_neutral_mb;
  float2 source_offset = source_mb.xy - adapted_neutral_mb;
  float desired_radius2 = dot(desired_offset, desired_offset);
  float source_radius2 = dot(source_offset, source_offset);
  if (pre_shoulder_hue_linearity > 0.f
      && desired_radius2 > renodx::tonemap::psychov::PSYCHO25_EPSILON
                               * renodx::tonemap::psychov::PSYCHO25_EPSILON
      && source_radius2 > renodx::tonemap::psychov::PSYCHO25_EPSILON
                              * renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    float2 desired_direction = desired_offset * rsqrt(desired_radius2);
    float2 source_direction = source_offset * rsqrt(source_radius2);
    float2 shoulder_input_direction = lerp(
        desired_direction,
        source_direction,
        saturate(pre_shoulder_hue_linearity));
    shoulder_input_direction *= rsqrt(
        dot(shoulder_input_direction, shoulder_input_direction));
    float2 shoulder_input_mb_xy = adapted_neutral_mb
                                  + shoulder_input_direction * sqrt(desired_radius2);
    float shoulder_input_mb_scale = renodx::math::DivideSafe(
        desired_yf,
        shoulder_input_mb_xy.x * safe_adaptive_state_lms.x
            + (1.f - shoulder_input_mb_xy.x) * safe_adaptive_state_lms.y,
        0.f);
    shoulder_input_lms = renodx::tonemap::psychov::psycho25_LMSFromAdaptiveMB(
        float3(shoulder_input_mb_xy, shoulder_input_mb_scale),
        adaptive_state_lms);
  }

  float3 physical_compressed_lms = ApplyAnchoredCInfinityShoulder(
      shoulder_input_lms,
      target_lms_peak,
      background_state_lms,
      compression);
  float authored_yf = renodx::tonemap::psychov::psycho25_YfFromLMS(physical_compressed_lms);
  if (authored_yf <= renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    return 0.f.xxx;
  }

  float3 authored_mb = renodx::color::macleod_boynton::from::WeightedLMS(
      renodx::tonemap::psychov::psycho25_ToAdaptiveRelativeWeightedLMS(
          physical_compressed_lms,
          adaptive_state_lms));
  float2 authored_offset = authored_mb.xy - adapted_neutral_mb;
  float authored_radius2 = dot(authored_offset, authored_offset);

  float authored_radius = sqrt(authored_radius2);
  float2 authored_direction = authored_offset * rsqrt(authored_radius2 + renodx::tonemap::psychov::PSYCHO25_EPSILON * renodx::tonemap::psychov::PSYCHO25_EPSILON);

  // Reference Scale source-direction recovery keeps collapsing saturated
  // highlights from rotating through an unrelated hue on their way to white.
  [branch]
  if (post_shoulder_source_hue_recovery_strength > 0.f) {
    float source_radius = sqrt(source_radius2);
    float2 source_direction = source_offset * rsqrt(source_radius2 + renodx::tonemap::psychov::PSYCHO25_EPSILON * renodx::tonemap::psychov::PSYCHO25_EPSILON);
    float source_radius_support =
        renodx::tonemap::psychov::psycho25_TargetLowerPlaneRadiusForDirection(
            source_direction,
            adapted_neutral_mb,
            adaptive_state_lms,
            target_gamut_mode);
    float source_direction_support_radius =
        renodx::tonemap::psychov::PSYCHO25_REFERENCE_SOURCE_DIRECTION_OCCUPANCY
        * source_radius_support
        * renodx::math::DivideSafe(
            source_radius,
            sqrt(source_radius2 + source_radius_support * source_radius_support),
            0.f);
    float radius_normalization = max(
        max(authored_radius, source_direction_support_radius),
        renodx::tonemap::psychov::PSYCHO25_EPSILON);
    float authored_weight = pow(
        authored_radius / radius_normalization,
        renodx::tonemap::psychov::PSYCHO25_SOURCE_DIRECTION_BLEND_POWER);
    float source_direction_support_weight = pow(
        source_direction_support_radius / radius_normalization,
        renodx::tonemap::psychov::PSYCHO25_SOURCE_DIRECTION_BLEND_POWER);
    float source_hue_support =
        renodx::tonemap::psychov::PSYCHO25_SOURCE_HUE_SUPPORT_FRACTION
        * source_radius_support;
    float source_hue_confidence = renodx::math::DivideSafe(
        source_radius2,
        source_radius2 + source_hue_support * source_hue_support,
        0.f);
    float source_collapse_weight = renodx::math::DivideSafe(
        source_direction_support_weight,
        authored_weight + source_direction_support_weight,
        0.f);
    float source_direction_weight = post_shoulder_source_hue_recovery_strength
                                    * (1.f - (1.f - source_hue_confidence) * (1.f - source_collapse_weight));
    float2 combined_direction = lerp(
        authored_direction,
        source_direction,
        source_direction_weight);
    combined_direction *= rsqrt(
        dot(combined_direction, combined_direction)
        + renodx::tonemap::psychov::PSYCHO25_EPSILON
              * renodx::tonemap::psychov::PSYCHO25_EPSILON);
    authored_direction = combined_direction;
    authored_offset = authored_direction * authored_radius;
    authored_mb.xy = adapted_neutral_mb + authored_offset;
  }

  // Discard the trajectory's carried scale, preserving only its authored
  // adaptive-MB direction and radius before solving the target gamut hull.
  float trajectory_yf_for_normalization = authored_mb.z
                                          * (authored_mb.x * safe_adaptive_state_lms.x
                                             + (1.f - authored_mb.x) * safe_adaptive_state_lms.y);
  float3 unit_yf_lms = renodx::tonemap::psychov::psycho25_LMSFromAdaptiveMB(
      float3(
          authored_mb.xy,
          renodx::math::DivideSafe(
              authored_mb.z,
              trajectory_yf_for_normalization,
              0.f)),
      adaptive_state_lms);
  float3 neutral_lms = adaptive_state_lms / adaptive_yf;

  // Reference Scale lower-plane compression keeps the authored hue ray inside
  // the nonnegative target-gamut primary half-spaces without a component clamp.
  if (authored_radius > renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    float3 neutral_target_rgb =
        renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(neutral_lms, target_gamut_mode);
    float3 current_target_rgb =
        renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(unit_yf_lms, target_gamut_mode);
    float current_boundary_fraction =
        renodx::tonemap::psychov::psycho25_TargetLowerPlaneBoundaryFraction(
            current_target_rgb,
            neutral_target_rgb);
    float current_radius_scale =
        renodx::tonemap::psychov::psycho25_CompressTargetLowerPlaneRadius(
            current_boundary_fraction);

    authored_direction = authored_offset / authored_radius;
    float containment_reference_radius = max(
        authored_radius,
        length(source_mb.xy - adapted_neutral_mb));
    float3 reference_lms = renodx::tonemap::psychov::psycho25_LMSFromAdaptiveMB(
        float3(
            adapted_neutral_mb
                + authored_direction * containment_reference_radius,
            1.f),
        adaptive_state_lms);
    reference_lms /= renodx::tonemap::psychov::psycho25_YfFromLMS(reference_lms);
    float3 reference_target_rgb =
        renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(reference_lms, target_gamut_mode);
    float reference_boundary_fraction =
        renodx::tonemap::psychov::psycho25_TargetLowerPlaneBoundaryFraction(
            reference_target_rgb,
            neutral_target_rgb);
    float reference_radius_scale =
        renodx::tonemap::psychov::psycho25_CompressTargetLowerPlaneRadius(
            reference_boundary_fraction);

    float trajectory_fraction = authored_radius / containment_reference_radius;
    float release_progress = saturate(
        trajectory_fraction
        / renodx::tonemap::psychov::PSYCHO25_LOWER_PLANE_NEUTRAL_RELEASE_FRACTION);
    float neutral_scale = min(1.f, 4.f * reference_radius_scale);
    float release_weight = 1.f - release_progress;
    float radius_scale = min(
        lerp(
            reference_radius_scale,
            neutral_scale,
            release_weight * release_weight),
        current_radius_scale);
    unit_yf_lms = lerp(neutral_lms, unit_yf_lms, radius_scale);
  }

  // Black-pivot upper-plane shoulder along the contained target-gamut hue ray.
  float3 unit_target_rgb =
      renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(unit_yf_lms, target_gamut_mode);
  float max_target_channel = max(
      unit_target_rgb.x,
      max(unit_target_rgb.y, unit_target_rgb.z));
  float directional_yf_limit = peak_value / max_target_channel;
  float normalized_input = desired_yf * renodx::math::DivideSafe(target_peak_yf, directional_yf_limit, 1.f);
  float normalized_output = ApplyAnchoredCInfinityShoulder(
      normalized_input,
      target_peak_yf,
      background_yf,
      compression);
  float output_yf = normalized_output * renodx::math::DivideSafe(directional_yf_limit, target_peak_yf, 1.f);
  return unit_yf_lms * output_yf;
}

float3 ApplyCustomPsychoV25ToneMap(
    float3 bt709_linear_input,
    float peak_value,
    float highlights,
    float shadows,
    float cone_response_exponent,
    float flare,
    float purity_scale,
    float highlight_saturation,
    float dechroma,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float pre_shoulder_hue_linearity = 0.5f,
    float post_shoulder_source_hue_recovery_strength = 0.35f,
    float compression = 1.5f,
    int target_gamut_mode = renodx::tonemap::psychov::PSYCHO25_TARGET_GAMUT_BT2020) {
  float3 finite_bt709_input = renodx::math::ZeroNaN(bt709_linear_input);
  finite_bt709_input = renodx::math::Select(
      isinf(finite_bt709_input),
      renodx::math::CopySign(65504.f.xxx, finite_bt709_input),
      finite_bt709_input);

  float3 lms_in = renodx::color::lms::from::BT709(finite_bt709_input);
  float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(current_adaptive_state_bt709);
  float3 current_background_state_lms = renodx::color::lms::from::BT709(current_background_state_bt709);
  float3 target_lms_peak = renodx::color::lms::from::BT709(peak_value.xxx);

  if (dechroma != 0.f || highlight_saturation != 1.f) {
    float luminance = renodx::color::yf::from::LMS(lms_in);
    float neutral_luminance = renodx::color::yf::from::LMS(current_adaptive_state_lms);

    // Ramp purity grading over 2.75 decades above the adaptive neutral.
    static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
    static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
    static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

    float luminance_from_neutral = max(luminance, neutral_luminance) / neutral_luminance;
    float rolloff_position = saturate(log2(luminance_from_neutral) * INVERSE_HIGHLIGHT_RANGE_STOPS);
    float rolloff_position_squared = rolloff_position * rolloff_position;
    float rolloff = rolloff_position_squared * rolloff_position * mad(rolloff_position, mad(6.f, rolloff_position, -15.f), 10.f);

    // Base smootherstep brings dechroma into the midtones while remaining monotonic and C2.
    if (dechroma != 0.f) {
      purity_scale *= mad(-dechroma, rolloff, 1.f);
    }

    // Blend smootherstep squared and cubed for a later, gentler C2 progression.
    if (highlight_saturation != 1.f) {
      float highlight_rolloff = rolloff * rolloff * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
      purity_scale *= mad(highlight_saturation - 1.f, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
    }
  }

  float3 contrast_input = renodx::tonemap::psychov::psycho25_ApplyAdaptiveMBPurity(
      lms_in,
      current_adaptive_state_lms,
      purity_scale);
  float3 contrast_lms = ApplyAnchoredTonalGrading(
      contrast_input,
      current_adaptive_state_lms,
      current_background_state_lms,
      cone_response_exponent,
      flare,
      1.f,
      1.f,
      highlights,
      shadows);

  float3 output_lms = CompressPsychoV25ReferenceScaleHull(
      contrast_lms,
      contrast_input,
      current_adaptive_state_lms,
      current_background_state_lms,
      target_lms_peak,
      pre_shoulder_hue_linearity,
      post_shoulder_source_hue_recovery_strength,
      compression,
      peak_value,
      target_gamut_mode);
  return renodx::color::bt709::from::LMS(output_lms);
}

#endif  // RENODX_SHADERS_TONEMAP_PSYCHOV_TEST25_HLSL_