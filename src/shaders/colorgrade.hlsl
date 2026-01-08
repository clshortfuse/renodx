#ifndef SRC_SHADERS_COLORGRADE_HLSL_
#define SRC_SHADERS_COLORGRADE_HLSL_

#include "./color.hlsl"
#include "./colorcorrect.hlsl"
#include "./math.hlsl"

#ifndef RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION
#define RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION 3
#endif

#ifndef RENODX_COLOR_GRADE_SHADOWS_VERSION
#define RENODX_COLOR_GRADE_SHADOWS_VERSION 3
#endif

namespace renodx {
namespace color {
namespace grade {

static const float HIGHLIGHTS_VERSION = RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION;
static const float SHADOWS_VERSION = RENODX_COLOR_GRADE_SHADOWS_VERSION;

// https://en.wikipedia.org/wiki/Weber%E2%80%93Fechner_law
float Contrast(float x, float contrast, float mid_gray = 0.18f) {
  return pow(x / mid_gray, contrast) * mid_gray;
}

float ContrastSafe(float x, float contrast, float mid_gray = 0.18f) {
  return renodx::math::SignPow(x / mid_gray, contrast) * mid_gray;
}

float3 Contrast(float3 color, float contrast, float mid_gray = 0.18f, float3x3 color_space = renodx::color::BT709_TO_XYZ_MAT) {
  float3 original_color = color;
  color = abs(color);
  float color_y = dot(color, color_space[1].rgb);
  float contrasted_y = Contrast(color_y, contrast, mid_gray);
  return renodx::math::CopySign(renodx::color::correct::Luminance(color, color_y, contrasted_y), original_color);
}

float Highlights(float x, float highlights, float mid_gray, float highlights_version) {
  float value;
  [branch]
  if (highlights_version == 2.f) {
    [branch]
    if (highlights > 1.f) {
      float bias = 0.10f;
      float scaled = (highlights * highlights - highlights);
      float extra = bias * scaled * scaled * x * x * x * (x - mid_gray);
      value = ((mid_gray * x) + extra) / mid_gray;
    } else {
      value = x;
    }
  } else if (highlights_version == 1.f) {
    float scaled = x / mid_gray;
    float highlighted = lerp(scaled, pow(scaled, highlights), saturate(scaled));
    float rescaled = highlighted * mid_gray;
    value = rescaled;
  } else {
    // Version 3 (Default)
    [branch]
    if (highlights > 1.f) {
      value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    } else if (highlights < 1.f) {
      // value = x * x / lerp(x, mid_gray * pow(x / mid_gray, 2.f - highlights), x);
      value = min(x, x / (1.f + mid_gray * pow(x / mid_gray, 2.f - highlights) - x));
    } else {
      value = x;
      // 0
    }
  }
  return value;
}

float Highlights(float x, float highlights = 1.f, float mid_gray = 0.18f) {
  return Highlights(x, highlights, mid_gray, RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION);
}

float Shadows(float x, float shadows, float mid_gray, float shadows_version) {
  float value;
  [branch]
  if (shadows_version == 1.f) {
    float scaled = x / mid_gray;
    float shadowed = pow(scaled, -1.f * (shadows - 2.f));
    float lerped = lerp(shadowed, scaled, saturate(shadowed));
    float rescaled = lerped * mid_gray;
    value = rescaled;
  } else {
    // Version 2 Skipped
    // Version 3 Default
    if (shadows > 1.f) {
      // float contrasted = mid_gray * pow(x / mid_gray, shadows);
      // value = x * (1.f + x * mid_gray * (1.f / contrasted));
      value = max(x, x * (1.f + (x * mid_gray / pow(x / mid_gray, shadows))));
    } else if (shadows < 1.f) {
      // float contrasted = mid_gray * pow(x / mid_gray, 2.f - shadows);
      // value = x* (1.f - x * mid_gray * (1.f / contrasted));
      value = clamp(x * (1.f - (x * mid_gray / pow(x / mid_gray, 2.f - shadows))), 0.f , x);
    } else {
      value = x;
      // 0
    }
  }

  return value;
}

float Shadows(float x, float shadows = 1.f, float mid_gray = 0.18f) {
  return Shadows(x, shadows, mid_gray, RENODX_COLOR_GRADE_SHADOWS_VERSION);
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
  if (exposure == 1.f
      && saturation == 1.f
      && dechroma == 0.f
      && shadows == 1.f
      && highlights == 1.f
      && contrast == 1.f
      && hue_correction_strength == 0.f) {
    return bt709;
  }

  float3 color = bt709;

  color *= exposure;

  float y = renodx::color::y::from::BT709(color);

  const float y_contrasted = Contrast(y, contrast);
  float y_highlighted = Highlights(y_contrasted, highlights);
  float y_shadowed = Shadows(y_highlighted, shadows);
  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  if (saturation != 1.f || dechroma != 0.f || hue_correction_strength != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(hue_correction_source);

      // Save chrominance to apply black
      float chrominance_pre_adjust = length(perceptual_new.yz);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, hue_correction_strength);

      float chrominance_post_adjust = length(perceptual_new.yz);

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
  if (config.exposure == 1.f
      && config.saturation == 1.f
      && config.dechroma == 0.f
      && config.shadows == 1.f
      && config.highlights == 1.f
      && config.contrast == 1.f
      && config.flare == 0.f
      && config.hue_correction_strength == 0.f
      && config.blowout == 0.f) {
    return bt709;
  }

  float3 color = bt709;

  color *= config.exposure;

  float y = renodx::color::y::from::BT709(color);
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
