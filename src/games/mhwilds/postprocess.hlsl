#ifndef SRC_MHWILDS_POSTPROCESS_HLSL_
#define SRC_MHWILDS_POSTPROCESS_HLSL_
#include "./include/postprocess_cbuffers.hlsl"
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

float3 PickExposure(float3 vanilla, float fixed = CUSTOM_FLAT_EXPOSURE_DEFAULT) {
  float normalizedCustomExposure = NormalizeExposure();

  if (CUSTOM_EXPOSURE_TYPE == 1.f) {
    float newExposure = fixed * normalizedCustomExposure;
    return float3(newExposure, newExposure, newExposure);
  }
  return vanilla.rgb * normalizedCustomExposure;
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

float3 VanillaSDRTonemapper(float3 color) {
  // color = renodx::color::ap1::from::BT709(color);

  float _2673 = (TonemapParam_002y)*color.r;
  float _2681 = 1.0f;
  // linearBegin
  if ((!(color.r >= (TonemapParam_000y)))) {
    _2681 = ((_2673 * _2673) * (3.0f - (_2673 * 2.0f)));
  }
  // invLinearBegin
  float _2682 = (TonemapParam_002y)*color.g;
  float _2690 = 1.0f;
  if ((!(color.g >= (TonemapParam_000y)))) {
    _2690 = ((_2682 * _2682) * (3.0f - (_2682 * 2.0f)));
  }
  float _2691 = (TonemapParam_002y)*color.b;
  float _2699 = 1.0f;
  if ((!(color.b >= (TonemapParam_000y)))) {
    _2699 = ((_2691 * _2691) * (3.0f - (_2691 * 2.0f)));
  }
  // linearStart
  float _2708 = (((bool)((color.r < (TonemapParam_001y)))) ? 0.0f : 1.0f);
  float _2709 = (((bool)((color.g < (TonemapParam_001y)))) ? 0.0f : 1.0f);
  float _2710 = (((bool)((color.b < (TonemapParam_001y)))) ? 0.0f : 1.0f);

  // contrast + madLinearStartContrastFactor + toe (and max nits and other stuff)
  color.r = ((((((TonemapParam_000x)*color.r) + (TonemapParam_002z)) * (_2681 - _2708)) + (((exp2(((log2(_2673)) * (TonemapParam_000w)))) * (1.0f - _2681)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*color.r) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2708));
  color.g = ((((((TonemapParam_000x)*color.g) + (TonemapParam_002z)) * (_2690 - _2709)) + (((exp2(((log2(_2682)) * (TonemapParam_000w)))) * (1.0f - _2690)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*color.g) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2709));
  color.b = ((((((TonemapParam_000x)*color.b) + (TonemapParam_002z)) * (_2699 - _2710)) + (((exp2(((log2(_2691)) * (TonemapParam_000w)))) * (1.0f - _2699)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w)*color.b) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _2710));

  // color = renodx::color::bt709::from::AP1(color);
  return color;
}

float3 UpgradeWithSDR(float3 untonemapped_bt709, float3 tonemapped_bt709) {
  float3 sdr;
  // sdr = renodx::tonemap::renodrt::NeutralSDR(untonemapped_bt709); // Higher contrast, desaturates and searing.
  sdr = saturate(untonemapped_bt709);
  // tonemapped_bt709 = saturate(tonemapped_bt709); // desaturates
  float3 output = renodx::tonemap::UpgradeToneMap(untonemapped_bt709, sdr, tonemapped_bt709, 1.f);

  output = renodx::color::ap1::from::BT709(output);
  return output;
}

#endif  // SRC_MHWILDS_POSTPROCESS_HLSL_
