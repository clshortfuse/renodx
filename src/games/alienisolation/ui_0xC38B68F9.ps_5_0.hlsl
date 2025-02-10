#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 01:30:32 2024

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = tex.Sample(sampler_tex_s, v0.xy).x;
  o0.w = v1.w * r0.x;
  o0.xyz = v1.xyz;

  o0 = UIScale(o0);
  return;
}