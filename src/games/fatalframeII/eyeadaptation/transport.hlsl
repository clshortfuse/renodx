#ifndef CUSTOM_EYE_ADAPTATION_TRANSPORT_HLSL_
#define CUSTOM_EYE_ADAPTATION_TRANSPORT_HLSL_

#include "./adaptation.hlsl"

float4 RenodxReadEyeAdaptationState() {
  float current_average = custom::adaptation::v1::NEUTRAL_YF;
  float target_average = custom::adaptation::v1::NEUTRAL_YF;
  float raw_target_average = custom::adaptation::v1::NEUTRAL_YF;
  float exposure_gain = 1.f;

  if (CUSTOM_EYE_ADAPTATION_PERCEPTUAL && CUSTOM_EYE_ADAPTATION_HAS_DATA) {
    current_average = max(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_CURRENT_AVG_OFFSET), custom::adaptation::v1::MIN_VALID_YF);
    target_average = max(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_TARGET_AVG_OFFSET), custom::adaptation::v1::MIN_VALID_YF);
    raw_target_average = max(RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_RAW_TARGET_OFFSET), custom::adaptation::v1::MIN_VALID_YF);
    exposure_gain = renodx::math::DivideSafe(target_average, current_average, 1.f);
  }

  return float4(current_average, target_average, raw_target_average, exposure_gain);
}

void RenodxWriteEyeAdaptationHistogram(float3 color_bt709) {
  if (!CUSTOM_EYE_ADAPTATION_PERCEPTUAL) return;

  float luminance_yf = renodx::color::yf::from::BT709(max(color_bt709, 0.f));
  uint histogram_bin = custom::adaptation::v1::EncodeHistogramBin(luminance_yf);
  uint previous_value;
  InterlockedAdd(renodx_eye_adaptation_histogram[histogram_bin], custom::adaptation::v1::HISTOGRAM_BASE_SAMPLE_WEIGHT, previous_value);
}

void RenodxResolveEyeAdaptationTransport(float4 sv_position) {
  if (!CUSTOM_EYE_ADAPTATION_PERCEPTUAL) return;
  if (any(uint2(sv_position.xy) != uint2(0u, 0u))) return;

  int black_count = 0;
  int positive_count = 0;
  [loop]
  for (int bin_index = 0; bin_index < (int)custom::adaptation::v1::HISTOGRAM_BIN_COUNT; ++bin_index) {
    int bin_count = (int)renodx_eye_adaptation_histogram[bin_index];
    if (bin_index == 0) {
      black_count += bin_count;
    } else {
      positive_count += bin_count;
    }
  }

  float field_yf = 0.f;
  float percentile_count = max(1.0f, (float)positive_count);
  float remaining_lo = percentile_count * custom::adaptation::v1::HISTOGRAM_PERCENTILE_LOW;
  float remaining_hi = percentile_count * custom::adaptation::v1::HISTOGRAM_PERCENTILE_HIGH;
  float sum_log = 0.0f;
  float sum_weight = 0.0f;

  [loop]
  for (int percentile_bin_index = 1; percentile_bin_index < (int)custom::adaptation::v1::HISTOGRAM_BIN_COUNT; ++percentile_bin_index) {
    float bin_count = (float)((int)renodx_eye_adaptation_histogram[percentile_bin_index]);
    float skip = min(remaining_lo, bin_count);
    float after_skip = bin_count - skip;
    float window = max(0.0f, remaining_hi - skip);
    float take = min(window, after_skip);

    if (take > 0.0f) {
      float log_yf = custom::adaptation::v1::DecodeHistogramLog2Luminance((float)((uint)percentile_bin_index));
      sum_log += take * log_yf;
      sum_weight += take;
    }

    remaining_lo -= skip;
    remaining_hi = window - take;
  }

  if (sum_weight > 0.0f) {
    field_yf = exp2(sum_log / max(sum_weight, custom::adaptation::v1::MIN_VALID_YF));
  }

  bool field_valid = !isnan(field_yf) && !isinf(field_yf) && field_yf > 0.0f;
  bool black_reset = black_count > 0 && positive_count == 0;

  float history_valid = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET);
  float history_magic = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET);
  float previous_current = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_CURRENT_AVG_OFFSET);
  float previous_frame_time = RenodxEyeAdaptationBufferLoadFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FRAME_OFFSET);
  bool has_history = history_valid > 0.5f
                     && !isnan(history_magic)
                     && !isinf(history_magic)
                     && abs(history_magic - RENODX_EYE_ADAPTATION_HISTORY_MAGIC_EXPECTED) < 0.125f
                     && !black_reset;

  float current_frame_time = max(CUSTOM_FRAME_TIME, 0.0f);
  float frame_delta_time = CUSTOM_FRAME_DELTA_TIME > 0.0f ? CUSTOM_FRAME_DELTA_TIME : (1.0f / 60.0f);
  float history_gap = current_frame_time - previous_frame_time;
  bool temporal_continuity = has_history
                             && frame_delta_time > 0.0f
                             && frame_delta_time <= custom::adaptation::v1::MAX_CONTINUITY_SECONDS
                             && history_gap >= 0.0f
                             && history_gap <= custom::adaptation::v1::MAX_CONTINUITY_SECONDS;

  float raw_target_yf = field_valid ? field_yf : custom::adaptation::v1::NEUTRAL_YF;
  float target_yf = raw_target_yf;
  if (CUSTOM_EYE_ADAPTATION_MIN_BRIGHTNESS > 0.0f) {
    target_yf = max(target_yf, CUSTOM_EYE_ADAPTATION_MIN_BRIGHTNESS);
  }
  if (CUSTOM_EYE_ADAPTATION_MAX_BRIGHTNESS > 0.0f) {
    target_yf = min(target_yf, CUSTOM_EYE_ADAPTATION_MAX_BRIGHTNESS);
  }

  float previous_yf = has_history && previous_current > 0.0f ? previous_current : target_yf;
  float current_yf = field_valid
                         ? custom::adaptation::v1::AdaptAsymmetric(
                               previous_yf,
                               target_yf,
                               frame_delta_time,
                               CUSTOM_EYE_ADAPTATION_DARK_TO_LIGHT,
                               CUSTOM_EYE_ADAPTATION_LIGHT_TO_DARK)
                         : previous_yf;

  uint transport_flags = 0u;
  if (field_valid) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_FIELD_VALID;
  if (has_history) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TRANSPORT_HISTORY;
  if (temporal_continuity) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_TEMPORAL_CONTINUITY;
  if (!has_history && field_valid) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_BASELINE;
  if (field_valid) transport_flags |= RENODX_EYE_ADAPTATION_TRANSPORT_FLAG_HISTOGRAM_USABLE;

  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_CURRENT_AVG_OFFSET, max(current_yf, custom::adaptation::v1::MIN_VALID_YF));
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_TARGET_AVG_OFFSET, max(target_yf, custom::adaptation::v1::MIN_VALID_YF));
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_RAW_TARGET_OFFSET, max(raw_target_yf, custom::adaptation::v1::MIN_VALID_YF));
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_EXPOSURE_GAIN_OFFSET, renodx::math::DivideSafe(target_yf, current_yf, 1.f));
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_EXPECTED_U3_CURRENT_OFFSET, max(current_yf, custom::adaptation::v1::MIN_VALID_YF));
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FIELD_OFFSET, max(field_yf, 0.f));
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_TARGET_OFFSET, max(target_yf, custom::adaptation::v1::MIN_VALID_YF));
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FAST_OFFSET, 0.f);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_SLOW_OFFSET, 0.f);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_VALID_OFFSET, field_valid ? 1.f : 0.f);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_FRAME_OFFSET, current_frame_time);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_HISTORY_MAGIC_OFFSET, RENODX_EYE_ADAPTATION_HISTORY_MAGIC_EXPECTED);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_FLAGS_OFFSET, (float)transport_flags);
  RenodxEyeAdaptationBufferStoreFloat(RENODX_EYE_ADAPTATION_BUFFER_TRANSPORT_GAP_OFFSET, temporal_continuity ? history_gap : 0.f);
}

void RenodxDebugDrawFloat(
    inout renodx::canvas::Context canvas_context,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0,
    float value = 0.f) {
  renodx::canvas::DrawDynamicText(canvas_context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  renodx::canvas::InsertSpace(canvas_context);
  renodx::canvas::DrawFloat(canvas_context, value, 5.f, 3.f, false, true);
  renodx::canvas::NewLine(canvas_context);
}

void RenodxDebugDrawInt(
    inout renodx::canvas::Context canvas_context,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0,
    int value = 0) {
  renodx::canvas::DrawDynamicText(canvas_context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  renodx::canvas::InsertSpace(canvas_context);
  renodx::canvas::DrawInteger(canvas_context, value, 10.f, false, false);
  renodx::canvas::NewLine(canvas_context);
}

float3 RenodxDebugEyeAdaptation(float4 sv_position, float3 color) {
  uint2 pixel = uint2(sv_position.xy);

  renodx::canvas::Context canvas_context = renodx::canvas::CreateContext(
      sv_position.xy,
      float2(8.f, 8.f),
      float2(8.f, 12.f),
      color,
      1.f,
      float3(0.1f, 1.f, 0.25f),
      1.f,
      1.f,
      renodx::canvas::MODE_NORMAL,
      CUSTOM_FRAME_TIME,
      1.05f);

  if (pixel.x < 536u && pixel.y < 252u) {
    renodx::canvas::SetColor(canvas_context, float3(0.f, 0.f, 0.f), 0.55f);
    renodx::canvas::FillRect(canvas_context, float2(4.f, 4.f), float2(532.f, 248.f));
    renodx::canvas::SetColor(canvas_context, float3(0.1f, 1.f, 0.25f), 1.f);

    int histogram_total = 0;
    int histogram_max_bin = 0;
    int histogram_max_count = 0;
    [loop]
    for (int debug_bin_index = 0; debug_bin_index < (int)custom::adaptation::v1::HISTOGRAM_BIN_COUNT; ++debug_bin_index) {
      int debug_bin_count = (int)renodx_eye_adaptation_histogram[debug_bin_index];
      histogram_total += debug_bin_count;
      if (debug_bin_count > histogram_max_count) {
        histogram_max_count = debug_bin_count;
        histogram_max_bin = debug_bin_index;
      }
    }

    float4 eye_adaptation = RenodxReadEyeAdaptationState();

    renodx::canvas::DrawDynamicText(canvas_context, 'E', 'Y', 'E', ' ', 'A', 'D', 'A', 'P', 'T', 'A', 'T', 'I', 'O', 'N');
    renodx::canvas::NewLine(canvas_context);
    RenodxDebugDrawFloat(canvas_context, 'E', 'N', 'A', 'B', 'L', 'E', 'D', 0, 0, 0, 0, 0, 0, 0, 0, 0, CUSTOM_EYE_ADAPTATION_PERCEPTUAL ? 1.f : 0.f);
    RenodxDebugDrawFloat(canvas_context, 'H', 'A', 'S', ' ', 'D', 'A', 'T', 'A', 0, 0, 0, 0, 0, 0, 0, 0, CUSTOM_EYE_ADAPTATION_HAS_DATA ? 1.f : 0.f);
    RenodxDebugDrawInt(canvas_context, 'F', 'L', 'A', 'G', 'S', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (int)CUSTOM_EYE_ADAPTATION_TRANSPORT_FLAGS);
    RenodxDebugDrawFloat(canvas_context, 'C', 'U', 'R', 'R', 'E', 'N', 'T', 0, 0, 0, 0, 0, 0, 0, 0, 0, eye_adaptation.x);
    RenodxDebugDrawFloat(canvas_context, 'T', 'A', 'R', 'G', 'E', 'T', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, eye_adaptation.y);
    RenodxDebugDrawFloat(canvas_context, 'R', 'A', 'W', ' ', 'T', 'A', 'R', 'G', 'E', 'T', 0, 0, 0, 0, 0, 0, eye_adaptation.z);
    RenodxDebugDrawFloat(canvas_context, 'G', 'A', 'I', 'N', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, eye_adaptation.w);
    RenodxDebugDrawInt(canvas_context, 'H', 'I', 'S', 'T', ' ', 'T', 'O', 'T', 'A', 'L', 0, 0, 0, 0, 0, 0, histogram_total);
    RenodxDebugDrawInt(canvas_context, 'M', 'A', 'X', ' ', 'B', 'I', 'N', 0, 0, 0, 0, 0, 0, 0, 0, 0, histogram_max_bin);
    RenodxDebugDrawInt(canvas_context, 'M', 'A', 'X', ' ', 'C', 'O', 'U', 'N', 'T', 0, 0, 0, 0, 0, 0, 0, histogram_max_count);
  }

  float3 debug_color = renodx::canvas::GetOutput(canvas_context).rgb;

  if (pixel.x < 512u && pixel.y >= 260u && pixel.y < 388u) {
    uint bin_index = min(pixel.x >> 1u, custom::adaptation::v1::HISTOGRAM_BIN_COUNT - 1u);
    uint bin_count = renodx_eye_adaptation_histogram[bin_index];
    float normalized_count = saturate(log2((float)bin_count + 1.f) / 16.f);
    uint bar_height = (uint)(normalized_count * 128.f);
    uint local_y = pixel.y - 260u;

    if (local_y >= 128u - bar_height) {
      float bin_lerp = (float)bin_index / (float)(custom::adaptation::v1::HISTOGRAM_BIN_COUNT - 1u);
      debug_color = lerp(float3(0.1f, 0.35f, 1.f), float3(1.f, 0.85f, 0.05f), bin_lerp);
    } else if ((pixel.x & 31u) == 0u || local_y == 127u) {
      debug_color = float3(0.08f, 0.08f, 0.08f);
    }
  }

  return debug_color;
}

#endif  // CUSTOM_EYE_ADAPTATION_TRANSPORT_HLSL_
