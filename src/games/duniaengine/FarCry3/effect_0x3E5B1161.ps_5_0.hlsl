#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

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

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  r1.xyzw = t0.Sample(s0_s, v1.zw).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.zw).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = r0.w;
  return;
}