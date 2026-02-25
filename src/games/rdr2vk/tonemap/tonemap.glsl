#include "../common.glsl"

vec3 EncodeLUTInput(vec3 x, float _m11, float _m12, float _m13, float _m14, bool skip_encoding) {
  if (CUSTOM_LUT_ENCODING == 2.f) {  // sRGB
    return mix(
        x * 12.92,
        1.055 * pow(x, vec3(1.0 / 2.4)) - 0.055,
        step(vec3(0.0031308), x));
  } else if (CUSTOM_LUT_ENCODING == 1.f) {  // sRGB-like encoding (defaults to 2.2, controlled by the SDR gamma slider)
    return mix(
        (pow(x, vec3(_m12)) * _m13) - vec3(_m14),
        x * _m11,
        lessThan(x, vec3(0.0031308)));
  } else {  // vanilla (2.2 sRGB-like in SDR, none in HDR)
    return mix(
        mix(
            (pow(x, vec3(_m12)) * _m13) - vec3(_m14),
            x * _m11,
            lessThan(x, vec3(0.0031308))),
        x, bvec3(skip_encoding));
  }
}

vec3 DecodeLUTInput(vec3 x) {
  if (CUSTOM_LUT_ENCODING != 0.f) {  // sRGB
    return mix(
        x / 12.92,
        pow((x + 0.055) / 1.055, vec3(2.4)),
        step(vec3(0.04045), x));
  } else {
    return x;
  }
}
