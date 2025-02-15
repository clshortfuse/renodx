#ifndef SRC_AVOWED_SHARED_H_
#define SRC_AVOWED_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapDisplay;
  float toneMapGameNits;
  float toneMapUINits;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;
  float colorGradeFlare;
};
#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedBuffer : register(b13) {
#endif
  ShaderInjectData injectedData : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#define RENODX_TONE_MAP_TYPE                 injectedData.toneMapType
#define RENODX_PEAK_NITS                     injectedData.toneMapPeakNits
#define RENODX_GAME_NITS                     injectedData.toneMapGameNits
#define RENODX_UI_NITS                       injectedData.toneMapUINits
#define RENODX_TONE_MAP_EXPOSURE             injectedData.colorGradeExposure
#define RENODX_TONE_MAP_HIGHLIGHTS           injectedData.colorGradeHighlights
#define RENODX_TONE_MAP_SHADOWS              injectedData.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST             injectedData.colorGradeContrast
#define RENODX_TONE_MAP_SATURATION           injectedData.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION injectedData.colorGradeHighlightSaturation
#define RENODX_TONE_MAP_BLOWOUT              injectedData.colorGradeBlowout
#define RENODX_TONE_MAP_FLARE                injectedData.colorGradeFlare
#define RENODX_INTERMEDIATE_ENCODING         4.f
#define RENODX_SWAP_CHAIN_ENCODING           4.f
#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_AVOWED_SHARED_H_
