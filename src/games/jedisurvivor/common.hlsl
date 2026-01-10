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

float3 ApplyUserToneMap(float3 untonemapped_ap1) {
  renodx::tonemap::Config tm_config = renodx::tonemap::config::Create();
  float mid_gray = 0.1f;

  // RENOCES
  float reno_drt_highlights = 1.1025f;
  float reno_drt_shadows = 0.86f;
  float reno_drt_contrast = 1.45f;
  float reno_drt_saturation = 22.5f;
  float renoDRTDechroma = 0.90f;
  tm_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  tm_config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
  tm_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
  tm_config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  tm_config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL;

  tm_config.type = RENODX_TONE_MAP_TYPE;
  tm_config.peak_nits = RENODX_PEAK_WHITE_NITS;
  tm_config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  tm_config.gamma_correction = RENODX_GAMMA_CORRECTION;
  tm_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  tm_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  tm_config.shadows = RENODX_TONE_MAP_SHADOWS;
  tm_config.contrast = RENODX_TONE_MAP_CONTRAST;
  tm_config.saturation = RENODX_TONE_MAP_SATURATION;
  tm_config.reno_drt_highlights = reno_drt_highlights;
  tm_config.reno_drt_shadows = reno_drt_shadows;
  tm_config.reno_drt_contrast = reno_drt_contrast;
  tm_config.reno_drt_saturation = reno_drt_saturation;
  tm_config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  tm_config.reno_drt_blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  tm_config.mid_gray_value = mid_gray;
  tm_config.mid_gray_nits = mid_gray * 100.f;
  tm_config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  tm_config.reno_drt_working_color_space = 2;

  float3 incorrect_hue_ap1 = (untonemapped_ap1 * tm_config.mid_gray_value / 0.18f);
  float3 hue_shifted_color = renodx::color::bt709::from::AP1(renodx::tonemap::ReinhardPiecewise(incorrect_hue_ap1, 1.5f, tm_config.mid_gray_value));

  tm_config.hue_correction_color = hue_shifted_color;

  return renodx::tonemap::config::Apply(renodx::color::bt709::from::AP1(untonemapped_ap1), tm_config);
}

float3 ApplyACES(float3 untonemapped_ap1) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  // cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = 1.f - RENODX_TONE_MAP_HUE_SHIFT;
  float untonemapped_lum = renodx::color::y::from::AP1(untonemapped_ap1);
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }

  untonemapped_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, untonemapped_lum, cg_config);

  float3 tonemapped_ap1, tonemapped_bt709;
  if (RENODX_TONE_MAP_PER_CHANNEL) {
    tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
  } else {
    // tonemap both by channel and luminance
    renodx::tonemap::aces::ODTConfig odt_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);
    float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
    float y_out = renodx::tonemap::aces::ODTToneMap(y_in, odt_config) / 48.f;

    float3 channel_tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, odt_config) / 48.f;
    float3 luminance_tonemapped_ap1 = renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out);

    float3 channel_tonemapped_bt709 = renodx::color::bt709::from::AP1(channel_tonemapped_ap1);
    float3 luminance_tonemapped_bt709 = renodx::color::bt709::from::AP1(luminance_tonemapped_ap1);

    // match luminance tm chrominance with perch tm
    luminance_tonemapped_ap1 = renodx::color::correct::Chrominance(
        luminance_tonemapped_bt709,
        channel_tonemapped_bt709);

    float blending_ratio = saturate(renodx::color::y::from::BT709(luminance_tonemapped_ap1) / 0.6f);
    tonemapped_bt709 = lerp(luminance_tonemapped_ap1, channel_tonemapped_bt709, blending_ratio);
  }
  tonemapped_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(tonemapped_bt709, renodx::color::bt709::from::AP1(untonemapped_ap1), untonemapped_lum, cg_config);

  return tonemapped_bt709;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  float3 result = renodx::color::correct::Hue(corrected_color, incorrect_color);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {  //   if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

float4 GenerateOutput(float3 untonemapped_ap1) {
  float3 tonemapped_bt709;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    tonemapped_bt709 = ApplyACES(untonemapped_ap1);
  } else {
    tonemapped_bt709 = ApplyUserToneMap(untonemapped_ap1);
  }

  // if (RENODX_GAMMA_CORRECTION != 0.f) {
  //   tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
  // }
  tonemapped_bt709 = ApplyGammaCorrection(tonemapped_bt709);

  float3 pq_color = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), RENODX_DIFFUSE_WHITE_NITS);
  pq_color /= 1.05f;

  return float4(pq_color, 0.f);
}

bool HandleUICompositing(float4 ui_color, float4 scene_color, inout float4 output_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  // linearize and normalize brightness
  float3 ui_color_linear = renodx::color::pq::DecodeSafe(ui_color.rgb, RENODX_DIFFUSE_WHITE_NITS);
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color.rgb, RENODX_DIFFUSE_WHITE_NITS);

  // blend in gamma
  float3 ui_color_gamma = renodx::color::gamma::EncodeSafe(ui_color_linear);
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  float3 composited_color_gamma = ui_color_gamma + scene_color_gamma * (1.0 - ui_color.a);

  // linearize and scale up brightness
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  float3 pq_color = renodx::color::pq::EncodeSafe(composited_color_linear, RENODX_DIFFUSE_WHITE_NITS);
  output_color = float4(pq_color, 1.f);

  return true;
}
