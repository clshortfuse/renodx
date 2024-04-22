#include "../../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[134];
}

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_Target0 {
  const float4 inputColor = t0.Sample(s0_s, v1.xy).rgba;

  float3 outputColor = inputColor.rgb;

  if (injectedData.toneMapGammaCorrection) {
    outputColor = gammaCorrectSafe(outputColor);
  }

  outputColor.rgb *= injectedData.toneMapUINits / 80.f;

  return float4(outputColor, inputColor.a);
}
