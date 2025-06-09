#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu May 15 12:35:03 2025

cbuffer _Params : register(b0) {
  float ColorTextureMipBias : packoffset(c0);
  float4 DiffuseColor : packoffset(c1);
}

SamplerState ColorSamplerSmp_s : register(s0);
Texture2D<float4> ColorSampler : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0: TEXCOORD0,
    out float4 o0: SV_Target0,
    out float3 o1: SV_Target1) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = ColorSampler.SampleBias(ColorSamplerSmp_s, v0.xy, ColorTextureMipBias).xyzw;
  r0.rgb = saturate(r0.rgb);
  float4 diffuseColor = DiffuseColor;
  if (CUSTOM_LOWER_WHITE_UI) {
    diffuseColor.rgb = renodx::color::gamma::DecodeSafe(diffuseColor.rgb);
    float luminance = renodx::color::y::from::BT709(diffuseColor.rgb);
    float rate = min(3, CUSTOM_UI_HAS_DRAWN + 1);
    if (luminance >= 0.99f) {
      diffuseColor.rgb = diffuseColor.rgb * (1 / rate);
    }
    diffuseColor.rgb = renodx::color::gamma::EncodeSafe(diffuseColor.rgb);
  }
  r0.xyzw = diffuseColor.xyzw * r0.xyzw;

  // o0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
  o0 = r0;
  o0 = saturate(o0);
  o1.xyz = float3(0.5, 0.5, 0.5);
  return;
}
