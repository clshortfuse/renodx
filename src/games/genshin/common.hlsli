#ifndef SRC_GAMES_GENSHIN_COMMON_HLSLI_
#define SRC_GAMES_GENSHIN_COMMON_HLSLI_

#include "./shared.h"

// Vanilla SDR tone curve, shared by the SDR uberpost path (applied, then
// clipped) and the HDR LUT builder (applied per channel for hue/saturation).
float3 VanillaToneMap(float3 x) {
  return saturate((x * (1.36f * x + 0.047f)) / (x * (0.93f * x + 0.56f) + 0.14f));
}

#endif  // SRC_GAMES_GENSHIN_COMMON_HLSLI_
