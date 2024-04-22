#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : COLOR0, float4 v1 : COLOR1, float4 v2 : TEXCOORD0, float4 v3 : TEXCOORD1, float2 v4 : TEXCOORD2, out float4 o0 : SV_TARGET0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v4.xy).xyzw;
  r0.xyzw = -v0.xyzw + r0.xyzw;
  r0.xyzw = v1.xxxx * r0.xyzw + v0.xyzw;
  r0.xyzw = r0.xyzw * v3.xyzw + v2.xyzw;
  r0.xyz = saturate(r0.xyz);
  o0.w = v1.w * r0.w;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[5].www * r0.xyz;
  o0.xyz = exp2(r0.xyz);

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
