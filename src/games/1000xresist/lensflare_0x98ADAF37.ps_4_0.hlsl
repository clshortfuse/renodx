#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Dec 12 19:14:33 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[14];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float lensFlareMul = injectedData.fxLensFlare / 2;  // It's too high by default, so we increase granularity
  o0.xyz = (r0.xyz * cb0[13].xxx * lensFlareMul) + r1.xyz;
  o0.w = r1.w;
  return;
}
