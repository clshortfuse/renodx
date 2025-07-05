#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 03 01:29:41 2025

cbuffer _Globals : register(b0)
{
  float4 sampleWeight0 : packoffset(c0);
  float4 sampleWeight1 : packoffset(c1);
  float2 sampleOffset0 : packoffset(c2);
  float2 sampleOffset1 : packoffset(c2.z);
  float2 sampleOffset2 : packoffset(c3);
  float2 sampleOffset3 : packoffset(c3.z);
  float2 sampleOffset4 : packoffset(c4);
  float2 sampleOffset5 : packoffset(c4.z);
  float2 sampleOffset6 : packoffset(c5);
  float2 sampleOffset7 : packoffset(c5.z);
  float4 extractConst : packoffset(c6);
  float saturation : packoffset(c7);
}

SamplerState textureSampler0_s : register(s0);
Texture2D<float4> textureSampler0Tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  float2 w3 : TEXCOORD5,
  float2 v4 : TEXCOORD6,
  float2 w4 : TEXCOORD7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = textureSampler0Tex.Sample(textureSampler0_s, w1.xy).xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r1.xyz = textureSampler0Tex.Sample(textureSampler0_s, v1.xy).xyz;
  r0.xyz = r1.xyz * float3(0.25,0.25,0.25) + r0.xyz;
  r1.xyz = textureSampler0Tex.Sample(textureSampler0_s, v2.xy).xyz;
  r0.xyz = r1.xyz * float3(0.25,0.25,0.25) + r0.xyz;
  r1.xyz = textureSampler0Tex.Sample(textureSampler0_s, w2.xy).xyz;
  r0.xyz = r1.xyz * float3(0.25,0.25,0.25) + r0.xyz;

  r0.xyz = saturate(-extractConst.xyz + r0.xyz);

  //r0.xyz = -extractConst.xyz + r0.xyz;

  r0.xyz = extractConst.www * r0.xyz;
  r1.xyz = r0.xyz + r0.xyz;
  r0.w = dot(r1.xyz, float3(0.333332986,0.333332986,0.333332986));
  r0.xyz = r0.xyz * float3(2,2,2) + -r0.www;
  o0.xyz = saturation * r0.xyz + r0.www;
  o0.w = 1;

  o0.rgb *= CUSTOM_BLOOM;
  return;
}