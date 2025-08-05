#ifndef SRC_ASSCREEDMIRAGE_SHARED_H_
#define SRC_ASSCREEDMIRAGE_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float custom_color_filter_strength;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float custom_bloom;
  float custom_bloom_scaling;
  float graphics_white_nits;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_GAME_GAMMA_CORRECTION 1u
#define HUE_CORRECTION               1u

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define CUSTOM_COLOR_FILTER_STRENGTH         shader_injection.custom_color_filter_strength
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_BLOOM_SCALING                 shader_injection.custom_bloom_scaling
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ASSCREEDMIRAGE_SHARED_H_
