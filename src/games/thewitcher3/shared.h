#ifndef SRC_THEWITCHER3_SHARED_H_
#define SRC_THEWITCHER3_SHARED_H_

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type
#define CUSTOM_RENODX_TONE_MAP_TYPE            shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
// #define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT              0.f
// #define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection.tone_map_hue_processor
//#define RENODX_TONE_MAP_PER_CHANNEL            shader_injection.tone_map_per_channel
//#define RENODX_COLOR_GRADE_STRENGTH            shader_injection.tone_map_color_grade_strength
#define RENODX_COLOR_GRADE_STRENGTH            shader_injection.scene_grade_strength
#define RENODX_INTERMEDIATE_ENCODING           renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_DECODING             renodx::draw::ENCODING_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     renodx::draw::GAMMA_CORRECTION_NONE
#define RENODX_GAMMA_CORRECTION                renodx::draw::GAMMA_CORRECTION_NONE
//#define RENODX_SWAP_CHAIN_SCALING_NITS         100.f * RENODX_DIFFUSE_WHITE_NITS / 203.f
#define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD
//#define RENODX_RENO_DRT_WHITE_CLIP             100.f
#define CUSTOM_SCENE_GRADE_METHOD              shader_injection.scene_grade_method
#define CUSTOM_SCENE_GRADE_HUE_CORRECTION      shader_injection.scene_grade_hue_correction
#define CUSTOM_SCENE_GRADE_SATURATION_CORRECTION shader_injection.scene_grade_saturation_correction
#define CUSTOM_SCENE_GRADE_BLOWOUT_RESTORATION shader_injection.scene_grade_blowout_restoration
#define CUSTOM_SCENE_GRADE_HUE_SHIFT           shader_injection.scene_grade_hue_shift
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                          shader_injection.custom_random
#define CUSTOM_LUT_STRENGTH                    shader_injection.custom_lut_strength
//#define CUSTOM_POST_MAXCLL                     shader_injection.custom_post_maxcll
#define CUSTOM_BLOOM                           shader_injection.custom_bloom
#define CUSTOM_LENS_DIRT                       shader_injection.custom_lens_dirt
#define CUSTOM_SUNSHAFTS_STRENGTH              shader_injection.custom_sunshafts_strength
#define CUSTOM_DEPTH_BLUR                      shader_injection.custom_depth_blur
#define CUSTOM_SHARPENING_TYPE                shader_injection.custom_sharpening_type
#define CUSTOM_SHARPNESS                      shader_injection.custom_sharpness
#define CUSTOM_TONEMAP_EXPOSURE                shader_injection.tone_map_exposure
#define UTILITY_HUD                            shader_injection.utility_hud

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
  // float tone_map_hue_correction;
  // float tone_map_hue_shift;
  //float tone_map_hue_processor;
  float tone_map_per_channel;
  float tone_map_color_grade_strength;
  float swap_chain_custom_color_space;
  float scene_grade_method;
  float scene_grade_strength;
  float scene_grade_hue_correction;
  float scene_grade_saturation_correction;
  float scene_grade_blowout_restoration;
  float scene_grade_hue_shift;
  float custom_film_grain;
  float custom_random;
  float custom_lut_strength;
  //float custom_post_maxcll;
  float custom_bloom;
  float custom_lens_dirt;
  float custom_sunshafts_strength;
  float custom_tone_map_exposure;
  float custom_depth_blur;
  float custom_sharpening_type;
  float custom_sharpness;
  float utility_hud;
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

#endif  // SRC_THEWITCHER3_SHARED_H_
