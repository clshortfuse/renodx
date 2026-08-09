#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.w = 1;
  r1.x = cb0[2].x;
  r1.w = 1;
  r2.y = 1;
  r3.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r2.x = dot(r3.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r4.xyzw = r3.xyzw + -r2.xxxy;
  r1.xyzw = r1.xxxw * r4.xyzw + r2.xxxy;
  r1.xyzw = log2(r1.xyzw);
  r2.yz = max(float2(0,0.100000001), cb0[2].wy);
  r0.xyz = min(float3(5000,5000,5000), r2.zzz);
  r2.y = min(cb0[2].z, r2.y);
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyz = cb0[4].xyz * r0.xyz;
  o0.w = saturate(r0.w);
  r0.w = cb0[3].x + -r2.y;
  r0.w = r2.x * r0.w + r2.y;
  r1.x = -0.5 + r2.x;
  r1.x = -abs(r1.x) * 2 + 1;
  r1.y = max(0, cb0[3].x);
  r1.y = min(cb0[2].w, r1.y);
  r1.y = r1.y + -r0.w;
  r0.w = r1.x * r1.y + r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = 1 / cb0[3].y;
  r0.xyz = saturate(r0.xyz * r0.www);
  r1.xyz = r0.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = r1.xyz * r0.xyz + -r3.xyz;
  o0.xyz = cb0[3].zzz * r0.xyz + r3.xyz;
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}