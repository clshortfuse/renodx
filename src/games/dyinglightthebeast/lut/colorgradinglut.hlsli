#include "../common.hlsli"

#define cmp -

float3 Unclamp(float3 original_gamma, float3 black_gamma,
               float3 black_pivot_gamma, float3 mid_gray_gamma,
               float3 white_gamma, float3 neutral_gamma, float3 neutral_gamma_adjusted) {
  const float3 added_gamma = black_gamma;
  const float3 removed_gamma = 1.f - min(1.f, white_gamma);

  // Remove from 0 to black_pivot
  const float black_pivot_average = (black_pivot_gamma.r + black_pivot_gamma.g + black_pivot_gamma.b) / 3.f;
  const float shadow_length = black_pivot_average;
  const float shadow_stop = max(neutral_gamma_adjusted.r, max(neutral_gamma_adjusted.g, neutral_gamma_adjusted.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  // Add back from mid-gray to 1.f
  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;
  const float highlights_length = 1.f - mid_gray_average;
  const float highlights_stop = 1.f - min(neutral_gamma.r, min(neutral_gamma.g, neutral_gamma.b));
  const float3 ceiling_add = removed_gamma * (max(0, highlights_length - highlights_stop) / highlights_length);

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove) + ceiling_add;
  return unclamped_gamma;
}

float3 SampleLUT(float3 color_input, renodx::lut::Config lut_config, Texture3D lut_texture) {
  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = renodx::lut::SampleColor(lut_input_color, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_white = renodx::lut::SampleColor(renodx::lut::ConvertInput(1.f, lut_config), lut_config, lut_texture);
      float3 lut_mid = renodx::lut::SampleColor(renodx::lut::ConvertInput(0.18f, lut_config), lut_config, lut_texture);
      float3 lut_black_pivot = renodx::lut::SampleColor(renodx::lut::ConvertInput(lut_black_y, lut_config), lut_config, lut_texture);
      float black_shifted = renodx::color::y::from::BT709(renodx::lut::LinearOutput(lut_black_pivot, lut_config));
#if 1
      float lut_shift = (black_shifted + lut_black_y) / black_shifted;
#else
      float lut_shift = (lut_black_y + black_shifted) / lut_black_y;
#endif

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_black_pivot, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::GammaOutput(lut_white, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config),
          renodx::lut::ConvertInput(color_input * lut_shift, lut_config));

      const float scaling_strength = 0.43;

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling * scaling_strength);
      color_output = recolored;
    }
  } else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return lerp(color_input, color_output, lut_config.strength);
}

float3 SampleLUTSRGBInSRGBOut(float3 input, Texture3D<float4> lut_texture, SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = RENODX_COLOR_GRADE_STRENGTH;
  lut_config.scaling = RENODX_COLOR_GRADE_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.size = 32u;
  lut_config.tetrahedral = true;
  lut_config.recolor = 0.f;

  float3 output = SampleLUT(input, lut_config, lut_texture);

  output = renodx::color::bt709::from::BT2020(max(0.f, CorrectOutOfRangeColor(renodx::color::bt2020::from::BT709(output), true, false)));

  return output;
}

float3 ToneMapForLUT(float3 untonemapped) {
  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = ReinhardPiecewiseExtended(y_in, 100.f, 1.f, 0.3f);
  float3 tonemapped = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

  tonemapped = saturate(CorrectOutOfRangeColor(tonemapped, false, true, 1.f, 0.f, 1.f, false));

  return tonemapped;
}

float3 SampleLUTWithHDRUpgrade(float3 input, Texture3D<float4> lut_texture, SamplerState lut_sampler) {
  float3 output = input;
  if (LUT_SAMPLING_METHOD) {
    float3 color_hdr = input;
    float3 color_sdr = ToneMapForLUT(input);
    float3 color_graded = SampleLUTSRGBInSRGBOut(color_sdr, lut_texture, lut_sampler);
    output = renodx::tonemap::UpgradeToneMap(color_hdr, color_sdr, color_graded);
  } else {
    float3 color = input;
    float max_channel = renodx::math::Max(color.r, color.g, color.b);
    max_channel = max(1e-6, max_channel);

    // Soft-knee highlight compression
    float scale;
    const float KNEE = 0.525f;
    const float A = 1.0f / KNEE;     // 1.90476203f
    const float B = 122.0f / 21.0f;  // 5.80952358f
    const float C = 9.0f / 21.0f;    // 0.429761916f
    if (abs(1.0f - max_channel) < KNEE) {
      scale = ((-max_channel * A + B) * max_channel - C) * 0.25f / max_channel;
    } else {
      scale = min(1.0f, max_channel) / max_channel;
    }

    color *= scale;
    color = SampleLUTSRGBInSRGBOut(color, lut_texture, lut_sampler);
    color /= scale;
    output = color;
  }

  return output;
}
