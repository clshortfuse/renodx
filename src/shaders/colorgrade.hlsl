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
  float3 lch = renodx::color::oklch::from::BT709(bt709);
  lch[1] *= saturation;
  float3 color = renodx::color::bt709::from::OkLCh(lch);
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 UserColorGrading(
    float3 color,
    float exposure,
    float highlights,
    float shadows,
    float contrast,
    float saturation,
    float dechroma,
    float hue_correction_strength,
    float3 hue_correction_source) {
  if (exposure == 1.f && saturation == 1.f && dechroma == 0.f && shadows == 1.f && highlights == 1.f && contrast == 1.f && hue_correction_strength == 0.f) {
    return color;
  }

  // Store original color

  float3 restore_lab = (hue_correction_strength == 0)
                           ? 0
                           : renodx::color::oklab::from::BT709(hue_correction_source);
  float3 restore_lch = (hue_correction_strength == 0)
                           ? 0
                           : renodx::color::oklch::from::OkLab(restore_lab);

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
    float3 lab_new = renodx::color::oklab::from::BT709(color);
    float3 lch_new = renodx::color::oklch::from::OkLab(lab_new);

    if (hue_correction_strength != 0.f) {
      if (hue_correction_strength == 1.f) {
        lch_new[2] = restore_lch[2];  // Full hue override
      } else {
        float old_chroma = lch_new[1];  // Store old chroma
        lab_new.yz = lerp(lab_new.yz, restore_lab.yz, hue_correction_strength);
        lch_new = renodx::color::oklch::from::OkLab(lab_new);
        lch_new[1] = old_chroma;  // chroma restore
      }
    }

    if (dechroma != 0.f) {
      lch_new[1] = lerp(lch_new[1], 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - dechroma))));
    }

    if (saturation != 1.f) {
      lch_new[1] *= saturation;
    }

    color = renodx::color::bt709::from::OkLCh(lch_new);

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
