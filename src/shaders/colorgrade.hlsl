#ifndef SRC_SHADERS_COLORGRADE_HLSL_
#define SRC_SHADERS_COLORGRADE_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"

namespace renodx {
namespace color {
namespace grade {

float3 Contrast(float3 color, float contrast, float mid_gray = 0.18f, float3x3 color_space = renodx::color::BT709_TO_XYZ_MAT) {
  float3 signs = renodx::math::Sign(color);
  color = abs(color);
  float3 working_color = pow(color / mid_gray, contrast) * mid_gray;
  float working_y = dot(working_color, float3(color_space[1].r, color_space[1].g, color_space[1].b));
  float color_y = dot(color, float3(color_space[1].r, color_space[1].g, color_space[1].b));
  return signs * color * (color_y > 0 ? (working_y / color_y) : 1.f);
}

float3 Saturation(float3 bt709, float saturation = 1.f) {
  float3 perceptual = renodx::color::oklab::from::BT709(bt709);
  perceptual.yz *= saturation;
  float3 color = renodx::color::bt709::from::OkLab(perceptual);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 UserColorGrading(
    float3 bt709,
    float exposure,
    float highlights,
    float shadows,
    float contrast,
    float saturation,
    float dechroma,
    float hue_correction_strength,
    float3 hue_correction_source) {
  if (exposure == 1.f && saturation == 1.f && dechroma == 0.f && shadows == 1.f && highlights == 1.f && contrast == 1.f && hue_correction_strength == 0.f) {
    return bt709;
  }

  float3 color = bt709;

  color *= exposure;

  float y = renodx::color::y::from::BT709(abs(color));
  const float y_normalized = y / 0.18f;

  const float y_contrasted = pow(y_normalized, contrast);

  float y_highlighted = pow(y_contrasted, highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted));

  float y_shadowed = pow(y_highlighted, -1.f * (shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted));

  const float y_final = y_shadowed * 0.18f;

  color *= (y > 0 ? (y_final / y) : 0);

  if (saturation != 1.f || dechroma != 0.f || hue_correction_strength != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(hue_correction_source);

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - dechroma))));
    }

    perceptual_new.yz *= saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }

  return color;
}

float3 UserColorGrading(
    float3 color,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float saturation = 1.f,
    float dechroma = 0.f,
    float hue_correction_strength = 1.f) {
  return UserColorGrading(
      color,
      exposure,
      highlights,
      shadows,
      contrast,
      saturation,
      dechroma,
      hue_correction_strength,
      color);
}
}  // namespace grade
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLORGRADE_HLSL_
