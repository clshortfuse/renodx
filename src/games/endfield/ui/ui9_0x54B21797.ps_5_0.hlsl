// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 14:35:33 2026

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[15];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[0].y * 0.0009765625;
  r0.y = cmp(r0.x >= -r0.x);
  r0.x = frac(abs(r0.x));
  r0.x = r0.y ? r0.x : -r0.x;
  r0.x = 1024 * r0.x;
  r0.xyzw = cb1[12].xxyy * r0.xxxx + v2.xxyy;
  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r0.xyzw = cb1[13].xyzw * r0.xyzw;
  r0.xy = r0.xy + r0.zw;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = r0.xy * cb1[14].xy + cb1[14].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.w = r0.x;
  r1.x = 1;
  r1.xyzw = r1.xxxw + -r0.xyzw;
  r0.xyzw = cb1[11].xxxx * r1.xyzw + r0.xyzw;
  r1.x = 255 * v1.w;
  r1.x = round(r1.x);
  r1.w = 0.00392156886 * r1.x;
  r1.xyz = v1.xyz;
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.w = cb1[9].z * -r0.w + r0.w;
  
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  
  return;
}