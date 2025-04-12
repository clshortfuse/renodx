#include "./shared.h"

float3 Tonemap(float3 untonemapped, float3 final) {
  /* renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = colorGradingLUTSampler;
  lut_config.size = 32u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::PQ;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;

  float3 final = renodx::lut::Sample(
      renodx::tonemap::renodrt::NeutralSDR(untonemapped),
      lut_config,
      lut); */
  final = renodx::color::srgb::DecodeSafe(final);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    final = renodx::draw::ToneMapPass(untonemapped.rgb, final);
  }

  // untonemapped = renodx::color::bt709::from::AP1(untonemapped);
  final = renodx::draw::RenderIntermediatePass(final.rgb);
  return final;
}
