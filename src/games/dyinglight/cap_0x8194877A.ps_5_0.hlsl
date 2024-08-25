#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:21 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
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

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  // no noticeable effect when skipping this code
  r1.x = r0.x + r0.y;
  r1.x = r1.x + r0.z;
  r0.xyzw = -r1.xxxx * float4(0.333333343,0.333333343,0.333333343,0.333333343) + r0.xyzw;
  r1.x = 0.333333343 * r1.x;
  o0.xyzw = cb0[0].xxxx * r0.xyzw + r1.xxxx;  //  o0.xyzw = saturate(cb0[0].xxxx * r0.xyzw + r1.xxxx);
  o0.w = saturate(o0.w);
  return;
}