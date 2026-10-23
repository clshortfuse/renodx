#ifndef SRC_CP2077_CP2077_H_
#define SRC_CP2077_CP2077_H_

// Must be 32bit aligned
// Should be 4x32
// 27 max for pixel/vertex
// 49 max for compute

struct ShaderInjectData {
  float toneMapType;
  float peak_white_nits;
  float diffuse_white_nits;
  float toneMapGammaCorrection;
  float toneMapHueCorrection;
  float toneMapHueProcessor;
  float toneMapPerChannel;

  float fxBloom;
  float fxVignette;
  float fx_film_grain_strength;
  float fx_dynamic_exposure;
  float fx_vanilla_hdr_slope;

  float processingLUTScaling;
  float processing_lut_black_floor;
  float processing_lut_ceiling;
  float custom_flags;

  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeConeResponse;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;
  float colorGradeLUTStrength;

  float sceneGradingStrength;
};

#define TONE_MAPPER_TYPE__VANILLA 0.f
#define TONE_MAPPER_TYPE__NONE    1.f
#define TONE_MAPPER_TYPE__ACES    2.f
#define TONE_MAPPER_TYPE__RENODX  3.f
#define TONE_MAPPER_TYPE__PSYCHOV17 4.f
#define TONE_MAPPER_TYPE__PSYCHOV22 5.f
#define TONE_MAPPER_TYPE__PSYCHOV30 6.f

#define OUTPUT_TYPE_SRGB8  0u
#define OUTPUT_TYPE_PQ     1u
#define OUTPUT_TYPE_SCRGB  2u
#define OUTPUT_TYPE_SRGB10 3u

#define CUSTOM_FLAGS__LUT_ORDER_BEFORE         0b00000001
#define CUSTOM_FLAGS__LUT_ORDER_AFTER          0b00000010
#define CUSTOM_FLAGS__SAMPLING_ENCODE_PQ       0b00000100
#define CUSTOM_FLAGS__SAMPLING_DECODE_PQ       0b00001000
#define CUSTOM_FLAGS__WHITE_POINT_D60          0b00010000
#define CUSTOM_FLAGS__WHITE_POINT_D65          0b00100000
#define CUSTOM_FLAGS__FILM_GRAIN_PERCEPTUAL    0b01000000
#define CUSTOM_FLAGS__DEBUG_GRAPH              0b10000000
#define CUSTOM_FLAGS__LUT_CORRECTION_MIDGRAY   0b0000010000000000
#define CUSTOM_FLAGS__PSYCHOV_EXPOSURE_MATCH   0b0000100000000000

#define RENODX_TONE_MAP_TYPE      injectedData.toneMapType
#define RENODX_PEAK_WHITE_NITS    injectedData.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS injectedData.diffuse_white_nits

#define RENODX_GAMMA_CORRECTION         injectedData.toneMapGammaCorrection
#define CUSTOM_SCENE_GRADING_LIFT       1.f
#define CUSTOM_SCENE_GRADING_GAMMA      1.f
#define CUSTOM_SCENE_GRADING_GAIN       1.f
#define CUSTOM_SCENE_GRADING_COLOR      1.f
#define CUSTOM_SCENE_GRADING_BLACK      1.f
#define CUSTOM_SCENE_GRADING_CLIP       1.f
#define CUSTOM_SCENE_GRADING_HUE        1.f
#define CUSTOM_SCENE_GRADING_SATURATION 1.f
#define CUSTOM_DYNAMIC_EXPOSURE         injectedData.fx_dynamic_exposure
#define CUSTOM_SCENE_GRADING_STRENGTH   injectedData.sceneGradingStrength
#define CUSTOM_FILM_GRAIN_STRENGTH      injectedData.fx_film_grain_strength
#define CUSTOM_CONE_RESPONSE            injectedData.colorGradeConeResponse
#define CUSTOM_CONE_COMPRESSION         0.f
#define CUSTOM_PSYCHOV_VANILLA_HDR_SLOPE injectedData.fx_vanilla_hdr_slope
#define CUSTOM_FLAGS                    injectedData.custom_flags
#define CUSTOM_LUT_ORDER_BEFORE         ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__LUT_ORDER_BEFORE) != 0)
#define CUSTOM_LUT_ORDER_AFTER          ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__LUT_ORDER_AFTER) != 0)
#define CUSTOM_SAMPLING_ENCODE_PQ       ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__SAMPLING_ENCODE_PQ) != 0)
#define CUSTOM_SAMPLING_DECODE_PQ       ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__SAMPLING_DECODE_PQ) != 0)
#define CUSTOM_WHITE_POINT_D60          ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__WHITE_POINT_D60) != 0)
#define CUSTOM_WHITE_POINT_D65          ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__WHITE_POINT_D65) != 0)
#define CUSTOM_FILM_GRAIN_PERCEPTUAL    ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__FILM_GRAIN_PERCEPTUAL) != 0)
#define CUSTOM_DRAW_GRAPH               ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__DEBUG_GRAPH) != 0)
#define CUSTOM_LUT_CORRECTION_MIDGRAY   ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__LUT_CORRECTION_MIDGRAY) != 0)
#define CUSTOM_LUT_CORRECTION_MIDGRAY_ACTIVE (CUSTOM_LUT_CORRECTION_MIDGRAY && injectedData.processingLUTScaling > 0.f)
#define CUSTOM_PSYCHOV_EXPOSURE_MATCH   ((asuint(CUSTOM_FLAGS) & CUSTOM_FLAGS__PSYCHOV_EXPOSURE_MATCH) != 0)

#define RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION 3
#define RENODX_COLOR_GRADE_SHADOWS_VERSION    3

#ifndef __cplusplus
cbuffer injectedBuffer : register(b14, space0) {
  ShaderInjectData injectedData : packoffset(c0);
}
#include "../../shaders/renodx.hlsl"

float3 ScaleVanillaFilmGrainNoise(float3 noise) {
  return lerp(0.5f, noise, CUSTOM_FILM_GRAIN_STRENGTH);
}
#endif

#endif  // SRC_CP2077_CP2077_H_
