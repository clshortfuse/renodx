#ifndef SRC_GAMES_JEDISURVIVOR_SHARED_H_
#define SRC_GAMES_JEDISURVIVOR_SHARED_H_

// #define RENODX_TONE_MAP_TYPE                 2  // 0 - Vanilla, 1 - None, 2 - ACES, 3 - RenoDRT, 4 - SDR
// #define RENODX_PEAK_WHITE_NITS               400
// #define RENODX_DIFFUSE_WHITE_NITS            100
// #define RENODX_GRAPHICS_WHITE_NITS           100
// #define RENODX_TONE_MAP_HUE_SHIFT            1
// #define RENODX_GAMMA_CORRECTION              1
// #define RENODX_GAMMA_CORRECTION_UI           1
// #define RENODX_TONE_MAP_EXPOSURE             1
// #define RENODX_TONE_MAP_HIGHLIGHTS           1
// #define RENODX_TONE_MAP_SHADOWS              1
// #define RENODX_TONE_MAP_CONTRAST             1
// #define RENODX_TONE_MAP_SATURATION           1
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1
// #define RENODX_TONE_MAP_BLOWOUT              0
// #define RENODX_TONE_MAP_FLARE                0
// #define CUSTOM_LUT_STRENGTH                  1
// #define CUSTOM_LUT_SCALING                   1
// #define CUSTOM_FISHEYE                       1
// #define CUSTOM_VIGNETTE                      1

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float gamma_correction_ui;
  float tone_map_hue_shift;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_fisheye;
  float custom_vignette;
};

#ifndef __cplusplus
cbuffer cb13 : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type  // 0 - Vanilla, 1 - None, 2 - ACES, 3 - RenoDRT, 4 - SDR
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_GAMMA_CORRECTION_UI           shader_injection.gamma_correction_ui
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_LUT_STRENGTH                  shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                   shader_injection.custom_lut_scaling
#define CUSTOM_FISHEYE                       shader_injection.custom_fisheye
#define CUSTOM_VIGNETTE                      shader_injection.custom_vignette

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_JEDISURVIVOR_SHARED_H_
