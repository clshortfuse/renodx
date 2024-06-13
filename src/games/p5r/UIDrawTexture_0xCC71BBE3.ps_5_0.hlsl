#include "./p5r.h"

SamplerState diffuseSampler_s : register(s0);
Texture2D<float4> diffuseTexture : register(t0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0 = diffuseTexture.Sample(diffuseSampler_s, v2.xy);
  r0 = r0 * v1;
  
  o0 = r0;
  
  return;
}
