#ifndef SRC_SPACE_MARINE_2_COMMON_H_
#define SRC_SPACE_MARINE_2_COMMON_H_
#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.f;

float3 LutToneMap(float3 untonemapped, Texture3D<float4> lut, SamplerState colorGradingLUTSampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = colorGradingLUTSampler;
  lut_config.size = 32u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::PQ;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;

  float3 final = renodx::lut::Sample(
      renodx::tonemap::renodrt::NeutralSDR(untonemapped),
      lut_config,
      lut);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    final = renodx::draw::ToneMapPass(untonemapped.rgb, final);
  }

  final = renodx::draw::RenderIntermediatePass(final.rgb);
  return final;
}

float3 LutToneMap(float3 untonemapped, float3 lutOutput) {
  float3 final = renodx::color::srgb::DecodeSafe(lutOutput);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    final = renodx::draw::ToneMapPass(untonemapped.rgb, final);
  }

  final = renodx::draw::RenderIntermediatePass(final.rgb);
  return final;
}

#endif  // SRC_SPACE_MARINE_2_COMMON_H_