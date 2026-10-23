#include "../common.hlsli"
#include "./customtest31.hlsli"

#define ANVIL_ENGINE_TONEMAP_GENERATOR(T)                                                                                                \
  T EvaluateAnvilEngineToeAndLinear(T input, float linear_slope, float toe_end, float toe_power, float toe_offset) {                     \
    T input_abs = abs(input);                                                                                                            \
    bool toe_enabled = toe_end > 1e-5f;                                                                                                  \
    T toe_progress_unclamped = input_abs / toe_end;                                                                                      \
    T toe_progress = saturate(toe_progress_unclamped);                                                                                   \
    T toe_progress_squared = toe_progress * toe_progress;                                                                                \
    T smoothstep_factor = mad(toe_progress, -2.f, 3.f);                                                                                  \
    T toe_output = renodx::math::Select(toe_enabled, mad(pow(abs(toe_progress_unclamped), toe_power), toe_end, toe_offset), toe_offset); \
    T toe_blend_weight = mad(-smoothstep_factor, toe_progress_squared, 1.f);                                                             \
    T linear_output = mad(input_abs - toe_end, linear_slope, toe_end);                                                                   \
    T toe_to_linear_blend = mad(smoothstep_factor, toe_progress_squared, -1.f) + 1.f;                                                    \
    T toe_linear_output = (toe_blend_weight * toe_output) + (toe_to_linear_blend * linear_output);                                       \
    return toe_linear_output;                                                                                                            \
  }                                                                                                                                      \
  T ApplyAnvilEngineToneMapShoulder(T toe_linear_output, float toe_end, float peak_ratio, float shoulder_start) {                        \
    float toe_to_peak_output_range = peak_ratio - toe_end;                                                                               \
    float shoulder_start_output = mad(toe_to_peak_output_range, shoulder_start, toe_end);                                                \
    return renodx::tonemap::ExponentialRollOff(toe_linear_output, shoulder_start_output, peak_ratio);                                    \
  }                                                                                                                                      \
  T ApplyAnvilEngineToneMap(                                                                                                             \
      T input, float linear_slope, float toe_end, float toe_power, float toe_offset, float peak_ratio, float shoulder_start) {           \
    return ApplyAnvilEngineToneMapShoulder(                                                                                              \
        EvaluateAnvilEngineToeAndLinear(input, linear_slope, toe_end, toe_power, toe_offset), toe_end, peak_ratio, shoulder_start);      \
  }

ANVIL_ENGINE_TONEMAP_GENERATOR(float)
ANVIL_ENGINE_TONEMAP_GENERATOR(float3)
#undef ANVIL_ENGINE_TONEMAP_GENERATOR

namespace renodx {
namespace tonemap {
namespace psychov {
namespace anvil31 {

// Specialize the current custom_psychotm_test31 grade/call chain only. Keep its
// shared shoulder, MeanA2, target endpoints, and source geometry helpers; the
// psycho30-prefixed primitives below are also used by the current custom V31.
struct Curve {
  float linear_slope;
  float toe_end;
  float toe_power;
  float toe_offset;
  float toe_flare;
};

float3 EvaluateCustomAnvilEngineToeAndLinear(float3 input, Curve curve) {
  float3 linear_output = mad(input - curve.toe_end, curve.linear_slope, curve.toe_end);
  if (curve.toe_end <= 1e-5f) return linear_output;
  float3 toe_progress = saturate(input / curve.toe_end);
  float3 effective_toe_power = curve.toe_power;
  if (curve.toe_flare > 0.f) {
    float3 shadow_distance = 1.f - toe_progress;
    float3 flat_shadow_weight = exp2(-toe_progress / shadow_distance);
    effective_toe_power *= mad(flat_shadow_weight, curve.toe_flare / (toe_progress + curve.toe_flare), 1.f);
  }
  float3 toe_output = mad(pow(toe_progress, effective_toe_power), curve.toe_end, curve.toe_offset);
  return mad(custom_psycho31_CInfinityTransition(toe_progress), linear_output - toe_output, toe_output);
}

// All response probes (including source boundaries and signed magnitudes) use
// the same D65-relative Anvil grade. No purity, anchored grade, or post saturation.
float3 GradeLMS(float3 source_lms, Curve curve) {
  return EvaluateCustomAnvilEngineToeAndLinear(source_lms / PSYCHO30_D65_WHITE_LMS, curve)
         * PSYCHO30_D65_WHITE_LMS;
}

void ResponseState(
    float3 source_lms, Curve curve,
    float3 anchor_in_lms, float3 anchor_out_lms, float3 target_peak_lms,
    float compression, float3 mean_a2_weights,
    out float3 source_q, out float3 response_u, out float effective_weight) {
  // Odd extension requires GradeLMS(0) == 0: the current positive-power toe
  // has toe_offset == 0. Nonzero offset is positive-domain-only; it cannot
  // provide a continuous signed extension and is not silently subtracted.
  float3 graded_lms = GradeLMS(abs(source_lms), curve);
  float3 response_lms = custom_psycho31_ApplyAnchoredCInfinityShoulder(
      graded_lms, target_peak_lms, anchor_out_lms, compression);
  // With purity/gamma removed, the pre-tonal source is the original LMS, not
  // the Anvil-graded value. Preserve it for both hue and tonal-region weighting.
  source_q = source_lms / anchor_in_lms;
  response_u = renodx::math::CopySign(response_lms, source_lms)
               / target_peak_lms;
  effective_weight = custom_psycho31_ShoulderMeanA2Weight(
      abs(source_q), graded_lms, response_lms, mean_a2_weights.x, mean_a2_weights.y, mean_a2_weights.z);
}

float3 ResponseCoord(
    float3 source_lms, Curve curve,
    float3 anchor_in_lms, float3 anchor_out_lms, float3 target_peak_lms,
    float compression, float3 mean_a2_weights,
    out float3 source_q, out float response_yf, out uint valid) {
  float3 response_u;
  float effective_weight;
  ResponseState(source_lms, curve, anchor_in_lms, anchor_out_lms, target_peak_lms,
                compression, mean_a2_weights, source_q, response_u, effective_weight);
  return custom_psycho31_MeanA2Response(source_q, response_u, effective_weight, response_yf, valid);
}

// Both neutral and boundary responses must use Anvil; calling the standard
// cage here would silently restore its anchored tonal grade for those probes.
float3 SourceCoordinateCage(
    float3 desired_coord, float3 anchored_source_rgb, float3x3 source_to_lms, Curve curve,
    float3 anchor_in_lms, float3 anchor_out_lms, float3 target_peak_lms,
    float compression, float3 mean_a2_weights, float response_yf_ceiling, int target_gamut_mode, out uint valid) {
  valid = 0u;
  float3 source_yf_coefficients = mul(renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1], source_to_lms);
  float neutral_source_rgb = dot(source_yf_coefficients, anchored_source_rgb) / dot(source_yf_coefficients, 1.f.xxx);
  // Only black lacks a ray in the nonnegative anchored source RGB domain.
  if (neutral_source_rgb <= 0.f) {
    return 0.f;
  }
  float3 source_residual = anchored_source_rgb - neutral_source_rgb;
  float3 raw_lower_demand = -source_residual / neutral_source_rgb;
  const float smooth_epsilon = CUSTOM_PSYCHO31_SOURCE_POSITIVE_EPSILON;
  float3 smooth_lower_demand = 0.5f
                               * (raw_lower_demand + sqrt(raw_lower_demand * raw_lower_demand + smooth_epsilon * smooth_epsilon));
  float boundary_fraction = rcp(custom_psycho31_SmoothMax3(smooth_lower_demand));

  float3 neutral_source_q;
  float neutral_response_yf;  // Same signed response and MeanA2 policy as the pixel.
  uint neutral_valid;
  float3 neutral_coord = ResponseCoord(
      mul(source_to_lms, neutral_source_rgb.xxx), curve,
      anchor_in_lms, anchor_out_lms, target_peak_lms, compression, mean_a2_weights,
      neutral_source_q, neutral_response_yf, neutral_valid);
  float3 boundary_source_q;
  float boundary_response_yf;
  uint boundary_valid;
  float3 source_boundary_coord = ResponseCoord(
      mul(source_to_lms, neutral_source_rgb + source_residual * boundary_fraction), curve,
      anchor_in_lms, anchor_out_lms, target_peak_lms, compression, mean_a2_weights,
      boundary_source_q, boundary_response_yf, boundary_valid);
  if (neutral_valid == 0u || boundary_valid == 0u) return 0.f;
  uint target_endpoint_valid;
  float3 target_endpoint_coord = custom_psycho31_TargetEndpoint(
      source_boundary_coord, boundary_response_yf, target_gamut_mode, target_endpoint_valid);
  if (target_endpoint_valid == 0u) return 0.f;

  // The source-matrix neutral need not be exactly D65. Grade and bound both
  // ends with the pixel's Anvil response, never a standard tonal-grade probe.
  uint neutral_endpoint_valid;
  float3 neutral_endpoint_coord = custom_psycho31_TargetEndpoint(
      neutral_coord, neutral_response_yf, target_gamut_mode, neutral_endpoint_valid);
  if (neutral_endpoint_valid == 0u) return 0.f;

  float desired_a = psycho31_YfFromTest30Coord(desired_coord);
  float neutral_a = psycho31_YfFromTest30Coord(neutral_coord);
  float3 source_chord = source_boundary_coord - neutral_coord;
  float source_chord_a = psycho31_YfFromTest30Coord(source_chord);
  float source_chord_length2 = 0.5f * source_chord.x * source_chord.x
                               + source_chord.z * source_chord.z / 6.f
                               + source_chord_a * source_chord_a;
  float projected_progress = (0.5f * (desired_coord.x - neutral_coord.x) * source_chord.x
                              + (desired_coord.z - neutral_coord.z) * source_chord.z / 6.f
                              + (desired_a - neutral_a) * source_chord_a)
                             / max(source_chord_length2, PSYCHO30_EPSILON2);
  float response_progress = custom_psycho31_CInfinityClamp01(projected_progress);
  float3 mapped_coord = lerp(neutral_endpoint_coord, target_endpoint_coord, response_progress);
  // The chord and direct endpoint share the black limit; scaling toward black
  // preserves target containment and chord hue.
  float cage_a = psycho31_YfFromTest30Coord(mapped_coord);
  float ceiling_a = clamp(desired_a, 0.f, saturate(response_yf_ceiling));
  if (cage_a > ceiling_a) {
    mapped_coord *= ceiling_a / cage_a;
  }
  valid = !any(isnan(mapped_coord)) && !any(isinf(mapped_coord)) ? 1u : 0u;
  return valid != 0u ? mapped_coord : 0.f;
}

// Trusted compression >=1, peak > output anchor, weights in [0,1]; no auto mode.
float3 Apply(
    float3 bt709_input, Curve curve, float input_anchor, float output_anchor, float peak_value,
    float gamut_compression, int target_gamut_mode, float compression, float3 mean_a2_weights,
    int source_boundary, float source_awareness) {
  float3 input_lms;
  float3 anchored_source_rgb = bt709_input;
  float3x3 source_to_lms = PSYCHO30_BT709_TO_LMS_MAT;
  if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_NONE) {
    input_lms = mul(source_to_lms, bt709_input);
  } else {
    float3 source_rgb = bt709_input;
    float3 source_yf_weights = PSYCHO30_BT709_SOURCE_YF_WEIGHTS;
    if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_BT2020) {
      source_rgb = mul(renodx::color::BT709_TO_BT2020_MAT, bt709_input);
      source_to_lms = PSYCHO30_BT2020_TO_LMS_MAT;
      source_yf_weights = PSYCHO30_BT2020_SOURCE_YF_WEIGHTS;
    } else if (source_boundary == PSYCHO30_SOURCE_BOUNDARY_AP1) {
      source_rgb = mul(renodx::color::BT709_TO_AP1_MAT, bt709_input);
      source_to_lms = PSYCHO30_AP1_TO_LMS_MAT;
      source_yf_weights = PSYCHO30_AP1_SOURCE_YF_WEIGHTS;
    }
    if (all(source_rgb <= 0.f) && !any(isinf(source_rgb))) return 0.f;
    input_lms = custom_psycho31_AnchorSourceBoundaryToYf(
        source_rgb, source_to_lms, source_yf_weights,
        anchored_source_rgb);
  }

  float3 anchor_in_lms = PSYCHO30_D65_WHITE_LMS * input_anchor;
  float3 anchor_out_lms = PSYCHO30_D65_WHITE_LMS * output_anchor;
  float3 target_peak_lms = PSYCHO30_D65_WHITE_LMS * peak_value;

  float3 source_q;
  float response_yf;
  uint response_valid;
  float3 desired_coord = ResponseCoord(
      input_lms, curve, anchor_in_lms, anchor_out_lms, target_peak_lms,
      compression, mean_a2_weights, source_q, response_yf, response_valid);
  if (response_valid == 0u) return 0.f;
  float3 desired_lms = psycho31_LMSFromTest30Coord(desired_coord, peak_value);
  if (gamut_compression == 0.f) return mul(PSYCHO30_LMS_TO_BT709_MAT, desired_lms);

  // Defer direct reconstruction: a successful full cage needs only demand.
  float normalized_demand = custom_psycho31_NormalizedL8TargetDemand(
      desired_coord, response_yf, target_gamut_mode);
  float source_weight = source_boundary != PSYCHO30_SOURCE_BOUNDARY_NONE ? saturate(source_awareness) : 0.f;
  [branch]
  if (source_weight != 0.f) {
    source_weight *= custom_psycho31_CInfinityTransition(
        (normalized_demand - CUSTOM_PSYCHO31_GAMUT_KNEE_START)
        / (CUSTOM_PSYCHO31_GAMUT_KNEE_END - CUSTOM_PSYCHO31_GAMUT_KNEE_START));
  }
  float3 source_aware_coord = 0.f;
  uint cage_valid = 0u;
  [branch]
  if (source_weight != 0.f) {
    float3 cage_coord = SourceCoordinateCage(
        desired_coord, anchored_source_rgb, source_to_lms, curve,
        anchor_in_lms, anchor_out_lms, target_peak_lms, compression, mean_a2_weights,
        response_yf, target_gamut_mode, cage_valid);
    if (cage_valid != 0u) source_aware_coord = cage_coord;
  }

  float3 knee_coord = 0.f;
  uint solve_valid = 0u;
  [branch]
  if (source_weight != 1.f || cage_valid == 0u) {
    knee_coord = custom_psycho31_MapL8TargetDemand(
        desired_coord, response_yf, target_gamut_mode, normalized_demand);
    solve_valid = !any(isnan(knee_coord)) && !any(isinf(knee_coord)) ? 1u : 0u;
    if (cage_valid == 0u) {
      // Reuse the direct endpoint, including its finite-to-zero fallback at 1.
      source_aware_coord = solve_valid != 0u ? knee_coord : 0.f;
    }
  }
  float3 mapped_lms;
  [branch]
  if (source_weight == 1.f) {
    mapped_lms = psycho31_LMSFromTest30Coord(source_aware_coord, peak_value);
  } else {
    if (solve_valid == 0u) return 0.f;
    [branch]
    if (source_weight != 0.f) {
      knee_coord = lerp(knee_coord, source_aware_coord, source_weight);
    }
    mapped_lms = psycho31_LMSFromTest30Coord(knee_coord, peak_value);
  }
  float3 output_bt709 = mul(PSYCHO30_LMS_TO_BT709_MAT, lerp(desired_lms, mapped_lms, gamut_compression));
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709)) ? output_bt709 : 0.f;
}

}  // namespace anvil31
}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

float3 ApplyCustomAnvilEnginePsychoV31ToneMap(
    float3 untonemapped_ap1,
    float peak_value,
    float linear_slope,
    float toe_end,
    float toe_power,
    float toe_offset,
    float toe_flare,
    float shoulder_start,
    float mean_a2_shadow_source_weight = 1.f,
    float mean_a2_midgray_source_weight = 0.5f,
    float mean_a2_highlight_source_weight = 0.f,
    int target_gamut_mode = renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT2020,
    float compression = 1.5f,  // Trusted >=1, peak > shoulder_start; no auto mode.
    float gamut_compression = 1.f,
    int source_boundary = renodx::tonemap::psychov::PSYCHO30_SOURCE_BOUNDARY_AP1,
    float source_awareness = 1.f) {
  float3 finite_ap1_input = renodx::math::ZeroNaN(untonemapped_ap1);
  const float max_finite_input = 65504.f;  // Local infinity replacement, not a finite-value clamp.
  finite_ap1_input = renodx::math::Select(
      isinf(finite_ap1_input),
      renodx::math::CopySign(max_finite_input.xxx, finite_ap1_input),
      finite_ap1_input);
  float3 finite_bt709_input = renodx::math::ZeroNaN(renodx::color::bt709::from::AP1(finite_ap1_input));
  finite_bt709_input = renodx::math::Select(
      isinf(finite_bt709_input),
      renodx::math::CopySign(max_finite_input.xxx, finite_bt709_input),
      finite_bt709_input);

  // Keep the standard Test31 include untouched; all grade-dependent probes are local.
  renodx::tonemap::psychov::anvil31::Curve curve = {
    linear_slope, toe_end, toe_power, toe_offset, toe_flare
  };
  // Exact Anvil input anchor on the linear branch: requires positive slope
  // and shoulder_start >= toe_end (currently 1.625, .18 >= .05 => input .13).
  // A toe-region anchor needs the inverse of this custom toe, not this formula.
  // Continuous signed use additionally requires grade(0) == 0 (toe_offset 0
  // with the current enabled, positive-power toe); nonzero offsets are only
  // valid for strictly positive cone inputs/probes, not signed/zero crossings.
  float3 output_ap1 = renodx::color::ap1::from::BT709(
      renodx::tonemap::psychov::anvil31::Apply(
          finite_bt709_input,
          curve,
          toe_end + ((shoulder_start - toe_end) / linear_slope),
          shoulder_start,
          peak_value,
          gamut_compression,
          target_gamut_mode,
          compression,
          float3(mean_a2_shadow_source_weight, mean_a2_midgray_source_weight, mean_a2_highlight_source_weight),
          source_boundary,
          source_awareness));
  return !any(isnan(output_ap1)) && !any(isinf(output_ap1))
             ? output_ap1
             : 0.f.xxx;
}

float3 Psycho23ToAdaptiveRelativeWeightedLMS(
    float3 lms_input,
    float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 Psycho23FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 Psycho23GamutCompressAdaptiveRelativeWeightedLMSBound(
    float3 lms_weighted_relative_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  return renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
      lms_weighted_relative_input,
      current_adaptive_state_lms,
      bound_rgb_to_lms_weighted_mat,
      strength);
}

float3 BuildToneMapLUTOutput(float3 untonemapped_ap1, float exposure, float display_peak_nits, bool hdr_enabled) {
  untonemapped_ap1 /= 100.f;

  // The game uses twice the SDR exposure by default when HDR is enabled.
  float diffuse_white_nits = (exposure / 64.f) * 203.f;
  float target_peak_ratio = display_peak_nits / diffuse_white_nits;
  float3 tonemapped_bt709;

  if (RENODX_TONE_MAP_TYPE == 2.f) {
    int target_gamut_mode = renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT2020;
    if (!hdr_enabled) {
      target_peak_ratio = 1.f;
      target_gamut_mode = renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT709;
    }

    float linear_slope = 1.625f;
    float shoulder_start = 0.18f;
    float toe_end = 0.05f;
    float toe_power = 1.15f;
    float toe_offset = 0.f;
    float toe_flare = 0.1f * pow(0.875f, 10.f);

    float3 tonemapped_ap1 = ApplyCustomAnvilEnginePsychoV31ToneMap(
        untonemapped_ap1,
        target_peak_ratio,
        linear_slope,
        toe_end,
        toe_power,
        toe_offset,
        toe_flare,
        shoulder_start,
        1.f,
        0.5f,
        0.f,
        target_gamut_mode);
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

  } else {
    if (RENODX_GAME_GAMMA_CORRECTION != 0.f) {
      target_peak_ratio = renodx::color::correct::GammaSafe(target_peak_ratio, true);
    }

    float linear_slope = 1.5f;
    float shoulder_start = 0.5f;
    float toe_end = 0.05f;
    float toe_power = 1.f;
    float toe_offset = 0.f;
    if (!hdr_enabled) {
      target_peak_ratio = 1.f;
    }

    float3 tonemapped_ap1 = ApplyAnvilEngineToneMap(untonemapped_ap1, linear_slope, toe_end, toe_power, toe_offset, target_peak_ratio, shoulder_start);
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

    const float output_anchor = 0.18f;
    const float input_adaptive_anchor = toe_end + ((output_anchor - toe_end) / linear_slope);
    float3 input_adaptive_anchor_lms = renodx::color::lms::from::AP1(input_adaptive_anchor.xxx);
    float3 tonemapped_lms = renodx::color::lms::from::BT709(tonemapped_bt709);
    float3 tonemapped_relative_weighted = Psycho23ToAdaptiveRelativeWeightedLMS(
        tonemapped_lms,
        input_adaptive_anchor_lms);
    tonemapped_relative_weighted = Psycho23GamutCompressAdaptiveRelativeWeightedLMSBound(
        tonemapped_relative_weighted,
        input_adaptive_anchor_lms,
        hdr_enabled ? renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT
                    : renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
        1.f);
    tonemapped_bt709 = renodx::color::bt709::from::LMS(
        renodx::color::macleod_boynton::UnweighLMS(
            Psycho23FromAdaptiveRelativeWeightedLMS(
                tonemapped_relative_weighted,
                input_adaptive_anchor_lms)));

    if (RENODX_GAME_GAMMA_CORRECTION != 0.f) {
      tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
    }
  }

  if (hdr_enabled) {
    return renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), diffuse_white_nits);
  }
  return renodx::color::gamma::EncodeSafe(tonemapped_bt709);
}
