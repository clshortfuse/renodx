#include "../common.hlsl"

float4 SampleWithSRGBDecode(Texture2D<float4> texture_input, SamplerState sampler_input, float2 texcoord) {
  float4 color = texture_input.Sample(sampler_input, texcoord);
  color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  return color;
}

float4 SampleLevelWithSRGBDecode(Texture2D<float4> texture_input, SamplerState sampler_input, float2 texcoord, float level) {
  float4 color = texture_input.SampleLevel(sampler_input, texcoord, level);
  color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  return color;
}

float3 WriteWithSRGBEncode(float3 color) {
  color = renodx::color::srgb::EncodeSafe(color);
  return color;
}