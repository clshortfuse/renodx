// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 25 16:56:14 2025

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float fTextureSampleBias : packoffset(c4) = {0};
  float4x4 matFarCloudShadowProjectionTexScale : packoffset(c5);
  float3 vecScreenSize : packoffset(c9);
  float4 vecInvScreenSize : packoffset(c10);
  float2 vecBlurSize : packoffset(c11);
  float4 srcTargetSize : packoffset(c12);
  float4 dstTargetSize : packoffset(c13);
  float2 sharpenWeight : packoffset(c14);
  float2 viewportJitter : packoffset(c14.z);
  float hdrDisplayGamma : packoffset(c15) = {1};
  float hdrDisplayMiddle : packoffset(c15.y) = {0.800000012};
  float hdrDisplayMaxNits : packoffset(c15.z) = {1000};
  float hdrDisplayWhiteNits : packoffset(c15.w) = {200};
  float3 vecViewPosition : packoffset(c16);
  float4 vecBlurDirection : packoffset(c17);
  float2 fIntensityScale : packoffset(c18);
  float2 g_InvRTSize : packoffset(c18.z);
  float4x4 g_invViewProjTM : packoffset(c19);
  float4x4 g_preInvViewProjTM : packoffset(c23);
  float4x4 g_preViewProjTM : packoffset(c27);
  float g_Roughness : packoffset(c31) = {0.5};
  int g_MaxMipMap : packoffset(c31.y) = {6};
  int g_CurrentMipmap : packoffset(c31.z) = {0};
}

SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s0);
Texture2D<float4> texBackBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = hdrDisplayMaxNits / hdrDisplayWhiteNits;
  r0.y = -1 + r0.x;
  r0.x = r0.x / r0.y;
  r0.y = hdrDisplayMiddle * r0.x;
  r0.z = -hdrDisplayMiddle + r0.x;
  r0.y = r0.y / r0.z;
  r0.y = 1 + -r0.y;
  r0.z = 2.4000001 * hdrDisplayGamma;
  r1.xyzw = texBackBuffer.Sample(PA_LINEAR_CLAMP_FILTER_s, v1.xy).xyzw;
  r1.xyzw = max(float4(0,0,0,0), r1.xyzw);
  r1.xyzw = min(float4(1000,1000,1000,1000), r1.xyzw);
  r1.xyz = log2(r1.xyz);
  r2.xyz = r1.xyz * r0.zzz;
  r1.xyz = hdrDisplayGamma * r1.xyz;
  o1.xyz = exp2(r1.xyz);
  r1.xyz = exp2(r2.xyz);
  r0.z = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r0.w = min(1, r0.z);
  r0.w = r0.x + -r0.w;
  r0.x = r0.x * r0.z;
  r0.x = r0.x / r0.w;
  r0.x = r0.y + r0.x;
  r0.y = hdrDisplayMiddle * 2 + -r0.z;
  r0.y = r0.z / r0.y;
  r0.w = cmp(hdrDisplayMiddle < r0.z);
  r0.z = 9.99999975e-05 + r0.z;
  r1.xyz = r1.xyz / r0.zzz;
  r0.x = r0.w ? r0.x : r0.y;
  r0.xyz = r1.xyz * r0.xxx;
  r1.x = dot(float3(0.627403975,0.329281986,0.0433136001), r0.xyz);
  r1.y = dot(float3(0.0457456,0.941776991,0.0124771995), r0.xyz);
  r1.z = dot(float3(-0.00121054996,0.0176040996,0.983606994), r0.xyz);
  r0.xyz = hdrDisplayWhiteNits * r1.xyz;
  r0.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = r1.w;
  o1.w = r1.w;
  return;
}