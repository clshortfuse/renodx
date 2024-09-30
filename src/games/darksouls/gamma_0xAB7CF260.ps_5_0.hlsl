#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 04 23:18:27 2024

SamplerState g_TextureSampler_s : register(s0);
SamplerState g_GammaTextureSampler_s : register(s1);
Texture2D<float4> g_Texture : register(t0);
Texture1D<float4> g_GammaTexture : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_Position0, float2 v1
          : TEXCOORD0, out float4 o0
          : SV_Target0) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_resource_texture1d (float,float,float,float) t1
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  o0.xyz = g_Texture.Sample(g_TextureSampler_s, v1.xy).xyz;

  o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);
  o0.rgb *= injectedData.toneMapUINits / 80.f;

  // Removed gamma slider as it capped brightness
  // Image is unchanged when set to default 5

  return;
}