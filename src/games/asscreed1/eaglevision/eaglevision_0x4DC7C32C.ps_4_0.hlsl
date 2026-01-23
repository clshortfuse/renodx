#include "../common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar  1 00:56:44 2025

cbuffer SCB_CommonPostEffect : register(b9)
{
  float g_BloomScale : packoffset(c0);
  float g_StarScale : packoffset(c1);
}

SamplerState Source_s : register(s0);
SamplerState BloomFilter_s : register(s1);
SamplerState StarFilter_s : register(s2);
Texture2D<float4> texture0 : register(t0);
Texture2D<float4> texture1 : register(t1);
Texture2D<float4> texture2 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = texture2.Sample(StarFilter_s, v1.xy).xyzw;
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.xyz = g_StarScale * r0.xyz;
  r1.xyzw = texture1.Sample(BloomFilter_s, v1.xy).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.xyz = r1.xyz * g_BloomScale + r0.xyz;
  r1.xyzw = texture0.Sample(Source_s, v1.xy).xyzw;

  r1.rgb = InvertIntermediatePass(r1.rgb);

  o0.xyz = r1.xyz + r0.xyz;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = saturate(o0.rgb);
  }

  o0.rgb = ClampAndRenderIntermediatePass(o0.rgb);

  o0.w = 1;
  return;
}