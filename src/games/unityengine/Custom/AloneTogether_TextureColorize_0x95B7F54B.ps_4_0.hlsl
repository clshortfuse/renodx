#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  r1.xyz = cb0[4].xyz * cb0[4].www;
  r1.w = cb0[5].x;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r2.x = cb0[5].x;
  r2.w = 0;
  o0.xyzw = r0.xyzw * r2.xxxw + r1.xyzw;
  o0.w = saturate(o0.w);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.xyz = saturate(o0.xyz);
  }
  return;
}