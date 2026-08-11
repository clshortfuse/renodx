#include "../common.hlsli"
#include "./psychov25/test25.hlsli"
#include "./test24.hlsli"

static const float MID_GRAY_IN = 0.119121851127f;
static const float MID_GRAY_OUT = 0.163979921774f;
static const float MID_GRAY_SLOPE = 1.95752308422f;

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

#define CONTRAST_AND_FLARE_GENERATOR(T)                                                                       \
  T ContrastAndFlare(T x, float contrast, float flare, T mid_gray_in = (T)0.18f, T mid_gray_out = (T)0.18f) { \
    T x_normalized = x / mid_gray_in;                                                                         \
    T flare_ratio = (T)1.f + renodx::math::DivideSafe(flare, x_normalized + flare, (T)0.f);                   \
    return pow(x_normalized, contrast * flare_ratio) * mid_gray_out;                                          \
  }

CONTRAST_AND_FLARE_GENERATOR(float)
CONTRAST_AND_FLARE_GENERATOR(float3)
#undef CONTRAST_AND_FLARE_GENERATOR

float3 ApplyLuminanceGradingLMS(float3 color_lms, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float yf = max(0.f, renodx::color::yf::from::LMS(color_lms));
  float yf_adjusted = yf * exposure;
  yf_adjusted = renodx::color::grade::Highlights(yf_adjusted, highlights, mid_gray_yf);
  yf_adjusted = renodx::color::grade::Shadows(yf_adjusted, shadows, mid_gray_yf);
  yf_adjusted = ContrastAndFlare(yf_adjusted, contrast, flare, mid_gray_yf, mid_gray_yf);
  return color_lms * renodx::math::DivideSafe(yf_adjusted, yf, 1.f);
}

float3 ApplyLuminanceGradingBT2020(float3 color_bt2020, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyLuminanceGradingLMS(color_lms, exposure, highlights, shadows, contrast, flare, mid_gray_yf);
  return renodx::color::bt2020::from::LMS(color_lms);
}

float3 ApplyPurityGradingLMS(float3 color_lms, float purity_scale, float highlight_saturation, float dechroma, float3 adaptive_neutral_lms = 0.18f) {
  if (purity_scale == 1.f && highlight_saturation == 1.f && dechroma == 0.f) return color_lms;

  if (dechroma != 0.f || highlight_saturation != 1.f) {
    float luminance = renodx::color::yf::from::LMS(color_lms);
    float neutral_luminance = renodx::color::yf::from::LMS(adaptive_neutral_lms);

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

    if (highlight_saturation != 1.f) {
      // Blend smootherstep squared and cubed for a later, gentler C2 progression.
      float highlight_rolloff = rolloff * rolloff * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
      purity_scale *= mad(highlight_saturation - 1.f, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
    }
  }

  if (purity_scale != 1.f) {
    color_lms = ApplyAdaptiveMBPurity(color_lms, adaptive_neutral_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyPurityGradingBT2020(float3 color_bt2020, float purity_scale, float highlight_saturation, float dechroma) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyPurityGradingLMS(color_lms, purity_scale, highlight_saturation, dechroma, renodx::color::lms::from::BT2020(0.18f.xxx));
  return renodx::color::bt2020::from::LMS(color_lms);
}

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

/// Identity at and below anchor; C-infinity generalized Naka-Rushton above it.
/// Requires anchor < peak, compression_power > 1, and 0 < response_coefficient <= 1.
#define APPLY_CINFINITY_NAKA_RUSHTON_GENERATOR(T)                                                                              \
  T ApplyCInfinityNakaRushton(T color, T peak, T anchor, float compression_power = 1.f, float response_coefficient = 0.001f) { \
    float inverse_compression_power = rcp(compression_power);                                                                  \
    float flat_response_numerator = -1.f / log(2.f) * response_coefficient;                                                    \
    T shoulder_range = peak - anchor;                                                                                          \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                                      \
    T position = distance_from_anchor / shoulder_range;                                                                        \
    T position_power = pow(position, compression_power);                                                                       \
    T flat_response = exp2(flat_response_numerator * rcp(mad(position_power, position_power, position_power)));                \
    T response_scale = pow(mad(position_power, flat_response, (T)1.f), -inverse_compression_power);                            \
    return mad(distance_from_anchor, response_scale, color - distance_from_anchor);                                            \
  }
APPLY_CINFINITY_NAKA_RUSHTON_GENERATOR(float)
APPLY_CINFINITY_NAKA_RUSHTON_GENERATOR(float3)
#undef APPLY_CINFINITY_NAKA_RUSHTON_GENERATOR

// Fixed PsychoV25 target-hull path: Fast60 hue guidance, Reference Scale,
// full BT.2020 lower/upper-plane enforcement, and a black upper-hull pivot.
float3 CompressPsychoV25ReferenceScaleHull(
    float3 desired_lms,
    float3 direction_source_lms,
    float3 adaptive_state_lms,
    float3 background_state_lms,
    float3 target_lms_peak,
    float source_direction_recovery_strength,
    float naka_rushton_compression,
    float cinfinity_shoulder_compression,
    int white_curve_mode,
    float cone_response_exponent,
    float peak_value) {
  float3 desired_weighted_lms = renodx::color::macleod_boynton::WeighLMS(desired_lms);
  float desired_yf = desired_weighted_lms.x + desired_weighted_lms.y;
  if (desired_yf <= renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    return 0.f.xxx;
  }

  float adaptive_yf = renodx::tonemap::psychov::psycho25_YfFromLMS(adaptive_state_lms);
  float background_yf = renodx::tonemap::psychov::psycho25_YfFromLMS(background_state_lms);
  float target_peak_yf = renodx::tonemap::psychov::psycho25_SignedYfFromLMS(target_lms_peak);
  float3 physical_compressed_lms;
  [branch]
  if (white_curve_mode == 1) {
    renodx::tonemap::psychov::Psycho25ConeResponseParameters cone_response =
        renodx::tonemap::psychov::psycho25_PrepareConeResponseParameters(
            background_state_lms,
            target_lms_peak,
            cone_response_exponent,
            naka_rushton_compression,
            1.f);
    renodx::tonemap::psychov::Psycho25ConeResponseState response_state =
        renodx::tonemap::psychov::psycho25_BuildConeResponseState(
            desired_lms,
            cone_response);
    float3 normalized_response = response_state.encoded_response
                                 / (abs(response_state.encoded_response)
                                    + response_state.encoded_peak_offset);
    float3 compressed_response = cone_response.inverse_compression_power == 1.f
                                     ? normalized_response
                                     : renodx::math::SignPow(
                                           normalized_response,
                                           cone_response.inverse_compression_power);
    physical_compressed_lms = target_lms_peak * compressed_response;
  } else {
    physical_compressed_lms = ApplyAnchoredCInfinityShoulder(
        desired_lms,
        target_lms_peak,
        background_state_lms,
        cinfinity_shoulder_compression);
  }
  float authored_yf = renodx::tonemap::psychov::psycho25_YfFromLMS(physical_compressed_lms);
  if (authored_yf <= renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    return 0.f.xxx;
  }

  float3 safe_adaptive_state_lms = max(
      adaptive_state_lms,
      renodx::tonemap::psychov::PSYCHO25_EPSILON.xxx);
  float2 adapted_neutral_mb = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float3 authored_mb = renodx::color::macleod_boynton::from::WeightedLMS(
      renodx::tonemap::psychov::psycho25_ToAdaptiveRelativeWeightedLMS(
          physical_compressed_lms,
          adaptive_state_lms));
  float3 source_mb = renodx::color::macleod_boynton::from::WeightedLMS(
      renodx::tonemap::psychov::psycho25_ToAdaptiveRelativeWeightedLMS(
          direction_source_lms,
          adaptive_state_lms));

  // Fast60: retain physical radius and use the angular midpoint between the
  // source direction and the raw per-cone-compressed direction.
  float2 authored_offset = authored_mb.xy - adapted_neutral_mb;
  float2 source_offset = source_mb.xy - adapted_neutral_mb;
  float authored_radius2 = dot(authored_offset, authored_offset);
  float source_radius2 = dot(source_offset, source_offset);
  if (authored_radius2 > renodx::tonemap::psychov::PSYCHO25_EPSILON
                             * renodx::tonemap::psychov::PSYCHO25_EPSILON
      && source_radius2 > renodx::tonemap::psychov::PSYCHO25_EPSILON
                              * renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    float2 source_direction = source_offset * rsqrt(source_radius2);
    float2 compressed_direction = authored_offset * rsqrt(authored_radius2);
    float2 output_direction = lerp(
        source_direction,
        compressed_direction,
        1.f - renodx::tonemap::psychov::PSYCHO25_HUE_AMPLITUDE);
    float output_direction2 = dot(output_direction, output_direction);
    if (output_direction2 > renodx::tonemap::psychov::PSYCHO25_EPSILON
                                * renodx::tonemap::psychov::PSYCHO25_EPSILON) {
      authored_mb.xy = adapted_neutral_mb
                       + output_direction * rsqrt(output_direction2) * sqrt(authored_radius2);
      authored_offset = authored_mb.xy - adapted_neutral_mb;
      authored_radius2 = dot(authored_offset, authored_offset);
    }
  }

  float authored_radius = sqrt(authored_radius2);
  float2 authored_direction = authored_offset * rsqrt(authored_radius2 + renodx::tonemap::psychov::PSYCHO25_EPSILON * renodx::tonemap::psychov::PSYCHO25_EPSILON);

  // Reference Scale source-direction recovery keeps collapsing saturated
  // highlights from rotating through an unrelated hue on their way to white.
  [branch]
  if (source_direction_recovery_strength > 0.f) {
    float source_radius = sqrt(source_radius2);
    float2 source_direction = source_offset * rsqrt(source_radius2 + renodx::tonemap::psychov::PSYCHO25_EPSILON * renodx::tonemap::psychov::PSYCHO25_EPSILON);
    float source_radius_support =
        renodx::tonemap::psychov::psycho25_TargetLowerPlaneRadiusForDirection(
            source_direction,
            adapted_neutral_mb,
            adaptive_state_lms,
            1);
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
    float source_direction_weight = source_direction_recovery_strength
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
  // adaptive-MB direction and radius before solving the BT.2020 hull.
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
  // the nonnegative BT.2020 primary half-spaces without a component clamp.
  if (authored_radius > renodx::tonemap::psychov::PSYCHO25_EPSILON) {
    float3 neutral_target_rgb =
        renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(neutral_lms, 1);
    float3 current_target_rgb =
        renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(unit_yf_lms, 1);
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
        renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(reference_lms, 1);
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

  // Black-pivot upper-plane shoulder along the contained BT.2020 hue ray.
  float3 unit_target_rgb =
      renodx::tonemap::psychov::psycho25_TargetRGBFromLMS(unit_yf_lms, 1);
  float max_target_channel = max(
      unit_target_rgb.x,
      max(unit_target_rgb.y, unit_target_rgb.z));
  float directional_yf_limit = peak_value / max_target_channel;
  float normalized_input = desired_yf * renodx::math::DivideSafe(target_peak_yf, directional_yf_limit, 1.f);
  float normalized_output;
  [branch]
  if (white_curve_mode == 1) {
    normalized_output = ApplyCInfinityNakaRushton(
        normalized_input,
        target_peak_yf,
        background_yf,
        naka_rushton_compression,
        0.001f);
  } else {
    normalized_output = ApplyAnchoredCInfinityShoulder(
        normalized_input,
        target_peak_yf,
        background_yf,
        cinfinity_shoulder_compression);
  }
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
    float source_direction_recovery_strength = 0.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    int white_curve_mode = 0,
    float naka_rushton_compression = 0.f,
    float cinfinity_shoulder_compression = 1.5f) {
  float3 finite_bt709_input = renodx::math::ZeroNaN(bt709_linear_input);
  finite_bt709_input = renodx::math::Select(
      isinf(finite_bt709_input),
      renodx::math::CopySign(65504.f.xxx, finite_bt709_input),
      finite_bt709_input);

  float3 lms_in = renodx::color::lms::from::BT709(finite_bt709_input);
  float3 current_adaptive_state_lms =
      renodx::color::lms::from::BT709(current_adaptive_state_bt709);
  float3 current_background_state_lms =
      renodx::color::lms::from::BT709(current_background_state_bt709);
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

  float naka_rushton_compression_power = naka_rushton_compression;
  if (white_curve_mode == 1) {
    if (naka_rushton_compression == renodx::tonemap::psychov::PSYCHO25_AUTO_COMPRESSION_SENTINEL) {
      naka_rushton_compression_power = renodx::tonemap::psychov::psycho25_AutoCompressionFromCenteredReferenceRange(
          renodx::tonemap::psychov::psycho25_YfFromLMS(current_background_state_lms),
          renodx::tonemap::psychov::psycho25_YfFromLMS(target_lms_peak));
    }
    naka_rushton_compression_power = max(
        naka_rushton_compression_power,
        renodx::tonemap::psychov::PSYCHO25_MIN_MANUAL_COMPRESSION);
  }

  float3 output_lms = CompressPsychoV25ReferenceScaleHull(
      contrast_lms,
      contrast_input,
      current_adaptive_state_lms,
      current_background_state_lms,
      target_lms_peak,
      source_direction_recovery_strength,
      naka_rushton_compression_power,
      cinfinity_shoulder_compression,
      white_curve_mode,
      cone_response_exponent,
      peak_value);
  return renodx::color::bt709::from::LMS(output_lms);
}

/// Elite Dangerous vanilla SDR tonemapper.
/// Output is in gamma space.
#define APPLY_VANILLA_TONEMAP_GENERATOR(T)                        \
  T ApplyVanillaTonemap(T untonemapped, float N4 = -1.274e-7f) {  \
    const float N0 = 8.46800041f;                                 \
    const float N1 = 1.0f;                                        \
    const float N2 = -0.00295699993f;                             \
    const float N3 = 0.000100400001f;                             \
                                                                  \
    const float D0 = 8.3604002f;                                  \
    const float D1 = 1.82270002f;                                 \
    const float D2 = 0.218899995f;                                \
    const float D3 = -0.00211700005f;                             \
    const float D4 = 3.67300017e-5f;                              \
                                                                  \
    T x = untonemapped;                                           \
    T numerator = (((x * N0 + N1) * x + N2) * x + N3) * x + N4;   \
    T denominator = (((x * D0 + D1) * x + D2) * x + D3) * x + D4; \
    return max((T)0.0f, numerator / denominator);                 \
  }

APPLY_VANILLA_TONEMAP_GENERATOR(float)
APPLY_VANILLA_TONEMAP_GENERATOR(float3)
#undef APPLY_VANILLA_TONEMAP_GENERATOR

#define APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(T)                                            \
  T ApplyExtendedVanillaTonemap(T x, float sdr_blend_strength = 0.f) {                         \
    const float INFLECTION_X = 0.119121851127f;                                                \
    const float INFLECTION_Y = 0.163979921774f;                                                \
    const float INFLECTION_SLOPE = 1.95752308422f;                                             \
                                                                                               \
    /* N4 = 0 removes the black clip. */                                                       \
    T vanilla_gamma = ApplyVanillaTonemap(x, 0.f);                                             \
    T vanilla_linear = pow(vanilla_gamma, 2.2f);                                               \
                                                                                               \
    T extended_linear = INFLECTION_Y + INFLECTION_SLOPE * (x - INFLECTION_X);                  \
                                                                                               \
    T restored_linear = lerp(extended_linear, vanilla_linear, sdr_blend_strength);             \
                                                                                               \
    T output_linear = renodx::math::Select(x > INFLECTION_X, restored_linear, vanilla_linear); \
                                                                                               \
    return max((T)0.f, output_linear);                                                         \
  }

APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(float)
APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(float3)
#undef APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR

float3 ApplyPreLUTToneMapAndGammaEncode(float3 untonemapped) {
  float3 tonemapped_gamma;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped_gamma = ApplyVanillaTonemap(untonemapped);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    float sdr_blend_strength = 0.f;
    float3 tonemapped = ApplyExtendedVanillaTonemap(untonemapped, sdr_blend_strength);
    if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
      float perch_yf = renodx::color::yf::from::BT709(tonemapped);
      float lum_yf = ApplyExtendedVanillaTonemap(renodx::color::yf::from::BT709(untonemapped), sdr_blend_strength);
      tonemapped = renodx::color::correct::Luminance(tonemapped, perch_yf, lum_yf);
    }
    tonemapped_gamma = renodx::color::gamma::Encode(tonemapped, 2.2f);
  } else {
    tonemapped_gamma = renodx::color::gamma::Encode(max(0, untonemapped), 2.2f);
  }

  return tonemapped_gamma;
}

float3 ApplyLUT(float3 lut_input_gamma, Texture3D<float4> lut_texture, SamplerState lut_sampler, float texel_size, float lut_strength) {
  if (CUSTOM_LUT_STRENGTH == 0.f || lut_strength == 0.f) return lut_input_gamma;

  float3 lut_input_linear = renodx::color::gamma::Decode(lut_input_gamma, 2.2f);

  float maxch_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
      maxch_scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(lut_input_linear, 1.f, MID_GRAY_OUT, 1.5f);
    } else {  // Custom
      maxch_scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(lut_input_linear, 1.f, MID_GRAY_IN, 1.5f);
    }
    lut_input_linear *= maxch_scale;
    lut_input_gamma = renodx::color::gamma::Encode(lut_input_linear, 2.2f);
  }

  float3 lut_output_gamma;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    lut_output_gamma = lut_texture.Sample(lut_sampler, saturate(lut_input_gamma) * (1 - texel_size) + (0.5 * texel_size)).rgb;  // LUT
  } else {
    lut_output_gamma = renodx::lut::SampleTetrahedral(lut_texture, lut_input_gamma, uint(1.f / texel_size));
  }
  lut_output_gamma = lerp(lut_input_gamma, lut_output_gamma, lut_strength * CUSTOM_LUT_STRENGTH);  // Blend in LUT as a percentage

  float3 lut_output_linear = renodx::color::gamma::Decode(lut_output_gamma, 2.2f) / maxch_scale;

  return renodx::color::gamma::Encode(lut_output_linear, 2.2f);
}

float3 ApplyPostLUTToneMap(float3 untonemapped_gamma) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped_gamma;

  float3 untonemapped = renodx::color::gamma::DecodeSafe(untonemapped_gamma, 2.2f);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
    untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

    // Apply BT.2020 luminance and purity grading.
    untonemapped = ApplyLuminanceGradingBT2020(untonemapped,
                                               1.f,
                                               RENODX_TONE_MAP_HIGHLIGHTS,
                                               RENODX_TONE_MAP_SHADOWS,
                                               RENODX_TONE_MAP_CONTRAST,
                                               0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                               MID_GRAY_OUT);
    untonemapped = ApplyPurityGradingBT2020(untonemapped,
                                            RENODX_TONE_MAP_SATURATION,
                                            RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
                                            RENODX_TONE_MAP_DECHROMA);
    untonemapped = max(untonemapped, 1e-7f);

    tonemapped = ApplyAnchoredCInfinityShoulder(untonemapped, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, MID_GRAY_OUT, 1.5f);
    tonemapped = renodx::color::bt709::from::BT2020(tonemapped);
  } else {  // Custom

    tonemapped = ApplyCustomPsychoV25ToneMap(
        untonemapped,
        RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        1.55f * RENODX_TONE_MAP_CONTRAST,
        0.10f * pow(0.85f, 10.f) + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        RENODX_TONE_MAP_DECHROMA,
        0.f,
        MID_GRAY_IN,
        MID_GRAY_OUT,
        0, 1.f, 1.5f);
  }

  return renodx::color::gamma::EncodeSafe(tonemapped, 2.2f);
}
