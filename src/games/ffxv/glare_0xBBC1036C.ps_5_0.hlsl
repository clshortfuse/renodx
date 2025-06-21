// ---- Created with 3Dmigoto v1.3.16 on Wed May 28 12:53:51 2025
#include "shared.h"
cbuffer _Globals : register(b0)
{
  float4 graph_color : packoffset(c0);
  float3 copy_srcColorFactor : packoffset(c1);
  float3 copy_srcColorFactorArray[11] : packoffset(c2);
  float3 highpass_gamma : packoffset(c13);
  float2 highpass_pixelOffset : packoffset(c14);
  float3 highpass_threshold : packoffset(c15);
  float2 gauss_minUV : packoffset(c16);
  float2 gauss_maxUV : packoffset(c16.z);
  float3 gauss_mix : packoffset(c17);
  float4 gauss_weights[65] : packoffset(c18);
  float2 gauss_offsets[65] : packoffset(c83);
  float3 compo_sparkBlend : packoffset(c148);
  float3 compo_oneMinusSparkBlend : packoffset(c149);
  float3 compo_glareGamma : packoffset(c150);
  float4 compo_glareWeights[11] : packoffset(c151);
  float4 compo_glareWeightsSumInv : packoffset(c162);
  float compo_glareBaseBlurMip : packoffset(c163);
  float3 compo_glareSoftAmount : packoffset(c163.y);
  float3 compo_glareSoftExpand : packoffset(c164);
  float3 compo_glareFoggyAmount : packoffset(c165);
  float3 compo_glareFoggyExpand : packoffset(c166);
  float4 compo_vignetteParam0 : packoffset(c167);
  float4 compo_vignetteParam1 : packoffset(c168);
  float4 compo_vignetteParam2 : packoffset(c169);
}

SamplerState srcSampler_s : register(s0);
Texture2D<float4> compo_glareSamplerTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = compo_glareSamplerTexture.SampleLevel(srcSampler_s, v1.xy, 0).xyz;
  r0.xyz = compo_glareWeights[1].xyz * r0.xyz;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = compo_glareGamma.xyz * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(renodx::math::SignPow(r0.x, compo_glareGamma.x), renodx::math::SignPow(r0.y, compo_glareGamma.y), renodx::math::SignPow(r0.z, compo_glareGamma.z));
  r0.xyz = compo_glareWeightsSumInv.xyz * r0.xyz;
  r0.w = dot(w1.xy, w1.xy);
  r0.w = r0.w * compo_vignetteParam2.y + compo_vignetteParam2.z;
  r0.w = compo_vignetteParam2.z / r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * compo_vignetteParam2.x + -compo_vignetteParam2.x;
  r1.xyz = r0.www * compo_vignetteParam1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  o1.xyz = compo_glareWeightsSumInv.xyz * r1.xyz;
  o0.w = 0;
  o1.w = 0;
  return;
}