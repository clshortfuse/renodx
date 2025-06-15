#ifndef SRC_LASTEPOCH_SHARED_H_
#define SRC_LASTEPOCH_SHARED_H_

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
  float toneMapHueProcessor;
  float toneMapHueShift;
  float toneMapHueCorrection;
  float toneMapColorSpace;
  float toneMapPerChannel;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;
  float colorGradeDechroma;
  float colorGradeFlare;
  float colorGradeClip;
  float colorGradeLUTStrength;
  float colorGradeLUTSampling;
  float colorGradeLUTShaper;
  float fxBloom;
  float fxVignette;
  float fxCA;
  float fxSharpen;
  float fxNoise;
  float fxCameraLight;
  float fxFilmGrain;
  float fxFilmGrainType;

  float random_1;
  float random_2;
  float random_3;
  bool stateCheck;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_LASTEPOCH_SHARED_H_
