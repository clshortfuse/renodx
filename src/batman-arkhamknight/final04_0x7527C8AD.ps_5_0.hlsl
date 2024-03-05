#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float4 v1 : TEXCOORD0, float4 v2 : TEXCOORD1, float2 v3 : TEXCOORD2, out float4 outputColor : SV_TARGET0) {
  float4 r0 = t0.Sample(s0_s, v3.xy).xyzw;
  r0.xyzw = r0.xyzw * v2.xyzw + v1.xyzw;
  // r0.xyz = saturate(r0.xyz);
  outputColor.w = v0.w * r0.w;
  outputColor.rgb = pow(r0.xyz, cb0[5].w);

  outputColor.rgb = pow(outputColor.rgb, 2.2f);
  if (injectedData.toneMapperEnum != 0) {
    outputColor.rgb *= injectedData.uiPaperWhite;
  } else {
    outputColor.rgb *= 203.f;
  }
  outputColor.rgb /= 80.f;
  return;
}
