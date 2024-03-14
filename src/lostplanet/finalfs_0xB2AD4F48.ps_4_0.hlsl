// fullscreen noop

#include "./shared.h"

SamplerState XfBaseSampler_s : register(s0);
Texture2D<float4> XfBaseSamplerTEXTURE : register(t0);

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  float4 inputColor = XfBaseSamplerTEXTURE.Sample(XfBaseSampler_s, v1.xy).xyzw;

  float3 outputColor = pow(max(0, inputColor.rgb), 2.2f);
  // Convert to linear

  outputColor.rgb *= injectedData.uiPaperWhite;
  outputColor.rgb /= 80.f;
  return float4(outputColor.rgb, inputColor.a);
}
