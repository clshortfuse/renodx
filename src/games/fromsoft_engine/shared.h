#ifndef SRC_FROMSOFT_ENGINE_H_
#define SRC_FROMSOFT_ENGINE_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float color_grade_color_space;
  float custom_fx_chromatic_aberration;
  float custom_random;
  float custom_grain_type;
  float custom_grain_strength;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                     shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                   shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS                shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS               shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                  shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                    shader_injection.tone_map_flare
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE     shader_injection.color_grade_color_space
#define RENODX_GAMMA_CORRECTION                  GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_ENCODING               ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE   color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_DECODING               GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_SCALING_NITS           RENODX_DIFFUSE_WHITE_NITS
#define RENODX_INTERMEDIATE_SCALING_NITS         RENODX_DIFFUSE_WHITE_NITS
#define RENODX_INTERMEDIATE_ENCODING             ENCODING_PQ
#define RENODX_RENO_DRT_TONE_MAP_METHOD          renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION      1.f
#define CUSTOM_FX_CHROMATIC_ABERRATION           shader_injection.custom_fx_chromatic_aberration
#define CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION   0.5f
#define CUSTOM_COLOR_GRADE_HUE_CORRECTION        0.f
#define CUSTOM_COLOR_GRADE_SATURATION_CORRECTION 0.f
#define CUSTOM_COLOR_GRADE_HUE_SHIFT             1.f
#define CUSTOM_GRAIN_TYPE                        shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH                    shader_injection.custom_grain_strength
#define CUSTOM_RANDOM                            shader_injection.custom_random
#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_FROMSOFT_ENGINE_H_
