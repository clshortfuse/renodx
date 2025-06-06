#include "./shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Thu May 15 12:35:02 2025

SamplerState ColorSamplerSmp_s : register(s0);
Texture2D<float4> ColorSampler : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 outputColor;

  r0.xyz = ColorSampler.Sample(ColorSamplerSmp_s, v0.xy).xyz;
  outputColor = r0.rgb;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r0.xyz;
  o0.xyz = exp2(r0.xyz);

  if (RENODX_TONE_MAP_TYPE) {
    outputColor = renodx::draw::ToneMapPass(outputColor);
  } else {
    outputColor = saturate(outputColor);
  }
  outputColor = renodx::draw::RenderIntermediatePass(outputColor);
  o0.rgb = outputColor;
  o0.w = 1;
  return;
}
