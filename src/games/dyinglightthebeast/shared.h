#ifndef SRC_DYINGLIGHTTHEBEAST_SHARED_H_
#define SRC_DYINGLIGHTTHEBEAST_SHARED_H_

#define USE_CUSTOM_AUTOEXPOSURE 1.f

#define RENODX_TONE_MAP_TYPE       2.f
#define RENODX_GAMMA_CORRECTION    2.f
#define RENODX_TONE_MAP_HUE_SHIFT  1.f
#define RENODX_TONE_MAP_BLOWOUT    0.25f
#define RENODX_TONE_MAP_WHITE_CLIP 100.f

#define RENODX_TONE_MAP_EXPOSURE             1.f
#define RENODX_TONE_MAP_HIGHLIGHTS           1.f
#define RENODX_TONE_MAP_SHADOWS              1.f
#define RENODX_TONE_MAP_CONTRAST             1.f
#define RENODX_TONE_MAP_SATURATION           1.f
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#define RENODX_TONE_MAP_DECHROMA             0.f
#define RENODX_TONE_MAP_FLARE                0.f
#define RENODX_COLOR_GRADE_STRENGTH          1.f
#define RENODX_COLOR_GRADE_SCALING           1.f
#define LUT_SAMPLING_METHOD                  1.f

#define CUSTOM_BLOOM      1.f
#define CUSTOM_LENS_FLARE 1.f

#define RENODX_LUT_SHAPER        1.f
#define CUSTOM_LUT_TETRAHEDRAL   1.f
#define RENODX_LUT_OUTPUT_BT2020 1.f

#ifndef __cplusplus

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DYINGLIGHTTHEBEAST_SHARED_H_