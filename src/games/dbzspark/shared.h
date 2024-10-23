#ifndef SRC_DBZSPARK_SHARED_H_
#define SRC_DBZSPARK_SHARED_H_

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
  float toneMapHueCorrection;
  float toneMapDice;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeLUTStrength;
  float colorGradeBlowout;
};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b0, space50) {
  ShaderInjectData injectedData : packoffset(c0);
}
/* static const ShaderInjectData injectedData = {
    3.f,    // toneMapType
    800.f,  // toneMapPeakNits
    80.f,  // toneMapGameNits
    100.f,   // toneMapUINits
    1.f,    // toneMapGammaCorrection
    1.f,    // toneMapHueCorrection
    1.f,    // toneMapDice
    1.f,    // colorGradeExposure
    1.f,    // colorGradeHighlights
    1.f,    // colorGradeShadows
    1.f,    // colorGradeContrast
    1.f,    // colorGradeSaturation
    1.f,    // colorGradeLUTStrength
    0.f,    // colorGradeBlowout
}; */
#endif

#endif  // SRC_DBZSPARK_SHARED_H_
