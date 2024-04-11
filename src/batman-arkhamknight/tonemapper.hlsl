#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "../common/graph.hlsl"
#include "../common/lut.hlsl"
#include "../common/tonemap.hlsl"
#include "./shared.h"

#define DRAW_TONEMAPPER 1

float3 applyUserToneMap(float3 untonemapped, Texture2D lutTexture, SamplerState lutSampler) {
  float3 outputColor = untonemapped;

  outputColor = applyUserColorGrading(
    outputColor,
    injectedData.colorGradeExposure,
    injectedData.colorGradeLUTStrength ? 1.f : injectedData.colorGradeSaturation,
    injectedData.colorGradeShadows,
    injectedData.colorGradeHighlights,
    injectedData.colorGradeContrast
  );

  float vanillaMidGray = uncharted2Tonemap(0.18f) / uncharted2Tonemap(2.2f);
  if (injectedData.toneMapType == 2.f) {
    const float ACES_MID_GRAY = 0.10f;
    float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / ACES_MID_GRAY);
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);

    if (injectedData.colorGradeLUTStrength) {
      outputColor = max(0, outputColor);
    }
    float3 hdrColor = aces_rgc_rrt_odt(
      outputColor,
      0.0001f / (paperWhite / 48.f),
      48.f * hdrScale
    );
    hdrColor /= 48.f;
    hdrColor *= (vanillaMidGray / ACES_MID_GRAY);

    if (injectedData.colorGradeLUTStrength) {
      paperWhite = 203.f * (vanillaMidGray / ACES_MID_GRAY);
      float sdrScale = (203.f / paperWhite);

      float3 sdrColor = aces_rgc_rrt_odt(
        max(0, outputColor),
        0.0001f / (sdrScale / 48.f),
        48.f * sdrScale
      );
      sdrColor /= 48.f;
      sdrColor *= (vanillaMidGray / ACES_MID_GRAY);
      sdrColor = saturate(sdrColor);

      float3 sdrGammaColor = pow(sdrColor, 1.f / 2.2f);  // gamma
      float3 luttedColor = sampleLUTAlt(lutTexture, lutSampler, sdrGammaColor, 16);
      luttedColor = pow(luttedColor, 2.2f);  // linear

      float scaledRatio = 1.f;
      float outputY = yFromBT709(abs(luttedColor));
      float hdrY = yFromBT709(abs(hdrColor));
      float sdrY = yFromBT709(abs(sdrColor));
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
      if (injectedData.colorGradeSaturation != 1.f) {
        outputColor = applySaturation(injectedData.colorGradeSaturation);
      }
    } else {
      outputColor = hdrColor;
    }
  } else if (injectedData.toneMapType == 3.f) {
    const float OPENDRT_MID_GRAY = 11.696f / 100.f;
    float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / OPENDRT_MID_GRAY);
    float hdrScale = (injectedData.toneMapPeakNits / paperWhite);

    float3 hdrColor = outputColor;
    if (!injectedData.colorGradeLUTStrength) {
      hdrColor = mul(BT709_2_DISPLAYP3_MAT, hdrColor);
    }
    hdrColor = max(0, hdrColor);
    hdrColor = open_drt_transform_bt709(
      hdrColor,
      100.f * hdrScale,
      0,
      1.f,
      0
    );
    hdrColor *= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    if (!injectedData.colorGradeLUTStrength) {
      hdrColor = mul(DISPLAYP3_2_BT709_MAT, hdrColor);
    }

    if (injectedData.colorGradeLUTStrength) {
      paperWhite = 203.f * (vanillaMidGray / OPENDRT_MID_GRAY);
      float sdrScale = (203.f / paperWhite);

      float3 sdrColor = open_drt_transform_bt709(
        max(0, outputColor),
        100.f * sdrScale,
        0,
        1.f,
        0
      );
      sdrColor = saturate(sdrColor);

      float3 sdrGammaColor = pow(sdrColor, 1.f / 2.2f);  // gamma
      float3 luttedColor = sampleLUTAlt(lutTexture, lutSampler, sdrGammaColor, 16);
      luttedColor = pow(luttedColor, 2.2f);  // linear

      float scaledRatio = 1.f;
      float outputY = yFromBT709(abs(luttedColor));
      float hdrY = yFromBT709(abs(hdrColor));
      float sdrY = yFromBT709(abs(sdrColor));
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
      if (injectedData.colorGradeSaturation != 1.f) {
        outputColor = applySaturation(injectedData.colorGradeSaturation);
      }
    } else {
      outputColor = hdrColor;
    }
  } else if (injectedData.toneMapType == 4.f) {
    float3 hdrColor = outputColor;
    hdrColor = renodrt(
      hdrColor,
      injectedData.toneMapPeakNits / injectedData.toneMapGameNits * 100.f,
      0.18f,
      vanillaMidGray * 100.f,
      1.12f,
      0,
      0.f,  // dechroma
      1.f,  // sat
      1.2f  //highlight boost
    );

    if (injectedData.colorGradeLUTStrength) {
      float3 sdrColor = renodrt(
        untonemapped,
        100.f,
        0.18f,
        vanillaMidGray * 100.f,
        1.12f,
        0,
        0.f,  // dechroma
        1.f,  // sat
        1.2f  //highlight boost
      );
      sdrColor = saturate(sdrColor);

      float3 sdrGammaColor = pow(sdrColor, 1.f / 2.2f);  // gamma
      float3 luttedColor = sampleLUTAlt(lutTexture, lutSampler, sdrGammaColor, 16);
      luttedColor = pow(luttedColor, 2.2f);  // linear

      float scaledRatio = 1.f;
      float outputY = yFromBT709(abs(luttedColor));
      float hdrY = yFromBT709(abs(hdrColor));
      float sdrY = yFromBT709(abs(sdrColor));
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
      if (injectedData.colorGradeSaturation != 1.f) {
        outputColor = applySaturation(injectedData.colorGradeSaturation);
      }
    } else {
      outputColor = hdrColor;
    }
  }

  return outputColor;
}
