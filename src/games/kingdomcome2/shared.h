#ifndef SRC_KINGDOM_COME2_SHARED_H_
#define SRC_KINGDOM_COME2_SHARED_H_

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
#define RENODX_EFFECT_BLOOM                  injectedData.fxBloom
#define RENODX_GAMMA_CORRECTION              injectedData.toneMapGammaCorrection
#define RENODX_INTERMEDIATE_ENCODING         1.f
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  2.f

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;

  float toneMapGammaCorrection;
  float toneMapHueShift;
  float toneMapHueCorrection;
  float toneMapHueProcessor;

  float colorGradeFlare;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;

  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;
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

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_KINGDOM_COME2_SHARED_H_