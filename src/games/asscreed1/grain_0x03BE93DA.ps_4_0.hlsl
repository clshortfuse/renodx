#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar  1 00:56:39 2025

cbuffer SCB_CommonPostEffect : register(b9) {
  float4 g_MultiplyColor : packoffset(c0);
  float g_MaskFilter[8] : packoffset(c1);
}

SamplerState aTexture_s : register(s0);
Texture2D<float4> texture0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1, -1) + float2(0, 1);

  if (CUSTOM_GRAIN_TYPE == 0.f) {
    r0.xyzw = texture0.Sample(aTexture_s, r0.xy).xyzw;
    o0.xyzw = g_MultiplyColor.xyzw * r0.xyzw;
  } else {  // grain darkens, so blend to 0 with low strength to darken
    o0.rgb = g_MultiplyColor.xyz * 0.025f;
    o0.w = g_MultiplyColor.w * 0.085f;
  }

  return;
}
