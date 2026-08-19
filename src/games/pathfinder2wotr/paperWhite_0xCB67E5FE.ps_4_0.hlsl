// ---- Created with 3Dmigoto v1.3.16 on Tue Nov  5 00:45:44 2024
// Scale our brightness here

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
  // Apparently the below is just a scuffed way of checking for negative numbers?
  // r1.xyz = (int3)r0.xyz & int3(0x7fffffff,0x7fffffff,0x7fffffff);
  // r2.xyz = cmp(int3(0x7f800000,0x7f800000,0x7f800000) < (uint3)r1.xyz);
  // r1.xyz = cmp((int3)r1.xyz == int3(0x7f800000,0x7f800000,0x7f800000));
  // r1.w = (int)r2.y | (int)r2.x;
  // r1.w = (int)r2.z | (int)r1.w;
  // r1.x = (int)r1.y | (int)r1.x;
  // r1.x = (int)r1.z | (int)r1.x;
  // r1.x = (int)r1.x | (int)r1.w;
  // o0.xyz = r1.xxx ? float3(0,0,0) : r0.xyz;

  o0.rgb = r0.rgb;

  o0.w = r0.w;
  return;
}