#include "./shared.h"

float3 ToneMap(float3 untonemapped, float3 tonemapped_bt709, SamplerState lutSampler, Texture2D lut, float3 preCompute) {
  float3 outputColor;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = 1.f;
  lut_config.scaling = 0.f;
  lut_config.precompute = preCompute;
  lut_config.tetrahedral = 1.f;
  lut_config.type_input = renodx::lut::config::type::ARRI_C1000_NO_CUT;
  lut_config.type_output = renodx::lut::config::type::LINEAR;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped = max(0.00001f, untonemapped);  // fixes black squares in somnia

    outputColor = renodx::tonemap::UpgradeToneMap(
    untonemapped,
    renodx::tonemap::renodrt::NeutralSDR(untonemapped),
    renodx::lut::Sample(
        renodx::tonemap::dice::BT709(untonemapped, 1.0f, 0.25f), // better than RenoDRT NeutralSDR
        lut_config, 
        lut), 
    1.f);

    //outputColor = renodx::color::bt709::from::AP1(outputColor);
    //outputColor = renodx::color::correct::Hue(outputColor, tonemapped_bt709, CUSTOM_HUE_CORRECTION, RENODX_TONE_MAP_WORKING_COLOR_SPACE);
    //outputColor = renodx::color::ap1::from::BT709(outputColor);

    outputColor = renodx::draw::ToneMapPass(outputColor);
  } else {
    outputColor = saturate(tonemapped_bt709);
  }

  outputColor = renodx::draw::RenderIntermediatePass(outputColor);

  return outputColor;
}