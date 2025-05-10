#ifndef SRC_OPUSECHOOFSTARSONG_SHARED_H_
#define SRC_OPUSECHOOFSTARSONG_SHARED_H_

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             1.03f * shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                   shader_injection.custom_lut_scaling
#define CUSTOM_LUT_TETRAHEDRAL               shader_injection.custom_lut_tetrahedral
#define CUSTOM_GRAIN_TOGGLE                  shader_injection.custom_grain_toggle
#define CUSTOM_FILM_GRAIN_STRENGTH           shader_injection.custom_film_grain_strength
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define ORIGINAL_GAMMA                       shader_injection.original_gamma
#define ORIGINAL_DITHER                      shader_injection.original_dither
#define ORIGINAL_BLACK_FLOOR                 shader_injection.original_black_floor
#define ORIGINAL_BLOWOUT                     shader_injection.original_blowout
#define RENODX_RENO_DRT_WHITE_CLIP           10.f

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
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;
  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;
  float tone_map_per_channel;
  float gamma_correction;
  float intermediate_scaling;
  float intermediate_encoding;
  float intermediate_color_space;
  float swap_chain_decoding;
  float swap_chain_gamma_correction;
  float swap_chain_custom_color_space;
  float swap_chain_clamp_color_space;
  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  float custom_lut_scaling;
  float custom_lut_strength;
  float custom_lut_tetrahedral;
  float bloom_intensity;
  float bloom_radius;
  float custom_grain_toggle;
  float custom_film_grain_strength;
  float custom_random;
  float original_gamma;
  float original_dither;
  float original_black_floor;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_OPUSECHOOFSTARSONG_SHARED_H_
