#include "shared.h"

const static float NIGHT_LUMINANCE = renodx::math::FLT32_MIN;
const static float DAY_LUMINANCE = 2.5f;
const static float NIGHT_EXPOSURE = 1.85f;  // Keep dark scenes well-lit
const static float DAY_EXPOSURE = 0.35f;    // Reduce bright scenes more (adjust to taste)

// Adaptive exposure based on scene luminance
// Higher luminance (bright scenes) = more exposure reduction
// Lower luminance (dark scenes) = less exposure reduction
// Luminance range: Night=0.009, Day=2.0

/* float CalculateExposure(float luminance) {
  if (!RENODX_TONE_MAP_TYPE) return 1.f;
  // For bright scenes (high luminance), we want low exposure
  // For dark scenes (low luminance), we want high exposure

  // Create smooth curve based on luminance
  float t = saturate((luminance - NIGHT_LUMINANCE) / (DAY_LUMINANCE - NIGHT_LUMINANCE));

  // Use smoothstep for natural transition
  float smoothT = smoothstep(0.0, 1.0, t);

  // Interpolate between night and day exposure
  return lerp(NIGHT_EXPOSURE, DAY_EXPOSURE, smoothT);
} */
float CalculateExposure(float luminance, float power = 1.f) {
  if (!RENODX_TONE_MAP_TYPE) return 1.f;
  // power controls how quickly exposure falls off:
  // power = 0.5: gentle falloff
  // power = 1.0: linear inverse
  // power = 2.0: aggressive falloff

  return renodx::math::PowSafe(1.0 / (1.0 + luminance), power);
}
