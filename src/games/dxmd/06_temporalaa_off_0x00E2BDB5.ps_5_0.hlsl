#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11) {
  float4 cb11[88];
}

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  float3 outputColor = max(0, r0.rgb);
  outputColor = pow(outputColor, cb11[87].x);

  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(outputColor);
  }

  return float4(outputColor.rgb, r0.w);
}
