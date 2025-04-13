#ifndef SRC_GOW2018REDUX_SHARED_H_
#define SRC_GOW2018REDUX_SHARED_H_

// #define RENODX_PEAK_WHITE_NITS      400.f
// #define RENODX_DIFFUSE_WHITE_NITS   100.f
// #define RENODX_GRAPHICS_WHITE_NITS  100.f
// #define RENODX_GAMMA_CORRECTION     1u
// #define RENODX_TONE_MAP_TYPE        1u
// #define RENODX_TONE_MAP_EXPOSURE    1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS  1.f
// #define RENODX_TONE_MAP_SHADOWS     1.f
// #define RENODX_TONE_MAP_CONTRAST    1.f
// #define RENODX_TONE_MAP_SATURATION  1.f
// #define RENODX_TONE_MAP_BLOWOUT     0.f
// #define RENODX_TONE_MAP_HUE_SHIFT   0.2f
// #define RENODX_COLOR_GRADE_STRENGTH 1.f
// #define RENODX_COLOR_GRADE_SCALING  1.f
// #define CUSTOM_BLOOM                1.f
// #define RENODX_USE_PQ_ENCODING      1u
// #define RENODX_OVERRIDE_BRIGHTNESS  1u

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_blowout;
  float tone_map_hue_shift;
  float gamma_correction;
  float color_grade_strength;
  float color_grade_scaling;
  float custom_bloom;
  float tone_map_override_brightness;
  float custom_hdr10_encoding;
};

#ifndef __cplusplus
cbuffer cb11 : register(b11) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS      shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS   shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS  shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION     shader_injection.gamma_correction
#define RENODX_TONE_MAP_TYPE        shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE    shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS  shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS     shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST    shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION  shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT     shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_HUE_SHIFT   shader_injection.tone_map_hue_shift
#define RENODX_COLOR_GRADE_STRENGTH shader_injection.color_grade_strength
#define RENODX_COLOR_GRADE_SCALING  shader_injection.color_grade_scaling
#define CUSTOM_BLOOM                shader_injection.custom_bloom
#define RENODX_USE_PQ_ENCODING      shader_injection.custom_hdr10_encoding
#define RENODX_OVERRIDE_BRIGHTNESS  shader_injection.tone_map_override_brightness

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GOW2018REDUX_SHARED_H_
