#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 29 09:17:59 2025

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts[5] : packoffset(c0);
}

SamplerState DepthMap_s : register(s1);
Texture2D<float4> DepthMap : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float3 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.xyzw = float4(0,0,0,0);
  o1.xyzw = float4(0,0,0,0);
  r0.xy = v1.xy / v1.zz;
  r1.xyzw = InstanceConsts[2].xyzw * r0.yyyy;
  r1.xyzw = r0.xxxx * InstanceConsts[1].xyzw + r1.xyzw;
  r0.x = DepthMap.Sample(DepthMap_s, r0.xy).x;
  r0.xyzw = r0.xxxx * InstanceConsts[3].xyzw + r1.xyzw;
  r0.xyzw = InstanceConsts[4].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = InstanceConsts[0].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.x = dot(r0.xyz, r0.xyz);
  r0.x = saturate(r0.x);                                                          // r0.x = min(1, r0.x);
  o2.xyzw = saturate(InstanceConsts[0].yyyy * r0.xxxx + InstanceConsts[0].zzzz);  // o2.xyzw = InstanceConsts[0].yyyy * r0.xxxx + InstanceConsts[0].zzzz;
  return;
}