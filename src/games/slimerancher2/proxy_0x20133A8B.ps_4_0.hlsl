// ---- Created with 3Dmigoto v1.3.16 on Tue Oct 07 01:04:21 2025
#include "./shared.h"

SamplerState BlitSampler_s : register(s0);
Texture2D<float4> BlitTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = renodx::draw::SwapChainPass(BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw);
  return;
}