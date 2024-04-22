#include "../../common/color.hlsl"
#include "./shared.h"

SamplerState Sampler0_s : register(s0);
Texture2D<float4> Tex0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : CLIP_SPACE_POSITION0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = Tex0.Sample(Sampler0_s, v2.xy).xyzw;
  o0 = saturate(o0);
  o0 = injectedData.toneMapGammaCorrection ? pow(o0, 2.2f) : linearFromSRGBA(o0);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}