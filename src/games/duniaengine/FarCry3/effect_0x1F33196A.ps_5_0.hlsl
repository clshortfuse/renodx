#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s1_s, v1.xy).xyz;
  r0.x = 6.28319979 * r0.x;
  sincos(r0.x, r0.x, r1.x);
  r1.y = r0.x;
  r2.xyzw = r1.xxyy * r0.zzzz + v1.xxyy;
  r0.xz = r1.xy * r0.zz;
  r1.xyzw = r2.xyzw * cb0[7].xyzw + cb0[8].xyzw;
  r1.xy = saturate(min(r1.xz, r1.yw));
  r1.zw = r0.xz * r1.xy + v1.xy;
  r0.xz = r1.xy * r0.xz;
  r0.w = t0.Sample(s1_s, r1.zw).w;
  r0.xz = r0.xz * r0.ww + v1.xy;
  r1.xy = t1.Sample(s2_s, v1.xy).xz;
  r0.w = 6.28319979 * r1.x;
  sincos(r0.w, r1.x, r2.x);
  r2.y = r1.x;
  r3.xyzw = r2.xxyy * r1.yyyy + v1.xxyy;
  r1.xy = r2.xy * r1.yy;
  r2.xyzw = r3.xyzw * cb0[7].xyzw + cb0[8].xyzw;
  r1.zw = saturate(min(r2.xz, r2.yw));
  r2.xy = r1.xy * r1.zw + v1.xy;
  r1.xy = r1.xy * r1.zw;
  r0.w = t1.Sample(s2_s, r2.xy).w;
  r0.xz = r1.xy * r0.ww + r0.xz;
  r1.xyzw = t3.Sample(s3_s, r0.xz).xyzw;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r2.xyzw = t2.Sample(s0_s, v1.xy).xyzw;
  r2.rgb = renodx::math::SignPow(r2.rgb, 2.f);
  r3.xyzw = -r2.xyzw + r1.xyzw;
  r0.xyzw = r0.yyyy * r3.xyzw + r2.xyzw;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = -cb0[6].xxxx * r1.xyzw + r0.xyzw;
  o0.xyz = renodx::math::SignSqrt(r0.rgb);
  o0.w = saturate(r0.w);
  return;
}