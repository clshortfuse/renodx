#include "./shared.h"
#include "./tonemap.hlsli"

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float4 Sample2DLUT(float3 srgb_color, SamplerState lut_sampler, Texture2D<float4> lut_tex) {
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

// HITMAN 3 + Ambrose Island
float4 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DLUT(srgb_input, lut_sampler, lut_texture);
  float3 color_output_gamma = lut_sample.rgb;
  float3 color_output_original_gamma = color_output_gamma;

  if (RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 lut_black_gamma = Sample2DLUT(0.f, lut_sampler, lut_texture).rgb;

    float lut_black_y = renodx::color::yf::from::BT709(renodx::color::srgb::Decode(max(0, lut_black_gamma)));
    if (lut_black_y > 0.f) {
      float3 lut_mid_gamma = Sample2DLUT(renodx::color::srgb::Encode(0.18f), lut_sampler, lut_texture).rgb;

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        color_output_gamma = renodx::color::srgb::Encode(renodx::color::gamma::Decode(max(0, color_output_gamma)));
        lut_black_gamma = renodx::color::srgb::Encode(renodx::color::gamma::Decode(max(0, lut_black_gamma)));
        lut_mid_gamma = renodx::color::srgb::Encode(renodx::color::gamma::Decode(max(0, lut_mid_gamma)));
      }

      float3 unclamped_gamma = Unclamp(color_output_gamma, lut_black_gamma, lut_mid_gamma, srgb_input);

      float3 unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped_gamma);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 color_output_original_linear = renodx::color::srgb::Decode(color_output_original_gamma);

      float3 color_output_linear = color_output_original_linear * lerp(1.f, renodx::math::DivideSafe(renodx::color::yf::from::BT709(unclamped_linear), renodx::color::yf::from::BT709(color_output_original_linear), 1.f), RENODX_COLOR_GRADE_SCALING);
      color_output_linear = ApplyPurityFromBT709(unclamped_linear, color_output_linear);

      lut_sample.rgb = renodx::color::srgb::EncodeSafe(color_output_linear);
    }
  }

  return lut_sample;
}

// HITMAN 1 + 2
float4 SampleLUTSRGBInLinearOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DLUT(srgb_input, lut_sampler, lut_texture);

  float3 color_output_linear = lut_sample.rgb;
  float3 color_output_original_linear = color_output_linear;

  if (RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 lut_black_linear = Sample2DLUT(0.f, lut_sampler, lut_texture).rgb;

    float lut_black_y = renodx::color::yf::from::BT709(max(0, lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_mid_linear = Sample2DLUT(renodx::color::srgb::Encode(0.18f), lut_sampler, lut_texture).rgb;

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        color_output_linear = renodx::color::correct::GammaSafe(max(0, color_output_linear));
        lut_black_linear = renodx::color::correct::GammaSafe(max(0, lut_black_linear));
        lut_mid_linear = renodx::color::correct::GammaSafe(max(0, lut_mid_linear));
      }

      float3 unclamped_gamma = Unclamp(renodx::color::srgb::Encode(color_output_linear), renodx::color::srgb::Encode(lut_black_linear), renodx::color::srgb::Encode(lut_mid_linear), srgb_input);

      float3 unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped_gamma);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      color_output_linear = color_output_original_linear * lerp(1.f, renodx::math::DivideSafe(renodx::color::yf::from::BT709(unclamped_linear), renodx::color::yf::from::BT709(color_output_original_linear), 1.f), RENODX_COLOR_GRADE_SCALING);
      color_output_linear = ApplyPurityFromBT709(unclamped_linear, color_output_linear);

      lut_sample.rgb = color_output_linear;
    }
  }

  return lut_sample;
}

float3 ScaleBloom(float3 color_scene, float3 tex_bloom, float bloom_strength) {
  float3 bloom_color = bloom_strength * tex_bloom;

  if (bloom_strength > 0.f && CUSTOM_BLOOM_SCALING > 0.f && CUSTOM_BLOOM > 0.f) {
    float mid_gray_bloomed = (0.18 + renodx::color::yf::from::BT709(bloom_color)) / 0.18;

    float scene_luminance = renodx::color::yf::from::BT709(color_scene) * mid_gray_bloomed;
    float bloom_blend = saturate(smoothstep(0.f, 0.05f, scene_luminance));
    float3 bloom_scaled = lerp(0.f, bloom_color, bloom_blend);
    bloom_scaled = lerp(bloom_color, bloom_scaled, CUSTOM_BLOOM_SCALING * BLOOM_SCALING_MAX);

    bloom_color = lerp(bloom_scaled, bloom_color, saturate(renodx::color::yf::from::BT709(bloom_scaled) / 0.18f));
  }
  return CUSTOM_BLOOM * bloom_color + color_scene;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.18f, float output_max = 1.f) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewise(peak, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

// samples the lutbuilder, scaling is done separately inside the lutbuilder
renodx::lut::Config CreateLUTConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 16u;
  lut_config.recolor = 0.f;
  lut_config.gamut_compress = 0.f;
  return lut_config;
}

float3 SampleGamma2LUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
  if (RENODX_LUT_SAMPLING_TYPE) {
    lut_config.type_input = renodx::lut::config::type::SRGB;
  } else {
    lut_config.type_input = renodx::lut::config::type::GAMMA_2_0;
  }

  float3 lutted = renodx::lut::Sample(lut_texture, lut_config, color_input);

  return lutted;
}

float3 SampleLinearLUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
  if (RENODX_LUT_SAMPLING_TYPE) {  // replace linear lut sampling with sRGB
    lut_config.type_input = renodx::lut::config::type::SRGB;
  } else {
    lut_config.type_input = renodx::lut::config::type::LINEAR;
  }

  float3 lutted = renodx::lut::Sample(lut_texture, lut_config, color_input);

  return lutted;
}

float3 ApplyDisplayMap(float3 color_input, float peak_ratio) {
  // UserGradingConfig cg_config = CreateColorGradeConfig();
  // float y = renodx::color::yf::from::BT709(color_input);
  // color_input = ApplyExposureContrastFlareHighlightsShadowsByLuminance(color_input, y, cg_config);
  // color_input = ApplySaturationBlowoutHueCorrectionHighlightSaturation(color_input, color_input, y, cg_config);

  float3 color_output = color_input;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    peak_ratio = peak_ratio / 2.f;  // gamma correction slider at default is now 200.f, tonemapper originally biased around 100.f

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      peak_ratio = renodx::color::correct::GammaSafe(peak_ratio, true);
    }

    float3 color_input_bt2020 = renodx::color::bt2020::from::BT709(color_input);
    float3 display_mapped = renodx::tonemap::neutwo::MaxChannel(max(0, color_input_bt2020), peak_ratio);
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
  if (RENODX_GAMMA_CORRECTION) {
    color_input = renodx::color::correct::GammaSafe(color_input);
  }
  color_input *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION) {
    color_input = renodx::color::correct::GammaSafe(color_input, true);
  }
  color_input *= 2.5f;
  return color_input;
}

float3 ApplySDRLUTInHDR(float3 color_hdr, Texture3D<float4> lut_texture, SamplerState lut_sampler, uint lut_type) {
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

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
    corrected_color = renodx::color::correct::Hue(corrected_color, incorrect_color, 1.f, 0);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}
