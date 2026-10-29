#include "./shared.h"

[[vk::binding(0, 0)]]
Texture2D source_texture;
[[vk::binding(1, 0)]]
SamplerState source_sampler;

float4 main([[vk::location(0)]] float2 uv: TEXCOORD0) : SV_Target {
  return renodx::draw::SwapChainPass(source_texture.Sample(source_sampler, uv));
}
