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

float3 ApplyAC3RUIBrightness(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color;
  return color * (max(RENODX_GRAPHICS_WHITE_NITS, 1.f) / AC3R_NATIVE_DIFFUSE_WHITE_NITS);
}

float3 ApplyAC3RFilmGrain(float3 color, float2 position) {
  if (CUSTOM_FILM_GRAIN_TYPE == 0.f || CUSTOM_FILM_GRAIN_STRENGTH <= 0.f) return color;

  return renodx::effects::ApplyFilmGrain(
      color,
      position,
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
      AC3R_NATIVE_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE);
}

float3 ApplyAC3RFilmGrainEncoded(float3 encoded_color, float2 position) {
  if (CUSTOM_FILM_GRAIN_TYPE == 0.f || CUSTOM_FILM_GRAIN_STRENGTH <= 0.f) return encoded_color;

  float3 linear_ap1 = DecodeAC3RSceneIntermediate(encoded_color);
  linear_ap1 = renodx::effects::ApplyFilmGrain(
      linear_ap1,
      position,
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
      AC3R_NATIVE_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE);

  return EncodeAC3RSceneIntermediate(max(0.f, linear_ap1));
}

float AC3RMax4(float a, float b, float c, float d) {
  return max(max(a, b), max(c, d));
}

float AC3RMin4(float a, float b, float c, float d) {
  return min(min(a, b), min(c, d));
}

float2 AC3RClampUVToTexelCenter(float2 tex_coord, float2 texel_size) {
  return clamp(tex_coord, texel_size * 0.5f, 1.f - texel_size * 0.5f);
}

float3 ApplyAC3RRCAS(float3 center_color, float2 tex_coord, Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  if (CUSTOM_RCAS_STRENGTH <= 0.f) return center_color;

  uint width, height;
  scene_texture.GetDimensions(width, height);
  if (width == 0 || height == 0) return center_color;

  const float2 texel_size = rcp(float2(width, height));

  float3 b = ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(0.f, -1.f) * texel_size, texel_size), 0).rgb));
  float3 d = ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(-1.f, 0.f) * texel_size, texel_size), 0).rgb));
  float3 e = center_color;
  float3 f = ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(1.f, 0.f) * texel_size, texel_size), 0).rgb));
  float3 h = ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(0.f, 1.f) * texel_size, texel_size), 0).rgb));

  const float normalization_point = AC3R_NATIVE_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;
  b /= normalization_point;
  d /= normalization_point;
  e /= normalization_point;
  f /= normalization_point;
  h /= normalization_point;

  float b_lum = renodx::color::y::from::BT709(b);
  float d_lum = renodx::color::y::from::BT709(d);
  float e_lum = max(renodx::color::y::from::BT709(e), 1e-6f);
  float f_lum = renodx::color::y::from::BT709(f);
  float h_lum = renodx::color::y::from::BT709(h);

  float min_lum = max(AC3RMin4(b_lum, d_lum, f_lum, h_lum), 1e-6f);
  float max_lum = AC3RMax4(b_lum, d_lum, f_lum, h_lum);
  float limited_max_lum = min(max_lum, 0.99f);

  float hit_min = min_lum * rcp(4.f * limited_max_lum + 1e-6f);
  float hit_max = (1.f - limited_max_lum) * rcp(4.f * min_lum - 4.f);
  float local_lobe = max(-hit_min, hit_max);

  static const float FSR_RCAS_LIMIT = 0.1875f;
  float lobe = max(-FSR_RCAS_LIMIT, min(local_lobe, 0.f)) * CUSTOM_RCAS_STRENGTH;

  float b_lum_2x = b_lum * 2.f;
  float d_lum_2x = d_lum * 2.f;
  float e_lum_2x = e_lum * 2.f;
  float f_lum_2x = f_lum * 2.f;
  float h_lum_2x = h_lum * 2.f;
  float noise = 0.25f * (b_lum_2x + d_lum_2x + f_lum_2x + h_lum_2x) - e_lum_2x;
  float max_lum_2x = max(AC3RMax4(b_lum_2x, d_lum_2x, f_lum_2x, h_lum_2x), e_lum_2x);
  float min_lum_2x = min(AC3RMin4(b_lum_2x, d_lum_2x, f_lum_2x, h_lum_2x), e_lum_2x);
  noise = saturate(abs(noise) * rcp(max_lum_2x - min_lum_2x + 1e-6f));
  lobe *= (-0.5f * noise + 1.f);

  float rcp_lobe = rcp(4.f * lobe + 1.f);
  float sharpened_lum = ((b_lum + d_lum + h_lum + f_lum) * lobe + e_lum) * rcp_lobe;
  float3 sharpened = clamp(sharpened_lum / e_lum, 0.f, 4.f) * e;

  return max(0.f, sharpened * normalization_point);
}

float3 ApplyAC3RRCASEncoded(float3 center_color, float2 tex_coord, Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  if (CUSTOM_RCAS_STRENGTH <= 0.f) return center_color;

  uint width, height;
  scene_texture.GetDimensions(width, height);
  if (width == 0 || height == 0) return center_color;

  const float2 texel_size = rcp(float2(width, height));

  float3 b = DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(0.f, -1.f) * texel_size, texel_size), 0).rgb);
  float3 d = DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(-1.f, 0.f) * texel_size, texel_size), 0).rgb);
  float3 e = DecodeAC3RSceneIntermediate(center_color);
  float3 f = DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(1.f, 0.f) * texel_size, texel_size), 0).rgb);
  float3 h = DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, AC3RClampUVToTexelCenter(tex_coord + float2(0.f, 1.f) * texel_size, texel_size), 0).rgb);

  float b_lum = renodx::color::y::from::AP1(b);
  float d_lum = renodx::color::y::from::AP1(d);
  float e_lum = max(renodx::color::y::from::AP1(e), 1e-6f);
  float f_lum = renodx::color::y::from::AP1(f);
  float h_lum = renodx::color::y::from::AP1(h);

  float min_lum = max(AC3RMin4(b_lum, d_lum, f_lum, h_lum), 1e-6f);
  float max_lum = AC3RMax4(b_lum, d_lum, f_lum, h_lum);
  float limited_max_lum = min(max_lum, 0.99f);

  float hit_min = min_lum * rcp(4.f * limited_max_lum + 1e-6f);
  float hit_max = (1.f - limited_max_lum) * rcp(4.f * min_lum - 4.f);
  float local_lobe = max(-hit_min, hit_max);

  static const float FSR_RCAS_LIMIT = 0.1875f;
  float lobe = max(-FSR_RCAS_LIMIT, min(local_lobe, 0.f)) * CUSTOM_RCAS_STRENGTH;

  float b_lum_2x = b_lum * 2.f;
  float d_lum_2x = d_lum * 2.f;
  float e_lum_2x = e_lum * 2.f;
  float f_lum_2x = f_lum * 2.f;
  float h_lum_2x = h_lum * 2.f;
  float noise = 0.25f * (b_lum_2x + d_lum_2x + f_lum_2x + h_lum_2x) - e_lum_2x;
  float max_lum_2x = max(AC3RMax4(b_lum_2x, d_lum_2x, f_lum_2x, h_lum_2x), e_lum_2x);
  float min_lum_2x = min(AC3RMin4(b_lum_2x, d_lum_2x, f_lum_2x, h_lum_2x), e_lum_2x);
  noise = saturate(abs(noise) * rcp(max_lum_2x - min_lum_2x + 1e-6f));
  lobe *= (-0.5f * noise + 1.f);

  float rcp_lobe = rcp(4.f * lobe + 1.f);
  float sharpened_lum = ((b_lum + d_lum + h_lum + f_lum) * lobe + e_lum) * rcp_lobe;
  float3 sharpened = clamp(sharpened_lum / e_lum, 0.f, 4.f) * e;

  return EncodeAC3RSceneIntermediate(max(0.f, sharpened));
}

float3 ApplyAC3RChromaticAberration(float3 center_color, float2 tex_coord, Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  if (CUSTOM_CHROMATIC_ABERRATION_STRENGTH <= 0.f) return center_color;

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

  float3 red_sample = ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, tex_coord + offset, 0).rgb));
  float3 blue_sample = ApplyAC3RDisplayTransformToScRGB(DecodeAC3RSceneIntermediate(scene_texture.SampleLevel(scene_sampler, tex_coord - offset, 0).rgb));

  float3 color = center_color;
  color.r = red_sample.r;
  color.b = blue_sample.b;
  return max(0.f, color);
}

float3 ApplyAC3RChromaticAberrationEncoded(float3 center_color, float2 tex_coord, Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  if (CUSTOM_CHROMATIC_ABERRATION_STRENGTH <= 0.f) return center_color;

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

float3 ApplyAC3RScenePostEffectsEncoded(float3 center_color, float2 tex_coord, Texture2D<float4> scene_texture, SamplerState scene_sampler) {
  float3 processed_center = ApplyAC3RRCASEncoded(center_color, tex_coord, scene_texture, scene_sampler);
  processed_center = ApplyAC3RFilmGrainEncoded(processed_center, tex_coord);

  if (CUSTOM_CHROMATIC_ABERRATION_STRENGTH <= 0.f) return processed_center;

  uint width, height;
  scene_texture.GetDimensions(width, height);
  if (width == 0 || height == 0) return processed_center;

  const float2 dimensions = float2(width, height);
  const float2 texel_size = rcp(dimensions);
  float2 pixel_from_center = (tex_coord - 0.5f) * dimensions;
  float distance_from_center = length(pixel_from_center);
  if (distance_from_center <= 1e-4f) return processed_center;

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

  float2 red_uv = AC3RClampUVToTexelCenter(tex_coord + offset, texel_size);
  float2 blue_uv = AC3RClampUVToTexelCenter(tex_coord - offset, texel_size);
  float3 red_color = scene_texture.SampleLevel(scene_sampler, red_uv, 0).rgb;
  float3 blue_color = scene_texture.SampleLevel(scene_sampler, blue_uv, 0).rgb;
  red_color = ApplyAC3RRCASEncoded(red_color, red_uv, scene_texture, scene_sampler);
  blue_color = ApplyAC3RRCASEncoded(blue_color, blue_uv, scene_texture, scene_sampler);
  red_color = ApplyAC3RFilmGrainEncoded(red_color, red_uv);
  blue_color = ApplyAC3RFilmGrainEncoded(blue_color, blue_uv);

  float3 color = processed_center;
  color.r = red_color.r;
  color.b = blue_color.b;
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
