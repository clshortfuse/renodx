#include "../../shaders/tonemap.hlsl"
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

float3 tonemap(float3 color) {
  float3 gXfInColor = (color - gXfInBlack) * gXfInWhite;
  float3 gXfOutColor = (gXfInColor * gXfOutWhite) + gXfOutBlack;
  return pow(saturate(gXfOutColor), gXfInGamma.xyz);
}

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_TARGET0 {
  float4 textureColor = PointSampler0TEXTURE.Sample(PointSampler0_s, v1.xy).rgba;

  float3 gXfInColor = (textureColor.rgb - gXfInBlack) * gXfInWhite;
  float3 gXfOutColor = (gXfInColor * gXfOutWhite) + gXfOutBlack;

  float3 outputColor = saturate(gXfOutColor);
  outputColor = pow(outputColor, gXfInGamma.xyz);

  if (injectedData.toneMapType != 0) {
    outputColor = pow(max(0, gXfOutColor), gXfInGamma.xyz);
  }

  outputColor = pow(outputColor, 2.2f);  // linear

  float vanillaMidGray = 0.18f;  // pow(yFromBT709(tonemap(0.5f)), 2.2f);
  float renoDRTHighlights = 1.0f;
  float renoDRTShadows = 1.f;
  float renoDRTContrast = 1.0f;
  float renoDRTSaturation = 1.0f;
  float renoDRTDechroma = 0.5f;
  float renoDRTFlare = 0.0f;

  ToneMapParams tmParams = {
    injectedData.toneMapType,
    injectedData.toneMapPeakNits,
    injectedData.toneMapGameNits,
    0,
    injectedData.colorGradeExposure,
    injectedData.colorGradeHighlights,
    injectedData.colorGradeShadows,
    injectedData.colorGradeContrast,
    injectedData.colorGradeSaturation,
    vanillaMidGray,
    vanillaMidGray * 100.f,
    renoDRTHighlights,
    renoDRTShadows,
    renoDRTContrast,
    renoDRTSaturation,
    renoDRTDechroma,
    renoDRTFlare
  };

  outputColor = toneMap(outputColor, tmParams);

  outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);

  return float4(outputColor.rgb, textureColor.a);
}
