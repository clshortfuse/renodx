#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 10:33:37 2025

cbuffer vector_register_block : register(b0)
{
  float3 gBloomScale : packoffset(c0);
  float4 gColorCorrectACParameter[3] : packoffset(c1);
  float4 gColorCorrectSecondaryACParameter[3] : packoffset(c4);
  float4 gColorCorrectSecondaryMaskAdjust : packoffset(c7);
}

SamplerState gScreenSampler_SamplerState_s : register(s0);
SamplerState gBloomEffectIuminous_SamplerState_s : register(s1);
Texture2D<float4> gScreenSampler_Texture : register(t0);
Texture2D<float4> gBloomEffectIuminous_Texture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = gBloomEffectIuminous_Texture.Sample(gBloomEffectIuminous_SamplerState_s, v1.xy).xyz;
  r1.xyzw = gScreenSampler_Texture.Sample(gScreenSampler_SamplerState_s, v1.xy).xyzw;
  o0.xyz = r0.xyz * gBloomScale.xyz + r1.xyz;
  o0.w = r1.w;

  o0.rgb = ApplyToneMap(o0.rgb);

  return;
}