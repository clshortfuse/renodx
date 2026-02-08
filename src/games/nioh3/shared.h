
#ifndef SRC_NIOH3_SHARED_H_
#define SRC_NIOH3_SHARED_H_

#define RENODX_TONE_MAP_TYPE                 shader_injection.toneMapType
#define RENODX_PEAK_NITS                     shader_injection.toneMapPeakNits
#define RENODX_GAME_NITS                     shader_injection.toneMapGameNits
#define RENODX_UI_NITS                       shader_injection.toneMapUINits
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.colorGradeExposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.colorGradeHighlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.colorGradeShadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.colorGradeContrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.colorGradeSaturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.colorGradeHighlightSaturation
// #define RENODX_TONE_MAP_BLOWOUT              shader_injection.colorGradeBlowout
#define RENODX_TONE_MAP_FLARE                shader_injection.colorGradeFlare
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_WHITE_CLIP           65.f  // Cause they're using arri
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.colorGradeColorSpace
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET      renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10
//  Game's UI and render are linear, so we gamma correct everything at the end
#define RENODX_GAMMA_CORRECTION            GAMMA_CORRECTION_GAMMA_2_2
#define RENODX_INTERMEDIATE_ENCODING       GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION GAMMA_CORRECTION_GAMMA_2_2
#define CUSTOM_FILM_GRAIN_TYPE             shader_injection.custom_film_grain_type
#define CUSTOM_FILM_GRAIN_STRENGTH         shader_injection.custom_film_grain
#define CUSTOM_LUT_STRENGTH                1.f
#define CUSTOM_LUT_SCALING                 1.f
#define CUSTOM_RANDOM                      shader_injection.custom_random
#define CUSTOM_SHARPNESS                   shader_injection.custom_sharpness
#define CUSTOM_VIGNETTE                    shader_injection.custom_vignette
#define CUSTOM_DECHROMA                    shader_injection.colorGradeBlowout

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
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

  float colorGradeColorSpace;
  float custom_film_grain_type;
  float custom_lut_scaling;
  float custom_film_grain;

  float custom_random;
  float custom_sharpness;
  float custom_vignette;
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

#endif  // SRC_NIOH3_SHARED_H_