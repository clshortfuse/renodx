#ifndef SRC_MAXPAYNE3_SHARED_H_
#define SRC_MAXPAYNE3_SHARED_H_

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
  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;

  float custom_bloom;
  float gamma_correction;
  float custom_random;
  float custom_film_grain_strength;
  float tone_map_contrast_highlights;
  float tone_map_contrast_shadows;
  float tone_map_dechroma;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_CORRECTION       0.6f
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              0.f
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS  shader_injection.tone_map_contrast_highlights
#define RENODX_TONE_MAP_CONTRAST_SHADOWS     shader_injection.tone_map_contrast_shadows
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#define CUSTOM_BLOOM               shader_injection.custom_bloom
#define CUSTOM_RANDOM              shader_injection.custom_random
#define CUSTOM_FILM_GRAIN_STRENGTH shader_injection.custom_film_grain_strength

#define RENODX_INTERMEDIATE_ENCODING           (RENODX_GAMMA_CORRECTION + 1.f)
#define RENODX_INTERMEDIATE_COLOR_SPACE        color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_DECODING             RENODX_INTERMEDIATE_ENCODING
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION     GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE RENODX_INTERMEDIATE_COLOR_SPACE
#define RENODX_INTERMEDIATE_SCALING            (RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS)
#define RENODX_SWAP_CHAIN_SCALING_NITS         RENODX_DIFFUSE_WHITE_NITS
#define RENODX_SWAP_CHAIN_CLAMP_NITS           10000.f
#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020

#define CLAMP_POSTFX 1

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_MAXPAYNE3_SHARED_H_
