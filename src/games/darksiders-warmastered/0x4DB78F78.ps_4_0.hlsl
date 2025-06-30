#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Feb 10 03:01:20 2025

SamplerState g_source_sampler_s : register(s0);
Texture2D<float4> g_source_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = g_source_texture.Sample(g_source_sampler_s, v1.xy).xyzw;
  return;
}