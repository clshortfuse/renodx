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

  r0.xy = v1.xy * cb0[6].zw + cb0[6].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  r0.xyzw = float4(0.089041099,0.089041099,0.089041099,0.089041099) * r0.xyzw;
  r1.xy = v1.xy * cb0[5].zw + cb0[5].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.0684931502,0.0684931502,0.0684931502,0.0684931502) + r0.xyzw;
  r1.xy = v1.xy * cb0[7].zw + cb0[7].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.12328767,0.12328767,0.12328767,0.12328767) + r0.xyzw;
  r1.xy = v1.xy * cb0[8].zw + cb0[8].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.143835619,0.143835619,0.143835619,0.143835619) + r0.xyzw;
  r1.xy = v1.xy * cb0[9].zw + cb0[9].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.150684938,0.150684938,0.150684938,0.150684938) + r0.xyzw;
  r1.xy = v1.xy * cb0[10].zw + cb0[10].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.143835619,0.143835619,0.143835619,0.143835619) + r0.xyzw;
  r1.xy = v1.xy * cb0[11].zw + cb0[11].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.12328767,0.12328767,0.12328767,0.12328767) + r0.xyzw;
  r1.xy = v1.xy * cb0[12].zw + cb0[12].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.089041099,0.089041099,0.089041099,0.089041099) + r0.xyzw;
  r1.xy = v1.xy * cb0[13].zw + cb0[13].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw * float4(0.0684931502,0.0684931502,0.0684931502,0.0684931502) + r0.xyzw;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}