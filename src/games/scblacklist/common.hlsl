#include "./shared.h"

//-----TONEMAP-----//
float3 toneMap(float3 color) {
  const float peakWhite = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (peakWhite <= 1.f) return saturate(color);
  const float rolloff_start = 1.f;
  return renodx::tonemap::ExponentialRollOff(color, rolloff_start, peakWhite);
}

//-----SCALING-----//
float3 FinalizeOutput(float3 color) {
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color = renodx::color::bt709::clamp::BT2020(color);

  if (RENODX_TONE_MAP_TYPE == 2.f) {
    color = toneMap(color);
  } else if (RENODX_TONE_MAP_TYPE == 0.f) {
    color = saturate(color);
  }

  color *= RENODX_DIFFUSE_WHITE_NITS / 80.f;
  return color;
}
