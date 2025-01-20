#ifndef SRC_SHADOWTOMBRAIDER_SHARED_H_
#define SRC_SHADOWTOMBRAIDER_SHARED_H_

// #define RENODX_PEAK_WHITE_NITS               1000
// #define RENODX_DIFFUSE_WHITE_NITS            203
// #define RENODX_GRAPHICS_WHITE_NITS           203
// #define RENODX_TONE_MAP_TYPE                 3
// #define RENODX_TONE_MAP_EXPOSURE             1
// #define RENODX_TONE_MAP_HIGHLIGHTS           1
// #define RENODX_TONE_MAP_SHADOWS              1
// #define RENODX_TONE_MAP_CONTRAST             1
// #define RENODX_TONE_MAP_SATURATION           1
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 0.1
// #define RENODX_TONE_MAP_BLOWOUT              0.8
// #define RENODX_TONE_MAP_FLARE                0
// #define RENODX_TONE_MAP_HUE_SHIFT            0.25
// #define RENODX_TONE_MAP_WORKING_COLOR_SPACE  2
// #define RENODX_TONE_MAP_HUE_PROCESSOR        0
// #define RENODX_TONE_MAP_PER_CHANNEL          0
// #define RENODX_GAMMA_CORRECTION              0
// #define CUSTOM_LUT_STRENGTH                  1
// #define CUSTOM_VIGNETTE                      1
// #define CUSTOM_LENS_FLARE                    1
// #define CUSTOM_MOTION_BLUR                   1
// #define CUSTOM_BLOOM                         1

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel

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
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_hue_shift;
  float tone_map_working_color_space;
  float tone_map_hue_processor;
  float tone_map_per_channel;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_SHADOWTOMBRAIDER_SHARED_H_
