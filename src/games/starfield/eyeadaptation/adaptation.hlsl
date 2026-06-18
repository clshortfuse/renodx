#ifndef CUSTOM_ADAPTATION_V1_HLSL_
#define CUSTOM_ADAPTATION_V1_HLSL_

namespace custom {
namespace adaptation {
namespace v1 {

// v1 is the shared "current-generation" adaptation contract:
// histogram-driven, heuristic, and close in spirit to the existing Crimson
// Desert / Starfield family rather than the later science-facing prototype.

static const uint HISTOGRAM_BIN_COUNT = 256u;
static const float HISTOGRAM_MIN_LOG2 = -16.0f;
static const float HISTOGRAM_MAX_LOG2 = 16.0f;
static const float HISTOGRAM_RANGE_LOG2 = HISTOGRAM_MAX_LOG2 - HISTOGRAM_MIN_LOG2;
static const float HISTOGRAM_PERCENTILE_LOW = 0.20000000298023224f;
static const float HISTOGRAM_PERCENTILE_HIGH = 0.800000011920929f;
static const uint HISTOGRAM_BASE_SAMPLE_WEIGHT = 4u;
static const float HISTOGRAM_CENTER_WEIGHT_SIGMA = 0.25f;
static const float HISTOGRAM_CENTER_WEIGHT_SCALE = 4.0f;
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

float NormalizeWeightSum(float a, float b, float c) {
  return max(a + b + c, renodx::math::FLT_EPSILON);
}

float BlendSpatialKeys(
    float center_key_yf,
    float parafoveal_key_yf,
    float peripheral_key_yf,
    float center_weight,
    float parafoveal_weight,
    float peripheral_weight) {
  float total = NormalizeWeightSum(center_weight, parafoveal_weight, peripheral_weight);
  return (
             center_key_yf * center_weight
             + parafoveal_key_yf * parafoveal_weight
             + peripheral_key_yf * peripheral_weight)
         / total;
}

float BrightSourceExcess(float source_yf, float threshold_yf) {
  return max(source_yf - threshold_yf, 0.0f);
}

float VeilingLuminance(float source_yf, float threshold_yf, float strength = 0.35f) {
  return BrightSourceExcess(source_yf, threshold_yf) * strength;
}

float ApplyVeilingLuminance(float adapting_state_yf, float veiling_luminance_yf) {
  return adapting_state_yf + max(veiling_luminance_yf, 0.0f);
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

struct Inputs {
  float scene_key_yf;
  float center_key_yf;
  float parafoveal_key_yf;
  float peripheral_key_yf;
  float glare_source_yf;
  float glare_threshold_yf;
  float adapted_state_prev_yf;
  float delta_time;
  float light_tau_seconds;
  float dark_tau_seconds;
  float center_weight;
  float parafoveal_weight;
  float peripheral_weight;
  float glare_strength;
};

struct Outputs {
  float adapted_state_yf;
  float exposure_scale;
  float glare_yf;
  float spatial_key_yf;
};

Inputs CreateDefaultInputs() {
  Inputs output;
  output.scene_key_yf = 0.18f;
  output.center_key_yf = 0.18f;
  output.parafoveal_key_yf = 0.18f;
  output.peripheral_key_yf = 0.18f;
  output.glare_source_yf = 0.18f;
  output.glare_threshold_yf = 1.0f;
  output.adapted_state_prev_yf = 0.18f;
  output.delta_time = 1.0f / 60.0f;
  output.light_tau_seconds = 0.15f;
  output.dark_tau_seconds = 0.75f;
  output.center_weight = 1.0f;
  output.parafoveal_weight = 0.35f;
  output.peripheral_weight = 0.15f;
  output.glare_strength = 0.35f;
  return output;
}

Outputs Resolve(Inputs input) {
  Outputs output;

  float spatial_key_yf = BlendSpatialKeys(
      input.center_key_yf,
      input.parafoveal_key_yf,
      input.peripheral_key_yf,
      input.center_weight,
      input.parafoveal_weight,
      input.peripheral_weight);
  float glare_yf = VeilingLuminance(
      input.glare_source_yf,
      input.glare_threshold_yf,
      input.glare_strength);
  float target_state_yf = ApplyVeilingLuminance(spatial_key_yf, glare_yf);
  float adapted_state_yf = AdaptAsymmetric(
      max(input.adapted_state_prev_yf, renodx::math::FLT_EPSILON),
      max(target_state_yf, renodx::math::FLT_EPSILON),
      input.delta_time,
      input.light_tau_seconds,
      input.dark_tau_seconds);

  output.adapted_state_yf = adapted_state_yf;
  output.exposure_scale = input.scene_key_yf > 0.0f
                              ? adapted_state_yf / max(input.scene_key_yf, renodx::math::FLT_EPSILON)
                              : 1.0f;
  output.glare_yf = glare_yf;
  output.spatial_key_yf = spatial_key_yf;
  return output;
}

}  // namespace v1
}  // namespace adaptation
}  // namespace custom

#endif  // CUSTOM_ADAPTATION_V1_HLSL_
