#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul 23 17:30:06 2025

SamplerState SceneColorTextureSampler_s : register(s0);
SamplerState FinalTextureSampler_s : register(s1);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> FinalTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SceneColorTexture.Sample(SceneColorTextureSampler_s, v0.xy).xyzw;
  r1.xyzw = FinalTexture.Sample(FinalTextureSampler_s, v0.xy).xyzw;
  o0.xyzw = r0.xyzw + (r1.xyzw * CUSTOM_FLARE_OUT);
  return;
}