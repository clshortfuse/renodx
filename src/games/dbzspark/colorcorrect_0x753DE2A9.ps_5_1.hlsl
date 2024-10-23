// ---- Created with 3Dmigoto v1.3.16 on Fri Oct 18 20:09:35 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[7];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

// Increases brightness
void main(
    float4 v0 : SV_POSITION0,
                out float4 o0 : SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 tonemappedPQ, post_srgb, output;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = r0.xy * cb0[38].zw + cb1[1].zw;
  r0.xy = cb0[38].zw * r0.xy;
  r0.xy = r0.xy * cb0[5].xy + cb0[4].xy;
  r0.zw = float2(-0.5, -0.5) + r0.zw;
  r0.z = dot(r0.zw, cb1[4].xy);
  r0.z = 0.5 + r0.z;
  r0.w = 1 + -r0.z;
  r0.z = r0.z * r0.w + cb1[4].z;
  r0.w = log2(r0.z);
  r0.z = cmp(0 >= r0.z);
  r0.w = cb1[4].w * r0.w;
  r0.w = exp2(r0.w);
  r0.w = min(1, r0.w);
  r0.z = r0.z ? 0 : r0.w;
  r1.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.xyw = t0.Sample(s1_s, r0.xy).xyz;

  // Both are game render so we srgb both
  tonemappedPQ = r1.xyz;
  r0.xyw = pqTosRGB(r0.xyw);
  r1.xyz = pqTosRGB(r1.xyz);

  r1.xyz = r1.xyz * r0.zzz + -r0.xyw;
  r0.xyz = cb1[5].xxx * r1.xyz + r0.xyw;
  r1.xyz = cb1[6].xyz + -r0.xyz;
  r0.xyz = cb1[5].yyy * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0, 0, 0), r0.xyz);
  post_srgb = o0.rgb;
  o0.w = 0;

  o0.rgb = upgradeSRGBtoPQ(tonemappedPQ, post_srgb);
  // o0.rgb = tonemappedPQ;

  return;
}