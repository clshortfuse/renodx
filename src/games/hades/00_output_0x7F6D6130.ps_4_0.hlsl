#include "../../shaders/color.hlsl"
#include "./shared.h"

SamplerState Sampler_s : register(s0);
Texture2D<float4> Texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  o0.xyzw = Texture.Sample(Sampler_s, v2.xy).xyzw;
  float3 signs = sign(o0.rgb);
  o0.rgb = abs(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
   
  return;
}