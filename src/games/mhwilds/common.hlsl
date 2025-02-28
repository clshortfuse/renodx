#ifndef SRC_MHWILDS_COMMON_HLSL_
#define SRC_MHWILDS_COMMON_HLSL_
#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.f;

struct OutputSignature {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

float3 FinalizeLutTonemap(float3 color) {
  color = renodx::draw::SwapChainPass(color);

  return color;
}

float3 LutToneMap(float3 untonemapped, Texture3D<float4> lut, SamplerState colorGradingLUTSampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = false;
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::PQ;
  lut_config.scaling = 0.f;
  lut_config.lut_sampler = colorGradingLUTSampler;

  // float3 lutInput = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
  float3 final = renodx::lut::Sample(
      untonemapped,
      lut_config,
      lut);
  // final = saturate(final);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    final = renodx::draw::ToneMapPass(untonemapped.rgb);
  }
  // final = renodx::draw::ToneMapPass(untonemapped.rgb, final);

  return FinalizeLutTonemap(final);
}

#endif  // SRC_MHWILDS_COMMON_HLSL_
