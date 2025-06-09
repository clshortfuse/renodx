#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 01:30:33 2024

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = tex.Sample(sampler_tex_s, v0.xy).xyzw;

  o0 = UIScale(o0);
  return;
}