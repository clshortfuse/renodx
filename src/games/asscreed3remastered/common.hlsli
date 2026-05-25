#include "./shared.h"
#define cmp -

static const float AC3R_NATIVE_DIFFUSE_WHITE_NITS = 203.f;

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
#if 0
  // const float highlights = 1 + (sign(config.highlights - 1) * pow(abs(config.highlights - 1), 10.f));
  // float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);
#else
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
#endif
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

renodx::color::grade::Config CreateColorGradeConfig() {
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

  return cg_config;
}

float3 GamutCompressBT2020(float3 color_bt2020) {
  float grayscale = renodx::color::y::from::BT2020(color_bt2020);

  const float MID_GRAY_LINEAR = 1 / (pow(10, 0.75));                          // ~0.18f
  const float MID_GRAY_PERCENT = 0.5f;                                        // 50%
  const float MID_GRAY_GAMMA = log(MID_GRAY_LINEAR) / log(MID_GRAY_PERCENT);  // ~2.49f
  float encode_gamma = MID_GRAY_GAMMA;

  float3 encoded = renodx::color::gamma::EncodeSafe(color_bt2020, encode_gamma);
  float encoded_gray = renodx::color::gamma::Encode(grayscale, encode_gamma);

  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray);
  float3 color_bt2020_compressed = renodx::color::gamma::DecodeSafe(compressed, encode_gamma);

  return color_bt2020_compressed;
}

float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits, float tone_map_type = 1.f) {
  // set up ACES parameters
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));  // apply RRT

  // custom grading
  renodx::color::grade::Config cg_config = CreateColorGradeConfig();
  float y = renodx::color::y::from::AP1(untonemapped_ap1);
  untonemapped_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, y, cg_config);

  float3 tonemapped_bt709;
  if (tone_map_type == 2.f) {  // regular ACES with gamma correction

#if RENODX_GAME_GAMMA_CORRECTION
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
#endif

    float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;
    tonemapped_ap1 = max(0, tonemapped_ap1);
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

#if RENODX_GAME_GAMMA_CORRECTION
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif
  } else {  // customized version of ACES, by luminance for midtones and shadows and per-channel for highlights, lowers min nits instead of 2.2 emulation
#if RENODX_GAME_GAMMA_CORRECTION
    aces_min /= 5.f;
#endif

    renodx::tonemap::aces::ODTConfig ODT_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);

    // luminance tonemap
    float y_in = renodx::color::y::from::AP1(untonemapped_ap1);
    float y_out = renodx::tonemap::aces::ODTToneMap(y_in, ODT_config) / 48.f;
    float3 tonemapped_lum_ap1 = (renodx::color::correct::Luminance(untonemapped_ap1, y_in, y_out));

    // per channel tonemap
    float3 tonemapped_perch_ap1 = (renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / 48.f);

    // blend luminance and per channel
    const float blending_ratio = renodx::color::y::from::AP1(tonemapped_lum_ap1);
    float3 tonemapped_ap1 = lerp(tonemapped_lum_ap1, tonemapped_perch_ap1, saturate(blending_ratio));  // take highlights from per channel

    // take chrominance from per channel
    tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
    float3 tonemapped_perch_bt709 = renodx::color::bt709::from::AP1(tonemapped_perch_ap1);
    tonemapped_bt709 = renodx::color::correct::Chrominance(tonemapped_bt709, tonemapped_perch_bt709);
    tonemapped_bt709 = renodx::color::bt709::clamp::AP1(tonemapped_bt709);
  }

  tonemapped_bt709 = ApplySaturationBlowoutHueCorrectionHighlightSaturation(tonemapped_bt709, renodx::color::bt709::from::AP1(untonemapped_ap1), y, cg_config);
  float3 tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);
  tonemapped_bt2020 = GamutCompressBT2020(tonemapped_bt2020);

  float3 pq_color = renodx::color::pq::EncodeSafe(tonemapped_bt2020, diffuse_white_nits);

  return pq_color;
}

float3 EncodeAC3RSceneIntermediate(float3 linear_ap1) {
  return renodx::color::srgb::EncodeSafe(linear_ap1);
}

float3 DecodeAC3RSceneIntermediate(float3 encoded_ap1) {
  return renodx::color::srgb::DecodeSafe(encoded_ap1);
}

float3 ApplyAC3RSceneColorGrade(float3 untonemapped_ap1) {
  renodx::color::grade::Config cg_config = CreateColorGradeConfig();
  float y = renodx::color::y::from::AP1(untonemapped_ap1);
  float3 graded_ap1 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, y, cg_config);
  graded_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(graded_ap1, untonemapped_ap1, y, cg_config);
  return max(0.f, graded_ap1);
}

float3 ApplyAC3RDisplayTransformToScRGB(float3 untonemapped_ap1) {
  const float diffuse_white_nits = AC3R_NATIVE_DIFFUSE_WHITE_NITS;
  const float peak_nits = max(RENODX_PEAK_WHITE_NITS, diffuse_white_nits);
  const float aces_min = 0.0001f / diffuse_white_nits;
  const float aces_max = peak_nits / diffuse_white_nits;

  float3 aces_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));
  renodx::tonemap::aces::ODTConfig odt_config = renodx::tonemap::aces::CreateODTConfig(aces_min * 48.f, aces_max * 48.f);
  float y_in = renodx::color::y::from::AP1(aces_ap1);
  float y_out = renodx::tonemap::aces::ODTToneMap(y_in, odt_config) / 48.f;
  float3 tonemapped_lum_ap1 = renodx::color::correct::Luminance(aces_ap1, y_in, y_out);
  float3 tonemapped_perch_ap1 = renodx::tonemap::aces::ODTToneMap(aces_ap1, odt_config) / 48.f;
  float blend = saturate(renodx::color::y::from::AP1(tonemapped_lum_ap1));
  float3 tonemapped_ap1 = lerp(tonemapped_lum_ap1, tonemapped_perch_ap1, blend);

  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(max(0.f, tonemapped_ap1));
  float3 tonemapped_perch_bt709 = renodx::color::bt709::from::AP1(max(0.f, tonemapped_perch_ap1));
  tonemapped_bt709 = renodx::color::correct::Chrominance(tonemapped_bt709, tonemapped_perch_bt709);
  tonemapped_bt709 = renodx::color::bt709::clamp::AP1(tonemapped_bt709);
  float3 tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);
  tonemapped_bt2020 = GamutCompressBT2020(tonemapped_bt2020);

  float3 bt2020_nits = tonemapped_bt2020 * diffuse_white_nits;
  float3 bt709_nits = renodx::color::bt709::from::BT2020(bt2020_nits);
  return bt709_nits / renodx::color::srgb::REFERENCE_WHITE;
}

float AC3RMax4(float a, float b, float c, float d) {
  return max(max(a, b), max(c, d));
}

float AC3RMin4(float a, float b, float c, float d) {
  return min(min(a, b), min(c, d));
}

float AC3RMax5(float a, float b, float c, float d, float e) {
  return max(AC3RMax4(a, b, c, d), e);
}

float AC3RMin5(float a, float b, float c, float d, float e) {
  return min(AC3RMin4(a, b, c, d), e);
}

float2 AC3RClampToTexelCenter(float2 uv, float2 texel_size) {
  return clamp(uv, texel_size * 0.5f, 1.f - texel_size * 0.5f);
}

float3 SampleAC3RDisplayScRGB(Texture2D<float4> scene_texture, SamplerState scene_sampler, float2 uv) {
  return ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, uv, 0).xyz));
}

float3 ApplyAC3RRCASScRGB(float3 center_color, float2 tex_coord, Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  if (CUSTOM_RCAS_STRENGTH <= 0.f) return center_color;

  uint width, height;
  scene_texture.GetDimensions(width, height);
  if (width == 0 || height == 0) return center_color;

  const float2 texel_size = rcp(float2(width, height));
  const float2 uv = AC3RClampToTexelCenter(tex_coord, texel_size);

  float3 b = SampleAC3RDisplayScRGB(scene_texture, scene_sampler, AC3RClampToTexelCenter(uv + float2(0.f, -1.f) * texel_size, texel_size));
  float3 d = SampleAC3RDisplayScRGB(scene_texture, scene_sampler, AC3RClampToTexelCenter(uv + float2(-1.f, 0.f) * texel_size, texel_size));
  float3 e = center_color;
  float3 f = SampleAC3RDisplayScRGB(scene_texture, scene_sampler, AC3RClampToTexelCenter(uv + float2(1.f, 0.f) * texel_size, texel_size));
  float3 h = SampleAC3RDisplayScRGB(scene_texture, scene_sampler, AC3RClampToTexelCenter(uv + float2(0.f, 1.f) * texel_size, texel_size));

  const float normalization_point = max(RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE, 1.f);
  b /= normalization_point;
  d /= normalization_point;
  e /= normalization_point;
  f /= normalization_point;
  h /= normalization_point;

  float b_luma = max(renodx::color::y::from::BT709(b), 0.f);
  float d_luma = max(renodx::color::y::from::BT709(d), 0.f);
  float e_luma = max(renodx::color::y::from::BT709(e), 0.f);
  float f_luma = max(renodx::color::y::from::BT709(f), 0.f);
  float h_luma = max(renodx::color::y::from::BT709(h), 0.f);

  if (e_luma <= 1e-6f) return center_color;

  float min_ring_luma = AC3RMin4(b_luma, d_luma, f_luma, h_luma);
  float max_ring_luma = AC3RMax4(b_luma, d_luma, f_luma, h_luma);
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
  float max_luma_2x = AC3RMax5(b_luma_2x, d_luma_2x, e_luma_2x, f_luma_2x, h_luma_2x);
  float min_luma_2x = AC3RMin5(b_luma_2x, d_luma_2x, e_luma_2x, f_luma_2x, h_luma_2x);
  noise = saturate(abs(noise) * rcp(max(max_luma_2x - min_luma_2x, 1e-6f)));
  lobe *= 1.f - 0.5f * noise;

  float rcp_lobe = rcp(4.f * lobe + 1.f);
  float sharpened_luma = ((b_luma + d_luma + f_luma + h_luma) * lobe + e_luma) * rcp_lobe;
  float luma_ratio = clamp(sharpened_luma / e_luma, 0.f, 4.f);

  return center_color * luma_ratio;
}

float3 ApplyAC3RFilmGrainScRGB(float3 color, float2 position) {
  if (CUSTOM_FILM_GRAIN_TYPE == 0.f || CUSTOM_FILM_GRAIN_STRENGTH <= 0.f) return color;

  return renodx::effects::ApplyFilmGrain(
      color,
      position,
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
      AC3R_NATIVE_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE);
}

float3 ApplyAC3RUIBrightness(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color;
  return color * (max(RENODX_GRAPHICS_WHITE_NITS, 1.f) / AC3R_NATIVE_DIFFUSE_WHITE_NITS);
}

float3 ApplyAC3RChromaticAberrationEncoded(float3 center_color, float2 tex_coord, Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  if (CUSTOM_CHROMATIC_ABERRATION_TYPE == 0.f || CUSTOM_CHROMATIC_ABERRATION_STRENGTH <= 0.f) return center_color;

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
  color.r = scene_texture.SampleLevel(scene_sampler, tex_coord + offset, 0).r;
  color.b = scene_texture.SampleLevel(scene_sampler, tex_coord - offset, 0).b;
  return max(0.f, color);
}

float3 ApplyAC3RBloom(float3 bloom_color, float3 bloom_tint) {
  float bloom_strength = RENODX_TONE_MAP_TYPE != 0.f ? CUSTOM_BLOOM_STRENGTH : 1.f;
  return bloom_color * bloom_tint * bloom_strength;
}

float3 SampleAC3RLUTBuilderResolved(
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture2D<float4> exposure_texture,
    SamplerState exposure_sampler,
    Texture2D<float4> bloom_texture,
    SamplerState bloom_sampler,
    Texture3D<float4> aces_lut,
    Texture3D<float4> aces_ldr_lut,
    Texture3D<float4> ldr_to_hdr_lut,
    SamplerState lut_sampler,
    float2 uv,
    float global_lighting_scale,
    float3 bloom_tint,
    float vignette,
    float use_aces_lut,
    float ldr_split) {
  float3 color = scene_texture.SampleLevel(scene_sampler, uv, 0).xyz;
  color *= global_lighting_scale;

  const float exposure = exposure_texture.SampleLevel(exposure_sampler, float2(0.f, 0.f), 0).x;
  const float3 bloom = ApplyAC3RBloom(bloom_texture.SampleLevel(bloom_sampler, uv, 0).xyz, bloom_tint);
  color = color * exposure + bloom;

  if (vignette != 0.f) {
    const float2 centered_uv = uv - 0.5f;
    float vignette_weight = max(0.f, 1.f - dot(centered_uv, centered_uv));
    vignette_weight = exp2(vignette * log2(vignette_weight));
    color *= vignette_weight;
  }

  float3 resolved = 0.f;
  if (use_aces_lut != 0.f) {
    float3 lut_uv = saturate(log2(color) * 0.0588235296f + 0.527878284f);
    lut_uv = lut_uv * 0.96875f + 0.015625f;
    resolved = aces_lut.SampleLevel(lut_sampler, lut_uv, 0).xyz;

    if (ldr_split != 0.f) {
      bool in_ldr_split = false;
      if (ldr_split > 0.f) {
        in_ldr_split = uv.x < ldr_split;
      } else {
        in_ldr_split = -ldr_split < uv.x;
      }

      if (in_ldr_split) {
        float3 ldr = aces_ldr_lut.SampleLevel(lut_sampler, lut_uv, 0).xyz;
        ldr = saturate(ldr) * 0.96875f + 0.015625f;
        resolved = ldr_to_hdr_lut.SampleLevel(lut_sampler, ldr, 0).xyz;
      }
    }
  } else {
    float3 denominator = color * 0.97709924f + 1.46564889f;
    color = saturate(color / denominator);
    float3 linear_segment = color * 12.9200001f;
    float3 gamma_segment = exp2(log2(color) * 0.416666657f) * 1.05499995f - 0.0549999997f;
    resolved = (0.00313080009f >= color) ? linear_segment : gamma_segment;
  }

  return resolved;
}

float3 ApplyAC3RLUTBuilderChromaticAberration(
    float3 center_color,
    float2 tex_coord,
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture2D<float4> exposure_texture,
    SamplerState exposure_sampler,
    Texture2D<float4> bloom_texture,
    SamplerState bloom_sampler,
    Texture3D<float4> aces_lut,
    Texture3D<float4> aces_ldr_lut,
    Texture3D<float4> ldr_to_hdr_lut,
    SamplerState lut_sampler,
    float global_lighting_scale,
    float3 bloom_tint,
    float vignette,
    float use_aces_lut,
    float ldr_split) {
  if (CUSTOM_CHROMATIC_ABERRATION_TYPE == 0.f || CUSTOM_CHROMATIC_ABERRATION_STRENGTH <= 0.f) return center_color;

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

  float3 positive_color = SampleAC3RLUTBuilderResolved(
      scene_texture, scene_sampler,
      exposure_texture, exposure_sampler,
      bloom_texture, bloom_sampler,
      aces_lut, aces_ldr_lut, ldr_to_hdr_lut, lut_sampler,
      tex_coord + offset,
      global_lighting_scale, bloom_tint, vignette, use_aces_lut, ldr_split);
  float3 negative_color = SampleAC3RLUTBuilderResolved(
      scene_texture, scene_sampler,
      exposure_texture, exposure_sampler,
      bloom_texture, bloom_sampler,
      aces_lut, aces_ldr_lut, ldr_to_hdr_lut, lut_sampler,
      tex_coord - offset,
      global_lighting_scale, bloom_tint, vignette, use_aces_lut, ldr_split);

  float3 color = center_color;
  color.r = positive_color.r;
  color.b = negative_color.b;
  return max(0.f, color);
}

float3 SampleAC3RLUTBuilderAcesResolved(
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture2D<float4> exposure_texture,
    SamplerState exposure_sampler,
    Texture2D<float4> bloom_texture,
    SamplerState bloom_sampler,
    Texture3D<float4> aces_lut,
    SamplerState lut_sampler,
    float2 uv,
    float global_lighting_scale,
    float3 bloom_tint,
    float vignette) {
  float2 centered_uv = uv - 0.5f;
  float vignette_weight = max(0.f, 1.f - dot(centered_uv, centered_uv));
  vignette_weight = exp2(vignette * log2(vignette_weight));

  float3 color = scene_texture.SampleLevel(scene_sampler, uv, 0).xyz;
  color *= global_lighting_scale;
  float3 bloom = ApplyAC3RBloom(bloom_texture.SampleLevel(bloom_sampler, uv, 0).xyz, bloom_tint);
  float exposure = exposure_texture.SampleLevel(exposure_sampler, float2(0.f, 0.f), 0).x;
  color = (color * exposure + bloom) * vignette_weight;

  float3 lut_uv = saturate(log2(color) * 0.0588235296f + 0.527878284f);
  lut_uv = lut_uv * 0.96875f + 0.015625f;
  return aces_lut.SampleLevel(lut_sampler, lut_uv, 0).xyz;
}

float3 ApplyAC3RLUTBuilderAcesChromaticAberration(
    float3 center_color,
    float2 tex_coord,
    Texture2D<float4> scene_texture,
    SamplerState scene_sampler,
    Texture2D<float4> exposure_texture,
    SamplerState exposure_sampler,
    Texture2D<float4> bloom_texture,
    SamplerState bloom_sampler,
    Texture3D<float4> aces_lut,
    SamplerState lut_sampler,
    float global_lighting_scale,
    float3 bloom_tint,
    float vignette) {
  if (CUSTOM_CHROMATIC_ABERRATION_TYPE == 0.f || CUSTOM_CHROMATIC_ABERRATION_STRENGTH <= 0.f) return center_color;

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

  float3 positive_color = SampleAC3RLUTBuilderAcesResolved(
      scene_texture, scene_sampler,
      exposure_texture, exposure_sampler,
      bloom_texture, bloom_sampler,
      aces_lut, lut_sampler,
      tex_coord + offset,
      global_lighting_scale, bloom_tint, vignette);
  float3 negative_color = SampleAC3RLUTBuilderAcesResolved(
      scene_texture, scene_sampler,
      exposure_texture, exposure_sampler,
      bloom_texture, bloom_sampler,
      aces_lut, lut_sampler,
      tex_coord - offset,
      global_lighting_scale, bloom_tint, vignette);

  float3 color = center_color;
  color.r = positive_color.r;
  color.b = negative_color.b;
  return max(0.f, color);
}

float3 NormalizeAC3RWhitePointScale(float3 white_point_scale) {
  const float white_scale = max(dot(white_point_scale, float3(0.333333343f, 0.333333343f, 0.333333343f)), 0.0001f);
  return white_point_scale / white_scale;
}

float GetAC3RWhitePointPaperWhiteNits(float3 white_point_scale) {
  const float white_scale = max(dot(white_point_scale, float3(0.333333343f, 0.333333343f, 0.333333343f)), 0.0001f);
  return AC3R_NATIVE_DIFFUSE_WHITE_NITS * white_scale;
}

float3 ApplyAC3RToneMapToScRGB(float3 untonemapped_ap1) {
  float3 pq_color = ApplyToneMapEncodePQ(
      untonemapped_ap1,
      max(RENODX_PEAK_WHITE_NITS, AC3R_NATIVE_DIFFUSE_WHITE_NITS),
      AC3R_NATIVE_DIFFUSE_WHITE_NITS,
      RENODX_TONE_MAP_TYPE);

  float3 bt2020_nits = renodx::color::pq::DecodeSafe(pq_color, 1.f);
  float3 bt709_nits = renodx::color::bt709::from::BT2020(bt2020_nits);
  return bt709_nits / renodx::color::srgb::REFERENCE_WHITE;
}

float CalculatePaperWhiteExposureCompensation(float paper_white) {
  float x = paper_white;
  float exposure = 0.3849059f
                   - 0.0007877044f * x
                   + 5.215512e-7f * x * x;
  return lerp(1.0f, exposure, CUSTOM_EXPOSURE_COMPENSATION);
}

float CalculatePaperWhiteContrastCompensation(float paper_white) {
  float contrast = mad(-0.0002f, paper_white, 0.92f);
  return lerp(1.0f, contrast, CUSTOM_CONTRAST_COMPENSATION);
}
