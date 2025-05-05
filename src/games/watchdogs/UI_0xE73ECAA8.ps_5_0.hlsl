#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[18];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.zz;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r1.xyzw = v0.xyzw * r1.xyzw;
  r0.xyz = r1.xyz * r0.xyz;
  o0.w = r1.w;
  o0.xyz = cb0[17].xxx * r0.xyz;
  o0.rgb = UIScale(o0.rgb);
  return;
}