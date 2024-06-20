#include "./shared.h"

SamplerState diffuseSampler_s : register(s0);
Texture2D<float4> diffuseTexture : register(t0);

float4 main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float2 v2 : TEXCOORD0) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;

  float4 o0 = diffuseTexture.SampleLevel(diffuseSampler_s, v2.xy, 1) * v1;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
