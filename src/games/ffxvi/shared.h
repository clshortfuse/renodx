#ifndef SRC_FFXVI_SHARED_H_
#define SRC_FFXVI_SHARED_H_

// #define RENODX_OVERRIDE_PEAK_NITS            0.f
// #define RENODX_TONE_MAP_TYPE                 1.f
// #define RENODX_PEAK_WHITE_NITS               400.f
// #define RENODX_DIFFUSE_WHITE_NITS            100.f
// #define RENODX_TONE_MAP_HUE_CORRECTION       0.5f
// #define RENODX_TONE_MAP_EXPOSURE             1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS           1.f
// #define RENODX_TONE_MAP_SHADOWS              1.f
// #define RENODX_TONE_MAP_CONTRAST             1.f
// #define RENODX_TONE_MAP_FLARE                0.f
// #define RENODX_TONE_MAP_SATURATION           2.55f
// #define RENODX_TONE_MAP_BLOWOUT              0.91f
// #define RENODX_COLOR_GRADE_STRENGTH          1.f
// #define CUSTOM_BLOOM                         1.f
// #define CUSTOM_BLOOM_SCALING                 1.f
// #define RENODX_CUSTOM_COLOR_SPACE            0.f
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.35f
// #define RENODX_TONE_MAP_SHOULDER_START       0.2f

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_override_peak_nits;
  float peak_white_nits;
  float diffuse_white_nits;
  float color_grade_strength;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_flare;
  float tone_map_saturation;
  float tone_map_blowout;
  float tone_map_highlight_saturation;
  float tone_map_hue_correction;
  float tone_map_shoulder_start;
  float custom_color_space;

  float custom_bloom;
  float custom_bloom_scaling;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_OVERRIDE_PEAK_NITS            shader_injection.tone_map_override_peak_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_BLOOM_SCALING                 shader_injection.custom_bloom_scaling
#define RENODX_CUSTOM_COLOR_SPACE            shader_injection.custom_color_space
#define RENODX_TONE_MAP_SHOULDER_START       shader_injection.tone_map_shoulder_start

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_FFXVI_SHARED_H_
