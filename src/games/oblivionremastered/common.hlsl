#include "./shared.h"

// clang-format off
static struct UELutBuilderConfig {
  float3 ungraded_ap1;
  float3 untonemapped_ap1;
  float3 untonemapped_bt709;
  float3 tonemapped_bt709;
  float3 graded_bt709;
} RENODX_UE_CONFIG;
// clang-format on

// First instance of 0.272228718, 0.674081743, 0.0536895171
void SetUngradedAP1(float3 color) {
  RENODX_UE_CONFIG.ungraded_ap1 = color;
}

void SetUntonemappedAP1(float3 color) {
  RENODX_UE_CONFIG.untonemapped_ap1 = color;
  RENODX_UE_CONFIG.untonemapped_bt709 = renodx::color::bt709::from::AP1(RENODX_UE_CONFIG.untonemapped_ap1);
  RENODX_UE_CONFIG.tonemapped_bt709 = abs(RENODX_UE_CONFIG.untonemapped_bt709);
}

void SetTonemappedBT709(inout float color_red, inout float color_green, inout float color_blue) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 color = float3(color_red, color_green, color_blue);
  RENODX_UE_CONFIG.tonemapped_bt709 = color;

  if (CUSTOM_SCENE_GRADE_HUE_CORRECTION != 0.f
      || CUSTOM_SCENE_GRADE_HUE_CORRECTION != 0.f
      || CUSTOM_SCENE_GRADE_SATURATION_CORRECTION != 0.f
      || CUSTOM_SCENE_GRADE_HUE_SHIFT != 0.f) {
    color = renodx::draw::ApplyPerChannelCorrection(
        RENODX_UE_CONFIG.untonemapped_bt709,
        float3(color_red, color_green, color_blue),
        CUSTOM_SCENE_GRADE_BLOWOUT_RESTORATION,
        CUSTOM_SCENE_GRADE_HUE_CORRECTION,
        CUSTOM_SCENE_GRADE_SATURATION_CORRECTION,
        CUSTOM_SCENE_GRADE_HUE_SHIFT);
  }

  color = abs(color);
  color_red = color.r;
  color_green = color.g;
  color_blue = color.b;
}

void SetTonemappedBT709(inout float3 color) {
  SetTonemappedBT709(color.r, color.g, color.b);
}

// Used by LUTs
void SetTonemappedAP1(inout float color_red, inout float color_green, inout float color_blue) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 color = float3(color_red, color_green, color_blue);
  float3 bt709_color = renodx::color::bt709::from::AP1(color);
  SetTonemappedBT709(bt709_color);

  color = renodx::color::ap1::from::BT709(bt709_color);
  color_red = color.r;
  color_green = color.g;
  color_blue = color.b;
}

void SetTonemappedAP1(inout float3 color) {
  SetTonemappedAP1(color.r, color.g, color.b);
}

void SetGradedBT709(inout float3 color) {
  RENODX_UE_CONFIG.graded_bt709 = color;
  RENODX_UE_CONFIG.graded_bt709 *= sign(RENODX_UE_CONFIG.tonemapped_bt709);
}

float3 GenerateToneMap() {
  return renodx::draw::ToneMapPass(RENODX_UE_CONFIG.untonemapped_bt709, RENODX_UE_CONFIG.graded_bt709);
}

float3 GenerateToneMap(float3 graded_bt709) {
  SetGradedBT709(graded_bt709);
  return GenerateToneMap();
}

float4 GenerateOutput(uint OutputDevice = 0u) {
  float3 untonemapped_graded = renodx::draw::ComputeUntonemappedGraded(RENODX_UE_CONFIG.untonemapped_bt709, RENODX_UE_CONFIG.graded_bt709);
  float3 color;
  [branch]
  if (CUSTOM_LUT_OPTIMIZATION == 1.f) {
    // Perform here and now
    color = renodx::draw::ToneMapPass(untonemapped_graded);
  } else {
    color = untonemapped_graded; // Apply in output
  }

  renodx::draw::Config config = renodx::draw::BuildConfig();
  if (OutputDevice != 0u) {
    config.intermediate_encoding = renodx::draw::ENCODING_PQ;
    config.intermediate_scaling = RENODX_DIFFUSE_WHITE_NITS;
    config.intermediate_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
  }
  color = renodx::draw::RenderIntermediatePass(color, config);
  color *= 1.f / 1.05f;
  return float4(color, 1.f);
}

float4 GenerateOutput(float3 graded_bt709, uint OutputDevice = 0u) {
  SetGradedBT709(graded_bt709);
  return GenerateOutput(OutputDevice);
}

void HandleLUTOutput(
    inout float red, inout float green, inout float blue,
    inout float luminance,
    float2 position,
    bool is_pq) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return;
  if (CUSTOM_GRAIN_TYPE == 0.f && CUSTOM_LUT_OPTIMIZATION == 1.f) return;

  renodx::draw::Config config = renodx::draw::BuildConfig();
  if (is_pq) {
    config.intermediate_encoding = renodx::draw::ENCODING_PQ;
    config.intermediate_scaling = RENODX_DIFFUSE_WHITE_NITS;
    config.intermediate_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
  }

  float3 linear_color = renodx::draw::InvertIntermediatePass(float3(red, green, blue), config);
  float3 tonemapped;
  [branch]
  if (CUSTOM_LUT_OPTIMIZATION == 0.f) {
    tonemapped = renodx::draw::ToneMapPass(linear_color, config);
  } else {
    tonemapped = linear_color;
  }

  luminance = renodx::color::y::from::BT709(abs(tonemapped));

  if (CUSTOM_GRAIN_TYPE == 1.f && CUSTOM_GRAIN_STRENGTH != 0.f) {
    float3 grained = renodx::effects::ApplyFilmGrain(
        tonemapped,
        position,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
    tonemapped = grained;
  }
  tonemapped = renodx::draw::RenderIntermediatePass(tonemapped, config);

  red = tonemapped.r;
  green = tonemapped.g;
  blue = tonemapped.b;
}
