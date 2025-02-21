#include "./shared.h"

float4 TonemapWithLUT(float3 untonemapped_bt709, SamplerState lut_sampler,
                      Texture3D<float4> lut_texture, float ratio = 1.f) {
  /* float3 neutral_sdr_color = RenoDRTSmoothClamp(untonemapped_bt709);

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      lut_sampler,
      1.f,
      0.f,
      renodx::lut::config::type::GAMMA_2_2,
      renodx::lut::config::type::GAMMA_2_2);
  float3 post_lut_color = renodx::lut::Sample(lut_texture, lut_config, neutral_sdr_color);

  float3 untonemapped_graded = UpgradeToneMapByLuminance(untonemapped_bt709, neutral_sdr_color, post_lut_color, 1.f);
  untonemapped_graded = lerp(untonemapped_bt709, untonemapped_graded, ratio);

  float3 color = ToneMap(untonemapped_graded);
  color = renodx::color::bt709::clamp::BT2020(color);
  color = renodx::color::correct::Gamma(color);
  color = renodx::color::bt2020::from::BT709(color);
  color = renodx::color::pq::Encode(color.rgb, injectedData.toneMapGameNits); */
  /* color = PostToneMapScale(color);
  color *= 1.f / 1.05f; */
  return float4(untonemapped_bt709, 1);
}

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
