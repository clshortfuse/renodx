#ifndef SRC_GAMES_RDR2_COMMON_GLSL_
#define SRC_GAMES_RDR2_COMMON_GLSL_

#include "./shared.h"

float DivideSafe(float dividend, float divisor, float fallback) {
  return divisor == 0.0 ? fallback : dividend / divisor;
}

float DivideSafe(float dividend, float divisor) {
  float fallback = uintBitsToFloat((floatBitsToUint(dividend) & 0x80000000u) | 0x7f7fffffu);
  return DivideSafe(dividend, divisor, fallback);
}

vec3 DivideSafe(vec3 dividend, vec3 divisor) {
  return vec3(
      DivideSafe(dividend.x, divisor.x),
      DivideSafe(dividend.y, divisor.y),
      DivideSafe(dividend.z, divisor.z));
}

vec3 SRGBDecode(vec3 color) {
  return mix(pow((color + 0.055) / 1.055, vec3(2.4)), color / 12.92, lessThanEqual(color, vec3(0.04045)));
}

vec3 SRGBDecodeSafe(vec3 color) {
  return sign(color) * SRGBDecode(abs(color));
}

vec3 SRGBEncode(vec3 color) {
  return mix(1.055 * pow(max(color, vec3(0.0)), vec3(1.0 / 2.4)) - 0.055,
             color * 12.92, lessThanEqual(color, vec3(0.0031308)));
}

vec3 SRGBEncodeSafe(vec3 color) {
  return sign(color) * SRGBEncode(abs(color));
}

// These conversions expect linear RGB, not sRGB-encoded values.
vec3 BT709ToBT2020(vec3 color) {
  return color * mat3(vec3(0.627403896, 0.329283038, 0.043313066), vec3(0.069097289, 0.919540395, 0.011362316), vec3(0.016391439, 0.088013308, 0.895595253));
}

vec3 BT2020ToBT709(vec3 color) {
  return color * mat3(vec3(1.660491002, -0.587641139, -0.072849863), vec3(-0.124550475, 1.132899897, -0.008349423), vec3(-0.018150763, -0.100578898, 1.118729661));
}

#endif
