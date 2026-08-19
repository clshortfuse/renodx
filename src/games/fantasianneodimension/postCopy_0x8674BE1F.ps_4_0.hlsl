// ---- Created with 3Dmigoto v1.3.16 on Thu Dec  5 19:31:25 2024
// Last shader that's the game render during the open world
// Spawns in battles along side the blit shader

#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0) {
  o0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  return;
}