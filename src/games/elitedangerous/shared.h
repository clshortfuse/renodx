#ifndef SRC_ELITEDANGEROUS_SHARED_H_
#define SRC_ELITEDANGEROUS_SHARED_H_

// #define RENODX_PEAK_WHITE_NITS               400.f
// #define RENODX_DIFFUSE_WHITE_NITS            100.f
// #define RENODX_GRAPHICS_WHITE_NITS           100.f
// #define RENODX_TONE_MAP_TYPE                 3.f
// #define RENODX_TONE_MAP_EXPOSURE             1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS           1.f
// #define RENODX_TONE_MAP_SHADOWS              1.f
// #define RENODX_TONE_MAP_CONTRAST             1.f
// #define RENODX_TONE_MAP_SATURATION           1.f
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 0.f
// #define RENODX_TONE_MAP_BLOWOUT              0.f
// #define RENODX_TONE_MAP_FLARE                1.f
// #define RENODX_TONE_MAP_HUE_CORRECTION       1.f
// #define RENODX_TONE_MAP_WORKING_COLOR_SPACE  0.f
// #define RENODX_TONE_MAP_HUE_PROCESSOR        0.f
// #define RENODX_TONE_MAP_PER_CHANNEL          0.f
// #define RENODX_POST_LUT_SATURATION           1.25f
// #define RENODX_POST_LUT_BLOWOUT              0.25f
// #define CUSTOM_LUT_STRENGTH                  1.f
// #define CUSTOM_BLOOM                         1.f
// #define CUSTOM_AUTO_EXPOSURE                 1.f
// #define CUSTOM_RANDOM                        0.f
// #define CUSTOM_GRAIN_STRENGTH                0.f

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
  float tone_map_highlight_saturation;
  float tone_map_dechroma;
  float tone_map_flare;

  float tone_map_per_channel;
  float custom_lut_strength;
  float custom_bloom;
  float custom_random;
  float custom_grain_strength;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE        shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS      shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS   shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS  shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_PER_CHANNEL shader_injection.tone_map_per_channel

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength

#define CUSTOM_BLOOM          shader_injection.custom_bloom
#define CUSTOM_RANDOM         shader_injection.custom_random
#define CUSTOM_GRAIN_STRENGTH shader_injection.custom_grain_strength

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ELITEDANGEROUS_SHARED_H_