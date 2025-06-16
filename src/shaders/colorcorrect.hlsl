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

float3 ChrominanceICtCp(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_ictcp = renodx::color::ictcp::from::BT709(incorrect_color);
  float3 correct_ictcp = renodx::color::ictcp::from::BT709(correct_color);

  float2 incorrect_ctcp = incorrect_ictcp.yz;
  float2 correct_ctcp = correct_ictcp.yz;

  // Compute chrominance (magnitude of the Ct–Cp vector)
  float incorrect_chrominance = length(incorrect_ctcp);
  float correct_chrominance = length(correct_ctcp);

  // Scale chrominance vector to match target chrominance
  float chroma_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chroma_ratio, strength);
  incorrect_ictcp.yz = incorrect_ctcp * scale;

  float3 result = renodx::color::bt709::from::ICtCp(incorrect_ictcp);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 ChrominancedtUCS(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_uvY = renodx::color::dtucs::uvY::from::BT709(incorrect_color);
  float3 correct_uvY = renodx::color::dtucs::uvY::from::BT709(correct_color);

  float2 incorrect_uv = incorrect_uvY.xy;
  float2 correct_uv = correct_uvY.xy;

  float Y_incorrect = incorrect_uvY.z;
  float Y_correct = correct_uvY.z;

  // Compute perceptual lightness (L*) for both colors
  float L_star_hat_i = pow(Y_incorrect, 0.631651345306265f);
  float L_star_i = 2.098883786377f * L_star_hat_i / (L_star_hat_i + 1.12426773749357f);
  float L_star_hat_c = pow(Y_correct, 0.631651345306265f);
  float L_star_c = 2.098883786377f * L_star_hat_c / (L_star_hat_c + 1.12426773749357f);

  // Compute chrominance (C) for both colors
  float M2_incorrect = dot(incorrect_uv, incorrect_uv);
  float M2_correct = dot(correct_uv, correct_uv);
  float C_incorrect = 15.932993652962535f * pow(L_star_i, 0.6523997524738018f) * pow(M2_incorrect, 0.6007557017508491f) / color::dtucs::L_WHITE;
  float C_correct = 15.932993652962535f * pow(L_star_c, 0.6523997524738018f) * pow(M2_correct, 0.6007557017508491f) / color::dtucs::L_WHITE;

  // Interpolate chrominance while preserving original hue direction
  float C = lerp(C_incorrect, C_correct, strength);
  float h = atan2(incorrect_uv.y, incorrect_uv.x);

  // Compute original perceptual lightness (J)
  float J = pow(L_star_i / color::dtucs::L_WHITE, 1.f);

  // Build JCH from original J, interpolated chrominance, and original hue
  float3 final_jch = float3(J, C, h);

  float3 result = renodx::color::bt709::from::dtucs::JCH(final_jch);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 Chrominance(float3 incorrect_color, float3 correct_color, float strength = 1.f, uint method = 0u) {
  if (method == 1u) return ChrominanceICtCp(incorrect_color, correct_color, strength);
  if (method == 2u) return ChrominancedtUCS(incorrect_color, correct_color, strength);
  return ChrominanceOKLab(incorrect_color, correct_color, strength);
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

  float3 incorrect_uvY = renodx::color::dtucs::uvY::from::BT709(incorrect_color);
  float3 correct_uvY = renodx::color::dtucs::uvY::from::BT709(correct_color);

  float2 incorrect_uv = incorrect_uvY.xy;
  float2 correct_uv = correct_uvY.xy;

  float Y_incorrect = incorrect_uvY.z;
  float Y_correct = correct_uvY.z;

  // Compute perceptual lightness (L*) for both colors
  float L_star_hat_i = pow(Y_incorrect, 0.631651345306265f);
  float L_star_i = 2.098883786377f * L_star_hat_i / (L_star_hat_i + 1.12426773749357f);
  float L_star_hat_c = pow(Y_correct, 0.631651345306265f);
  float L_star_c = 2.098883786377f * L_star_hat_c / (L_star_hat_c + 1.12426773749357f);

  // Compute chrominance (C) for both colors from uv vector magnitude and L*
  float M2_incorrect = dot(incorrect_uv, incorrect_uv);
  float M2_correct = dot(correct_uv, correct_uv);
  float C_incorrect = 15.932993652962535f * pow(L_star_i, 0.6523997524738018f) * pow(M2_incorrect, 0.6007557017508491f) / color::dtucs::L_WHITE;
  float C_correct = 15.932993652962535f * pow(L_star_c, 0.6523997524738018f) * pow(M2_correct, 0.6007557017508491f) / color::dtucs::L_WHITE;

  // Build chrominance-direction vectors (C * unit vector of hue angle)
  float2 incorrect_vec = C_incorrect * normalize(incorrect_uv);
  float2 correct_vec = C_correct * normalize(correct_uv);

  // Blend chrominance and hue by interpolating between chrominance-direction vectors
  float2 blended_vec = lerp(incorrect_vec, correct_vec, strength);

  // Rescale to original chrominance to avoid saturation shift
  float blended_chrominance = length(blended_vec);
  blended_vec *= renodx::math::DivideSafe(C_incorrect, blended_chrominance, 1.f);

  // Reconstruct hue from blended vector
  float h = atan2(blended_vec.y, blended_vec.x);

  // Compute original perceptual lightness (J)
  float J = pow(L_star_i / color::dtucs::L_WHITE, 1.f);

  // Build JCH from original J, original chrominance, and interpolated hue
  float3 final_jch = float3(J, C_incorrect, h);

  float3 result = renodx::color::bt709::from::dtucs::JCH(final_jch);
  return renodx::color::bt709::clamp::AP1(result);
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
