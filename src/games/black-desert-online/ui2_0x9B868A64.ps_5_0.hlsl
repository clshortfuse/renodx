// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 26 21:03:05 2025

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
Texture2D<float4> texBloom : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_UI_VISIBLE < 0.5f) {
    o0 = float4(0, 0, 0, 0);
    return;
  }

  r0.xyzw = -vecBlurSize.xyxy * float4(-0.400000006,-0.400000006,-0.300000012,-0.300000012) + v1.xyxy;
  r1.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r0.zw).xyzw;
  r0.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r0.xy).xyzw;
  r1.xyzw = float4(0.0700000003,0.0700000003,0.0700000003,0.0700000003) * r1.xyzw;
  r0.xyzw = r0.xyzw * float4(0.0399999991,0.0399999991,0.0399999991,0.0399999991) + r1.xyzw;
  r1.xyzw = -vecBlurSize.xyxy * float4(-0.200000003,-0.200000003,-0.100000001,-0.100000001) + v1.xyxy;
  r2.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.xy).xyzw;
  r1.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw * float4(0.119999997,0.119999997,0.119999997,0.119999997) + r0.xyzw;
  r0.xyzw = r1.xyzw * float4(0.170000002,0.170000002,0.170000002,0.170000002) + r0.xyzw;
  r1.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.200000003,0.200000003,0.200000003,0.200000003) + r0.xyzw;
  r1.xyzw = -vecBlurSize.xyxy * float4(0.100000001,0.100000001,0.200000003,0.200000003) + v1.xyxy;
  r2.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.xy).xyzw;
  r1.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw * float4(0.170000002,0.170000002,0.170000002,0.170000002) + r0.xyzw;
  r0.xyzw = r1.xyzw * float4(0.119999997,0.119999997,0.119999997,0.119999997) + r0.xyzw;
  r1.xyzw = -vecBlurSize.xyxy * float4(0.300000012,0.300000012,0.400000006,0.400000006) + v1.xyxy;
  r2.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.xy).xyzw;
  r1.xyzw = texBloom.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw * float4(0.0700000003,0.0700000003,0.0700000003,0.0700000003) + r0.xyzw;
  o0.xyzw = r1.xyzw * float4(0.0399999991,0.0399999991,0.0399999991,0.0399999991) + r0.xyzw;
  return;
}