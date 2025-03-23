#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s2_s, v1.xy).x;
  r0.x = cb0[5].y + r0.x;
  r0.x = saturate(cb0[5].x * r0.x);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r2.xyzw = t2.Sample(s1_s, v1.xy).xyzw;
  r2.rgb = renodx::math::SignPow(r2.rgb, 2.f);
  r0.rgba = lerp(r2.rgba, r1.rgba, r0.x);
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}