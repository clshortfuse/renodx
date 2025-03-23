#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.x = log2(r0.w);
  r1.x = cb0[4].z * r1.x;
  r1.x = exp2(r1.x);
  r1.y = cmp(r0.w >= 0.100000001);
  r1.y = r1.y ? 1.000000 : 0;
  r1.x = r1.y * r1.x;
  r1.x = saturate(cb0[6].x * r1.x);
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.rgb = renodx::math::SignPow(r2.rgb, 2.f);
  r0.rgba = lerp(r2.rgba, r0.rgba, r1.x);
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}