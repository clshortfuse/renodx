#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s0_s, v2.zw).xyz;
  r0.w = t0.Sample(s0_s, v1.xy).x;
  r1.x = renodx::math::SignPow(r0.w, 2.f);
  r0.w = t0.Sample(s0_s, v1.zw).y;
  r1.y = renodx::math::SignPow(r0.w, 2.f);
  r0.w = t0.Sample(s0_s, v2.xy).z;
  r1.z = renodx::math::SignPow(r0.w, 2.f);
  r0.xyz = renodx::math::SignPow(r0.rgb, 2.f) + -r1.xyz;
  r0.w = saturate(cb0[8].y);
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = 1;
  return;
}