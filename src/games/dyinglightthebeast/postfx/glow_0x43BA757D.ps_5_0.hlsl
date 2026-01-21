#include "../shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Mon Sep 22 15:25:28 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    linear noperspective float4 v1: TEXCOORD0,
    out float3 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.SampleLevel(s1_s, v1.zw, 0).x;
  r0.yzw = t0.Sample(s0_s, v1.xy).xyz;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = cb0[0].yyy * r0.xyz;

  float3 lens_flare = r0.rgb * CUSTOM_LENS_FLARE;

  r1.xyz = t1.Sample(s0_s, v1.xy).xyz;
  float3 bloom = r1.rgb * cb0[0].x * CUSTOM_BLOOM;

  o0.xyz = bloom + lens_flare;
  return;
}
