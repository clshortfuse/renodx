// ---- Created with 3Dmigoto v1.3.16 on Wed Jan 21 20:06:28 2026
#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s0_s, v1.xy).w;
  r0.y = t1.Sample(s1_s, w1.xy).w;
  r0.z = t2.Sample(s2_s, w1.xy).w;
  r0.xyz = float3(-0.0627499968,-0.50195998,-0.50195998) + r0.xyz;
  float3 rgb;
  rgb.x = dot(float2(1.16437995,1.59603), r0.xz);
  rgb.y = dot(float3(1.16437995,-0.391759992,-0.812969983), r0.xyz);
  rgb.z = dot(float2(1.16437995,2.01723003), r0.xy);
  
  rgb = AutoHDRVideo(rgb);
  
  o0.x = rgb.x;
  o0.y = rgb.y;
  o0.z = rgb.z;
  o0.w = -cb0[7].x + 1;
  return;
}