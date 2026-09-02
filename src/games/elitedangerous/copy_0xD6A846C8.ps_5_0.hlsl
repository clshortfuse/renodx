#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Thu Jun 18 00:28:59 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  o0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;

  o0.rgb = GameScaleAndGrain(o0.rgb, v0.xy);

  return;
}
