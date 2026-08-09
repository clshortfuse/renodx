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
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[28].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = saturate(cb0[28].yyy * r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[28].x);
    r0.xyz = cb0[28].yyy * r0.xyz;
  }
  o0.xyz = r0.xyz;
  return;
}