#ifndef RENODX_ELITEDANGEROUS_TONEMAP_PSYCHOV_TEST24_HLSL_
#define RENODX_ELITEDANGEROUS_TONEMAP_PSYCHOV_TEST24_HLSL_

#include "../common.hlsli"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx_custom {
namespace tonemap {
namespace psychov {

static const float PSYCHO24_EPSILON = 1e-6f;
static const float PSYCHO24_TWO_PI = 6.2831853071795864769f;
static const float PSYCHO24_REFERENCE_SIMULTANEOUS_RANGE_LOG10 = 3.7f;
static const float PSYCHO24_REFERENCE_CENTERED_RANGE_SIDE_COUNT = 2.f;
static const float PSYCHO24_HEADROOM_RATIO_FALLBACK = 1.f;
static const float PSYCHO24_MIN_AUTO_COMPRESSION = 1.f;
static const float PSYCHO24_MIN_MANUAL_COMPRESSION = 1e-6f;
static const float PSYCHO24_AUTO_COMPRESSION_SENTINEL = 0.f;
static const float PSYCHO24_HIGHLIGHT_GRADE_REFERENCE_WHITE = 1.f;
static const float PSYCHO24_SHADOW_GRADE_RANGE_STOPS = 4.f;

float psycho24_YfFromLMS(float3 lms) {
  float3 weighted_lms =
      renodx::color::macleod_boynton::WeighLMS(lms);
  return max(weighted_lms.x + weighted_lms.y, PSYCHO24_EPSILON);
}

float psycho24_QuinticUnitRamp(float t) {
  t = saturate(t);
  return t * t * t * (t * (t * 6.f - 15.f) + 10.f);
}

float psycho24_HighlightsScalarV4(
    float x,
    float highlights,
    float adapted_anchor_yf) {
  if (highlights == 1.f) {
    return x;
  }

  float t = 0.f;
  if (x > adapted_anchor_yf) {
    float reference_range_log2 = log2(
        PSYCHO24_HIGHLIGHT_GRADE_REFERENCE_WHITE
        / max(adapted_anchor_yf, PSYCHO24_EPSILON));
    t = saturate(
        log2(x / max(adapted_anchor_yf, PSYCHO24_EPSILON))
        / max(reference_range_log2, PSYCHO24_EPSILON));
  }
  t = psycho24_QuinticUnitRamp(t);

  float ratio = max(
      x / max(adapted_anchor_yf, PSYCHO24_EPSILON),
      PSYCHO24_EPSILON);
  if (highlights > 1.f) {
    return lerp(
        x,
        adapted_anchor_yf * pow(ratio, highlights),
        t);
  }

  float b = adapted_anchor_yf * pow(ratio, 2.f - highlights);
  return renodx::math::DivideSafe(x * x, lerp(x, b, t), x);
}

float psycho24_ShadowsScalarV4(
    float x,
    float shadows,
    float adapted_anchor_yf) {
  if (shadows == 1.f) {
    return x;
  }

  float ratio = max(
      renodx::math::DivideSafe(x, adapted_anchor_yf, 0.f),
      0.f);
  float base_term = x * adapted_anchor_yf;
  float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
  float shadow_floor =
      adapted_anchor_yf * exp2(-PSYCHO24_SHADOW_GRADE_RANGE_STOPS);

  float t = 1.f;
  if (x > shadow_floor) {
    t = saturate(
        log2(x / max(adapted_anchor_yf, PSYCHO24_EPSILON))
        / log2(
              shadow_floor
              / max(adapted_anchor_yf, PSYCHO24_EPSILON)));
  }
  t = psycho24_QuinticUnitRamp(t);

  if (shadows > 1.f) {
    float raised = x * (
        1.f + renodx::math::DivideSafe(
                  base_term,
                  pow(max(ratio, PSYCHO24_EPSILON), shadows),
                  0.f));
    float reference = x * (1.f + base_scale);
    return x + (raised - reference) * t;
  }

  float lowered = x * (
      1.f - renodx::math::DivideSafe(
                base_term,
                pow(max(ratio, PSYCHO24_EPSILON), 2.f - shadows),
                0.f));
  float reference = x * (1.f - base_scale);
  return x + (lowered - reference) * t;
}

float psycho24_AutoCompressionFromCenteredReferenceRange(
    float anchor_out_yf,
    float peak_yf) {
  float peak_over_anchor = renodx::math::DivideSafe(
      max(peak_yf, PSYCHO24_EPSILON),
      max(anchor_out_yf, PSYCHO24_EPSILON),
      PSYCHO24_HEADROOM_RATIO_FALLBACK);
  peak_over_anchor = max(
      peak_over_anchor,
      1.f + PSYCHO24_EPSILON);

  float reference_one_side_range_log10 =
      PSYCHO24_REFERENCE_SIMULTANEOUS_RANGE_LOG10
      / PSYCHO24_REFERENCE_CENTERED_RANGE_SIDE_COUNT;
  float actual_above_adaptation_range_log10 = max(
      log10(peak_over_anchor),
      PSYCHO24_EPSILON);
  return max(
      reference_one_side_range_log10
          / actual_above_adaptation_range_log10,
      PSYCHO24_MIN_AUTO_COMPRESSION);
}

float3 psycho24_ToAdaptiveRelativeWeightedLMS(
    float3 lms_input,
    float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho24_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative
      * max(current_adaptive_state_lms, PSYCHO24_EPSILON.xxx);
}

float3 psycho24_GamutCompressAdaptiveRelativeWeightedLMSBound(
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

float3 psycho24_ApplyOKLabGamutHueDirection(
        float3 gamut_mapped_bt709,
        float3 pre_gamut_bt709,
        int gamut_compression_mode) {
    float3 mapped_oklab = renodx::color::oklab::from::BT709(gamut_mapped_bt709);
    float3 source_oklab = renodx::color::oklab::from::BT709(pre_gamut_bt709);

    float mapped_radius2 = dot(mapped_oklab.yz, mapped_oklab.yz);
    float source_radius2 = dot(source_oklab.yz, source_oklab.yz);
    if (mapped_radius2 <= PSYCHO24_EPSILON
            || source_radius2 <= PSYCHO24_EPSILON) {
        return gamut_mapped_bt709;
    }

    float mapped_radius = sqrt(mapped_radius2);
    float2 source_direction = source_oklab.yz * rsqrt(source_radius2);

    float3 hue_restored_oklab = mapped_oklab;
    hue_restored_oklab.yz = source_direction * mapped_radius;
    float3 hue_restored_bt709 =
            renodx::color::bt709::from::OkLab(hue_restored_oklab);
    float3 hue_restored_bound_rgb = gamut_compression_mode == 1
                                                                            ? renodx::color::bt2020::from::BT709(
                                                                                        hue_restored_bt709)
                                                                            : hue_restored_bt709;

    if (min(hue_restored_bound_rgb.x,
                    min(hue_restored_bound_rgb.y, hue_restored_bound_rgb.z)) < 0.f) {
        float radius_inside = 0.f;
        float radius_outside = mapped_radius;

        [unroll]
        for (int i = 0; i < 10; ++i) {
            float radius_test = 0.5f * (radius_inside + radius_outside);
            float3 test_oklab = mapped_oklab;
            test_oklab.yz = source_direction * radius_test;
            float3 test_bt709 = renodx::color::bt709::from::OkLab(test_oklab);
            float3 test_bound_rgb = gamut_compression_mode == 1
                                                                    ? renodx::color::bt2020::from::BT709(
                                                                                test_bt709)
                                                                    : test_bt709;

            if (min(test_bound_rgb.x,
                            min(test_bound_rgb.y, test_bound_rgb.z)) >= 0.f) {
                radius_inside = radius_test;
            } else {
                radius_outside = radius_test;
            }
        }

        hue_restored_oklab.yz = source_direction * radius_inside;
        hue_restored_bt709 =
                renodx::color::bt709::from::OkLab(hue_restored_oklab);
    }

    float mapped_yf = psycho24_YfFromLMS(
            renodx::color::lms::from::BT709(gamut_mapped_bt709));
    float restored_yf = psycho24_YfFromLMS(
            renodx::color::lms::from::BT709(hue_restored_bt709));
    return hue_restored_bt709
            * renodx::math::DivideSafe(mapped_yf, restored_yf, 1.f);
}

float3 psycho24_ApplyAdaptiveMBPurity(
    float3 lms_input,
    float3 adaptive_neutral_lms,
    float purity_delta) {
  if (abs(purity_delta - 1.f) <= 1e-5f) {
    return lms_input;
  }

  float3 relative_weighted =
      psycho24_ToAdaptiveRelativeWeightedLMS(
          lms_input,
          adaptive_neutral_lms);
  float3 mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          relative_weighted);
  float3 mb_neutral =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(
      mb_neutral.xy,
      mb.xy,
      purity_delta);
  float3 relative_weighted_out =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          float3(mb_scaled_xy, mb.z));
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho24_FromAdaptiveRelativeWeightedLMS(
          relative_weighted_out,
          adaptive_neutral_lms));
}

// Position: source adaptive MacLeod-Boynton hue phase.
// Parameters: x = final direct
// normalize(lerp(compressed_direction, source_direction, x)) fraction; no V17
// sensitivity or global hue-restore multiplier.
// y = inactive Phase 2 placeholder (semantics not yet chosen).
static const uint PSYCHO_MANUAL_HUE_COUNT = 23u;
static const float PSYCHO_MANUAL_HUE_POSITION[PSYCHO_MANUAL_HUE_COUNT] = {
    0.01071375f, 0.10705012f, 0.12795984f, 0.15335225f, 0.18766853f, 0.22076293f,
    0.24936653f, 0.27634237f, 0.29474511f, 0.31129214f, 0.35078118f, 0.39136371f,
    0.47262991f, 0.49426816f, 0.54698948f, 0.60705013f, 0.68311772f, 0.81129214f,
    0.91306421f, 0.93498424f, 0.94625976f, 0.96664602f, 0.97262991f,
};
static const float2 PSYCHO_MANUAL_HUE_PARAMETERS[PSYCHO_MANUAL_HUE_COUNT] = {
    float2(0.517681f, 0.500000f),  // rose
    float2(0.675575f, 0.500000f),  // magenta
    float2(0.691365f, 0.500000f),  // fuchsia
    float2(0.691365f, 0.500000f),  // orchid
    float2(0.665049f, 0.500000f),  // purple
    float2(0.680839f, 0.500000f),  // violet
    float2(0.661513f, 0.500000f),  // indigo
    float2(0.654523f, 0.500000f),  // blue-violet
    float2(0.648355f, 0.500000f),  // ultramarine
    float2(0.640461f, 0.500000f),  // blue
    float2(0.556250f, 0.500000f),  // azure
    float2(0.519408f, 0.500000f),  // sky
    float2(0.450987f, 0.500000f),  // cyan
    float2(0.435197f, 0.500000f),  // teal
    float2(0.424671f, 0.500000f),  // spring
    float2(0.464145f, 0.500000f),  // green
    float2(0.516776f, 0.500000f),  // chartreuse
    float2(0.608882f, 0.500000f),  // yellow
    float2(0.690461f, 0.500000f),  // amber
    float2(0.606250f, 0.500000f),  // skin
    float2(0.553618f, 0.500000f),  // orange
    float2(0.514145f, 0.500000f),  // vermilion
    float2(0.482566f, 0.500000f),  // red
};

float psycho24_SampleManualHueLinearity(float source_hue_phase) {
  source_hue_phase -= floor(source_hue_phase);

  uint lower_index = PSYCHO_MANUAL_HUE_COUNT - 1u;
  [unroll]
  for (uint i = 0u; i < PSYCHO_MANUAL_HUE_COUNT; ++i) {
    if (source_hue_phase >= PSYCHO_MANUAL_HUE_POSITION[i]) {
      lower_index = i;
    }
  }

  uint upper_index = (lower_index + 1u) % PSYCHO_MANUAL_HUE_COUNT;
  float lower_position = PSYCHO_MANUAL_HUE_POSITION[lower_index];
  float upper_position = upper_index == 0u
                             ? PSYCHO_MANUAL_HUE_POSITION[0] + 1.f
                             : PSYCHO_MANUAL_HUE_POSITION[upper_index];
  if (upper_index == 0u && source_hue_phase < lower_position) {
    source_hue_phase += 1.f;
  }

  float t = saturate(renodx::math::DivideSafe(
      source_hue_phase - lower_position,
      upper_position - lower_position,
      0.f));
  return lerp(
      PSYCHO_MANUAL_HUE_PARAMETERS[lower_index].x,
      PSYCHO_MANUAL_HUE_PARAMETERS[upper_index].x,
      t);
}

float3 psycho24_ApplyManualHueDirection(
    float3 compressed_lms,
    float3 direction_source_lms,
    float3 current_adaptive_state_lms,
    float to_white_progress) {
  float3 compressed_relative_weighted =
      psycho24_ToAdaptiveRelativeWeightedLMS(
          compressed_lms,
          current_adaptive_state_lms);
  float3 source_relative_weighted =
      psycho24_ToAdaptiveRelativeWeightedLMS(
          direction_source_lms,
          current_adaptive_state_lms);

  float3 compressed_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          compressed_relative_weighted);
  float3 source_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          source_relative_weighted);
  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;

  float2 compressed_offset = compressed_mb.xy - adapted_neutral_mb;
  float2 source_offset = source_mb.xy - adapted_neutral_mb;
  float compressed_radius2 = dot(compressed_offset, compressed_offset);
  float source_radius2 = dot(source_offset, source_offset);
  if (compressed_radius2 <= PSYCHO24_EPSILON * PSYCHO24_EPSILON
      || source_radius2 <= PSYCHO24_EPSILON * PSYCHO24_EPSILON) {
    return compressed_lms;
  }

  float source_hue_phase =
      atan2(source_offset.y, source_offset.x) / PSYCHO24_TWO_PI;
  source_hue_phase -= floor(source_hue_phase);
  float amount = lerp(
      1.f,
      psycho24_SampleManualHueLinearity(source_hue_phase),
      saturate(to_white_progress));

  float compressed_radius = sqrt(compressed_radius2);
  float2 compressed_direction = compressed_offset / compressed_radius;
  float2 source_direction = source_offset * rsqrt(source_radius2);
  float2 output_direction = lerp(compressed_direction, source_direction, amount);
  float output_direction2 = dot(output_direction, output_direction);
  if (output_direction2 <= PSYCHO24_EPSILON * PSYCHO24_EPSILON) {
    return compressed_lms;
  }
  output_direction *= rsqrt(output_direction2);

  float3 restored_mb = float3(
      adapted_neutral_mb + output_direction * compressed_radius,
      compressed_mb.z);
  float3 restored_relative_weighted =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          restored_mb);
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho24_FromAdaptiveRelativeWeightedLMS(
          restored_relative_weighted,
          current_adaptive_state_lms));
}

// Test24 keeps Test23 grading, adaptive-MB purity, contrast, compression,
// CopySign, and gamut/output stages. Its only model change is replacing the
// pre-gamut OKLab hue operation with the authored adaptive-MB interpolation.
float3 psychotm_test24(float3 bt709_linear_input, float peak_value = 1000.f / 203.f,
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
                       float adaptive_normalization = 1.f,
                       float compression = 1.f,
                       float highlight_saturation = 1.f,
                       float gamut_hue_restore = 0.f) {
  float legacy_response_scale = cone_response_exponent * adaptation_contrast;
  contrast *= legacy_response_scale;
  purity_scale *= legacy_response_scale;

  float3 lms_in =
      renodx::color::lms::from::BT709(bt709_linear_input * exposure);
  float3 lms_peak =
      renodx::color::lms::from::BT709(float(peak_value).xxx);
  float3 current_adaptive_state_lms =
      renodx::color::lms::from::BT709(current_adaptive_state_bt709);
  float3 desired_background_state_lms =
      renodx::color::lms::from::BT709(current_background_state_bt709);

  float3 lms_cones = lms_in;
    float3 anchor_in = max(current_adaptive_state_lms, PSYCHO24_EPSILON.xxx);
    float3 anchor_out = max(desired_background_state_lms, PSYCHO24_EPSILON.xxx);
    float contrast_power = max(contrast, PSYCHO24_EPSILON);

  float3 graded_lms = abs(lms_cones);
  float graded_yf = psycho24_YfFromLMS(graded_lms);
  float adapted_anchor_yf = psycho24_YfFromLMS(anchor_in);
  float graded_yf_out =
      psycho24_HighlightsScalarV4(
          graded_yf,
          highlights,
          adapted_anchor_yf);
  graded_yf_out = psycho24_ShadowsScalarV4(
      graded_yf_out,
      shadows,
      adapted_anchor_yf);
  graded_lms *= renodx::math::DivideSafe(
      graded_yf_out,
      graded_yf,
      1.f);

  float purity_delta = renodx::math::DivideSafe(
      max(purity_scale, PSYCHO24_EPSILON),
      contrast_power,
      1.f);
  float3 contrast_input =
      psycho24_ApplyAdaptiveMBPurity(
          graded_lms,
          anchor_in,
          purity_delta);

  float3 contrast_ratio =
      max(contrast_input / anchor_in, PSYCHO24_EPSILON.xxx);
  float3 contrast_lms =
      anchor_out * pow(contrast_ratio, contrast_power);

  float compression_power = compression;
  if (compression == PSYCHO24_AUTO_COMPRESSION_SENTINEL) {
    compression_power = psycho24_AutoCompressionFromCenteredReferenceRange(
        psycho24_YfFromLMS(anchor_out),
        psycho24_YfFromLMS(lms_peak));
  }
  compression_power = max(
      compression_power,
      PSYCHO24_MIN_MANUAL_COMPRESSION);

  float3 anchor_over_peak =
      anchor_out / max(lms_peak, PSYCHO24_EPSILON.xxx);
  float3 compression_slope_norm =
      1.f - pow(
                max(anchor_over_peak, PSYCHO24_EPSILON.xxx),
                compression_power);
  float3 compression_input = pow(
      max(contrast_lms / anchor_out, PSYCHO24_EPSILON.xxx),
      compression_power
          / max(compression_slope_norm, PSYCHO24_EPSILON.xxx));
  float3 compression_white_offset =
      pow(
          max(lms_peak / anchor_out, PSYCHO24_EPSILON.xxx),
          compression_power)
      - 1.f;
  float3 compression_rolloff = pow(
      compression_input
          / max(
                compression_input + compression_white_offset,
                PSYCHO24_EPSILON.xxx),
      rcp(compression_power));
  float3 compressed_lms = lms_peak * compression_rolloff;
  float to_white_progress = max(
      compression_rolloff.x,
      max(compression_rolloff.y, compression_rolloff.z));

  float3 hue_restored_lms = psycho24_ApplyManualHueDirection(
      compressed_lms,
      contrast_input,
      current_adaptive_state_lms,
      to_white_progress);
  float3 display_scaled =
      renodx::math::CopySign(hue_restored_lms, lms_cones);
  float3 display_scaled_relative_weighted =
      psycho24_ToAdaptiveRelativeWeightedLMS(
          display_scaled,
          current_adaptive_state_lms);

  if (gamut_compression != 0.f) {
    if (gamut_compression_mode == 0) {
      display_scaled_relative_weighted =
          psycho24_GamutCompressAdaptiveRelativeWeightedLMSBound(
              display_scaled_relative_weighted,
              current_adaptive_state_lms,
              renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
              gamut_compression);
    } else if (gamut_compression_mode == 1) {
      display_scaled_relative_weighted =
          psycho24_GamutCompressAdaptiveRelativeWeightedLMSBound(
              display_scaled_relative_weighted,
              current_adaptive_state_lms,
              renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
              gamut_compression);
    }
  }

  float3 final_bt709 = renodx::color::bt709::from::LMS(
      renodx::color::macleod_boynton::UnweighLMS(
          psycho24_FromAdaptiveRelativeWeightedLMS(
              display_scaled_relative_weighted,
              current_adaptive_state_lms)));

  if (gamut_compression != 0.f && gamut_hue_restore != 0.f) {
    float3 pre_gamut_bt709 =
        renodx::color::bt709::from::LMS(display_scaled);
    float3 hue_fixed_bt709 = psycho24_ApplyOKLabGamutHueDirection(
        final_bt709,
        pre_gamut_bt709,
        gamut_compression_mode);
    final_bt709 = lerp(
        final_bt709,
        hue_fixed_bt709,
        saturate(gamut_hue_restore));
  }

  return final_bt709;
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_ELITEDANGEROUS_TONEMAP_PSYCHOV_TEST24_HLSL_