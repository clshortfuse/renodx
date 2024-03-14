#include "../common/aces.hlsl"
#include "../common/color.hlsl"
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

  switch (injectedData.toneMapperEnum) {
    default:
    case 0:
      break;
    case 1:
      outputColor = max(0, textureColor.rgb) * gXfInWhite * gXfOutWhite;
      outputColor = pow(outputColor, gXfInGamma.xyz);
      outputColor = pow(outputColor, 2.2f);  // linear
      outputColor *= injectedData.gamePaperWhite / injectedData.uiPaperWhite;
      outputColor = pow(outputColor, 1.f / 2.2f);
      break;
    case 2:
      outputColor = max(0, textureColor.rgb) * gXfInWhite * gXfOutWhite;
      outputColor = pow(outputColor, gXfInGamma.xyz);
      outputColor = pow(outputColor, 2.2f);
      outputColor = aces_rrt_odt(
        outputColor,
        0.0001f,  // minY
        48.f * (injectedData.gamePeakWhite / injectedData.gamePaperWhite)
      );
      outputColor *= injectedData.gamePeakWhite / injectedData.uiPaperWhite;
      outputColor = pow(outputColor, 1.f / 2.2f);
      break;
  }

  return float4(outputColor.rgb, textureColor.a);
}
