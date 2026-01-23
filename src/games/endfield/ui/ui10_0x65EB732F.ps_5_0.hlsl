// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 15:07:05 2026

#include "../shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[33];
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
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.Sample(s2_s, v2.xy).w;
  r0.y = -v3.x + r0.x;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.x = v3.z + -r0.x;
  r0.y = cb1[22].w * cb1[6].x;
  r0.z = cb1[22].w * cb1[4].y;
  r0.yw = v3.yy * r0.yz;
  r1.xyz = cb1[3].xyz * v1.xyz;
  r2.xy = cb1[2].xy * cb0[0].yy + v6.xy;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r2.w = cb1[3].w * r2.w;
  r3.xy = cb1[4].zw * cb0[0].yy + v6.zw;
  r3.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = cb1[5].xyzw * r3.xyzw;
  r1.w = 0.5 * r0.y;
  r2.xyz = r2.www * r1.xyz;
  r3.xyz = r3.xyz * r3.www;
  r1.xy = cb1[26].zw + -cb1[26].xy;
  r1.xy = -abs(v4.xy) + r1.xy;
  r1.xy = saturate(v4.zw * r1.xy);
  r4.xyzw = max(cb1[26].xyzw, float4(-2e+10,-2e+10,-2e+10,-2e+10));
  r4.xyzw = min(float4(2e+10,2e+10,2e+10,2e+10), r4.xyzw);
  r5.xy = v4.xy + r4.xy;
  r5.xy = r5.xy + r4.zw;
  r1.z = saturate(r0.x * v3.y + r1.w);
  r0.y = min(1, r0.y);
  r0.y = sqrt(r0.y);
  r0.y = r1.z * r0.y;
  r3.xyzw = r3.xyzw + -r2.xyzw;
  r2.xyzw = r0.yyyy * r3.xyzw + r2.xyzw;
  r0.x = r0.x * v3.y + -r1.w;
  r0.x = r0.w * 0.5 + r0.x;
  r0.y = r0.z * v3.y + 1;
  r0.x = saturate(r0.x / r0.y);
  r0.x = 1 + -r0.x;
  r0.xyzw = r2.xyzw * r0.xxxx;
  r1.x = r1.x * r1.y;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xy = r5.xy * float2(0.5,0.5) + -r4.xy;
  r2.xyzw = float4(1,1,1,1) / cb1[32].xzyw;
  r1.xy = saturate(r2.xz * r1.xy);
  r1.zw = r1.xy * float2(-2,-2) + float2(3,3);
  r1.xy = r1.xy * r1.xy;
  r1.xy = r1.zw * r1.xy;
  r1.zw = -r5.xy * float2(0.5,0.5) + r4.zw;
  r1.zw = saturate(r1.zw * r2.yw);
  r2.xy = r1.zw * float2(-2,-2) + float2(3,3);
  r1.zw = r1.zw * r1.zw;
  r1.zw = r2.xy * r1.zw;
  r1.x = r1.x * r1.z;
  r1.x = r1.x * r1.y;
  r1.x = r1.x * r1.w;
  r0.xyzw = r1.xxxx * r0.xyzw;
  o0.xyzw = v1.wwww * r0.xyzw;

  if (UI_VISIBILITY < 0.5f) o0 = 0;

  return;
}