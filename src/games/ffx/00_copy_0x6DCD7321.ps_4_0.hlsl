#include "./shared.h"
#include "./common.hlsl"

SamplerState ColorBufferState_s : register(s0);
Texture2D<float4> ColorBuffer : register(t0);

// 3Dmigoto declarations
#define cmp -



void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1, -1) + float2(0, 1);
  o0.xyzw = ColorBuffer.Sample(ColorBufferState_s, r0.xy).xyzw;

  o0.rgb = FinalizeOutput(o0.rgb);

  return;
}
