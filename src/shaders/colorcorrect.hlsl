#ifndef SRC_SHADERS_COLORCORRECT_HLSL_
#define SRC_SHADERS_COLORCORRECT_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"

namespace renodx {
namespace color {
namespace correct {

float Gamma(float x, bool pow_to_srgb = false) {
  if (pow_to_srgb) {
    return srgb::Decode(gamma::Encode(x));
  }
  // srgb2pow
  return gamma::Decode(srgb::Encode(x));
}

float GammaSafe(float x, bool pow_to_srgb = false) {
  if (pow_to_srgb) {
    return renodx::math::Sign(x) * srgb::Decode(gamma::Encode(abs(x)));
  }
  return renodx::math::Sign(x) * gamma::Decode(srgb::Encode(abs(x)));
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
  float3 signs = renodx::math::Sign(color);
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

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);

  float chrominance_pre_adjust = distance(incorrect_lab.yz, 0);

  incorrect_lab.yz = lerp(incorrect_lab.yz, correct_lab.yz, strength);

  float chrominance_post_adjust = distance(incorrect_lab.yz, 0);

  if (chrominance_post_adjust != 0.f) {
    incorrect_lab.yz *= chrominance_pre_adjust / chrominance_post_adjust;
  }

  float3 color = renodx::color::bt709::from::OkLab(incorrect_lab);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

}  // namespace correct
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLORCORRECT_HLSL_
