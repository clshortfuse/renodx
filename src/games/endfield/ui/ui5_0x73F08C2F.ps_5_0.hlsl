// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 11:53:21 2026
#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
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

  r0.xyzw = max(cb0[4].xyzw, float4(-2e+10,-2e+10,-2e+10,-2e+10));
  r0.xyzw = min(float4(2e+10,2e+10,2e+10,2e+10), r0.xyzw);
  r1.xy = v4.xy + r0.xy;
  r1.xy = r1.xy + r0.zw;
  r0.xy = r1.xy * float2(0.5,0.5) + -r0.xy;
  r0.zw = -r1.xy * float2(0.5,0.5) + r0.zw;
  r1.xyzw = float4(1,1,1,1) / cb0[8].xzyw;
  r0.xyzw = saturate(r1.xzyw * r0.xyzw);
  r1.xy = r0.xy * float2(-2,-2) + float2(3,3);
  r0.xy = r0.xy * r0.xy;
  r0.xy = r1.xy * r0.xy;
  r1.xy = r0.zw * float2(-2,-2) + float2(3,3);
  r0.zw = r0.zw * r0.zw;
  r0.zw = r1.xy * r0.zw;
  r0.x = r0.x * r0.z;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r0.w;
  r0.y = cmp(0.000000 != cb0[10].z);
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.w = r0.y ? 1 : r1.w;
  r1.xyzw = cb0[3].xyzw + r1.xyzw;
  r0.y = 255 * v1.w;
  r0.y = round(r0.y);
  r2.w = 0.00392156886 * r0.y;
  r2.xyz = v1.xyz;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r0.yz = cb0[4].zw + -cb0[4].xy;
  r0.yz = -abs(v4.xy) + r0.yz;
  r0.yz = saturate(v4.zw * r0.yz);
  r0.y = r0.y * r0.z;
  r0.y = r1.w * r0.y;
  r0.x = r0.y * r0.x;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = cb0[9].z * -r0.x + r0.x;
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  return;
}