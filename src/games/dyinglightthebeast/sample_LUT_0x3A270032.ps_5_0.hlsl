#include "./common.hlsli"

Texture3D<float4> texture_LUT : register(t1);

Texture2D<float4> texture_scene : register(t0);

SamplerState sampler_LUT : register(s0);

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float3 untonemapped = texture_scene.Load(int3((uint2)v0.xy, 0u)).xyz;

  float3 lut_input_color = untonemapped;
  if (RENODX_LUT_SHAPER != 0.f) {
    lut_input_color = renodx::color::pq::EncodeSafe(untonemapped, 100.f);
  } else {
    lut_input_color = (log2(untonemapped) + 13) * 0.05f;
  }

  float3 tonemapped = texture_LUT.SampleLevel(sampler_LUT, lut_input_color * 0.96875f + 0.015625f, 0).xyz;
  o0.rgb = renodx::color::pq::DecodeSafe(tonemapped, 1.f);

  o0.w = 0;
  return;
}
