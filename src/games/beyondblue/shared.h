#ifndef SRC_BEYONDBLUE_SHARED_H_
#define SRC_BEYONDBLUE_SHARED_H_

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
  float tone_map_blowout;
  float tone_map_hue_correction;
  float gamma_correction;

  float custom_bloom;
  float custom_grain_type;
  float custom_grain_strength;
  float custom_lut_tetrahedral;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE           shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS         shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS      shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS     shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION        shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_CORRECTION shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_EXPOSURE       shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS     shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS        shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST       shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION     shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT        shader_injection.tone_map_blowout
#define RENODX_COLOR_GRADE_STRENGTH    shader_injection.color_grade_strength
#define CUSTOM_BLOOM                   shader_injection.custom_bloom
#define CUSTOM_GRAIN_TYPE              shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH          shader_injection.custom_grain_strength
#define CUSTOM_LUT_TETRAHEDRAL         shader_injection.custom_lut_tetrahedral

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_BEYONDBLUE_SHARED_H_
