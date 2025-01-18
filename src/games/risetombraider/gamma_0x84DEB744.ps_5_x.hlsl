#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jan 17 16:14:28 2025

cbuffer FlipConstantBuffer : register(b0) {
  float4 gamma : packoffset(c0);
}

SamplerState g_Sampler_s : register(s0);
Texture2D<float4> g_InputTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_InputTexture.Sample(g_Sampler_s, v1.xy).xyzw;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = gamma.yyy * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // o0.xyz = saturate(gamma.xxx * r0.xyz);
  o0.xyz = renodx::math::SignPow(r0.xyz, gamma.y);
  o0.xyz = gamma.xxx * r0.xyz;
  o0.w = 1;

  if (CUSTOM_IS_SWAPCHAIN_WRITE) {
    o0.rgb = renodx::draw::SwapChainPass(r0.rgb);
  }
  return;
}
