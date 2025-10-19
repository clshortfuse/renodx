#include "./shared.h"

// Reinhard piecewise shoulder driven by the channel max to compress into output_max.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f, float channel_max = 100.f) {
  float peak = renodx::math::Max(color.r, color.g, color.b);

  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, channel_max, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 0.f);
  float3 tonemapped = color * scale;

  return tonemapped;
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

float3 ApplyToneMap(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color;

  float3 color_ungraded = color;
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

  float y = renodx::color::y::from::BT709(color);
  color = ApplyExposureContrastFlareHighlightsShadowsByLuminance(color, y, cg_config);

  if (RENODX_TONE_MAP_TYPE == 2.f) {
    float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    color = renodx::tonemap::ReinhardPiecewiseExtended(color, RENODX_TONE_MAP_WHITE_CLIP, peak_ratio, min(peak_ratio * 0.5f, 1.f));
  }

  color = ApplySaturationBlowoutHueCorrectionHighlightSaturation(color, color_ungraded, y, cg_config);

  return color;
}

float3 ApplyFilmGrain(float3 color, float2 position) {
  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    color = renodx::effects::ApplyFilmGrain(
        color,
        position,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f);
  }
  return color;
}

float3 ApplyToneMapAndGrain(float3 color, float2 position) {
  color = ApplyToneMap(color);
  color = ApplyFilmGrain(color, position);
  return color;
}

float3 ToneMapAndRenderIntermediatePass(float3 color, float2 position) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color = ApplyToneMapAndGrain(color, position);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color = ApplyToneMapAndGrain(color, position);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color = ApplyToneMapAndGrain(color, position);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 InvertIntermediatePass(float3 color) {
  return color;

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 ClampInIntermediatePass(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = saturate(color);
  } else if (RENODX_TONE_MAP_TYPE >= 2.f) {
    color = min(color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  }
  return color;
}

float3 ClampAndRenderIntermediatePass(float3 color) {
  return color;

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color = ClampInIntermediatePass(color);
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color = ClampInIntermediatePass(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color = ClampInIntermediatePass(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}
