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
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeLUTStrength;
  float colorGradeBlowout;
};

#ifndef __cplusplus
/* cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
} */

static const ShaderInjectData injectedData = {
    2.f,    // toneMapType
    800.f,  // toneMapPeakNits
    203.f,  // toneMapGameNits
    203.f,   // toneMapUINits
    1.f,    // toneMapGammaCorrection
    1.f,    // toneMapHueCorrection
    1.f,    // colorGradeExposure
    1.f,    // colorGradeHighlights
    1.f,    // colorGradeShadows
    1.f,    // colorGradeContrast
    1.f,    // colorGradeSaturation
    1.f,    // colorGradeLUTStrength
    1.f,    // colorGradeBlowout
};
#endif

#endif  // SRC_DBZSPARK_SHARED_H_
