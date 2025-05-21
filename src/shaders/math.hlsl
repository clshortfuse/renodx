#ifndef SRC_SHADERS_MATH_HLSL_
#define SRC_SHADERS_MATH_HLSL_

#include "./cross.hlsl"

START_NAMESPACE(renodx)
START_NAMESPACE(math)

static const float FLT10_MAX = 64512.f;
static const float FLT11_MAX = 65024.f;

static const float FLT16_MIN = CROSS_COMPILE(asfloat(0x0400), 0.00006103515625);
static const float FLT16_MAX = 65504.f;
static const float FLT32_MIN = CROSS_COMPILE(asfloat(0x00800000), 1.17549435082228750797e-38);
static const float FLT32_MAX = CROSS_COMPILE(asfloat(0x7F7FFFFF), 3.40282346638528859812e+38);
static const float FLT_MIN = FLT32_MIN;
static const float FLT_MAX = FLT32_MAX;
static const float INFINITY = CROSS_COMPILE(asfloat(0x7F800000), 1.0 / 0.0);
static const float NEG_INFINITY = CROSS_COMPILE(asfloat(0xFF800000), -1.0 / 0.0);

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

#define SIGNPOW_FUNCTION_GENERATOR(struct)                      \
  struct SignPow(struct x, float exponent) {                    \
    return Sign(x) * pow(abs(x), exponent); \
  }

SIGNPOW_FUNCTION_GENERATOR(float)
SIGNPOW_FUNCTION_GENERATOR(float2)
SIGNPOW_FUNCTION_GENERATOR(float3)
SIGNPOW_FUNCTION_GENERATOR(float4)
#undef SIGNPOW_FUNCTION_GENERATOR

#define SIGNSQRT_FUNCTION_GENERATOR(struct) \
  struct SignSqrt(struct x) {               \
    return Sign(x) * sqrt(abs(x));          \
  }

SIGNSQRT_FUNCTION_GENERATOR(float)
SIGNSQRT_FUNCTION_GENERATOR(float2)
SIGNSQRT_FUNCTION_GENERATOR(float3)
SIGNSQRT_FUNCTION_GENERATOR(float4)
#undef SIGNSQRT_FUNCTION_GENERATOR

#define CBRT_FUNCTION_GENERATOR(struct) \
  struct Cbrt(struct x) {               \
    return SignPow(x, 1.f / 3.f);       \
  }

CBRT_FUNCTION_GENERATOR(float)
CBRT_FUNCTION_GENERATOR(float2)
CBRT_FUNCTION_GENERATOR(float3)
CBRT_FUNCTION_GENERATOR(float4)
#undef CBRT_FUNCTION_GENERATOR

float Average(float3 color) {
  return (color.x + color.y + color.z) / 3.f;
}

float DivideSafe(float dividend, float divisor) {
  return (divisor == 0.f)
             ? FLT_MAX * Sign(dividend)
             : (dividend / divisor);
}

float DivideSafe(float dividend, float divisor, float fallback) {
  return (divisor == 0.f)
             ? fallback
             : (dividend / divisor);
}

float2 DivideSafe(float2 dividend, float2 divisor) {
  return float2(DivideSafe(dividend.x, divisor.x, FLT_MAX * Sign(dividend.x)),
                DivideSafe(dividend.y, divisor.y, FLT_MAX * Sign(dividend.y)));
}

float2 DivideSafe(float2 dividend, float2 divisor, float2 fallback) {
  return float2(DivideSafe(dividend.x, divisor.x, fallback.x),
                DivideSafe(dividend.y, divisor.y, fallback.y));
}

float3 DivideSafe(float3 dividend, float3 divisor) {
  return float3(DivideSafe(dividend.x, divisor.x, FLT_MAX * Sign(dividend.x)),
                DivideSafe(dividend.y, divisor.y, FLT_MAX * Sign(dividend.y)),
                DivideSafe(dividend.z, divisor.z, FLT_MAX * Sign(dividend.z)));
}

float3 DivideSafe(float3 dividend, float3 divisor, float3 fallback) {
  return float3(DivideSafe(dividend.x, divisor.x, fallback.x),
                DivideSafe(dividend.y, divisor.y, fallback.y),
                DivideSafe(dividend.z, divisor.z, fallback.z));
}

END_NAMESPACE(math)
END_NAMESPACE(renodx)

#endif  // SRC_SHADERS_MATH_HLSL_
