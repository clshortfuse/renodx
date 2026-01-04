#include "../../shared.h"

cbuffer cb0 : register(b0) {
  float4 cb0[42];
}

static const float FilmBlackClip = asfloat(cb0[38].x);
static const float FilmToe = asfloat(cb0[37].z);
static const float FilmShoulder = asfloat(cb0[37].w);
static const float FilmSlope = asfloat(cb0[37].y);
static const float FilmWhiteClip = asfloat(cb0[38].y);
static const float ToneCurveAmount = asfloat(cb0[37].x);
static const float BlueCorrection = asfloat(cb0[36].z);

static uint output_device = asuint(cb0[40].w);
static uint output_gamut = asuint(cb0[41].x);
static float expand_gamut = asfloat(cb0[36].w);
static bool is_hdr = (output_device >= 3u) && (output_gamut <= 6u);

static float4 LUTWeights[1] = { float4(cb0[5].x, cb0[5].y, cb0[5].z, 0.0f) };
