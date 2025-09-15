#include "./shaders/common.hlsl"
// #include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0) : SV_TARGET {
  float4 color = t0.Sample(s0, uv);
  color = renodx::draw::SwapChainPass(color);
  color = max((float4)0, color); //clamp bad
  // if (CUSTOM_TONEMAP_IDENTIFY == 2) color.xyz = DrawBinary(CALLBACK_TONEMAP_ISDRAWN, color.xyz, uv.xy);

  return color;
}
