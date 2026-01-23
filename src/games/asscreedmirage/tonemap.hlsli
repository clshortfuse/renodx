#include "./shared.h"

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    // value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    return max(x,
               lerp(x, mid_gray * pow(x / mid_gray, highlights),
                    renodx::tonemap::ExponentialRollOff(x, 1.f, 1.1f)));
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
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(renodx::color::bt709::from::AP1(color));

    float hue_correction_strength = config.hue_correction_strength;
    if (hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(renodx::color::bt709::from::AP1(hue_reference_color));

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);
      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, hue_correction_strength);
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

    color = renodx::color::ap1::from::BT709(color);
    color = max(0, color);
  }
  return color;
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
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  float ungraded_y = renodx::color::y::from::AP1(ungraded_ap1);

  float3 graded_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded_ap1, ungraded_y, cg_config);
  graded_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(graded_ap1, ungraded_ap1, ungraded_y, cg_config);

  return graded_ap1;
}

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

  float3 tonemapped_bt2020;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // ACES (Customized)
#if RENODX_GAME_GAMMA_CORRECTION
    aces_min /= 2.5f;
#endif

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

    float3 tonemapped_perch_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f;

    float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
    float y_out = renodx::tonemap::aces::ODTToneMap(y_in, ODT_config) / 48.f;
    float3 tonemapped_lum_ap1 = (renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out));

    const float blending_ratio = renodx::color::y::from::AP1(tonemapped_lum_ap1);
    float3 tonemapped_ap1 = lerp(tonemapped_lum_ap1, tonemapped_perch_ap1, saturate(blending_ratio));  // take highlights from per channel

    // take chrominance from perch
    tonemapped_bt2020 = renodx::color::bt2020::from::BT709(
        renodx::color::correct::Chrominance(
            renodx::color::bt709::from::AP1(tonemapped_ap1),
            renodx::color::bt709::from::AP1(tonemapped_perch_ap1)));
  } else {  // ACES
#if RENODX_GAME_GAMMA_CORRECTION
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

    float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f);

#if RENODX_GAME_GAMMA_CORRECTION
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif

    tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);
  }

  return renodx::color::pq::EncodeSafe(tonemapped_bt2020, diffuse_white_nits);
}
