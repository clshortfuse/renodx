#ifndef RENODX_SHADERS_COLOR_GAMMA_HLSL
#define RENODX_SHADERS_COLOR_GAMMA_HLSL

#include "../math.hlsl"

namespace renodx {
namespace color {
namespace gamma {

#define ENCODE(T)                     \
  T Encode(T c, float gamma = 2.2f) { \
    return pow(c, 1.f / gamma);       \
  }

ENCODE(float)
ENCODE(float2)
ENCODE(float3)

#define ENCODE_SAFE(T)                            \
  T EncodeSafe(T c, float gamma = 2.2f) {         \
    return renodx::math::SignPow(c, 1.f / gamma); \
  }

ENCODE_SAFE(float)
ENCODE_SAFE(float2)
ENCODE_SAFE(float3)

#define DECODE(T)                     \
  T Decode(T c, float gamma = 2.2f) { \
    return pow(c, gamma);             \
  }

DECODE(float)
DECODE(float2)
DECODE(float3)

#define DECODE_SAFE(T)                      \
  T DecodeSafe(T c, float gamma = 2.2f) {   \
    return renodx::math::SignPow(c, gamma); \
  }

DECODE_SAFE(float)
DECODE_SAFE(float2)
DECODE_SAFE(float3)

#undef ENCODE
#undef ENCODE_SAFE
#undef DECODE
#undef DECODE_SAFE

}  // namespace gamma
}  // namespace color
}  // namespace renodx

#endif  // RENODX_SHADERS_COLOR_GAMMA_HLSL