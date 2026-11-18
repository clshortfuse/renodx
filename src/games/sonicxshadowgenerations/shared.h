#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_hue_correction;
  float tone_map_hue_processor;
  float custom_flip_uv_y;
  float custom_rcas;
  float chromatic_aberration;
  float fx_bloom;
  float bloom_composite;
  float fx_bloom_threshold;
  float bloom_luminance_valid;
  float fx_bloom_haze;
  float bloom_target_level;
  float tone_map_highlight_saturation;
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
#define RENODX_DIFFUSE_WHITE_NITS            min(shader_injection.diffuse_white_nits, shader_injection.peak_white_nits)
#define RENODX_GRAPHICS_WHITE_NITS           renodx::color::bt2408::REFERENCE_WHITE
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation

#define RENODX_GAMMA_CORRECTION renodx::draw::GAMMA_CORRECTION_GAMMA_2_2
#define RENODX_SWAP_CHAIN_ENCODING renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE renodx::color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE renodx::color::convert::COLOR_SPACE_BT2020

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
