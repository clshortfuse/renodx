#include "../../shared.h"

cbuffer cb0_buf : register(b0) {
  uint4 cb0_m[69] : packoffset(c0);
};

static const float FilmBlackClip = asfloat(cb0_m[36u].w);
static const float FilmToe = asfloat(cb0_m[36u].y);
static const float FilmShoulder = asfloat(cb0_m[36u].z);
static const float FilmSlope = asfloat(cb0_m[36u].x);
static const float FilmWhiteClip = asfloat(cb0_m[37u].x);
static const float ToneCurveAmount = asfloat(cb0_m[66u].z);
static const float BlueCorrection = asfloat(cb0_m[66u].x);

static uint output_device = uint(cb0_m[65u].z);
static uint output_gamut = uint(cb0_m[65u].w);
static float expand_gamut = asfloat(cb0_m[66u].y);
static bool is_hdr = (output_device >= 3u) && (output_gamut <= 6u);

void ApplyLUTOutputOverrides() {
  if (RENODX_TONE_MAP_TYPE != 0.f && is_hdr) {
    output_device = 0u;
    output_gamut = 0u;
    expand_gamut = 0.f;
  }
}
