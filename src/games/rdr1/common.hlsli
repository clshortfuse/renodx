#include "./shared.h"

/// Inverse of the Reinhard tonemapping function used in RDR1.
///
/// Reconstructs the original linear HDR value from its Extended Reinhard
/// tone-mapped result.
/// Uses the positive root for a valid HDR value.
///
/// @param x - The tone-mapped value.
/// @param whitePoint - The white point scaling factor.
/// @return The original linear HDR value.
float RDR1ReinardInverse(float x, float whitePoint) {
  // Calculate the two roots of the inverse
  float term1 = 0.5 * (whitePoint * x - whitePoint);
  float term2 = 0.5 * sqrt(whitePoint) * sqrt((whitePoint * x * x) - (2.0 * whitePoint * x) + whitePoint + 4.0 * x);

  // Use the positive root, as it's the physically meaningful solution
  return term1 + term2;
}

/// Computes the mid-gray point for the Reinhard tonemapping function.
///
/// This function calculates the linear HDR input value that corresponds to the
/// standard scene referred mid-gray (18%) in the Reinhard tone-mapped space.
/// This value is crucial for aligning the mid-gray points of untonemapped and
/// Reinhard-tonemapped images during blending.
///
/// @param whitePoint - The white point scaling factor used in the tonemapping.
/// @return The linear HDR mid-gray value.
float RDR1ReinhardMidgray(float whitePoint) {
  return RDR1ReinardInverse(0.18, whitePoint);
}

/// Computes the scale factor for aligning mid-gray levels in RDR1.
///
/// This function returns a scaling factor to map the untonemapped image's scene referred
/// mid-gray to align with the Reinhard tone-mapped's scene referred mid-gray.
/// This ensures that the blended result retains the original game's visual art direction
/// while enabling HDR highlights.
///
/// @param whitePoint - The white point scaling factor used in the tonemapping.
/// @return The scale factor for aligning mid-gray levels.
float RDR1ReinhardMidgrayScale(float whitePoint) {
  return 0.18 / RDR1ReinhardMidgray(whitePoint);
}

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_GENERATOR(T)                                                      \
  T ExponentialRollOffExtended(T input, float rolloff_start, float output_max, float clip) { \
    T rolloff_size = output_max - rolloff_start;                                             \
    T overage = -max((T)0, input - rolloff_start);                                           \
    T clip_size = rolloff_start - clip;                                                      \
    T rolloff_value = (T)1.0f - exp(overage / rolloff_size);                                 \
    T clip_value = (T)1.0f - exp(clip_size / rolloff_size);                                  \
    T new_overage = mad(rolloff_size, rolloff_value / clip_value, overage);                  \
    return input + new_overage;                                                              \
  }
EXPONENTIALROLLOFF_GENERATOR(float)
EXPONENTIALROLLOFF_GENERATOR(float3)
#undef EXPONENTIALROLLOFF_GENERATOR

float3 ApplyExponentialRolloffMaxChannel(float3 untonemapped, float peak_ratio = 1.f, float rolloff_start_ratio = 0.5f, float clip = 100.f) {
  float max_channel = renodx::math::Max(untonemapped);

  float mapped_max = exp2(ExponentialRollOffExtended(
      log2(max_channel),
      log2(rolloff_start_ratio * peak_ratio),
      log2(peak_ratio),
      log2(clip)));

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 1.f);
  return untonemapped * scale;
}

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
  float blowout;
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
    0.f,                                                  // float hue_emulation_strength;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    0.f                                                   // float blowout;
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
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_emulation_strength != 0.f || config.blowout != 0.f || config.highlight_saturation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue emulation and blowout
    if (config.hue_emulation_strength != 0.0 || config.blowout != 0.0) {
      const float3 reference_oklab = renodx::color::oklab::from::BT709(hue_reference_color);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_emulation_strength != 0.0) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, config.hue_emulation_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.blowout != 0.0) {
        const float reference_chrominance = length(reference_oklab.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.blowout);
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
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
      if (config.highlight_saturation < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    // saturation
    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 ApplyUserGrading(float3 ungraded) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return ungraded;

  UserGradingConfig cg_config = CreateColorGradeConfig();
  float y = renodx::color::y::from::BT709(ungraded);
  float3 graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, y, cg_config);
  graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded, ungraded, y, cg_config);

  return graded;
}

float3 HueAndChrominance1ReferenceColorOKLab(
    float3 incorrect_color, float3 hue_reference_color,
    float hue_correct_strength = 0.f,
    float chrominance_correct_strength = 0.f) {
  if (hue_correct_strength != 0.0 || chrominance_correct_strength != 0.0) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color);
    const float3 reference_oklab = renodx::color::oklab::from::BT709(hue_reference_color);

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
