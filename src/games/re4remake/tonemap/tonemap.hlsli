#include "../common.hlsli"

#ifndef SHADER_HASH
#define SHADER_HASH 0
#endif

#if SHADER_HASH == 0x973A39FC || SHADER_HASH == 0x7FE82B7A  // With Vignette
#define TONE_MAP_PARAM_REGISTER        b2
#define COLOR_CORRECT_TEXTURE_REGISTER b8
#define CB_CONTROL_REGISTER            b11
#define USES_LUTS                      1
#elif SHADER_HASH == 0x1F9104F3 || SHADER_HASH == 0xDADFEAEF  // No Vignette
#define TONE_MAP_PARAM_REGISTER        b1
#define COLOR_CORRECT_TEXTURE_REGISTER b7
#define CB_CONTROL_REGISTER            b10
#define USES_LUTS                      1
#elif SHADER_HASH == 0x1A45EF38 || SHADER_HASH == 0xF37A126A  // PostTonemap_PS
#define TONE_MAP_PARAM_REGISTER b0
#elif SHADER_HASH == 0x38F17A43 || SHADER_HASH == 0x38F17A43  // PostTonemapC4L
#define TONE_MAP_PARAM_REGISTER b1
#else  // unknown hash
#define TONE_MAP_PARAM_REGISTER b0
#endif

cbuffer TonemapParam : register(TONE_MAP_PARAM_REGISTER) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float original_toe : packoffset(c000.w);          // overridden
  float original_maxNit : packoffset(c001.x);       // overridden
  float original_linearStart : packoffset(c001.y);  // overridden
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
};

float GetToe() {
  float toe = original_toe;
  if (RENODX_TONE_MAP_TYPE != 0) {
    if (RENODX_TONE_MAP_TOE_ADJUSTMENT_TYPE == 0) {
      toe *= RENODX_TONE_MAP_SHADOW_TOE;  // toe
    } else {
      toe = RENODX_TONE_MAP_SHADOW_TOE;  // toe
    }
  }
  return toe;
}
float GetMaxNit() {
  return (RENODX_TONE_MAP_TYPE == 0.f) ? original_maxNit : renodx::math::FLT16_MAX;
}
float GetLinearStart() {
  return (RENODX_TONE_MAP_TYPE == 0.f) ? original_linearStart : renodx::math::FLT16_MAX;
}

#define toe         GetToe()
#define maxNit      GetMaxNit()
#define linearStart GetLinearStart()

#ifndef USES_LUTS
#define USES_LUTS 0
#endif

#if USES_LUTS
Texture3D<float4> tTextureMap0 : register(t5);

Texture3D<float4> tTextureMap1 : register(t6);

Texture3D<float4> tTextureMap2 : register(t7);

cbuffer ColorCorrectTexture : register(COLOR_CORRECT_TEXTURE_REGISTER) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  row_major float4x4 fColorMatrix : packoffset(c001.x);
};

cbuffer CBControl : register(CB_CONTROL_REGISTER) {
  uint cPassEnabled : packoffset(c000.x);
};

SamplerState TrilinearClamp : register(s9, space32);

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  // Remove from 0 to mid-gray
  const float shadow_length = renodx::math::Min(mid_gray_gamma);
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * renodx::math::DivideSafe(max(0, shadow_length - shadow_stop), shadow_length, 0.f);

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float ComputeMaxChCompressionScale(float3 untonemapped, float rolloff_start = 0.18f, float output_max = 1.f) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewise(peak, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 BlendLUTs(float3 color) {
  const float lut_scale = 1.f - fTextureInverseSize;
  const float lut_offset = fTextureInverseSize * 0.5f;
  float3 color_encoded = renodx::color::srgb::Encode(color);

  float3 output;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    output = tTextureMap0.SampleLevel(TrilinearClamp, color_encoded * lut_scale + lut_offset, 0.f).rgb;
  } else {
    output = renodx::lut::SampleTetrahedral(tTextureMap0, color_encoded, (uint)fTextureSize).rgb;
  }

  [branch]
  if (fTextureBlendRate > 0.f) {
    float3 lut1;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      lut1 = tTextureMap1.SampleLevel(TrilinearClamp, color_encoded * lut_scale + lut_offset, 0.f).rgb;
    } else {
      lut1 = renodx::lut::SampleTetrahedral(tTextureMap1, color_encoded, (uint)fTextureSize).rgb;
    }
    output = lerp(output.rgb, lut1, fTextureBlendRate);
  }

  [branch]
  if (fTextureBlendRate2 > 0.f) {
    // missing lut scale and offset for some reason
    float3 lut2 = tTextureMap2.SampleLevel(TrilinearClamp, renodx::color::srgb::Encode(output), 0.f).rgb;
    output = lerp(output, lut2, fTextureBlendRate2);
  }

  return output;
}

float3 ApplyColorGradingLUTs(float3 color_input) {
  float3 color_output_original = BlendLUTs(color_input);

  float3 color_output = color_output_original;

  if (COLOR_GRADE_LUT_SCALING > 0.f) {
    float3 lut_black = BlendLUTs(0.f);

    float lut_black_y = renodx::color::y::from::BT709(lut_black);
    if (lut_black_y > 0.f) {
      float3 lut_mid = BlendLUTs(lut_black_y);

      // if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
      //   color_output = renodx::color::correct::GammaSafe(color_output);
      //   lut_black = renodx::color::correct::GammaSafe(lut_black);
      //   lut_mid = renodx::color::correct::GammaSafe(lut_mid);
      //   // color_input = renodx::color::correct::GammaSafe(color_input);
      // }

      float3 unclamped_gamma = Unclamp(
          renodx::color::srgb::EncodeSafe(color_output),
          renodx::color::srgb::EncodeSafe(lut_black),
          renodx::color::srgb::EncodeSafe(lut_mid),
          renodx::color::srgb::EncodeSafe(color_input));

      float3 unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped_gamma);

      // if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
      //   unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      // }

      // color_output = color_output_original * lerp(1.f, renodx::math::DivideSafe(LuminosityFromBT709(unclamped_linear), LuminosityFromBT709(color_output_original), 1.f), COLOR_GRADE_LUT_SCALING);
      color_output = renodx::lut::RecolorUnclamped(color_output_original, unclamped_linear, COLOR_GRADE_LUT_SCALING);
    }
  }

  return color_output;
}

void ApplyColorGrading(float r_in, float g_in, float b_in,
                       inout float r_out, inout float g_out, inout float b_out) {
  float3 working_color = float3(r_in, g_in, b_in);

  if ((cPassEnabled & 4) != 0) {
    float compression_scale;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      compression_scale = renodx::math::Max(working_color);
      compression_scale = 1.f / renodx::math::Select(compression_scale > 1.f, compression_scale, 1.f);  // only compress values above 1.f
    } else {
      compression_scale = ComputeMaxChCompressionScale(working_color);
    }

    {  // max channel compression
      working_color *= compression_scale;
    }

    if (COLOR_GRADE_LUT_STRENGTH > 0.f) {
      float3 lutted = ApplyColorGradingLUTs(working_color);
      working_color = lerp(working_color, lutted, COLOR_GRADE_LUT_STRENGTH);
    }

    {  // color matrix
      working_color.r = mad(working_color.b, fColorMatrix[2].x, mad(working_color.g, fColorMatrix[1].x, (working_color.r * fColorMatrix[0].x))) + fColorMatrix[3].x;
      working_color.g = mad(working_color.b, fColorMatrix[2].y, mad(working_color.g, fColorMatrix[1].y, (working_color.r * fColorMatrix[0].y))) + fColorMatrix[3].y;
      working_color.b = mad(working_color.b, fColorMatrix[2].z, mad(working_color.g, fColorMatrix[1].z, (working_color.r * fColorMatrix[0].z))) + fColorMatrix[3].z;
    }

    {  // max channel decompression
      working_color /= compression_scale;
    }
  }

  r_out = working_color.r, g_out = working_color.g, b_out = working_color.b;
  return;
}
#endif

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
  float3 color_adjusted = color * renodx::math::DivideSafe(y_adjusted, y, 1.f);

  color_adjusted = renodx::lut::RecolorUnclamped(color, color_adjusted);

  return color_adjusted;
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

float3 ApplyToneMap(float3 color_bt709, float2 grain_uv) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return max(0, color_bt709);
  float3 color_input_bt709 = color_bt709;

  const float MID_GRAY = 0.18f;
  const float PEAK_RATIO = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
  }

  float3 color_bt2020;
  if (RENODX_TONE_MAP_WORKING_COLOR_SPACE == 0.f) {
    float3 purity_and_hue_source = renodx::tonemap::neutwo::PerChannel(color_bt709, PEAK_RATIO);
    color_bt709 = renodx::color::correct::Luminance(purity_and_hue_source, renodx::color::yf::from::BT709(purity_and_hue_source), renodx::color::yf::from::BT709(color_bt709));
    color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
  } else {  // blow out and hue shift in LMS
    const float3 BT2020_WHITE_LMS = renodx::color::lms::from::BT2020(1.f);
    float3 color_lms_normalized = renodx::color::lms::from::BT709(color_bt709) / BT2020_WHITE_LMS;
    float3 purity_and_hue_source_lms_normalized = renodx::tonemap::neutwo::PerChannel(color_lms_normalized, PEAK_RATIO);
    color_lms_normalized = renodx::color::correct::Luminance(
        purity_and_hue_source_lms_normalized,
        renodx::color::yf::from::LMS(purity_and_hue_source_lms_normalized),
        renodx::color::yf::from::LMS(color_lms_normalized));

    color_bt2020 = renodx::color::bt2020::from::LMS(color_lms_normalized * BT2020_WHITE_LMS);
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

