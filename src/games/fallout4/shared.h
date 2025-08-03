#ifndef SRC_FALLOUT4_SHARED_H_
#define SRC_FALLOUT4_SHARED_H_

struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float scene_grade_strength;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float gamma_correction;
  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_bloom;
  float custom_autoexposure;
  float custom_scene_filter;
  float custom_dof;
  float custom_film_grain;
  float custom_random;
};

#ifndef __cplusplus
cbuffer cb11 : register(b11) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define xRENODX_COLOR_GRADE_STRENGTH         shader_injection.scene_grade_strength
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                   shader_injection.custom_lut_scaling
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_AUTOEXPOSURE                  shader_injection.custom_autoexposure
#define CUSTOM_SCENE_FILTER                  shader_injection.custom_scene_filter
#define CUSTOM_DOF                           shader_injection.custom_dof
#define CUSTOM_FILM_GRAIN                    shader_injection.custom_film_grain
#define CUSTOM_RANDOM                        shader_injection.custom_random

#include "../../shaders/renodx.hlsl"

#endif  // __cplusplus

#endif  // SRC_FALLOUT4_SHARED_H_
