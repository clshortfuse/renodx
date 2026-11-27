#ifndef SRC_GAMES_GUARDIANSOFTHEGALAXY_ACES_SDR_HLSLI_
#define SRC_GAMES_GUARDIANSOFTHEGALAXY_ACES_SDR_HLSLI_

// Game-exact ACES 1.0 SDR path (segmented spline c5 RRT + c9 ODT).
// Requires SDisplayMappingConstants to be declared before inclusion.

#include "../../shaders/tonemap/aces.hlsl"

static const float3x3 GAME_ACES_SPLINE_MAT = {
    0.5f, -1.f, 0.5f,
    -1.f, 1.f, 0.5f,
    0.5f, 0.f, 0.f};

float GameAcesC5(float x) {
  static const float C5_LOW[6] = {-4.f, -4.f, -3.1573765773f, -0.4852499958f, 1.8477324706f, 1.8477324706f};
  static const float C5_HIGH[6] = {-0.7185482425f, 2.0810307172f, 3.6681241237f, 4.f, 4.f, 4.f};
  const float lx = log10(max(x, 6.10352e-5f));
  const float lmin = log10(0.18f * exp2(-15.f));
  const float lmid = log10(0.18f);
  const float lmax = log10(0.18f * exp2(18.f));
  float ly;
  if (lx <= lmin) {
    ly = log10(1e-4f);  // slope 0: flat extension
  } else if (lx < lmid) {
    const float kc = 3.f * (lx - lmin) / (lmid - lmin);
    const int j = (int)kc;
    const float t = kc - j;
    ly = dot(float3(t * t, t, 1.f), mul(float3(C5_LOW[j], C5_LOW[j + 1], C5_LOW[j + 2]), GAME_ACES_SPLINE_MAT));
  } else if (lx < lmax) {
    const float kc = 3.f * (lx - lmid) / (lmax - lmid);
    const int j = (int)kc;
    const float t = kc - j;
    ly = dot(float3(t * t, t, 1.f), mul(float3(C5_HIGH[j], C5_HIGH[j + 1], C5_HIGH[j + 2]), GAME_ACES_SPLINE_MAT));
  } else {
    ly = log10(1e4f);  // slope 0: flat extension
  }
  return pow(10.f, ly);
}

float GameAcesC9(float x, SDisplayMappingConstants k) {
  const float lx = log10(max(x, 6.10352e-5f));
  const float lmin = log10(k.vMinPoint.x);
  const float lmid = log10(k.vMidPoint.x);
  const float lmax = log10(k.vMaxPoint.x);
  float ly;
  if (lx <= lmin) {
    ly = lx * k.vSlope.x + (log10(k.vMinPoint.y) - k.vSlope.x * lmin);
  } else if (lx < lmid) {
    const float kc = 7.f * (lx - lmin) / (lmid - lmin);
    const int j = (int)kc;
    const float t = kc - j;
    ly = dot(float3(t * t, t, 1.f), mul(float3(k.vCoefs[j].x, k.vCoefs[j + 1].x, k.vCoefs[j + 2].x), GAME_ACES_SPLINE_MAT));
  } else if (lx < lmax) {
    const float kc = 7.f * (lx - lmid) / (lmax - lmid);
    const int j = (int)kc;
    const float t = kc - j;
    ly = dot(float3(t * t, t, 1.f), mul(float3(k.vCoefs[j].y, k.vCoefs[j + 1].y, k.vCoefs[j + 2].y), GAME_ACES_SPLINE_MAT));
  } else {
    ly = lx * k.vSlope.y + (log10(k.vMaxPoint.y) - k.vSlope.y * lmax);
  }
  return pow(10.f, ly);
}

// The graded scene is ACEScg (AP1): ColorGrading converts BT.709 to AP1 before the display LUT.
float3 GameAcesRRT(float3 scene) {
  return renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, scene));
}

float3 GameAcesODT(float3 rgb_pre, SDisplayMappingConstants k) {
  float3 y;
  [unroll] for (int i = 0; i < 3; i++) {
    y[i] = GameAcesC9(GameAcesC5(rgb_pre[i]), k);
  }
  float3 lin = (y - k.vMinPoint.y) / (k.vMaxPoint.y - k.vMinPoint.y);
  lin = mul(renodx::color::XYZ_TO_AP1_MAT, renodx::tonemap::aces::DarkToDim(mul(renodx::color::AP1_TO_XYZ_MAT, lin)));
  lin = mul(renodx::tonemap::aces::ODT_SAT_MAT, lin);
  return saturate(mul(renodx::color::AP1_TO_BT709_MAT, lin));
}

#endif  // SRC_GAMES_GUARDIANSOFTHEGALAXY_ACES_SDR_HLSLI_
