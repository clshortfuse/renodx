#include "./shared.h"

float3 HueAndChrominanceOKLab(
    float3 incorrect_color, float3 reference_color,
    float hue_correct_strength = 0.f,
    float chrominance_correct_strength = 0.f) {
  if (hue_correct_strength != 0.0 || chrominance_correct_strength != 0.0) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color);
    const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);

    float chrominance_current = length(perceptual_new.yz);
    float chrominance_ratio = 1.0;

    if (hue_correct_strength != 0.0) {
      const float chrominance_pre = chrominance_current;
      perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, hue_correct_strength);
      const float chrominancePost = length(perceptual_new.yz);
      chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
      chrominance_current = chrominancePost;
    }

    if (chrominance_correct_strength != 0.0) {
      const float reference_chrominance = length(reference_oklab.yz);
      float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
      chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_correct_strength);
    }
    perceptual_new.yz *= chrominance_ratio;

    incorrect_color = renodx::color::bt709::from::OkLab(perceptual_new);
    incorrect_color = renodx::color::bt709::clamp::AP1(incorrect_color);
  }
  return incorrect_color;
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

  float3 hue_chrominance_reference = renodx::tonemap::ReinhardPiecewise(hdr_tonemap, 6.f, 0.0932816);

  hdr_tonemap = HueAndChrominanceOKLab(
      hdr_tonemap,
      hue_chrominance_reference,  // hue and chrominance reference color
      RENODX_TONE_MAP_HUE_SHIFT,  // hue correct strength
      RENODX_TONE_MAP_BLOWOUT     // chrominance correct strength
  );

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

  float3 hue_chrominance_reference = renodx::tonemap::ReinhardPiecewise(hdr_tonemap, 6.f, 0.465571);

  hdr_tonemap = HueAndChrominanceOKLab(
      hdr_tonemap,
      hue_chrominance_reference,  // hue and chrominance reference color
      RENODX_TONE_MAP_HUE_SHIFT,  // hue correct strength
      RENODX_TONE_MAP_BLOWOUT     // chrominance correct strength
  );

  return hdr_tonemap;
}

// USER GRADING
struct UserGradingConfig {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float saturation;
  float dechroma;
  float hue_emulation_strength;
  float highlight_saturation;
  float chrominance_emulation_strength;
};

UserGradingConfig CreateColorGradeConfig() {
  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
    0.f,                                                  // float hue_emulation_strength; handled earlier
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    0.f                                                   // float chrominance_emulation_strength; handled earlier
  };
  return cg_config;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 10.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1.f
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, UserGradingConfig config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

  // highlights
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_emulation_strength != 0.f || config.chrominance_emulation_strength != 0.f || config.highlight_saturation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue and chrominance emulation
    if (config.hue_emulation_strength != 0.0 || config.chrominance_emulation_strength != 0.0) {
      const float3 perceptual_reference = renodx::color::oklab::from::BT709(hue_reference_color);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_emulation_strength != 0.0) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, perceptual_reference.yz, config.hue_emulation_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.chrominance_emulation_strength != 0.0) {
        const float reference_chrominance = length(perceptual_reference.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.chrominance_emulation_strength);
      }
      perceptual_new.yz *= chrominance_ratio;
    }

    // dechroma
    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    // highlight saturation
    if (config.highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float highlight_saturation_strength = 100.f;
      float highlight_saturation_change = pow(1.f - percent_max, highlight_saturation_strength * abs(config.highlight_saturation));
      if (config.highlight_saturation < 0) {
        highlight_saturation_change = (2.f - highlight_saturation_change);
      }

      perceptual_new.yz *= highlight_saturation_change;
    }

    // saturation
    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}
