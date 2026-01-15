#include "./shared.h"

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
      color_output = recolored;
    }
  } else {
  }

  return lerp(color_input, color_output, lut_config.strength);
  // float3 color_output = renodx::lut::Sample(lut_texture, lut_config, color_input);

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

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.5f, float output_max = 1.f, float channel_max = 100.f) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, channel_max, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 0.f);

  return scale;
}

// void BlowoutAndHueShift(inout float r, inout float g, inout float b) {
//   float3 color = float3(r, g, b);
//   float reference_peak = 8.f;
//   float reference_shoulder = 0.5f;
//   float3 reference_color = renodx::tonemap::ExponentialRollOff(color, reference_shoulder, reference_peak);
//   color = HueAndChrominance1ReferenceColorOKLab(
//       color, reference_color, RENODX_TONE_MAP_HUE_SHIFT, (1.f - RENODX_PER_CHANNEL_BLOWOUT_RESTORATION));
//   color = max(0, color);

//   r = color.r, g = color.g, b = color.b;
//   return;
// }

float3 BlowoutAndHueShift(float3 input_color) {
  float3 color = input_color;
  float reference_peak = 8.f;
  float reference_shoulder = 0.5f;
  float3 reference_color = renodx::tonemap::ExponentialRollOff(color, reference_shoulder, reference_peak);
  color = HueAndChrominance1ReferenceColorOKLab(
      color, reference_color, RENODX_TONE_MAP_HUE_SHIFT, (1.f - RENODX_PER_CHANNEL_BLOWOUT_RESTORATION));
  color = max(0, color);

  return color;
}

float3 LUTToneMap(inout float3 untonemapped) {
  return untonemapped * ComputeReinhardSmoothClampScale(untonemapped);
}

float4 LUTToneMapScale(float3 untonemapped) {
  float scale = ComputeReinhardSmoothClampScale(untonemapped);
  return float4(untonemapped * scale, scale);
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    // value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    return max(x,
               lerp(x, mid_gray * pow(x / mid_gray, highlights),
                    renodx::tonemap::ExponentialRollOff(x, 1.f, 2.75f)));
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

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
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
#if 0
  // const float highlights = 1 + (sign(config.highlights - 1) * pow(abs(config.highlights - 1), 10.f));
  // float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);
#else
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
#endif
  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

#if 0
    // if (config.hue_correction_strength != 0.f) {
    //   float3 perceptual_old = renodx::color::oklab::from::BT709(hue_reference_color);

    //   // Save chrominance to apply black
    //   float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

    //   perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

    //   float chrominance_post_adjust = distance(perceptual_new.yz, 0);

    //   // Apply back previous chrominance
    //   perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    // }

    // if (config.dechroma != 0.f) {
    //   perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    // }
#else
    if (config.hue_correction_strength != 0.0 || config.dechroma != 0.0) {
      const float3 reference_oklab = renodx::color::oklab::from::BT709(hue_reference_color);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_correction_strength != 0.0) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, config.hue_correction_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.dechroma != 0.0) {
        const float reference_chrominance = length(reference_oklab.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.dechroma);
      }
      perceptual_new.yz *= chrominance_ratio;
    }
#endif

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

float3 ApplyCustomGrading(float3 ungraded) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = 0.f;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  float ungraded_y = renodx::color::y::from::BT709(ungraded);

  float3 graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, ungraded_y, cg_config, 0.1f);
  graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded, ungraded, ungraded_y, cg_config);

  return graded;
}

float3 AdjustGammaByChannel(float3 linearColor, float gammaAdjustmentFactor) {
  if (gammaAdjustmentFactor == 1.f) return linearColor;  // No adjustment if factor is 1

  // Create a mask to identify components less than 1
  float3 mask = step(linearColor, float3(1.0f, 1.0f, 1.0f));  // 1 where linearColor < 1, 0 otherwise
  // Adjust gamma only for components where the value is less than 1
  return mask * renodx::color::gamma::EncodeSafe(linearColor, 1.f / gammaAdjustmentFactor) + (1.f - mask) * linearColor;
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float diffuse_nits, float peak_nits) {
  const float peak_ratio = peak_nits / diffuse_nits;
  float white_clip = max(100.f, peak_ratio * 1.5f);  // safeguard to prevent artifacts

  float max_channel = renodx::math::Max(input.r, input.g, input.b);

  float max_pq = renodx::color::pq::Encode(max_channel, diffuse_nits);
  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, diffuse_nits);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled_pq = renodx::tonemap::HermiteSplineRolloff(max_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float mapped_max = renodx::color::pq::Decode(scaled_pq, diffuse_nits);
  mapped_max = min(mapped_max, peak_ratio);

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 0.f);
  return input * scale;
}

float3 GammaCorrectByLuminance(float3 color, bool pow_to_srgb = false) {
  float y_in = renodx::color::y::from::BT709(color);
  float y_out = renodx::color::correct::Gamma(y_in, pow_to_srgb);

  color = renodx::color::correct::Luminance(color, y_in, y_out);

  return color;
}

float3 ApplyDisplayMap(float3 untonemapped) {
  const float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    untonemapped = renodx::color::correct::GammaSafe(untonemapped);
  }

  float3 tonemapped_bt2020 = ApplyHermiteSplineByMaxChannel(max(0, renodx::color::bt2020::from::BT709(untonemapped)),
                                                            RENODX_DIFFUSE_WHITE_NITS,
                                                            RENODX_PEAK_WHITE_NITS);
  tonemapped_bt2020 = min(tonemapped_bt2020, peak_ratio);

  float3 tonemapped_bt709 = renodx::color::bt709::from::BT2020(tonemapped_bt2020);
  tonemapped_bt709 *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709, true);
  }

  return tonemapped_bt709;
}

float3 ApplyToneMap(float3 untonemapped) {
  untonemapped = max(0, untonemapped);
  untonemapped = BlowoutAndHueShift(untonemapped);
  untonemapped = ApplyCustomGrading(untonemapped);
  untonemapped = AdjustGammaByChannel(untonemapped, RENODX_GAMMA_ADJUST);

  float3 tonemapped = ApplyDisplayMap(untonemapped);

  return tonemapped;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  corrected_color = renodx::color::correct::Hue(corrected_color, incorrect_color, 1.f);

  return corrected_color;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}
