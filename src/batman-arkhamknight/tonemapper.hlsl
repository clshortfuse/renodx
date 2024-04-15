#include "../common/RenoDRT.hlsl"
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

  float vanillaMidGray = uncharted2Tonemap(0.18f) / uncharted2Tonemap(2.2f);

  float renoDRTContrast = 1.12f;
  float renoDRTShadow = 0.0f;
  float renoDRTDechroma = 0.0f;
  float renoDRTSaturation = 1.f;
  float renoDRTHighlights = 1.2f;

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
    renoDRTContrast,
    renoDRTShadow,
    renoDRTDechroma,
    renoDRTSaturation,
    renoDRTHighlights
  };
  ToneMapLUTParams lutParams = {
    lutTexture,
    lutSampler,
    injectedData.colorGradeLUTStrength,
    0.f,  // Lut scaling not needed
    TONE_MAP_LUT_TYPE__2_2,
    TONE_MAP_LUT_TYPE__2_2,
    16.f,         // size
    float(0).xxx  // precompute
  };

  outputColor = toneMap(untonemapped, tmParams, lutParams);

  return outputColor;
}
