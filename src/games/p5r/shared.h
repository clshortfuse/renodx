#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

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
  float colorGradeColorSpace;
  float fxBloom;
  float clampState;
};

#define CLAMP_STATE__NONE      0.f
#define CLAMP_STATE__OUTPUT    1.f
#define CLAMP_STATE__MIN_ALPHA 2.f
#define CLAMP_STATE__MAX_ALPHA 3.f

#define COLOR_SPACE__NONE   0.f
#define COLOR_SPACE__BT709  1.f
#define COLOR_SPACE__BT2020 2.f
#define COLOR_SPACE__AP1    3.f

#ifndef __cplusplus
cbuffer cb7 : register(b7) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_TEMPLATE_SHARED_H_
