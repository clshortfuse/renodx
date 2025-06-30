#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb 11 06:46:37 2025

SamplerState pDiffuseMap_sampler_s : register(s0);
Texture2D<float4> pDiffuseMap_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : COLOR0,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = pDiffuseMap_texture.Sample(pDiffuseMap_sampler_s, v0.xy).xyzw;
  r0.w = v1.w * r0.w;
  r1.x = cmp(r0.w < 0.00100000005);
  if (r1.x != 0) discard;
  o0.xyz = v1.xyz * r0.xyz;
  o0.w = r0.w;
  return;
}