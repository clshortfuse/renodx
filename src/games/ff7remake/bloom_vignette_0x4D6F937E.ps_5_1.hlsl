#include "./shared.h"

Texture2D<float4> t0 : register(t0);  // Render
Texture2D<float4> t1 : register(t1);  // Bloom

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb1 : register(b1) {
  float4 cb1[123];
}

cbuffer cb0 : register(b0) {
  float4 cb0[21];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    linear noperspective float4 v1: TEXCOORD1,
    float4 v2: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb1[121].xy + v2.xy;
  r0.xy = cb1[122].zw * r0.xy;
  r0.xy = cb0[19].zw * r0.xy;
  r0.xy = max(float2(0.5, 0.5), r0.xy);
  r0.zw = float2(-0.5, -0.5) + cb0[19].zw;
  r0.xy = min(r0.xy, r0.zw);
  r0.xy = cb0[1].zw * r0.xy;
  r0.xyz = t1.Sample(s1_s, r0.xy).xyz * CUSTOM_BLOOM;
  r0.w = max(0.00100000005, cb0[20].y);
  r0.w = rcp(r0.w);
  r1.z = v1.z * r0.w;
  r1.xy = v1.xy;
  r0.w = dot(r1.xyz, r1.xyz);
  r1.x = r1.z * r1.z;
  r0.w = rcp(r0.w);
  r0.w = r1.x * r0.w;
  r0.w = r0.w * r0.w + -1;
  r0.w = cb0[20].x * r0.w + 1;
  r0.w = max(0, r0.w);
  r1.xyz = t0.SampleLevel(s0_s, v0.xy, 0).xyz;
  r2.xyz = r1.xyz * r0.www;
  r3.xy = float2(1, 1) + -cb0[18].yz * CUSTOM_VIGNETTE;
  r3.xzw = r3.xxx * r2.xyz;

  r0.xyz = r3.xzw * r3.yyy + r0.xyz;
  r0.xyz = -r1.xyz * r0.www + r0.xyz;
  o0.xyz = cb0[18].xxx * r0.xyz + r2.xyz;

  o0.w = 1;
  return;
}
