#include "./shared.h"

#if 0
float3 CorrectLuminance(float3 color, float y_old, float y_new) {
  float y_delta = y_new - y_old;
  return color + y_delta;
}
#else
float3 CorrectLuminance(float3 color, float y_old, float y_new) {
// Reference chroma (distance from old gray axis)
#if CHROMA_CALCULATION_TYPE == 0
  float ref_mag = length(renodx::math::DivideSafe(color, y_old, 1.f) - 1.f);
#else
  float ref_mag = length(color - y_old);
#endif
  // Candidate 1: additive luminance shift
  float3 add_out = color + (y_new - y_old);

  // Candidate 2: multiplicative luminance scale
  float3 mul_out = color * renodx::math::DivideSafe(y_new, y_old, 1.f);

// Compute chroma error for additive and multiplicative
#if CHROMA_CALCULATION_TYPE == 0
  float add_mag = length(renodx::math::DivideSafe(add_out, y_new, 1.f) - 1.f);
  float mul_mag = length(renodx::math::DivideSafe(mul_out, y_new, 1.f) - 1.f);
#else
  float add_mag = length(add_out - y_new);
  float mul_mag = length(mul_out - y_new);
#endif
  float add_err = abs(add_mag - ref_mag);
  float mul_err = abs(mul_mag - ref_mag);

  // Falls back to additive if multiplicative oversaturates
  float w_mul = renodx::math::DivideSafe(add_err, add_err + mul_err, 1.f);

  return lerp(add_out, mul_out, w_mul);
}
#endif

float3 GamutCompress(float3 color_bt709, float3x3 color_space_matrix = renodx::color::BT709_TO_XYZ_MAT) {
  float grayscale = dot(color_bt709, color_space_matrix[1].rgb);

  const float MID_GRAY_LINEAR = 1 / (pow(10, 0.75));                          // ~0.18f
  const float MID_GRAY_PERCENT = 0.5f;                                        // 50%
  const float MID_GRAY_GAMMA = log(MID_GRAY_LINEAR) / log(MID_GRAY_PERCENT);  // ~2.49f
  float encode_gamma = MID_GRAY_GAMMA;

  float3 encoded = renodx::color::gamma::EncodeSafe(color_bt709, encode_gamma);
  float encoded_gray = renodx::color::gamma::Encode(grayscale, encode_gamma);

  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray);
  float3 color_bt709_compressed = renodx::color::gamma::DecodeSafe(compressed, encode_gamma);

  return color_bt709_compressed;
}

float3 CorrectHueAndChrominance2ReferenceColorsOKLab(
    float3 incorrect_color,
    float3 chrominance_reference_color,
    float3 hue_reference_color,
    float hue_correct_strength = 1.f) {
  if (hue_correct_strength == 0.f)
    return renodx::color::correct::ChrominanceOKLab(incorrect_color, chrominance_reference_color);

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 hue_lab = renodx::color::oklab::from::BT709(hue_reference_color);
  float3 chrominance_lab = renodx::color::oklab::from::BT709(chrominance_reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 hue_ab = hue_lab.yz;

  // Always use chrominance magnitude from chroma reference
  float target_chrominance = length(chrominance_lab.yz);

  // Compute blended hue direction
  float2 blended_ab_dir = normalize(lerp(normalize(incorrect_ab), normalize(hue_ab), hue_correct_strength));

  // Apply chrominance magnitude from chroma_reference_color
  float2 final_ab = blended_ab_dir * target_chrominance;

  incorrect_lab.yz = final_ab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

struct UserGradingConfig {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float gamma;
  float saturation;
  float dechroma;
  float highlight_saturation;
  float hue_emulation_strength_high;
  float chrominance_emulation_strength_high;
  float hue_emulation_strength_low;
  float chrominance_emulation_strength_low;
  float hue_chrominance_ramp_start;
  float hue_chrominance_ramp_end;
};

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
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

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 ungraded, float y, UserGradingConfig config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f && config.gamma == 1.f) {
    return ungraded;
  }
  float3 color = ungraded;

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

  float y_gamma_adjusted = renodx::math::Select(y_shadowed < 1.f, pow(y_shadowed, config.gamma), y_shadowed);

  const float y_final = y_gamma_adjusted;

#if LUMINANCE_CORRECT_TYPE == 0  // apply new y using division
  float3 output = renodx::color::correct::Luminance(color, y, y_final);
#else  // apply new y using subtraction
  float3 output = CorrectLuminance((color), y, y_final);
#endif

#if 0  // chroma / hue correction using subtraction on
  float3 source_hue_chroma = ungraded - y;
  output = y_final + source_hue_chroma;
#endif

  return output;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.highlight_saturation != 0.f
      || config.hue_emulation_strength_high != 0.f || config.chrominance_emulation_strength_high != 0.f
      || config.hue_emulation_strength_low != 0.f || config.chrominance_emulation_strength_low != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue and chrominance emulation
    if (config.hue_emulation_strength_high != 0.f || config.chrominance_emulation_strength_high != 0.f
        || config.hue_emulation_strength_low != 0.f || config.chrominance_emulation_strength_low != 0.f) {
      const float3 perceptual_reference = renodx::color::oklab::from::BT709(hue_reference_color);

#if 1
      float hue_emulation_strength = config.hue_emulation_strength_high;
      float chrominance_emulation_strength = config.chrominance_emulation_strength_high;

      if (!(config.hue_chrominance_ramp_start == 0.f && config.hue_chrominance_ramp_end == 0.f)) {
        float ramp_denom = config.hue_chrominance_ramp_end - config.hue_chrominance_ramp_start;
        float ramp_t = saturate(renodx::math::DivideSafe(y - config.hue_chrominance_ramp_start, ramp_denom, 0.f));
        hue_emulation_strength = lerp(config.hue_emulation_strength_low, config.hue_emulation_strength_high, ramp_t);
        chrominance_emulation_strength = lerp(config.chrominance_emulation_strength_low, config.chrominance_emulation_strength_high, ramp_t);
      }
#endif

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_emulation_strength_high != 0.f || config.hue_emulation_strength_low != 0.f) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, perceptual_reference.yz, hue_emulation_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.chrominance_emulation_strength_high != 0.f || config.chrominance_emulation_strength_low != 0.f) {
        const float reference_chrominance = length(perceptual_reference.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_emulation_strength);
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
#if GAMUT_COMPRESS == 1
    color = GamutCompress(color);
#endif
  }
  return color;
}

float3 ApplyGammaCorrectionByLuminance(float3 incorrect_color) {
  float y_incorrect = renodx::color::y::from::BT709(incorrect_color);
  float y_corrected = renodx::color::correct::Gamma(max(0, y_incorrect));
#if LUMINANCE_CORRECT_TYPE == 0  // apply new y using division
  float3 lum_corrected = renodx::color::correct::Luminance(incorrect_color, y_incorrect, y_corrected);
#else  // apply new y using subtraction
  float3 lum_corrected = CorrectLuminance(incorrect_color, y_incorrect, y_corrected);
#endif
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  lum_corrected = CorrectHueAndChrominance2ReferenceColorsOKLab(lum_corrected, ch, incorrect_color);

#if 0  // cleans up dark saturated blues and purples
  lum_corrected = lerp(lum_corrected, GamutCompress(lum_corrected), 0.5f);
#endif

  return lum_corrected;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  incorrect_color = renodx::color::bt709::clamp::AP1(incorrect_color);

  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

float3 ApplyResidentEvilToneMap(
    float3 color,
    float contrast,
    float linearBegin,
    float linearStart,
    float toe,
    float maxNit,
    float displayMaxNitSubContrastFactor,
    float contrastFactor,
    float mulLinearStartContrastFactor,
    float invLinearBegin,
    float madLinearStartContrastFactor) {
  if (!isfinite(renodx::math::Max(color))) {
    return 1.f;
  }

  // Normalize by linearBegin for toe math
  float3 t = color * invLinearBegin;

  // toe: below linearBegin
  float3 toe_weight = select(color >= linearBegin, 0.f, 1.f - (t * t) * (3.f - 2.f * t));
  float3 toe_value = pow(t, toe) * linearBegin;

  // shoulder: above linearStart
  float3 shoulder_weight = select(color < linearStart, 0.f, 1.f);
  float3 shoulder_value = maxNit - exp2(contrastFactor * color + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor;

  // linear: remainder
  float3 linear_weight = 1.f - shoulder_weight - toe_weight;
  float3 linear_value = contrast * color + madLinearStartContrastFactor;

  return linear_value * linear_weight
         + toe_value * toe_weight
         + shoulder_value * shoulder_weight;
}
