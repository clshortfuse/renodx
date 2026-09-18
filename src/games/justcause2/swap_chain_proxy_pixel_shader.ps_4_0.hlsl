#include "./shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0 : register(s0);

float4 main(float4 position : SV_Position, float2 uv : TEXCOORD0) : SV_Target {
  return renodx::draw::SwapChainPass(t0.Sample(s0, uv), position.xy);
}
