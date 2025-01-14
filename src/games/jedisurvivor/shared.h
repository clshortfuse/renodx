#ifndef SRC_GAMES_JEDISURVIVOR_SHARED_H_
#define SRC_GAMES_JEDISURVIVOR_SHARED_H_

#define RENODX_PEAK_WHITE_NITS               1000
#define RENODX_DIFFUSE_WHITE_NITS            203
#define RENODX_GRAPHICS_WHITE_NITS           203
#define RENODX_TONE_MAP_TYPE                 3
#define RENODX_TONE_MAP_EXPOSURE             1
#define RENODX_TONE_MAP_HIGHLIGHTS           1
#define RENODX_TONE_MAP_SHADOWS              1
#define RENODX_TONE_MAP_CONTRAST             1
#define RENODX_TONE_MAP_SATURATION           1
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 0.025
#define RENODX_TONE_MAP_BLOWOUT              0
#define RENODX_TONE_MAP_FLARE                0
#define RENODX_TONE_MAP_HUE_CORRECTION       0.6
#define RENODX_TONE_MAP_HUE_SHIFT            0
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  2
#define RENODX_TONE_MAP_HUE_PROCESSOR        0
#define RENODX_TONE_MAP_PER_CHANNEL          1
#define RENODX_GAMMA_CORRECTION              0
#define RENODX_GAMMA_CORRECTION_UI           0
#define CUSTOM_LUT_STRENGTH                  1
#define CUSTOM_LUT_SCALING                   0
#define CUSTOM_FISHEYE                       1
#define CUSTOM_VIGNETTE                      1

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float gamma_correction_ui;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_fisheye;
  float custom_vignette;
};

#endif  // SRC_GAMES_JEDISURVIVOR_SHARED_H_
