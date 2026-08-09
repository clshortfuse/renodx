#include "../../tonemap.hlsl"

Texture2D<float4> t10 : register(t10);
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
SamplerState s10_s : register(s10);
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
  float4 cb0[51];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[46].xxx * r1.xyz + r0.xyz;
  r1.xyz = r3.xyz + -r2.xyz;
  r1.xyz = cb0[46].yyy * r1.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[46].zzz * r1.xyz + r0.xyz;
  r1.xyzw = t10.Sample(s10_s, v1.xy).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[50].xxx * r1.xyz + r0.xyz;
  if (cb0[47].x > 0.001) {
    r2.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[47].xxx * r2.xyz + r0.xyz;
  }
  if (cb0[47].y > 0.001) {
    r2.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[47].yyy * r2.xyz + r0.xyz;
  }
  if (cb0[47].z > 0.001) {
    r2.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
    r1.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[47].zzz * r1.xyz + r0.xyz;
  }
  if (cb0[47].w > 0.001) {
    r1.xyzw = t7.Sample(s7_s, v1.xy).xyzw;
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[47].www * r1.xyz + r0.xyz;
  }
  if (cb0[48].x > 0.001) {
    r2.xyzw = t8.Sample(s8_s, v1.xy).xyzw;
    r1.xzw = r2.xyz + -r0.xyz;
    r0.xyz = cb0[48].xxx * r1.xzw + r0.xyz;
  }
  if (cb0[48].y > 0.001) {
    r1.xyzw = t9.Sample(s9_s, v1.xy).xyzw;
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[48].yyy * r1.xyz + r0.xyz;
  }
  r0.xyz = applyUserNoTonemap(r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}