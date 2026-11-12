#ifndef GEARSOFWAR4_LEGACY_LUT_HLSL_
#define GEARSOFWAR4_LEGACY_LUT_HLSL_

#include "../common.hlsl"

// These older builders finish their pre-film grading in BT.709, not AP1.
void SetGearsUntonemappedBT709(float3 color) {
  RENODX_UE_CONFIG.untonemapped_bt709 = color;
  RENODX_UE_CONFIG.untonemapped_ap1 = renodx::color::ap1::from::BT709(color);
  RENODX_UE_CONFIG.tonemapped_bt709 = abs(color);
}

// UE's legacy/mobile shoulder is (a*x+b)/(x+d), starting at h.
// Continue its tangent above h while retaining the original toe, linear
// section, color matrix and shadow tint. The added term is tangent(x)-curve(x):
// (a*d-b)*(x-h)^2 / ((h+d)^2*(x+d)). It is zero with zero derivative at h.
// Work on the pre-curve value, before the original shader clamps it to h.
float3 ExtendGearsLegacyShoulder(float3 input, float3 vanilla, float h, float d, float a, float b) {
  float denominator = h + d;
  float numerator = a * d - b;
  float3 extended = vanilla;
  if (denominator > 1.e-6f && numerator > 0.f) {
    float3 distance = max(input - h, 0.f);
    float slope = numerator / (denominator * denominator);
    extended += slope * distance * (distance / (denominator + distance));
  }
  return extended;
}

float4 GenerateGearsLutOutput(float3 graded, float3 neutral, bool legacy, uint output_device) {
  // The filmic branch continues to use the mod's normal grading transport.
  SetGradedBT709(graded);
  renodx::draw::Config config = GetOutputConfig(output_device);
  // Compare grading with the game's actual legacy SDR result. Using a neutral
  // RenoDRT curve here would reintroduce the legacy shoulder as a grading loss.
  float3 color;
  if (legacy) {
    color = renodx::draw::ComputeUntonemappedGraded(
        RENODX_UE_CONFIG.untonemapped_bt709,
        RENODX_UE_CONFIG.graded_bt709, neutral, config);
  } else {
    color = renodx::draw::ComputeUntonemappedGraded(
        RENODX_UE_CONFIG.untonemapped_bt709,
        RENODX_UE_CONFIG.graded_bt709, config);
  }
  if (CUSTOM_LUT_OPTIMIZATION == 0.f) {
    config.gamma_correction = 0.f;
  } else {
    color = Gears4ToneMapPass(color, config);
  }
  color = renodx::draw::RenderIntermediatePass(color, config);
  return float4(color / 1.05f, 1.f);
}

#endif  // GEARSOFWAR4_LEGACY_LUT_HLSL_
