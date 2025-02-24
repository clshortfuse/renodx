#ifndef SRC_ROADHOGENGINE_SHARED_H_
#define SRC_ROADHOGENGINE_SHARED_H_

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
  float fxBloom;
  float fxLens;
  float fxSharpen;
  float fxBlur;
  float fxVignette;
  float fxFilmGrain;
  float fxFilmGrainType;

  float elapsedTime;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_ROADHOGENGINE_SHARED_H_