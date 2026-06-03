#ifndef SRC_ALIEN_ISOLATION_SHARED_H_
#define SRC_ALIEN_ISOLATION_SHARED_H_

#define HDR_LENS_FLARE 1

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_dechroma;
  float tone_map_flare;
  float custom_lut_strength;
  float custom_bloom;
  float custom_lens_flare;
  float custom_vignette;
  float custom_grain_type;
  float custom_grain_strength;
  float custom_sharpening;
  float custom_chromatic_aberration;
  float custom_alias_isolation_taa;
  float custom_random;
  float debug_1;
  float debug_2;
};

#ifndef __cplusplus
cbuffer cb11 : register(b11) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE       shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#define CUSTOM_LUT_STRENGTH         shader_injection.custom_lut_strength
#define CUSTOM_BLOOM                shader_injection.custom_bloom
#define CUSTOM_LENS_FLARE           shader_injection.custom_lens_flare
#define CUSTOM_VIGNETTE             shader_injection.custom_vignette
#define CUSTOM_GRAIN_TYPE           shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH       shader_injection.custom_grain_strength
#define CUSTOM_SHARPENING           shader_injection.custom_sharpening
#define CUSTOM_CHROMATIC_ABERRATION shader_injection.custom_chromatic_aberration
#define CUSTOM_ALIAS_ISOLATION_TAA  shader_injection.custom_alias_isolation_taa
#define CUSTOM_RANDOM               shader_injection.custom_random
#define DEBUG_1                     shader_injection.debug_1
#define DEBUG_2                     shader_injection.debug_2

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ALIEN_ISOLATION_SHARED_H_
