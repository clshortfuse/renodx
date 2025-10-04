#include "./shared.h"

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  float shadow_mask = 1.f;
  if (config.shadows < 1.f) shadow_mask = mid_gray;

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

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
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

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = renodx::color::y::from::BT709(incorrect_color);
  const float y_out = max(0, renodx::color::correct::Gamma(y_in));

  float3 lum = incorrect_color * (y_in > 0 ? y_out / y_in : 0.f);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

float4 GenerateOutput(float3 untonemapped_ap1) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  float untonemapped_lum = renodx::color::y::from::AP1(untonemapped_ap1);

  float ACES_MIN;
  float aces_min;
  float aces_max;
  float3 tonemapped_ap1;
  float3 graded_ap1;
  float3 tonemapped_bt709;
  float3 pq_color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    graded_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, untonemapped_lum, cg_config, 0.18f);
    graded_ap1 *= 0.1f / 0.18f;
    float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(graded_ap1);
    untonemapped_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(untonemapped_bt709, renodx::color::bt709::from::AP1(untonemapped_ap1), untonemapped_lum, cg_config);

    untonemapped_bt709 = ApplyGammaCorrection(untonemapped_bt709);

    pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(untonemapped_bt709), RENODX_DIFFUSE_WHITE_NITS);
    return float4(pq_color * (1.f / 1.05f), 0.f);  // lutbuilder does this
  } else if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
    ACES_MIN = 0.0001f;
    aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
    aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    if (RENODX_GAMMA_CORRECTION) {
      aces_max = renodx::color::correct::Gamma(aces_max, true);
      aces_min = renodx::color::correct::Gamma(aces_min, true);
    }

    graded_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, untonemapped_lum, cg_config);
    graded_ap1 = max(0, graded_ap1);

    // tonemap both by channel and luminance
    renodx::tonemap::aces::ODTConfig odt_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);
    float y_in = renodx::color::y::from::AP1(graded_ap1);
    float y_out = renodx::tonemap::aces::ODTToneMap(y_in, odt_config) / 48.f;

    float3 channel_tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(graded_ap1, odt_config) / 48.f;
    float3 luminance_tonemapped_ap1 = renodx::color::correct::Luminance(graded_ap1, y_in, y_out);

    // correct luminance tonemap saturation
    luminance_tonemapped_ap1 = renodx::color::ap1::from::BT709(
        renodx::color::correct::Chrominance(
            renodx::color::bt709::from::AP1(luminance_tonemapped_ap1),
            renodx::color::bt709::from::AP1(channel_tonemapped_ap1),
            1.f,   // strength
            0.f,   // clamp chrominance loss
            0u));  // hue processor

    // blend luminance and channel
    float lum = renodx::color::y::from::AP1(luminance_tonemapped_ap1);
    tonemapped_ap1 = lerp(luminance_tonemapped_ap1, channel_tonemapped_ap1, saturate(lum / 1.f));
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1.rgb);

    tonemapped_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(tonemapped_bt709, renodx::color::bt709::from::AP1(untonemapped_ap1), untonemapped_lum, cg_config);

    tonemapped_bt709 = ApplyGammaCorrection(tonemapped_bt709);

    pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), RENODX_DIFFUSE_WHITE_NITS);
    return float4(pq_color * (1.f / 1.05f), 0.f);  // lutbuilder does this
  } else {
    ACES_MIN = 0.0001f;
    aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
    aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

    if (RENODX_GAMMA_CORRECTION) {
      aces_max = renodx::color::correct::Gamma(aces_max, true);
      aces_min = renodx::color::correct::Gamma(aces_min, true);
    }

    graded_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, untonemapped_lum, cg_config);
    graded_ap1 = max(0, graded_ap1);

    tonemapped_ap1 = renodx::tonemap::aces::ODT(graded_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

    tonemapped_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(tonemapped_bt709, renodx::color::bt709::from::AP1(untonemapped_ap1), untonemapped_lum, cg_config);

    tonemapped_bt709 = ApplyGammaCorrection(tonemapped_bt709);

    pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), RENODX_DIFFUSE_WHITE_NITS);
    return float4(pq_color * (1.f / 1.05f), 0.f);  // lutbuilder does this
  }
}

bool HandleUICompositing(float4 ui_color, float3 scene_color, inout float4 output_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  // linearize and normalize brightness
  float3 ui_color_linear;
  if (RENODX_GAMMA_CORRECTION != 0.f) {  // 2.2
    ui_color_linear = renodx::color::gamma::Decode(max(0, ui_color.rgb));
  } else {  // sRGB
    ui_color_linear = renodx::color::srgb::Decode(max(0, ui_color.rgb));
  }
  ui_color_linear = renodx::color::bt2020::from::BT709(ui_color_linear) * RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color, RENODX_DIFFUSE_WHITE_NITS);

  // blend in gamma
  float3 ui_color_gamma = renodx::color::gamma::EncodeSafe(ui_color_linear);
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  float3 composited_color_gamma = lerp(scene_color_gamma, ui_color_gamma, ui_color.a);

  // linearize and scale up brightness
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  float3 pq_color = renodx::color::pq::EncodeSafe(composited_color_linear, RENODX_DIFFUSE_WHITE_NITS);
  output_color = float4(pq_color, 1.f);

  return true;
}
