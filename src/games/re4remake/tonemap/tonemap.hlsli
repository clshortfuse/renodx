#include "../common.hlsli"

#ifndef SHADER_HASH
#define SHADER_HASH 0
#endif

#if SHADER_HASH == 0x973A39FC  // HDRPostProcess_WithTonemap_0x973A39FC
#define TONE_MAP_PARAM_REGISTER        b2
#define COLOR_CORRECT_TEXTURE_REGISTER b8
#define CB_CONTROL_REGISTER            b11
#define USES_LUTS                      1
#elif SHADER_HASH == 0x1F9104F3  // NoVignette_HDRPostProcess_WithTonemap_0x1F9104F3
#define TONE_MAP_PARAM_REGISTER        b1
#define COLOR_CORRECT_TEXTURE_REGISTER b7
#define CB_CONTROL_REGISTER            b10
#define USES_LUTS                      1
#elif SHADER_HASH == 0x1A45EF38  // PostTonemap_PS_0x1A45EF38
#define TONE_MAP_PARAM_REGISTER b0
#elif SHADER_HASH == 0x38F17A43  // PostTonemapC4L_PS_0x38F17A43
#define TONE_MAP_PARAM_REGISTER b1
#else  // unknown hash
#define TONE_MAP_PARAM_REGISTER b0
#endif

cbuffer TonemapParam : register(TONE_MAP_PARAM_REGISTER) {
  float original_contrast : packoffset(c000.x);
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

float GetHighlightContrast() {
  float contrast = original_contrast;
  if (TONE_MAP_TYPE != 0) {
    contrast *= RENODX_TONE_MAP_HIGHLIGHT_CONTRAST;  // toe
  }
  return contrast;
}

float GetToe() {
  float toe = original_toe;
  if (TONE_MAP_TYPE != 0) {
    if (RENODX_TONE_MAP_TOE_ADJUSTMENT_TYPE == 0) {
      toe *= RENODX_TONE_MAP_SHADOW_TOE;  // toe
    } else {
      toe = RENODX_TONE_MAP_SHADOW_TOE;  // toe
    }
  }
  return toe;
}
float GetMaxNit() {
  return (TONE_MAP_TYPE == 0.f) ? original_maxNit : renodx::math::FLT16_MAX;
}
float GetLinearStart() {
  return (TONE_MAP_TYPE == 0.f) ? original_linearStart : renodx::math::FLT16_MAX;
}

#define toe         GetToe()
#define maxNit      GetMaxNit()
#define linearStart GetLinearStart()
#define contrast    GetHighlightContrast()

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

float3 BlendLUTs(float3 color) {
  const float lut_scale = 1.f - fTextureInverseSize;
  const float lut_offset = fTextureInverseSize * 0.5f;
  float3 color_encoded = renodx::color::srgb::Encode(color);

  float3 output;
  if (TONE_MAP_TYPE == 0.f) {
    output = tTextureMap0.SampleLevel(TrilinearClamp, color_encoded * lut_scale + lut_offset, 0.f).rgb;
  } else {
    output = renodx::lut::SampleTetrahedral(tTextureMap0, color_encoded, (uint)fTextureSize).rgb;
  }

  [branch]
  if (fTextureBlendRate > 0.f) {
    float3 lut1;
    if (TONE_MAP_TYPE == 0.f) {
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
  float3 color_output = BlendLUTs(color_input);

  if (COLOR_GRADE_LUT_SCALING > 0.f) {
    float3 lut_black = BlendLUTs(0.f);

    float lut_black_y = renodx::color::y::from::BT709(lut_black);
    if (lut_black_y > 0.f) {
      float3 lut_mid = BlendLUTs(lut_black_y);

      float3 unclamped_gamma = Unclamp(
          renodx::color::srgb::EncodeSafe(color_output),
          renodx::color::srgb::EncodeSafe(lut_black),
          renodx::color::srgb::EncodeSafe(lut_mid),
          renodx::color::srgb::EncodeSafe(color_input));

      float3 unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped_gamma);

      color_output = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, COLOR_GRADE_LUT_SCALING);
    }
  }

  return color_output;
}

void ApplyColorGrading(float r_in, float g_in, float b_in,
                       inout float r_out, inout float g_out, inout float b_out) {
  float3 working_color = float3(r_in, g_in, b_in);

  if ((cPassEnabled & 4) != 0) {
    float compression_scale;
    if (TONE_MAP_TYPE == 0.f) {
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

float3 ApplyCustomGrading(float3 ungraded) {
  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_GAMMA,                                // float gamma;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    RENODX_TONE_MAP_HUE_SHIFT,                            // float hue_emulation_strength_high;
    RENODX_TONE_MAP_BLOWOUT,                              // float chrominance_emulation_strength_high;
    1.f,                                                  // float hue_emulation_strength_low;
    1.f,                                                  // float chrominance_emulation_strength_low;
    0.18f,                                                // float hue_chrominance_ramp_start;
    1.f                                                   // float hue_chrominance_ramp_end;
  };

  float y = renodx::color::y::from::BT709(ungraded);
  // float3 chrominance_hue_reference_color = renodx::color::bt709::from::BT2020(renodx::tonemap::neutwo::PerChannel(renodx::color::bt2020::from::BT709(ungraded) / 3.f) * 3.f);
  float3 chrominance_hue_reference_color = renodx::color::bt709::from::BT2020(renodx::tonemap::ReinhardPiecewise(renodx::color::bt2020::from::BT709(ungraded), 5.f, 1.5f));

  float3 graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, y, cg_config, 0.18f);
  graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded, chrominance_hue_reference_color, y, cg_config);

  return graded;
}

float3 ApplyNeutwoByMaxChannel(float3 input, float peak_white, float diffuse_white, float white_clip = 100.f,
                               float gray_in = 0.18f, float gray_out = 0.18f, float min = 0.f) {
  float max_channel = renodx::math::Max(input);

  float peak_ratio = peak_white / diffuse_white;
  float min_ratio = min / diffuse_white;
  float mapped_peak = renodx::tonemap::Neutwo(max_channel, peak_ratio, white_clip, gray_in, gray_out, min_ratio);
  float scale = renodx::math::DivideSafe(mapped_peak, max_channel, 1.f);
  float3 tonemapped = input * scale;
  return tonemapped;
}

float3 ApplyDisplayMap(float3 untonemapped) {
  const float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  float3 untonemapped_bt2020 = renodx::color::bt2020::from::BT709(untonemapped);

#if GAMUT_COMPRESS == 2
  untonemapped_bt2020 = GamutCompress(untonemapped_bt2020, renodx::color::BT2020_TO_XYZ_MAT);
#endif

  // float3 tonemapped_bt2020 = renodx::tonemap::neutwo::MaxChannel(
  //     max(0, untonemapped_bt2020),
  //     RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 100.f);
  float3 tonemapped_bt2020 = ApplyNeutwoByMaxChannel(
      max(0, untonemapped_bt2020),
      RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS, 100.f, 0.18f, 0.18f, 0.0001f);
  tonemapped_bt2020 = min(peak_ratio, tonemapped_bt2020);

  float3 tonemapped_bt709 = renodx::color::bt709::from::BT2020(tonemapped_bt2020);

  return tonemapped_bt709;
}

float3 ApplyToneMap(float3 untonemapped, float2 texcoord) {
  if (TONE_MAP_TYPE == 0.f) return max(0, untonemapped);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    untonemapped = renodx::color::correct::GammaSafe(untonemapped);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    untonemapped = ApplyGammaCorrectionByLuminance(untonemapped);
  }

#if GAMUT_COMPRESS == 1
  untonemapped = GamutCompress(untonemapped);
  untonemapped = max(0, untonemapped);
#endif

  untonemapped = ApplyCustomGrading(untonemapped);

  float3 tonemapped = ApplyDisplayMap(untonemapped);

  tonemapped = renodx::effects::ApplyFilmGrain(
      tonemapped,
      texcoord,
      CUSTOM_RANDOM,
      CUSTOM_GRAIN_STRENGTH * 0.03f);

  tonemapped *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    tonemapped = renodx::color::correct::GammaSafe(tonemapped, true);
  }

  return tonemapped;
}

