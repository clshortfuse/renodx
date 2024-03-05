#include "../common/color.hlsl"
#include "./shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float4 v1 : COLOR1, float4 v2 : TEXCOORD0, float4 v3 : TEXCOORD1, out float4 outputColor : SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v0.xyzw * v3.xyzw + v2.xyzw;
  // r0.xyz = saturate(r0.xyz);
  outputColor.w = v1.w * r0.w;
  outputColor.rgb = pow(r0.rgb, cb0[5].w);

  outputColor.rgb = pow(outputColor.rgb, 2.2f);
  if (injectedData.toneMapperEnum != 0) {
    outputColor.rgb *= injectedData.uiPaperWhite;
  } else {
    outputColor.rgb *= 203.f;
  }
  outputColor.rgb /= 80.f;
  return;
}
