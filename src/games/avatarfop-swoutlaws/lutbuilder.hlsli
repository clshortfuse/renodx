#include "./macleod_boynton.hlsli"
#include "./shared.h"

float3 ApplySDREOTFEmulation(float3 color) {
  if (RENODX_SDR_EOTF_EMULATION == 2.f) {
    color = renodx::color::correct::Hue(renodx::color::correct::GammaSafe(color), color);
  } else if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    color = renodx::color::correct::GammaSafe(color);
  }
  return color;
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

float3 ApplyLuminosityGrading(float3 untonemapped, float y, UserGradingConfig config, float mid_gray = 0.18f) {
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

float3 ApplyHueAndPurityGrading(
    float3 tonemapped,
    float3 hue_reference_color,
    float lum,
    UserGradingConfig config,
    bool clamp_to_ap1 = true,
    float curve_gamma = 1.f,
    float2 mb_white_override = float2(-1.f, -1.f),
    float t_min = 1e-6f) {
  float3 color = tonemapped;
  if (config.saturation == 1.f && config.dechroma == 0.f && config.hue_emulation_strength == 0.f && config.chrominance_emulation == 0.f && config.highlight_saturation == 0.f) {
    return color;
  }

  const float kNearWhiteEpsilon = renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON;
  const float2 white = (mb_white_override.x >= 0.f && mb_white_override.y >= 0.f)
                           ? mb_white_override
                           : renodx_custom::color::macleod_boynton::MB_White_D65();

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(color);
  float color_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                             color_bt2020, 1.f, 1.f, mb_white_override, t_min)
                             .purityCur01;

  // MB hue + purity emulation (analog of OkLab hue/chrominance section).
  if (config.hue_emulation_strength != 0.f || config.chrominance_emulation != 0.f) {
    float3 reference_bt2020 = renodx::color::bt2020::from::BT709(hue_reference_color);
    float reference_purity01 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                                   reference_bt2020, 1.f, 1.f, mb_white_override, t_min)
                                   .purityCur01;

    float purity_current = color_purity01;
    float purity_ratio = 1.f;
    float3 hue_seed_bt2020 = color_bt2020;

    if (config.hue_emulation_strength != 0.f) {
      float3 target_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                              mul(renodx::color::BT2020_TO_XYZ_MAT, color_bt2020));
      float3 reference_lms = mul(renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
                                 mul(renodx::color::BT2020_TO_XYZ_MAT, reference_bt2020));

      float target_t = target_lms.x + target_lms.y;
      if (target_t > t_min) {
        float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - white;
        float2 reference_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(reference_lms) - white;

        float target_len_sq = dot(target_direction, target_direction);
        float reference_len_sq = dot(reference_direction, reference_direction);

        if (target_len_sq > kNearWhiteEpsilon || reference_len_sq > kNearWhiteEpsilon) {
          float2 target_unit = (target_len_sq > kNearWhiteEpsilon)
                                   ? target_direction * rsqrt(target_len_sq)
                                   : float2(0.f, 0.f);
          float2 reference_unit = (reference_len_sq > kNearWhiteEpsilon)
                                      ? reference_direction * rsqrt(reference_len_sq)
                                      : target_unit;

          if (target_len_sq <= kNearWhiteEpsilon) {
            target_unit = reference_unit;
          }

          float2 blended_unit = lerp(target_unit, reference_unit, config.hue_emulation_strength);
          float blended_len_sq = dot(blended_unit, blended_unit);
          if (blended_len_sq <= kNearWhiteEpsilon) {
            blended_unit = (config.hue_emulation_strength >= 0.5f) ? reference_unit : target_unit;
            blended_len_sq = dot(blended_unit, blended_unit);
          }
          blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

          float seed_len = sqrt(max(target_len_sq, 0.f));
          if (seed_len <= 1e-6f) {
            seed_len = sqrt(max(reference_len_sq, 0.f));
          }
          seed_len = max(seed_len, 1e-6f);

          hue_seed_bt2020 = mul(
              renodx::color::XYZ_TO_BT2020_MAT,
              mul(renodx_custom::color::macleod_boynton::LMS_TO_XYZ_2006,
                  renodx_custom::color::macleod_boynton::LMS_From_MB_T(white + blended_unit * seed_len, target_t)));

          float purity_post = renodx_custom::color::macleod_boynton::ApplyBT2020(
                                  hue_seed_bt2020, 1.f, 1.f, mb_white_override, t_min)
                                  .purityCur01;
          purity_ratio = renodx::math::SafeDivision(purity_current, purity_post, 1.f);
          purity_current = purity_post;
        }
      }
    }

    if (config.chrominance_emulation != 0.f) {
      float target_purity_ratio = renodx::math::SafeDivision(reference_purity01, purity_current, 1.f);
      purity_ratio = lerp(purity_ratio, target_purity_ratio, config.chrominance_emulation);
    }

    float applied_purity01 = saturate(purity_current * max(purity_ratio, 0.f));
    color_bt2020 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                       hue_seed_bt2020, applied_purity01, curve_gamma, mb_white_override, t_min)
                       .rgbOut;
    color_purity01 = applied_purity01;
  }

  float purity_scale = 1.f;

  // dechroma
  if (config.dechroma != 0.f) {
    purity_scale *= lerp(1.f, 0.f, saturate(pow(lum / (10000.f / 100.f), (1.f - config.dechroma))));
  }

  // highlight saturation
  if (config.highlight_saturation != 0.f) {
    float percent_max = saturate(lum * 100.f / 10000.f);
    // positive = 1 to 0, negative = 1 to 2
    float blowout_strength = 100.f;
    float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
    if (config.highlight_saturation < 0) {
      blowout_change = (2.f - blowout_change);
    }

    purity_scale *= blowout_change;
  }

  // saturation
  purity_scale *= config.saturation;

  if (purity_scale != 1.f) {
    float scaled_purity01 = saturate(color_purity01 * max(purity_scale, 0.f));
    color_bt2020 = renodx_custom::color::macleod_boynton::ApplyBT2020(
                       color_bt2020, scaled_purity01, curve_gamma, mb_white_override, t_min)
                       .rgbOut;
  }

  color = renodx::color::bt709::from::BT2020(color_bt2020);

  if (clamp_to_ap1) {
    color = renodx::color::bt709::clamp::AP1(color);
  }

  return color;
}

#define SPLIT_CONTRAST_FUNCTION_GENERATOR(T)                                                       \
  T SplitContrast(T input, float contrast_shadows = 1.f, float contrast_highlights = 1.f,          \
                  float split_point = 0.18f) {                                                     \
    T contrast = renodx::math::Select(input < split_point, contrast_shadows, contrast_highlights); \
    T contrasted = pow(input / split_point, contrast) * split_point;                               \
    return contrasted;                                                                             \
  }

SPLIT_CONTRAST_FUNCTION_GENERATOR(float)
SPLIT_CONTRAST_FUNCTION_GENERATOR(float3)

#undef SPLIT_CONTRAST_FUNCTION_GENERATOR

float3 ApplyUserGrading(float3 ungraded) {
  UserGradingConfig cg_config = CreateColorGradeConfig();
  float y = renodx::color::y::from::BT709(ungraded);
  float3 graded = ApplyLuminosityGrading(ungraded, y, cg_config);
  graded = ApplyHueAndPurityGrading(graded, ungraded, y, cg_config, false);

  return graded;
}

float3 GenerateOutputAvatar(float3 ungraded_bt709, float contrast) {
  float3 graded_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    graded_bt709 = ungraded_bt709;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      float lum_in = LuminosityFromBT709LuminanceNormalized(ungraded_bt709);
      float lum_out = renodx::color::correct::GammaSafe(lum_in);
      float3 corrected_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

      float3 corrected_ch = renodx::color::correct::GammaSafe(ungraded_bt709);
      graded_bt709 = CorrectPurityMB(corrected_lum, corrected_ch);
    }
  } else {  // Vanilla+
    // `pow(c, contrast) * 2.f` per channel will essentially give uncapped version of vanilla
    float shadow_contrast = contrast;
    // lower highlight contrast so image isn't overly harsh, but make sure sun still reaches 100.f (10k nits with 100 game brightness)
    float highlight_contrast = contrast * 0.681f;
    float exposure_adjustment = 2.f;

    // apply by luminosity to keep hues intact and scale lightness evenly
    float lum_in = LuminosityFromBT709LuminanceNormalized(ungraded_bt709);
    float lum_out = SplitContrast(lum_in, shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      lum_out = renodx::color::correct::GammaSafe(lum_out);
    }
    float3 contrasted_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

    // apply grading per channel as reference color to take purity from
    float3 contrasted_ch = renodx::color::bt709::from::BT2020(SplitContrast(renodx::color::bt2020::from::BT709(ungraded_bt709), shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment);
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      contrasted_ch = renodx::color::correct::GammaSafe(contrasted_ch);
    }
    // use reinhard to blow out and hue shift, peak of 10.f found to look good in testing
    float3 hue_and_chrominance_source = renodx::tonemap::ReinhardPiecewise(contrasted_ch, 10.f, 1.f);

    // apply purity and hue (only on highlights) of per channel contrasted to luminosity contrasted
    // this gives us our graded color which will be compressed by max channel to monitor peak later
    graded_bt709 = CorrectHueAndPurityMBGated(contrasted_lum, hue_and_chrominance_source, 1.f, 1.f, 2.f);
  }

  if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    graded_bt709 = renodx::color::correct::GammaSafe(graded_bt709);
  }

  float3 final_bt709 = ApplyUserGrading(graded_bt709);

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(final_bt709);

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // display map by max channel
    color_bt2020 = renodx::tonemap::neutwo::MaxChannel(color_bt2020, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, RENODX_TONE_MAP_WHITE_CLIP);
  }

  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);

  return color_pq;
}

float3 GenerateOutputStarWarsOutlaws(float3 ungraded_bt709, float contrast) {
  float3 graded_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    graded_bt709 = ungraded_bt709;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      float lum_in = LuminosityFromBT709LuminanceNormalized(ungraded_bt709);
      float lum_out = renodx::color::correct::GammaSafe(lum_in);
      float3 corrected_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

      float3 corrected_ch = renodx::color::correct::GammaSafe(ungraded_bt709);
      graded_bt709 = CorrectPurityMB(corrected_lum, corrected_ch);
    }
  } else {  // Vanilla+
    // `pow(c, contrast) * 2.f` per channel will essentially give uncapped version of vanilla
    float shadow_contrast = contrast;
    // lower highlight contrast so image isn't overly harsh, but make sure sun still reaches 100.f (10k nits with 100 game brightness)
    float highlight_contrast = contrast * 0.7375f;
    float exposure_adjustment = 1.7f;

    // apply by luminosity to keep hues intact and scale lightness evenly
    float lum_in = LuminosityFromBT709LuminanceNormalized(ungraded_bt709);
    float lum_out = SplitContrast(lum_in, shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment;
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      lum_out = renodx::color::correct::GammaSafe(lum_out);
    }
    float3 contrasted_lum = renodx::color::correct::Luminance(ungraded_bt709, lum_in, lum_out);

    // apply grading per channel as reference color to take purity from
    float3 contrasted_ch = renodx::color::bt709::from::BT2020(SplitContrast(renodx::color::bt2020::from::BT709(ungraded_bt709), shadow_contrast, highlight_contrast, 1.f) * exposure_adjustment);
    if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      contrasted_ch = renodx::color::correct::GammaSafe(contrasted_ch);
    }
    // use reinhard to blow out and hue shift, peak of 10.f found to look good in testing
    float3 hue_and_chrominance_source = renodx::tonemap::ReinhardPiecewise(contrasted_ch, 10.f, 1.f);

    // apply purity and hue (only on highlights) of per channel contrasted to luminosity contrasted
    // this gives us our graded color which will be compressed by max channel to monitor peak later
    graded_bt709 = CorrectHueAndPurityMBGated(contrasted_lum, hue_and_chrominance_source, 1.f, 1.f, 2.f);
  }

  if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    graded_bt709 = renodx::color::correct::GammaSafe(graded_bt709);
  }

  float3 final_bt709 = ApplyUserGrading(graded_bt709);

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(final_bt709);

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // display map by max channel
    color_bt2020 = renodx::tonemap::neutwo::MaxChannel(color_bt2020, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, RENODX_TONE_MAP_WHITE_CLIP);
  }

  float3 color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_DIFFUSE_WHITE_NITS);

  return color_pq;
}
