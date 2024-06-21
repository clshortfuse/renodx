#include "../../shaders/color.hlsl"
#include "./shared.h"

SamplerState diffuseSampler_s : register(s0);
Texture2D<float4> diffuseTexture : register(t0);

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = diffuseTexture.Sample(diffuseSampler_s, v1.xy).xyzw;
  o0.xyzw = r0.xyzw;
  o0.a = 1.f;
  return;
}
