#ifndef SRC_SHADERS_COLOR_GRADE_HLSL_
#define SRC_SHADERS_COLOR_GRADE_HLSL_

#include "./color.hlsl"

namespace renodx {
namespace color {
namespace grade {

float3 Contrast(float3 color, float contrast, float mid_gray = 0.18f, float3x3 color_space = renodx::color::BT709_TO_XYZ_MAT) {
  float3 signs = sign(color);
  color = abs(color);
  float3 working_color = pow(color / mid_gray, contrast) * mid_gray;
  float working_y = dot(working_color, float3(color_space[1].r, color_space[1].g, color_space[1].b));
  float color_y = dot(color, float3(color_space[1].r, color_space[1].g, color_space[1].b));
  return signs * color * (color_y > 0 ? (working_y / color_y) : 1.f);
}

float3 Saturation(float3 bt709, float saturation = 1.f) {
  float3 lch = renodx::color::oklch::from::BT709(bt709);
  lch[1] *= saturation;
  float3 color = renodx::color::bt709::from::OkLCh(lch);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 UserColorGrading(
    float3 color,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float saturation = 1.f) {
  if (exposure == 1.f && saturation == 1.f && shadows == 1.f && highlights == 1.f && contrast == 1.f) {
    return color;
  }

  // Store original color
  float3 lch_original = renodx::color::oklch::from::BT709(color);

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

  float3 lch_new = renodx::color::oklch::from::BT709(color);
  lch_new[1] *= saturation;
  lch_new[2] = lch_original[2];  // hue correction

  color = renodx::color::bt709::from::OkLCh(lch_new);
  color = renodx::color::bt709::clamp::AP1(color);

  return color;
}
}  // namespace grade
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_GRADE_HLSL_
