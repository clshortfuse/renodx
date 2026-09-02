// Thin RenoDX swapchain proxy pixel shader shape.
// Use only after the resource chain proves the sampled input is a preserved
// float/intermediate scene signal, not the completed SDR backbuffer.
// High-quality game addons keep this shader thin and get SwapChainPass config
// from shared.h / the injected swapchain output preset cbuffer.

#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float4 main(float4 vpos : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  return renodx::draw::SwapChainPass(t0.Sample(s0, uv));
}