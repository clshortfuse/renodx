#include "../common.hlsl"
#include "./adaptation.hlsl"

RWTexture1D<uint> renodx_eye_adaptation_histogram : register(u1, space50);

struct HDRData {
  float HDRData_000;
  float HDRData_004;
  int HDRData_008;
  int HDRData_012;
};

struct HDR_HistogramReadLightAdapt_Data {
  float HDR_HistogramReadLightAdapt_Data_000;
  float HDR_HistogramReadLightAdapt_Data_004;
  float HDR_HistogramReadLightAdapt_Data_008;
  float HDR_HistogramReadLightAdapt_Data_012;
  int HDR_HistogramReadLightAdapt_Data_016;
  int HDR_HistogramReadLightAdapt_Data_020;
  int HDR_HistogramReadLightAdapt_Data_024;
  int HDR_HistogramReadLightAdapt_Data_028;
};

RWStructuredBuffer<uint> u0_space4 : register(u0, space4);

RWStructuredBuffer<float4> u1_space4 : register(u1, space4);

RWTexture2D<float> u2_space4 : register(u2, space4);

RWByteAddressBuffer u3_space4 : register(u3, space4);

cbuffer cb0_space4 : register(b0, space4) {
  HDRData Data_000 : packoffset(c000.x);
};

cbuffer cb1_space4 : register(b1, space4) {
  HDR_HistogramReadLightAdapt_Data LightAdaptData_000 : packoffset(c000.x);
};

struct StarfieldPsychoVHistogramState {
  int black_count;
  int positive_count;
  float field_yf;
  bool field_valid;
  bool ran_this_frame;
  bool black_reset;
};

struct StarfieldPsychoVTransportWrite {
  float current_yf;
  float target_yf;
  float raw_target_yf;
  float exposure_gain;
  float expected_current_yf;
  float history_field_yf;
  float history_target_yf;
  float history_fast_yf;
  float history_slow_yf;
  float history_valid;
  float history_frame_time;
  float history_magic;
  uint flags;
  float gap;
#ifndef NDEBUG
  float debug_field_yf;
#endif
};

StarfieldPsychoVHistogramState StarfieldReadPsychoVHistogramState() {
  StarfieldPsychoVHistogramState histogram;
  histogram.black_count = 0;
  histogram.positive_count = 0;
  histogram.field_yf = 0.0f;
  histogram.field_valid = false;
  histogram.ran_this_frame = CUSTOM_EYE_ADAPTATION_HISTOGRAM_COUNT > 0.5f;
  histogram.black_reset = false;

  const int histogram_bin_count = (int)custom::adaptation::v1::HISTOGRAM_BIN_COUNT;
  [loop]
  for (int bin_index = 0; bin_index < histogram_bin_count; ++bin_index) {
    int bin_count = (int)renodx_eye_adaptation_histogram[bin_index];
    if (bin_index == 0) {
      histogram.black_count += bin_count;
    } else {
      histogram.positive_count += bin_count;
    }
  }

  histogram.black_reset = histogram.ran_this_frame
                          && histogram.black_count > 0
                          && histogram.positive_count == 0;

  // Bin 0 is the black/invalid bucket and is intentionally excluded from
  // the field luminance average below. Do not let it consume the percentile
  // window either, otherwise black letterbox/interior regions can put the
  // whole 20%-80% band inside bin 0 and leave sum_weight at zero.
  float percentile_count = max(1.0f, (float)histogram.positive_count);
  float remaining_lo = percentile_count * custom::adaptation::v1::HISTOGRAM_PERCENTILE_LOW;
  float remaining_hi = percentile_count * custom::adaptation::v1::HISTOGRAM_PERCENTILE_HIGH;
  float sum_log = 0.0f;
  float sum_weight = 0.0f;

  [loop]
  for (int bin_index = 1; bin_index < histogram_bin_count; ++bin_index) {
    float bin_count = (float)((int)renodx_eye_adaptation_histogram[bin_index]);
    float skip = min(remaining_lo, bin_count);
    float after_skip = bin_count - skip;
    float window = max(0.0f, remaining_hi - skip);
    float take = min(window, after_skip);

    if (take > 0.0f) {
      float log_yf = custom::adaptation::v1::DecodeHistogramLog2Luminance((float)((uint)bin_index));
      sum_log += take * log_yf;
      sum_weight += take;
    }

    remaining_lo -= skip;
    remaining_hi = window - take;
  }

  if (sum_weight > 0.0f) {
    histogram.field_yf = exp2(sum_log / max(sum_weight, custom::adaptation::v1::MIN_VALID_YF));
  }

  histogram.field_valid = !isnan(histogram.field_yf)
                          && !isinf(histogram.field_yf)
                          && (histogram.field_yf > 0.0f);
  return histogram;
}

uint StarfieldBuildPsychoVTransportFlags(
    bool field_valid,
    bool transport_has_history,
    bool has_filtered_target_history,
    bool previous_field_valid,
    bool previous_history_frame_valid,
    bool temporal_continuity,
    bool baseline_this_frame,
    bool predicted_field_valid,
    bool histogram_usable_this_frame,
    bool freeze_to_history,
    bool vanilla_histogram_reset_signal,
    bool black_histogram_reset_signal) {
  uint transport_flags = 0u;
#ifdef NDEBUG
  if (temporal_continuity) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TEMPORAL_CONTINUITY;
  if (baseline_this_frame) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BASELINE;
#else
  if (field_valid) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FIELD_VALID;
  if (transport_has_history) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TRANSPORT_HISTORY;
  if (has_filtered_target_history) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FILTERED_TARGET;
  if (previous_field_valid) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREVIOUS_FIELD_VALID;
  if (previous_history_frame_valid) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREVIOUS_FRAME_VALID;
  if (temporal_continuity) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TEMPORAL_CONTINUITY;
  if (baseline_this_frame) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BASELINE;
  if (predicted_field_valid) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_PREDICTED_FIELD_VALID;
  if (histogram_usable_this_frame) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_HISTOGRAM_USABLE;
  if (freeze_to_history) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FREEZE_TO_HISTORY;
  if (vanilla_histogram_reset_signal) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_VANILLA_HDR_RESET;
  if (black_histogram_reset_signal) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BLACK_RESET;
#endif
  return transport_flags;
}

void StarfieldStorePsychoVTransport(StarfieldPsychoVTransportWrite transport) {
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_CURRENT_AVG_OFFSET, transport.current_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_TARGET_AVG_OFFSET, transport.target_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_RAW_TARGET_OFFSET, transport.raw_target_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_EXPOSURE_GAIN_OFFSET, transport.exposure_gain);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_EXPECTED_U3_CURRENT_OFFSET, transport.expected_current_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FIELD_OFFSET, transport.history_field_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_TARGET_OFFSET, transport.history_target_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FAST_OFFSET, transport.history_fast_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_SLOW_OFFSET, transport.history_slow_yf);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET, transport.history_valid);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FRAME_OFFSET, transport.history_frame_time);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET, transport.history_magic);
#ifndef NDEBUG
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_DEBUG_FIELD_OFFSET, transport.debug_field_yf);
#endif
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_FLAGS_OFFSET, (float)transport.flags);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_GAP_OFFSET, transport.gap);
}

[numthreads(1, 1, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  if (CUSTOM_EYE_ADAPTATION_PERCEPTUAL) {
    float fixed_delta_time = CUSTOM_FRAME_DELTA_TIME > 0.0f
                                 ? CUSTOM_FRAME_DELTA_TIME
                                 : (1.0f / 60.0f);
    float vanilla_histogram_min_log2 = Data_000.HDRData_000;
    float vanilla_histogram_max_log2 = Data_000.HDRData_004;
    bool vanilla_histogram_reset_signal = abs(vanilla_histogram_min_log2) <= renodx::math::FLT_EPSILON
                                          && abs(vanilla_histogram_max_log2) <= renodx::math::FLT_EPSILON;
    StarfieldPsychoVHistogramState histogram_state = StarfieldReadPsychoVHistogramState();
    bool histogram_ran_this_frame = histogram_state.ran_this_frame;
    bool black_histogram_reset_signal = histogram_state.black_reset;
    float field_y = histogram_state.field_yf;
    bool field_valid = histogram_state.field_valid;

    const float history_magic_expected = RENODX_EYE_ADAPTATION_HISTORY_MAGIC_EXPECTED;
    float history_valid_raw = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET);
    float history_magic_raw = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET);
    bool transport_has_history = (history_valid_raw > 0.5f)
                                 && !isnan(history_valid_raw)
                                 && !isinf(history_valid_raw)
                                 && !isnan(history_magic_raw)
                                 && !isinf(history_magic_raw)
                                 && (abs(history_magic_raw - history_magic_expected) < 0.125f)
                                 && !vanilla_histogram_reset_signal
                                 && !black_histogram_reset_signal;

    bool has_history = transport_has_history;
    float previous_filtered_target = 0.0f;
    float previous_fast_eqbg = 0.0f;
    float previous_slow_eqbg = 0.0f;
    float previous_field_yf = 0.0f;
    float previous_history_frame_time = 0.0f;

    if (transport_has_history) {
      previous_filtered_target = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_TARGET_OFFSET);
      previous_fast_eqbg = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FAST_OFFSET);
      previous_slow_eqbg = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_SLOW_OFFSET);
      previous_field_yf = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FIELD_OFFSET);
      previous_history_frame_time = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FRAME_OFFSET);
    }

    bool has_filtered_target_history = has_history
                                       && !isnan(previous_filtered_target)
                                       && !isinf(previous_filtered_target)
                                       && (previous_filtered_target > 0.0f);

    float smoothed_target_yf = field_valid ? field_y : 0.0f;
    if (CUSTOM_EYE_ADAPTATION_TARGET_SMOOTHING > 0.0f && has_filtered_target_history && field_valid) {
      float target_smooth_tau = max(CUSTOM_EYE_ADAPTATION_TARGET_SMOOTHING, custom::adaptation::v1::MIN_VALID_YF);
      float target_smooth_alpha = 1.0f - exp(-fixed_delta_time / target_smooth_tau);
      float log_prev_target = log2(max(previous_filtered_target, custom::adaptation::v1::MIN_VALID_YF));
      float log_cur_target = log2(max(smoothed_target_yf, custom::adaptation::v1::MIN_VALID_YF));
      smoothed_target_yf = exp2(lerp(log_prev_target, log_cur_target, target_smooth_alpha));
    }

    float target_average_yf = max(smoothed_target_yf, 0.0f);
    if (CUSTOM_EYE_ADAPTATION_MIN_BRIGHTNESS > 0.0f) {
      target_average_yf = max(target_average_yf, CUSTOM_EYE_ADAPTATION_MIN_BRIGHTNESS);
    }
    if (CUSTOM_EYE_ADAPTATION_MAX_BRIGHTNESS > 0.0f) {
      target_average_yf = min(target_average_yf, CUSTOM_EYE_ADAPTATION_MAX_BRIGHTNESS);
    }

    bool previous_fast_valid = has_history && !isnan(previous_fast_eqbg) && !isinf(previous_fast_eqbg);
    bool previous_slow_valid = has_history && !isnan(previous_slow_eqbg) && !isinf(previous_slow_eqbg);
    bool previous_field_valid = has_history && !isnan(previous_field_yf) && !isinf(previous_field_yf) && (previous_field_yf > 0.0f);
    bool previous_history_frame_valid = has_history
                                        && !isnan(previous_history_frame_time)
                                        && !isinf(previous_history_frame_time)
                                        && (previous_history_frame_time >= 0.0f);
    float current_frame_time = max(CUSTOM_FRAME_TIME, 0.0f);
    float history_frame_gap = current_frame_time - previous_history_frame_time;
    bool temporal_continuity = has_history
                               && (fixed_delta_time > 0.0f)
                               && (fixed_delta_time <= custom::adaptation::v1::MAX_CONTINUITY_SECONDS);
    if (transport_has_history) {
      temporal_continuity = temporal_continuity
                            && previous_history_frame_valid
                            && !isnan(current_frame_time)
                            && !isinf(current_frame_time)
                            && (current_frame_time >= previous_history_frame_time)
                            && (history_frame_gap >= 0.0f)
                            && (history_frame_gap <= custom::adaptation::v1::MAX_CONTINUITY_SECONDS);
    }

    float previous_current_state_yf = target_average_yf;
    if (previous_field_valid) {
      previous_current_state_yf = previous_field_yf;
      if (previous_fast_valid) {
        previous_current_state_yf += previous_fast_eqbg;
      }
      if (previous_slow_valid) {
        previous_current_state_yf += previous_slow_eqbg;
      }
    }
    if (!(previous_current_state_yf > 0.0f)) {
      previous_current_state_yf = target_average_yf;
    }

    bool histogram_usable_this_frame = histogram_ran_this_frame && field_valid && !black_histogram_reset_signal;
    bool baseline_this_frame = histogram_usable_this_frame && (!temporal_continuity || !previous_field_valid);
    bool freeze_to_history = !histogram_usable_this_frame && has_history;
    if (black_histogram_reset_signal) {
      uint transport_flags = 0u;
#ifndef NDEBUG
      transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BLACK_RESET;
#endif

      StarfieldPsychoVTransportWrite transport;
      transport.current_yf = custom::adaptation::v1::NEUTRAL_YF;
      transport.target_yf = custom::adaptation::v1::NEUTRAL_YF;
      transport.raw_target_yf = custom::adaptation::v1::NEUTRAL_YF;
      transport.exposure_gain = 1.0f;
      transport.expected_current_yf = custom::adaptation::v1::NEUTRAL_YF;
      transport.history_field_yf = custom::adaptation::v1::NEUTRAL_YF;
      transport.history_target_yf = custom::adaptation::v1::NEUTRAL_YF;
      transport.history_fast_yf = 0.0f;
      transport.history_slow_yf = 0.0f;
      transport.history_valid = 0.0f;
      transport.history_frame_time = current_frame_time;
      transport.history_magic = history_magic_expected;
      transport.flags = transport_flags;
      transport.gap = 0.0f;
#ifndef NDEBUG
      transport.debug_field_yf = field_y;
#endif
      StarfieldStorePsychoVTransport(transport);
    } else if (freeze_to_history) {
      float frozen_history_target_yf = has_filtered_target_history
                                           ? previous_filtered_target
                                           : previous_current_state_yf;
      float frozen_history_field_yf = previous_field_valid ? previous_field_yf : frozen_history_target_yf;
      float frozen_history_fast_eqbg_yf = previous_fast_valid ? previous_fast_eqbg : 0.0f;
      float frozen_history_slow_eqbg_yf = previous_slow_valid ? previous_slow_eqbg : 0.0f;
      float frozen_output_current_yf = previous_current_state_yf;
      float frozen_output_target_yf = frozen_history_target_yf;
      float frozen_output_raw_target_yf = frozen_history_target_yf;
      float frozen_output_exposure_gain = renodx::math::DivideSafe(
          frozen_output_target_yf,
          frozen_output_current_yf,
          1.0f);

      uint transport_flags = StarfieldBuildPsychoVTransportFlags(
          field_valid,
          transport_has_history,
          has_filtered_target_history,
          previous_field_valid,
          previous_history_frame_valid,
          temporal_continuity,
          false,
          false,
          histogram_usable_this_frame,
          freeze_to_history,
          vanilla_histogram_reset_signal,
          black_histogram_reset_signal);

      if (CUSTOM_DEBUG_INSPECT_RESIDUALS) {
        frozen_output_current_yf = frozen_history_fast_eqbg_yf;
        frozen_output_target_yf = frozen_history_slow_eqbg_yf;
        frozen_output_raw_target_yf = frozen_output_target_yf;
        frozen_output_exposure_gain = 0.0f;
      } else if (CUSTOM_DEBUG_INSPECT_PREV_FIELD) {
        frozen_output_current_yf = frozen_history_field_yf;
        frozen_output_target_yf = frozen_history_target_yf;
        frozen_output_raw_target_yf = frozen_output_target_yf;
        frozen_output_exposure_gain = renodx::math::DivideSafe(
            frozen_output_target_yf,
            frozen_output_current_yf,
            1.0f);
      }

      StarfieldPsychoVTransportWrite transport;
      transport.current_yf = frozen_output_current_yf;
      transport.target_yf = frozen_output_target_yf;
      transport.raw_target_yf = frozen_output_raw_target_yf;
      transport.exposure_gain = frozen_output_exposure_gain;
      transport.expected_current_yf = previous_current_state_yf;
      transport.history_field_yf = frozen_history_field_yf;
      transport.history_target_yf = frozen_history_target_yf;
      transport.history_fast_yf = frozen_history_fast_eqbg_yf;
      transport.history_slow_yf = frozen_history_slow_eqbg_yf;
      transport.history_valid = 1.0f;
      transport.history_frame_time = current_frame_time;
      transport.history_magic = history_magic_expected;
      transport.flags = transport_flags;
      transport.gap = history_frame_gap;
#ifndef NDEBUG
      transport.debug_field_yf = field_y;
#endif
      StarfieldStorePsychoVTransport(transport);
    } else {
      float solve_target_yf = histogram_usable_this_frame ? smoothed_target_yf : target_average_yf;
      float predicted_field_yf = max(solve_target_yf, custom::adaptation::v1::MIN_VALID_YF);
      bool predicted_field_valid = !isnan(solve_target_yf) && !isinf(solve_target_yf) && (solve_target_yf > 0.0f);

      float current_state_yf = predicted_field_yf;
      if (!temporal_continuity) {
        current_state_yf = predicted_field_yf;
      } else if (!previous_field_valid) {
        current_state_yf = predicted_field_yf;
      } else if (!predicted_field_valid) {
        current_state_yf = previous_current_state_yf;
      } else {
        bool brightening = predicted_field_yf > previous_current_state_yf;
        float tau_fast = max(CUSTOM_EYE_ADAPTATION_DARK_TO_LIGHT, 0.10000000149011612f);
        float tau_slow = max(CUSTOM_EYE_ADAPTATION_LIGHT_TO_DARK, 0.10000000149011612f);
        float tau_state = tau_fast;
        if (!brightening) {
          float previous_state_td = max(previous_current_state_yf, 0.0f) * RENODX_DIFFUSE_WHITE_NITS * 4.0f;
          float bleached_fraction = previous_state_td / (previous_state_td + 20000.0f);
          tau_state = lerp(tau_fast, tau_slow, saturate(bleached_fraction));
        }
        float state_alpha = 1.0f - exp(-fixed_delta_time / tau_state);
        float previous_log = log2(previous_current_state_yf);
        float target_log = log2(predicted_field_yf);
        current_state_yf = exp2(lerp(previous_log, target_log, state_alpha));
      }

      float state_delta_yf = current_state_yf - predicted_field_yf;
      float fast_eqbg_yf = min(state_delta_yf, 0.0f);
      float slow_eqbg_yf = max(state_delta_yf, 0.0f);
      current_state_yf = max(predicted_field_yf + fast_eqbg_yf + slow_eqbg_yf, custom::adaptation::v1::MIN_VALID_YF);

      float history_field_yf = predicted_field_yf;
      float history_target_yf = solve_target_yf;
      float history_fast_eqbg_yf = fast_eqbg_yf;
      float history_slow_eqbg_yf = slow_eqbg_yf;
      uint transport_flags = StarfieldBuildPsychoVTransportFlags(
          field_valid,
          transport_has_history,
          has_filtered_target_history,
          previous_field_valid,
          previous_history_frame_valid,
          temporal_continuity,
          baseline_this_frame,
          predicted_field_valid,
          histogram_usable_this_frame,
          freeze_to_history,
          vanilla_histogram_reset_signal,
          black_histogram_reset_signal);

      float output_current_yf = current_state_yf;
      float output_target_yf = target_average_yf;
      float output_raw_target_yf = smoothed_target_yf;
      float output_exposure_gain = output_target_yf / max(output_current_yf, renodx::math::FLT_EPSILON);
      float expected_u3_current_yf = current_state_yf;
      if (CUSTOM_DEBUG_INSPECT_RESIDUALS) {
        output_current_yf = previous_fast_valid ? previous_fast_eqbg : 0.0f;
        output_target_yf = previous_slow_valid ? previous_slow_eqbg : 0.0f;
        output_raw_target_yf = output_target_yf;
        output_exposure_gain = 0.0f;
      } else if (CUSTOM_DEBUG_INSPECT_PREV_FIELD) {
        output_current_yf = previous_field_valid ? previous_field_yf : 0.0f;
        output_target_yf = has_filtered_target_history ? previous_filtered_target : 0.0f;
        output_raw_target_yf = output_target_yf;
        output_exposure_gain = output_target_yf / max(output_current_yf, renodx::math::FLT_EPSILON);
      }

      StarfieldPsychoVTransportWrite transport;
      transport.current_yf = output_current_yf;
      transport.target_yf = output_target_yf;
      transport.raw_target_yf = output_raw_target_yf;
      transport.exposure_gain = output_exposure_gain;
      transport.expected_current_yf = expected_u3_current_yf;
      transport.history_field_yf = history_field_yf;
      transport.history_target_yf = history_target_yf;
      transport.history_fast_yf = history_fast_eqbg_yf;
      transport.history_slow_yf = history_slow_eqbg_yf;
      transport.history_valid = 1.0f;
      transport.history_frame_time = current_frame_time;
      transport.history_magic = history_magic_expected;
      transport.flags = transport_flags;
      transport.gap = history_frame_gap;
#ifndef NDEBUG
      transport.debug_field_yf = field_y;
#endif
      StarfieldStorePsychoVTransport(transport);
    }
#ifndef NDEBUG
    RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_DEBUG_HDR_MIN_OFFSET, vanilla_histogram_min_log2);
    RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_DEBUG_HDR_MAX_OFFSET, vanilla_histogram_max_log2);
#endif
  }

  float _13 = float((uint)(uint)(LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_016));
  int _15 = int(_13 * LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_008);
  int _18 = int(_13 * LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_012);
  float _23 = Data_000.HDRData_004 - Data_000.HDRData_000;
  int _74;
  float _75;
  float _76;
  int _77;
  int _78;
  int _79;
  int _80;
  _74 = 0;
  _75 = 0.0f;
  _76 = ((_23 * 0.004999999888241291f) + Data_000.HDRData_000);
  _77 = 0;
  _78 = 0;
  _79 = 100;
  _80 = 0;
  while (true) {
    int _83 = u0_space4[_80];
    int _97 = select(((((int)_74 < (int)_15)) && (((int)(_83 + _74) >= (int)_15))), _80, _78);
    int _102 = select(((((int)_74 <= (int)_18)) && (((int)(_83 + _74) > (int)_18))), (_80 + 1), _79);
    float _104 = ((float((int)(min(max((min(_18, (_83 + _74)) - max(_15, _74)), 0), _83))) / float((int)(_18 - _15))) * exp2(_76)) + _75;
    int _106 = max(_77, _83);
    if (!((_80 + 1) == 100)) {
      _74 = (_83 + _74);
      _75 = _104;
      _76 = (_76 + (_23 * 0.009999999776482582f));
      _77 = _106;
      _78 = _97;
      _79 = _102;
      _80 = (_80 + 1);
      continue;
    }
    float _28 = log2(_104);
    float _31 = u1_space4[0].x;
    float _32 = u1_space4[0].y;
    float _33 = u1_space4[0].w;
    float _36 = select((_15 == LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_016), 100.0f, float((uint)_97));
    u1_space4[0].x = _31;
    u1_space4[0].y = _32;
    u1_space4[0].z = _36;
    u1_space4[0].w = _33;
    float _39 = u1_space4[0].x;
    float _40 = u1_space4[0].y;
    float _41 = u1_space4[0].z;
    float _44 = select((_18 == _15), 0.0f, float((int)(_102)));
    u1_space4[0].x = _39;
    u1_space4[0].y = _40;
    u1_space4[0].z = _41;
    u1_space4[0].w = _44;
    float _47 = u1_space4[0].x;
    float _48 = u1_space4[0].z;
    float _49 = u1_space4[0].w;
    u1_space4[0].x = _47;
    u1_space4[0].y = _28;
    u1_space4[0].z = _48;
    u1_space4[0].w = _49;
    float _52 = u1_space4[0].y;
    float _53 = u1_space4[0].z;
    float _54 = u1_space4[0].w;
    float _55 = float((int)(_106));
    u1_space4[0].x = _55;
    u1_space4[0].y = _52;
    u1_space4[0].z = _53;
    u1_space4[0].w = _54;
    float _57 = u2_space4.Load(int2(0, 0));
    float _60 = log2(max(1.1920928955078125e-07f, _57.x));
    float _61 = _28 - _60;
    float _69 = exp2((select((_61 > 0.0f), LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_004, LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_000) * _61) + _60);
    u2_space4[int2(0, 0)] = _69;
    if (!(LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_020 == -1)) {
      u3_space4.Store(LightAdaptData_000.HDR_HistogramReadLightAdapt_Data_020, asuint(_69));
    }
    break;
  }
}
