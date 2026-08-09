#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = cb0[2].y * injectedData.fxCA;
  r0.x = 0;
  r0.zw = v0.xy * cb0[4].xy + cb0[4].zw;
  r1.xyzw = r0.zwzw + r0.yxxy;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  o0.yw = r0.yw;
  r0.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  o0.z = r1.z;
  o0.x = r0.x;
  return;
}