#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 18:40:39 2025

cbuffer ToneMapParams : register(b1)
{
  float g_fKeyValue : packoffset(c0);
  float g_fWhitePointSquared : packoffset(c0.y);
  float2 g_xScaleParams : packoffset(c0.z);
  float g_fFixedLuminance : packoffset(c1);
  bool g_bDynamicExposure : packoffset(c1.y);
  bool g_bUseBloom : packoffset(c1.z);
  bool g_bUseGodRays : packoffset(c1.w);
}

cbuffer BloomParams : register(b2)
{
  float4 g_xBloomConsts : packoffset(c0);
}

SamplerState g_xTrilinearClamp_s : register(s3);
Texture2D<float4> g_xInputSceneTexture : register(t2);
Texture2D<float4> g_xCurrentLuminance : register(t3);
Texture2D<float4> g_xBloomTexture : register(t4);
Texture2D<float4> g_xGodRaysTexture : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : Texcoords0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v1.xy;
  r0.zw = float2(0,0);
  r0.xyz = g_xInputSceneTexture.Load(r0.xyz).xyz;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) r0.xyz = min(float3(31.9990234,31.9990234,31.9990234), r0.xyz);
  
  r0.xyz = r0.xyz * g_xScaleParams.xxx + g_xScaleParams.yyy;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) r0.xyz = max(float3(0,0,0), r0.xyz);
  
  r0.w = g_xCurrentLuminance.Load(float4(0,0,0,0)).x;
  r0.w = g_bDynamicExposure ? r0.w : g_fFixedLuminance;
  [branch]
  if (g_bUseBloom != 0) {
    r1.xyz = g_xBloomTexture.SampleLevel(g_xTrilinearClamp_s, v0.xy, 0).xyz;
    r0.xyz = r1.xyz + r0.xyz;
  }
  [branch]
  if (g_bUseGodRays != 0) {
    r1.xyz = g_xGodRaysTexture.SampleLevel(g_xTrilinearClamp_s, v0.xy, 0).xyz;
    r0.xyz = r1.xyz * g_xBloomConsts.xxx + r0.xyz;
  }
  
  r1.x = dot(r0.xyz, float3(0.270000011,0.670000017,0.0599999987));
  r0.w = 9.99999975e-05 + r0.w;
  r0.w = g_fKeyValue / r0.w; // 0.15
  r1.y = r0.w * r1.x;

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.z = r1.y / g_fWhitePointSquared; // 2
  } else {
    r1.z = r1.y / 1; // seems to disable their "tonemapper" (still heavily clips)
  }
  
  r1.z = 1 + r1.z;
  r1.y = r1.y * r1.z;
  r0.w = r0.w * r1.x + 1;
  r0.w = r1.y / r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = max(9.99999975e-05, r1.x);
  r0.xyz = r0.xyz / r0.www;
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.w = sqrt(r0.w);
  o0.xyz = r0.xyz;
  return;
}