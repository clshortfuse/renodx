#ifndef RENODX_SHADERS_COLOR_SRGB_HLSL
#define RENODX_SHADERS_COLOR_SRGB_HLSL

#include "../math.hlsl"

namespace renodx {
namespace color {
namespace srgb {
static const float REFERENCE_WHITE = 80.f;

#define ENCODE(T)                                  \
  T Encode(T c) {                                  \
    return renodx::math::Select(                   \
        c <= 0.0031308f,                           \
        c * 12.92f,                                \
        mad(1.055f, pow(c, 1.f / 2.4f), -0.055f)); \
  }

ENCODE(float)
ENCODE(float2)
ENCODE(float3)

float4 Encode(float4 color) {
  return float4(Encode(color.rgb), color.a);
}

#define ENCODE_SAFE(T)                                \
  T EncodeSafe(T c) {                                 \
    return renodx::math::CopySign(Encode(abs(c)), c); \
  }

ENCODE_SAFE(float)
ENCODE_SAFE(float2)
ENCODE_SAFE(float3)

float4 EncodeSafe(float4 color) {
  return float4(EncodeSafe(color.rgb), color.a);
}

#define DECODE(T)                                          \
  T Decode(T c) {                                          \
    return renodx::math::Select(                           \
        c <= 0.04045f,                                     \
        c / 12.92f,                                        \
        pow(mad(c, 1.f / 1.055f, 0.055f / 1.055f), 2.4f)); \
  }

DECODE(float)
DECODE(float2)
DECODE(float3)

float4 Decode(float4 color) {
  return float4(Decode(color.rgb), color.a);
}

#define DECODE_SAFE(T)                                \
  T DecodeSafe(T c) {                                 \
    return renodx::math::CopySign(Decode(abs(c)), c); \
  }

DECODE_SAFE(float)
DECODE_SAFE(float2)
DECODE_SAFE(float3)

float4 DecodeSafe(float4 color) {
  return float4(DecodeSafe(color.rgb), color.a);
}

#undef ENCODE
#undef ENCODE_SAFE
#undef DECODE
#undef DECODE_SAFE

}  // namespace srgb

namespace srgba {

float4 Encode(float4 color) {
  return renodx::math::Select(
      color <= 0.0031308f,
      color * 12.92f,
      mad(1.055f, pow(color, 1.f / 2.4f), -0.055f));
}

float4 Decode(float4 color) {
  return renodx::math::Select(
      color <= 0.04045f,
      color / 12.92f,
      pow(mad(color, 1.f / 1.055f, 0.055f / 1.055f), 2.4f));
}

float4 EncodeSafe(float4 color) {
  return renodx::math::CopySign(Encode(abs(color)), color);
}

float4 DecodeSafe(float4 color) {
  return renodx::math::CopySign(Decode(abs(color)), color);
}

}  // namespace srgba
}  // namespace color
}  // namespace renodx

#endif  // RENODX_SHADERS_COLOR_SRGB_HLSL