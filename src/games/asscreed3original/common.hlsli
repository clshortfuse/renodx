#include "./shared.h"

float ComputeMaxChCompressionScale(float3 untonemapped) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::Neutwo(peak);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = renodx::math::Average(mid_gray_gamma);

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = renodx::math::Max(neutral_gamma);
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 Sample(Texture3D<float4> lut_texture, renodx::lut::Config lut_config, float3 color_input) {
  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);

    float lutBlackY = renodx::color::y::from::BT709(renodx::lut::LinearOutput(lutBlack, lut_config));

    if (lutBlackY > 0.f) {
      float lutMidInput = (lutBlackY + 0.04f) / 2.f;  // hand-tuned to target shadows more
      float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lutMidInput, lut_config), lut_config, lut_texture);
      float3 lutWhite = 1.f;
      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lutOutputColor, lut_config),
          renodx::lut::GammaOutput(lutBlack, lut_config),
          renodx::lut::GammaOutput(lutMid, lut_config),
          renodx::lut::GammaInput(color_input, lutInputColor, lut_config));
      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  return lerp(color_input, color_output, lut_config.strength);
}

renodx::lut::Config CreateLUTConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = RENODX_COLOR_GRADE_STRENGTH;
  lut_config.scaling = RENODX_COLOR_GRADE_SCALING;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  lut_config.size = 16u;
  lut_config.tetrahedral = true;
  lut_config.max_channel = 0.f;
  lut_config.gamut_compress = 0.f;
  return lut_config;
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
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
    RENODX_TONE_MAP_HUE_SHIFT,                            // float hue_emulation_strength;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    RENODX_TONE_MAP_BLOWOUT                               // float blowout;
  };
  return cg_config;
}

float3 DecodeIntermediateForToneMap(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    return renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    return renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else {
    return renodx::color::srgb::DecodeSafe(color);
  }
}

float GetNeutwoWhiteClip(float peak) {
  return max(RENODX_TONE_MAP_WHITE_CLIP, peak + 0.001f);
}

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

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, UserGradingConfig config, float mid_gray = 0.18f) {
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

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config, bool clamp_to_ap1 = true) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_emulation_strength != 0.f || config.blowout != 0.f || config.highlight_saturation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue emulation and blowout
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

    // dechroma
    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    // highlight saturation
    if (config.highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
      if (config.highlight_saturation < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    // saturation
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
    // set up grading config
    const UserGradingConfig cg_config = CreateColorGradeConfig();
    float3 hue_correction_source = untonemapped;
    const float y = renodx::color::y::from::BT709(untonemapped);

    float3 untonemapped_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, cg_config);
    if (RENODX_TONE_MAP_HUE_SHIFT > 0.f || RENODX_TONE_MAP_BLOWOUT > 0.f) {
      const float hue_reference_peak = 8.f;
      const float hue_reference_white_clip = GetNeutwoWhiteClip(hue_reference_peak);
      hue_correction_source = renodx::tonemap::neutwo::PerChannel(untonemapped, hue_reference_peak, hue_reference_white_clip);
    }
    untonemapped_graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(untonemapped_graded, hue_correction_source, y, cg_config);

    if (RENODX_TONE_MAP_TYPE == 1.f) {
      tonemapped = untonemapped_graded;
    } else {
      const float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      const float white_clip = GetNeutwoWhiteClip(peak);
      tonemapped = renodx::color::bt709::from::BT2020(
          renodx::tonemap::neutwo::MaxChannel(
              renodx::color::bt2020::from::BT709(untonemapped_graded), peak, white_clip));
    }
  }
  return tonemapped;
}

float3 ToneMapAndRenderIntermediatePass(float3 color, float2 position) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color = ApplyToneMap(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color = ApplyToneMap(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color = ApplyToneMap(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float AC3OMax4(float a, float b, float c, float d) {
  return max(max(a, b), max(c, d));
}

float AC3OMin4(float a, float b, float c, float d) {
  return min(min(a, b), min(c, d));
}

float AC3OMax5(float a, float b, float c, float d, float e) {
  return max(AC3OMax4(a, b, c, d), e);
}

float AC3OMin5(float a, float b, float c, float d, float e) {
  return min(AC3OMin4(a, b, c, d), e);
}

float2 AC3OClampToTexelCenter(float2 uv, float2 texel_size) {
  return clamp(uv, texel_size * 0.5f, 1.f - texel_size * 0.5f);
}

float3 SampleAC3OToneMappedLUT(
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture3D<float4> lut_texture,
    SamplerState lut_sampler,
    float2 uv,
    float3 pre_lut_scale,
    float3 pre_lut_offset) {
  uint width, height;
  scene_texture.GetDimensions(width, height);
  if (width == 0 || height == 0) return 0.f;

  const float2 texel_size = rcp(float2(width, height));
  uv = AC3OClampToTexelCenter(uv, texel_size);

  float3 input = scene_texture.SampleLevel(scene_sampler, uv, 0).rgb;
  float3 untonemapped_gamma = (((input * pre_lut_scale + pre_lut_offset) - 0.03125f) / 0.9375f);
  float3 untonemapped = DecodeIntermediateForToneMap(untonemapped_gamma);

  renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
  const float compression_scale = ComputeMaxChCompressionScale(untonemapped);

  const float3 color_sdr = untonemapped * compression_scale;
  const float3 color_sdr_graded = Sample(lut_texture, lut_config, color_sdr);
  float3 color_final = color_sdr_graded / max(compression_scale, 1e-6f);

  color_final = renodx::color::gamma::EncodeSafe(color_final, 2.2f);
  return ToneMapAndRenderIntermediatePass(color_final, uv);
}

float3 ApplyAC3ORCAS(
    float3 center_color,
    float2 tex_coord,
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture3D<float4> lut_texture,
    SamplerState lut_sampler,
    float3 pre_lut_scale,
    float3 pre_lut_offset) {
  if (RENODX_TONE_MAP_TYPE == 0.f || CUSTOM_RCAS_STRENGTH <= 0.f) return center_color;

  uint width, height;
  scene_texture.GetDimensions(width, height);
  if (width == 0 || height == 0) return center_color;

  const float2 texel_size = rcp(float2(width, height));
  const float2 uv = AC3OClampToTexelCenter(tex_coord, texel_size);

  float3 b = SampleAC3OToneMappedLUT(scene_texture, scene_sampler, lut_texture, lut_sampler, uv + float2(0.f, -1.f) * texel_size, pre_lut_scale, pre_lut_offset);
  float3 d = SampleAC3OToneMappedLUT(scene_texture, scene_sampler, lut_texture, lut_sampler, uv + float2(-1.f, 0.f) * texel_size, pre_lut_scale, pre_lut_offset);
  float3 e = center_color;
  float3 f = SampleAC3OToneMappedLUT(scene_texture, scene_sampler, lut_texture, lut_sampler, uv + float2(1.f, 0.f) * texel_size, pre_lut_scale, pre_lut_offset);
  float3 h = SampleAC3OToneMappedLUT(scene_texture, scene_sampler, lut_texture, lut_sampler, uv + float2(0.f, 1.f) * texel_size, pre_lut_scale, pre_lut_offset);

  float b_luma = max(renodx::color::y::from::BT709(b), 0.f);
  float d_luma = max(renodx::color::y::from::BT709(d), 0.f);
  float e_luma = max(renodx::color::y::from::BT709(e), 0.f);
  float f_luma = max(renodx::color::y::from::BT709(f), 0.f);
  float h_luma = max(renodx::color::y::from::BT709(h), 0.f);

  if (e_luma <= 1e-6f) return center_color;

  float min_ring_luma = AC3OMin4(b_luma, d_luma, f_luma, h_luma);
  float max_ring_luma = AC3OMax4(b_luma, d_luma, f_luma, h_luma);
  float limited_max_ring_luma = min(max(max_ring_luma, 1e-6f), 0.99f);
  float limited_min_ring_luma = max(min_ring_luma, 1e-6f);

  float hit_min_luma = limited_min_ring_luma * rcp(4.f * limited_max_ring_luma);
  float hit_max_luma = (1.f - limited_max_ring_luma) * rcp(4.f * limited_min_ring_luma - 4.f);
  float local_lobe = max(-hit_min_luma, hit_max_luma);

  const float rcas_limit = 0.1875f;
  float lobe = max(-rcas_limit, min(local_lobe, 0.f)) * CUSTOM_RCAS_STRENGTH;

  float b_luma_2x = b_luma * 2.f;
  float d_luma_2x = d_luma * 2.f;
  float e_luma_2x = e_luma * 2.f;
  float f_luma_2x = f_luma * 2.f;
  float h_luma_2x = h_luma * 2.f;
  float noise = 0.25f * (b_luma_2x + d_luma_2x + f_luma_2x + h_luma_2x) - e_luma_2x;
  float max_luma_2x = AC3OMax5(b_luma_2x, d_luma_2x, e_luma_2x, f_luma_2x, h_luma_2x);
  float min_luma_2x = AC3OMin5(b_luma_2x, d_luma_2x, e_luma_2x, f_luma_2x, h_luma_2x);
  noise = saturate(abs(noise) * rcp(max(max_luma_2x - min_luma_2x, 1e-6f)));
  lobe *= 1.f - 0.5f * noise;

  float rcp_lobe = rcp(4.f * lobe + 1.f);
  float sharpened_luma = ((b_luma + d_luma + f_luma + h_luma) * lobe + e_luma) * rcp_lobe;
  float luma_ratio = clamp(sharpened_luma / e_luma, 0.f, 4.f);

  return center_color * luma_ratio;
}

float3 ApplyAC3OFilmGrain(float3 color, float2 position) {
  if (RENODX_TONE_MAP_TYPE == 0.f || CUSTOM_FILM_GRAIN_TYPE == 0.f || CUSTOM_FILM_GRAIN_STRENGTH <= 0.f) return color;

  return renodx::effects::ApplyFilmGrain(
      color,
      position,
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
}

float3 ApplyAC3OChromaticAberration(
    float3 center_color,
    float2 tex_coord,
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture3D<float4> lut_texture,
    SamplerState lut_sampler,
    float3 pre_lut_scale,
    float3 pre_lut_offset) {
  if (RENODX_TONE_MAP_TYPE == 0.f || CUSTOM_CHROMATIC_ABERRATION_TYPE == 0.f || CUSTOM_CHROMATIC_ABERRATION_STRENGTH <= 0.f) return center_color;

  uint width, height;
  scene_texture.GetDimensions(width, height);
  if (width == 0 || height == 0) return center_color;

  const float2 dimensions = float2(width, height);
  const float2 texel_size = rcp(dimensions);
  float2 pixel_from_center = (tex_coord - 0.5f) * dimensions;
  float distance_from_center = length(pixel_from_center);
  if (distance_from_center <= 1e-4f) return center_color;

  float edge_distance = saturate(distance_from_center / (0.5f * length(dimensions)));
  float edge_weight = smoothstep(0.15f, 1.f, edge_distance);
  edge_weight *= edge_weight;

  float2 screen_edge_distance = abs(tex_coord * 2.f - 1.f);
  float axial_edge_weight = smoothstep(0.55f, 1.f, max(screen_edge_distance.x, screen_edge_distance.y)) * 0.35f;
  edge_weight = max(edge_weight, axial_edge_weight);

  float2 direction = pixel_from_center / distance_from_center;
  float desired_offset_pixels = CUSTOM_CHROMATIC_ABERRATION_STRENGTH * 9.f * edge_weight;
  float2 edge_room_pixels = min(tex_coord, 1.f - tex_coord) * dimensions;
  float2 safe_offset_pixels_xy = edge_room_pixels / max(abs(direction), 1e-4f);
  float safe_offset_pixels = max(0.f, min(safe_offset_pixels_xy.x, safe_offset_pixels_xy.y) - 1.f);
  float offset_pixels = min(desired_offset_pixels, safe_offset_pixels);
  float2 offset = direction * texel_size * offset_pixels;

  float3 color = center_color;
  color.r = SampleAC3OToneMappedLUT(scene_texture, scene_sampler, lut_texture, lut_sampler, tex_coord + offset, pre_lut_scale, pre_lut_offset).r;
  color.b = SampleAC3OToneMappedLUT(scene_texture, scene_sampler, lut_texture, lut_sampler, tex_coord - offset, pre_lut_scale, pre_lut_offset).b;
  return color;
}

float3 ApplyAC3OPostProcess(
    float3 color,
    float2 tex_coord,
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture3D<float4> lut_texture,
    SamplerState lut_sampler,
    float3 pre_lut_scale,
    float3 pre_lut_offset) {
  color = ApplyAC3ORCAS(color, tex_coord, scene_texture, scene_sampler, lut_texture, lut_sampler, pre_lut_scale, pre_lut_offset);
  color = ApplyAC3OFilmGrain(color, tex_coord);
  color = ApplyAC3OChromaticAberration(color, tex_coord, scene_texture, scene_sampler, lut_texture, lut_sampler, pre_lut_scale, pre_lut_offset);
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

float3 ClampIntermediatePass(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = saturate(color);
  } else if (RENODX_TONE_MAP_TYPE >= 2.f) {
    color = min(color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  }
  return color;
}

float3 ClampAndRenderIntermediatePass(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color = ClampIntermediatePass(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color = ClampIntermediatePass(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
    color = ClampIntermediatePass(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}
