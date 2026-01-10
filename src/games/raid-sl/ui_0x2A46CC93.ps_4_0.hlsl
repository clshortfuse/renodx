#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 08:36:54 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[17];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float w2 : TEXCOORD3,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[4].xyzw + -cb0[3].xyzw;
  r1.x = cb0[5].z + -cb0[5].y;
  r2.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r3.xyzw = r2.xyxy * cb0[12].xyzw + v4.xyzw;
  r3.xyzw = r3.xyzw * cb0[8].xyxy + cb0[8].zwzw;
  r4.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r3.zw).xyzw;
  r1.y = cb0[15].y + r3.y;
  r1.z = cb0[15].x + r4.x;
  r1.y = saturate(r1.z + r1.y);
  r1.zw = cb0[5].xw + r1.yy;
  r1.z = -cb0[5].y + r1.z;
  r1.w = -cb0[6].x + r1.w;
  r1.x = saturate(r1.z / r1.x);
  r0.xyzw = r1.xxxx * r0.xyzw + cb0[3].xyzw;
  r0.xyzw = -cb0[2].xyzw + r0.xyzw;
  r1.x = cb0[6].y + -cb0[6].x;
  r1.x = saturate(r1.w / r1.x);
  r0.xyzw = r1.xxxx * r0.xyzw + cb0[2].xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xz = r2.xy * cb0[13].xy + cb0[13].zw;
  r1.xz = cb0[15].xy + r1.xz;
  r3.xyzw = t1.Sample(s0_s, r1.xz).xyzw;
  r1.x = r3.z * r2.z;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[10].xxxx * r0.xyzw;
  r1.x = -cb0[14].x + w2.x;
  r1.z = cmp(0 < r1.x);
  r1.w = cmp(r1.x < 0);
  r1.x = max(0.00100000005, abs(r1.x));
  r1.z = (int)-r1.z + (int)r1.w;
  r1.z = (int)r1.z;
  r1.z = r1.z * 2 + 1;
  r1.z = max(-1, r1.z);
  r1.z = min(1, r1.z);
  r1.x = r1.x * r1.z;
  r1.z = -cb0[14].x + r1.y;
  r1.y = v1.w * r1.y;
  r1.y = r1.y * r3.z;
  r1.y = r1.y * r2.z;
  r1.x = saturate(r1.z / r1.x);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.x = r1.y * r1.x;
  r0.w = r1.x * r0.w;
  o0.xyz = r0.xyz;
  r0.xy = cmp(v3.xy >= cb0[16].xy);
  r0.xy = r0.xy ? float2(1,1) : 0;
  r1.xy = cmp(cb0[16].zw >= v3.xy);
  r1.xy = r1.xy ? float2(1,1) : 0;
  r0.xy = r1.xy * r0.xy;
  r0.x = r0.x * r0.y;
  o0.w = r0.w * r0.x;
  o0 *= CUSTOM_UI_ENABLED;
  return;
}