#ifndef SRC_UE_DX11_SHARED_H_
#define SRC_UE_DX11_SHARED_H_

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
  float toneMapHueCorrectionMethod;
  float toneMapHueCorrection;
  float toneMapPerChannel;
  float toneMapHueProcessor;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;
  float colorGradeColorSpace;
};


#ifndef __cplusplus
#if (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedcbuffer : register(b13) {
#else
cbuffer injectedcbuffer : register(b13, space50) {
#endif
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_UE_DX11_SHARED_H_
