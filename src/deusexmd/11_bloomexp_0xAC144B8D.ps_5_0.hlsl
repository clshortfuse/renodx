// Bloom + Exp

#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11) {
  float4 cb11[18];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float2 v1 : TEXCOORD0,
                          out float4 o0 : SV_TARGET0
) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  // r0.xyzw = cb11[17].xyzw * r0.xyzw;
  r0.xyzw = cb11[17].xyzw * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xyzw = cb11[16].xyzw * r1.xyzw * injectedData.fxBloom + r0.xyzw;  // Exposure

  return;
}
