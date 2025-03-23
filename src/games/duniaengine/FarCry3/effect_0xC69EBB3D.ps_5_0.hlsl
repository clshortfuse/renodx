#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float2 v6 : TEXCOORD5,
  uint v7 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  r0.xyz = v2.zzz * r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r1.w = max(0, r1.w);
  r0.w = max(r1.w, r0.w);
  r0.xyz = r1.xyz * v1.zzz + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.w = max(r1.w, r0.w);
  r0.xyz = r1.xyz * v3.zzz + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v4.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r0.w = max(r1.w, r0.w);
  r0.xyz = r1.xyz * v4.zzz + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  o0.w = max(r1.w, r0.w);
  r0.xyz = r1.xyz * v5.zzz + r0.xyz;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  return;
}