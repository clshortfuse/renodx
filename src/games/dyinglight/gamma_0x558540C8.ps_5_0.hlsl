#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:10 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

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

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 untonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(untonemapped);

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

float3 ApplyGammaCorrectionByLuminance(float3 color_input) {
  float y_in = renodx::color::y::from::BT709(color_input);
  float y_out = renodx::color::correct::Gamma(max(0, y_in));
  float3 color_output = renodx::color::correct::Luminance(color_input, y_in, y_out);

  return color_output;
}

float3 ApplyGammaCorrectionToneMapAndScale(float3 untonemapped) {
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

  float3 lum, ch;
  float y = renodx::color::y::from::BT709(abs(untonemapped));

  float3 untonemapped_graded = untonemapped;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, cg_config);
  }

  float3 final_untonemapped = untonemapped_graded;
  if (RENODX_GAMMA_CORRECTION == 2.f) {  // 2.2 luminance with per channel chrominance
    lum = ApplyGammaCorrectionByLuminance(untonemapped_graded);
    ch = renodx::color::correct::GammaSafe(untonemapped_graded);
    final_untonemapped = renodx::color::correct::Chrominance(lum, ch, 1.f, 1.f);
  } else if (RENODX_GAMMA_CORRECTION) {
    final_untonemapped = renodx::color::correct::GammaSafe(untonemapped_graded);
  }

  float3 tonemapped = final_untonemapped;
  if (RENODX_TONE_MAP_TYPE == 0) {  // vanilla tonemap flickers if left unclamped
    tonemapped = saturate(final_untonemapped);
  } else {
    if (RENODX_TONE_MAP_TYPE == 2.f) {
      const float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      tonemapped = renodx::tonemap::ReinhardPiecewiseExtended(final_untonemapped, RENODX_TONE_MAP_WHITE_CLIP, peak_ratio, min(1.f, peak_ratio * 0.5f));
    }
    tonemapped = ApplySaturationBlowoutHueCorrectionHighlightSaturation(tonemapped, final_untonemapped, y, cg_config);
  }

  tonemapped *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    tonemapped = renodx::color::correct::GammaSafe(tonemapped, true);
  }

  return tonemapped;
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.xyzw = r0.xyzw;

  o0.rgb = ApplyGammaCorrectionToneMapAndScale(o0.rgb);

  o0.w = saturate(o0.w);
  return;
}
