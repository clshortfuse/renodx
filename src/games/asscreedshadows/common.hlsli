#include "./shared.h"

float3 HueAndChrominanceOKLab(
    float3 incorrect_color, float3 reference_color,
    float hue_correct_strength = 0.f,
    float chrominance_correct_strength = 0.f,
    float clamp_chrominance_loss = 0.f,
    float clamp_chrominance_gain = 0.f,
    float saturation = 1.f) {
  if (hue_correct_strength != 0.f || chrominance_correct_strength != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color);
    const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);

    float chrominance_current = length(perceptual_new.yz);
    float chrominance_ratio_hue = 1.f;
    float chrominance_ratio = 1.f;

    if (hue_correct_strength != 0.f) {
      const float chrominance_pre = chrominance_current;
      perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, hue_correct_strength);
      const float chrominancePost = length(perceptual_new.yz);
      chrominance_ratio_hue = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
      chrominance_current = chrominancePost;
    }

    if (chrominance_correct_strength != 0.f) {
      const float reference_chrominance = length(reference_oklab.yz);
      float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
      chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_correct_strength);
    }

    // Combine hue-preservation scaling and chroma correction, then clamp gain/loss.
    float chroma_scale = chrominance_ratio_hue * chrominance_ratio;
    const float chroma_gain_mask = step(1.f, chroma_scale);        // 1 when scaling up
    const float chroma_loss_mask = 1.f - step(1.f, chroma_scale);  // 1 when scaling down
    chroma_scale = lerp(chroma_scale, 1.f, chroma_gain_mask * clamp_chrominance_gain);
    chroma_scale = lerp(chroma_scale, 1.f, chroma_loss_mask * clamp_chrominance_loss);

    perceptual_new.yz *= chroma_scale;
    perceptual_new.yz *= saturation;

    incorrect_color = renodx::color::bt709::from::OkLab(perceptual_new);
    incorrect_color = renodx::color::bt709::clamp::AP1(incorrect_color);
  }
  return incorrect_color;
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(float3 ungraded_ap1, float3 hue_reference_color_ap1, float y, renodx::color::grade::Config config) {
  float3 color_ap1 = ungraded_ap1;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 color = renodx::color::bt709::from::AP1(ungraded_ap1);
    float3 hue_reference_color = renodx::color::bt709::from::AP1(hue_reference_color_ap1);

    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(hue_reference_color);

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

    color_ap1 = max(0, renodx::color::ap1::from::BT709(color));
  }
  return color_ap1;
}

float3 ApplyUserColorGradingAP1(float3 ungraded_ap1) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = 0.f;  // no hue correction
  cg_config.blowout = 0.f;                  // no highlight saturation
  float ungraded_y = renodx::color::y::from::AP1(ungraded_ap1);

  float3 graded_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded_ap1, ungraded_y, cg_config);
  graded_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(graded_ap1, ungraded_ap1, ungraded_y, cg_config);

  return graded_ap1;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
#if USE_LUM_GAMMA_CORRECTION_WITH_CHROMINANCE_CORRECTION
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = max(0, renodx::color::y::from::BT709(incorrect_color));
  const float y_out = renodx::color::correct::Gamma(y_in);

  float3 lum = renodx::color::correct::Luminance(incorrect_color, y_in, y_out);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);
#else
  float3 corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  float3 result = renodx::color::correct::Hue(corrected_color, incorrect_color);
#endif
  return result;
}

/// Vanilla Tonemapper from Assassin's Creed Shadows
/// biased around 100 nits
#define ACSHADOWSTONEMAP_GENERATOR(T)                                                                                                                                                                                                                                                                                                      \
  T ApplyACShadowsToneMap(T untonemapped_ap1, float peak_nits = 100.f, float min_nits = 0.f) {                                                                                                                                                                                                                                             \
    /* Declare params, use values from SDR */                                                                                                                                                                                                                                                                                              \
    const float contrast = 1.25f;                   /* cb0_space5_000x        */                                                                                                                                                                                                                                                           \
    const float toe_threshold = 0.13f;              /* cb0_space5_000y ≈ 0.13 */                                                                                                                                                                                                                                                           \
    const float mid_point = 0.50f;                  /* cb0_space5_000z        */                                                                                                                                                                                                                                                           \
    const float toe_slope = 1.00f;                  /* cb0_space5_000w        */                                                                                                                                                                                                                                                           \
    const float black_offset = min_nits / 100.f;    /* cb0_space5_001x        */                                                                                                                                                                                                                                                           \
    const float peak_luminance = peak_nits / 100.f; /* cb0_space5_003w        */                                                                                                                                                                                                                                                           \
                                                                                                                                                                                                                                                                                                                                           \
    /* parameter setup */                                                                                                                                                                                                                                                                                                                  \
    const float inv_ln2 = 1.f / log(2.f);                                                                                                                                                                                                                                                                                                  \
    float _233 = peak_luminance;                                                                                                                                                                                                                                                                                                           \
    float _243 = ((_233 - toe_threshold) * mid_point) / contrast;                                                                                                                                                                                                                                                                          \
    bool _247 = (toe_threshold > 1e-5);                                                                                                                                                                                                                                                                                                    \
    float _259 = _233 - ((_243 * contrast) + toe_threshold);                                                                                                                                                                                                                                                                               \
    float _260 = (contrast * _233) / _259;                                                                                                                                                                                                                                                                                                 \
    float _275 = _243 + toe_threshold;                                                                                                                                                                                                                                                                                                     \
                                                                                                                                                                                                                                                                                                                                           \
    /* Per-channel processing */                                                                                                                                                                                                                                                                                                           \
    T _input_scaled = abs(untonemapped_ap1 / 100.f);                                                                                                                                                                                                                                                                                       \
    T _select_result = select((_input_scaled > _275), (T)1.0f, (T)0.0f);                                                                                                                                                                                                                                                                   \
    T _step1 = _input_scaled - toe_threshold;                                                                                                                                                                                                                                                                                              \
    T _step2 = _input_scaled / toe_threshold;                                                                                                                                                                                                                                                                                              \
    T _step3_sat = saturate(_step2);                                                                                                                                                                                                                                                                                                       \
    T _step3_smooth = (_step3_sat * _step3_sat) * (3.0f - (_step3_sat * 2.0f));                                                                                                                                                                                                                                                            \
    T _final_result = (((((_step3_smooth - _select_result) * ((_step1 * contrast) + toe_threshold)) + ((_233 - (exp2(((-0.0f - ((_step1 - _243) * _260)) / _233) * inv_ln2) * _259)) * _select_result)) + ((1.0f - _step3_smooth) * select(_247, ((exp2(log2(abs(_step2)) * toe_slope) * toe_threshold) + black_offset), black_offset)))); \
                                                                                                                                                                                                                                                                                                                                           \
    return _final_result;                                                                                                                                                                                                                                                                                                                  \
  }

ACSHADOWSTONEMAP_GENERATOR(float)
ACSHADOWSTONEMAP_GENERATOR(float3)
#undef ACSHADOWSTONEMAP_GENERATOR

float3 ApplyVanillaPlusToneMapPerChannel(float3 untonemapped_ap1, float peak_white = 100.f, float diffuse_white = 100.f) {
  float peak_ratio = peak_white / diffuse_white;
  float min_ratio = 0.0001f / diffuse_white;
#if RENODX_GAME_GAMMA_CORRECTION  // inverse gamma correct peak nits
  peak_ratio = renodx::color::correct::GammaSafe(peak_ratio, true);
  min_ratio = renodx::color::correct::GammaSafe(min_ratio, true);
#endif

  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(ApplyACShadowsToneMap(untonemapped_ap1, peak_ratio * 100.f, min_ratio * 100.f));

#if RENODX_GAME_GAMMA_CORRECTION  // apply custom sRGB -> 2.2 gamma correction
  tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif

  return renodx::color::bt2020::from::BT709(tonemapped_bt709);
}

float3 ApplyACESPerChannel(float3 untonemapped_ap1, float peak_white = 100.f, float diffuse_white = 100.f) {
  untonemapped_ap1 /= 32.f;
  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white;
  float aces_max = (peak_white / diffuse_white);
  renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f;

  return renodx::color::bt2020::from::AP1(tonemapped_ap1);
}

float3 ApplyVanillaPlusToneMapByLuminanceBlended(float3 untonemapped_ap1, float peak_white = 100.f, float diffuse_white = 100.f) {
  float peak_ratio = peak_white / diffuse_white;
  float min_ratio = 0.0001f / diffuse_white;
#if RENODX_GAME_GAMMA_CORRECTION  // inverse gamma correct peak nits
  peak_ratio = renodx::color::correct::GammaSafe(peak_ratio, true);
  min_ratio = renodx::color::correct::GammaSafe(min_ratio, true);
#endif

#if USE_LUM_TM_WITH_CHROMINANCE_CORRECTION
  float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
  float y_out = ApplyACShadowsToneMap(y_in, peak_ratio * 100.f, min_ratio * 100.f);

  float3 tonemapped_lum_bt709 = renodx::color::bt709::from::AP1(renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out));
  float3 tonemapped_perch_bt709 = renodx::color::bt709::from::AP1(ApplyACShadowsToneMap(untonemapped_ap1, peak_ratio * 100.f, min_ratio * 100.f));

  tonemapped_lum_bt709 = renodx::color::correct::Chrominance(tonemapped_lum_bt709, tonemapped_perch_bt709, 1.f);  // take chrominance from per channel
  tonemapped_lum_bt709 = renodx::color::bt709::clamp::AP1(tonemapped_lum_bt709);

  const float blending_ratio = renodx::color::y::from::BT709(tonemapped_lum_bt709);
  float3 tonemapped_bt709 = lerp(tonemapped_lum_bt709, tonemapped_perch_bt709, saturate(blending_ratio));  // take highlights from per channel
#else
  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(ApplyACShadowsToneMap(untonemapped_ap1, peak_ratio * 100.f, min_ratio * 100.f));
  float3 tonemapped_bt709_hue_corrected = renodx::color::correct::Hue(tonemapped_bt709, renodx::color::bt709::from::AP1(untonemapped_ap1));

  const float blending_ratio = renodx::color::y::from::BT709(tonemapped_bt709_hue_corrected);
  tonemapped_bt709 = lerp(tonemapped_bt709_hue_corrected, tonemapped_bt709, saturate(blending_ratio));  // take highlights from per channel
#endif

#if RENODX_GAME_GAMMA_CORRECTION  // apply hue preserving sRGB -> 2.2 gamma correction
  tonemapped_bt709 = GammaCorrectHuePreserving(tonemapped_bt709);
#endif

  return renodx::color::bt2020::from::BT709(tonemapped_bt709);
}

float3 ApplyACESByLuminanceBlended(float3 untonemapped_ap1, float peak_white = 100.f, float diffuse_white = 100.f) {
  untonemapped_ap1 /= 32.f;
  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white;
  float aces_max = (peak_white / diffuse_white);
  renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

  float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
  float y_out = renodx::tonemap::aces::ODTToneMap(y_in, ODT_config) / 48.f;
  float3 tonemapped_lum_bt709 = renodx::color::bt709::from::AP1(renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out));

  float3 tonemapped_perch_bt709 = renodx::color::bt709::from::AP1(renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f);

  tonemapped_lum_bt709 = renodx::color::correct::Chrominance(tonemapped_lum_bt709, tonemapped_perch_bt709, 1.f);  // take chrominance from per channel
  tonemapped_lum_bt709 = renodx::color::bt709::clamp::AP1(tonemapped_lum_bt709);

  const float blending_ratio = renodx::color::y::from::BT709(tonemapped_lum_bt709);
  float3 tonemapped_bt709 = lerp(tonemapped_lum_bt709, tonemapped_perch_bt709, saturate(blending_ratio));  // take highlights from per channel

  return renodx::color::bt2020::from::BT709(tonemapped_bt709);
}

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_white = 100.f, float diffuse_white = 100.f) {
  float3 tonemapped_bt2020;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    tonemapped_bt2020 = ApplyACESByLuminanceBlended(untonemapped_ap1, peak_white, diffuse_white);
  } else {
    tonemapped_bt2020 = ApplyVanillaPlusToneMapByLuminanceBlended(untonemapped_ap1, peak_white, diffuse_white);
  }
  return renodx::color::pq::EncodeSafe(tonemapped_bt2020, diffuse_white);
}
