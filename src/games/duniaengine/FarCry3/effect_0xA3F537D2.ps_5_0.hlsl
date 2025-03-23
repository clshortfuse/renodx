#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[14];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[6].xy + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  r0.xyzw = cb0[6].zzzz * r0.xyzw;
  r1.xy = cb0[5].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[5].zzzz * r1.xyzw + r0.xyzw;
  r1.xy = cb0[7].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[7].zzzz * r1.xyzw + r0.xyzw;
  r1.xy = cb0[8].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[8].zzzz * r1.xyzw + r0.xyzw;
  r1.xy = cb0[9].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[9].zzzz * r1.xyzw + r0.xyzw;
  r1.xy = cb0[10].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[10].zzzz * r1.xyzw + r0.xyzw;
  r1.xy = cb0[11].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[11].zzzz * r1.xyzw + r0.xyzw;
  r1.xy = cb0[12].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[12].zzzz * r1.xyzw + r0.xyzw;
  r1.xy = cb0[13].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = cb0[13].zzzz * r1.xyzw + r0.xyzw;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}