#ifndef SRC_CONTROL_RESONANT_SHARED_H_
#define SRC_CONTROL_RESONANT_SHARED_H_

#define ENABLE_SLIDERS 1

#if ENABLE_SLIDERS
// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_highlight_compression;
  float tone_map_highlights;
  float tone_map_contrast_highlights;

  float tone_map_shadows;
  float tone_map_contrast_shadows;
  float tone_map_contrast;
  float tone_map_saturation;

  float tone_map_highlight_saturation;
  float tone_map_dechroma;
  float tone_map_flare;
  float color_grade_lut_strength;

  float tone_map_gamut_clip;
};
#endif  // ENABLE_SLIDERS

#ifndef __cplusplus
#if ENABLE_SLIDERS
cbuffer shader_injection : register(b0, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define TONE_MAP_TYPE                  shader_injection.tone_map_type
#define TONE_MAP_HIGHLIGHT_COMPRESSION shader_injection.tone_map_highlight_compression
#define TONE_MAP_GAMUT_CLIP            shader_injection.tone_map_gamut_clip

#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS  shader_injection.tone_map_contrast_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST_SHADOWS     shader_injection.tone_map_contrast_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define COLOR_GRADE_LUT_STRENGTH             shader_injection.color_grade_lut_strength

#else

#define TONE_MAP_TYPE                  1.f
#define TONE_MAP_HIGHLIGHT_COMPRESSION 1.f
#define TONE_MAP_GAMUT_CLIP            1.f

#define RENODX_TONE_MAP_HIGHLIGHTS           1.f
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS  1.f
#define RENODX_TONE_MAP_SHADOWS              1.f
#define RENODX_TONE_MAP_CONTRAST_SHADOWS     1.f
#define RENODX_TONE_MAP_CONTRAST             1.f
#define RENODX_TONE_MAP_SATURATION           1.f
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#define RENODX_TONE_MAP_DECHROMA             0.f
#define RENODX_TONE_MAP_FLARE                0.f
#define COLOR_GRADE_LUT_STRENGTH             1.f

#endif  // ENABLE_SLIDERS

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_CONTROL_RESONANT_SHARED_H_