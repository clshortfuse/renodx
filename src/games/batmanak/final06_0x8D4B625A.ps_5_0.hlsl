#include "../../common/color.hlsl"
#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(out float4 o0 : SV_TARGET0) {
  float4 r0;

  r0.xyz = saturate(cb0[6].xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[7].xxx * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = cb0[6].w;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
