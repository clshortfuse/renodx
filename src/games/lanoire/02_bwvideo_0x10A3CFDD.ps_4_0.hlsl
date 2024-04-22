#include "../../shaders/tonemap.hlsl"
#include "../../shaders/color.hlsl"
#include "./shared.h"

cbuffer dx11_constants : register(b0) {
  float4 consta : packoffset(c0);
  float4 focus : packoffset(c1);
}

SamplerState tex0_s : register(s0);
Texture2D<float4> tex0_t : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex0_t.Sample(tex0_s, v1.xy).wxyz;
  r0.w = 1;
  o0.xyzw = consta.xyzw * r0.xxxw;

  o0 = saturate(o0);
  o0 = injectedData.toneMapGammaCorrection ? pow(o0, 2.2f) : linearFromSRGBA(o0);
  float videoPeak = injectedData.toneMapPeakNits / (injectedData.toneMapGameNits / 203.f);
  o0.rgb = bt2446a_inverse_tonemapping_bt709(o0.rgb, 100.f, videoPeak);
  o0.rgb *= injectedData.toneMapPeakNits / videoPeak;
  o0.rgb /= 80.f;
  return;
}
