#ifndef SRC_DEADSPACE2023_SHARED_H_
#define SRC_DEADSPACE2023_SHARED_H_

#define DEADSPACE_ENABLE_RESOURCE_UPGRADES 1

#ifndef __cplusplus

// With OVERRIDE_GAME_BRIGHTNESS disabled
// input = real output
// 417 = 400
// 943 = 800
// 1245 = 1000
// 2096 = 1500
// 3142 = 2000
// 4432 = 2500
// 10081.5 = 4000

#define TONE_MAP_TYPE              1.f
#define RENODX_PEAK_WHITE_NITS     450.f
#define OVERRIDE_GAME_BRIGHTNESS   1.f
#define RENODX_DIFFUSE_WHITE_NITS  100.f
#define OVERRIDE_UI_BRIGHTNESS     1.f
#define RENODX_GRAPHICS_WHITE_NITS 140.f

#define RENODX_TONE_MAP_WORKING_COLOR_SPACE 1.f  // 0 - AP1, 1 - LMS
#define RENODX_SDR_EOTF_EMULATION_UI        1.f
#define CUSTOM_SHOW_UI                      1.f

#define RENODX_TONE_MAP_EXPOSURE             1.f
#define RENODX_TONE_MAP_HIGHLIGHTS           1.f
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS  1.f
#define RENODX_TONE_MAP_SHADOWS              1.f
#define RENODX_TONE_MAP_CONTRAST_SHADOWS     1.f
#define RENODX_TONE_MAP_CONTRAST             1.f
#define RENODX_TONE_MAP_SATURATION           1.f
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#define RENODX_TONE_MAP_DECHROMA             0.f
#define RENODX_TONE_MAP_FLARE                0.f
#define RENODX_TONE_MAP_GAMMA                1.f
#define COLOR_GRADE_LUT_STRENGTH             1.f

#define CUSTOM_BLOOM          1.f
#define CUSTOM_GRAIN_TYPE     0.f
#define CUSTOM_GRAIN_STRENGTH 1.f

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DEADSPACE2023_SHARED_H_