// UI elements

#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(float2 v0 : TEXCOORD0, float4 v1 : COLOR0, out float4 outputColor : SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = saturate(v1.xyz);
  r0.xyz = v1.xyz;
  r0.xyz = pow(r0.xyz, cb0[7].x);  // Usually 1 (brightness)
  r0.x = t0.Sample(s0_s, v0.xy).x;
  outputColor.w = v1.w * r0.x;
  outputColor.rgb = v1.rgb;
  outputColor.rgba = max(0, outputColor.rgba);

  outputColor.rgb = pow(outputColor.rgb, 2.2f);
  outputColor.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
