#ifndef SRC_DARKSIDERS_WARMASTERED_SHARED_H_
#define SRC_DARKSIDERS_WARMASTERED_SHARED_H_

#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE

#define RENODX_RENDER_MODE                   shader_injection.render_mode_setting
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction

#define CUSTOM_HDR_BOOST                     shader_injection.hdr_boost
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_PER_CHANNEL          0.f

#define SCENE_GRADE_PER_CHANNEL_BLOWOUT      shader_injection.scene_grade_per_channel_blowout
#define SCENE_GRADE_PER_CHANNEL_HUE_SHIFT    shader_injection.scene_grade_per_channel_hue_shift
#define SCENE_GRADE_HUE_CLIP                 shader_injection.scene_grade_hue_clip

#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define CUSTOM_VIDEO_ITM                     shader_injection.custom_video_itm
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_BITS          shader_injection.swap_chain_output_dither_bits
#define RENODX_SWAP_CHAIN_OUTPUT_DITHER_SEED          shader_injection.swap_chain_output_dither_seed

#define CUSTOM_BLOOM                        shader_injection.custom_bloom
#define CUSTOM_CHROMATIC_ABERRATION          shader_injection.custom_chromatic_aberration
#define CUSTOM_VIGNETTE                      shader_injection.custom_vignette
#define CUSTOM_SHARPENING                     shader_injection.custom_sharpening

#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  color::convert::COLOR_SPACE_BT2020
//#define RENODX_SWAP_CHAIN_DECODING           1.f // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
//#define RENODX_INTERMEDIATE_ENCODING         1.f // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
//#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
//#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET        shader_injection.swap_chain_output_preset

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float render_mode_setting;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;

  float gamma_correction;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;

  float scene_grade_per_channel_blowout;
  float scene_grade_per_channel_hue_shift;
  float scene_grade_hue_clip;
  float hdr_boost;
  float custom_film_grain;
  float custom_random;
  
  float custom_bloom;
  float custom_chromatic_aberration;
  float custom_vignette;
  float custom_sharpening;
  float custom_video_itm;
  float swap_chain_output_dither_bits;
  float swap_chain_output_dither_seed;

  float swap_chain_output_preset;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injectedBuffer : register(b13, space0) {
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

#endif  // SRC_DARKSIDERS_WARMASTERED_SHARED_H_
