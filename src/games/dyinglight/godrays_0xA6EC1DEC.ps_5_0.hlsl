#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:30 2024
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t2.SampleLevel(s2_s, v1.xy, 0).xyz;
  r0.xyz = cb0[0].yyy * r0.xyz;
  r0.w = t1.SampleLevel(s1_s, float2(0,0), 0).x;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r1.xyz = r1.xyz * r0.www;
  o0.w = r1.w;
  r0.w = dot(float3(0.212500006,0.715399981,0.0720999986), r1.xyz);
  r2.xy = r0.ww * cb0[0].xz + cb0[0].zz;
  r0.w = r2.x / r2.y;
  o0.xyz = r1.xyz * r0.www + r0.xyz;  //  o0.xyz = saturate(r1.xyz * r0.www + r0.xyz);
  return;
}