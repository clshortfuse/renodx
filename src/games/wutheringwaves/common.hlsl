#include "./shared.h"

#define CAPTURE_UNTONEMAPPED(dst, c) const float3 dst = (c).xyz

#define CAPTURE_TONEMAPPED(dst, c) const float3 dst = (c).xyz


namespace wuwa {

static const float3x3 DCIP3_to_BT2020_MAT = float3x3(
    0.75383303, 0.19859737, 0.04756960,
    0.04574385, 0.94177722, 0.01247893,
    -0.00121034, 0.01760172, 0.98360862
);

}

float3 HandleLUTOutput(float3 lut_output, float3 untonemapped, float3 tonemapped) {
  lut_output = renodx::draw::InvertIntermediatePass(lut_output);

  if (RENODX_TONE_MAP_TYPE != 0) {
    if (RENODX_COLOR_GRADE_STRENGTH == 0) {
      lut_output = untonemapped;
    } else {
        lut_output =
          renodx::draw::ApplyPerChannelCorrection(untonemapped,
                                                  lut_output,
                                                  RENODX_PER_CHANNEL_BLOWOUT_RESTORATION,
                                                  RENODX_PER_CHANNEL_HUE_CORRECTION,
                                                  RENODX_PER_CHANNEL_CHROMINANCE_CORRECTION,
                                                  RENODX_PER_CHANNEL_HUE_SHIFT);

        lut_output =
            renodx::tonemap::UpgradeToneMap(
                untonemapped,
                tonemapped,
                lut_output,
                RENODX_COLOR_GRADE_STRENGTH,
                1.f);
    }

    lut_output = renodx::draw::ToneMapPass(lut_output);
  }

  lut_output = renodx::draw::RenderIntermediatePass(lut_output);

  return lut_output;
}

#define GENERATE_LUT_OUTPUT(T)                                               \
  T GenerateLUTOutput(T graded_bt709) {                                     \
    graded_bt709 = renodx::draw::RenderIntermediatePass(graded_bt709); \
    return graded_bt709;                                                 \
  }

GENERATE_LUT_OUTPUT(float3)
GENERATE_LUT_OUTPUT(float4)
