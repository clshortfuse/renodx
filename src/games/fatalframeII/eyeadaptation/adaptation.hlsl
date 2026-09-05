#ifndef CUSTOM_ADAPTATION_V1_HLSL_
#define CUSTOM_ADAPTATION_V1_HLSL_

namespace custom {
namespace adaptation {
namespace v1 {

static const uint HISTOGRAM_BIN_COUNT = 256u;
static const float HISTOGRAM_MIN_LOG2 = -16.0f;
static const float HISTOGRAM_MAX_LOG2 = 16.0f;
static const float HISTOGRAM_RANGE_LOG2 = HISTOGRAM_MAX_LOG2 - HISTOGRAM_MIN_LOG2;
static const float HISTOGRAM_PERCENTILE_LOW = 0.20000000298023224f;
static const float HISTOGRAM_PERCENTILE_HIGH = 0.800000011920929f;
static const uint HISTOGRAM_BASE_SAMPLE_WEIGHT = 4u;
static const float MIN_VALID_YF = 9.999999747378752e-05f;
static const float NEUTRAL_YF = 0.18f;
static const float MAX_CONTINUITY_SECONDS = 1.0f;

float DecodeHistogramLog2Luminance(float histogram_bin) {
  return HISTOGRAM_MIN_LOG2 + ((((histogram_bin + 0.5f) / float(HISTOGRAM_BIN_COUNT))) * HISTOGRAM_RANGE_LOG2);
}

uint EncodeHistogramBin(float luminance_yf) {
  if (luminance_yf <= 0.0f) return 0u;
  float log_y = log2(luminance_yf);
  float histogram_value = saturate((log_y - HISTOGRAM_MIN_LOG2) / HISTOGRAM_RANGE_LOG2);
  return min(HISTOGRAM_BIN_COUNT - 1u, uint(floor(histogram_value * float(HISTOGRAM_BIN_COUNT))));
}

float ExponentialBlend(float current_value, float target_value, float delta_time, float tau_seconds) {
  if (tau_seconds <= 0.0f) return target_value;
  float alpha = 1.0f - exp(-max(delta_time, 0.0f) / tau_seconds);
  return lerp(current_value, target_value, saturate(alpha));
}

float AdaptAsymmetric(
    float current_value,
    float target_value,
    float delta_time,
    float light_tau_seconds,
    float dark_tau_seconds) {
  return target_value > current_value
             ? ExponentialBlend(current_value, target_value, delta_time, light_tau_seconds)
             : ExponentialBlend(current_value, target_value, delta_time, dark_tau_seconds);
}

}  // namespace v1
}  // namespace adaptation
}  // namespace custom

#endif  // CUSTOM_ADAPTATION_V1_HLSL_
