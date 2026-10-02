#include "../common.hlsli"

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
