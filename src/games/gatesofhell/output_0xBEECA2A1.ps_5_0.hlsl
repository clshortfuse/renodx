#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Sep 22 12:21:11 2025

cbuffer color_tune1 : register(b0)
{
  float3 colorTone : packoffset(c11);
  float gamma : packoffset(c10);
  float brightness : packoffset(c10.y);
  float contrast : packoffset(c10.z);
  float saturation : packoffset(c10.w);
  float minRange : packoffset(c38);
  float4 shadeTone : packoffset(c22);
}

SamplerState bilinear_Sampler_s : register(s0);
Texture2D<float4> hdrScene_Buffer : register(t0);
Texture2D<float4> bezierCurveLUT_Buffer : register(t3);
Texture2D<float4> histogramMetaData_Buffer : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = histogramMetaData_Buffer.Load(float4(2,0,0,0)).x;
  r0.x = max(minRange, r0.x);
  r0.y = histogramMetaData_Buffer.Load(float4(3,0,0,0)).x;
  r0.y = 0.300000012 + r0.y;
  r0.y = max(minRange, r0.y);
  r0.x = r0.x + -r0.y;
  r0.z = max(0, r0.x);
  r0.z = -4 * r0.z;
  r0.z = exp2(r0.z);
  r0.x = r0.z * r0.x + r0.y;
  r0.x = r0.x * r0.x;
  r1.xyzw = hdrScene_Buffer.Sample(bilinear_Sampler_s, v1.xy).xyzw;

  const float3 untonemapped = r1.xyzw;

  r0.y = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.x = r0.y / r0.x;
  r0.xz = float2(1,1) + r0.xy;
  r0.x = r0.y * r0.x;
  r0.y = max(0.00100000005, r0.y);
  r2.x = r0.x / r0.z;
  r2.y = 0.5;
  r0.x = bezierCurveLUT_Buffer.Sample(bilinear_Sampler_s, r2.xy).x;
  r0.x = r0.x / r0.y;
  r0.xyz = r1.xyz * r0.xxx + float3(-0.5,-0.5,-0.5);
  o0.w = r1.w;
  r0.xyz = r0.xyz * contrast + float3(0.5,0.5,0.5);
  r0.xyz = brightness * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.w = 1 / gamma;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = colorTone.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = saturation * r0.xyz + r0.www;
  r0.w = dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r1.xyz = r0.www * shadeTone.xyz + -r0.xyz;
  o0.xyz = shadeTone.www * r1.xyz + r0.xyz;

  float3 graded_sdr = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.rgb = renodx::draw::ToneMapPass(untonemapped, graded_sdr);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}