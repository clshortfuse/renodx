#ifndef SRC_GAMES_STARFIELD_SHARED_H_
#define SRC_GAMES_STARFIELD_SHARED_H_

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
  float toneMapHueCorrectionMethod;
  float toneMapHueCorrection;
  float toneMapPerChannel;
  float toneMapHueProcessor;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;
  float colorGradeColorSpace;
  float colorGradeLUTStrength;
  float colorGradeLUTScaling;
  float colorGradeSceneGrading;
  float fxBloom;
  float fxFilmGrain;
  float random_1;
  float random_2;
  float random_3;
};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b0, space50) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_GAMES_STARFIELD_SHARED_H_
