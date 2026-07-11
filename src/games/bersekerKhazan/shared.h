
#ifndef SRC_BERSERKER_SHARED_H_
#define SRC_BERSERKER_SHARED_H_

#define RENODX_TONE_MAP_TYPE                   shader_injection.toneMapType
#define RENODX_PEAK_NITS                       shader_injection.toneMapPeakNits
#define RENODX_GAME_NITS                       shader_injection.toneMapGameNits
#define RENODX_UI_NITS                         shader_injection.toneMapUINits
#define RENODX_COLOR_GRADE_STRENGTH            1.f
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.colorGradeExposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.colorGradeHighlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.colorGradeContrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.colorGradeHighlightSaturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.colorGradeBlowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.colorGradeFlare
#define RENODX_RENO_DRT_WHITE_CLIP             65.f
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    color::convert::COLOR_SPACE_AP1
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection.toneMapPerChannel
#define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection.toneMapHueProcessor
#define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection.toneMapHueCorrection
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection.toneMapHueShift
#define RENODX_TONE_MAP_HUE_SHIFT_METHOD       4.f
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION    1.f
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      color::convert::COLOR_SPACE_BT2020
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE  // renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_GAMMA_CORRECTION                shader_injection.toneMapGammaCorrection
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.colorGradeColorSpace
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING             ENCODING_PQ
// #define RENODX_SWAP_CHAIN_CLAMP_NITS           10000.f

#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP        20.f

#define DEBUG_MAX_CH 1.f

#define LUTBUILDER_EXIST shader_injection.lutbuilder_exist
#define GODRAY_EXIST     shader_injection.godray_exist
#define POSTFX_EXIST     shader_injection.postfx_exist

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
  float toneMapHueShiftMethod;

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

  float lutbuilder_exist;
  float godray_exist;
  float postfx_exist;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injectedBuffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ENDERMAG_SHARED_H_