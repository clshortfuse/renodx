#include "../../shaders/color.hlsl"
#include "./shared.h"

SamplerState diffuseSampler_s : register(s0);
Texture2D<float4> diffuseTexture : register(t0);

float4 main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float2 v2 : TEXCOORD0) : SV_TARGET0 {
  if (injectedData.uiState == UI_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.uiState == UI_STATE__MAX_ALPHA) return 0.f;

  return diffuseTexture.SampleLevel(diffuseSampler_s, v2.xy, 1) * v1;
}
