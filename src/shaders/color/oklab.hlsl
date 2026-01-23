#ifndef SRC_SHADERS_COLOR_OKLAB_HLSL_
#define SRC_SHADERS_COLOR_OKLAB_HLSL_

#include "../math.hlsl"
namespace renodx {
namespace color {

namespace bt709 {
namespace from {
float3 OkLab(float3 oklab) {
  static const float3x3 OKLAB_2_OKLABLMS = {
    1.f, 0.3963377774f, 0.2158037573f,
    1.f, -0.1055613458f, -0.0638541728f,
    1.f, -0.0894841775f, -1.2914855480f
  };

  static const float3x3 OKLABLMS_2_BT709 = {
    4.0767416621f, -3.3077115913f, 0.2309699292f,
    -1.2684380046f, 2.6097574011f, -0.3413193965f,
    -0.0041960863f, -0.7034186147f, 1.7076147010f
  };

  float3 lms = mul(OKLAB_2_OKLABLMS, oklab);

  lms = lms * lms * lms;

  return mul(OKLABLMS_2_BT709, lms);
}
}  // namespace from
}  // namespace bt709

namespace oklab {
namespace from {
float3 BT709(float3 bt709) {
  static const float3x3 BT709_2_OKLABLMS = {
    0.4122214708f, 0.5363325363f, 0.0514459929f,
    0.2119034982f, 0.6806995451f, 0.1073969566f,
    0.0883024619f, 0.2817188376f, 0.6299787005f
  };
  static const float3x3 OKLABLMS_2_OKLAB = {
    0.2104542553f, 0.7936177850f, -0.0040720468f,
    1.9779984951f, -2.4285922050f, 0.4505937099f,
    0.0259040371f, 0.7827717662f, -0.8086757660f
  };

  float3 lms = mul(BT709_2_OKLABLMS, bt709);

  lms = renodx::math::Cbrt(lms);

  return mul(OKLABLMS_2_OKLAB, lms);
}

float3 OkLCh(float3 oklch) {
  float l = oklch[0];
  float c = oklch[1];
  float h = oklch[2];
  return float3(l, c * cos(h), c * sin(h));
}
}  // namespace from
}  // namespace oklab

namespace oklch {
namespace from {
float3 OkLab(float3 oklab) {
  float l = oklab[0];
  float a = oklab[1];
  float b = oklab[2];
  return float3(l, distance(oklab.yz, 0), atan2(b, a));
}
float3 BT709(float3 bt709) {
  float3 ok_lab = renodx::color::oklab::from::BT709(bt709);
  return OkLab(ok_lab);
}
}  // namespace from
}  // namespace oklch

namespace bt709 {
namespace from {
float3 OkLCh(float3 oklch) {
  float3 ok_lab = renodx::color::oklab::from::OkLCh(oklch);
  return OkLab(ok_lab);
}

}  // namespace from
}  // namespace bt709

}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_OKLAB_HLSL_