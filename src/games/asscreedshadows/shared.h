#ifndef SRC_ASSCREEDSHADOWS_SHARED_H_
#define SRC_ASSCREEDSHADOWS_SHARED_H_

#define RENODX_UI_MODE               0u  // 1u = per pixel BT.2020 PQ Conversion
#define RENODX_GRAPHICS_WHITE_NITS   203.f
#define RENODX_TONE_MAP_TYPE         2u
#define RENODX_GAME_GAMMA_CORRECTION 0u
#define CUSTOM_LOCAL_TONEMAPPING     1u

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float graphics_white_nits;
};

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_ASSCREEDSHADOWS_SHARED_H_
