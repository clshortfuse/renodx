#include "./shared.h"

[[vk::binding(0, 0)]]
Texture2D t0 : register(t0);
[[vk::binding(1, 0)]]
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  return renodx::draw::SwapChainPass(t0.Sample(s0, uv));
}
