#include "../common.hlsli"

float SetMaxLuminance(float MaxLuminance) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return RENODX_PEAK_WHITE_NITS;
  } else {
    return MaxLuminance;
  }
}