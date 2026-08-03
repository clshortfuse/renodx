#ifndef SRC_THECALLISTOPROTOCOL_SHARED_H_
#define SRC_THECALLISTOPROTOCOL_SHARED_H_

#define RENODX_TONE_MAP_TYPE       1.f
#define RENODX_PEAK_WHITE_NITS     400.f
#define RENODX_DIFFUSE_WHITE_NITS  100.f
#define RENODX_GRAPHICS_WHITE_NITS 100.f

#define RENODX_GAMMA_CORRECTION    1.f
#define RENODX_GAMMA_CORRECTION_UI 1.f

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

#ifndef __cplusplus

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_THECALLISTOPROTOCOL_SHARED_H_