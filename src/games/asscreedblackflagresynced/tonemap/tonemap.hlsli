#include "../common.hlsli"

struct ImmortalsToneMapConfig {
  float contrast;
  float toe_threshold;
  float toe_slope;
  float black_offset;
  float peak_luminance;
  float shoulder_start;
  float shoulder_scale;
  float shoulder_range_negative;
  bool has_toe;
};

ImmortalsToneMapConfig CreateImmortalsToneMapConfig(
    float contrast,
    float toe_threshold,
    float mid_point,
    float toe_slope,
    float black_offset,
    float peak_nits) {
  ImmortalsToneMapConfig config;
  config.contrast = contrast;
  config.toe_threshold = toe_threshold;
  config.toe_slope = toe_slope;
  config.black_offset = black_offset;
  config.peak_luminance = peak_nits * 0.00999999977648258209228515625f;
  config.has_toe = config.toe_threshold > 9.9999997473787516355514526367188e-06f;

  float peak_minus_toe = mad(peak_nits, 0.00999999977648258209228515625f, -config.toe_threshold);
  float linear_end = mad(peak_minus_toe, mid_point, config.toe_threshold);
  config.shoulder_start = ((peak_minus_toe * mid_point) / config.contrast) + config.toe_threshold;
  config.shoulder_scale = (config.peak_luminance * config.contrast) / mad(peak_nits, 0.00999999977648258209228515625f, -linear_end);
  config.shoulder_range_negative = mad(-peak_nits, 0.00999999977648258209228515625f, linear_end);
  return config;
}

#define IMMORTALS_TONEMAP_GENERATOR(T)                                                                                                                                                                              \
  T ApplyImmortalsToneMap(T untonemapped_ap1, ImmortalsToneMapConfig config) {                                                                                                                                      \
    T input_scaled = abs(untonemapped_ap1 * 0.00999999977648258209228515625f);                                                                                                                                      \
    T toe_ratio = input_scaled / config.toe_threshold;                                                                                                                                                              \
    T toe_ratio_sat = saturate(toe_ratio);                                                                                                                                                                          \
    T toe_ratio_sat_sq = toe_ratio_sat * toe_ratio_sat;                                                                                                                                                             \
    T toe_smooth = mad(toe_ratio_sat, -2.f, 3.f);                                                                                                                                                                   \
    T in_shoulder = renodx::math::Select(input_scaled > config.shoulder_start, (T)1.f, (T)0.f);                                                                                                                     \
    T toe_curve = renodx::math::Select(config.has_toe, mad(exp2(log2(abs(toe_ratio)) * config.toe_slope), config.toe_threshold, config.black_offset), config.black_offset);                                         \
    T toe_weight = mad(-toe_smooth, toe_ratio_sat_sq, 1.f);                                                                                                                                                         \
    T linear_curve = mad(input_scaled - config.toe_threshold, config.contrast, config.toe_threshold);                                                                                                               \
    T linear_weight = (mad(toe_smooth, toe_ratio_sat_sq, -1.f) + 1.f) - in_shoulder;                                                                                                                                \
    T shoulder_curve = config.peak_luminance + (exp2(((config.shoulder_scale * (input_scaled - config.shoulder_start)) / config.peak_luminance) * (-1.44269502162933349609375f)) * config.shoulder_range_negative); \
    return mad(shoulder_curve, in_shoulder, (toe_weight * toe_curve) + (linear_weight * linear_curve)) * 100.f;                                                                                                     \
  }

IMMORTALS_TONEMAP_GENERATOR(float)
IMMORTALS_TONEMAP_GENERATOR(float3)
#undef IMMORTALS_TONEMAP_GENERATOR