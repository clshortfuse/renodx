#ifndef SRC_DYINGLIGHTTHEBEAST_SHARED_H_
#define SRC_DYINGLIGHTTHEBEAST_SHARED_H_

#define RENODX_TONE_MAP_TYPE       2.f
#define RENODX_GAMMA_CORRECTION    0.f
#define RENODX_TONE_MAP_HUE_SHIFT  1.f
#define RENODX_TONE_MAP_BLOWOUT    1.f
#define RENODX_TONE_MAP_WHITE_CLIP 100.f

#define RENODX_PRE_EXPOSURE 1.f

#define RENODX_TONE_MAP_EXPOSURE             0.575f
#define RENODX_TONE_MAP_HIGHLIGHTS           1.f
#define RENODX_TONE_MAP_SHADOWS              1.f
#define RENODX_TONE_MAP_CONTRAST             1.1f
#define RENODX_TONE_MAP_SATURATION           1.05f
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#define RENODX_TONE_MAP_DECHROMA             0.f
#define RENODX_TONE_MAP_FLARE                0.f
#define RENODX_COLOR_GRADE_STRENGTH          1.f
#define RENODX_COLOR_GRADE_SCALING           0.f
#define LUT_SAMPLING_METHOD                  1.f

#define CUSTOM_BLOOM      0.5f
#define CUSTOM_LENS_FLARE 0.5f

#define RENODX_LUT_SHAPER 1.f

#ifndef __cplusplus

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DYINGLIGHTTHEBEAST_SHARED_H_