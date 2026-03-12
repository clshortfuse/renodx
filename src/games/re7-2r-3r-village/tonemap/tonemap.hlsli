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

      color_output = color_output_original * lerp(1.f, renodx::math::DivideSafe(LuminosityFromBT709(unclamped_linear), LuminosityFromBT709(color_output_original), 1.f), COLOR_GRADE_LUT_SCALING);
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

float3 ApplyUserGradingAndToneMap(float3 color_bt709, float2 grain_uv) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return color_bt709;

  color_bt709 = ApplyGammaCorrection(color_bt709);

  {  // blow out and hue shift
    float3 purity_and_hue_source = renodx::tonemap::ReinhardPiecewise(color_bt709, 5.f, 1.5f);
    color_bt709 = renodx::color::correct::Luminance(purity_and_hue_source, LuminosityFromBT709(purity_and_hue_source), LuminosityFromBT709(color_bt709));
  }

  float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);
  color_bt2020 = ApplyCustomGrading(color_bt2020);
  color_bt2020 = renodx::tonemap::neutwo::MaxChannel(color_bt2020, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
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
