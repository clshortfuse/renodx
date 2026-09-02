#ifndef SRC_LEGOHPC_SHARED_H_
#define SRC_LEGOHPC_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_sdr_blend_factor;

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

  float scene_grade_strength;
  float gamma_correction;

  float stud_strength;
  float lut_strength;
  float letterbox;
  float custom_bloom;

  float custom_vignette;
  float custom_dof;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_SDR_BLEND_FACTOR     shader_injection.tone_map_sdr_blend_factor
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define LUT_STRENGTH                   shader_injection.lut_strength
#define STUD_STRENGTH                  shader_injection.stud_strength
#define CUSTOM_DOF                  shader_injection.custom_dof
#define LETTERBOX           !shader_injection.letterbox
// #define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
// #define RENODX_TONE_MAP_HUE_SHIFT_METHOD     HUE_SHIFT_METHOD_SDR_MODIFIED
// #define RENODX_TONE_MAP_HUE_SHIFT_MODIFIER   0.5f
#define RENODX_HUE_SHIFT shader_injection.scene_grade_strength
// #define RENODX_TONE_MAP_WORKING_COLOR_SPACE       shader_injection.tone_map_working_color_space
// #define RENODX_TONE_MAP_HUE_PROCESSOR             shader_injection.tone_map_hue_processor
#define RENODX_RENO_DRT_TONE_MAP_METHOD -1
#define RENODX_GAMMA_CORRECTION         shader_injection.gamma_correction
#define CUSTOM_BLOOM                    shader_injection.custom_bloom
#define CUSTOM_VIGNETTE                 shader_injection.custom_vignette
#define RENODX_INTERMEDIATE_SCALING     (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
// #define RENODX_INTERMEDIATE_COLOR_SPACE        color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_DECODING         1.f  // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
#define RENODX_INTERMEDIATE_ENCODING       1.f  // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION RENODX_GAMMA_CORRECTION
// #define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE RENODX_INTERMEDIATE_COLOR_SPACE
// #define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   COLOR_SPACE_CUSTOM_BT709D65
// #define RENODX_SWAP_CHAIN_SCALING_NITS         RENODX_GRAPHICS_WHITE_NITS
#define RENODX_SWAP_CHAIN_CLAMP_NITS        9999.f
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE renodx::color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING          ENCODING_SCRGB
// #define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_LEGOHPC_SHARED_H_
