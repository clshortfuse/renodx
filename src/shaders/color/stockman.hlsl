#ifndef SRC_SHADERS_COLOR_STOCKMAN_HLSL_
#define SRC_SHADERS_COLOR_STOCKMAN_HLSL_

#include "../math.hlsl"
#include "./rgb.hlsl"

namespace renodx {
namespace color {
namespace bt709 {
namespace from {

float3 StockmanDKL(float3 dkl) {
  // Modified Stockman & Sharpe for LCD LED
  float3x3 XYZ_TO_LMS_WUERGER_2020 = float3x3(
      0.187596268556126, 0.585168649077728, -0.026384263306304,
      -0.133397430663221, 0.405505777260049, 0.034502127690364,
      0.000244379021663, -0.000542995890619, 0.019406849066323);

  // Manually recomputed from CIE 1931 XYZ 1nm to Stockman 2deg 1nm 8dp with MB2 Weights
  float3x3 XYZ_TO_LMS_2006 = float3x3(
      0.185082982238733f, 0.584081279463687f, -0.0240722415044404f,
      -0.134433056469973f, 0.405752392775348f, 0.0358252602217631f,
      0.000789456671966863f, -0.000912281325916184f, 0.0198490812339463f);

  float3x3 XYZ_FROM_LMS = renodx::math::Invert3x3(XYZ_TO_LMS_2006);

  // CIE 1931 2 degree standard observer
  float2 WHITE_POINT_D65 = float2(0.31272, 0.32903);
  float3 D65_XYZ = renodx::color::xyz::from::xyY(float3(WHITE_POINT_D65, 1.f));
  float3 LMS_WHITE = mul(XYZ_TO_LMS_2006, D65_XYZ);

  float mc1 = LMS_WHITE.x / LMS_WHITE.y;
  float mc2 = (LMS_WHITE.x + LMS_WHITE.y) / LMS_WHITE.z;

  // actual ACC color space (DKL-like / ACC)
  float3x3 LMS_TO_DKL_D65 = float3x3(
      1, 1, 0,
      1, -mc1, 0,
      -1, -1, mc2);

  float3x3 LMS_FROM_DKL_D65 = renodx::math::Invert3x3(LMS_TO_DKL_D65);

  float3x3 RGB_TO_DKL_D65 = mul(LMS_TO_DKL_D65, XYZ_TO_LMS_2006);
  float3x3 DKL_D65_TO_RGB = renodx::math::Invert3x3(RGB_TO_DKL_D65);

  float3 lms_color = mul(LMS_FROM_DKL_D65, dkl);

  float3 lms_background = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::xyY(float3(WHITE_POINT_D65, 1.00f)));

  lms_background = 0;  // skip for now
  float3 lms_final = lms_color + lms_background;

  float3 xyz = mul(XYZ_FROM_LMS, lms_final);

  float3 bt709 = renodx::color::bt709::from::XYZ(xyz);
  return bt709;
}
}  // namespace from
}  // namespace bt709

namespace stockmandkl {
namespace from {
float3 BT709(float3 bt709) {
  // Modified Stockman & Sharpe for LCD LED
  float3x3 XYZ_TO_LMS_WUERGER_2020 = float3x3(
      0.187596268556126, 0.585168649077728, -0.026384263306304,
      -0.133397430663221, 0.405505777260049, 0.034502127690364,
      0.000244379021663, -0.000542995890619, 0.019406849066323);

  // Manually recomputed from CIE 1931 XYZ 1nm to Stockman 2deg 1nm 8dp with MB2 Weights
  float3x3 XYZ_TO_LMS_2006 = float3x3(
      0.185082982238733f, 0.584081279463687f, -0.0240722415044404f,
      -0.134433056469973f, 0.405752392775348f, 0.0358252602217631f,
      0.000789456671966863f, -0.000912281325916184f, 0.0198490812339463f);

  float3x3 XYZ_FROM_LMS = renodx::math::Invert3x3(XYZ_TO_LMS_2006);

  // CIE 1931 2 degree standard observer
  float2 WHITE_POINT_D65 = float2(0.31272, 0.32903);
  float3 D65_XYZ = renodx::color::xyz::from::xyY(float3(WHITE_POINT_D65, 1.f));
  float3 LMS_WHITE = mul(XYZ_TO_LMS_2006, D65_XYZ);

  float mc1 = LMS_WHITE.x / LMS_WHITE.y;
  float mc2 = (LMS_WHITE.x + LMS_WHITE.y) / LMS_WHITE.z;

  // actual ACC color space (DKL-like / ACC)
  float3x3 LMS_TO_DKL_D65 = float3x3(
      1, 1, 0,
      1, -mc1, 0,
      -1, -1, mc2);

  float3x3 LMS_FROM_DKL_D65 = renodx::math::Invert3x3(LMS_TO_DKL_D65);
  float3 xyz = renodx::color::xyz::from::BT709(bt709);
  float3 lms_input = mul(XYZ_TO_LMS_2006, xyz);
  float3 dkl_input = mul(LMS_TO_DKL_D65, lms_input);

  float3 lms_background = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::xyY(float3(WHITE_POINT_D65, 1.00f)));

  lms_background = 0;  // skip for now
  float3 delta = lms_input - lms_background;

  float3 dkl = mul(LMS_TO_DKL_D65, delta);

  return dkl;
}
}  // namespace from
}  // namespace stockmandkl

}  // namespace color
}  // namespace renodx
#endif  // SRC_SHADERS_COLOR_STOCKMAN_HLSL_