#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[27];
}
cbuffer cb0 : register(b0){
  float4 cb0[5];
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

  r0.xyz = t0.Sample(s2_s, v1.zw).xyz;
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f);
  r1.xyz = t0.Sample(s2_s, v1.xy).xyz;
  r0.rgb = renodx::math::SignPow(r1.rgb, 2.f) + r0.rgb;
  r1.xyz = t0.Sample(s2_s, v2.xy).xyz;
  r0.rgb = renodx::math::SignPow(r1.rgb, 2.f) + r0.rgb;
  r1.xyz = t0.Sample(s2_s, v2.zw).xyz;
  r0.rgb = renodx::math::SignPow(r1.rgb, 2.f) + r0.rgb;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  o0.xyz = renodx::math::SignSqrt(r0.xyz);
  r0.x = t2.Sample(s0_s, v1.xy).x;
  r0.x = cb1[26].y * r0.x + cb1[26].x;
  r0.x = 1 / r0.x;
  r0.x = saturate(cb0[4].y * r0.x);
  r0.x = 1 + -r0.x;
  r0.y = t1.Sample(s1_s, v1.xy).x;
  r0.y = 1 + -r0.y;
  r0.y = cb0[4].x * r0.y;
  o0.w = r0.y * r0.x;
  return;
}