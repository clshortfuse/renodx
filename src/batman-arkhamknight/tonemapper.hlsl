#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "../common/graph.hlsl"
#include "../common/lut.hlsl"
#include "../common/tonemap.hlsl"
#include "./shared.h"

#define DRAW_TONEMAPPER 0

float3 applyUserToneMap(float3 untonemapped, Texture2D lutTexture, SamplerState lutSampler) {
  float3 outputColor = untonemapped;

  outputColor = applyUserColorGrading(
    outputColor,
    injectedData.colorGradeExposure,
    injectedData.colorGradeSaturation,
    injectedData.colorGradeShadows,
    injectedData.colorGradeHighlights,
    injectedData.colorGradeContrast
  );

  float vanillaMidGray = 0.18f;
  if (injectedData.toneMapType == 2.f) {
    float paperWhite = injectedData.toneMapGameNits;  // ACES mid gray is 10%
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);

    if (injectedData.colorGradeLUTStrength) {
      outputColor = max(0, outputColor);
    }
    float3 hdrColor = aces_rgc_rrt_odt(outputColor, 0.0001f / (paperWhite / 48.f), 48.f * hdrScale) / 48.f;
    outputColor = hdrColor;
    if (injectedData.colorGradeLUTStrength) {
      float3 sdrColor = aces_rgc_rrt_odt(max(0, untonemapped), 0.0001f, 48.f) / 48.f;
      sdrColor = saturate(sdrColor);

      float3 sdrGammaColor = pow(sdrColor, 1.f / 2.2f);  // gamma
      float3 luttedColor = sampleLUTAlt(lutTexture, lutSampler, sdrGammaColor, 16);
      luttedColor = pow(luttedColor, 2.2f);  // linear

      float scaledRatio = 1.f;
      float outputY = yFromBT709(luttedColor);
      float hdrY = yFromBT709(abs(hdrColor));
      float sdrY = yFromBT709(sdrColor);
      if (hdrY < sdrY) {
        // If substracting (user contrast or paperwhite) scale down instead
        scaledRatio = hdrY / sdrY;
      } else {
        float deltaY = hdrY - sdrY;
        float newY = outputY + max(0, deltaY);  // deltaY may be NaN?
        scaledRatio = outputY > 0 ? (newY / outputY) : 0;
      }
      luttedColor *= scaledRatio;
      outputColor = lerp(outputColor, luttedColor, injectedData.colorGradeLUTStrength);
    }
  } else if (injectedData.toneMapType == 3.f) {
    float paperWhite = injectedData.toneMapGameNits;
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);

    float3 hdrColor = outputColor;
    if (!injectedData.colorGradeLUTStrength) {
      float3 hdrColor = mul(BT709_2_DISPLAYP3_MAT, outputColor);
    }
    hdrColor = max(0, hdrColor);
    hdrColor = open_drt_transform_bt709(
      hdrColor,
      100.f * hdrScale,
      0,
      1.f,
      0
    );
    if (!injectedData.colorGradeLUTStrength) {
      hdrColor = mul(DISPLAYP3_2_BT709_MAT, hdrColor);
    }
    hdrColor *= hdrScale;
    outputColor = hdrColor;

    if (injectedData.colorGradeLUTStrength) {
      float3 sdrColor = open_drt_transform_bt709(max(0, untonemapped), 100.f, 0, 1.f, 0);
      sdrColor = saturate(sdrColor);

      float3 sdrGammaColor = pow(sdrColor, 1.f / 2.2f);  // gamma
      float3 luttedColor = sampleLUTAlt(lutTexture, lutSampler, sdrGammaColor, 16);
      luttedColor = pow(luttedColor, 2.2f);  // linear

      float scaledRatio = 1.f;
      float outputY = yFromBT709(luttedColor);
      float hdrY = yFromBT709(abs(hdrColor));
      float sdrY = yFromBT709(sdrColor);
      if (hdrY < sdrY) {
        // If substracting (user contrast or paperwhite) scale down instead
        scaledRatio = hdrY / sdrY;
      } else {
        float deltaY = hdrY - sdrY;
        float newY = outputY + max(0, deltaY);  // deltaY may be NaN?
        scaledRatio = outputY > 0 ? (newY / outputY) : 0;
      }
      luttedColor *= scaledRatio;
      outputColor = lerp(outputColor, luttedColor, injectedData.colorGradeLUTStrength);
    }
  }

  return outputColor;
}
