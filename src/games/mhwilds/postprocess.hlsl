#ifndef SRC_MHWILDS_POSTPROCESS_HLSL_
#define SRC_MHWILDS_POSTPROCESS_HLSL_
#include "./shared.h"

float NormalizeExposure() {
  return CUSTOM_EXPOSURE_STRENGTH * ((CUSTOM_LUT_EXPOSURE_REVERSE * 5.f) + 1);
}

float PickExposure(float vanilla, float fixed = CUSTOM_FLAT_EXPOSURE_DEFAULT) {
  float normalizedCustomExposure = NormalizeExposure();

  if (CUSTOM_EXPOSURE_TYPE == 1.f) {
    return fixed * normalizedCustomExposure;
  }
  return vanilla * normalizedCustomExposure;
}

float FlatExposure(float fixed = CUSTOM_FLAT_EXPOSURE_DEFAULT) {
  float normalizedCustomExposure = NormalizeExposure();

  return fixed * normalizedCustomExposure;
}

float3 CustomLUTColor(float3 ap1_input, float3 ap1_output) {
  float ap1_input_y = renodx::color::y::from::AP1(ap1_input);
  float ap1_output_y = renodx::color::y::from::AP1(ap1_output);
  float3 new_color;
  new_color = lerp(
      ap1_input * (renodx::math::DivideSafe(ap1_output_y, ap1_input_y, 0)),
      ap1_output,
      CUSTOM_LUT_COLOR_STRENGTH);

  if (CUSTOM_LUT_EXPOSURE_REVERSE > 0.f) {
    new_color = lerp(
        ap1_input,
        ap1_output * (renodx::math::DivideSafe(ap1_input_y, ap1_output_y, 0)),
        CUSTOM_LUT_COLOR_STRENGTH);
  }

  return new_color;
}

void CustomVignette(inout float vignette) {
  vignette = lerp(1.f, vignette, CUSTOM_VIGNETTE);
}

#endif  // SRC_MHWILDS_POSTPROCESS_HLSL_
