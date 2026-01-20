#ifndef SRC_HITMANWOA_SHARED_H_
#define SRC_HITMANWOA_SHARED_H_

#define FORCE_HDR10          1  // fixes NVAPI washed out issue
#define ENABLE_SHADER_TOGGLE 1

#define RENODX_TONE_MAP_TYPE                   1.f
#define RENODX_PEAK_WHITE_NITS                 400.f
#define RENODX_DIFFUSE_WHITE_NITS              100.f
#define RENODX_GRAPHICS_WHITE_NITS             100.f
#define RENODX_TONE_MAP_HUE_SHIFT              0.f
#define RENODX_GAMMA_CORRECTION                2.f
#define RENODX_PER_CHANNEL_BLOWOUT_RESTORATION 0.f
#define RENODX_TONE_MAP_EXPOSURE               1.f
#define RENODX_TONE_MAP_HIGHLIGHTS             1.f
#define RENODX_TONE_MAP_SHADOWS                1.f
#define RENODX_TONE_MAP_CONTRAST               1.f
#define RENODX_TONE_MAP_SATURATION             1.f
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   1.f
#define RENODX_TONE_MAP_BLOWOUT                0.f
#define RENODX_TONE_MAP_FLARE                  0.f
#define RENODX_COLOR_GRADE_STRENGTH            1.f
#define RENODX_COLOR_GRADE_SCALING             1.f
#define RENODX_LUT_SAMPLING_TYPE               1.f  // 0 = default, 1 = replace linear/gamma2 input with srgb input and add lut offsets
#define LUT_GAMUT_RESTORATION                  0.f
#define CUSTOM_BLOOM                           0.75f
#define CUSTOM_BLOOM_SCALING                   1.f
#define CUSTOM_LUT_TETRAHEDRAL                 1.f
#define CUSTOM_SHARPENING                      0.f
#define CUSTOM_DITHERING                       0.f
#define COMPRESS_TO_BT709                      1.f

#define BLOOM_SCALING_MAX 0.33f

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_hue_correction;
  float gamma_correction;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float color_grade_strength;
  float color_grade_scaling;

  float custom_bloom;
  float color_grade_lut_sampling;
  float custom_sharpening;
  float custom_dithering;
};

#ifndef __cplusplus
// cbuffer shader_injection : register(b13, space50) {
//   ShaderInjectData shader_injection : packoffset(c0);
// }

// #define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
// #define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
// #define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
// #define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
// #define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
// #define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
// #define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
// #define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
// #define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
// #define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
// #define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
// #define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
// #define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
// #define RENODX_COLOR_GRADE_SCALING           shader_injection.color_grade_scaling
// #define CUSTOM_BLOOM                         shader_injection.custom_bloom
// #define CUSTOM_LUT_TETRAHEDRAL               shader_injection.color_grade_lut_sampling
// #define CUSTOM_SHARPENING                    shader_injection.custom_sharpening
// #define CUSTOM_DITHERING                     shader_injection.custom_dithering

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_HITMANWOA_SHARED_H_
