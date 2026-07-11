#include "./common.hlsl"

// Found in the first "mansion"
// In some areas no uberpost shader is drawn, so the game essentially becomes just clipped to surface
// This shader contains the game render with no UI
// We check a cbuffer, and when no uberpost exists; we tonemap here

// ---- Created with 3Dmigoto v1.3.16 on Thu Jun 19 02:29:37 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  o0.xyz = r0.xyz;

  o0.w = 1;

  // Only tonemap if uberpost is not spawned
  if (UBERPOST_EXIST == 0) {
    o0 = ProcessColor(o0.rgb);
  }

  return;
}
