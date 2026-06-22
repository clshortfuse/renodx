#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sun Jun 21 19:28:50 2026
Texture3D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[9];
}

// 3Dmigoto declarations
#define cmp -

[numthreads(32, 2, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1;
  uint3 u0_temp;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (float3)vThreadID.xyz;
  r0.xyz = float3(0.0322580636, 0.0322580636, 0.0322580636) * r0.xyz;
  r0.xyz = min(float3(1, 1, 1), r0.xyz);
  r0.xyz = cb0[8].yyy * r0.xyz;
  u0_temp.xyz = (uint3)r0.xyz;
  r0.xyz = f16tof32(u0_temp.xyz);
  r0.xyz = cb0[8].xxx * r0.xyz;

  r0.xyz = renodx::color::pq::Encode(r0.xyz, 100.f);
  r0.xyz = r0.xyz * float3(0.969696999, 0.969696999, 0.969696999) + float3(0.0151515156, 0.0151515156, 0.0151515156);
  r0.xyz = t0.SampleLevel(s0_s, r0.xyz, 0).xyz;
  r0.w = 1;
  u0[vThreadID.xyz] = r0.xyzw;
  return;
}
