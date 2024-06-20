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
  // o0 = clamp(o0, -125.f, 125.f);
  o0.rgb = mul(BT709_2_AP1_MAT, o0.rgb);  // Convert to AP1
  o0.rgb = max(0, o0.rgb);                // Clamp to AP1
  o0.rgb = mul(AP1_2_BT709_MAT, o0.rgb);  // Convert BT709

  o0.a = 1.f;
  return;
}
