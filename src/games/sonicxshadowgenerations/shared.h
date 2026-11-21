#ifndef SRC_GAMES_SONICXSHADOWGENERATIONS_SHARED_H_
#define SRC_GAMES_SONICXSHADOWGENERATIONS_SHARED_H_

// Must be 32bit aligned
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_hue_processor;
  float custom_rcas;
  float chromatic_aberration;
  float fx_bloom;
  float bloom_composite;
  float fx_bloom_threshold;
  float bloom_luminance_valid;
  float fx_bloom_haze;
  float bloom_target_level;
  float tone_map_vanilla_hue_influence;
  float tone_map_highlight_chroma_rolloff;
  float fx_motion_blur;
  float fx_motion_blur_samples;
  float fx_motion_blur_strength;
  float fx_motion_blur_full_res;
  float sg_bloom_enabled;
  float sg_bloom_strength;
  float sg_bloom_threshold;
  float sg_bloom_hdr;
  float sg_motion_blur;
  float sg_motion_blur_strength;
  float sg_motion_blur_samples;
  float sg_highlight_rolloff;
  float tone_map_type;
  float fx_sharpening;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b9, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b9) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            min(shader_injection.diffuse_white_nits, shader_injection.peak_white_nits)
#define RENODX_GRAPHICS_WHITE_NITS           renodx::color::bt2408::REFERENCE_WHITE
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION       1.f
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type

#define RENODX_GAMMA_CORRECTION renodx::draw::GAMMA_CORRECTION_GAMMA_2_2
#define RENODX_SWAP_CHAIN_ENCODING renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE renodx::color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE renodx::color::convert::COLOR_SPACE_BT2020

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_SONICXSHADOWGENERATIONS_SHARED_H_
