#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 outputColor = t0.Sample(s0, uv);
  //outputColor.rgb = renodx::color::bt709::clamp::BT2020(outputColor.rgb);
  return renodx::draw::SwapChainPass(outputColor);
}
