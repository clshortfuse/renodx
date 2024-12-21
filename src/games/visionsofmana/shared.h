#ifndef SRC_MANA_SHARED_H_
#define SRC_MANA_SHARED_H_

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
  float colorGradeBlowout;
  float toneMapHueCorrection;
  float clipPeak;
  float vignette;
  float toneMapPerChannel;
  float ToneMapHueProcessor;
  float toneMapHueCorrectionMethod;
};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b0, space50) {
  ShaderInjectData injectedData : packoffset(c0);
}
// cbuffer cb1 : register(b1) {
//   ShaderInjectData injectedData : packoffset(c0);  //
// }
#endif

#endif  // SRC_MANA_SHARED_H_
