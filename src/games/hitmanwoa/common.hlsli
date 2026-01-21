#include "./shared.h"
#include "./tonemap.hlsli"

float3 GammaCorrectByLuminance(float3 color, bool pow_to_srgb = false) {
  float y_in = renodx::color::y::from::BT709(color);
  float y_out = renodx::color::correct::Gamma(y_in, pow_to_srgb);

  color = renodx::color::correct::Luminance(color, y_in, y_out);

  return color;
}

float4 Sample2DPackedLUT(float3 srgb_color, SamplerState lut_sampler, Texture2D<float4> lut_tex) {
  if (RENODX_LUT_SAMPLING_TYPE) {
    srgb_color = srgb_color * 0.984375f + 0.0078125f;  // add missing offsets
  }

  if (CUSTOM_LUT_TETRAHEDRAL) {
    const uint size = 16u;
    const uint tile_size = 16u;
    const float max_index = (float)(size - 1u);
  
    float3 coordinates = saturate(srgb_color) * max_index;
    int3 point0 = (int3)floor(coordinates);
    point0 = min(point0, int3((int)size - 2, (int)size - 2, (int)size - 2));
  
    float3 fraction = coordinates - (float3)point0;
  
    int3 offset0 = int3(0, 0, 0);
    int3 offset1 = int3(0, 0, 0);
    int3 offset2 = int3(1, 1, 1);
    int3 offset3 = int3(1, 1, 1);
  
    float3 sorted;
    if (fraction.r > fraction.g) {
      if (fraction.g > fraction.b) {
        offset1.r = 1;
        offset2.b = 0;
        sorted = fraction.rgb;
      } else if (fraction.r > fraction.b) {
        offset1.r = 1;
        offset2.g = 0;
        sorted = fraction.rbg;
      } else {
        offset1.b = 1;
        offset2.g = 0;
        sorted = fraction.brg;
      }
    } else {
      if (fraction.g <= fraction.b) {
        offset1.b = 1;
        offset2.r = 0;
        sorted = fraction.bgr;
      } else if (fraction.r >= fraction.b) {
        offset1.g = 1;
        offset2.b = 0;
        sorted = fraction.grb;
      } else {
        offset1.g = 1;
        offset2.r = 0;
        sorted = fraction.gbr;
      }
    }
  
    int3 point1 = point0 + offset1;
    int3 point2 = point0 + offset2;
    int3 point3 = point0 + offset3;
  
    uint2 tile0 = uint2((uint)point0.z & 3u, (uint)point0.z >> 2);
    uint2 tile1 = uint2((uint)point1.z & 3u, (uint)point1.z >> 2);
    uint2 tile2 = uint2((uint)point2.z & 3u, (uint)point2.z >> 2);
    uint2 tile3 = uint2((uint)point3.z & 3u, (uint)point3.z >> 2);
  
    uint2 uv0 = uint2(tile0 * tile_size) + uint2((uint)point0.x, (uint)point0.y);
    uint2 uv1 = uint2(tile1 * tile_size) + uint2((uint)point1.x, (uint)point1.y);
    uint2 uv2 = uint2(tile2 * tile_size) + uint2((uint)point2.x, (uint)point2.y);
    uint2 uv3 = uint2(tile3 * tile_size) + uint2((uint)point3.x, (uint)point3.y);
  
    float4 texel0 = lut_tex.Load(int3(uv0, 0));
    float4 texel1 = lut_tex.Load(int3(uv1, 0));
    float4 texel2 = lut_tex.Load(int3(uv2, 0));
    float4 texel3 = lut_tex.Load(int3(uv3, 0));
  
    float weight0 = 1.f - sorted[0];
    float weight1 = sorted[0] - sorted[1];
    float weight2 = sorted[1] - sorted[2];
    float weight3 = sorted[2];
  
    float4 value0 = texel0 * weight0;
    float4 value1 = texel1 * weight1;
    float4 value2 = texel2 * weight2;
    float4 value3 = texel3 * weight3;

    return value0 + value1 + value2 + value3;
  } else {
    // Convert sRGB color to 3D LUT index space (0–15)
    float3 lut_coord = srgb_color * 15.f;

    // Blue channel determines which 2D tile slice (Z axis)
    float lut_b = lut_coord.b;
    uint b_index = (uint)lut_b;
    uint b_index_next = b_index + 1u;
    float b_frac = lut_b - float(b_index);  // interpolation weight between slices

    // Red and green determine position within each 2D tile (X and Y axes)
    float lut_r = lut_coord.r + 0.5f;
    float lut_g = lut_coord.g + 0.5f;

    // Compute 4×4 tile grid index for blue slices (tiles of size 16x16)
    int2 tile_a = int2(b_index & 3, b_index >> 2);
    int2 tile_b = int2(b_index_next & 3, b_index_next >> 2);

    // Get UVs inside the 64×64 packed LUT texture
    float2 uv_a = (float2(tile_a * 16) + float2(lut_r, lut_g)) / 64.f;
    float2 uv_b = (float2(tile_b * 16) + float2(lut_r, lut_g)) / 64.f;

    // Trilinear interpolation between adjacent blue slices
    float4 lut_slice_low = lut_tex.SampleLevel(lut_sampler, uv_a, 0.f);
    float4 lut_slice_high = lut_tex.SampleLevel(lut_sampler, uv_b, 0.f);
    float4 lut_sample = lerp(lut_slice_low, lut_slice_high, b_frac);

    return lut_sample;
  }
}

float4 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DPackedLUT(srgb_input, lut_sampler, lut_texture);

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = 0.f;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;
  lut_config.gamut_compress = LUT_GAMUT_RESTORATION;
  lut_config.max_channel = 0.f;

  float3 lutInputColor = srgb_input;
  float3 lutOutputColor = lut_sample.rgb;
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color_output = GammaCorrectByLuminance(color_output);
  }

  color_output = renodx::color::srgb::Encode(max(0, color_output));

  lut_sample.rgb = color_output.rgb;

  return lut_sample;
}

float4 SampleLUTSRGBInLinearOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DPackedLUT(srgb_input, lut_sampler, lut_texture);

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = 0.f;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.recolor = 0.f;
  lut_config.gamut_compress = LUT_GAMUT_RESTORATION;
  lut_config.max_channel = 0.f;

  float3 lutInputColor = srgb_input;
  float3 lutOutputColor = lut_sample.rgb;
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color_output = GammaCorrectByLuminance(color_output);
  }

  lut_sample.rgb = color_output.rgb;

  return lut_sample;
}

float3 ScaleBloom(float3 color_scene, float3 tex_bloom, float bloom_strength) {
  float3 bloom_color = bloom_strength * tex_bloom;

  if (bloom_strength > 0.f && CUSTOM_BLOOM_SCALING > 0.f && CUSTOM_BLOOM > 0.f) {
    float mid_gray_bloomed = (0.18 + renodx::color::y::from::BT709(bloom_color)) / 0.18;

    float scene_luminance = renodx::color::y::from::BT709(color_scene) * mid_gray_bloomed;
    float bloom_blend = saturate(smoothstep(0.f, 0.05f, scene_luminance));
    float3 bloom_scaled = lerp(0.f, bloom_color, bloom_blend);
    bloom_scaled = lerp(bloom_color, bloom_scaled, CUSTOM_BLOOM_SCALING * BLOOM_SCALING_MAX);

    bloom_color = lerp(bloom_scaled, bloom_color, saturate(renodx::color::y::from::BT709(bloom_scaled) / 0.18f));
  }
  return CUSTOM_BLOOM * bloom_color + color_scene;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.18f, float output_max = 1.f, float channel_max = 100.f) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, channel_max, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

renodx::lut::Config CreateLUTConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = RENODX_COLOR_GRADE_SCALING;  // handle inside lutbuilder
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 16u;
  lut_config.recolor = 0.f;
  lut_config.gamut_compress = 1.f;
  return lut_config;
}

float3 SampleLUTWithScaling(Texture3D<float4> lut_texture, renodx::lut::Config lut_config, float3 color_input) {
  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(0.18f, lut_config), lut_config, lut_texture);

    float3 unclamped_gamma = renodx::lut::Unclamp(
        renodx::lut::GammaOutput(lutOutputColor, lut_config),
        renodx::lut::GammaOutput(lutBlack, lut_config),
        renodx::lut::GammaOutput(lutMid, lut_config),
        1.f,  // don't scale white (breaks mission intro fades)
        renodx::lut::GammaInput(color_input, lutInputColor, lut_config));
    float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
    float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
    color_output = recolored;
  } else {
  }

  if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse, as we gamma corrected in the lutbuilder for scaling
    color_output = GammaCorrectByLuminance(color_output, true);
  }

  return lerp(color_input, color_output, lut_config.strength);
}

float3 SampleGamma2LUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
  if (RENODX_LUT_SAMPLING_TYPE) {
    lut_config.type_input = renodx::lut::config::type::SRGB;
  } else {
    lut_config.type_input = renodx::lut::config::type::GAMMA_2_0;
  }

  float3 lutted = SampleLUTWithScaling(lut_texture, lut_config, color_input);

  return lutted;
}

float3 SampleLinearLUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
  if (RENODX_LUT_SAMPLING_TYPE) {  // replace linear lut sampling with sRGB
    lut_config.type_input = renodx::lut::config::type::SRGB;
  } else {
    lut_config.type_input = renodx::lut::config::type::LINEAR;
  }

  float3 lutted = SampleLUTWithScaling(lut_texture, lut_config, color_input);

  return lutted;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    // value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(10.f, x)));
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
  }
  return color;
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float peak_white, float white_clip = 100.f) {
  float max_channel = renodx::math::Max(input.r, input.g, input.b);

  float mapped_peak = exp2(renodx::tonemap::HermiteSplineRolloff(log2(max_channel), log2(peak_white), log2(white_clip)));
  float scale = renodx::math::DivideSafe(mapped_peak, max_channel, 1.f);
  float3 tonemapped = input * scale;
  return tonemapped;
}

float3 GamutCompress(float3 color_bt709, float3x3 color_space_matrix = renodx::color::BT709_TO_XYZ_MAT) {
  float grayscale = dot(color_bt709, color_space_matrix[1].rgb);

  const float MID_GRAY_LINEAR = 1 / (pow(10, 0.75));                          // ~0.18f
  const float MID_GRAY_PERCENT = 0.5f;                                        // 50%
  const float MID_GRAY_GAMMA = log(MID_GRAY_LINEAR) / log(MID_GRAY_PERCENT);  // ~2.49f
  float encode_gamma = MID_GRAY_GAMMA;

  float3 encoded = renodx::color::gamma::EncodeSafe(color_bt709, encode_gamma);
  float encoded_gray = renodx::color::gamma::Encode(grayscale, encode_gamma);

  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray);
  float3 color_bt709_compressed = renodx::color::gamma::DecodeSafe(compressed, encode_gamma);

  return color_bt709_compressed;
}

float3 ApplyDisplayMap(float3 color_input, float peak_ratio) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
  float3 hue_correction_source = color_input;
  if (RENODX_TONE_MAP_HUE_SHIFT > 0.f) {
    hue_correction_source = renodx::tonemap::ExponentialRollOff(color_input, 1.f, 4.f);
  }
  color_input = renodx::color::bt709::clamp::AP1(color_input);
  float y = renodx::color::y::from::BT709(color_input);
  color_input = ApplyExposureContrastFlareHighlightsShadowsByLuminance(color_input, y, cg_config);
  color_input = ApplySaturationBlowoutHueCorrectionHighlightSaturation(color_input, hue_correction_source, y, cg_config);

  float3 color_output = color_input;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    peak_ratio = peak_ratio / 2.f;  // gamma correction slider at default is now 200.f, tonemapper originally biased around 100.f

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      peak_ratio = renodx::color::correct::GammaSafe(peak_ratio, true);
    }

    float3 color_input_bt2020 = renodx::color::bt2020::from::BT709(color_input);
    float3 display_mapped = ApplyHermiteSplineByMaxChannel(max(0, color_input_bt2020), peak_ratio, 60.f);
    display_mapped = renodx::color::bt709::from::BT2020(display_mapped);

    color_output = display_mapped;
  }

  return color_output;
}

float3 ApplyDithering(float3 color_input, float screen_pos_x, float screen_pos_y) {
  if (CUSTOM_DITHERING == 0.f)
    return color_input;

  // Constants for HDR10 PQ dithering
  const float INV_HDR10PQ_STEPS = 1.f / 1023.f;  // ~0.000977, size of one PQ code step at 10-bit
  const float DITHER_SCALE = 1.f;
  const float2 DITHER_HASH_VEC = float2(12.9898f, 78.233f);
  const float DITHER_HASH_SCALE = 43758.546875f;

  float2 base = float2(screen_pos_x, screen_pos_y);

  // Use BT.2020 luminance weights
  float3 offsets = renodx::color::BT2020_TO_XYZ_MAT[1];  // {0.2627002120f, 0.6779980715f, 0.0593017165f}

  // Generate per-channel hash noise
  float3 noise = float3(
      frac(sin(dot(base + offsets.r, DITHER_HASH_VEC)) * DITHER_HASH_SCALE),
      frac(sin(dot(base + offsets.g, DITHER_HASH_VEC)) * DITHER_HASH_SCALE),
      frac(sin(dot(base + offsets.b, DITHER_HASH_VEC)) * DITHER_HASH_SCALE));

  // Center and scale the dither to ~±0.5 PQ step
  float3 dither = (noise - 0.5f) * INV_HDR10PQ_STEPS * DITHER_SCALE;

  // Apply dithering in PQ space
  float3 encoded_pq = renodx::color::pq::EncodeSafe(color_input, RENODX_DIFFUSE_WHITE_NITS);
  float3 dithered_pq = encoded_pq + dither;
  return renodx::color::pq::DecodeSafe(saturate(dithered_pq), RENODX_DIFFUSE_WHITE_NITS);
}

float3 ApplyFade(float3 color_input, float fade) {
  return color_input * fade;
}

float3 FinalizeOutput(float3 color_input) {
  if (COMPRESS_TO_BT709 != 0.f) {
    color_input = GamutCompress(color_input);
  }

  color_input = renodx::color::correct::GammaSafe(color_input);
  color_input *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  color_input = renodx::color::correct::GammaSafe(color_input, true);
  color_input *= 2.5f;
  return color_input;
}

float3 ApplySDRLUTInHDR(float3 color_hdr, Texture3D<float4> lut_texture, SamplerState lut_sampler, uint lut_type) {
  if (LUT_GAMUT_RESTORATION == 0.f) {
    color_hdr = GamutCompress(color_hdr);
  }
  const float scale = ComputeReinhardSmoothClampScale(color_hdr);
  float3 color_sdr = color_hdr * scale;

  float3 lutted;
  if (lut_type == 0u) {  // gamma 2
    lutted = SampleGamma2LUT16(lut_texture, lut_sampler, color_sdr);
  } else {  // linear
    lutted = SampleLinearLUT16(lut_texture, lut_sampler, color_sdr);
  }

  float3 upgraded = lutted / scale;
  upgraded = lerp(color_hdr, upgraded, RENODX_COLOR_GRADE_STRENGTH);

  return upgraded;
}

float3 ToneMapMaxCLLAndSampleGamma2LUT16AndFinalizeOutput(
    float3 hdr_tonemapped,
    Texture3D<float4> lut_texture, SamplerState lut_sampler, float peak_ratio,
    float screen_pos_x, float screen_pos_y,
    float fade) {
  float3 lutted = ApplySDRLUTInHDR(hdr_tonemapped, lut_texture, lut_sampler, 0u);

  float3 display_mapped = ApplyDisplayMap(lutted, peak_ratio);
  display_mapped = ApplyDithering(display_mapped, screen_pos_x, screen_pos_y);
  display_mapped = ApplyFade(display_mapped, fade);
  display_mapped = FinalizeOutput(display_mapped);

  return display_mapped;
}

float3 ToneMapMaxCLLAndSampleLinearLUT16AndFinalizeOutput(
    float3 hdr_tonemapped,
    Texture3D<float4> lut_texture, SamplerState lut_sampler, float peak_ratio,
    float screen_pos_x, float screen_pos_y,
    float fade) {
  float3 lutted = ApplySDRLUTInHDR(hdr_tonemapped, lut_texture, lut_sampler, 1u);

  float3 display_mapped = ApplyDisplayMap(lutted, peak_ratio);
  display_mapped = ApplyDithering(display_mapped, screen_pos_x, screen_pos_y);
  display_mapped = ApplyFade(display_mapped, fade);
  display_mapped = FinalizeOutput(display_mapped);

  return display_mapped;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);
  float3 lum = GammaCorrectByLuminance(incorrect_color);

  // use chrominance from channel gamma correction and apply hue shifting from per channel tonemap
  float3 result = renodx::color::correct::Chrominance(lum, ch, 1.f, 1.f, 0);

  result = renodx::color::bt709::clamp::AP1(result);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
    corrected_color = renodx::color::correct::Hue(corrected_color, incorrect_color, 1.f, 0);
  } else if (RENODX_GAMMA_CORRECTION == 3.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}
