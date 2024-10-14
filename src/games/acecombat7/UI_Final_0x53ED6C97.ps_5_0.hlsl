// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 11 21:13:03 2024
#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[5];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v3.xy;
  r0.zw = float2(0,0);
  r0.x = t0.Load(r0.xyz).x;
  r0.x = v3.z + -r0.x;
  r0.x = cmp(r0.x < 0);
  r0.y = cmp(asint(cb0[2].x) != 0);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) discard;
  r0.xyzw = cmp(cb0[0].xyzw != float4(0,0,0,0));
  r0.xy = (int2)r0.zw | (int2)r0.xy;
  r0.x = (int)r0.y | (int)r0.x;
  r1.xyzw = t1.Sample(s0_s, v0.xy).xyzw;
  r0.y = dot(r1.xyzw, cb0[0].xyzw);
  r0.xyzw = r0.xxxx ? r0.yyyy : r1.xyzw;
  r0.w = dot(r0.xyzw, cb0[1].xyzw);
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xyz = saturate(r0.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = cb0[4].xxx * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.w = cmp(cb0[4].x != 1.000000);
  o0.xyz = r1.www ? r1.xyz : r0.xyz;
  o0.w = r0.w;
  o1.xyzw = float4(0,0,0,0);

  return;
}