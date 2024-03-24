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
    outputColor = pow(outputColor, 2.2f);  // linear

    if (injectedData.toneMapType != 1.f) {
      if (injectedData.colorGradeSaturation != 1.f) {
        float grayscale = yFromBT709(outputColor);
        outputColor = lerp(grayscale, outputColor, injectedData.colorGradeSaturation);
        outputColor = max(0, outputColor);
      }

      if (injectedData.colorGradeShadows != 1.f) {
        outputColor = apply_user_shadows(outputColor, injectedData.colorGradeShadows);
      }
      if (injectedData.colorGradeHighlights != 1.f) {
        outputColor = apply_user_highlights(outputColor, injectedData.colorGradeHighlights);
      }
      if (injectedData.colorGradeContrast != 1.f) {
        float3 workingColor = pow(outputColor / 0.18f, injectedData.colorGradeContrast) * 0.18f;
        // Working in BT709 still
        float workingColorY = yFromBT709(workingColor);
        float outputColorY = yFromBT709(outputColor);
        outputColor *= outputColorY ? workingColorY / outputColorY : 1.f;
      }

      float hdrScale = (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
      if (injectedData.toneMapType == 2.f) {
        // ACES
        outputColor = aces_rgc_rrt_odt(
          outputColor,
          0.0001f / hdrScale,  // minY
          48.f * hdrScale
        );
        outputColor /= 48.f;
      } else {  // OpenDRT
        outputColor = apply_aces_highlights(outputColor);
        outputColor = open_drt_transform(
          outputColor,
          100.f * hdrScale,
          0,
          1.f,
          0
        );
        outputColor *= hdrScale;
      }
    }
    outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    outputColor = pow(outputColor, 1.f / 2.2f);
  }

  return float4(outputColor.rgb, textureColor.a);
}
