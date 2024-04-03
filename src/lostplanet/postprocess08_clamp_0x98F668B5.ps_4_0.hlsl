#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
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
  float4 textureColor = PointSampler0TEXTURE.Sample(PointSampler0_s, v1.xy).rgba;

  float3 gXfInColor = (textureColor.rgb - gXfInBlack) * gXfInWhite;
  float3 gXfOutColor = (gXfInColor * gXfOutWhite) + gXfOutBlack;

  float3 outputColor = saturate(gXfOutColor);
  outputColor = pow(outputColor, gXfInGamma.xyz);

  if (injectedData.toneMapType != 0) {
    outputColor = max(0, textureColor.rgb) * gXfInWhite * gXfOutWhite;
    outputColor = pow(outputColor, gXfInGamma.xyz);
  }

  outputColor = pow(outputColor, 2.2f);  // linear
  outputColor = applyUserColorGrading(
    outputColor,
    1.f,
    injectedData.colorGradeSaturation,
    injectedData.colorGradeShadows,
    injectedData.colorGradeHighlights,
    injectedData.colorGradeContrast
  );

  const float vanillaMidGray = 0.18f;

  if (injectedData.toneMapType == 2.f) {
    const float ACES_MID_GRAY = 0.10f;
    float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / ACES_MID_GRAY);
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
    outputColor = aces_rgc_rrt_odt(
      outputColor,
      0.0001f / hdrScale,
      48.f * hdrScale
    );
    outputColor /= 48.f;
    outputColor *= (vanillaMidGray / ACES_MID_GRAY);
  } else if (injectedData.toneMapType == 3.f) {
    const float OPENDRT_MID_GRAY = 11.696f / 100.f;
    float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / OPENDRT_MID_GRAY);
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
    outputColor = mul(BT709_2_DISPLAYP3_MAT, outputColor);
    outputColor = max(0, outputColor);
    outputColor = open_drt_transform_bt709(
      outputColor,
      100.f * hdrScale,
      0.12,
      1.f,
      0
    );
    outputColor = mul(DISPLAYP3_2_BT709_MAT, outputColor);
    outputColor *= hdrScale;
    outputColor *= (vanillaMidGray / OPENDRT_MID_GRAY);
  }

  outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);

  return float4(outputColor.rgb, textureColor.a);
}
