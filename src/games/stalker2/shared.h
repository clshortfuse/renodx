#ifndef SRC_STALKER2_SHARED_H_
#define SRC_STALKER2_SHARED_H_

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
  float toneMapPerChannel;
  float radiationOverlayStrength;
  float vignetteStrength;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;
  float colorGradeLUTStrength;
};
#ifndef __cplusplus
cbuffer injectedBuffer : register(b0, space50) {
  ShaderInjectData injectedData : packoffset(c0);
}
/* static const ShaderInjectData injectedData = {
    2.f,    // toneMapType
    800.f,  // toneMapPeakNits
    200.f,  // toneMapGameNits
    150.f,  // toneMapUINits
    1.f,    // radiationOverlayStrength
    1.f,    // vignette
    1.f,    // colorGradeExposure
    1.f,    // colorGradeHighlights
    1.f,    // colorGradeShadows
    1.f,    // colorGradeContrast
    1.f,    // colorGradeSaturation
    0.5f,   // colorGradeBlowout
    1.f,    // colorGradeLUTStrength
}; */
#endif

#endif  // SRC_STALKER2_SHARED_H_
