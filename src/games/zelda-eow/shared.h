#ifndef SRC_ZELDA_EOW_SHARED_H_
#define SRC_ZELDA_EOW_SHARED_H_

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

  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;
  float tone_map_hue_processor;

  float tone_map_per_channel;
  float scene_grade_strength;
  float scene_grade_hue_correction;
  float scene_grade_saturation_correction;
  float scene_grade_blowout_restoration;
  float scene_grade_hue_shift;

  float gamma_correction;
  float custom_bloom;

  float custom_dof;
};

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
// #define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
// #define RENODX_TONE_MAP_HUE_SHIFT_METHOD     HUE_SHIFT_METHOD_SDR_MODIFIED
// #define RENODX_TONE_MAP_HUE_SHIFT_MODIFIER   0.5f
#define RENODX_PER_CHANNEL_BLOWOUT_RESTORATION    shader_injection.scene_grade_blowout_restoration
#define RENODX_PER_CHANNEL_HUE_CORRECTION         shader_injection.scene_grade_hue_correction
#define RENODX_PER_CHANNEL_CHROMINANCE_CORRECTION shader_injection.scene_grade_saturation_correction
#define RENODX_PER_CHANNEL_HUE_SHIFT              shader_injection.scene_grade_hue_shift
#define RENODX_COLOR_GRADE_STRENGTH               shader_injection.scene_grade_strength
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE       shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR             shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_PER_CHANNEL               shader_injection.tone_map_per_channel
#define RENODX_RENO_DRT_TONE_MAP_METHOD           renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_GAMMA_CORRECTION                   shader_injection.gamma_correction
#define CUSTOM_BLOOM                              shader_injection.custom_bloom
#define CUSTOM_DOF                                shader_injection.custom_dof

// #define RENODX_INTERMEDIATE_SCALING            (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
#define RENODX_INTERMEDIATE_ENCODING renodx::draw::ENCODING_NONE
// #define RENODX_INTERMEDIATE_COLOR_SPACE        color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_DECODING         renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION RENODX_GAMMA_CORRECTION
// #define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE RENODX_INTERMEDIATE_COLOR_SPACE
// #define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   COLOR_SPACE_CUSTOM_BT709D65
// #define RENODX_SWAP_CHAIN_SCALING_NITS         RENODX_GRAPHICS_WHITE_NITS
// #define RENODX_SWAP_CHAIN_CLAMP_NITS           RENODX_PEAK_WHITE_NITS
// #define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_UNKNOWN
// #define RENODX_SWAP_CHAIN_ENCODING             ENCODING_SCRGB
// #define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709

#ifndef __cplusplus
#ifdef __SLANG__
layout(push_constant) uniform PushData {
  ShaderInjectData shader_injection;
}
#else
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injected_buffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injected_buffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}
#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ZELDA_EOW_SHARED_H_
