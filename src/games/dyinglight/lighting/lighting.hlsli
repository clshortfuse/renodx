#include "../shared.h"

float3 ApplyCustomClampSpecular(float3 unclamped_color) {
  if (CUSTOM_UNCLAMP_LIGHTING == 0) return saturate(unclamped_color);

  unclamped_color = max(0, unclamped_color);

  float3 clamped_color = unclamped_color;
#if 1
  clamped_color = renodx::tonemap::ExponentialRollOff(unclamped_color, 1.f, 10.f);
#else
  clamped_color = min(10.f, clamped_color);
#endif

  return clamped_color;
}

float ApplyCustomClampWaterSpecular(float unclamped_value) {
  if (CUSTOM_UNCLAMP_LIGHTING == 0) return saturate(unclamped_value);

  unclamped_value = max(0, unclamped_value);

  float clamped_value = unclamped_value;
#if 1
  clamped_value = renodx::tonemap::ExponentialRollOff(clamped_value, 1.f, 10.f);
#else
  clamped_value = min(10.f, clamped_value);
#endif

  return clamped_value;
}

float ApplyCustomClampFire(float unclamped_value) {
  if (CUSTOM_UNCLAMP_LIGHTING == 0) return saturate(unclamped_value);

  unclamped_value = max(0, unclamped_value);

  float clamped_value = unclamped_value;
#if 0
  clamped_value = min(100.f, unclamped_value);
  clamped_value = renodx::tonemap::ExponentialRollOff(unclamped_value, 1.f, 5.f);
#else
  clamped_value = min(5.f, clamped_value);
#endif

  return clamped_value;
}
