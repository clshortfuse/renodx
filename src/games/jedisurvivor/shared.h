#ifndef SRC_GAMES_JEDISURVIVOR_SHARED_H_
#define SRC_GAMES_JEDISURVIVOR_SHARED_H_

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
  float toneMapGammaCorrectionUI;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeLUTStrength;
  float colorGradeLUTScaling;
  float fxFishEye;
  float fxVignette;
};

#ifndef __cplusplus
static const ShaderInjectData injectedData = {
  3.f, // toneMapType
  800.f, // toneMapPeakNits
  203.f, // toneMapGameNits
  100.f, // toneMapUINits
  0.f, // toneMapGammaCorrection
  0.f, // toneMapGammaCorrectionUI
  1.f, // colorGradeExposure
  1.f, // colorGradeHighlights
  1.f, // colorGradeShadows
  1.f, // colorGradeContrast
  1.f, // colorGradeSaturation
  1.f, // colorGradeLUTStrength
  1.f, // colorGradeLUTScaling
  1.f, // fxFishEye
  1.f, // fxVignette
};
#endif


#endif  // SRC_GAMES_JEDISURVIVOR_SHARED_H_
