#ifndef SRC_CP2077_CP2077_H_
#define SRC_CP2077_CP2077_H_

// Must be 32bit aligned
// Should be 4x32
// 27 max for pixel/vertex
// 49 max for compute

struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapGammaCorrection;
  float toneMapHueCorrection;
  float toneMapHueProcessor;
  float toneMapPerChannel;

  float fxBloom;
  float fxVignette;
  float fxFilmGrain;

  float processingLUTScaling;
  float processingLUTOrder;
  float processingInternalSampling;

  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;
  float colorGradeWhitePoint;
  float colorGradeLUTStrength;

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

#define RENODX_GAMMA_CORRECTION         injectedData.toneMapGammaCorrection
#define CUSTOM_SCENE_GRADING_LIFT       1.f
#define CUSTOM_SCENE_GRADING_GAMMA      1.f
#define CUSTOM_SCENE_GRADING_GAIN       1.f
#define CUSTOM_SCENE_GRADING_COLOR      1.f
#define CUSTOM_SCENE_GRADING_BLACK      1.f
#define CUSTOM_SCENE_GRADING_CLIP       1.f
#define CUSTOM_SCENE_GRADING_HUE        1.f
#define CUSTOM_SCENE_GRADING_SATURATION 1.f
#define CUSTOM_SCENE_GRADING_STRENGTH   injectedData.sceneGradingStrength

#define RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION 1
#define RENODX_COLOR_GRADE_SHADOWS_VERSION    1

#ifndef __cplusplus
cbuffer injectedBuffer : register(b14, space0) {
  ShaderInjectData injectedData : packoffset(c0);
}
#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_CP2077_CP2077_H_
