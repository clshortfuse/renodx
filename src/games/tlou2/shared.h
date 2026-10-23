#ifndef SRC_TLOU2_SHARED_H_
#define SRC_TLOU2_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;

  float custom_random;
  float custom_film_grain_type;
  float custom_grain_strength;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE       shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits
#define RENODX_SDR_EOTF_EMULATION  shader_injection.gamma_correction

#define CUSTOM_RANDOM         shader_injection.custom_random
#define CUSTOM_GRAIN_TYPE     shader_injection.custom_film_grain_type
#define CUSTOM_GRAIN_STRENGTH shader_injection.custom_grain_strength

#define CUSTOM_GRADE_STRENGTH 1.f

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_TLOU2_SHARED_H_