#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:29:13 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yw = float2(0.125, 0.375);
  r1.xyzw = t0.SampleLevel(s1_s, w1.xy, 0).zxyw;
  r0.xz = r1.yz;
  r2.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r2.xyz = float3(0, 1, 0) * r2.xyz;
  r0.xyz = r0.xyz * float3(1, 0, 0) + r2.xyz;
  o0.w = r1.w;
  r1.y = 0.625;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0, 0, 1) + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.219999999, 0.707000017, 0.0710000023));
  r0.xyz = r0.xyz + -r0.www;
  o0.xyz = cb0[2].zzz * r0.xyz + r0.www;

  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}
