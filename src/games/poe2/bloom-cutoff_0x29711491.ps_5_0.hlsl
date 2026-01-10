// ---- Created with 3Dmigoto v1.4.1 on Wed Dec  3 06:20:11 2025
// Contrast-aware pass: samples scene color, measures average brightness, and
// applies a gain only above a configurable threshold to avoid washing out
// shadows.
#include "shared.h"
Texture2D<float4> t0 : register(t0);

SamplerState s11_s : register(s11);

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Build UV from viewport size and optional scaling/offset contained in cb0[1].
  r0.xy = asint(cb0[0].xy);
  r0.xy = float2(1,1) / r0.xy;
  r0.xy = v0.xy * r0.xy;
  r0.xy = cb0[1].xy * r0.xy;
  r0.xyzw = t0.SampleLevel(s11_s, r0.xy, 0).xyzw;

  // Vanilla
  float avg_luminance = dot(r0.xyz, float3(1,1,1)) * 0.333333343;
  float vanilla_mask = cb0[0].w * max(0.0, avg_luminance - cb0[0].z);
  float3 vanilla_rgb = r0.xyz * vanilla_mask;

  // To reduce flicker.
  const float3 luma_weights = float3(0.299000025, 0.587000012, 0.114000000);
  float luminance = dot(r0.xyz, luma_weights);
  float threshold = cb0[0].z;
  float gain = cb0[0].w;
  float normalized = saturate((luminance - threshold) / max(threshold + 1e-05, 1e-03));
  float soft_mask = smoothstep(0.0, 1.0, normalized);
  float bloom_factor = saturate(gain * soft_mask);
  float3 enhanced_rgb = bloom_factor.xxx * r0.xyz;

  float use_enhanced = step(0.5f, CUSTOM_BLOOM_MODE);
  o0.xyz = lerp(vanilla_rgb, enhanced_rgb, use_enhanced);
  o0.w = r0.w;
  return;
}