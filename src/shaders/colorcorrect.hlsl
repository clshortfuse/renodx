#ifndef SRC_SHADERS_COLORCORRECT_HLSL_
#define SRC_SHADERS_COLORCORRECT_HLSL_

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

float4 Gamma(float4 color, bool pow2srgb = false) {
  return float4(Gamma(color.rgb, pow2srgb), color.a);
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

float4 GammaSafe(float4 color, bool pow2srgb = false) {
  return float4(GammaSafe(color.rgb, pow2srgb), color.a);
}

float3 Hue(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);
  float3 correct_lch = renodx::color::oklch::from::OkLab(correct_lab);

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 incorrect_lch = renodx::color::oklch::from::OkLab(incorrect_lab);
  if (strength == 1.f) {
    incorrect_lch[2] = correct_lch[2];
  } else {
    float old_chroma = incorrect_lch[1];

    incorrect_lab.yz = lerp(incorrect_lab.yz, correct_lab.yz, strength);
    incorrect_lch = renodx::color::oklch::from::OkLab(incorrect_lab);
    incorrect_lch[1] = old_chroma;
  }

  float3 color = renodx::color::bt709::from::OkLCh(incorrect_lch);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

}  // namespace correct
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLORCORRECT_HLSL_
