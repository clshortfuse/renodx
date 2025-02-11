#ifndef SRC_UNREALENGINE_SHARED_H_
#define SRC_UNREALENGINE_SHARED_H_

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

  float toneMapPerChannel;
  float colorGradeExposure;
  float colorGradeHighlights;
  float colorGradeShadows;

  float colorGradeContrast;
  float colorGradeSaturation;
  float colorGradeHighlightSaturation;
  float colorGradeBlowout;

  float colorGradeFlare;
  float colorGradeColorSpace;
  float colorGradeRestorationMethod;
  float colorGradeStrength;

  float processingUseSCRGB;
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

#define RENODX_TONE_MAP_TYPE                   injectedData.toneMapType
#define RENODX_PEAK_NITS                       injectedData.toneMapPeakNits
#define RENODX_GAME_NITS                       injectedData.toneMapGameNits
#define RENODX_UI_NITS                         injectedData.toneMapUINits
#define RENODX_COLOR_GRADE_STRENGTH            injectedData.colorGradeStrength
#define RENODX_TONE_MAP_EXPOSURE               injectedData.colorGradeExposure
#define RENODX_TONE_MAP_HIGHLIGHTS             injectedData.colorGradeHighlights
#define RENODX_TONE_MAP_SHADOWS                injectedData.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST               injectedData.colorGradeContrast
#define RENODX_TONE_MAP_SATURATION             injectedData.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   injectedData.colorGradeHighlightSaturation
#define RENODX_TONE_MAP_BLOWOUT                injectedData.colorGradeBlowout
#define RENODX_TONE_MAP_FLARE                  injectedData.colorGradeFlare
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    color::convert::COLOR_SPACE_AP1
#define RENODX_TONE_MAP_PER_CHANNEL            injectedData.toneMapPerChannel
#define RENODX_TONE_MAP_HUE_PROCESSOR          injectedData.toneMapHueProcessor
#define RENODX_TONE_MAP_HUE_CORRECTION         injectedData.toneMapHueCorrection
#define RENODX_TONE_MAP_HUE_SHIFT              injectedData.toneMapHueShift
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      color::convert::COLOR_SPACE_BT2020
#define RENODX_GAMMA_CORRECTION                injectedData.toneMapGammaCorrection
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   injectedData.colorGradeColorSpace
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE (color::convert::COLOR_SPACE_BT2020 - injectedData.processingUseSCRGB)  // BT709 = BT2020 - 1
#define RENODX_SWAP_CHAIN_ENCODING             (ENCODING_PQ + injectedData.processingUseSCRGB)                         // SCRGB = PQ + 1

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_UNREALENGINE_SHARED_H_
