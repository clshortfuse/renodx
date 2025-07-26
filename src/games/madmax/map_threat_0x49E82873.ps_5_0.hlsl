#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Apr 28 07:17:34 2025

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts[2] : packoffset(c0);
}

cbuffer cbTypeConsts : register(b2)
{
  float4 TypeConsts[2] : packoffset(c0);
}

SamplerState RasterMap_s : register(s0);
SamplerState ThreatTints_s : register(s1);
Texture2D<float4> RasterMap : register(t0);
Texture2D<float4> ThreatTints : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (shader_injection.map_threat == 0) {
    discard;
  } else {
    r0.xyzw = ThreatTints.Sample(ThreatTints_s, InstanceConsts[1].zz).xyzw;
    r0.xyzw = InstanceConsts[0].xyzw * r0.xyzw;
    r1.xyzw = RasterMap.Sample(RasterMap_s, v1.xy).xyzw;
    r2.xyzw = InstanceConsts[1].yyyy * r1.xyzw + -r0.xyzw;
    r1.x = InstanceConsts[1].y * r1.w;
    r0.xyzw = r1.xxxx * r2.xyzw + r0.xyzw;
    r0.xyz = log2(r0.xyz);
    o0.w = r0.w;
    r0.xyz = TypeConsts[1].xxx * r0.xyz;
    o0.xyz = exp2(r0.xyz);
  }
  return;
}