#ifndef SRC_SHADERS_MATH_SIGN_HLSL_
#define SRC_SHADERS_MATH_SIGN_HLSL_

#include "./constants.hlsl"
#include "./cross.hlsl"
#include "./select.hlsl"

START_NAMESPACE(renodx)
START_NAMESPACE(math)

static const uint FLT32_SIGN = 0x80000000u;       // 0b10000000000000000000000000000000
static const uint FLT32_MAGNITUDE = 0x7FFFFFFFu;  // 0b01111111111111111111111111111111

#if __SHADER_TARGET_MAJOR <= 3
#define SELECT_FUNCTION_GENERATOR(TYPE)            \
  TYPE CopySign(TYPE mag, TYPE sgn) {              \
    TYPE abs_value = abs(mag);                     \
    return Select(sgn < 0, -abs_value, abs_value); \
  }
SELECT_FUNCTION_GENERATOR(float)
SELECT_FUNCTION_GENERATOR(float2)
SELECT_FUNCTION_GENERATOR(float3)
SELECT_FUNCTION_GENERATOR(float4)
#undef SELECT_FUNCTION_GENERATOR
#else
float CopySign(float mag, float sgn) {
  uint sign_bits = asuint(sgn) & FLT32_SIGN;
  uint mag_bits = asuint(mag) & FLT32_MAGNITUDE;
  return asfloat(sign_bits | mag_bits);
}

#define COPYSIGN_FUNCTION_GENERATOR_VECTOR(SIZE)           \
  float##SIZE CopySign(float##SIZE mag, float##SIZE sgn) { \
    uint##SIZE sign_bits = asuint(sgn) & FLT32_SIGN;       \
    uint##SIZE mag_bits = asuint(mag) & FLT32_MAGNITUDE;   \
    float##SIZE result = asfloat(sign_bits | mag_bits);    \
    return result;                                         \
  }

COPYSIGN_FUNCTION_GENERATOR_VECTOR(2)
COPYSIGN_FUNCTION_GENERATOR_VECTOR(3)
COPYSIGN_FUNCTION_GENERATOR_VECTOR(4)
#undef COPYSIGN_FUNCTION_GENERATOR_VECTOR
#endif

// Half-precision CopySign
#if __SHADER_TARGET_MAJOR >= 6 && __SHADER_TARGET_MINOR >= 2

static const uint16_t FLT16_SIGN = 0x8000;       // 0b1000000000000000
static const uint16_t FLT16_MAGNITUDE = 0x7FFF;  // 0b0111111111111111

half CopySign(half mag, half sgn) {
  uint16_t sign_u = asuint16(sgn) & FLT16_SIGN;
  uint16_t mag_u = asuint16(mag) & FLT16_MAGNITUDE;
  return asfloat16(sign_u | mag_u);
}

half2 CopySign(half2 mag, half2 sgn) {
  uint16_t sign_x_u = asuint16(sgn.x) & FLT16_SIGN;
  uint16_t sign_y_u = asuint16(sgn.y) & FLT16_SIGN;

  uint16_t mag_x_u = asuint16(mag.x) & FLT16_MAGNITUDE;
  uint16_t mag_y_u = asuint16(mag.y) & FLT16_MAGNITUDE;

  return half2(
      asfloat16(sign_x_u | mag_x_u),
      asfloat16(sign_y_u | mag_y_u));
}

half3 CopySign(half3 mag, half3 sgn) {
  uint16_t sign_x_u = asuint16(sgn.x) & FLT16_SIGN;
  uint16_t sign_y_u = asuint16(sgn.y) & FLT16_SIGN;
  uint16_t sign_z_u = asuint16(sgn.z) & FLT16_SIGN;

  uint16_t mag_x_u = asuint16(mag.x) & FLT16_MAGNITUDE;
  uint16_t mag_y_u = asuint16(mag.y) & FLT16_MAGNITUDE;
  uint16_t mag_z_u = asuint16(mag.z) & FLT16_MAGNITUDE;

  return half3(
      asfloat16(sign_x_u | mag_x_u),
      asfloat16(sign_y_u | mag_y_u),
      asfloat16(sign_z_u | mag_z_u));
}

half4 CopySign(half4 mag, half4 sgn) {
  uint16_t sign_x_u = asuint16(sgn.x) & FLT16_SIGN;
  uint16_t sign_y_u = asuint16(sgn.y) & FLT16_SIGN;
  uint16_t sign_z_u = asuint16(sgn.z) & FLT16_SIGN;
  uint16_t sign_w_u = asuint16(sgn.w) & FLT16_SIGN;

  uint16_t mag_x_u = asuint16(mag.x) & FLT16_MAGNITUDE;
  uint16_t mag_y_u = asuint16(mag.y) & FLT16_MAGNITUDE;
  uint16_t mag_z_u = asuint16(mag.z) & FLT16_MAGNITUDE;
  uint16_t mag_w_u = asuint16(mag.w) & FLT16_MAGNITUDE;

  return half4(
      asfloat16(sign_x_u | mag_x_u),
      asfloat16(sign_y_u | mag_y_u),
      asfloat16(sign_z_u | mag_z_u),
      asfloat16(sign_w_u | mag_w_u));
}
#else
#define COPYSIGN_HALF_FUNCTION_GENERATOR(TYPE)     \
  TYPE CopySign(TYPE mag, TYPE sgn) {              \
    TYPE abs_value = abs(mag);                     \
    return Select(sgn < 0, -abs_value, abs_value); \
  }
COPYSIGN_HALF_FUNCTION_GENERATOR(half)
COPYSIGN_HALF_FUNCTION_GENERATOR(half2)
COPYSIGN_HALF_FUNCTION_GENERATOR(half3)
COPYSIGN_HALF_FUNCTION_GENERATOR(half4)
#undef COPYSIGN_HALF_FUNCTION_GENERATOR
#endif

#define SIGNPOW_FUNCTION_GENERATOR(T)          \
  T SignPow(T x, T exponent) {                 \
    return CopySign(pow(abs(x), exponent), x); \
  }
SIGNPOW_FUNCTION_GENERATOR(float)
SIGNPOW_FUNCTION_GENERATOR(float2)
SIGNPOW_FUNCTION_GENERATOR(float3)
SIGNPOW_FUNCTION_GENERATOR(float4)
SIGNPOW_FUNCTION_GENERATOR(half)
SIGNPOW_FUNCTION_GENERATOR(half2)
SIGNPOW_FUNCTION_GENERATOR(half3)
SIGNPOW_FUNCTION_GENERATOR(half4)
#undef SIGNPOW_FUNCTION_GENERATOR

#define SIGNSQRT_FUNCTION_GENERATOR(T) \
  T SignSqrt(T x) {                    \
    return CopySign(sqrt(abs(x)), x);  \
  }
SIGNSQRT_FUNCTION_GENERATOR(float)
SIGNSQRT_FUNCTION_GENERATOR(float2)
SIGNSQRT_FUNCTION_GENERATOR(float3)
SIGNSQRT_FUNCTION_GENERATOR(float4)
SIGNSQRT_FUNCTION_GENERATOR(half)
SIGNSQRT_FUNCTION_GENERATOR(half2)
SIGNSQRT_FUNCTION_GENERATOR(half3)
SIGNSQRT_FUNCTION_GENERATOR(half4)
#undef SIGNSQRT_FUNCTION_GENERATOR

#define CBRT_FUNCTION_GENERATOR_FLOAT(T) \
  T Cbrt(T x) {                          \
    return SignPow(x, 1.f / 3.f);        \
  }
#define CBRT_FUNCTION_GENERATOR_HALF(T) \
  T Cbrt(T x) {                         \
    return SignPow(x, 1.h / 3.h);       \
  }
CBRT_FUNCTION_GENERATOR_FLOAT(float)
CBRT_FUNCTION_GENERATOR_FLOAT(float2)
CBRT_FUNCTION_GENERATOR_FLOAT(float3)
CBRT_FUNCTION_GENERATOR_FLOAT(float4)
CBRT_FUNCTION_GENERATOR_HALF(half)
CBRT_FUNCTION_GENERATOR_HALF(half2)
CBRT_FUNCTION_GENERATOR_HALF(half3)
CBRT_FUNCTION_GENERATOR_HALF(half4)
#undef CBRT_FUNCTION_GENERATOR_HALF
#undef CBRT_FUNCTION_GENERATOR_FLOAT

// IEEE Float (0, +/-1, NaN) Sign function
#define SIGN_FUNCTION_GENERATOR(T) \
  T Sign(T x) {                    \
    return sign(x);                \
  }

SIGN_FUNCTION_GENERATOR(float)
SIGN_FUNCTION_GENERATOR(float2)
SIGN_FUNCTION_GENERATOR(float3)
SIGN_FUNCTION_GENERATOR(float4)
#undef SIGN_FUNCTION_GENERATOR

END_NAMESPACE(math)
END_NAMESPACE(renodx)
#endif  // SRC_SHADERS_MATH_SIGN_HLSL_