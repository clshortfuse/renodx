#include "../../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r0.x = cb1[7].z * r0.x + cb1[7].w;
  r0.x = 1 / r0.x;
  r0.y = r0.x < cb0[4].x ? 1.0 : 0;
  r0.z = -cb0[4].x + r0.x;
  r0.y = -cb0[5].x * r0.y + abs(r0.z);
  r0.y = cb0[4].y * r0.y;
  r0.y = 0.5 * r0.y;
  r0.y = r0.y / r0.x;
  o0.w = cb0[6].y >= r0.x ? r0.y : 0;
  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = min(cb0[6].xxx, r0.xyz);
  o0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  return;
}