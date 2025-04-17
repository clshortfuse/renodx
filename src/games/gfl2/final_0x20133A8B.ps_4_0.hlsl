#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.2 on Sun Mar 23 02:40:52 2025

SamplerState BlitSampler_s : register(s0);
Texture2D<float4> BlitTexture : register(t0);


// 3Dmigoto declarations
#define cmp -
//Texture1D<float4> IniParams : register(t120);
//Texture2D<float4> StereoParams : register(t125);


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw;
  o0.rgb = renodx::draw::SwapChainPass(o0.rgb);
  return;
}