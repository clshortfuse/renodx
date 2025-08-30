// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 26 00:00:08 2025

//Menu buttons black bg

#include "../shared.h"

cbuffer GenericsCBuffer : register(b3)
{
  float4 scriptVector0 : packoffset(c0);
  float4 scriptVector1 : packoffset(c1);
  float4 scriptVector2 : packoffset(c2);
  float4 scriptVector3 : packoffset(c3);
  float4 scriptVector4 : packoffset(c4);
  float4 scriptVector5 : packoffset(c5);
  float4 scriptVector6 : packoffset(c6);
  float4 scriptVector7 : packoffset(c7);
  float4 weaponParam0 : packoffset(c8);
  float4 weaponParam1 : packoffset(c9);
  float4 weaponParam2 : packoffset(c10);
  float4 weaponParam3 : packoffset(c11);
  float4 weaponParam4 : packoffset(c12);
  float4 weaponParam5 : packoffset(c13);
  float4 weaponParam6 : packoffset(c14);
  float4 weaponParam7 : packoffset(c15);
}

SamplerState colorSampler_s : register(s1);
Texture2D<float4> colorMapSampler : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  if (!CUSTOM_SHOW_HUD) discard;

  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1,1,1,1) / scriptVector0.xyzw;
  r1.xyzw = v2.xyxy * float4(1,1,-1,-1) + float4(0,0,1,1);
  r0.xyzw = saturate(r1.xyzw * r0.xyzw);
  r1.xyzw = r0.xyzw * float4(-2,-2,-2,-2) + float4(3,3,3,3);
  r0.xyzw = r0.xyzw * r0.xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r0.z;
  r0.x = r0.x * r0.w;
  r1.xyzw = colorMapSampler.Sample(colorSampler_s, v2.xy).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  return;
}