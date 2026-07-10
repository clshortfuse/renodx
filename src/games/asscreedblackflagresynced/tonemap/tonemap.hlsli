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
  T ApplyImmortalsToneMap(T untonemapped_ap1, ImmortalsToneMapConfig config) {                                                                                                                               \
    T input_scaled = abs(untonemapped_ap1 * 0.00999999977648258209228515625f);                                                                                                                               \
    T toe_ratio = input_scaled / config.toe_threshold;                                                                                                                                                       \
    T toe_ratio_sat = saturate(toe_ratio);                                                                                                                                                                   \
    T toe_ratio_sat_sq = toe_ratio_sat * toe_ratio_sat;                                                                                                                                                      \
    T toe_smooth = mad(toe_ratio_sat, -2.f, 3.f);                                                                                                                                                            \
    T in_shoulder = renodx::math::Select(input_scaled > config.shoulder_start, (T)1.f, (T)0.f);                                                                                                              \
    T toe_curve = renodx::math::Select(config.has_toe, mad(exp2(log2(abs(toe_ratio)) * config.toe_slope), config.toe_threshold, config.black_offset), config.black_offset);                                  \
    T toe_weight = mad(-toe_smooth, toe_ratio_sat_sq, 1.f);                                                                                                                                                  \
    T linear_curve = mad(input_scaled - config.toe_threshold, config.slope, config.toe_threshold);                                                                                                           \
    T linear_weight = (mad(toe_smooth, toe_ratio_sat_sq, -1.f) + 1.f) - in_shoulder;                                                                                                                         \
    T shoulder_curve = config.peak_luminance + (exp2(((config.shoulder_scale * (input_scaled - config.shoulder_start)) / config.peak_luminance) * (-1.44269502162933349609375f)) * config.shoulder_overage); \
    return mad(shoulder_curve, in_shoulder, (toe_weight * toe_curve) + (linear_weight * linear_curve)) * 100.f;                                                                                              \
  }

IMMORTALS_TONEMAP_GENERATOR(float)
IMMORTALS_TONEMAP_GENERATOR(float3)
#undef IMMORTALS_TONEMAP_GENERATOR

float3 TransferPurityAndWeightedHueFromLMS(
    float3 lms_source,
    float3 lms_target,
    float purity_loss_hue_power = 1.f,
    float baseline_hue_amount = 0.f,
    float purity_amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f,
    bool compress_bt2020 = false) {
  float3 mb_source = renodx::color::macleod_boynton::from::LMS(lms_source);
  float3 mb_target = renodx::color::macleod_boynton::from::LMS(lms_target);
  float2 mb_white = renodx::color::macleod_boynton::from::D65XY();

  float2 source_offset = mb_source.xy - mb_white;
  float2 target_offset = mb_target.xy - mb_white;
  float src_radius = length(source_offset);
  float tgt_radius = length(target_offset);
  if (tgt_radius <= eps) return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(lms_target, 1.f) : lms_target;

  float no_change_distance = max(tgt_radius - eps, eps);
  float purity_delta = src_radius - tgt_radius;
  float raw_hue_amount = saturate(0.5f - (purity_delta / (2.f * no_change_distance)));
  float purity_loss_hue_signal = saturate((raw_hue_amount - 0.5f) * 2.f);
  purity_loss_hue_signal = 1.f - pow(1.f - purity_loss_hue_signal, max(purity_loss_hue_power, eps));
  float purity_loss_hue_amount = 0.5f + (0.5f * purity_loss_hue_signal);
  float hue_amount = lerp(raw_hue_amount, purity_loss_hue_amount, step(0.5f, raw_hue_amount));
  hue_amount = max(hue_amount, saturate(baseline_hue_amount));

  float2 source_hue_offset = source_offset * (tgt_radius / max(src_radius, eps));
  float2 hue_offset = lerp(target_offset, source_hue_offset, hue_amount);
  float hue_radius = length(hue_offset);

  if (hue_radius <= eps) return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(lms_target, 1.f) : lms_target;

  float transfer_scale = src_radius / max(hue_radius, eps);
  float no_purity_loss_scale = max(transfer_scale, 1.f);
  transfer_scale = lerp(transfer_scale, no_purity_loss_scale, clamp_purity_loss);
  float scale = lerp(1.f, transfer_scale, purity_amount);
  float2 mb_scaled = mb_white + hue_offset * scale;

  float3 output_lms = renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb_target.z));
  return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(output_lms, 1.f) : output_lms;
}
