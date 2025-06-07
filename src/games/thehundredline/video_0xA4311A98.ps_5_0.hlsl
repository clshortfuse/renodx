#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu May 15 12:35:07 2025

cbuffer _Params : register(b0) {
  float4 DiffuseColor : packoffset(c0);
  float4 ColorDegammaValue : packoffset(c1);
}

SamplerState ColorSamplerSmp_s : register(s0);
Texture2D<float4> ColorSampler : register(t0);

// 3Dmigoto declarations
#define cmp -

// Runs as a godray + other stuff
// We only want to adjust the godray aspect
void main(
    float4 v0: TEXCOORD0,
    float4 v1: TEXCOORD1,
    float4 v2: COLOR0,
    float4 v3: SV_POSITION0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = ColorSampler.Sample(ColorSamplerSmp_s, v0.xy).xyzw;
  // r0 = saturate(r0);
  // r0.rgb = renodx::draw::RenderIntermediatePass(r0.rgb);
  r0.xyzw = DiffuseColor.xyzw * r0.xyzw;
  // r0 = saturate(r0);

  r0.xyz = r0.xyz * v2.xyz + float3(9.99999991e-38, 9.99999991e-38, 9.99999991e-38);
  r0.w = v2.w * r0.w;
  o0.w = r0.w;
  /* r0.xyz = log2(r0.xyz);
  r0.xyz = ColorDegammaValue.xyz * r0.xyz;
  o0.xyz = exp2(r0.xyz); */
  o0.rgb = renodx::math::SafePow(r0.rgb, ColorDegammaValue.r);
  if (CUSTOM_VIDEO_HAS_DRAWN == 0.f) {
    o0.rgb = saturate(o0.rgb);
    o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb * 0.25);
  }
  // o0.rgb = saturate(o0.rgb);
  // o0.rgb = renodx::color::correct::GammaSafe(o0.rgb);
  // o0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb);

  /* o0.rgb = saturate(o0.rgb); */
  return;
}
