#include "../shared.h"

float3 ApplyReinhardPiecewiseByLuminance(float3 color, float peak_white = 1.f, float shoulder = 0.0001f) {
  float y_in = renodx::color::y::from::BT709(color);
  float y_out = renodx::tonemap::ReinhardPiecewise(y_in, peak_white, shoulder);
  color = renodx::color::correct::Luminance(color, y_in, y_out);

  return color;
}

float3 ApplyCustomClampSpecular(float3 unclamped_color) {
  if (CUSTOM_UNCLAMP_LIGHTING == 0) return saturate(unclamped_color);

  unclamped_color = max(0, unclamped_color);

  float3 clamped_color = unclamped_color;
#if TONE_MAP_LIGHTING
  clamped_color = ApplyReinhardPiecewiseByLuminance(unclamped_color, 10.f, 1.f);
#else
  clamped_color = min(clamped_color, 100.f);
#endif

  return clamped_color;
}

float ApplyCustomClampWaterSpecular(float unclamped_value) {
  if (CUSTOM_UNCLAMP_LIGHTING == 0) return saturate(unclamped_value);

  unclamped_value = max(0, unclamped_value);

  float clamped_value = unclamped_value;
#if TONE_MAP_LIGHTING
  clamped_value = renodx::tonemap::ReinhardPiecewise(unclamped_value, 10.f, 1.f);
#else
  clamped_value = min(clamped_value, 100.f);
#endif

  return clamped_value;
}

float ApplyCustomClampFire(float unclamped_value) {
  if (CUSTOM_UNCLAMP_LIGHTING == 0) return saturate(unclamped_value);

  unclamped_value = max(0, unclamped_value);

  float clamped_value = unclamped_value;
#if TONE_MAP_LIGHTING
  clamped_value = renodx::tonemap::ReinhardPiecewise(unclamped_value, 10.f, 1.f);
#else
  clamped_value = min(clamped_value, 100.f);
#endif

  return clamped_value;
}

float3 ApplyCustomHueShiftFire(float3 color) {
  if (CUSTOM_HUE_SHIFT_FIRE) {
    color = renodx::color::correct::Hue(color, renodx::tonemap::ReinhardPiecewise(color, 5.f, 1.f), 0.9f);
    color = max(0, color);
  }
  return color;
}

float ApplyCustomAutoExposureClamp(float unclamped_value) {
  float clamped_value = unclamped_value;

  if (CUSTOM_CLAMP_AUTOEXPOSURE != 0.f) {
    clamped_value = renodx::tonemap::ReinhardPiecewise(clamped_value, 10.f, 4.f);
  }

  return clamped_value;
}

float3 ToneMapBrightPass(float3 color) {
  if (CUSTOM_UNCLAMP_LIGHTING) {
    color = ApplyReinhardPiecewiseByLuminance(color, 8.f, 1.f);
  }
  return color;
}
