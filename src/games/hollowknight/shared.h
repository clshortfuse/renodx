#ifndef SRC_HOLLOWKNIGHT_SHARED_H_
#define SRC_HOLLOWKNIGHT_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float color_grade_strength;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_white_clip;
  float tone_map_hue_processor;
  float gamma_correction;
  float custom_hue_shift;
  float custom_random;
  float custom_grain_type;
  float custom_grain_strength;
  float custom_bloom;
  float custom_hero_light;
  float custom_hdr_videos;
  float custom_vignette;
  float custom_saturation_clip;
  float custom_bloom_clip;
  float custom_hue_clip;
  float swap_chain_output_preset;
  float swap_chain_output_dither_bits;
  float swap_chain_output_dither_seed;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_TONE_MAP_HUE_CORRECTION       0.f
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET      shader_injection.swap_chain_output_preset
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_BITS shader_injection.swap_chain_output_dither_bits
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_SEED shader_injection.swap_chain_output_dither_seed
#define RENODX_RENO_DRT_WHITE_CLIP           shader_injection.tone_map_white_clip
#define CUSTOM_GRAIN_TYPE                    shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH                shader_injection.custom_grain_strength
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define CUSTOM_HERO_LIGHT                    shader_injection.custom_hero_light
#define CUSTOM_HDR_VIDEOS                    shader_injection.custom_hdr_videos
#define CUSTOM_SATURATION_CLIP               shader_injection.custom_saturation_clip
#define CUSTOM_BLOOM_CLIP                    shader_injection.custom_bloom_clip
#define CUSTOM_HUE_CLIP                      shader_injection.custom_hue_clip

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_HOLLOWKNIGHT_SHARED_H_
