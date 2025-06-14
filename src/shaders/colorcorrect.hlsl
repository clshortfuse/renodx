#ifndef SRC_SHADERS_COLORCORRECT_HLSL_
#define SRC_SHADERS_COLORCORRECT_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"

namespace renodx {
namespace color {
namespace correct {

#define GAMMA(T)                                               \
  T Gamma(T c, bool pow_to_srgb = false, float gamma = 2.2f) { \
    if (pow_to_srgb) {                                         \
      return srgb::Decode(color::gamma::Encode(c, gamma));     \
    } else {                                                   \
      return color::gamma::Decode(srgb::Encode(c), gamma);     \
    }                                                          \
  }

GAMMA(float)
GAMMA(float2)
GAMMA(float3)

float4 Gamma(float4 color, bool pow_to_srgb = false, float gamma = 2.2f) {
  return float4(Gamma(color.rgb, pow_to_srgb, gamma), color.a);
}

#define GAMMA_SAFE(T)                                                                   \
  T GammaSafe(T c, bool pow_to_srgb = false, float gamma = 2.2f) {                      \
    if (pow_to_srgb) {                                                                  \
      return renodx::math::Sign(c) * srgb::Decode(color::gamma::Encode(abs(c), gamma)); \
    } else {                                                                            \
      return renodx::math::Sign(c) * color::gamma::Decode(srgb::Encode(abs(c)), gamma); \
    }                                                                                   \
  }

GAMMA_SAFE(float)
GAMMA_SAFE(float2)
GAMMA_SAFE(float3)

float4 GammaSafe(float4 color, bool pow_to_srgb = false, float gamma = 2.2f) {
  return float4(Gamma(color.rgb, pow_to_srgb, gamma), color.a);
}

#undef GAMMA
#undef GAMMA_SAFE

float3 ChrominanceOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);
  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 correct_ab = correct_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(correct_ab);

  // Get tint (hue direction)
  float2 incorrect_direction = (incorrect_ab / incorrect_chrominance) * step(0.f, incorrect_chrominance);

  // Blend chrominance and apply to original tint
  float blended_chroma = lerp(incorrect_chrominance, correct_chrominance, strength);
  incorrect_lab.yz = incorrect_direction * blended_chroma;

  float3 color = renodx::color::bt709::from::OkLab(incorrect_lab);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 HueOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);

  float chrominance_pre_adjust = distance(incorrect_lab.yz, 0);

  incorrect_lab.yz = lerp(incorrect_lab.yz, correct_lab.yz, strength);

  float chrominance_post_adjust = distance(incorrect_lab.yz, 0);

  incorrect_lab.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);

  float3 color = renodx::color::bt709::from::OkLab(incorrect_lab);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 HueICtCp(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 correct_perceptual = renodx::color::ictcp::from::BT709(correct_color);

  float3 incorrect_perceptual = renodx::color::ictcp::from::BT709(incorrect_color);

  float chrominance_pre_adjust = distance(incorrect_perceptual.yz, 0);

  incorrect_perceptual.yz = lerp(incorrect_perceptual.yz, correct_perceptual.yz, strength);

  float chrominance_post_adjust = distance(incorrect_perceptual.yz, 0);

  incorrect_perceptual.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);

  float3 color = renodx::color::bt709::from::ICtCp(incorrect_perceptual);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 HuedtUCS(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 correct_perceptual = renodx::color::dtucs::jch::from::BT709(correct_color);

  float3 incorrect_perceptual = renodx::color::dtucs::jch::from::BT709(incorrect_color);

  float chrominance_pre_adjust = incorrect_perceptual[1];

  incorrect_perceptual[2] = lerp(incorrect_perceptual[2], correct_perceptual[2], strength);

  incorrect_perceptual[1] = chrominance_pre_adjust;

  float3 color = renodx::color::bt709::from::dtucs::JCH(incorrect_perceptual);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 Hue(float3 incorrect_color, float3 correct_color, float strength = 1.f, uint method = 0u) {
  if (method == 1u) return HueICtCp(incorrect_color, correct_color, strength);
  if (method == 2u) return HuedtUCS(incorrect_color, correct_color, strength);
  return HueOKLab(incorrect_color, correct_color, strength);
}

}  // namespace correct
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLORCORRECT_HLSL_
