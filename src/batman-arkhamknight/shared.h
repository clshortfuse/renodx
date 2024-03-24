#ifndef SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_
#define SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeLUTStrength;
  float fxBloom;
  float fxVignette;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_
