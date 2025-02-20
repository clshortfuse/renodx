#ifndef SRC_ALIEN_ISOLATION_SHARED_H_
#define SRC_ALIEN_ISOLATION_SHARED_H_

#define RENODX_RENO_DRT_WHITE_CLIP            200.f
#define RENODX_TONE_MAP_MID_GRAY              0.035f
#define RENODX_COLOR_GRADE_RESTORATION_METHOD 0u
#define CUSTOM_LENS_FLARE                     1

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;
  float toneMapHueShift;
  float toneMapHueCorrection;
  float toneMapPerChannel;
  float toneMapBlend;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;
  float colorGradeLUTStrength;
  float fxBloom;
  float fxBloomBlackFloor;
  float fxLensFlare;
  float fxVignette;
  float fxFilmGrainType;
  float fxFilmGrain;
};

#ifndef __cplusplus
cbuffer cb11 : register(b11) {
  ShaderInjectData injectedData : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ALIEN_ISOLATION_SHARED_H_
