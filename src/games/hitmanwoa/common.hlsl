#include "./shared.h"

float4 Sample2DPackedLUT(float3 srgb_color, SamplerState lut_sampler, Texture2D<float4> lut_tex) {
  // Convert sRGB color to 3D LUT index space (0–15)
  float3 lut_coord = srgb_color * 15.0f;

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
  float2 uv_a = (float2(tile_a * 16) + float2(lut_r, lut_g)) / 64.0f;
  float2 uv_b = (float2(tile_b * 16) + float2(lut_r, lut_g)) / 64.0f;

  // Trilinear interpolation between adjacent blue slices
  float4 lut_slice_low = lut_tex.SampleLevel(lut_sampler, uv_a, 0.0f);
  float4 lut_slice_high = lut_tex.SampleLevel(lut_sampler, uv_b, 0.0f);
  float4 lut_sample = lerp(lut_slice_low, lut_slice_high, b_frac);

  return lut_sample;
}

float3 ChrominanceOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 correct_ab = correct_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(correct_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);
  incorrect_lab.yz = incorrect_ab * scale;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 HueAndChrominanceOKLab(
    float3 incorrect_color,
    float3 chrominance_reference_color,
    float3 hue_reference_color,
    float hue_correct_strength = 1.f) {
  if (hue_correct_strength == 0.f)
    return ChrominanceOKLab(incorrect_color, chrominance_reference_color);

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 hue_lab = renodx::color::oklab::from::BT709(hue_reference_color);
  float3 chrominance_lab = renodx::color::oklab::from::BT709(chrominance_reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 hue_ab = hue_lab.yz;

  // Always use chrominance magnitude from chrominance reference
  float target_chrominance = length(chrominance_lab.yz);

  // Compute blended hue direction
  float2 blended_ab_dir = normalize(lerp(normalize(incorrect_ab), normalize(hue_ab), hue_correct_strength));

  // Apply chrominance magnitude from chrominance_reference_color
  float2 final_ab = blended_ab_dir * target_chrominance;

  incorrect_lab.yz = final_ab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 HueChrominanceOKLabSameColor(float3 incorrect_color, float3 correct_color) {
  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  incorrect_lab.yz = correct_lab.yz;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float3 CorrectBlackPerChannel(float3 color_input, float3 lut_color, float3 lut_black_rgb, float strength) {
  float3 input_y = renodx::color::y::from::BT709(abs(color_input));
  float3 color_y = renodx::color::y::from::BT709(abs(lut_color));
  float3 a = lut_black_rgb;
  float3 b = lerp(0.0f, lut_black_rgb, strength);
  float3 g = input_y;
  float3 h = color_y;

  float3 new_y = h - pow(a, pow(1.f + g, renodx::math::DivideSafe(b, a, 0.f)));

  float3 safe_ratio = renodx::math::DivideSafe(saturate(min(h, new_y)), h, 1.f);
  return lut_color * safe_ratio;
}

float3 CorrectBlackChrominance(float3 color_input, float3 lut_color, float3 lut_black_rgb, float lut_black_y, float strength) {
  float3 ch = CorrectBlackPerChannel(color_input, lut_color, lut_black_rgb, strength);
  float3 lum = renodx::lut::CorrectBlack(color_input, lut_color, lut_black_y, strength);

  float3 corrected = ChrominanceOKLab(lum, ch);

  return corrected;
}

float4 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DPackedLUT(srgb_input, lut_sampler, lut_texture);
  if (RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 min_black = max(0, Sample2DPackedLUT(0.f, lut_sampler, lut_texture).rgb);
    float3 lut_min_rgb = pow(min_black, 2.2f);
    float lut_min_y = renodx::color::y::from::BT709(max(0, lut_min_rgb));
    if (lut_min_y > 0) {
      float3 mid_gray = pow(Sample2DPackedLUT(renodx::color::srgb::EncodeSafe(0.18), lut_sampler, lut_texture).rgb, 2.2f);
      float3 linear_color_input_adjusted = pow(srgb_input, 2.2f) * mid_gray / 0.18f;
      float3 linear_lutted = pow(lut_sample.rgb, 2.2f);
      float3 corrected_black = CorrectBlackChrominance(linear_color_input_adjusted, linear_lutted, lut_min_rgb, lut_min_y, 1.f);
      // float3 corrected_black = CorrectBlackPerChannel(linear_color_input_adjusted, linear_lutted, lut_min_rgb, 1.f);
      // float3 corrected_black = renodx::lut::CorrectBlack(linear_color_input_adjusted, linear_lutted, lut_min_y, 1.f);
      corrected_black = max(0, corrected_black);
      lut_sample.rgb = lerp(pow(lut_sample.rgb, 2.2f), corrected_black, RENODX_COLOR_GRADE_SCALING * 0.999f);
      lut_sample.rgb = pow(lut_sample.rgb, 1.f / 2.2f);
    }
  }

  return lut_sample;
}

float4 SampleLUTSRGBInLinearOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DPackedLUT(srgb_input, lut_sampler, lut_texture);
  if (RENODX_COLOR_GRADE_SCALING > 0.f) {
    float3 min_black = Sample2DPackedLUT(0.f, lut_sampler, lut_texture).rgb;
    float3 lut_min_rgb = pow(min_black, 2.2f);
    float lut_min_y = renodx::color::y::from::BT709(max(0, lut_min_rgb));
    if (lut_min_y > 0) {
      float3 mid_gray = renodx::color::correct::GammaSafe(Sample2DPackedLUT(renodx::color::srgb::EncodeSafe(0.18), lut_sampler, lut_texture).rgb);
      float3 linear_color_input_adjusted = pow(srgb_input, 2.2f) * mid_gray / 0.18f;
      float3 lutted_gamma_corrected = renodx::color::correct::GammaSafe(lut_sample.rgb);
      float3 corrected_black = CorrectBlackChrominance(linear_color_input_adjusted, lutted_gamma_corrected, lut_min_rgb, lut_min_y, 1.f);
      // float3 corrected_black = renodx::lut::CorrectBlack(linear_color_input_adjusted, lutted_gamma_corrected, lut_min_y, 1.f);
      corrected_black = max(0, corrected_black);
      lut_sample.rgb = lerp(renodx::color::correct::GammaSafe(lut_sample.rgb), corrected_black, RENODX_COLOR_GRADE_SCALING * 0.999f);
      lut_sample.rgb = renodx::color::correct::GammaSafe(lut_sample.rgb, true);
    }
  }

  return lut_sample;
}

float3 ScaleBloom(float3 color_scene, float3 tex_bloom, float bloom_strength) {
  float3 bloom_color = bloom_strength * tex_bloom;

  if (bloom_strength > 0.f && CUSTOM_BLOOM_SCALING > 0.f && CUSTOM_BLOOM > 0.f) {
    float mid_gray_bloomed = (0.18 + renodx::color::y::from::BT709(bloom_color)) / 0.18;

    float scene_luminance = renodx::color::y::from::BT709(color_scene) * mid_gray_bloomed;
    float bloom_blend = saturate(smoothstep(0.f, 0.18f, scene_luminance));
    float3 bloom_scaled = lerp(0.f, bloom_color, bloom_blend);
    bloom_color = lerp(bloom_color, bloom_scaled, CUSTOM_BLOOM_SCALING * 0.25f);
  }

  return CUSTOM_BLOOM * bloom_color + color_scene;
}

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  color = renodx::color::correct::Hue(exp2(renodx::tonemap::ExponentialRollOff(log2(max(0, color) * 100.f), log2(1.5f * 100.f), log2(10.f * 100.f))) / 100.f, color, 1.f);

  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float ToneMapHitman2(float x) {
  float scaled = x * 0.6f;
  float num = (scaled + 0.1f) * x + 0.004f;
  float den = (scaled + 1.0f) * x + 0.06f;
  float result = num / den;
  result -= 2.f / 30.f;
  return saturate(result);
}

float3 ToneMapHitman2(float3 x) {
  x *= RENODX_TONE_MAP_EXPOSURE;
  float3 result =
      float3(ToneMapHitman2(x.r),
             ToneMapHitman2(x.g),
             ToneMapHitman2(x.b));

#if 1  // luminance with channel chrominance
  const float y_in = renodx::color::y::from::BT709(x);
  const float y_out = ToneMapHitman2(y_in);

  float3 lum = x * select(y_in > 0, y_out / y_in, 0.f);
  lum = ChrominanceOKLab(lum, result);

  result = lerp(lum, result, saturate(result / 0.4f));

#endif

  return saturate(result);
}

float3 ApplyCustomHitmanToneMap(float3 untonemapped) {
  float3 sdr_tonemap = ToneMapHitman2(untonemapped);

  float3 untonemapped_midgray_corrected = untonemapped * (ToneMapHitman2(0.18f) / 0.18f);
  float3 blended_tonemap = lerp(sdr_tonemap, untonemapped_midgray_corrected, sdr_tonemap);

  return blended_tonemap;
}

float3 ApplyCustomSimpleReinhardToneMap(float3 untonemapped) {
  float3 sdr_tonemap = renodx::tonemap::Reinhard(untonemapped);

  float3 untonemapped_midgray_corrected = untonemapped * (renodx::tonemap::Reinhard(0.18f) / 0.18f);
  float3 blended_tonemap = lerp(sdr_tonemap, untonemapped_midgray_corrected, sdr_tonemap);

  return blended_tonemap;
}

renodx::lut::Config CreateLUTConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;  // handle inside lutbuilder
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 16u;
  lut_config.recolor = 0.f;
  return lut_config;
}

float3 SampleGamma2LUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_0;

  float3 lutted = renodx::lut::Sample(lut_texture, lut_config, color_input);

  return lutted;
}

float3 SampleLinearLUT16(Texture3D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
  lut_config.type_input = renodx::lut::config::type::SRGB;

  float3 lutted = renodx::lut::Sample(lut_texture, lut_config, color_input);

  return lutted;
}

float3 ApplyPreToneMapSliders(float3 untonemapped, renodx::color::grade::Config config) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  float y = max(0, renodx::color::y::from::BT709(color));
  const float y_normalized = y / 0.18f;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted));

  const float y_final = y_shadowed * 0.18f;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplyPostToneMapSliders(float3 tonemapped, float3 untonemapped, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float y = max(0, renodx::color::y::from::BT709(untonemapped));
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

float3 ApplyDisplayMap(float3 color_input, float peak_ratio) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);

  if (RENODX_TONE_MAP_TYPE == 1.f) {
    cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
    // color_input = ApplyPreToneMapSliders(color_input, cg_config);

    const float diffuse_white = 100.f;
    const float peak_nits = peak_ratio / 2.f * diffuse_white;

    color_input = renodx::color::correct::GammaSafe(color_input);
    float3 signs = sign(color_input);
    color_input = abs(color_input);
    color_input *= diffuse_white;
    float3 display_mapped = exp2(renodx::tonemap::ExponentialRollOff(
        log2(color_input),
        log2(peak_nits * RENODX_TONE_MAP_SHOULDER_START),
        log2(peak_nits)));
    display_mapped /= diffuse_white;
    display_mapped *= signs;
    // float3 display_mapped = renodx::tonemap::frostbite::BT709(color_input, peak_ratio / 2.f, (peak_ratio / 2.f) * 0.375f, 1.f, 1.f);
    display_mapped = renodx::color::correct::GammaSafe(display_mapped, true);
    display_mapped = ApplyPostToneMapSliders(display_mapped, color_input, cg_config);
    color_input = display_mapped;
  } else {
    color_input = renodx::color::grade::config::ApplyUserColorGrading(color_input, cg_config);
  }

  return color_input;
}

float3 ApplyDithering(float3 color_input, float screen_pos_x, float screen_pos_y) {
  if (CUSTOM_DITHERING)
    return color_input;

  // Constants for HDR10 PQ dithering
  const float INV_HDR10PQ_STEPS = 1.0f / 1023.0f;  // ~0.000977, size of one PQ code step at 10-bit
  const float DITHER_SCALE = 1.0f;
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
  return renodx::color::pq::DecodeSafe(dithered_pq, RENODX_DIFFUSE_WHITE_NITS);
}

float3 ApplyFade(float3 color_input, float fade) {
  return color_input * fade;
}

float3 FinalizeOutput(float3 color_input) {
  color_input = renodx::color::correct::GammaSafe(color_input);
  color_input *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  color_input = renodx::color::correct::GammaSafe(color_input, true);
  color_input *= 2.5f;
  return color_input;
}

float3 ToneMapMaxCLLAndSampleGamma2LUT16AndFinalizeOutput(
    float3 hdr_tonemapped,
    Texture3D<float4> lut_texture, SamplerState lut_sampler, float peak_ratio,
    float screen_pos_x, float screen_pos_y,
    float fade) {
  float3 sdr_tonemapped = ToneMapMaxCLL(hdr_tonemapped);
  // float3 sdr_tonemapped = renodx::tonemap::dice::BT709(hdr_tonemapped, 1.f, 0.7f);

  float3 lutted = SampleGamma2LUT16(lut_texture, lut_sampler, sdr_tonemapped);
  float3 upgraded = renodx::tonemap::UpgradeToneMap(hdr_tonemapped, sdr_tonemapped, lutted, RENODX_COLOR_GRADE_STRENGTH, 0.f);
  float3 display_mapped = ApplyDisplayMap(upgraded, peak_ratio);
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
  float3 sdr_tonemapped = ToneMapMaxCLL(hdr_tonemapped);

  float3 lutted = SampleLinearLUT16(lut_texture, lut_sampler, sdr_tonemapped);
  float3 upgraded = renodx::tonemap::UpgradeToneMap(hdr_tonemapped, sdr_tonemapped, lutted, RENODX_COLOR_GRADE_STRENGTH, 0.f);
  float3 display_mapped = ApplyDisplayMap(upgraded, peak_ratio);
  display_mapped = ApplyDithering(display_mapped, screen_pos_x, screen_pos_y);
  display_mapped = ApplyFade(display_mapped, fade);
  display_mapped = FinalizeOutput(display_mapped);

  return display_mapped;
}

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  // use chrominance from channel gamma correction
  float3 result = renodx::color::correct::Hue(ch, incorrect_color);

  return result;
}
