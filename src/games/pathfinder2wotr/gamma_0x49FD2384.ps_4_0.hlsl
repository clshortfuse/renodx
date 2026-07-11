// ---- Created with 3Dmigoto v1.3.16 on Mon Nov  4 00:21:29 2024
// Game goes linear -> gamma here
// We comment everything

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  // r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  // r1.xyz = float3(0.947867334,0.947867334,0.947867334) * r1.xyz;
  // r1.xyz = log2(abs(r1.xyz));
  // r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  // r0.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  // o0.w = r0.w;
  // r0.xyz = r0.xyz ? r2.xyz : r1.xyz;

  // r0.rgb = renodx::math::PowSafe(r0.rgb, 1.f / 2.2f);
  // r0.rgb = renodx::math::PowSafe(r0.rgb, 2.2f);  // Linearize

  o0.rgb = r0.rgb;
  //o0.w = r0.w;
  o0.w = 1.f;

  // r1.xyz = (int3)r0.xyz & int3(0x7fffffff,0x7fffffff,0x7fffffff);
  // r2.xyz = cmp(int3(0x7f800000,0x7f800000,0x7f800000) < (uint3)r1.xyz);
  // r1.xyz = cmp((int3)r1.xyz == int3(0x7f800000,0x7f800000,0x7f800000));
  // r0.w = (int)r2.y | (int)r2.x;
  // r0.w = (int)r2.z | (int)r0.w;
  // r1.x = (int)r1.y | (int)r1.x;
  // r1.x = (int)r1.z | (int)r1.x;
  // r0.w = (int)r0.w | (int)r1.x;
  // o0.xyz = r0.www ? float3(0,0,0) : r0.xyz;
  return;
}