#include "../../tonemap.hlsl"

Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
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
  r0.xyzw = cb0[2].yyyy * r0.xyzw;
  r0.xyz = sqrt(r0.xyz);
  o0.w = r0.w;
  r1.xyz = cb0[2].zzz + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  r1.xyz = cb0[2].www + r1.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[2].xxx * r1.xyz + r0.xyz;
  o0.xyz = r0.xyz * r0.xyz;
  return;
}