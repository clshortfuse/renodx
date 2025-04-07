#include "./shared.h"
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

void main(
    float4 v0: TEXCOORD1,
    float4 v1: TEXCOORD2,
    float4 v2: TEXCOORD3,
    float4 v3: TEXCOORD4,
    float4 v4: TEXCOORD5,
    float4 v5: TEXCOORD6,
    float2 v6: TEXCOORD7,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s0_s, v1.xy).xyz;
  r1.xyz = t0.Sample(s0_s, v0.zw).xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r2.xyz = t0.Sample(s0_s, v2.xy).xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r3.xyz = t0.Sample(s0_s, v2.zw).xyz;
  r0.xyz = r3.xyz + r0.xyz;
  r3.xyz = r3.xyz + r2.xyz;
  r0.xyz = float3(0.25, 0.25, 0.25) * r0.xyz;
  r4.xyz = t0.Sample(s0_s, v0.xy).xyz;
  r1.xyz = r4.xyz + r1.xyz;
  r4.xyz = t0.Sample(s0_s, v1.zw).xyz;
  r1.xyz = r4.xyz + r1.xyz;
  r4.xyz = r4.xyz + r2.xyz;
  r1.xyz = r1.xyz + r2.xyz;
  r0.xyz = r1.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
  r1.xyz = t0.Sample(s0_s, v3.xy).xyz;
  r1.xyz = r4.xyz + r1.xyz;
  r2.xyz = t0.Sample(s0_s, v3.zw).xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r0.xyz = r1.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
  r1.xyz = t0.Sample(s0_s, v4.xy).xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = r1.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
  r1.xyz = t0.Sample(s0_s, v4.zw).xyz;
  r2.xyz = t0.Sample(s0_s, v5.xy).xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyz = t0.Sample(s0_s, v5.zw).xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyz = t0.Sample(s0_s, v6.xy).xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = float3(0.125, 0.125, 0.125) * r1.xyz;
  o0.xyz = r0.xyz * float3(0.125, 0.125, 0.125) + r1.xyz;
  o0.w = 0;

  o0.rgb *= CUSTOM_BLOOM;

  return;
}
