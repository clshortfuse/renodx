#ifndef SRC_RE7_RE2R_RE3R_REVILLAGE_SHARED_H_
#define SRC_RE7_RE2R_RE3R_REVILLAGE_SHARED_H_

#define FORCE_HDR10 1  // fixes NVAPI washed out issue

#ifndef __cplusplus

#define RENODX_TONE_MAP_TYPE    1.f
#define COLOR_GRADE_LUT_SCALING 1.f
#define RENODX_GAMMA_CORRECTION 1.f

#define CUSTOM_NOISE             0.f
#define CUSTOM_LUT_STRENGTH      1.f
#define CUSTOM_LUT_SCALING       1.f
#define CUSTOM_SHARPENING        2.f  // 0 - off, 1 - vanilla, 2 - Lilium RCAS
#define HUE_SHIFT_FIRE           0.f  // experimental, re7/8 shaders not collected yet
#define RENODX_TONE_MAP_DECHROMA 0.f

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_RE7_RE2R_RE3R_REVILLAGE_SHARED_H_
