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
};
#ifndef __cplusplus
cbuffer injectedBuffer : register(b13, space50) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_STALKER2_SHARED_H_
