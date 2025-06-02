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

struct Config {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float saturation;
  float dechroma;
  float hue_correction_strength;
  float3 hue_correction_source;
  float hue_correction_type;  // 0 = input, 1 = output
  float blowout;
};

namespace config {

namespace hue_correction_type {
static const float INPUT = 0.f;
static const float CLAMPED = 1.f;
static const float CUSTOM = 2.f;
}

Config Create(
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float saturation = 1.f,
    float dechroma = 0.f,
    float hue_correction_strength = 1.f,
    float3 hue_correction_source = 0,
    float hue_correction_type = config::hue_correction_type::INPUT,
    float blowout = 0.f) {
  const Config cg_config = {
    exposure,
    highlights,
    shadows,
    contrast,
    flare,
    saturation,
    dechroma,
    hue_correction_strength,
    hue_correction_source,
    hue_correction_type,
    blowout
  };
  return cg_config;
}

float3 ApplyUserColorGrading(
    float3 bt709,
    Config config) {
  if (config.exposure == 1.f && config.saturation == 1.f && config.dechroma == 0.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f && config.hue_correction_strength == 0.f && config.blowout == 0.f) {
    return bt709;
  }

  float3 color = bt709;

  color *= config.exposure;

  float y = renodx::color::y::from::BT709(abs(color));
  const float y_normalized = y / 0.18f;

  // contrast & flare
  float flare = math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted));

  // flare
  // const float scale = 32.f;
  // float y_scaled = y_shadowed * scale;
  // float y_flared = (y_scaled * y_scaled) / (y_scaled + config.flare);
  // y_flared /= scale;
  // y_flared = lerp(y_shadowed, y_flared, config.flare);

  const float y_final = y_shadowed * 0.18f;

  color *= (y > 0 ? (y_final / y) : 0);

  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 hue_correction_source;
      if (config.hue_correction_type == hue_correction_type::CUSTOM) {
        hue_correction_source = config.hue_correction_source;
      } else if (config.hue_correction_type == hue_correction_type::CLAMPED) {
        hue_correction_source = saturate(bt709);
      } else {
        hue_correction_source = bt709;
      }

      float3 perceptual_old = renodx::color::oklab::from::BT709(hue_correction_source);

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }

  return color;
}
}  // namespace config

}  // namespace grade
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLORGRADE_HLSL_
