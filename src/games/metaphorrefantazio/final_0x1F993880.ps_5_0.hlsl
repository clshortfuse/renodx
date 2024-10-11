// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 26 18:25:17 2024
#include "./shared.h"

cbuffer GFD_PSCONST_2D : register(b7) {
  float alphaKillThreshold : packoffset(c0);
  float gamma : packoffset(c0.y);
}

SamplerState diffuseSampler_s : register(s0);
Texture2D<float4> diffuseTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_POSITION0, float2 v1
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;
  float4 color;

  r0.xyzw = diffuseTexture.Sample(diffuseSampler_s, v1.xy).xyzw;
  color = r0;

  /* r0.xyz = max(float3(0, 0, 0), r0.xyz); // rec709 clamp
  o0.w = r0.w; */

  // Disable gamma adjust
  /* r0.xyz = log2(r0.xyz);
  r0.xyz = gamma * r0.xyz;
  o0.xyz = exp2(r0.xyz); */

  if (injectedData.toneMapType == 0.f) {
    color.rgb = max(float3(0, 0, 0), color.rgb);
  }

  if (injectedData.toneMapGammaCorrection) {
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
  }

  color.rgb *= injectedData.toneMapUINits / 80.f;

  o0 = color;
  return;
}
