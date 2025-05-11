#include "./shared.h"

// Unity dithering written by Claude - seems to work though
float3 Dither(float3 color, float2 uv, Texture2D ditherTex, SamplerState ditherSampler, float4 ditherCoords) {
  color = renodx::color::srgb::EncodeSafe(color);
  float2 sampleCoords = uv * ditherCoords.xy + ditherCoords.zw;
  float4 texSample = ditherTex.Sample(ditherSampler, sampleCoords);
  float noise = texSample.w * 2.0 - 1.0;
  float absNoiseComplement = 1.0 - abs(noise);
  float triangleDistribution = 1.0 - sqrt(absNoiseComplement);
  float noiseSign = (noise >= 0.0) ? 1.0 : -1.0;
  noise = noiseSign * triangleDistribution;
  color += noise / 255.0;
  color = renodx::color::srgb::DecodeSafe(color);
  return color;
}

// Sampling lut on NeturalSDR instead of clipped vanilla color
float3 ApplyUserTonemap(float3 ungraded, Texture2D lut_texture, SamplerState lut_sampler, float3 precompute) {
  
  float3 neutral_sdr = renodx::tonemap::renodrt::NeutralSDR(ungraded);
  
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.precompute = precompute;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;

  float3 graded_sdr = renodx::lut::Sample(neutral_sdr, lut_config, lut_texture);

  float3 color = renodx::draw::ToneMapPass(ungraded, graded_sdr,neutral_sdr);

  color = renodx::color::bt709::clamp::BT2020(color);

  color = renodx::draw::RenderIntermediatePass(color);

  return color;
}

// Vanilla tonemapping 
float3 Vanilla(float3 ungraded, Texture2D lut_texture, SamplerState lut_sampler, float3 precompute, float2 uv, Texture2D ditherTex, SamplerState ditherSampler, float4 ditherCoords) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.precompute = precompute;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;

  float3 color = renodx::lut::Sample(saturate(ungraded), lut_config, lut_texture);

  color = Dither(color, uv, ditherTex, ditherSampler, ditherCoords);

  color = renodx::draw::RenderIntermediatePass(color);

  return color;
}

