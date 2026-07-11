#ifndef SRC_KNK1_SHARED_H_
#define SRC_KNK1_SHARED_H_

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
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float gamma;
  float toneMapHueCorrection;
  float ColorGradeColorSpace;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0); //
}
#endif

#endif  // SRC_KNK1_SHARED_H_
