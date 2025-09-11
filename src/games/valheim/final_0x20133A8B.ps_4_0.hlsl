#include "./shared.h"


SamplerState BlitSampler_s : register(s0);
Texture2D<float4> BlitTexture : register(t0);

void main(
    float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  o0.xyzw = BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw;
  o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);
  o0.rgb = renodx::draw::SwapChainPass(o0.rgb);
  return;
}

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 29 15:53:29 2025
// // 3Dmigoto declarations
// #define cmp -


// void main(
//   float2 v0 : TEXCOORD0,
//   float4 v1 : SV_POSITION0,
//   out float4 o0 : SV_Target0)
// {
//   o0.xyzw = BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw;
//   return;
// }