#ifndef SRC_GAMES_STARFIELD_SHARED_H_
#define SRC_GAMES_STARFIELD_SHARED_H_

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

  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_scene_strength;

  float custom_bloom;
  float custom_film_grain;
  float custom_random;
  float custom_vanilla_by_luminance;
};

#ifndef __cplusplus

cbuffer injectedBuffer : register(b13, space50) {
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
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   1.f
#define RENODX_TONE_MAP_BLOWOUT                0.0001f
#define RENODX_TONE_MAP_FLARE                  injectedData.colorGradeFlare
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE    color::convert::COLOR_SPACE_BT709
#define RENODX_TONE_MAP_PER_CHANNEL            0.f
#define RENODX_TONE_MAP_HUE_PROCESSOR          injectedData.toneMapHueProcessor
#define RENODX_TONE_MAP_HUE_CORRECTION         injectedData.toneMapHueCorrection
#define RENODX_TONE_MAP_HUE_SHIFT              injectedData.toneMapHueShift
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE      color::convert::COLOR_SPACE_BT2020
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_GAMMA_CORRECTION                injectedData.toneMapGammaCorrection
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   injectedData.colorGradeColorSpace
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_ENCODING             ENCODING_SCRGB
#define CUSTOM_LUT_STRENGTH                    injectedData.custom_lut_strength
#define CUSTOM_LUT_SCALING                     injectedData.custom_lut_scaling
#define CUSTOM_SCENE_STRENGTH                  injectedData.custom_scene_strength
#define CUSTOM_BLOOM                           injectedData.custom_bloom
#define CUSTOM_FILM_GRAIN                      injectedData.custom_film_grain
#define CUSTOM_RANDOM                          injectedData.custom_random
#define CUSTOM_VANILLA_BY_LUMINANCE            injectedData.custom_vanilla_by_luminance

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_GAMES_STARFIELD_SHARED_H_
