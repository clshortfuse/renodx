#include "./shared.h"

float4 ApplyUIBrightness(float4 color) {
  // Foreground and backing sprites share this RGB gain and retain their coverage.
  color.rgb *= pow(shader_injection.graphics_white_nits / RENODX_GRAPHICS_WHITE_NITS, 1.f / 2.2f);
  return color;
}
