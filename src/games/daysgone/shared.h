#ifndef SRC_DAYSGONE_SHARED_H_
#define SRC_DAYSGONE_SHARED_H_

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                shader_injection.gamma_correction //0 // 0 = Off, 1 = 2.2, 2 = BT.1886
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare

#define SCENE_GRADE_PER_CHANNEL_BLOWOUT        shader_injection.scene_grade_per_channel_blowout
#define SCENE_GRADE_PER_CHANNEL_HUE_SHIFT       shader_injection.scene_grade_per_channel_hue_shift
#define SCENE_GRADE_COLOR_GRADE_STRENGTH          shader_injection.scene_grade_color_grade_strength
#define SCENE_GRADE_SKIP_ACES                  shader_injection.scene_grade_skip_aces

// #define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
// #define CUSTOM_RANDOM                          shader_injection.custom_random
#define TONEMAP_UNDER_UI                      shader_injection.tonemap_under_ui
#define LUT_SHAPER                             0 //shader_injection.lut_shaper

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float gamma_correction;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float scene_grade_per_channel_blowout;
  float scene_grade_per_channel_hue_shift;
  float scene_grade_color_grade_strength;
  float scene_grade_skip_aces;
  //float custom_film_grain;
  //float custom_random;
  float tonemap_under_ui;
  //float lut_shaper;
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

#endif  // SRC_DAYSGONE_SHARED_H_
