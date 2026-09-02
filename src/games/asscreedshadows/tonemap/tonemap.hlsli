#include "../common.hlsli"

struct ImmortalsToneMapConfig {
  float slope;
  float toe_threshold;
  float toe_slope;
  float black_offset;
  float peak_luminance;
  float shoulder_start;
  float shoulder_scale;
  float shoulder_overage;
  bool has_toe;
};

ImmortalsToneMapConfig CreateImmortalsToneMapConfig(
    float slope,
    float toe_threshold,
    float shoulder_start,
    float toe_slope,
    float black_offset,
    float peak_nits) {
  ImmortalsToneMapConfig config;
  config.slope = slope;
  config.toe_threshold = toe_threshold;
  config.toe_slope = toe_slope;
  config.black_offset = black_offset;
  config.peak_luminance = peak_nits * 0.00999999977648258209228515625f;
  config.has_toe = config.toe_threshold > 9.9999997473787516355514526367188e-06f;

  float toe_to_peak_range = mad(peak_nits, 0.00999999977648258209228515625f, -config.toe_threshold);
  float shoulder_start_output = mad(toe_to_peak_range, shoulder_start, config.toe_threshold);
  config.shoulder_start = ((toe_to_peak_range * shoulder_start) / config.slope) + config.toe_threshold;
  config.shoulder_scale = (config.peak_luminance * config.slope) / mad(peak_nits, 0.00999999977648258209228515625f, -shoulder_start_output);
  config.shoulder_overage = mad(-peak_nits, 0.00999999977648258209228515625f, shoulder_start_output);
  return config;
}

#define IMMORTALS_TONEMAP_GENERATOR(T)                                                                                                                                                                       \
  T ApplyImmortalsToneMap(T untonemapped_ap1, ImmortalsToneMapConfig config, out T precompression_ap1) {                                                                                                     \
    T input_scaled = abs(untonemapped_ap1 * 0.00999999977648258209228515625f);                                                                                                                               \
    T toe_ratio = input_scaled / config.toe_threshold;                                                                                                                                                       \
    T toe_ratio_sat = saturate(toe_ratio);                                                                                                                                                                   \
    T toe_ratio_sat_sq = toe_ratio_sat * toe_ratio_sat;                                                                                                                                                      \
    T toe_smooth = mad(toe_ratio_sat, -2.f, 3.f);                                                                                                                                                            \
    T in_shoulder = renodx::math::Select(input_scaled > config.shoulder_start, (T)1.f, (T)0.f);                                                                                                              \
    T toe_curve = renodx::math::Select(config.has_toe, mad(exp2(log2(abs(toe_ratio)) * config.toe_slope), config.toe_threshold, config.black_offset), config.black_offset);                                  \
    T toe_weight = mad(-toe_smooth, toe_ratio_sat_sq, 1.f);                                                                                                                                                  \
    T linear_curve = mad(input_scaled - config.toe_threshold, config.slope, config.toe_threshold);                                                                                                           \
    T linear_weight = mad(toe_smooth, toe_ratio_sat_sq, -1.f) + 1.f;                                                                                                                                         \
    T precompression_curve = (toe_weight * toe_curve) + (linear_weight * linear_curve);                                                                                                                      \
    T shoulder_curve = config.peak_luminance + (exp2(((config.shoulder_scale * (input_scaled - config.shoulder_start)) / config.peak_luminance) * (-1.44269502162933349609375f)) * config.shoulder_overage); \
    precompression_ap1 = precompression_curve * 100.f;                                                                                                                                                       \
    return lerp(precompression_curve, shoulder_curve, in_shoulder) * 100.f;                                                                                                                                  \
  }                                                                                                                                                                                                          \
  T ApplyImmortalsToneMap(T untonemapped_ap1, ImmortalsToneMapConfig config) {                                                                                                                               \
    T precompression_ap1;                                                                                                                                                                                    \
    return ApplyImmortalsToneMap(untonemapped_ap1, config, precompression_ap1);                                                                                                                              \
  }

IMMORTALS_TONEMAP_GENERATOR(float)
IMMORTALS_TONEMAP_GENERATOR(float3)
#undef IMMORTALS_TONEMAP_GENERATOR

static const float PSYCHO23_LOCAL_EPSILON = 1e-6f;
static const float PSYCHO23_LOCAL_REFERENCE_SIMULTANEOUS_RANGE_LOG10 = 3.7f;
static const float PSYCHO23_LOCAL_REFERENCE_CENTERED_RANGE_SIDE_COUNT = 2.f;
static const float PSYCHO23_LOCAL_HEADROOM_RATIO_FALLBACK = 1.f;
static const float PSYCHO23_LOCAL_MIN_AUTO_COMPRESSION = 1.f;

// Empirical signed-opponent appearance controls from PsychoV23.
static const float PSYCHO23_LOCAL_RED_RETENTION = 1.5f;
static const float PSYCHO23_LOCAL_GREEN_RETENTION = 2.f;
static const float PSYCHO23_LOCAL_BLUE_RETENTION = 1.f;
static const float PSYCHO23_LOCAL_YELLOW_RETENTION = 3.f;

float Psycho23YfFromLMS(float3 lms) {
  float3 weighted_lms = renodx::color::macleod_boynton::WeighLMS(lms);
  return max(weighted_lms.x + weighted_lms.y, PSYCHO23_LOCAL_EPSILON);
}

float Psycho23AutoCompressionFromCenteredReferenceRange(float anchor_out_yf, float peak_yf) {
  float peak_over_anchor = renodx::math::DivideSafe(
      max(peak_yf, PSYCHO23_LOCAL_EPSILON),
      max(anchor_out_yf, PSYCHO23_LOCAL_EPSILON),
      PSYCHO23_LOCAL_HEADROOM_RATIO_FALLBACK);
  peak_over_anchor = max(peak_over_anchor, 1.f + PSYCHO23_LOCAL_EPSILON);

  float reference_one_side_range_log10 =
      PSYCHO23_LOCAL_REFERENCE_SIMULTANEOUS_RANGE_LOG10
      / PSYCHO23_LOCAL_REFERENCE_CENTERED_RANGE_SIDE_COUNT;
  float actual_above_adaptation_range_log10 =
      max(log10(peak_over_anchor), PSYCHO23_LOCAL_EPSILON);

  return max(
      reference_one_side_range_log10 / actual_above_adaptation_range_log10,
      PSYCHO23_LOCAL_MIN_AUTO_COMPRESSION);
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

float3 Psycho23AdaptiveRelativeWeightedNeutral() {
  return renodx::color::macleod_boynton::WeighLMS(1.f.xxx);
}

float3 Psycho23OpponentACCFromWeightedDelta(float3 delta_weighted_lms) {
  float3 neutral_weighted = Psycho23AdaptiveRelativeWeightedNeutral();
  float m_to_l = renodx::math::DivideSafe(
      neutral_weighted.x,
      neutral_weighted.y,
      0.f);
  float s_to_lm = renodx::math::DivideSafe(
      neutral_weighted.x + neutral_weighted.y,
      neutral_weighted.z,
      0.f);

  return float3(
      delta_weighted_lms.x + delta_weighted_lms.y,
      delta_weighted_lms.x - m_to_l * delta_weighted_lms.y,
      -delta_weighted_lms.x - delta_weighted_lms.y
          + s_to_lm * delta_weighted_lms.z);
}

float3 Psycho23WeightedDeltaFromOpponentACC(float3 acc) {
  float3 neutral_weighted = Psycho23AdaptiveRelativeWeightedNeutral();
  float m_to_l = renodx::math::DivideSafe(
      neutral_weighted.x,
      neutral_weighted.y,
      0.f);
  float s_to_lm = renodx::math::DivideSafe(
      neutral_weighted.x + neutral_weighted.y,
      neutral_weighted.z,
      0.f);

  float delta_m = renodx::math::DivideSafe(acc.x - acc.y, 1.f + m_to_l, 0.f);
  float delta_l = acc.x - delta_m;
  float delta_s = renodx::math::DivideSafe(acc.z + acc.x, s_to_lm, 0.f);
  return float3(delta_l, delta_m, delta_s);
}

float Psycho23SignedOpponentRetention(float white_progress, float retention_exponent) {
  return 1.f - pow(saturate(white_progress), max(retention_exponent, PSYCHO23_LOCAL_EPSILON));
}

float3 Psycho23ApplySignedOpponentRetention(
    float3 compressed_lms,
    float3 source_lms,
    float3 adaptive_state_lms,
    float3 peak_lms,
    float white_progress) {
  if (white_progress <= 0.f
      || min(source_lms.x, min(source_lms.y, source_lms.z)) <= 0.f) {
    return compressed_lms;
  }

  float3 source_weighted = Psycho23ToAdaptiveRelativeWeightedLMS(
      source_lms,
      adaptive_state_lms);
  float3 adapted_neutral = Psycho23AdaptiveRelativeWeightedNeutral();
  float adapted_neutral_yf = adapted_neutral.x + adapted_neutral.y;
  float source_yf = source_weighted.x + source_weighted.y;

  if (source_yf <= PSYCHO23_LOCAL_EPSILON
      || adapted_neutral_yf <= PSYCHO23_LOCAL_EPSILON) {
    return compressed_lms;
  }

  float3 source_neutral = adapted_neutral
                          * renodx::math::DivideSafe(source_yf, adapted_neutral_yf, 1.f);
  float3 source_acc =
      Psycho23OpponentACCFromWeightedDelta(source_weighted - source_neutral)
      / source_yf;

  float red_retention = Psycho23SignedOpponentRetention(
      white_progress,
      PSYCHO23_LOCAL_RED_RETENTION);
  float green_retention = Psycho23SignedOpponentRetention(
      white_progress,
      PSYCHO23_LOCAL_GREEN_RETENTION);
  float blue_retention = Psycho23SignedOpponentRetention(
      white_progress,
      PSYCHO23_LOCAL_BLUE_RETENTION);
  float yellow_retention = Psycho23SignedOpponentRetention(
      white_progress,
      PSYCHO23_LOCAL_YELLOW_RETENTION);

  float rg_out = max(source_acc.y, 0.f) * red_retention
                 - max(-source_acc.y, 0.f) * green_retention;
  float yv_out = max(source_acc.z, 0.f) * blue_retention
                 - max(-source_acc.z, 0.f) * yellow_retention;

  float3 compressed_weighted = Psycho23ToAdaptiveRelativeWeightedLMS(
      compressed_lms,
      adaptive_state_lms);
  float target_yf = compressed_weighted.x + compressed_weighted.y;
  if (target_yf <= PSYCHO23_LOCAL_EPSILON) {
    return compressed_lms;
  }

  float3 peak_weighted = Psycho23ToAdaptiveRelativeWeightedLMS(
      peak_lms,
      adaptive_state_lms);
  float peak_weighted_yf = peak_weighted.x + peak_weighted.y;
  if (peak_weighted_yf <= PSYCHO23_LOCAL_EPSILON) {
    return compressed_lms;
  }

  float3 target_neutral = peak_weighted * renodx::math::DivideSafe(target_yf, peak_weighted_yf, 1.f);
  float3 target_delta = Psycho23WeightedDeltaFromOpponentACC(
      float3(0.f, rg_out * target_yf, yv_out * target_yf));
  float3 output_lms = renodx::color::macleod_boynton::UnweighLMS(
      Psycho23FromAdaptiveRelativeWeightedLMS(
          target_neutral + target_delta,
          adaptive_state_lms));

  float compressed_yf = Psycho23YfFromLMS(compressed_lms);
  float output_yf = Psycho23YfFromLMS(output_lms);
  if (output_yf <= PSYCHO23_LOCAL_EPSILON) {
    return compressed_lms;
  }

  return output_lms * renodx::math::DivideSafe(compressed_yf, output_yf, 1.f);
}

float3 ApplyPsycho23SignedOpponentRetentionAndGamutCompressionLMS(
    float3 precompression_lms,
    float3 compressed_lms,
    float3 input_adaptive_state_lms,
    float3 output_anchor_lms,
    float3 peak_white_lms,
    float3x3 gamut_bound_rgb_to_lms_weighted_mat,
    float hue_restore = 1.f,
    float gamut_compression = 1.f) {
  float anchor_yf = Psycho23YfFromLMS(output_anchor_lms);
  float peak_yf = Psycho23YfFromLMS(peak_white_lms);
  float output_yf = Psycho23YfFromLMS(compressed_lms);

  // Test23 measures white convergence in the compression power domain. Derive
  // the same progress from the actual Immortals output instead of assuming its
  // shoulder follows PsychoV's analytic compression curve.
  float compression_power = Psycho23AutoCompressionFromCenteredReferenceRange(
      anchor_yf,
      peak_yf);
  float anchor_over_peak = saturate(renodx::math::DivideSafe(anchor_yf, peak_yf, 1.f));
  float output_over_peak = max(renodx::math::DivideSafe(output_yf, peak_yf, 0.f), 0.f);
  float anchor_powered = pow(max(anchor_over_peak, 1e-6f), compression_power);
  float white_progress = saturate(renodx::math::DivideSafe(
      pow(output_over_peak, compression_power) - anchor_powered,
      1.f - anchor_powered,
      0.f));

  float3 opponent_retained_lms = Psycho23ApplySignedOpponentRetention(
      compressed_lms,
      precompression_lms,
      input_adaptive_state_lms,
      peak_white_lms,
      white_progress);
  float3 hue_restored_lms = lerp(
      compressed_lms,
      opponent_retained_lms,
      saturate(hue_restore));

  float3 display_relative_weighted = Psycho23ToAdaptiveRelativeWeightedLMS(
      hue_restored_lms,
      input_adaptive_state_lms);

  if (gamut_compression != 0.f) {
    display_relative_weighted = Psycho23GamutCompressAdaptiveRelativeWeightedLMSBound(
        display_relative_weighted,
        input_adaptive_state_lms,
        gamut_bound_rgb_to_lms_weighted_mat,
        gamut_compression);
  }

  return renodx::color::macleod_boynton::UnweighLMS(
      Psycho23FromAdaptiveRelativeWeightedLMS(
          display_relative_weighted,
          input_adaptive_state_lms));
}

float3 BuildToneMapLUTOutput(float3 untonemapped_ap1, float exposure, float display_peak_nits, bool hdr_enabled) {
  // The game uses twice the SDR exposure by default when HDR is enabled.
  float diffuse_white_nits = (exposure / 92.f) * 203.f;
  float target_peak_ratio = display_peak_nits / diffuse_white_nits;
  float3 tonemapped_bt709;

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // Enhanced
    if (!hdr_enabled) {
      target_peak_ratio = 1.f;
    }
    float slope = 1.25f;
    float shoulder_start = 0.50f;
    float toe_threshold = 0.13f;
    float toe_slope = 1.00f;
    float black_offset = 0.f;
    ImmortalsToneMapConfig config = CreateImmortalsToneMapConfig(
        slope,
        toe_threshold,
        shoulder_start,
        toe_slope,
        black_offset,
        target_peak_ratio * 100.f);

    float3 ap1_white_lms = renodx::color::lms::from::AP1(1.f.xxx);
    float3 untonemapped_lms = max(renodx::color::lms::from::AP1(untonemapped_ap1), 0.f);
    float3 precompression_lms;
    float3 tonemapped_relative_lms =
        ApplyImmortalsToneMap(
            untonemapped_lms / ap1_white_lms,
            config,
            precompression_lms)
        / 100.f;

    // Run the flare on white-normalized LMS here.
    const float flare_pivot = 0.125f;
    const float flare = 0.0045f;
    float flare_pivot_ratio = saturate(max(tonemapped_relative_lms.x, max(tonemapped_relative_lms.y, tonemapped_relative_lms.z)) / flare_pivot);
    float flare_mask = 1.f - flare_pivot_ratio * flare_pivot_ratio * (3.f - 2.f * flare_pivot_ratio);
    tonemapped_relative_lms = float3(
        ContrastAndFlare(tonemapped_relative_lms.x, 1.f, 1.f, 1.f, flare * flare_mask, flare_pivot),
        ContrastAndFlare(tonemapped_relative_lms.y, 1.f, 1.f, 1.f, flare * flare_mask, flare_pivot),
        ContrastAndFlare(tonemapped_relative_lms.z, 1.f, 1.f, 1.f, flare * flare_mask, flare_pivot));

    float3 tonemapped_lms = tonemapped_relative_lms * ap1_white_lms;

    precompression_lms = precompression_lms / 100.f * ap1_white_lms;

    // The curve has no isolated inflection between its convex toe and concave shoulder.
    // Fix the output anchor at SDR midgray and solve its input anchor from the linear section.
    const float output_anchor = 0.18f;
    const float input_adaptive_anchor = 100.f * (toe_threshold + ((output_anchor - toe_threshold) / slope));
    float3 input_adaptive_anchor_lms = renodx::color::lms::from::AP1(input_adaptive_anchor.xxx);
    float3 output_anchor_lms = renodx::color::lms::from::AP1(output_anchor.xxx);
    float3 peak_white_lms = target_peak_ratio * ap1_white_lms;

    tonemapped_lms = ApplyPsycho23SignedOpponentRetentionAndGamutCompressionLMS(
        precompression_lms,
        tonemapped_lms,
        input_adaptive_anchor_lms,
        output_anchor_lms,
        peak_white_lms,
        hdr_enabled ? renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT
                    : renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
        1.f,
        1.f);
    tonemapped_bt709 = renodx::color::bt709::from::LMS(tonemapped_lms);
  } else {  // Vanilla+
    if (RENODX_GAME_GAMMA_CORRECTION != 0.f) {
      target_peak_ratio = renodx::color::correct::GammaSafe(target_peak_ratio, true);
    }

    float slope = 1.25f;
    float shoulder_start = 0.50f;
    float toe_threshold = 0.13f;
    float toe_slope = 1.00f;
    float black_offset = 0.f;
    if (!hdr_enabled) {
      target_peak_ratio = 1.f;
    }

    ImmortalsToneMapConfig config = CreateImmortalsToneMapConfig(
        slope,
        toe_threshold,
        shoulder_start,
        toe_slope,
        black_offset,
        target_peak_ratio * 100.f);
    float3 tonemapped_ap1 = ApplyImmortalsToneMap(untonemapped_ap1, config) / 100.f;
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

    const float output_anchor = 0.18f;
    const float input_adaptive_anchor =
        100.f * (toe_threshold + ((output_anchor - toe_threshold) / slope));
    float3 input_adaptive_anchor_lms =
        renodx::color::lms::from::AP1(input_adaptive_anchor.xxx);
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
