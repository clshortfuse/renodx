#include "../common.hlsli"

float3 ApplyLUTStrength(float3 color, float2 position, uint lut_size) {
  [branch]
  if (COLOR_GRADE_LUT_STRENGTH != 1.f) {
    uint2 texel = uint2(position);
    float3 input_color = float3(texel.x % lut_size, texel.y, texel.x / lut_size) / float(lut_size - 1u);
    // Game-specific pairing: 32^3 LUTs use sRGB input/output; 48^3 LUTs use PQ input and linear RGB here.
    // Callers pass a constant size, so the encoding selection is resolved at compile time.
    const bool is_srgb = (lut_size == 32u);
    if (is_srgb) {
      input_color = renodx::color::srgb::Decode(input_color);
      color = renodx::color::srgb::Decode(color);
    } else {
      // HDR input coordinates use PQ with 80-nit linear units; the mixer output is already linear here.
      input_color = renodx::color::pq::Decode(input_color, 80.f);
    }
    color = lerp(input_color, color, COLOR_GRADE_LUT_STRENGTH);
    if (is_srgb) {
      color = renodx::color::srgb::Encode(color);
    }
  }
  return color;
}

float3 CompressBT709ColorToLMS(float3 color_bt709) {
  float3 color_lms = renodx::color::lms::from::BT709(color_bt709);
  color_lms = CompressLMSRadial(color_lms);
  color_bt709 = renodx::color::bt709::from::LMS(color_lms);
  return color_bt709;
}

float3 CompressBT709ColorToBT2020(float3 color_bt709) {
  float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
  // color_bt2020 = CompressLMSRadial(color_bt2020);
  // color_bt2020 = renodx::color::gamut::GamutCompressBT2020(color_bt2020);
  color_bt709 = renodx::color::bt709::from::BT2020(color_bt2020);
  return color_bt709;
}

float3 CompressBT709ColorToXYZ(float3 color_bt709) {
  float3 color_xyz = renodx::color::xyz::from::BT709(color_bt709);
  color_xyz = CompressXYZRadial(color_xyz);
  color_bt709 = renodx::color::bt709::from::XYZ(color_xyz);
  return color_bt709;
}

float3 CompressLUTMixerOutput(float3 color) {
  [branch]
  if (TONE_MAP_TYPE == 3.f) {
    float3 lms = mul(renodx::tonemap::psychov::PSYCHO30_BT709_TO_LMS_MAT, color);
    lms = CompressLMSRadial(lms);
    color = mul(renodx::tonemap::psychov::PSYCHO30_LMS_TO_BT709_MAT, lms);
  }

  return color;
}
