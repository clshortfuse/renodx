#include "./shared.h"

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
    RENODX_SDR_EOTF_EMULATION == 2.f ? 1.f : 0.f,         // float hue_emulation_strength;
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

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config, bool clamp_to_ap1 = true) {
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

    if (clamp_to_ap1) {
      color = renodx::color::bt709::clamp::AP1(color);
    }
  }
  return color;
}

float3 ApplyHermiteSplineByMaxChannelPQInput(float3 input_pq, float diffuse_nits, float peak_nits, float white_clip = 100.f) {
  white_clip = max(white_clip * diffuse_nits, peak_nits * 1.5f);  // safeguard to prevent artifacts

  float max_channel_pq = renodx::math::Max(input_pq);

  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, 1.f);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled_pq = renodx::tonemap::HermiteSplineRolloff(max_channel_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);
  float mapped_max_pq = min(scaled_pq, target_white_pq);

  float scale = renodx::math::DivideSafe(mapped_max_pq, max_channel_pq, 1.f);
  return input_pq * scale;
}

float3 HueAndChrominanceOKLab(
    float3 incorrect_color, float3 reference_color,
    float hue_correct_strength = 0.f,
    float chrominance_correct_strength = 0.f,
    float saturation = 1.f) {
  if (hue_correct_strength != 0.0 || chrominance_correct_strength != 0.0 || saturation != 0.0) {
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
    perceptual_new.yz *= saturation;

    incorrect_color = renodx::color::bt709::from::OkLab(perceptual_new);
    incorrect_color = renodx::color::bt709::clamp::AP1(incorrect_color);
  }
  return incorrect_color;
}

float3 CorrectHueAndChrominanceOKLab(
    float3 incorrect_color_bt709,
    float3 reference_color_bt709,
    float hue_emulation_strength = 0.f,
    float chrominance_emulation_strength = 0.f,
    float hue_emulation_ramp_start = 0.18f,
    float hue_emulation_ramp_end = 1.f) {
  if (hue_emulation_strength == 0.0 && chrominance_emulation_strength == 0.0) {
    return incorrect_color_bt709;
  }

  float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color_bt709);
  float3 perceptual_reference = renodx::color::oklab::from::BT709(reference_color_bt709);

  float chrominance_current = length(perceptual_new.yz);
  float chrominance_ratio = 1.0;

  if (hue_emulation_strength != 0.0) {
    float ramp_denom = hue_emulation_ramp_end - hue_emulation_ramp_start;
    float ramp_t = clamp(renodx::math::DivideSafe(perceptual_new.x - hue_emulation_ramp_start, ramp_denom, 0.0), 0.0, 1.0);
    hue_emulation_strength *= ramp_t;

    float chrominance_pre = chrominance_current;
    perceptual_new.yz = lerp(perceptual_new.yz, perceptual_reference.yz, hue_emulation_strength);
    float chrominance_post = length(perceptual_new.yz);
    chrominance_ratio = renodx::math::DivideSafe(chrominance_pre, chrominance_post, 1.0);
    chrominance_current = chrominance_post;
  }

  if (chrominance_emulation_strength != 0.0) {
    float reference_chrominance = length(perceptual_reference.yz);
    float target_chrominance_ratio = renodx::math::DivideSafe(reference_chrominance, chrominance_current, 1.0);
    chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_emulation_strength);
  }

  perceptual_new.yz *= chrominance_ratio;

  float3 corrected_color_bt709 = renodx::color::bt709::from::OkLab(perceptual_new);
  return corrected_color_bt709;
}

float3 ApplySDREOTFEmulation(float3 color) {
  if (RENODX_SDR_EOTF_EMULATION == 2.f) {
    color = renodx::color::correct::Hue(renodx::color::correct::GammaSafe(color), color);
  } else if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    color = renodx::color::correct::GammaSafe(color);
  }
  return color;
}

float3 SplitContrast(float3 color, float contrast_shadows = 1.f, float contrast_highlights = 1.f, float mid_gray = 0.18f,
                     float3x3 color_space = renodx::color::BT709_TO_XYZ_MAT) {
  float color_y = dot(color, color_space[1].rgb);

  float contrast = renodx::math::Select(color_y < mid_gray, contrast_shadows, contrast_highlights);
  float contrasted_y = pow(color_y / mid_gray, contrast) * mid_gray;

  return renodx::color::correct::Luminance(color, color_y, contrasted_y);
}

float3 SplitContrastPerCh(float3 color, float contrast_shadows = 1.f, float contrast_highlights = 1.f, float mid_gray = 0.18f) {
  float3 contrast = renodx::math::Select(color < mid_gray, contrast_shadows, contrast_highlights);
  float3 contrasted = pow(color / mid_gray, contrast) * mid_gray;

  return contrasted;
}

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

float3 GenerateOutputAvatar(float3 ungraded_bt709, float contrast) {
  UserGradingConfig cg_config = CreateColorGradeConfig();
  float3 graded_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    graded_bt709 = ungraded_bt709;
  } else {  // Vanilla+
    // `pow(c, contrast) * 2.f` per channel will essentially give uncapped version of vanilla
    // apply by luminance to keep hues and chrominance intact and scale lightness evenly
    float shadow_contrast = contrast;
    // lower highlight contrast so image isn't overly harsh, but make sure sun still reaches 100.f
    float highlight_contrast = contrast * 0.63207f;
    float3 contrasted_bt709 = (SplitContrast(ungraded_bt709, shadow_contrast, highlight_contrast, 1.f)) * 2.f;

    // use reinhard to blow out and hue shift, peak of 10.f found to look good in testing
    float3 hue_and_chrominance_source = renodx::tonemap::ReinhardPiecewise(contrasted_bt709, 10.f, 1.f);

    // apply chrominance and hue of tonemapped color onto untonemapped, add saturation boost
    // this gives us our graded color which will be compressed by max channel to monitor peak later
    graded_bt709 = HueAndChrominanceOKLab(contrasted_bt709, hue_and_chrominance_source, RENODX_TONE_MAP_HUE_SHIFT, RENODX_TONE_MAP_BLOWOUT, 1.1f);
  }

  float3 final_bt709 = graded_bt709;
  if (RENODX_SDR_EOTF_EMULATION) {
    final_bt709 = renodx::color::correct::GammaSafe(final_bt709);
  }

  float y = renodx::color::y::from::BT709(graded_bt709);
  final_bt709 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(final_bt709, y, cg_config);
  final_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(final_bt709, graded_bt709, y, cg_config, false);

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(final_bt709);

  color_bt2020 = renodx::color::bt2020::clamp::AP1(color_bt2020);
  color_bt2020 = GamutCompress(color_bt2020, renodx::color::BT2020_TO_XYZ_MAT);

  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // display map by max channel
    color_pq = ApplyHermiteSplineByMaxChannelPQInput(color_pq, RENODX_DIFFUSE_WHITE_NITS, RENODX_PEAK_WHITE_NITS, 100.f);
  }

  return color_pq;
}

float3 GenerateOutputStarWarsOutlaws(float3 ungraded_bt709, float contrast) {
  UserGradingConfig cg_config = CreateColorGradeConfig();
  float3 graded_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    graded_bt709 = ungraded_bt709;
  } else {  // Vanilla+
    // `pow(c, contrast) * 1.7f` per channel will essentially give uncapped version of vanilla
    // apply by luminance to keep hues and chrominance intact and scale lightness evenly
    float shadow_contrast = contrast;
    // lower highlight contrast so image isn't overly harsh, but make sure sun still reaches 100.f
    float highlight_contrast = contrast * 0.69275f;
    float3 contrasted_bt709 = (SplitContrast(ungraded_bt709, shadow_contrast, highlight_contrast, 1.f)) * 1.7f;

    // use reinhard to blow out and hue shift, peak of 10.f found to look good in testing
    float3 hue_and_chrominance_source = renodx::tonemap::ReinhardPiecewise(contrasted_bt709, 10.f, 1.f);

    // apply chrominance and hue of tonemapped color onto untonemapped, add saturation boost
    // this gives us our graded color which will be compressed by max channel to monitor peak later
    graded_bt709 = HueAndChrominanceOKLab(contrasted_bt709, hue_and_chrominance_source, RENODX_TONE_MAP_HUE_SHIFT, RENODX_TONE_MAP_BLOWOUT, 1.1f);
  }

  float3 final_bt709 = graded_bt709;
  if (RENODX_SDR_EOTF_EMULATION) {
    final_bt709 = renodx::color::correct::GammaSafe(final_bt709);
  }

  float y = renodx::color::y::from::BT709(graded_bt709);
  final_bt709 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(final_bt709, y, cg_config);
  final_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(final_bt709, graded_bt709, y, cg_config, false);

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(final_bt709);
  
  color_bt2020 = renodx::color::bt2020::clamp::AP1(color_bt2020);
  color_bt2020 = GamutCompress(color_bt2020, renodx::color::BT2020_TO_XYZ_MAT);

  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // display map by max channel
    color_pq = ApplyHermiteSplineByMaxChannelPQInput(color_pq, RENODX_DIFFUSE_WHITE_NITS, RENODX_PEAK_WHITE_NITS, 100.f);
  }

  return color_pq;
}
