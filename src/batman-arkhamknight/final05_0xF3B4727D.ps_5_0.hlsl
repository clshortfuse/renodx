#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float2 v1 : TEXCOORD0, out float4 outputColor : SV_TARGET0) {
  float4 r0 = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = saturate(r0.xyz);
  outputColor.w = v0.w * r0.w;
  outputColor.xyz = pow(r0.xyz, cb0[5].w);

  outputColor.rgb = pow(outputColor.rgb, 2.2f);
  outputColor.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
