#include "./shared.h"

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 5.f)));
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
  float3 corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  float3 result = renodx::color::correct::Hue(corrected_color, incorrect_color);

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
            1.f));

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

  ui_color.rgb = max(0, ui_color.rgb);
  const float ui_alpha = saturate(ui_color.a);
  const float one_minus_ui_alpha = 1.0 - ui_alpha;

  // linearize and normalize brightness
  float3 ui_color_linear;
  if (RENODX_GAMMA_CORRECTION != 0.f) {  // 2.2
    ui_color_linear = renodx::color::gamma::Decode(ui_color.rgb);
  } else {  // sRGB
    ui_color_linear = renodx::color::srgb::Decode(ui_color.rgb);
  }
  ui_color_linear = renodx::color::bt2020::from::BT709(ui_color_linear);
  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color, RENODX_GRAPHICS_WHITE_NITS);

#if 1  // apply Reinhard under UI
  if (TONEMAP_UNDER_UI != 0.f) {
    float y_in = renodx::color::y::from::BT2020(scene_color_linear);

    const float peak = 1.f;  // UI white
    float y_tonemapped = lerp(y_in, renodx::tonemap::Reinhard(y_in, peak), saturate(y_in));

    float y_out = lerp(y_in, y_tonemapped, ui_alpha);

    scene_color_linear = renodx::color::correct::Luminance(scene_color_linear, y_in, y_out);
  }
#endif

  // blend in gamma
  float3 ui_color_gamma = renodx::color::gamma::EncodeSafe(ui_color_linear);
  float3 scene_color_gamma = renodx::color::gamma::EncodeSafe(scene_color_linear);
  float3 composited_color_gamma = ui_color_gamma.rgb + (scene_color_gamma * one_minus_ui_alpha);

  // linearize and scale up brightness
  float3 composited_color_linear = renodx::color::gamma::DecodeSafe(composited_color_gamma);
  float3 pq_color = renodx::color::pq::EncodeSafe(composited_color_linear, RENODX_GRAPHICS_WHITE_NITS);
  output_color = float4(pq_color, 1.f);

  return true;
}
