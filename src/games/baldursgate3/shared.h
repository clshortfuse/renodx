#ifndef SRC_BALDURSGATE3_SHARED_H
#define SRC_BALDURSGATE3_SHARED_H

// #define RENODX_PEAK_WHITE_NITS      400.f
// #define RENODX_DIFFUSE_WHITE_NITS   100.f
// #define RENODX_GRAPHICS_WHITE_NITS  100.f
// #define RENODX_GAMMA_CORRECTION     1u
// #define RENODX_TONE_MAP_EXPOSURE    1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS  1.f
// #define RENODX_TONE_MAP_SHADOWS     1.f
// #define RENODX_TONE_MAP_CONTRAST    1.f
// #define RENODX_TONE_MAP_SATURATION  1.f
// #define RENODX_TONE_MAP_BLOWOUT     0.f
// #define RENODX_COLOR_GRADE_STRENGTH 1.f

#define RENODX_TONE_MAP_TYPE 1u

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_blowout;
  float color_grade_strength;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS      shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS   shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS  shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION     shader_injection.gamma_correction
#define RENODX_TONE_MAP_EXPOSURE    shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS  shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS     shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST    shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION  shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT     shader_injection.tone_map_blowout
#define RENODX_COLOR_GRADE_STRENGTH shader_injection.color_grade_strength

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_BALDURSGATE3_SHARED_H
