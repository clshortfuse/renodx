#ifndef SRC_SHADOW_OF_WAR_SHARED_H_
#define SRC_SHADOW_OF_WAR_SHARED_H_

// #define RENODX_TONE_MAP_TYPE                 2
// #define RENODX_PEAK_WHITE_NITS               400
// #define RENODX_DIFFUSE_WHITE_NITS            100
// #define RENODX_GRAPHICS_WHITE_NITS           100
// #define RENODX_GAMMA_CORRECTION              2
// #define RENODX_TONE_MAP_HUE_CORRECTION       0
// #define RENODX_TONE_MAP_EXPOSURE             1
// #define RENODX_TONE_MAP_HIGHLIGHTS           1
// #define RENODX_TONE_MAP_SHADOWS              1
// #define RENODX_TONE_MAP_CONTRAST             1
// #define RENODX_TONE_MAP_SATURATION           1
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1
// #define RENODX_TONE_MAP_BLOWOUT              0
// #define RENODX_TONE_MAP_FLARE                0
// #define RENODX_COLOR_GRADE_STRENGTH          1
// #define CUSTOM_BLOOM                         1
// #define CUSTOM_RANDOM                        1
// #define CUSTOM_GRAIN_STRENGTH                0

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float tone_map_hue_correction;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float scene_grade_strength;
  float custom_bloom;
  float custom_random;
  float custom_grain_strength;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.scene_grade_strength
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define CUSTOM_GRAIN_STRENGTH                shader_injection.custom_grain_strength

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_SHADOW_OF_WAR_SHARED_H_
