#ifndef SRC_CP2077_CP2077_H_
#define SRC_CP2077_CP2077_H_

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
// 27 max for pixel/vertex
// 49 max for 49

struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapGammaCorrection;
  float toneMapHueCorrection;

  float fxBloom;
  float fxVignette;
  float fxFilmGrain;

  float processingLUTCorrection;
  float processingLUTOrder;
  float processingGlobalGain;
  float processingGlobalLift;
  float processingInternalSampling;

  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;
  float colorGradeWhitePoint;
  float colorGradeLUTStrength;

  float sceneGradingLift;
  float sceneGradingGamma;
  float sceneGradingGain;
  float sceneGradingColor;
  float sceneGradingBlack;
  float sceneGradingClip;
  float sceneGradingStrength;
};

#define TONE_MAPPER_TYPE__VANILLA 0.f
#define TONE_MAPPER_TYPE__NONE    1.f
#define TONE_MAPPER_TYPE__ACES    2.f
#define TONE_MAPPER_TYPE__RENODX  3.f

#define OUTPUT_TYPE_SRGB8  0u
#define OUTPUT_TYPE_PQ     1u
#define OUTPUT_TYPE_SCRGB  2u
#define OUTPUT_TYPE_SRGB10 3u

#endif  // SRC_CP2077_CP2077_H_
