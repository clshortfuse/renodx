#include "../common.glsl"

vec3 ClampMaxChannel(vec3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f && RENODX_TONE_MAP_TYPE != 1.f && CLAMP_PEAK != 0.f) {
    float peak = RENODX_PEAK_WHITE_NITS;
    float max_channel = max(max(max(color.r, color.g), color.b), peak);
    color *= peak / max_channel;  // Clamp overshoot
  }
  return color;
}

vec3 PQEncodeUI(vec3 x) {
  x *= vec3(RENODX_GRAPHICS_WHITE_NITS);
  x = ClampMaxChannel(x);
  return EncodePQ(max(vec3(0.0), x), 1.f);
}

vec3 PQEncodeGame(vec3 x) {
  x *= vec3(RENODX_DIFFUSE_WHITE_NITS);
  x = ClampMaxChannel(x);
  return EncodePQ(max(vec3(0.0), x), 1.f);
}

