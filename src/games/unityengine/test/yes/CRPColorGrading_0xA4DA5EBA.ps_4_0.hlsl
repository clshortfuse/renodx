#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

// Approximately Up

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.w = r0.w;
  r1.y = dot(float3(0.439700991,0.382977992,0.177334994), r0.xyz);
  r1.z = dot(float3(0.0897922963,0.813422978,0.0967615992), r0.xyz);
  r1.w = dot(float3(0.0175439995,0.111543998,0.870703995), r0.xyz);
  r1.xyz = Ap1AcesTonemap(r1.yzw);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r1.xyz = GradeAndDisplayMap(r1.xyz);
  }
  r0.xyz = float3(255,255,255) * r1.xyz;
  r0.xyz = floor(r0.xyz);
  r1.xyz = r1.xyz * float3(255,255,255) + -r0.xyz;
  r2.xy = cb1[6].xy * v1.xy;
  r2.xy = float2(0.03125,0.03125) * r2.xy;
  r0.w = asint(cb0[2].x) & 63;
  r2.z = (uint)r0.w;
  r2.xyzw = t0.SampleLevel(s1_s, r2.xyz, 0).xyzw;
  r1.xyz = r2.xyz < r1.xyz ? float3(1,1,1) : 0;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(0.00392156886, 0.00392156886, 0.00392156886) * r0.xyz;
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}