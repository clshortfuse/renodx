#include "./shared.h"

Texture2D<float4> source_texture : register(t0);
SamplerState source_sampler : register(s0);

float4 main(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  float4 source = source_texture.Sample(source_sampler, uv);
  float3 bt709_nits = source.rgb * 80.f;
  float3 bt2020_nits = renodx::color::bt2020::from::BT709(bt709_nits);
  return float4(renodx::color::pq::EncodeSafe(bt2020_nits, 1.f), source.a);
}