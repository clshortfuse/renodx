#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Feb 10 03:26:32 2025

SamplerState g_color_buffer_sampler_s : register(s0);
Texture2D<float4> g_color_buffer_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_color_buffer_texture.Sample(g_color_buffer_sampler_s, v1.xy).xyzw;
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  return;
}