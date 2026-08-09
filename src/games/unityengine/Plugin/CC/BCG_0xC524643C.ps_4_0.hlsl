#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = cb0[6].xyz;
  r1.w = r0.w;
  r0.xyzw = r0.xyzw * cb0[6].wwww + -r1.xyzw;
  r0.xyzw = r0.xyzw * cb0[7].xxxx + r1.xyzw;
  r0.w = saturate(r0.w);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
    r0.xyzw = log2(r0.xyzw);
    r0.xyzw = cb0[7].yyyy * r0.xyzw;
    r0.xyzw = exp2(r0.xyzw);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[7].y);
    r0.w = pow(r0.w, cb0[7].y);
  }
  o0.xyzw = r0.xyzw;
  return;
}