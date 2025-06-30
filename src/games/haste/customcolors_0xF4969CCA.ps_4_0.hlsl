#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr  1 23:19:14 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1,1,1,1) + -cb0[6].xyzw;
  r0.xyzw = r0.xyzw + r0.xyzw;
  r1.x = cb0[5].y + -cb0[5].x;
  r1.x = 1 / r1.x;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  float3 ungraded = r2.xyz;

  r1.y = r2.x + r2.y;
  r1.y = r1.y + r2.z;
  r1.z = r1.y * 0.333333343 + -cb0[5].x;
  r1.y = r1.y * 0.333333343 + -cb0[8].x;
  r1.x = saturate(r1.z * r1.x);
  r1.z = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.z * r1.x;
  r1.x = -r1.x * r1.x + 1;
  r1.z = cb0[4].w * r1.x;
  r1.x = cb0[6].w * r1.x;
  r3.xyzw = saturate(cb0[4].xyzw * r2.xyzw);
  r3.xyzw = r3.xyzw + -r2.xyzw;
  r2.xyzw = r1.zzzz * r3.xyzw + r2.xyzw;
  r3.xyzw = float4(1,1,1,1) + -r2.xyzw;
  r0.xyzw = -r0.xyzw * r3.xyzw + float4(1,1,1,1);
  r3.xyzw = cb0[6].xyzw * r2.xyzw;
  r3.xyzw = r3.xyzw + r3.xyzw;
  r4.xyzw = cmp(float4(0.5,0.5,0.5,0.5) < cb0[6].xyzw);
  r0.xyzw = saturate(r4.xyzw ? r0.xyzw : r3.xyzw);
  r0.xyzw = r0.xyzw + -r2.xyzw;
  r0.xyzw = r1.xxxx * r0.xyzw + r2.xyzw;
  r2.xyzw = r0.xyzw * float4(2,2,2,2) + cb0[7].xyzw;
  r2.xyzw = float4(-1,-1,-1,-1) + r2.xyzw;
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r3.xyzw = r3.xyzw * float4(2,2,2,2) + cb0[7].xyzw;
  r4.xyzw = cmp(float4(0.5,0.5,0.5,0.5) < r0.xyzw);
  r2.xyzw = saturate(r4.xyzw ? r2.xyzw : r3.xyzw);
  r2.xyzw = r2.xyzw + -r0.xyzw;
  r1.x = cb0[8].y + -cb0[8].x;
  r1.x = 1 / r1.x;
  r1.x = saturate(r1.y * r1.x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r1.x = rsqrt(r1.x);
  r1.x = 1 / r1.x;
  r1.x = cb0[7].w * r1.x;
  o0.xyzw = r1.xxxx * r2.xyzw + r0.xyzw;

  float3 graded = o0.rgb;

  o0.rgb = lerp(ungraded, graded, CUSTOM_COLOR_GRADING);
  return;
}