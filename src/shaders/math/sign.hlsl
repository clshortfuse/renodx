#ifndef SRC_SHADERS_MATH_SIGN_HLSL_
#define SRC_SHADERS_MATH_SIGN_HLSL_

#include "./constants.hlsl"
#include "./cross.hlsl"
#include "./select.hlsl"

START_NAMESPACE(renodx)
START_NAMESPACE(math)

// CopySign

#if __SHADER_TARGET_MAJOR <= 3
#define SELECT_FUNCTION_GENERATOR(TYPE)          \
  TYPE CopySign(TYPE mag, TYPE sgn) {            \
    return Select(sgn < 0, -abs(mag), abs(mag)); \
  }
SELECT_FUNCTION_GENERATOR(float)
SELECT_FUNCTION_GENERATOR(float2)
SELECT_FUNCTION_GENERATOR(float3)
SELECT_FUNCTION_GENERATOR(float4)
#undef SELECT_FUNCTION_GENERATOR
#else
float CopySign(float mag, float sgn) {
  uint sign_bits = asuint(sgn) & 0x80000000u;
  uint mag_bits = asuint(mag) & 0x7FFFFFFFu;
  return asfloat(sign_bits | mag_bits);
}

#define COPYSIGN_FUNCTION_GENERATOR_VECTOR(SIZE)           \
  float##SIZE CopySign(float##SIZE mag, float##SIZE sgn) { \
    uint##SIZE sign_bits = asuint(sgn) & 0x80000000u;      \
    uint##SIZE mag_bits = asuint(mag) & 0x7FFFFFFFu;       \
    float##SIZE result = asfloat(sign_bits | mag_bits);    \
    return result;                                         \
  }

COPYSIGN_FUNCTION_GENERATOR_VECTOR(2)
COPYSIGN_FUNCTION_GENERATOR_VECTOR(3)
COPYSIGN_FUNCTION_GENERATOR_VECTOR(4)
#undef COPYSIGN_FUNCTION_GENERATOR_VECTOR
#endif

#define SIGNPOW_FUNCTION_GENERATOR(T)          \
  T SignPow(T x, float exponent) {             \
    return CopySign(pow(abs(x), exponent), x); \
  }
SIGNPOW_FUNCTION_GENERATOR(float)
SIGNPOW_FUNCTION_GENERATOR(float2)
SIGNPOW_FUNCTION_GENERATOR(float3)
SIGNPOW_FUNCTION_GENERATOR(float4)
#undef SIGNPOW_FUNCTION_GENERATOR

#define SIGNSQRT_FUNCTION_GENERATOR(T) \
  T SignSqrt(T x) {                    \
    return CopySign(sqrt(abs(x)), x);  \
  }
SIGNSQRT_FUNCTION_GENERATOR(float)
SIGNSQRT_FUNCTION_GENERATOR(float2)
SIGNSQRT_FUNCTION_GENERATOR(float3)
SIGNSQRT_FUNCTION_GENERATOR(float4)
#undef SIGNSQRT_FUNCTION_GENERATOR

#define CBRT_FUNCTION_GENERATOR(T) \
  T Cbrt(T x) {                    \
    return SignPow(x, 1.f / 3.f);  \
  }
CBRT_FUNCTION_GENERATOR(float)
CBRT_FUNCTION_GENERATOR(float2)
CBRT_FUNCTION_GENERATOR(float3)
CBRT_FUNCTION_GENERATOR(float4)
#undef CBRT_FUNCTION_GENERATOR

#if __SHADER_TARGET_MAJOR >= 6 || defined(VULKAN)
#define SIGN_FUNCTION_GENERATOR(T) \
  T Sign(T x) {                    \
    return sign(x);                \
  }
#else
#define SIGN_FUNCTION_GENERATOR(T)                          \
  T Sign(T x) {                                             \
    return mad(saturate(mad(x, FLT_MAX, 0.5f)), 2.f, -1.f); \
  }
#endif

SIGN_FUNCTION_GENERATOR(float)
SIGN_FUNCTION_GENERATOR(float2)
SIGN_FUNCTION_GENERATOR(float3)
SIGN_FUNCTION_GENERATOR(float4)
#undef SIGN_FUNCTION_GENERATOR

END_NAMESPACE(math)
END_NAMESPACE(renodx)
#endif  // SRC_SHADERS_MATH_SIGN_HLSL_