#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[29];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 / cb0[28].x;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  //r0.yzw = log2(r1.xyz);
  o0.w = r1.w;
  //r0.xyz = r0.xxx * r0.yzw;
  //o0.xyz = exp2(r0.xyz);
  o0.rgb = renodx::math::SignPow(r1.rgb, r0.x);
  return;
}