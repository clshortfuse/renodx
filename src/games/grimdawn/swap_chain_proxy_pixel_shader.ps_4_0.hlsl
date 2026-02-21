#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 outputColor = t0.Sample(s0, uv);
  // outputColor.w = saturate(outputColor.w);
  outputColor.w = 1.f;
  return renodx::draw::SwapChainPass(outputColor, uv);
}
