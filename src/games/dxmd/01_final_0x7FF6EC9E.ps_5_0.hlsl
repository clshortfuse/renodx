#include "../../shaders/color.hlsl"
#include "./shared.h"

cbuffer FlipConstantBuffer : register(b0) {
  float4 gamma : packoffset(c0);
}

SamplerState g_Sampler_s : register(s0);
Texture2D<float4> g_InputTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  // gamma.y = 1.f;
  // gamma.x = 1.f;
  const float4 inputColor = g_InputTexture.Sample(g_Sampler_s, v1.xy).xyzw;
  float4 r0 = inputColor;

  // Game Brightness =
  float3 signs = sign(r0.xyz);
  r0.rgb = pow(abs(r0.xyz), gamma.y);
  r0.rgb *= gamma.x;  // gain
  o0.rgb = r0.rgb;
  o0.rgb = injectedData.toneMapGammaCorrection
           ? pow(o0.rgb, 2.2f)
           : linearFromSRGB(o0.rgb);
  o0.rgb *= signs;

  o0.rgb *= injectedData.toneMapUINits / 80.f;
  o0.w = 1;
  return;
}
