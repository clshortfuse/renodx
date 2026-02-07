#include "./shared.h"

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

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 LUTBlackCorrection(float3 color_input, Texture3D lut_texture, renodx::lut::Config lut_config) {
  lut_config.gamut_compress = 0.f;
  lut_config.max_channel = 0.f;
  lut_config.tetrahedral = false;

  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = (renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture));

    float lutBlackY = renodx::color::y::from::BT709(lutBlack);
    if (lutBlackY > 0.f) {
      float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lutBlack, lut_config), lut_config, lut_texture);

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lutOutputColor, lut_config),
          renodx::lut::GammaOutput(lutBlack, lut_config),
          renodx::lut::GammaOutput(lutMid, lut_config),
          renodx::lut::GammaInput(color_input, lutInputColor, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
#if GAMUT_COMPRESS == 1
      recolored = GamutCompress(recolored);
#endif
      color_output = recolored;
    }
  } else {
  }

  return lerp(color_input, color_output, lut_config.strength);

  return color_output;
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

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.18f, float output_max = 1.f, float channel_max = 100.f) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, channel_max, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 0.f);

  return scale;
}

float3 LUTToneMap(inout float3 untonemapped) {
  return untonemapped * ComputeReinhardSmoothClampScale(untonemapped);
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
  float chrominance_emulation_strength;
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
#if GAMUT_COMPRESS == 1
    color = GamutCompress(color);
#endif
  }
  return color;
}

float3 ApplyCustomGrading(float3 ungraded) {
  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
    RENODX_TONE_MAP_HUE_SHIFT,                            // float hue_emulation_strength;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    RENODX_TONE_MAP_BLOWOUT                               // float chrominance_emulation_strength;
  };
  float ungraded_y = renodx::color::y::from::BT709(ungraded);

  float3 graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, ungraded_y, cg_config, 0.18f);
  float3 chrominance_hue_reference_color = renodx::tonemap::ReinhardPiecewise(graded, 12.5f, 1.f);
  graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded, chrominance_hue_reference_color, ungraded_y, cg_config);

  return graded;
}

float3 AdjustGammaByChannel(float3 linearColor, float gammaAdjustmentFactor) {
  if (gammaAdjustmentFactor == 1.f) return linearColor;  // No adjustment if factor is 1

  // Create a mask to identify components less than 1
  float3 mask = step(linearColor, float3(1.0f, 1.0f, 1.0f));  // 1 where linearColor < 1, 0 otherwise
  // Adjust gamma only for components where the value is less than 1
  return mask * renodx::color::gamma::EncodeSafe(linearColor, 1.f / gammaAdjustmentFactor) + (1.f - mask) * linearColor;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float y_in = renodx::color::y::from::BT709(incorrect_color);
  float y_out = renodx::color::correct::GammaSafe(y_in);
  float3 corrected_color = renodx::color::correct::Luminance(incorrect_color, y_in, y_out);
  // half strength chrominance correction to prevent dark blues from looking ugly
  corrected_color = renodx::color::correct::Chrominance(corrected_color, incorrect_color, 0.5f, 1.f);

  corrected_color = renodx::color::bt709::clamp::AP1(corrected_color);

  return corrected_color;
}

float3 ApplyDisplayMap(float3 untonemapped) {
  const float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  float3 untonemapped_bt2020 = renodx::color::bt2020::from::BT709(untonemapped);

#if GAMUT_COMPRESS == 2
  untonemapped_bt2020 = GamutCompress(untonemapped_bt2020, renodx::color::BT2020_TO_XYZ_MAT);
#endif

  float3 tonemapped_bt2020 = renodx::tonemap::neutwo::MaxChannel(
      max(0, untonemapped_bt2020),
      RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 100.f);
  // tonemapped_bt2020 = min(peak_ratio, tonemapped_bt2020);

  float3 tonemapped_bt709 = renodx::color::bt709::from::BT2020(tonemapped_bt2020);

  return tonemapped_bt709;
}

float3 ApplyToneMap(float3 untonemapped) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    untonemapped = renodx::color::correct::GammaSafe(untonemapped);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    untonemapped = GammaCorrectHuePreserving(untonemapped);
  }

#if GAMUT_COMPRESS == 1
  untonemapped = GamutCompress(untonemapped);
  untonemapped = max(0, untonemapped);
#endif

  untonemapped = ApplyCustomGrading(untonemapped);

  untonemapped = AdjustGammaByChannel(untonemapped, RENODX_GAMMA_ADJUST);

  float3 tonemapped = ApplyDisplayMap(untonemapped);

  tonemapped *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    tonemapped = renodx::color::correct::GammaSafe(tonemapped, true);
  }

  return tonemapped;
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
