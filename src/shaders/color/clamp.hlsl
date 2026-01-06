#ifndef RENODX_SHADERS_COLOR_CLAMP_HLSL
#define RENODX_SHADERS_COLOR_CLAMP_HLSL

#include "./rgb.hlsl"

namespace renodx {
namespace color {

namespace bt709 {
namespace clamp {
float3 BT709(float3 bt709) {
  return max(0, bt709);
}
float3 BT2020(float3 bt709) {
  float3 bt2020 = renodx::color::bt2020::from::BT709(bt709);
  bt2020 = max(0, bt2020);
  return renodx::color::bt709::from::BT2020(bt2020);
}

float3 AP1(float3 bt709) {
  float3 ap1 = renodx::color::ap1::from::BT709(bt709);
  ap1 = max(0, ap1);
  return renodx::color::bt709::from::AP1(ap1);
}
}  // namespace clamp
}  // namespace bt709

namespace bt2020 {
namespace clamp {
float3 BT709(float3 bt2020) {
  float3 bt709 = renodx::color::bt709::from::BT2020(bt2020);
  bt709 = max(0, bt709);
  return renodx::color::bt2020::from::BT709(bt709);
}
float3 BT2020(float3 bt2020) {
  return max(0, bt2020);
}
float3 AP1(float3 bt2020) {
  float3 ap1 = renodx::color::ap1::from::BT2020(bt2020);
  ap1 = max(0, ap1);
  return renodx::color::bt2020::from::AP1(ap1);
}

}  // namespace clamp
}  // namespace bt2020

namespace ap1 {
namespace clamp {
float3 BT709(float3 ap1) {
  float3 bt709 = renodx::color::bt709::from::AP1(ap1);
  bt709 = max(0, bt709);
  return renodx::color::ap1::from::BT709(bt709);
}
float3 BT2020(float3 ap1) {
  float3 bt2020 = renodx::color::bt2020::from::AP1(ap1);
  bt2020 = max(0, bt2020);
  return renodx::color::ap1::from::BT2020(bt2020);
}
float3 AP1(float3 ap1) {
  return max(0, ap1);
}
}  // namespace clamp
}  // namespace ap1

}  // namespace color
}  // namespace renodx

#endif  // RENODX_SHADERS_COLOR_CLAMP_HLSL