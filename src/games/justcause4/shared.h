#ifndef SRC_GAMES_JUSTCAUSE4_SHARED_H_
#define SRC_GAMES_JUSTCAUSE4_SHARED_H_

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
  float fxLensFlare;
  float fxBloom;
  float fxVignette;
  float fxMotionBlur;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_GAMES_JUSTCAUSE4_SHARED_H_
