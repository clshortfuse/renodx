#include "./shared.h"

float3 applyRenoDice(float3 color) {
  const float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  const float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  const float highlightsShoulderStart = paperWhite;

  return renodx::tonemap::dice::BT709(color.rgb * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
}

float3 neutralToneMap(float3 color) {
  [branch]
  if (RENODX_TONE_MAP_TYPE) {
    color = renodx::tonemap::renodrt::NeutralSDR(color);
  }

  return color;
}

float3 applyToneMapScaling(float3 untonemapped, float3 graded) {
  float3 color = graded;

  [branch]
  if (RENODX_TONE_MAP_TYPE) {
    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.peak_white_nits = 10000.f;
    draw_config.tone_map_type = 3.f;

    color = renodx::draw::ToneMapPass(untonemapped, color, draw_config);

    color = applyRenoDice(color);
  } else {
    color = saturate(color);
  }

  return renodx::draw::RenderIntermediatePass(color);
}

float3 lutSample(float3 color, SamplerState colorGradingLUTSampler, Texture3D<float4> lut) {
  color = neutralToneMap(color);

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f || (CUSTOM_LUT_STRENGTH == 1.f && CUSTOM_LUT_SCALING == 0.f && CUSTOM_LUT_TETRAHEDRAL == 0.f)) {
    color = renodx::color::srgb::EncodeSafe(color);

    color = color * float3(0.9375, 0.9375, 0.9375) + float3(0.03125, 0.03125, 0.03125);
    color = lut.Sample(colorGradingLUTSampler, color).xyz;
  } else {
    renodx::lut::Config lut_config = renodx::lut::config::Create();
    lut_config.lut_sampler = colorGradingLUTSampler;
    lut_config.size = 16u;
    lut_config.strength = CUSTOM_LUT_STRENGTH;
    lut_config.scaling = CUSTOM_LUT_SCALING;
    lut_config.type_input = renodx::lut::config::type::SRGB;
    lut_config.type_output = renodx::lut::config::type::LINEAR;
    lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL;

    color = renodx::lut::Sample(lut, lut_config, color);
  }

  return color;
}