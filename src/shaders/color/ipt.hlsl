#ifndef SRC_SHADERS_COLOR_IPT_HLSL_
#define SRC_SHADERS_COLOR_IPT_HLSL_
#include "../math.hlsl"
#include "./rgb.hlsl"

namespace renodx {
namespace color {

namespace ipt {
// https://repository.rit.edu/cgi/viewcontent.cgi?article=3862&context=theses
// https://www.researchgate.net/publication/221677980_Development_and_Testing_of_a_Color_Space_IPT_with_Improved_Hue_Uniformity

static const float3x3 XYZ_D65_TO_LMS_EBNER_MAT = float3x3(
    0.4002f, 0.7075f, -0.0807f,
    -0.2280f, 1.1500f, 0.0612f,
    0.0000f, 0.0000f, 0.9184f);

static const float RESPONSE_EXPONENT = 1.f / 2.3f;
namespace from {
float3 BT709(float3 bt709_color) {
  float3 lms = mul(mul(XYZ_D65_TO_LMS_EBNER_MAT, BT709_TO_XYZ_MAT), bt709_color);
  float3 plms = renodx::math::SignPow(lms, RESPONSE_EXPONENT);
  float3 ipt_color = mul(PLMS_TO_IPT_MAT, plms);
  return ipt_color;
}
}  // namespace from
}  // namespace ipt

namespace bt709 {
namespace from {
float3 IPT(float3 ipt_color) {
  float3 plms_color = mul(renodx::math::Invert3x3(PLMS_TO_IPT_MAT), ipt_color);
  float3 lms_color = renodx::math::SignPow(plms_color, 1.f / ipt::RESPONSE_EXPONENT);
  float3 bt709_color = mul(
      mul(
          renodx::math::Invert3x3(BT709_TO_XYZ_MAT),
          renodx::math::Invert3x3(ipt::XYZ_D65_TO_LMS_EBNER_MAT)),
      lms_color);
  return bt709_color;
}

}  // namespace from
}  // namespace bt709
}  // namespace color
}  // namespace renodx
#endif  // SRC_SHADERS_COLOR_IPT_HLSL_
