#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 09:09:53 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cmp(v4.xy >= cb0[5].xy);
  r0.zw = cmp(cb0[5].zw >= v4.xy);
  r0.xyzw = r0.xyzw ? float4(1,1,1,1) : 0;
  r0.xy = r0.xy * r0.zw;
  r0.x = r0.x * r0.y;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = cb0[7].xyzw + r1.xyzw;
  r1.xyzw = v2.yzwx * r1.yzwx;
  r2.w = r1.z;
  r0.y = r2.w * r0.x + -0.00100000005;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r3.zw = float2(-1,0.666666687);
  r4.zw = float2(0,-0.333333343);
  r0.y = cmp(r1.x < r1.y);
  r3.xy = r1.yx;
  r4.xy = r3.yx;
  r3.xyzw = r0.yyyy ? r3.xyzw : r4.xyzw;
  r0.y = cmp(r1.w < r3.x);
  r1.xyz = r3.xyw;
  r3.xyw = r1.wyx;
  r1.xyzw = r0.yyyy ? r1.xyzw : r3.xyzw;
  r0.y = r1.w + -r1.y;
  r0.z = min(r1.w, r1.y);
  r0.z = r1.x + -r0.z;
  r0.w = r0.z * 6 + 9.99999975e-05;
  r0.y = r0.y / r0.w;
  r0.y = r0.y + r1.z;
  r0.w = -r0.z * 0.5 + r1.x;
  r0.y = v3.x + abs(r0.y);
  r1.x = cmp(1 < r0.y);
  r1.y = -1 + r0.y;
  r0.y = r1.x ? r1.y : r0.y;
  r1.xyz = r0.yyy * float3(6,6,6) + float3(-3,-2,-4);
  r1.xyz = saturate(abs(r1.xyz) * float3(1,-1,-1) + float3(-1,2,2));
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r0.y = r0.w * 2 + -1;
  r0.w = v3.z + r0.w;
  r0.y = 1.00010002 + -abs(r0.y);
  r0.y = r0.z / r0.y;
  r0.y = saturate(v3.y + r0.y);
  r0.z = r0.w * 2 + -1;
  r0.z = 1 + -abs(r0.z);
  r0.y = r0.z * r0.y;
  r2.xyz = r1.xyz * r0.yyy + r0.www;
  r0.xyzw = r2.xyzw * r0.xxxx;
  o0.xyzw = r0.xyzw;
  o0 *= CUSTOM_UI_ENABLED;
  return;
}