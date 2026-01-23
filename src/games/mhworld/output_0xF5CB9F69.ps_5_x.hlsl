#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct 30 00:24:41 2025

cbuffer CBRenderFrame : register(b2)
{
  uint iRenderFrame : packoffset(c0);
  uint iTotalTime : packoffset(c0.y);
  uint iTotalTimeEx : packoffset(c0.z);
  float fFPS : packoffset(c0.w);
  float fDeltaTime : packoffset(c1);
  float fSSAOEffect : packoffset(c1.y);
  bool bSSSEnable : packoffset(c1.z) = false;
  bool bIsRenderingWater : packoffset(c1.w) = false;
  float fWaterDepthBias : packoffset(c2);
  uint iGpuMode : packoffset(c2.y);
  float2 fDitherSize : packoffset(c2.z);
  bool bHdrOutput : packoffset(c3) = false;
  float fHdrOutputWhiteLevel : packoffset(c3.y) = {100};
  float fHdrOutputGamutMappingRatio : packoffset(c3.z) = {0};
  float fHdrOutputGamma : packoffset(c3.w) = {1};
  bool bIsGUIHdrGamma : packoffset(c4) = false;
}

SamplerState SSSystemCopy_s : register(s0);
Texture2D<float4> tBaseMap : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TexCoord0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = tBaseMap.Sample(SSSystemCopy_s, v1.xy).xyz;

  if (RENODX_TONE_MAP_TYPE != 0) {
    if (RENODX_TONE_MAP_TYPE == 1) r0.xyz = saturate(r0.xyz);
    o0.xyz = renodx::draw::SwapChainPass(r0.xyz);
    o0.w = 1.f;
    return;
  }

  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.x = dot(float3(0.627403975,0.329281986,0.0433136001), r0.xyz);
  r1.y = dot(float3(0.0690969974,0.919539988,0.0113612004), r0.xyz);
  r1.z = dot(float3(0.0163915996,0.088013202,0.895595014), r0.xyz);
  r0.xyz = -r1.xyz + r0.xyz;
  r0.xyz = fHdrOutputGamutMappingRatio * r0.xyz + r1.xyz;
  r1.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = fHdrOutputGamma * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(r0.xyz < float3(1,1,1));
  r1.xyz = r2.xyz ? r1.xyz : r0.xyz;
  r0.xyz = bIsGUIHdrGamma ? r1.xyz : r0.xyz;

  r0.w = 10000 / fHdrOutputWhiteLevel;
  r0.xyz = saturate(r0.xyz / r0.www);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  o0.xyz = min(float3(1,1,1), r0.xyz);
  o0.w = 1;
  return;
}