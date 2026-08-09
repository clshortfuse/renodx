#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[77];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  uint4 v3 : TEXCOORD2,
  float3 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, cb0[76].x).xyzw;
  r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyz = cb0[76].yyy ? r1.xyz : r0.xyz;
  o0.w = r0.w;
  return;
}