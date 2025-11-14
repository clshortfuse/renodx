#ifndef COLORGRADING_LUT_HLSLI
#define COLORGRADING_LUT_HLSLI

#include "./CBuffers_LUTbuilder.hlsli"

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_GENERATOR(T)                                                                            \
  T ExponentialRollOffExtended(T input, float rolloff_start = 0.20f, float output_max = 1.f, float clip = 100.f) { \
    T rolloff_size = output_max - rolloff_start;                                                                   \
    T overage = -max((T)0, input - rolloff_start);                                                                 \
    T clip_size = rolloff_start - clip;                                                                            \
    T rolloff_value = (T)1.0f - exp(overage / rolloff_size);                                                       \
    T clip_value = (T)1.0f - exp(clip_size / rolloff_size);                                                        \
    T new_overage = mad(rolloff_size, rolloff_value / clip_value, overage);                                        \
    return input + new_overage;                                                                                    \
  }
EXPONENTIALROLLOFF_GENERATOR(float)
EXPONENTIALROLLOFF_GENERATOR(float3)
#undef EXPONENTIALROLLOFF_GENERATOR

/// Applies Exponential Roll-Off Extended tonemapping by luminance.
float3 LUTToneMap(float3 untonemapped, float rolloff_start = 0.5f, float output_max = 1.f) {
  float white_clip = (RENODX_TONE_MAP_TYPE == 1.f) ? 100.f : RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = exp2(ExponentialRollOffExtended(
      log2(y_in),
      log2(rolloff_start),
      log2(output_max),
      log2(white_clip)));
  float3 tonemapped = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

  return tonemapped;
}

float3 ComputeGamutCompressionScaleAndCompress(float3 color_linear, inout float gamut_compression_scale) {
  if (RENODX_TONE_MAP_TYPE == 4 || CUSTOM_LUT_GAMUT_RESTORATION == 0.f) return color_linear;

  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(color_linear, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::Encode(renodx::color::y::from::BT709(color_linear), MID_GRAY_GAMMA);

  gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(encoded, encoded_gray);

  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray, gamut_compression_scale);

  return renodx::color::gamma::DecodeSafe(compressed, MID_GRAY_GAMMA);
}

float3 GamutDecompress(float3 color_linear, float gamut_compression_scale) {
  if (RENODX_TONE_MAP_TYPE == 4 || CUSTOM_LUT_GAMUT_RESTORATION == 0.f || gamut_compression_scale == 1.f) return color_linear;

  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(color_linear, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::Encode(renodx::color::y::from::BT709(color_linear), MID_GRAY_GAMMA);

  float3 decompressed = renodx::color::correct::GamutDecompress(encoded, encoded_gray, gamut_compression_scale);

  return renodx::color::gamma::DecodeSafe(decompressed, MID_GRAY_GAMMA);
}

float3 ComputeMaxChannelScaleAndCompress(float3 color_srgb, inout float channel_compression_scale) {
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    channel_compression_scale = renodx::math::Max(color_srgb.r, color_srgb.g, color_srgb.b, 1.f);
    color_srgb /= channel_compression_scale;
  }
  return color_srgb;
}

float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture) {
  float max_channel = 1.f;
  {
    color_srgb = ComputeMaxChannelScaleAndCompress(color_srgb, max_channel);
  }

  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float _992 = (((lerp(_966.x, _973.x, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.r));
  float _993 = (((lerp(_966.y, _973.y, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.g));
  float _994 = (((lerp(_966.z, _973.z, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.b));

  float3 lutted_srgb = float3(_992, _993, _994);

  {
    lutted_srgb *= max_channel;
  }

  return lutted_srgb;
}

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

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;

  float gamut_compression_scale = 1.f;
  {
    color_input = ComputeGamutCompressionScaleAndCompress(color_input, gamut_compression_scale);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = SamplePacked1DLut(lut_input_color, lut_config.lut_sampler, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);

  color_output = GamutDecompress(color_output, gamut_compression_scale);

  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = SamplePacked1DLut(float3(0, 0, 0), lut_config.lut_sampler, lut_texture);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
#if 0
      if (OVERRIDE_BLACK_CLIP) {
        float target_black_nits = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;
        if (RENODX_GAMMA_CORRECTION) target_black_nits = renodx::color::correct::Gamma(target_black_nits, true);
        lut_black_linear += target_black_nits;
      }
#endif

      // set lut_mid based on lut_black_linear to target shadows more
      float3 lut_mid = SamplePacked1DLut(lut_black, lut_config.lut_sampler, lut_texture);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(lut_black_linear), lut_config);
        lut_mid = renodx::lut::ConvertInput(renodx::color::correct::GammaSafe(renodx::lut::LinearOutput(lut_mid, lut_config)), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
      }

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = LUTToneMap(color_lut_input);
    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);

  } else {
    color_output = renodx::color::srgb::DecodeSafe(SamplePacked1DLut(renodx::color::srgb::Encode(saturate(color_lut_input)), lut_sampler, lut_texture));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

#endif  // COLORGRADING_LUT_HLSLI
