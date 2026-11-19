#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 19 06:22:59 2026

cbuffer _Globals : register(b0)
{
  float4 g_ViewportSize : packoffset(c32);
  float4 g_TimeParam : packoffset(c65);
  float4 g_MiddleGray_Scale_LuminanceLow_LuminanceHigh : packoffset(c105);
  float4 mrgToneMapWeightParam : packoffset(c107);
  float4 g_BloomStar_Param1 : packoffset(c106);
}

SamplerState sampDif0_sampler_s : register(s0);
Texture2D<float4> sampDif0_NedSmpignorenametexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = sampDif0_NedSmpignorenametexture.Sample(sampDif0_sampler_s, v1.xy).xyz;
  r0.w = dot(r0.xyz, float3(0.298909992,0.586610019,0.114480004));
  // RenoDX: threshold (cb106.x) scaled by the Bloom Threshold setting
  r1.x = -(g_BloomStar_Param1.x * shader_injection.sg_bloom_threshold) + r0.w;
  r0.w = max(9.99999975e-006, r0.w);
  r1.x = max(0, r1.x);
  r0.w = r1.x / r0.w;
  r1.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz * r0.www + g_BloomStar_Param1.yyy;
  o0.xyz = r1.xyz / r0.xyz;
  o0.w = 1;
  return;
}
