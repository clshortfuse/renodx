#ifndef SRC_GUILDWARS2_SHARED_H_
#define SRC_GUILDWARS2_SHARED_H_

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;
  float toneMapGammaCorrection;
  float toneMapPerChannel;
  float toneMapHueProcessor;
  float toneMapHueShift;
  float toneMapHueCorrection;
  float toneMapShoulderStart;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;
  float colorGradeDechroma;
  float colorGradeFlare;
  float colorGradeClip;
  float colorGradeLUTStrength;
  float colorGradeLUTScaling;
  float colorGradeLUTSampling;
  float colorGradeTint;
  float fxBloom;
  float fxLightRays;
  float fxLightAdaptation;
  float fxFog;
  float fxBlur;
  float fxSelectionOutline;
  float fxVignette;
  float fxVignetteUW;
  float fxCA;
  float fxSharpen;
  float fxFlashbang;
  float fxFilmGrain;
  float fxFilmGrainType;

  float random_1;
  float random_2;
  float random_3;
  float stateCheck;
  bool isUnderWater;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_GUILDWARS2_SHARED_H_
