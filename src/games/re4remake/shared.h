#ifndef SRC_RE4REMAKE_SHARED_H_
#define SRC_RE4REMAKE_SHARED_H_

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapGammaCorrection;
  float toneMapGammaAdjust;
  float colorGradeHighlightContrast;
  float colorGradeToeAdjustmentType;
  float colorGradeShadowToe;
  float colorGradeLUTStrength;
  float colorGradeLUTScaling;
  float processingInternalSampling;
};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b0, space50) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_RE4REMAKE_SHARED_H_