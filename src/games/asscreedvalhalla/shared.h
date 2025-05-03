#ifndef SRC_ASSCREEDVALHALLA_SHARED_H_
#define SRC_ASSCREEDVALHALLA_SHARED_H_

#define RENODX_UI_MODE               0u  // 1u = per pixel BT.2020 PQ Conversion
#define RENODX_GRAPHICS_WHITE_NITS   203.f
#define RENODX_TONE_MAP_TYPE         2u
#define RENODX_GAME_GAMMA_CORRECTION 1u
#define HUE_CORRECTION               1u

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ASSCREEDVALHALLA_SHARED_H_
