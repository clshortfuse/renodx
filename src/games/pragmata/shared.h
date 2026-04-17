#ifndef SRC_PRAGMATA_SHARED_H_
#define SRC_PRAGMATA_SHARED_H_

#define SKIP_LUTS              0
#define SKIP_TONEMAP           0
#define APPLY_HIGHLIGHT_BOOST  1
#define RENODX_CUSTOM_EXPOSURE 0.76

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_use_aces;
  float gamma_correction;
  float gamma_correction_ui;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_apply_pre_tone_map_curve;
  float tone_map_scaling;
  float custom_ui_visibility;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_dechroma;
  float tone_map_flare;
  float tone_map_gamma;
  float color_grade_lut_strength;
  float color_grade_lut_scaling;

  float custom_noise;
  float custom_random;
  float custom_grain_strength;
};

#ifndef __cplusplus
cbuffer cb13 : register(b0, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define TONE_MAP_TYPE                     shader_injection.tone_map_type
#define TONE_MAP_APPLY_PRE_TONE_MAP_CURVE shader_injection.tone_map_apply_pre_tone_map_curve
#define RENODX_PEAK_WHITE_NITS            shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS         shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS        shader_injection.graphics_white_nits
#define CUSTOM_SHOW_UI                    shader_injection.custom_ui_visibility

#define RENODX_TONE_MAP_SCALING    shader_injection.tone_map_scaling
#define RENODX_GAMMA_CORRECTION    shader_injection.gamma_correction
#define RENODX_GAMMA_CORRECTION_UI shader_injection.gamma_correction_ui

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_GAMMA                shader_injection.tone_map_gamma
#define COLOR_GRADE_LUT_STRENGTH             shader_injection.color_grade_lut_strength
#define COLOR_GRADE_LUT_SCALING              shader_injection.color_grade_lut_scaling

#define CUSTOM_NOISE          shader_injection.custom_noise
#define CUSTOM_RANDOM         shader_injection.custom_random
#define CUSTOM_GRAIN_STRENGTH shader_injection.custom_grain_strength

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_PRAGMATA_SHARED_H_