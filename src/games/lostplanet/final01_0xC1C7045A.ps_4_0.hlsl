// Cinematic filter

#include "./shared.h"

cbuffer FilterColorCorrect : register(b0) {
  float4x4 gXfConversionMatrix : packoffset(c0);
  float3 gXfInBlack : packoffset(c4);
  float3 gXfInGamma : packoffset(c5);
  float3 gXfInWhite : packoffset(c6);
  float3 gXfOutBlack : packoffset(c7);
  float3 gXfOutWhite : packoffset(c8);
  float3 gXfShiftHSV : packoffset(c9);
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

SamplerState PointSampler0_s : register(s0);
Texture2D<float4> PointSampler0TEXTURE : register(t0);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  float4 o0;
  float4 r0 = PointSampler0TEXTURE.Sample(PointSampler0_s, v1.xy).xyzw;
  if (injectedData.toneMapType == 1.f) {
    return r0;
  }
  o0.w = r0.w;
  r0.w = 1;
  o0.x = dot(r0.xyzw, gXfConversionMatrix._m00_m10_m20_m30);
  o0.y = dot(r0.xyzw, gXfConversionMatrix._m01_m11_m21_m31);
  o0.z = dot(r0.xyzw, gXfConversionMatrix._m02_m12_m22_m32);
  return o0;
}
