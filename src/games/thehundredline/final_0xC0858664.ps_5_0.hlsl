#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu May 15 12:35:07 2025

cbuffer _Params : register(b0)
{
  float Exposure : packoffset(c0);
  float Gamma : packoffset(c0.y);
  float Contrast : packoffset(c0.z);
}

SamplerState ColorSamplerSmp_s : register(s0);
Texture2D<float4> ColorSampler : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = ColorSampler.Sample(ColorSamplerSmp_s, v0.xy).xyz;
  float3 output = r0.rgb;

  r0.xyz = float3(5.55555534,5.55555534,5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = Contrast * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007,0.180000007,0.180000007) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.w = 1 / Gamma;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  o0.xyz = Exposure * r0.xyz;

  o0.rgb = output;
  o0.w = 1;
  return;
}