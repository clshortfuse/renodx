#ifndef SRC_KOARR_SHARED_H_
#define SRC_KOARR_SHARED_H_

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
  float colorGradeLUTStrength;
  float colorGradeLUTSampling;
  float upgradePerChannel;
  float fxBloom;
  float fxVignette;
  float fxFlash;
  float fxFilmGrain;
  float fxFilmGrainType;

  float elapsedTime;
  float random_1;
  float random_2;
  float random_3;
  bool hasLoadedTitleMenu;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_KOARR_SHARED_H_
