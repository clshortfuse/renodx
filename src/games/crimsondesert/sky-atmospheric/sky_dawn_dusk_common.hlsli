#ifndef SRC_CRIMSONDESERT_SKY_ATMOSPHERIC_SKY_DAWN_DUSK_COMMON_HLSLI_
#define SRC_CRIMSONDESERT_SKY_ATMOSPHERIC_SKY_DAWN_DUSK_COMMON_HLSLI_

#include "../shared.h"

// --- Dawn/dusk activation factor ---

float DawnDuskFactor(float sunElevation) {
  if (DAWN_DUSK_IMPROVEMENTS == 0.f) return 0.f;

  float rise = smoothstep(-0.17f, 0.0f, sunElevation);
  float fall = 1.f - smoothstep(0.087f, 0.26f, sunElevation);
  return rise * fall;
}

// --- Mie phase boost ---

float MiePhaseBoostedG(float baseG, float dawnDuskFactor) {
  if (dawnDuskFactor == 0.f) return baseG;

  float boostStrength = 0.45f;
  float maxG = 0.98f;
  float boostedG = lerp(baseG, maxG, dawnDuskFactor * boostStrength);
  return min(boostedG, maxG);
}

// --- Inscatter colour bias ---
// Base game's scattering on the east and west looks very similar
// This adds some hue differences at the horizon for better
// distinction between the two
//
// Hues are picked from the spectral Rayleigh we added

float3 InscatterColorBias(float viewSunDot, float dawnDuskFactor,
                          float3 extinctionRGB) {
  if (dawnDuskFactor == 0.f) return 1.f;

  float t = mad(viewSunDot, 0.5f, 0.5f);
  float3 warm = float3(1.044f, 1.000f, 0.965f);
  float3 cool = float3(0.958f, 1.000f, 1.035f);
  float3 tint = lerp(cool, warm, t);
  float strength = 0.15f;
  return lerp(1.f, tint, dawnDuskFactor * strength);
}


// --- SH L1 directional bias ---
// Taken from CP2077
//
// Adds directional bias into the L1 SH band along the sun direction,
// scaled by L0 so it tracks overall sky brightness

void SHDirectionalBias(float3 sunDir, float dawnDuskFactor, float3 L0,
                       out float3 biasR, out float3 biasG, out float3 biasB) {
  if (dawnDuskFactor == 0.f) {
    biasR = 0.f; biasG = 0.f; biasB = 0.f;
    return;
  }

  float shScale = 0.3253f;

  float elevBlend = saturate(sunDir.y * 4.f);
  float warmR = lerp(1.15f, 1.05f, elevBlend);
  float warmG = lerp(1.02f, 1.00f, elevBlend);
  float warmB = lerp(0.85f, 0.95f, elevBlend);

  float biasStrength = 0.35f;
  float magR = L0.x * biasStrength * dawnDuskFactor * warmR * shScale;
  float magG = L0.y * biasStrength * dawnDuskFactor * warmG * shScale;
  float magB = L0.z * biasStrength * dawnDuskFactor * warmB * shScale;

  biasR = sunDir * magR;
  biasG = sunDir * magG;
  biasB = sunDir * magB;
}

// --- Dawn/dusk GI ambient boost ---
// Restored directional contrast downstream to ambient since the sky probe 
// suffers from an issue of being both low res and the inscatter gets heavily 
// averaged at mip 4. Not that big of a deal with direct lighting from the sun
// or moon but during dawn/dusk its rip creating flat GI

float3 DawnDuskAmbientBoost(float3 ambientRGB, float3 surfaceNormal,
                            float3 sunDir, float dawnDuskFactor,
                            float3 shL0) {
  if (dawnDuskFactor == 0.f) return ambientRGB;

  float nDotSun = dot(surfaceNormal, sunDir);
  float sunFacing = mad(nDotSun, 0.5f, 0.5f);

  float3 warm = float3(1.06f, 1.00f, 0.94f);
  float3 cool = float3(0.94f, 1.00f, 1.06f);
  float3 tint = lerp(cool, warm, sunFacing);

  float directionalMul = lerp(0.7f, 1.3f, sunFacing);

  float boostStrength = 2.0f;
  float3 directionalAmbient = ambientRGB * directionalMul * tint;
  float3 boosted = lerp(ambientRGB, directionalAmbient, dawnDuskFactor * boostStrength);

  // --- Energy floor ---
  // Use luminance of L0 as a neutral reference so the floor doesnt inherit
  // the sky colour bias
  //
  // Had an issue where tent interiors became way to red otherwise

  float shL0Lum = renodx::color::y::from::BT709(shL0);
  float floorFraction = 0.15f;
  float3 floorRGB = shL0Lum * floorFraction * dawnDuskFactor;

  boosted = max(boosted, floorRGB);

  return boosted;
}

#endif  // SRC_CRIMSONDESERT_SKY_ATMOSPHERIC_SKY_DAWN_DUSK_COMMON_HLSLI_