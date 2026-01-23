// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 11:53:21 2026
#include "../shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[23];
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
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  float4 v9 : TEXCOORD8,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[4].zw * cb0[0].yy + v8.zw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = cb1[5].xyzw * r0.xyzw;
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = cb1[3].xyz * v1.xyz;
  r2.xy = cb1[2].xy * cb0[0].yy + v8.xy;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r2.w = cb1[3].w * r2.w;
  r2.xyz = r2.www * r1.xyz;
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r1.x = cb1[22].w * cb1[6].x;
  r1.x = v3.y * r1.x;
  r1.y = min(1, r1.x);
  r1.x = 0.5 * r1.x;
  r1.y = sqrt(r1.y);
  r1.z = t2.Sample(s2_s, v2.xy).w;
  r1.z = v3.z + -r1.z;
  r1.w = saturate(r1.z * v3.y + r1.x);
  r1.x = r1.z * v3.y + -r1.x;
  r1.y = r1.w * r1.y;
  r0.xyzw = r1.yyyy * r0.xyzw + r2.xyzw;
  r1.y = cb1[22].w * cb1[4].y;
  r1.z = v3.y * r1.y;
  r1.y = r1.y * v3.y + 1;
  r1.x = r1.z * 0.5 + r1.x;
  r1.x = saturate(r1.x / r1.y);
  r1.x = 1 + -r1.x;
  r2.xyzw = r1.xxxx * r0.xyzw;
  r0.x = -r0.w * r1.x + 1;
  r0.y = t2.Sample(s2_s, v6.xy).w;
  r0.y = saturate(r0.y * v6.z + -v6.w);
  r1.xyzw = v7.xyzw * r0.yyyy;
  r0.xyzw = r1.xyzw * r0.xxxx + r2.xyzw;
  o0.xyzw = v1.wwww * r0.xyzw;
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  return;
}