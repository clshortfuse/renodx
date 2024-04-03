// Chromatic aberation

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11)
{
  float4 cb11[93];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.5 + -v1.x;
  r0.x = abs(r0.x) + abs(r0.x);
  r0.x = r0.x * r0.x;
  r0.x = cb11[92].y * r0.x;
  r1.z = cb11[92].x + v1.x;
  r1.yw = v1.yy;
  r0.y = t0.Sample(s0_s, r1.zw).x;
  r1.x = -cb11[92].x + v1.x;
  r0.w = t0.Sample(s0_s, r1.xy).z;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.z = r1.y;
  r0.yzw = -r1.xyz + r0.yzw;
  // o0.xyz = r0.xxx * r0.yzw + r1.xyz;
  o0.xyz = r1.xyz + (r0.xxx * r0.yzw * injectedData.fxChromaticAberration);
  o0.w = r1.w;
  return;
}