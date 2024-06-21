#include "../../shaders/RenoDRT.hlsl"
#include "../../shaders/aces.hlsl"
#include "../../shaders/color.hlsl"
#include "../../shaders/colorgrade.hlsl"
#include "../../shaders/graph.hlsl"
#include "../../shaders/lut.hlsl"
#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

#define DRAW_TONEMAPPER 0

float3 applyUserToneMap(float3 untonemapped, Texture2D lutTexture, SamplerState lutSampler, float3 vanilla) {
  float3 outputColor = untonemapped;

  float vanillaMidGray = uncharted2Tonemap(0.18f) / uncharted2Tonemap(2.2f);
  float4 correctColor;
  correctColor.rgb = vanilla.rgb;
  correctColor.a = injectedData.toneMapHueCorrection;

  float renoDRTContrast = 1.12f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.05f;
  float renoDRTHighlights = 1.2f;

  ToneMapParams tmParams = buildToneMapParams(
    injectedData.toneMapType,
    injectedData.toneMapPeakNits,
    injectedData.toneMapGameNits,
    injectedData.toneMapGammaCorrection - 1,  // -1 == srgb
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
    renoDRTFlare,
    correctColor
  );
  ToneMapLUTParams lutParams = buildLUTParams(
    lutSampler,
    injectedData.colorGradeLUTStrength,
    0.f,  // Lut scaling not needed
    TONE_MAP_LUT_TYPE__2_2,
    TONE_MAP_LUT_TYPE__2_2,
    16.f
  );

  outputColor = toneMap(untonemapped, tmParams, lutParams, lutTexture);

  if (injectedData.colorGradeExpandGamut > 0.f) {
    outputColor = hueCorrection(expandGamut(outputColor, injectedData.colorGradeExpandGamut), outputColor);
  }

  if (injectedData.toneMapGammaCorrection == 0.f) {
    outputColor = gammaCorrectSafe(outputColor, true);
  }

  return outputColor;
}
