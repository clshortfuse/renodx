#ifndef SRC_THECALLISTOPROTOCOL_SHARED_H_
#define SRC_THECALLISTOPROTOCOL_SHARED_H_

// Must be 32-bit aligned and grouped in 4x32-bit constant-buffer rows.
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float tone_map_working_color_space;

  float graphics_white_nits;
  float gamma_correction;
  float gamma_correction_ui;

  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_flare;
  float color_grade_strength;
  float color_grade_scaling;

  float custom_film_grain_type;
  float custom_grain_strength;
  float custom_random;
};

#ifndef __cplusplus

cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE       shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits

#define RENODX_GAMMA_CORRECTION    shader_injection.gamma_correction
#define RENODX_GAMMA_CORRECTION_UI shader_injection.gamma_correction_ui

#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_COLOR_GRADE_SCALING           shader_injection.color_grade_scaling

#define CUSTOM_GRAIN_TYPE     shader_injection.custom_film_grain_type
#define CUSTOM_GRAIN_STRENGTH shader_injection.custom_grain_strength
#define CUSTOM_RANDOM         shader_injection.custom_random

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_THECALLISTOPROTOCOL_SHARED_H_