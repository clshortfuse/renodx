#ifndef SRC_ASSCREED1_SHARED_H_
#define SRC_ASSCREED1_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float tone_map_hue_shift;
  float tone_map_white_clip;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float scene_grade_strength;
  float color_grade_scaling;

  float custom_bloom;
  float custom_random;
  float custom_grain_type;
  float custom_grain_strength;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE       shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION    shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_SHIFT  shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_WHITE_CLIP shader_injection.tone_map_white_clip

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.scene_grade_strength
#define RENODX_COLOR_GRADE_SCALING           shader_injection.color_grade_scaling

#define CUSTOM_BLOOM          shader_injection.custom_bloom
#define CUSTOM_RANDOM         shader_injection.custom_random
#define CUSTOM_GRAIN_TYPE     shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH shader_injection.custom_grain_strength

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ASSCREED1_SHARED_H_
