#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[22];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float2 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[21].xx ? cb0[4].zw : float2(0,0);
  r0.xy = v1.xy * cb0[4].xy + r0.xy;
  r0.xyzw = t1.Sample(s3_s, r0.xy).xyzw;
  r0.x = saturate(r0.x);
  r0.x = 1 + -r0.x;
  r0.yz = cb0[6].zw * v2.xy;
  r0.y = dot(float2(171,231), r0.yz);
  r0.yzw = float3(0.00970873795,0.0140845068,0.010309278) * r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = float3(-0.5,-0.5,-0.5) + r0.yzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyz = cb0[6].yyy * r1.xyz;
  r0.yzw = r0.yzw * (1.0 / 255.0) + r2.xyz;
  r2.xyz = max(float3(1,1,1), r2.xyz);
  float3 hdrColor = renodx::color::srgb::DecodeSafe(r0.yzw);
  /*r0.yzw = min(float3(0.999000013,0.999000013,0.999000013), r0.yzw);
  r0.yzw = r0.yzw * float3(0.0302734375,0.96875,31) + float3(0.00048828125,0.015625,0.5);
  r0.w = floor(r0.w);
  r0.yz = r0.ww * float2(0.03125,0) + r0.yz;
  r3.xyzw = t3.SampleLevel(s1_s, r0.yz, 0).xyzw;
  r4.xyzw = t2.SampleLevel(s2_s, r0.yz, 0).xyzw;*/
  r3.xyz = handleUserLUT(hdrColor, t3, s3_s, float3(1 / 1024, 1 / 32, 31));
  r4.xyz = handleUserLUT(hdrColor, t2, s2_s, float3(1 / 1024, 1 / 32, 31));
  r1.xyz = r4.xyz;
  r3.xyz = r3.xyz + -r1.xyz;
  r3.w = 0;
  r0.xyzw = r0.xxxx * r3.xyzw + r1.xyzw;
  o0.xyz = r0.xyz * r2.xyz;
  o0.w = r0.w;
  
  return;
}