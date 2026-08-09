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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = min(cb0[7].zzz, r0.xyz);
  r2.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = r2.xyz + -cb0[5].www;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  r0.x = max(r2.y, r2.z);
  o0.w = max(r2.x, r0.x);
  return;
}