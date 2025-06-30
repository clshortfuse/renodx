#ifndef SRC_HASTE_SHARED_H_
#define SRC_HASTE_SHARED_H_

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define CUSTOM_TONE_MAP_CONFIGURATION        shader_injection.custom_tone_map_configuration
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
//#define RENODX_RENO_DRT_WHITE_CLIP           100.f
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_DECODING           0
#define RENODX_INTERMEDIATE_ENCODING         0
//#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength
#define CUSTOM_LUT_STRENGTH                  1.f
#define CUSTOM_LUT_SCALING                   shader_injection.custom_lut_scaling
#define CUSTOM_LUT_TETRAHEDRAL               1
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.tone_map_color_grade_strength
#define CUSTOM_COLOR_GRADING                 shader_injection.custom_color_grading
#define CUSTOM_CHROMATIC_ABERRATION          shader_injection.custom_chromatic_aberration
#define CUSTOM_VIGNETTE                      shader_injection.custom_vignette
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_DOF                           shader_injection.custom_dof
#define CUSTOM_SPEED_LINES                   shader_injection.custom_speed_lines

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float custom_tone_map_configuration;
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
  float tone_map_working_color_space;
  float tone_map_hue_processor;
  float tone_map_per_channel;
  float gamma_correction;
  float swap_chain_custom_color_space;
  float custom_lut_scaling;
  float custom_lut_strength;
  //float custom_lut_tetrahedral;
  float tone_map_color_grade_strength;
  float custom_color_grading;
  float custom_chromatic_aberration;
  float custom_vignette;
  float custom_bloom;
  float custom_dof;
  float custom_speed_lines;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_HASTE_SHARED_H_
