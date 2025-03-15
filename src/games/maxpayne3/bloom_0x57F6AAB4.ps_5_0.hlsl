#include "./shared.h"

SamplerState HDRPointSampler_s : register(s6);
SamplerState BloomSampler_s : register(s10);
Texture2D<float4> HDRPointSampler : register(t6);
Texture2D<float4> BloomSampler : register(t10);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    float4 v4: TEXCOORD3,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;

  r0.xyz = BloomSampler.Sample(BloomSampler_s, v2.zw).xyz;
  r1.xyz = HDRPointSampler.Sample(HDRPointSampler_s, v1.xy).xyz;
  r0.xyz = -r1.xyz + r0.xyz;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(0.330000013, 0.330000013, 0.330000013) * r0.xyz;
  r2.xyz = BloomSampler.Sample(BloomSampler_s, v1.zw).xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r0.xyz = r2.xyz * float3(0.0500000007, 0.0500000007, 0.0500000007) + r0.xyz;
  r2.xyz = BloomSampler.Sample(BloomSampler_s, v3.xy).xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r0.xyz = r2.xyz * float3(0.330000013, 0.330000013, 0.330000013) + r0.xyz;
  r2.xyz = BloomSampler.Sample(BloomSampler_s, v4.xy).xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r0.xyz = r2.xyz * float3(0.0500000007, 0.0500000007, 0.0500000007) + r0.xyz;
  r2.xyz = BloomSampler.Sample(BloomSampler_s, v2.xy).xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r0.xyz = r2.xyz * float3(0.119999997, 0.119999997, 0.119999997) + r0.xyz;
  r2.xyz = BloomSampler.Sample(BloomSampler_s, v3.zw).xyz;
  r1.xyz = r2.xyz + -r1.xyz;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r0.xyz = r1.xyz * float3(0.119999997, 0.119999997, 0.119999997) + r0.xyz;
  r1.xyz = BloomSampler.Sample(BloomSampler_s, v1.xy).xyz;
  o0.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + r1.xyz;
  o0.w = 1;

  o0.rgb *= CUSTOM_BLOOM;
  return;
}
