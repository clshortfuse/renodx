// ---- Created with 3Dmigoto v1.4.1 on Sun Feb  8 01:22:43 2026
#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[4];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[0].x * 40;
  r0.x = floor(r0.x);
  r0.x = 25 * r0.x;
  r0.y = 8 * v1.y;
  r0.y = floor(r0.y);
  r0.x = r0.y * 0.125 + r0.x;
  r0.x = dot(r0.xx, float2(12.9898005,78.2330017));
  r0.x = sin(r0.x);
  r0.x = 43758.5469 * r0.x;
  r0.x = frac(r0.x);
  r0.x = 24 * r0.x;
  r0.y = cb0[0].x * r0.x;
  r0.y = 10 * r0.y;
  r0.y = floor(r0.y);
  r0.x = r0.y / r0.x;
  r0.x = r0.x * 6 + v1.y;
  r0.y = cb1[2].x * 8;
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
  r0.x = -cb1[2].y + abs(r0.x);
  r0.x = saturate(2.5 * r0.x);
  r0.y = (int)-r0.y + (int)r0.z;
  r0.y = (int)r0.y;
  r0.x = r0.y * r0.x;
  r0.x = cb1[2].z * r0.x;
  r0.y = ceil(r0.x);
  r1.x = 0.100000001 * r0.x;
  r0.x = 1 + -r0.y;
  r1.yw = float2(0,0);
  r0.yz = saturate(v1.xy + r1.xy);
  r1.x = v1.y;
  r1.y = cb0[0].x;
  r0.w = dot(r1.xy, float2(12.9898005,78.2330017));
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r1.x = cmp(abs(r0.w) >= cb1[2].w);
  r1.x = r1.x ? 1.000000 : 0;
  r1.x = cb1[3].x * r1.x;
  r1.z = r1.x * r0.w;
  r0.yz = r0.yz + r1.zw;
  r0.yz = frac(r0.yz);
  r1.xy = v1.xy + -r0.yz;
  r0.xy = r0.xx * r1.xy + r0.yz;
  o0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  return;
}