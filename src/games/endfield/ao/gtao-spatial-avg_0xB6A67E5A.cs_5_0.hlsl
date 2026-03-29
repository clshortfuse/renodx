// ---- Created with 3Dmigoto v1.4.1 on Tue Feb 10 15:11:49 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[83];
}


#include "../shared.h"

#define cmp -

RWTexture2D<unorm float4> u0 : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1;
  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.zw = r0.xy * cb0[82].zw + -cb0[82].zw;
  r0.z = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r1.xy = cb0[82].zw * r0.xy;
  r0.xy = r0.xy * cb0[82].zw + cb0[82].zw;
  r0.x = t0.SampleLevel(s0_s, r0.xy, 0).x;
  r0.y = t0.SampleLevel(s0_s, r1.xy, 0).x;
  r1.xyzw = cb0[82].zwzw * float4(1,-1,-1,1) + r1.xyxy;
  r0.y = r0.y + r0.z;
  r0.z = t0.SampleLevel(s0_s, r1.xy, 0).x;
  r0.w = t0.SampleLevel(s0_s, r1.zw, 0).x;
  r0.y = r0.y + r0.z;
  r0.y = r0.y + r0.w;
  r0.x = r0.y + r0.x;
  r0.x = 0.200000003 * r0.x;
  u0[vThreadID.xy] = r0.xxxx;
  return;
}