#include "./include/ToneMapCB.hlsl"
#include "./shared.h"

float OverrideGamma() {
  [branch]
  if (RENODX_GAMMA_ADJUST_TYPE) {
    return RENODX_GAMMA_ADJUST_VALUE;
  } else {
    return ToneMapCBuffer_m0[3u].w * RENODX_GAMMA_ADJUST_VALUE;
  }
}

static float m_HdrGamma = OverrideGamma();
