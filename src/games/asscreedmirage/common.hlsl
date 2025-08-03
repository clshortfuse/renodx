#include "./shared.h"

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

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

  float3 tonemapped_bt709;
  if (RENODX_TONE_MAP_TYPE == 2.f) {  // regular ACES with gamma correction
    float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

#if RENODX_GAME_GAMMA_CORRECTION
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

    float3 tonemapped_ap1 = renodx::tonemap::aces::RRTAndODT(untonemapped_bt709, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

#if RENODX_GAME_GAMMA_CORRECTION
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif
  } else {  // customized version of ACES, by luminance for midtones and shadows and per-channel for highlights, lowers minimum nits instead of gamma correcting
#if RENODX_GAME_GAMMA_CORRECTION
    aces_min /= 5.f;
#endif
    untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

    float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
    float y_out = renodx::tonemap::aces::ODTToneMap(y_in, ODT_config) / 48.f;
    float3 tonemapped_lum_bt709 = renodx::color::bt709::from::AP1(renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out));

    float3 tonemapped_perch_bt709 = renodx::color::bt709::from::AP1(renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f);

    tonemapped_lum_bt709 = renodx::color::correct::Chrominance(tonemapped_lum_bt709, tonemapped_perch_bt709, 1.f);  // take chrominance from per channel

    const float blending_ratio = renodx::color::y::from::BT709(tonemapped_lum_bt709);
    tonemapped_bt709 = lerp(tonemapped_lum_bt709, tonemapped_perch_bt709, saturate(blending_ratio));  // take highlights from per channel
  }

  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), diffuse_white_nits);

  return pq_color;
}
