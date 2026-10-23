#ifndef SRC_GAMES_RDR2_OUTPUT_BRIGHTNESS_GLSL_
#define SRC_GAMES_RDR2_OUTPUT_BRIGHTNESS_GLSL_

#include "../common.glsl"

vec3 ScaleSceneBrightness(vec3 color) {
  if (CUSTOM_IS_SWAPCHAIN_WRITE == 0.f
      || RENODX_DIFFUSE_WHITE_NITS == RENODX_GRAPHICS_WHITE_NITS) return color;

  // Normalize only the final scene write; subsequent UI remains relative to UI white.
  if (RENODX_SDR_EOTF_EMULATION != 0.f) {
    vec3 linear_color = pow(abs(color), vec3(2.2));
    linear_color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    return sign(color) * pow(linear_color, vec3(1.0 / 2.2));
  } else {
    vec3 linear_color = SRGBDecodeSafe(color);
    linear_color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    return SRGBEncodeSafe(linear_color);
  }
}

#endif  // SRC_GAMES_RDR2_OUTPUT_BRIGHTNESS_GLSL_