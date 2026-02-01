// ---- Created with 3Dmigoto v1.4.1 on Sun Feb  1 19:44:23 2026

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[12];
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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[0].x * 0.00999999978;
  r0.y = cmp(r0.x >= -r0.x);
  r0.x = frac(abs(r0.x));
  r0.x = r0.y ? r0.x : -r0.x;
  r0.y = 4000 * r0.x;
  r0.y = floor(r0.y);
  r0.y = 25 * r0.y;
  r0.z = 8 * v2.y;
  r0.z = floor(r0.z);
  r0.y = r0.z * 0.125 + r0.y;
  r0.y = dot(r0.yy, float2(12.9898005,78.2330017));
  r0.y = sin(r0.y);
  r0.y = 43758.5469 * r0.y;
  r0.y = frac(r0.y);
  r0.y = 24 * r0.y;
  r0.x = r0.x * r0.y;
  r0.x = 1000 * r0.x;
  r0.x = floor(r0.x);
  r0.x = r0.x / r0.y;
  r0.x = r0.x * 6 + v2.y;
  r0.y = max(cb1[10].w, 0.00999999978);
  r0.y = 8 * r0.y;
  r0.z = r0.x * r0.y;
  r0.x = 7 * r0.x;
  r0.xz = floor(r0.xz);
  r0.x = 0.142857149 * r0.x;
  r0.x = dot(r0.xx, float2(12.9898005,78.2330017));
  r0.x = sin(r0.x);
  r0.y = r0.z / r0.y;
  r0.y = dot(r0.yy, float2(12.9898005,78.2330017));
  r0.y = sin(r0.y);
  r0.xy = float2(43758.5469,43758.5469) * r0.xy;
  r0.xy = frac(r0.xy);
  r0.x = r0.y + r0.x;
  r0.x = -1 + r0.x;
  r0.y = cmp(0 < r0.x);
  r0.z = cmp(r0.x < 0);
  r0.x = -cb1[11].x + abs(r0.x);
  r0.x = saturate(2.5 * r0.x);
  r0.y = (int)-r0.y + (int)r0.z;
  r0.y = (int)r0.y;
  r0.x = r0.y * r0.x;
  r0.x = cb1[11].y * r0.x;
  r0.y = ceil(r0.x);
  r1.x = 0.100000001 * r0.x;
  r0.x = 1 + -r0.y;
  r0.y = cmp(0.000000 == cb1[10].w);
  r0.x = r0.y ? 1 : r0.x;
  r1.yw = float2(0,0);
  r0.yz = saturate(v2.xy + r1.xy);
  r1.x = v2.y;
  r1.y = cb0[0].x;
  r0.w = dot(r1.xy, float2(12.9898005,78.2330017));
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r1.x = cmp(abs(r0.w) >= cb1[11].z);
  r1.x = r1.x ? 1.000000 : 0;
  r1.x = cb1[11].w * r1.x;
  r1.z = r1.x * r0.w;
  r0.yz = r0.yz + r1.zw;
  r0.yz = frac(r0.yz);
  r1.xy = v2.xy + -r0.yz;
  r0.xy = r0.xx * r1.xy + r0.yz;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.x = cmp(0.000000 != cb1[10].z);
  r0.w = r1.x ? 1 : r0.w;
  r0.xyzw = cb1[3].xyzw + r0.xyzw;
  r1.x = 255 * v1.w;
  r1.x = round(r1.x);
  r1.w = 0.00392156886 * r1.x;
  r1.xyz = v1.xyz;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.xy = cb1[4].zw + -cb1[4].xy;
  r1.xy = -abs(v4.xy) + r1.xy;
  r1.xy = saturate(v4.zw * r1.xy);
  r1.x = r1.x * r1.y;
  r0.w = r1.x * r0.w;
  r1.xyzw = max(cb1[4].xyzw, float4(-2e+10,-2e+10,-2e+10,-2e+10));
  r1.xyzw = min(float4(2e+10,2e+10,2e+10,2e+10), r1.xyzw);
  r2.xy = v4.xy + r1.xy;
  r2.xy = r2.xy + r1.zw;
  r1.xy = r2.xy * float2(0.5,0.5) + -r1.xy;
  r1.zw = -r2.xy * float2(0.5,0.5) + r1.zw;
  r2.xyzw = float4(1,1,1,1) / cb1[8].xzyw;
  r1.xyzw = saturate(r2.xzyw * r1.xyzw);
  r2.xy = r1.xy * float2(-2,-2) + float2(3,3);
  r1.xy = r1.xy * r1.xy;
  r1.xy = r2.xy * r1.xy;
  r2.xy = r1.zw * float2(-2,-2) + float2(3,3);
  r1.zw = r1.zw * r1.zw;
  r1.zw = r2.xy * r1.zw;
  r1.x = r1.x * r1.z;
  r1.x = r1.x * r1.y;
  r1.x = r1.x * r1.w;
  r0.w = r1.x * r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = cb1[9].z * -r0.w + r0.w;

  if (UI_VISIBILITY < 0.5f) o0 = 0;

  return;
}