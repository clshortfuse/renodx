#include "./shared.h"

// This basically does gamut mapping, however it's not focused on gamut as primaries, but on peak white.
// The color is expected to be in the specified color space and in linear.
//
// The sum of "DesaturationAmount" and "DarkeningAmount" needs to be <= 1, both within 0 and 1. They only apply to "FixPositives".
// The closer the sum is to 1, the more each color channel will be containted within its peak range.
float3 CorrectOutOfRangeColor(float3 Color, bool FixNegatives = true, bool FixPositives = true, float DesaturationAmount = 0.5, float DarkeningAmount = 0.5, float Peak = 1.0, uint ColorSpace = 0u) {
  if (FixNegatives && any(Color < 0.0))  // Optional "optimization" branch
  {
    float colorLuminance = ColorSpace == 0u ? renodx::color::y::from::BT709(Color) : renodx::color::y::from::BT2020(Color);

    float3 positiveColor = max(Color.xyz, 0.0);
    float3 negativeColor = min(Color.xyz, 0.0);
    float positiveLuminance = ColorSpace == 0u ? renodx::color::y::from::BT709(positiveColor) : renodx::color::y::from::BT2020(positiveColor);
    float negativeLuminance = ColorSpace == 0u ? renodx::color::y::from::BT709(negativeColor) : renodx::color::y::from::BT2020(negativeColor);
    // Desaturate until we are not out of gamut anymore
    if (colorLuminance > renodx::math::FLT32_MIN) {
      // Desaturate (move towards luminance/grayscale) until no channel is below 0
      float minChannel = renodx::math::Min(Color.r, Color.g, Color.b);
      float desaturateAlpha = renodx::math::SafeDivision(minChannel, minChannel - colorLuminance, 0);  // Both division elements are meant to be negative so the ratio resolves to a positive value
      Color = lerp(Color, colorLuminance, desaturateAlpha);
    }
    // Increase luminance until it's 0 if we were below 0 (it will clip out the negative gamut)
    else if (colorLuminance < -renodx::math::FLT32_MIN) {
      float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
      negativeColor.xyz *= negativePositiveLuminanceRatio;
      Color.xyz = positiveColor + negativeColor;
    }
    // Snap to 0 if the overall luminance was zero, there's nothing to savage, no valid information on rgb ratio
    else {
      Color.xyz = 0.0;
    }
  }

  if (FixPositives && any(Color > Peak))  // Optional "optimization" branch
  {
    float colorLuminance = ColorSpace == 0u ? renodx::color::y::from::BT709(Color) : renodx::color::y::from::BT2020(Color);
    float colorLuminanceInExcess = colorLuminance - Peak;
    float maxColorInExcess = renodx::math::Max(Color.r, Color.g, Color.b) - Peak;                                                  // This is guaranteed to be >= "colorLuminanceInExcess"
    float brightnessReduction = saturate(renodx::math::SafeDivision(Peak, renodx::math::Max(Color.r, Color.g, Color.b), 1));       // Fall back to one in case of division by zero
    float desaturateAlpha = saturate(renodx::math::SafeDivision(maxColorInExcess, maxColorInExcess - colorLuminanceInExcess, 0));  // Fall back to zero in case of division by zero
    Color = lerp(Color, colorLuminance, desaturateAlpha * DesaturationAmount);
    Color = lerp(Color, Color * brightnessReduction, DarkeningAmount);  // Also reduce the brightness to partially maintain the hue, at the cost of brightness
  }

  return Color;
}

// take hue from one color and chrominance from another in OKLab space
float3 HueAndChrominanceOKLab(
    float3 incorrect_color,
    float3 hue_reference_color,
    float3 chrominance_reference_color,
    float hue_correct_strength = 1.f,
    float chrominance_correct_strength = 1.f,
    float clamp_chrominance_loss = 0.f) {
  if (hue_correct_strength == 0.f && chrominance_correct_strength == 0.f) {
    return incorrect_color;
  } else if (hue_correct_strength == 0.f) {
    return renodx::color::correct::ChrominanceOKLab(incorrect_color, chrominance_reference_color, chrominance_correct_strength, clamp_chrominance_loss);
  } else if (chrominance_correct_strength == 0.f) {
    return renodx::color::correct::Hue(incorrect_color, hue_reference_color, hue_correct_strength);
  }

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 hue_lab = renodx::color::oklab::from::BT709(hue_reference_color);
  float3 chrominance_lab = renodx::color::oklab::from::BT709(chrominance_reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 hue_ab = hue_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float target_chrominance = length(chrominance_lab.yz);

  // Scale original chrominance vector toward target chrominance
  float desired_chrominance = lerp(incorrect_chrominance, target_chrominance, chrominance_correct_strength);
  float scale = renodx::math::DivideSafe(desired_chrominance, incorrect_chrominance, 1.f);

  float t = 1.0f - step(1.0f, scale);  // t = 1 when scale < 1, 0 when scale >= 1
  scale = lerp(scale, 1.0f, t * clamp_chrominance_loss);

  float adjusted_chrominance = (incorrect_chrominance > 0.f)
                                   ? incorrect_chrominance * scale
                                   : desired_chrominance;

  // Blend hue direction between incorrect and reference colors
  float2 incorrect_dir = renodx::math::DivideSafe(
      incorrect_ab,
      float2(incorrect_chrominance, incorrect_chrominance),
      float2(0.f, 0.f));
  float hue_chrominance = length(hue_ab);
  float2 hue_dir = renodx::math::DivideSafe(
      hue_ab,
      float2(hue_chrominance, hue_chrominance),
      incorrect_dir);
  float2 blended_dir = lerp(incorrect_dir, hue_dir, hue_correct_strength);
  float blended_len = length(blended_dir);
  float2 final_dir = renodx::math::DivideSafe(
      blended_dir,
      float2(blended_len, blended_len),
      hue_dir);

  // Apply final hue direction and chroma magnitude
  float2 final_ab = final_dir * adjusted_chrominance;
  incorrect_lab.yz = final_ab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float4 Sample2DPackedLUT(float3 srgb_color, SamplerState lut_sampler, Texture2D<float4> lut_tex) {
  if (RENODX_LUT_SAMPLING_TYPE) {
    srgb_color = srgb_color * 0.984375f + 0.0078125;  // add missing offsets
  }
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

float4 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DPackedLUT(srgb_input, lut_sampler, lut_texture);

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = RENODX_COLOR_GRADE_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lutInputColor = srgb_input;
  float3 lutOutputColor = lut_sample.rgb;
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutWhite = 1.f;  // float3 lutWhite = Sample2DPackedLUT(renodx::lut::ConvertInput(1.f, lut_config), lut_sampler, lut_texture).rgb;
    float3 lutBlack = Sample2DPackedLUT(renodx::lut::ConvertInput(0, lut_config), lut_sampler, lut_texture).rgb;
    float3 lutMid = Sample2DPackedLUT(renodx::lut::ConvertInput(0.15f, lut_config), lut_sampler, lut_texture).rgb;  // adjust to not crush

    float3 unclamped_gamma = renodx::lut::Unclamp(
        renodx::lut::GammaOutput(lutOutputColor, lut_config),
        renodx::lut::GammaOutput(lutBlack, lut_config),
        renodx::lut::GammaOutput(lutMid, lut_config),
        renodx::lut::GammaOutput(lutWhite, lut_config),
        srgb_input);
    float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
    float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling * LUT_SCALING_MAX);
    color_output = recolored;
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(srgb_input, color_output, lut_config);
  }

  color_output = renodx::color::srgb::Encode(max(0, color_output));

  lut_sample.rgb = color_output.rgb;

  return lut_sample;
}

float4 SampleLUTSRGBInLinearOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 srgb_input) {
  float4 lut_sample = Sample2DPackedLUT(srgb_input, lut_sampler, lut_texture);

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = RENODX_COLOR_GRADE_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.recolor = 0.f;

  float3 lutInputColor = srgb_input;
  float3 lutOutputColor = lut_sample.rgb;
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutWhite = 1.f;  // float3 lutWhite = Sample2DPackedLUT(renodx::lut::ConvertInput(1.f, lut_config), lut_sampler, lut_texture).rgb;
    float3 lutBlack = Sample2DPackedLUT(renodx::lut::ConvertInput(0, lut_config), lut_sampler, lut_texture).rgb;
    float3 lutMid = Sample2DPackedLUT(renodx::lut::ConvertInput(0.15f, lut_config), lut_sampler, lut_texture).rgb;  // adjust to not crush

    float3 unclamped_gamma = renodx::lut::Unclamp(
        renodx::lut::GammaOutput(lutOutputColor, lut_config),
        renodx::lut::GammaOutput(lutBlack, lut_config),
        renodx::lut::GammaOutput(lutMid, lut_config),
        renodx::lut::GammaOutput(lutWhite, lut_config),
        srgb_input);
    float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
    float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling * LUT_SCALING_MAX);
    color_output = recolored;
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(srgb_input, color_output, lut_config);
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

// Reinhard piecewise shoulder driven by the channel max to compress into output_max.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f, float channel_max = 100.f) {
  float peak = renodx::math::Max(color.r, color.g, color.b);

  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, channel_max, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 0.f);
  float3 tonemapped = color * scale;

  tonemapped = CorrectOutOfRangeColor(tonemapped, true, true, 0.5f, 0.5f, 1.f);

  return tonemapped;
}

float InverseToneMapHitman(float y) {
  // Coefficients derived from inverse of Hitman 2's tonemap curve
  const float numerator1 = -(5.f / 6.f) * (y - (1.0f / 30.f));
  const float sqrt_term = (1.f / 180.f) * sqrt(19260.f * y * y + 1524.f * y + 25.f);
  const float denominator = y - (14.f / 15.f);

  // Use the positive root for physically plausible inverse
  float x = (numerator1 / denominator) - (sqrt_term / denominator);
  return x;
}

float ToneMapHitman(float x) {
  float A = 0.6f;
  float B = 0.1f;
  float C = 1.f;
  float D = 0.004f;
  float E = 0.06f;
  float F = D / E;

  float scaled = x * A;
  float numerator = (scaled + B) * x + D;
  float denominator = (scaled + C) * x + E;
  float result = numerator / denominator;
  result -= F;

  // ((0.6x + 0.1) * 0.6 + 0.004)/((0.6x + 1) * 0.6 + 0.06) - 0.004 / 0.06

  return max(0, result);
}

float3 ToneMapHitman(float3 x, bool by_luminance = false) {
  x *= RENODX_TONE_MAP_EXPOSURE;

  float3 result;
  if (!by_luminance) {
    result = float3(
        ToneMapHitman(x.r),
        ToneMapHitman(x.g),
        ToneMapHitman(x.b));
  } else {
    float y_in = renodx::color::y::from::BT709(x);
    float y_out = ToneMapHitman(y_in);
    result = renodx::color::correct::Luminance(x, y_in, y_out);
  }

  return result;
}

float InverseReinhard(float y) {
  return y / (1.0f - y);
}

float3 Reinhard(float3 x, bool by_luminance = false) {
  x *= RENODX_TONE_MAP_EXPOSURE;

  float3 result = x;
  if (!by_luminance) {
    result = renodx::tonemap::Reinhard(x);
  } else {
    float y_in = renodx::color::y::from::BT709(x);
    float y_out = renodx::tonemap::Reinhard(y_in);
    result = renodx::color::correct::Luminance(x, y_in, y_out);
  }

  return result;
}

float3 ApplyCustomHitmanToneMap(float3 untonemapped) {
  // tonemap by luminance
  float3 lum_tm = ToneMapHitman(untonemapped, true);
  float3 ch_tm = ToneMapHitman(untonemapped);
  float3 untonemapped_midgray_corrected = untonemapped * (0.18f / InverseToneMapHitman(0.18f));

  // create blended hdr version
  float y = renodx::color::y::from::BT709(lum_tm);
  lum_tm = lerp(lum_tm, ch_tm, saturate(y / 0.5f));
  float3 blended_tonemap = lerp(lum_tm, untonemapped_midgray_corrected, saturate(y));

  // take channel chrominance and untonemapped hue
  blended_tonemap = HueAndChrominanceOKLab(
      blended_tonemap,
      untonemapped,  // hue reference color
      ch_tm,         // chrominance reference color
      1.f,           // hue correct strength
      1.f,           // chrominance correct strength
      0.6f           // clamp chrominance loss
  );

  return blended_tonemap;
}

float3 ApplyCustomSimpleReinhardToneMap(float3 untonemapped) {
  // tonemap by luminance
  float3 lum_tm = Reinhard(untonemapped, true);
  float3 ch_tm = Reinhard(untonemapped);
  float3 untonemapped_midgray_corrected = untonemapped * (0.18f / InverseReinhard(0.18f));

  // create blended hdr version
  float y = renodx::color::y::from::BT709(lum_tm);
  lum_tm = lerp(lum_tm, ch_tm, saturate(y / 0.5f));
  float3 blended_tonemap = lerp(lum_tm, untonemapped_midgray_corrected, saturate(y));

  // take channel chrominance and untonemapped hue
  blended_tonemap = HueAndChrominanceOKLab(
      blended_tonemap,
      untonemapped,  // hue reference color
      ch_tm,         // chrominance reference color
      1.f,           // hue correct strength
      1.f,           // chrominance correct strength
      0.6f           // clamp chrominance loss
  );

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

    peak_ratio = peak_ratio / 2.f;  // gamma correction slider at default is now 200.f, tonemapper originally biased around 100.f

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      peak_ratio = renodx::color::correct::GammaSafe(peak_ratio, true);
    }

    float3 display_mapped = renodx::tonemap::ReinhardPiecewiseExtended(
        renodx::color::bt2020::from::BT709(color_input),
        100.f,
        peak_ratio,
        min(RENODX_TONE_MAP_SHOULDER_START, peak_ratio * 0.5f));
    display_mapped = renodx::color::bt709::from::BT2020(display_mapped);

    display_mapped = ApplyPostToneMapSliders(display_mapped, color_input, cg_config);

    display_mapped = renodx::color::bt2020::from::BT709(display_mapped);
    display_mapped = CorrectOutOfRangeColor(display_mapped, true, true, 1.f, 0.f, peak_ratio, 1u);
    display_mapped = renodx::color::bt709::from::BT2020(display_mapped);

    color_input = display_mapped;
  } else {
    color_input = renodx::color::grade::config::ApplyUserColorGrading(color_input, cg_config);
  }

  return color_input;
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

  const float y_in = renodx::color::y::from::BT709(incorrect_color);
  const float y_out = max(0, renodx::color::correct::Gamma(y_in));

  float3 lum = incorrect_color * select(y_in > 0, y_out / y_in, 0.f);

  // use chrominance from channel gamma correction and apply hue shifting from per channel tonemap
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
    corrected_color = renodx::color::correct::Hue(corrected_color, incorrect_color, 1.f);
  } else if (RENODX_GAMMA_CORRECTION == 3.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}
