#include "../common/color.hlsl"
#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(out float4 outputColor : SV_TARGET0) {
  float4 r0;

  r0.xyz = saturate(cb0[6].xyz);
  r0.xyz = cb0[6].xyz;
  outputColor.xyz = pow(r0.xyz, cb0[7].x);
  outputColor.w = cb0[6].w;

  outputColor.rgb = pow(outputColor.rgb, 2.2f);
  outputColor.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
