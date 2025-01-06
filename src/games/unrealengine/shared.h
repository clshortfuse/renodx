#ifndef SRC_UE_DX11_SHARED_H_
#define SRC_UE_DX11_SHARED_H_

#ifndef __cplusplus
#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

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
  float toneMapHueProcessor;

  float toneMapPerChannel;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;

  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeDechroma;
  float colorGradeBlowout;

  float colorGradeFlare;
  float colorGradeColorSpace;
  float colorGradeRestorationMethod;
  float colorGradeStrength;

  float processingUseSCRGB;
  float padding02;
  float padding03;
  float padding04;
};


#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedBuffer : register(b13) {
#endif
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_UE_DX11_SHARED_H_
