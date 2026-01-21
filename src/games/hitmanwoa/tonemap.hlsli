#include "./shared.h"

// take hue from one color and chrominance from another in OKLab space
float3 HueAndChrominanceOKLab(
    float3 incorrect_color,
    float3 hue_reference_color,
    float3 chrominance_reference_color,
    float hue_correct_strength = 1.f,
    float chrominance_correct_strength = 1.f,
    float clamp_chrominance_loss = 0.f) {
  if (hue_correct_strength == 0.f && chrominance_correct_strength == 0.f) {
    return incorrect_color;
  } else if (hue_correct_strength == 0.f) {
    return renodx::color::correct::ChrominanceOKLab(incorrect_color, chrominance_reference_color, chrominance_correct_strength, clamp_chrominance_loss);
  } else if (chrominance_correct_strength == 0.f) {
    return renodx::color::correct::HueOKLab(incorrect_color, hue_reference_color, hue_correct_strength);
  }

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 hue_lab = renodx::color::oklab::from::BT709(hue_reference_color);
  float3 chrominance_lab = renodx::color::oklab::from::BT709(chrominance_reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 hue_ab = hue_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float target_chrominance = length(chrominance_lab.yz);

  // Scale original chrominance vector toward target chrominance
  float desired_chrominance = lerp(incorrect_chrominance, target_chrominance, chrominance_correct_strength);
  float scale = renodx::math::DivideSafe(desired_chrominance, incorrect_chrominance, 1.f);

  float t = 1.0f - step(1.0f, scale);  // t = 1 when scale < 1, 0 when scale >= 1
  scale = lerp(scale, 1.0f, t * clamp_chrominance_loss);

  float adjusted_chrominance = (incorrect_chrominance > 0.f)
                                   ? incorrect_chrominance * scale
                                   : desired_chrominance;

  // Blend hue direction between incorrect and reference colors
  float2 incorrect_dir = renodx::math::DivideSafe(
      incorrect_ab,
      float2(incorrect_chrominance, incorrect_chrominance),
      float2(0.f, 0.f));
  float hue_chrominance = length(hue_ab);
  float2 hue_dir = renodx::math::DivideSafe(
      hue_ab,
      float2(hue_chrominance, hue_chrominance),
      incorrect_dir);
  float2 blended_dir = lerp(incorrect_dir, hue_dir, hue_correct_strength);
  float blended_len = length(blended_dir);
  float2 final_dir = renodx::math::DivideSafe(
      blended_dir,
      float2(blended_len, blended_len),
      hue_dir);

  // Apply final hue direction and chroma magnitude
  float2 final_ab = final_dir * adjusted_chrominance;
  incorrect_lab.yz = final_ab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

#define APPLY_TONEMAP_HITMAN_GENERATOR(T)                                       \
  T ToneMapHitman(T x) {                                                        \
    return renodx::tonemap::ApplyCurve(x, 0.6f, 1.f, 0.1f, 1.f, 0.004f, 0.06f); \
  }

APPLY_TONEMAP_HITMAN_GENERATOR(float)
APPLY_TONEMAP_HITMAN_GENERATOR(float3)

#undef APPLY_TONEMAP_HITMAN_GENERATOR

float ToneMapHitmanDerivative(float x) {
  float N = 0.6f * x * x + 0.1f * x + 0.004f;
  float D = 0.6f * x * x + 1.f * x + 0.06f;

  float Np = 1.2f * x + 0.1f;  // dN/dx
  float Dp = 1.2f * x + 1.f;   // dD/dx

  return (Np * D - N * Dp) / (D * D);
}

#define APPLY_HITMAN_EXTENDED_GENERATOR(T)          \
  T ToneMapHitmanExtended(                          \
      T x,                                          \
      T base) {                                     \
    const float pivot_x = 0.0932816;                \
    float pivot_y = ToneMapHitman(pivot_x);         \
    float slope = ToneMapHitmanDerivative(pivot_x); \
                                                    \
    float offset = pivot_y - slope * pivot_x;       \
    T extended = slope * x + offset;                \
                                                    \
    return lerp(base, extended, step(pivot_x, x));  \
  }

APPLY_HITMAN_EXTENDED_GENERATOR(float)
APPLY_HITMAN_EXTENDED_GENERATOR(float3)

#undef APPLY_HITMAN_EXTENDED_GENERATOR

float3 ApplyCustomHitmanToneMap(float3 untonemapped) {
#if 1
  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = ToneMapHitmanExtended(y_in, ToneMapHitman(y_in));
  float3 hdr_tonemap = renodx::color::correct::Luminance(untonemapped, y_in, y_out);
#else
  float3 hdr_tonemap = ToneMapHitmanExtended(untonemapped, ToneMapHitman(untonemapped));
#endif

  float3 chrominance_reference_color = renodx::tonemap::ReinhardPiecewise(hdr_tonemap, 6.f, 0.0932816);

  hdr_tonemap = HueAndChrominanceOKLab(
      hdr_tonemap,
      untonemapped,                             // hue reference color
      chrominance_reference_color,              // chrominance reference color
      1.f,                                      // hue correct strength
      1.f,                                      // chrominance correct strength
      RENODX_PER_CHANNEL_BLOWOUT_RESTORATION);  // clamp chrominance loss

  return hdr_tonemap;
}

float ReinhardDerivative(float x, float peak) {
  return (peak * peak) / ((x + peak) * (x + peak));
}

#define APPLY_EXTENDED_GENERATOR(T)                           \
  T ApplyReinhardPlus(                                        \
      T x, T base, float peak = 1.f) {                        \
    float pivot_x = 0.465571;                                 \
    float pivot_y = renodx::tonemap::Reinhard(pivot_x, peak); \
    float slope = ReinhardDerivative(pivot_x, peak);          \
    T offset = pivot_y - slope * pivot_x;                     \
                                                              \
    T extended = slope * x + offset; /* match slope */        \
                                                              \
    return lerp(base, extended, step(pivot_x, x));            \
  }

APPLY_EXTENDED_GENERATOR(float)
APPLY_EXTENDED_GENERATOR(float3)
#undef APPLY_EXTENDED_GENERATOR

float3 ApplyCustomSimpleReinhardToneMap(float3 untonemapped) {
#if 1
  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = ApplyReinhardPlus(y_in, renodx::tonemap::Reinhard(y_in));
  float3 hdr_tonemap = renodx::color::correct::Luminance(untonemapped, y_in, y_out);
#else
  float3 hdr_tonemap = ToneMapHitmanExtended(untonemapped, renodx::tonemap::Reinhard(untonemapped));
#endif

  float3 chrominance_reference_color = renodx::tonemap::ReinhardPiecewise(hdr_tonemap, 6.f, 0.465571);

  hdr_tonemap = HueAndChrominanceOKLab(
      hdr_tonemap,
      untonemapped,                             // hue reference color
      chrominance_reference_color,              // chrominance reference color
      1.f,                                      // hue correct strength
      1.f,                                      // chrominance correct strength
      RENODX_PER_CHANNEL_BLOWOUT_RESTORATION);  // clamp chrominance loss

  return hdr_tonemap;
}
