#include "../../shared.h"

Texture2D<float4> t9 : register(t9);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s9_s : register(s9);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[59];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s2_s, w1.xy).xyzw;
  r0.xyz = cb0[46].xxx * r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = cb0[48].yyy * r0.xyz;
  r0.xyz = cb0[51].yyy * r0.xyz;
  r2.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  r2.xyz = cb0[46].xxx * r2.xyz;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = cb0[48].xxx * r2.xyz + r1.xyz;
  r0.xyz = cb0[51].xxx * r2.xyz + r0.xyz;
  r2.xyzw = t2.Sample(s3_s, w1.xy).xyzw;
  r2.xyz = cb0[46].xxx * r2.xyz;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = cb0[48].zzz * r2.xyz + r1.xyz;
  r0.xyz = cb0[51].zzz * r2.xyz + r0.xyz;
  r2.xyzw = t3.Sample(s4_s, w1.xy).xyzw;
  r2.xyz = cb0[46].xxx * r2.xyz;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = cb0[48].www * r2.xyz + r1.xyz;
  r0.xyz = cb0[51].www * r2.xyz + r0.xyz;
  r2.xyzw = t4.Sample(s5_s, w1.xy).xyzw;
  r2.xyz = cb0[46].xxx * r2.xyz;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = cb0[49].xxx * r2.xyz + r1.xyz;
  r0.xyz = cb0[52].xxx * r2.xyz + r0.xyz;
  r2.xyzw = t5.Sample(s6_s, w1.xy).xyzw;
  r2.xyz = cb0[46].xxx * r2.xyz;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = cb0[49].yyy * r2.xyz + r1.xyz;
  r0.xyz = cb0[52].yyy * r2.xyz + r0.xyz;
  r0.xyz = cb0[52].zzz * r0.xyz;
  r1.xyz = cb0[57].zzz * r1.xyz;
  r2.xyzw = t7.Sample(s8_s, w1.xy).xyzw;
  r1.xyz = r1.xyz * cb0[58].xxx + r2.xyz;
  r2.xyzw = t8.Sample(s9_s, w1.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyzw = t9.Sample(s7_s, v1.xy).xyzw * CUSTOM_LENS;
  r0.xyz = r0.xyz * r2.xyz + r1.xyz;
  r1.xyzw = t6.Sample(s0_s, v3.xy).xyzw;
  o0.xyz = cb0[57].yyy * r1.xyz + r0.xyz * CUSTOM_BLOOM;
  r0.x = cb0[57].y * r1.w;
  o0.w = r0.x;
  return;
}