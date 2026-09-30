#include "../common.hlsli"

float ConditionalOverrideUIBrightness(float original_brightness, int hdr_enabled) {
  return (hdr_enabled == 0 || TONE_MAP_TYPE == 0.f)
             ? original_brightness
             : shader_injection.graphics_white_nits / 80.f;
}
