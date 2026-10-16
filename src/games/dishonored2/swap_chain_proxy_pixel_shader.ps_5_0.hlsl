#include "./shared.h"

Texture2D<float4> source_texture : register(t0);
SamplerState source_sampler : register(s0);

float4 main(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  float4 color = source_texture.Sample(source_sampler, uv);
  color.rgb = renodx::draw::SwapChainPass(color.rgb, position.xy);
  color.a = 1.f;
  return color;
}
