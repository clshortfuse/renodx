#include "./shared.h"

float ComputeMaxChCompressionScale(float3 untonemapped) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::Neutwo(peak);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);
  return scale;
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
  float blowout;
};

UserGradingConfig CreateColorGradeConfig() {
  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,
    RENODX_TONE_MAP_HIGHLIGHTS,
    RENODX_TONE_MAP_SHADOWS,
    RENODX_TONE_MAP_CONTRAST,
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
    RENODX_TONE_MAP_SATURATION,
    RENODX_TONE_MAP_DECHROMA,
    RENODX_TONE_MAP_HUE_SHIFT,
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
    RENODX_TONE_MAP_BLOWOUT
  };
  return cg_config;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;
  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 5.f)));
  } else {
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
  } else {
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, UserGradingConfig config, float mid_gray) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;
  color *= config.exposure;
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);
  color = renodx::color::correct::Luminance(color, y, y_shadowed);
  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config, bool clamp_to_ap1) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_emulation_strength != 0.f || config.blowout != 0.f || config.highlight_saturation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_emulation_strength != 0.0 || config.blowout != 0.0) {
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

      if (config.blowout != 0.0) {
        const float reference_chrominance = length(reference_oklab.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.blowout);
      }
      perceptual_new.yz *= chrominance_ratio;
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
      if (config.highlight_saturation < 0) {
        blowout_change = (2.f - blowout_change);
      }
      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;
    color = renodx::color::bt709::from::OkLab(perceptual_new);

    if (clamp_to_ap1) {
      color = renodx::color::bt709::clamp::AP1(color);
    }
  }
  return color;
}

float3 ApplyToneMap(float3 untonemapped) {
  float3 tonemapped;

  if (RENODX_TONE_MAP_TYPE == 0) {
    tonemapped = saturate(untonemapped);
  } else {
    const UserGradingConfig cg_config = CreateColorGradeConfig();
    float3 hue_correction_source = untonemapped;
    const float y = renodx::color::y::from::BT709(untonemapped);

    float3 untonemapped_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, cg_config, 0.18f);
    if (RENODX_TONE_MAP_HUE_SHIFT > 0.f || RENODX_TONE_MAP_BLOWOUT > 0.f) {
      hue_correction_source = renodx::tonemap::neutwo::PerChannel(untonemapped, 8.f, 100.f);
    }
    untonemapped_graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(untonemapped_graded, hue_correction_source, y, cg_config, true);

    if (RENODX_TONE_MAP_TYPE == 1.f) {
      tonemapped = renodx::color::bt709::from::BT2020(
          renodx::tonemap::neutwo::MaxChannel(
              renodx::color::bt2020::from::BT709(untonemapped_graded), RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 100.f));
    } else {
      renodx::tonemap::Config config = renodx::tonemap::config::Create();
      config.type = renodx::tonemap::config::type::RENODRT;
      config.peak_nits = RENODX_PEAK_WHITE_NITS;
      config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
      config.gamma_correction = RENODX_GAMMA_CORRECTION;
      config.exposure = RENODX_TONE_MAP_EXPOSURE;
      config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
      config.shadows = RENODX_TONE_MAP_SHADOWS;
      config.contrast = RENODX_TONE_MAP_CONTRAST;
      config.saturation = RENODX_TONE_MAP_SATURATION;
      config.mid_gray_nits = 18.f;
      config.reno_drt_highlights = 1.f;
      config.reno_drt_shadows = 1.f;
      config.reno_drt_contrast = 1.f;
      config.reno_drt_saturation = 1.f;
      config.reno_drt_dechroma = RENODX_TONE_MAP_DECHROMA;
      config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
      config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
      config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
      config.hue_correction_color = lerp(untonemapped, hue_correction_source, RENODX_TONE_MAP_HUE_SHIFT);
      config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
      config.reno_drt_blowout = RENODX_TONE_MAP_BLOWOUT;
      tonemapped = renodx::tonemap::config::Apply(untonemapped_graded, config);
    }
  }
  return tonemapped;
}

float3 ApplyFilmGrain(float3 color, float2 position) {
  if (CUSTOM_GRAIN_STRENGTH > 0.f && CUSTOM_GRAIN_TYPE != 0.f) {
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
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_PEAK_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color = ApplyToneMapAndGrain(color, position);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_PEAK_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color = ApplyToneMapAndGrain(color, position);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_PEAK_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 ScaleUiBrightness(float3 color) {
  const float ui_scale = RENODX_GRAPHICS_WHITE_NITS / RENODX_PEAK_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= ui_scale;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= ui_scale;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color *= ui_scale;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}
