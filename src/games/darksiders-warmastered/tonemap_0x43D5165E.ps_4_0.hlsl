#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Jan 13 18:57:51 2026

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float middleGray;
    float minToneMapMult;
    float maxToneMapMult;
    float brightPassThreshold;
  } g_data : packoffset(c0);

}

SamplerState s0_sampler_s : register(s0);
SamplerState s1_sampler_s : register(s1);
Texture2D<float4> s0_texture : register(t0);
Texture2D<float4> s1_texture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s0_texture.Sample(s0_sampler_s, v1.xy).xyzw;

  //float3 test = r0.xyz;

  r1.xyzw = s1_texture.Sample(s1_sampler_s, float2(0.5,0.5)).xyzw;
  r1.x = 0.00100000005 + r1.x;
  r1.x = g_data.middleGray / r1.x;
  r1.x = max(g_data.minToneMapMult, r1.x);
  r1.x = min(g_data.maxToneMapMult, r1.x);
  r1.xyz = r1.xxx * r0.xyz;
  r0.y = max(r1.y, r1.z);
  r0.y = max(r1.x, r0.y);
  r0.z = cmp(r0.y < 9.99999975e-06);
  r0.x = 0;
  o0.xyzw = r0.xxxw;
  if (r0.z != 0) return;
  r0.x = -g_data.brightPassThreshold + r0.y;
  r0.x = max(0, r0.x);
  r0.x = r0.x / r0.y;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = saturate(r0.w);

  if (RENODX_TONE_MAP_TYPE == 0) o0.xyz = saturate(o0.xyz);
  return;
}