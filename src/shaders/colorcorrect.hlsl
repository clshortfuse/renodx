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

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 correct_ab = correct_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(correct_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);
  incorrect_lab.yz = incorrect_ab * scale;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 HueOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 correct_ab = correct_lab.yz;

  // Preserve original chrominance (magnitude of the a–b vector)
  float chrominance_pre_adjust = length(incorrect_ab);

  // Blend chrominance and hue by interpolating (a, b) components
  float2 blended_ab = lerp(incorrect_ab, correct_ab, strength);

  // Rescale to original chrominance to avoid saturation shift
  float chrominance_post_adjust = length(blended_ab);
  blended_ab *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);

  incorrect_lab.yz = blended_ab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 HueICtCp(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_ictcp = renodx::color::ictcp::from::BT709(incorrect_color);
  float3 correct_ictcp = renodx::color::ictcp::from::BT709(correct_color);

  float2 incorrect_ctcp = incorrect_ictcp.yz;
  float2 correct_ctcp = correct_ictcp.yz;

  // Preserve original chrominance (magnitude of the Ct-Cp vector)
  float chrominance_pre_adjust = length(incorrect_ctcp);

  // Blend chrominance and hue by interpolating (Ct, Cp) components
  float2 blended_ctcp = lerp(incorrect_ctcp, correct_ctcp, strength);

  // Rescale to original chrominance to avoid saturation shift
  float chrominance_post_adjust = length(blended_ctcp);
  blended_ctcp *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);

  incorrect_ictcp.yz = blended_ctcp;

  float3 result = renodx::color::bt709::from::ICtCp(incorrect_ictcp);
  return renodx::color::bt709::clamp::AP1(result);
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
