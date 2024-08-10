#ifndef SRC_SHADERS_COLOR_CORRECT_HLSL_
#define SRC_SHADERS_COLOR_CORRECT_HLSL_

#include "./color.hlsl"

namespace renodx {
namespace color {
namespace correct {

float Gamma(float x, bool pow_to_srgb = false) {
  if (pow_to_srgb) {
    return renodx::color::bt709::from::SRGB(pow(x, 1.f / 2.2f));
  }  // srgb2pow
  return pow(renodx::color::srgb::from::BT709(x), 2.2f);
}

float GammaSafe(float x, bool pow_to_srgb = false) {
  if (pow_to_srgb) {
    return sign(x) * renodx::color::bt709::from::SRGB(pow(abs(x), 1.f / 2.2f));
  }
  return sign(x) * pow(renodx::color::srgb::from::BT709(abs(x)), 2.2f);
}

float3 Gamma(float3 color, bool pow_to_srgb = false) {
  return float3(
      Gamma(color.r, pow_to_srgb),
      Gamma(color.g, pow_to_srgb),
      Gamma(color.b, pow_to_srgb));
}

float3 GammaSafe(float3 color, bool pow2srgb = false) {
  float3 signs = sign(color);
  color = abs(color);
  color = float3(
      Gamma(color.r, pow2srgb),
      Gamma(color.g, pow2srgb),
      Gamma(color.b, pow2srgb));
  color *= signs;
  return color;
}

float3 Hue(float3 incorrect_color, float3 correct_color) {
  float3 correct_lch = renodx::color::oklch::from::BT709(correct_color);
  float3 incorrect_lch = renodx::color::oklch::from::BT709(incorrect_color);
  incorrect_lch[2] = correct_lch[2];
  float3 color = renodx::color::bt709::from::OkLCh(incorrect_lch);
  color = mul(BT709_TO_AP1_MAT, color);  // Convert to AP1
  color = max(0, color);                 // Clamp to AP1
  color = mul(AP1_TO_BT709_MAT, color);  // Convert BT709
  return color;
}

}  // namespace correct
}  // namespace color
}  // namespace renodx
#endif  // SRC_SHADERS_COLOR_CORRECT_HLSL_
