#ifndef TONEMAP_HLSLI
#define TONEMAP_HLSLI

#include "./CBuffer_ToneMap.hlsli"

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

float ComputeMaxChCompressionScale(float3 untonemapped, float rolloff_start = 0.18f, float output_max = 1.f) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewise(peak, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 BlendLUTs(
    float3 color_input,
    float fTextureSize,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fTextureInverseSize,
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp) {
  float lut_offset = fTextureInverseSize * 0.5f;
  float lut_scale = 1.f - fTextureInverseSize;
  float3 lut_coordinates = renodx::color::srgb::Encode(color_input) * lut_scale + lut_offset;

  float3 color_output = tTextureMap0.SampleLevel(TrilinearClamp, lut_coordinates, 0.f).rgb;

  [branch]
  if (fTextureBlendRate > 0.f) {
    float3 color_output1 = tTextureMap1.SampleLevel(TrilinearClamp, lut_coordinates, 0.f).rgb;
    color_output = lerp(color_output, color_output1, fTextureBlendRate);

    if (fTextureBlendRate2 > 0.f) {
      float3 color_output2 = tTextureMap2.SampleLevel(TrilinearClamp, renodx::color::srgb::Encode(color_output), 0.f).rgb;
      color_output = lerp(color_output, color_output2, fTextureBlendRate2);
    }
  } else {
    float3 color_output2 = tTextureMap2.SampleLevel(TrilinearClamp, renodx::color::srgb::Encode(color_output), 0.f).rgb;
    color_output = lerp(color_output, color_output2, fTextureBlendRate2);
  }

  return color_output;
}

float3 ApplyColorGradingLUTs(
    float3 color_input,
    float fTextureSize,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fTextureInverseSize,
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp) {
  const float3 color_output_original = BlendLUTs(
      color_input,
      fTextureSize,
      fTextureBlendRate,
      fTextureBlendRate2,
      fTextureInverseSize,
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp);

  float3 color_output = color_output_original;

  if (COLOR_GRADE_LUT_SCALING > 0.f) {
    float3 lut_black = BlendLUTs(
        0.f,
        fTextureSize,
        fTextureBlendRate,
        fTextureBlendRate2,
        fTextureInverseSize,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp);

    float lut_black_y = renodx::color::y::from::BT709(lut_black);
    if (lut_black_y > 0.f) {
      float3 lut_mid = BlendLUTs(
          lut_black_y,
          fTextureSize,
          fTextureBlendRate,
          fTextureBlendRate2,
          fTextureInverseSize,
          tTextureMap0,
          tTextureMap1,
          tTextureMap2,
          TrilinearClamp);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        color_output = renodx::color::correct::GammaSafe(color_output);
        lut_black = renodx::color::correct::GammaSafe(lut_black);
        lut_mid = renodx::color::correct::GammaSafe(lut_mid);
        // color_input = renodx::color::correct::GammaSafe(color_input);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::color::srgb::EncodeSafe(color_output),
          renodx::color::srgb::EncodeSafe(lut_black),
          renodx::color::srgb::EncodeSafe(lut_mid),
          renodx::color::srgb::EncodeSafe(color_input));

      float3 unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped_gamma);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      // color_output = color_output_original * lerp(1.f, renodx::math::DivideSafe(LuminosityFromBT709(unclamped_linear), LuminosityFromBT709(color_output_original), 1.f), COLOR_GRADE_LUT_SCALING);
      color_output = renodx::lut::RecolorUnclamped(color_output_original, unclamped_linear, COLOR_GRADE_LUT_SCALING);
    }
  }

  return color_output;
}

void ApplyColorGrading(
    float r_in,
    float g_in,
    float b_in,
    inout float r_out,
    inout float g_out,
    inout float b_out,
    uint cPassEnabled,
    float fTextureSize,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fTextureInverseSize,
    float4 fColorMatrix[4],
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp) {
  if ((cPassEnabled & 4u) == 0u) {
    r_out = r_in;
    g_out = g_in;
    b_out = b_in;
    return;
  }

  float3 color_input = float3(r_in, g_in, b_in);

  float compression_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    compression_scale = renodx::math::Max(color_input);
    compression_scale = 1.f / renodx::math::Select(compression_scale > 1.f, compression_scale, 1.f);  // only compress values above 1.f
  } else {
    compression_scale = ComputeMaxChCompressionScale(color_input);
  }

  float3 compressed_color = color_input * compression_scale;

  float3 lut_output = compressed_color;
  if (COLOR_GRADE_LUT_STRENGTH > 0.f) {
    lut_output = ApplyColorGradingLUTs(
        compressed_color,
        fTextureSize,
        fTextureBlendRate,
        fTextureBlendRate2,
        fTextureInverseSize,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp);
    lut_output = lerp(compressed_color, lut_output, COLOR_GRADE_LUT_STRENGTH);
  }

  float3 matrix_color;
  matrix_color.r = mad(lut_output.b, fColorMatrix[2].x,
                       mad(lut_output.g, fColorMatrix[1].x, (lut_output.r * fColorMatrix[0].x)))
                   + fColorMatrix[3].x;
  matrix_color.g = mad(lut_output.b, fColorMatrix[2].y,
                       mad(lut_output.g, fColorMatrix[1].y, (lut_output.r * fColorMatrix[0].y)))
                   + fColorMatrix[3].y;
  matrix_color.b = mad(lut_output.b, fColorMatrix[2].z,
                       mad(lut_output.g, fColorMatrix[1].z, (lut_output.r * fColorMatrix[0].z)))
                   + fColorMatrix[3].z;

  float3 color_output = matrix_color / compression_scale;

  r_out = color_output.r;
  g_out = color_output.g;
  b_out = color_output.b;
}

float3 ApplyAdaptiveMBPurity(float3 lms_input, float3 adaptive_neutral_lms, float purity_scale) {
  if (abs(purity_scale - 1.f) <= 1e-5f) return lms_input;

  float3 relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, adaptive_neutral_lms);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(relative_weighted);
  float3 mb_neutral = renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_scale);
  float3 relative_weighted_out = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(relative_weighted_out, adaptive_neutral_lms));
}

float ApplyLuminanceGradingChannel(float channel, float gamma, float exposure, float highlights, float shadows, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray = 0.18f) {
  float channel_adjusted = channel * exposure;
  if (gamma != 1.f) {
    channel_adjusted = renodx::math::Select(channel_adjusted < 1.f, pow(channel_adjusted, gamma), channel_adjusted);
  }
  channel_adjusted = renodx::color::grade::Highlights(channel_adjusted, highlights, mid_gray);
  channel_adjusted = renodx::color::grade::Shadows(channel_adjusted, shadows, mid_gray);
  channel_adjusted = ContrastAndFlare(channel_adjusted, contrast, contrast_highlights, contrast_shadows, flare, mid_gray);
  return channel_adjusted;
}

float3 ApplyLuminanceGrading(float3 color, float gamma, float exposure, float highlights, float shadows, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray = 0.18f) {
  float y = max(0.f, renodx::color::yf::from::BT2020(color));
  float y_adjusted = ApplyLuminanceGradingChannel(y, gamma, exposure, highlights, shadows, contrast, contrast_highlights, contrast_shadows, flare, mid_gray);
  return color * renodx::math::DivideSafe(y_adjusted, y, 1.f);
}

float3 ApplyPurityGradingLMS(float3 color_lms, float purity_scale, float purity_highlights, float dechroma, float3 mid_gray_lms = 0.18f) {
  if (purity_scale == 1.f && purity_highlights == 0.f && dechroma == 0.f) return color_lms;

  float lum_target = max(0.f, renodx::color::yf::from::LMS(color_lms));

  if (dechroma != 0.f) {
    purity_scale *= lerp(1.f, 0.f, saturate(pow(lum_target / (10000.f / 100.f), 1.f - dechroma)));
  }

  if (purity_highlights != 0.f) {
    float percent_max = saturate(lum_target * 100.f / 10000.f);
    float blowout_change = pow(1.f - percent_max, 100.f * abs(purity_highlights));
    if (purity_highlights < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    purity_scale *= blowout_change;
  }

  if (purity_scale != 1.f) {
    color_lms = ApplyAdaptiveMBPurity(color_lms, mid_gray_lms, purity_scale);
  }

  return color_lms;
}

float3 RestoreAdaptiveWeightedLMSHue(float3 source_lms, float3 target_lms, float3 adaptive_state_lms) {
  source_lms = max(0.f, source_lms);
  target_lms = max(0.f, target_lms);

  // Convert source to adapted weighted LMS.
  float3 source_relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(source_lms, adaptive_state_lms);

  // Convert target to adapted weighted LMS.
  float3 display_scaled_relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(target_lms, adaptive_state_lms);

  // Psychov-style MB hue direction restore.
  {
    float3 mb_source = renodx::color::macleod_boynton::from::WeightedLMS(source_relative_weighted);
    float3 mb_display_target = renodx::color::macleod_boynton::from::WeightedLMS(display_scaled_relative_weighted);
    float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f);

    float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
    float2 display_target_offset = mb_display_target.xy - mb_adapted_bg.xy;

    float src2 = dot(source_offset, source_offset);
    float display_tgt2 = dot(display_target_offset, display_target_offset);

    if (src2 > 1e-7f && display_tgt2 > 1e-7f) {
      float target_radius = sqrt(display_tgt2);
      float2 source_dir = source_offset * rsqrt(src2);
      float2 display_target_dir = display_target_offset * rsqrt(display_tgt2);

      float restore_weight = 0.5f;

      float2 blended_dir = lerp(display_target_dir, source_dir, restore_weight);
      float blended_len2 = dot(blended_dir, blended_dir);
      blended_dir = (blended_len2 > 1e-7f) ? (blended_dir * rsqrt(blended_len2)) : display_target_dir;

      float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
      float3 mb_restored = float3(mb_restored_xy, mb_display_target.z);

      display_scaled_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);
    }
  }

  // Psychov-style BT.2020-bound adaptive weighted LMS gamut compression.
  // display_scaled_relative_weighted = renodx::tonemap::psychov::psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
  //     display_scaled_relative_weighted,
  //     adaptive_state_lms,
  //     renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
  //     1.f);

  // Return compressed target to LMS.
  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(display_scaled_relative_weighted, adaptive_state_lms));
}

float3 ApplyUserGrading(float3 color_bt2020, float mid_gray = 0.1f) {
  color_bt2020 = ApplyLuminanceGrading(color_bt2020,
                                       RENODX_TONE_MAP_GAMMA,
                                       RENODX_TONE_MAP_EXPOSURE,
                                       RENODX_TONE_MAP_HIGHLIGHTS,
                                       RENODX_TONE_MAP_SHADOWS,
                                       RENODX_TONE_MAP_CONTRAST,
                                       RENODX_TONE_MAP_HIGHLIGHT_CONTRAST,
                                       RENODX_TONE_MAP_SHADOW_CONTRAST,
                                       0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                       mid_gray);

  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyPurityGradingLMS(
      color_lms,
      RENODX_TONE_MAP_SATURATION,
      -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
      RENODX_TONE_MAP_DECHROMA,
      renodx::color::lms::from::BT2020(mid_gray.xxx));

  return renodx::color::bt2020::from::LMS(color_lms);
}

float3 ApplyUserGradingAndToneMap(float3 color_bt709, float2 grain_uv) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color_bt709;
  float3 color_input_bt709 = color_bt709;

  const float MID_GRAY = 0.18f;
  const float PEAK_RATIO = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  float3 color_bt2020;
  if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
    }

    // blow out and hue shift in BT.709
    float3 purity_and_hue_source = renodx::tonemap::neutwo::PerChannel(color_bt709, PEAK_RATIO);
    color_bt709 = renodx::color::correct::Luminance(purity_and_hue_source, renodx::color::yf::from::BT709(purity_and_hue_source), renodx::color::yf::from::BT709(color_bt709));

    color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
  } else {
    float3 target_lms;
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      // gamma correction in lms normalized to bt709 white
      const float3 BT709_WHITE_LMS = renodx::color::lms::from::BT709(1.f);
      float3 color_lms_normalized = renodx::color::lms::from::BT709(color_bt709) / BT709_WHITE_LMS;
      color_lms_normalized = renodx::color::correct::GammaSafe(color_lms_normalized);
      target_lms = color_lms_normalized * BT709_WHITE_LMS;
    } else {
      target_lms = renodx::color::lms::from::BT709(color_bt709);
    }

    if (RENODX_GAMMA_CORRECTION != 0.f) {
      // apply hue correction
      target_lms = RestoreAdaptiveWeightedLMSHue(
          renodx::color::lms::from::BT709(color_input_bt709),
          target_lms,
          renodx::color::lms::from::BT709(MID_GRAY));
    }

    // blow out and hue shift in LMS normalized to BT.2020 white
    const float3 BT2020_WHITE_LMS = renodx::color::lms::from::BT2020(1.f);
    float3 color_lms_normalized = target_lms / BT2020_WHITE_LMS;
    float3 purity_and_hue_source_lms_normalized = renodx::tonemap::neutwo::PerChannel(color_lms_normalized, PEAK_RATIO);
    color_lms_normalized = renodx::color::correct::Luminance(purity_and_hue_source_lms_normalized, renodx::color::yf::from::LMS(purity_and_hue_source_lms_normalized), renodx::color::yf::from::LMS(color_lms_normalized));
    target_lms = color_lms_normalized * BT2020_WHITE_LMS;

    color_bt2020 = renodx::color::bt2020::from::LMS(target_lms);
  }

  {
    color_bt2020 = ApplyUserGrading(color_bt2020, MID_GRAY);
  }

  {
    color_bt2020 = renodx::tonemap::neutwo::MaxChannel(color_bt2020, PEAK_RATIO);
  }
  color_bt709 = renodx::color::bt709::from::BT2020(color_bt2020);

  color_bt709 = renodx::effects::ApplyFilmGrain(
      color_bt709,
      grain_uv,
      CUSTOM_RANDOM,
      CUSTOM_GRAIN_STRENGTH * 0.06f);

  color_bt709 *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color_bt709 = renodx::color::correct::GammaSafe(color_bt709, true);
  }

  return color_bt709;
}

#endif  // TONEMAP_HLSLI
