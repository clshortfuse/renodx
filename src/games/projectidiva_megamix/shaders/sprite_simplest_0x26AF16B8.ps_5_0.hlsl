// ---- Created with 3Dmigoto v1.3.16 on Mon Sep 01 02:43:29 2025
#include "./common.hlsl"

SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  if (!CUSTOM_SPRITES_DRAW) discard;

  o0.xyzw = g_texture.Sample(g_sampler_s, v1.xy).xyzw;
  o0 = max((float4)0, o0);
  return;
}