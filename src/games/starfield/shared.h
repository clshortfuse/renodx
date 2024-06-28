#ifndef SRC_GAMES_STARFIELD_SHARED_H_
#define SRC_GAMES_STARFIELD_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;
  float toneMapGammaCorrection;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeLUTStrength;
  float colorGradeLUTScaling;
  float colorGradeSceneGrading;
  float fxBloom;
  float fxFilmGrain;
  float elapsedTime;
  float resource_tag;
};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b0, space9) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_GAMES_STARFIELD_SHARED_H_
