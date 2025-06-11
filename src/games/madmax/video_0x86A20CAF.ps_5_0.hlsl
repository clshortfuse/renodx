#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Apr 24 12:50:25 2025

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts : packoffset(c0);
}

SamplerState VideoLuma_s : register(s0);
SamplerState VideoCr_s : register(s1);
SamplerState VideoCb_s : register(s2);
Texture2D<float4> VideoLuma : register(t0);
Texture2D<float4> VideoCr : register(t1);
Texture2D<float4> VideoCb : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = VideoCr.Sample(VideoCr_s, v1.xy).x;
  r0.xyz = float3(1.59500003,-0.813000023,0) * r0.xxx;
  r0.w = VideoLuma.Sample(VideoLuma_s, v1.xy).x;
  r0.xyz = r0.www * float3(1.16400003,1.16400003,1.16400003) + r0.xyz;
  r0.w = VideoCb.Sample(VideoCb_s, v1.xy).x;
  r0.xyz = r0.www * float3(0,-0.391000003,2.01699996) + r0.xyz;
  o0.xyz = float3(-0.870000005, 0.528999984, -1.08159995) + r0.xyz;
  o0.w = InstanceConsts.w;
  o0.rgb = max(0, o0.rgb);
  return;
}