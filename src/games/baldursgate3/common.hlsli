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
  float chrominance_emulation;
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
    0.f                                                   // float chrominance_emulation;
  };
  return cg_config;
}

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

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config, bool clamp_to_ap1 = true) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_emulation_strength != 0.f || config.chrominance_emulation != 0.f || config.highlight_saturation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue emulation and blowout
    if (config.hue_emulation_strength != 0.0 || config.chrominance_emulation != 0.0) {
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

      if (config.chrominance_emulation != 0.0) {
        const float reference_chrominance = length(reference_oklab.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.chrominance_emulation);
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

float3 SplitContrast(float3 color, float contrast_shadows = 1.f, float contrast_highlights = 1.f, float mid_gray = 0.18f,
                     float3x3 color_space = renodx::color::BT709_TO_XYZ_MAT) {
  float color_y = dot(color, color_space[1].rgb);

  float contrast = renodx::math::Select(color_y < mid_gray, contrast_shadows, contrast_highlights);
  float contrasted_y = pow(color_y / mid_gray, contrast) * mid_gray;

  return renodx::color::correct::Luminance(color, color_y, contrasted_y);
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

float3 GammaCorrectHuePreserving(float3 incorrect_color, bool pow_to_srgb = false) {
  float3 corrected_color = renodx::color::correct::GammaSafe(incorrect_color, pow_to_srgb);
  float3 result = renodx::color::correct::Hue(corrected_color, incorrect_color);
  return result;
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

float4 GenerateLUTbuilderOutput(float3 untonemapped_ap1) {
  float3 color_output = renodx::color::bt709::from::AP1(untonemapped_ap1);

  // apply contrast and midgray adjustment
  color_output = SplitContrast(color_output, 1.5f, 1.2575f, 0.18f);
  color_output *= 0.16f / 0.18f;

  // use reinhard to blow out and hue shift, peak of 5.5f found to look good in testing
  float3 hue_and_chrominance_source = renodx::tonemap::ReinhardPiecewise(color_output, 5.5f, 0.16f);

  // apply blowout, hue shifts, and then saturation boost
  color_output = HueAndChrominanceOKLab(color_output, hue_and_chrominance_source, 1.f, 1.f, 1.325f);

  color_output = GammaCorrectHuePreserving(color_output);

  color_output = renodx::color::bt2020::from::BT709(color_output);
  color_output = GamutCompress(color_output, renodx::color::BT2020_TO_XYZ_MAT);

  color_output = renodx::color::pq::EncodeSafe(color_output, 100.f);

  return float4(color_output, 1.f);
}

float3 ApplyUserGrading(float3 ungraded_bt709) {
  UserGradingConfig cg_config = CreateColorGradeConfig();

  float y = renodx::color::y::from::BT709(ungraded_bt709);
  float3 graded_bt709 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded_bt709, y, cg_config);
  graded_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded_bt709, graded_bt709, y, cg_config);

  return graded_bt709;
}
