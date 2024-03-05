#include "../common/color.hlsl"
#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(out float4 outputColor : SV_TARGET0) {
  float4 r0;

  // r0.xyz = saturate(cb0[6].xyz);
  r0.xyz = cb0[6].xyz;
  outputColor.xyz = pow(r0.xyz, cb0[7].x);
  outputColor.w = cb0[6].w;

  outputColor.rgb = pow(outputColor.rgb, 2.2f);
  if (injectedData.toneMapperEnum != 0) {
    outputColor.rgb *= injectedData.uiPaperWhite;
  } else {
    outputColor.rgb *= 203.f;
  }
  outputColor.rgb /= 80.f;
  return;
}
