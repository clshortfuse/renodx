#include "./shared.h"

#define CAPTURE_UNGRADED(c1, c2, c3) const float3 ungraded = float3((c1), (c2), (c3))

namespace wuwa {

namespace lut {

static inline float PrepareLinearInput(inout float r, inout float g, inout float b) {
  float3 lut_linear_input = max(0.f, float3(r, g, b));
  float lut_sampling_scale = 1.0f;

  if (RENODX_TONE_MAP_TYPE != 0.0f) {
    lut_sampling_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(lut_linear_input);
    lut_linear_input *= lut_sampling_scale;
  }

  r = lut_linear_input.r;
  g = lut_linear_input.g;
  b = lut_linear_input.b;
  return lut_sampling_scale;
}

static inline float NormalizeEncodedInput(inout float r, inout float g, inout float b) {
  float lut_sample_max_channel = renodx::math::Max(r, g, b, 1.0f);
  float3 lut_input_srgb = saturate(float3(r, g, b) / lut_sample_max_channel);
  r = lut_input_srgb.r;
  g = lut_input_srgb.g;
  b = lut_input_srgb.b;
  return lut_sample_max_channel;
}

static inline void ApplySampleMaxChannel(inout float r, inout float g, inout float b, float lut_sample_max_channel) {
  r *= lut_sample_max_channel;
  g *= lut_sample_max_channel;
  b *= lut_sample_max_channel;
}

static inline void ApplyInverseSamplingScale(inout float r, inout float g, inout float b, float lut_sampling_scale) {
  if (RENODX_TONE_MAP_TYPE != 0.0f) {
    float inv_lut_sampling_scale = 1.0f / max(lut_sampling_scale, 1e-6f);
    r *= inv_lut_sampling_scale;
    g *= inv_lut_sampling_scale;
    b *= inv_lut_sampling_scale;
  }
}

static inline void PreserveReferenceLightness(inout float r, inout float g, inout float b, float3 reference_bt709) {
  if (RENODX_TONE_MAP_TYPE == 0.f || RENODX_WUWA_LUT_LIGHTNESS >= 1.f) {
    return;
  }
  float3 lut_lab = renodx::color::oklab::from::BT709(float3(r, g, b));
  float3 ref_lab = renodx::color::oklab::from::BT709(reference_bt709);
  lut_lab.x = lerp(ref_lab.x, lut_lab.x, RENODX_WUWA_LUT_LIGHTNESS);
  float3 result = renodx::color::bt709::clamp::AP1(renodx::color::bt709::from::OkLab(lut_lab));
  r = result.r;
  g = result.g;
  b = result.b;
}


static inline void ApplyLutStrength(inout float r, inout float g, inout float b, float3 ungraded) {
  float3 ungraded_bt709 = renodx::color::bt709::from::AP1(ungraded);
  float3 graded_lab = renodx::color::oklab::from::BT709(float3(r, g, b));
  float3 ungraded_lab = renodx::color::oklab::from::BT709(ungraded_bt709);
  graded_lab.yz = lerp(ungraded_lab.yz, graded_lab.yz, RENODX_WUWA_LUT_STRENGTH);
  float3 result = renodx::color::bt709::clamp::AP1(renodx::color::bt709::from::OkLab(graded_lab));
  r = result.r;
  g = result.g;
  b = result.b;
}

}

}

#define GENERATE_LUT_OUTPUT(T)                                          \
  static inline T GenerateLUTOutput(T graded_bt709) {                   \
    graded_bt709 = renodx::draw::RenderIntermediatePass(graded_bt709);  \
    graded_bt709 /= 1.0499999523162842f;                                \
    return graded_bt709;                                                \
  }

GENERATE_LUT_OUTPUT(float3)
