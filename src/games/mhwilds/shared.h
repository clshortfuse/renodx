#ifndef SRC_MHWILDS_SHARED_H_
#define SRC_MHWILDS_SHARED_H_

#define RENODX_TONE_MAP_TYPE                   3.f
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_PER_CHANNEL            0.f // shader_injection.tone_map_per_channel
// #define RENODX_TONE_MAP_HUE_PROCESSOR          shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define RENODX_SWAP_CHAIN_DECODING             ENCODING_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     1.f
#define RENODX_SWAP_CHAIN_SCALING_NITS         100.f * RENODX_DIFFUSE_WHITE_NITS / 203.f
#define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_ENCODING             ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_RENO_DRT_WHITE_CLIP             100.f
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                          shader_injection.custom_random
#define CUSTOM_SHARPNESS                       0.f
#define CUSTOM_VIGNETTE                        shader_injection.custom_vignette
#define CUSTOM_LUT_COLOR_STRENGTH              1.f // shader_injection.custom_lut_color_strength
#define CUSTOM_LUT_OUTPUT_STRENGTH             1.f // shader_injection.custom_lut_output_strength
#define CUSTOM_USE_HDR_TONEMAP                 0.f
#define CUSTOM_ABERRATION                      1.f
#define CUSTOM_EXPOSURE_TYPE                   0.f // shader_injection.custom_exposure_type
#define CUSTOM_EXPOSURE_STRENGTH               1.f // shader_injection.custom_exposure_strength
#define CUSTOM_FLAT_EXPOSURE_DEFAULT           1.f
#define CUSTOM_LUT_EXPOSURE_REVERSE            0.f // shader_injection.custom_lut_exposure_reverse
#define CUSTOM_EXPOSURE_SHADER_DRAW            shader_injection.custom_exposure_shader_draw
#define CUSTOM_SDR_TONEAMPPER                  3.f // shader_injection.custom_sdr_tonemapper
#define CUSTOM_TONE_MAP_METHOD                 1.f // shader_injection.custom_tone_map_method

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float color_grade_strength;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_hue_processor;
  float tone_map_per_channel;
  float swap_chain_gamma_correction;
  float swap_chain_custom_color_space;
  float custom_lut_color_strength;
  float custom_lut_output_strength;
  float custom_film_grain;
  float custom_vignette;
  float custom_random;
  float custom_exposure_type;
  float custom_exposure_strength;
  float custom_lut_exposure_reverse;
  float custom_exposure_shader_draw;
  float custom_sdr_tonemapper;
  float custom_tone_map_method;
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

#endif  // SRC_MHWILDS_SHARED_H_
