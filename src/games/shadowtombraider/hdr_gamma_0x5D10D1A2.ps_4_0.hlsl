#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 03 06:54:22 2024

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

  r0.xyz = g_InputTexture.Sample(g_Sampler_s, v1.xy).xyz;
  if (RENODX_TONE_MAP_TYPE == 0) {
    r0.rgb = renodx::math::SignPow(r0.rgb, gamma.y);  // in game brightness slider
    r0.xyz = gamma.xxx * r0.xyz;                      // doesn't seem to apply in HDR
  }

  o0.rgb = r0.rgb;
  o0.w = 1;
  return;
}
