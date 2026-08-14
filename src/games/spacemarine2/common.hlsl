#ifndef SRC_SPACE_MARINE_2_COMMON_H_
#define SRC_SPACE_MARINE_2_COMMON_H_
#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f; // 50%
static const float DEFAULT_CONTRAST = 1.f;   // 50%
static const float DEFAULT_GAMMA = 1.f;

float3 LutToneMap(float3 untonemapped, float3 lutOutput) {
  float3 final = renodx::color::srgb::DecodeSafe(lutOutput);

  if (RENODX_TONE_MAP_TYPE) {
    final = renodx::draw::ToneMapPass(untonemapped.rgb, final);
  }

  return final;
}

#endif // SRC_SPACE_MARINE_2_COMMON_H_