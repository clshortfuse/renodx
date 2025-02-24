#ifndef SRC_AVOWED_COMMON_HLSL_
#define SRC_AVOWED_COMMON_HLSL_
#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.f;

struct OutputSignature {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

OutputSignature FinalizeLutTonemap(float3 color) {
  OutputSignature output;
  color *= 1.05f;
  output.SV_Target_1 = dot(color.rgb, float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  color = renodx::draw::RenderIntermediatePass(color);

  output.SV_Target = float4(color.rgb, 0.f);
  return output;
}

OutputSignature LutToneMap(float3 untonemapped, float3 lutInput, Texture3D<float4> lut, SamplerState colorGradingLUTSampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::LINEAR;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 1.f;
  lut_config.lut_sampler = colorGradingLUTSampler;

  // lutInput = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
  float3 final = renodx::lut::Sample(
      lutInput,
      lut_config,
      lut);
  final = saturate(final);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    final = renodx::draw::ToneMapPass(untonemapped.rgb, final);
  }

  return FinalizeLutTonemap(final);
}

#endif  // SRC_AVOWED_COMMON_HLSL_
