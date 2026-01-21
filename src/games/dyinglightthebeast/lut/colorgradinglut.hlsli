#include "../common.hlsli"

#define cmp -

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = renodx::math::Average(mid_gray_gamma);

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = renodx::math::Max(neutral_gamma);
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 SampleLUT(Texture3D lut_texture, renodx::lut::Config lut_config, float3 color_input) {
  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lutBlackLinear = renodx::lut::LinearOutput(lutBlack, lut_config);
    float lutBlackY = max(0, renodx::color::y::from::BT709(lutBlackLinear));

    if (lutBlackY > 0.f) {
      float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_config, lut_texture);
#if 1
      lutBlack = renodx::lut::ConvertInput(renodx::color::correct::Gamma(lutBlackLinear), lut_config);
      lutMid = renodx::lut::ConvertInput(renodx::color::gamma::Decode(lutMid), lut_config);
      lutOutputColor = renodx::lut::ConvertInput(renodx::color::gamma::Decode(lutOutputColor), lut_config);
      lutInputColor = renodx::lut::ConvertInput(renodx::color::correct::Gamma(color_input), lut_config);
#endif

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lutOutputColor, lut_config),
          renodx::lut::GammaOutput(lutBlack, lut_config),
          renodx::lut::GammaOutput(lutMid, lut_config),
          renodx::lut::GammaInput(color_input, lutInputColor, lut_config));
      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

#if 1
      unclamped_linear = renodx::color::correct::GammaSafe(unclamped_linear, true);
#endif

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      recolored = GamutCompress(recolored);
      recolored = max(0, recolored);
      color_output = recolored;
    }
  } else {
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
  lut_config.gamut_compress = 0.f;
  lut_config.max_channel = 0.f;

  float3 output = SampleLUT(lut_texture, lut_config, input);

  return output;
}

float3 SampleLUTWithHDRUpgrade(float3 input, Texture3D<float4> lut_texture, SamplerState lut_sampler) {
  float3 output = input;
  float3 color = input;

  // Soft-knee highlight compression
  float scale;
  if (LUT_SAMPLING_METHOD == 0.f) {
    float max_channel = max(1e-6, renodx::math::Max(color));
    const float KNEE = 0.525f;
    const float A = 1.0f / KNEE;     // 1.90476203f
    const float B = 122.0f / 21.0f;  // 5.80952358f
    const float C = 9.0f / 21.0f;    // 0.429761916f
    if (abs(1.0f - max_channel) < KNEE) {
      scale = ((-max_channel * A + B) * max_channel - C) * 0.25f / max_channel;
    } else {
      scale = min(1.0f, max_channel) / max_channel;
    }
  } else {
    scale = ComputeReinhardSmoothClampScale(input, 0.18f);
  }

  color *= scale;
  color = SampleLUTSRGBInSRGBOut(color, lut_texture, lut_sampler);
  color /= scale;
  output = color;

  return output;
}
