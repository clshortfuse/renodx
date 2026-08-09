#include "../../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[43];
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

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r0.xyz = r0.yzw * r0.xxx;
  if (cb0[42].x > 0.5) {
    o0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  } else {
    o0.w = r1.w;
  }
  o0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  return;
}