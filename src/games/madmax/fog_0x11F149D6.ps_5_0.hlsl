#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jul 26 17:59:18 2025

cbuffer cbConstants : register(b2)
{
  float4 Constants[13] : packoffset(c0);
}

SamplerState FogVolume_s : register(s2);
Texture2D<float4> FogVolume : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = FogVolume.Sample(FogVolume_s, v1.xy).xyw;
  r0.x = r0.z * 8 + r0.x;
  r0.yzw = Constants[9].xyz * r0.yyy;
  o0.xyz = (Constants[8].xyz * r0.xxx + r0.yzw) * CUSTOM_FOG;
  o0.w = 0;
  return;
}