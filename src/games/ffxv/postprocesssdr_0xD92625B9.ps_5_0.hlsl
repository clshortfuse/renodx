// ---- Created with 3Dmigoto v1.3.16 on Thu May 29 18:38:16 2025

cbuffer _Globals : register(b0)
{
  float gamma : packoffset(c0);
  float pqScale : packoffset(c0.y);
}

SamplerState samplerSrc0_s : register(s0);
Texture2D<float4> samplerSrc0Texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = samplerSrc0Texture.Sample(samplerSrc0_s, v1.xy).xyzw;
  r0.xyz = log2(r0.xyz);
  o0.w = r0.w;
  r0.xyz = gamma * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  return;
}