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
static const float FLT_MIN = CROSS_COMPILE(asfloat(0x00800000), 1.17549435082228750797e-38);
static const float FLT_MAX = CROSS_COMPILE(asfloat(0x7F7FFFFF), 3.40282346638528859812e+38);;
static const float INFINITY = CROSS_COMPILE(asfloat(0x7F800000), 1.0 / 0.0);
static const float NEG_INFINITY = CROSS_COMPILE(asfloat(0xFF800000), -1.0 / 0.0);
static const float PI = 3.14159265358979323846f;

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

#define SIGNPOW_FUNCTION_GENERATOR(struct)   \
  struct SignPow(struct x, float exponent) { \
    return Sign(x) * pow(abs(x), exponent);  \
  }

#define SIGNSQRT_FUNCTION_GENERATOR(struct) \
  struct SignSqrt(struct x) {               \
    return Sign(x) * sqrt(abs(x));          \
  }

#define CBRT_FUNCTION_GENERATOR(struct) \
  struct Cbrt(struct x) {               \
    return SignPow(x, 1.f / 3.f);       \
  }

#define ALL_FLOATS_FUNCTION_GENERATOR(generator) \
  generator(float)                               \
      generator(float2)                          \
          generator(float3)                      \
              generator(float4)

ALL_FLOATS_FUNCTION_GENERATOR(SIGN_FUNCTION_GENERATOR)
ALL_FLOATS_FUNCTION_GENERATOR(SIGNPOW_FUNCTION_GENERATOR)
ALL_FLOATS_FUNCTION_GENERATOR(SIGNSQRT_FUNCTION_GENERATOR)
ALL_FLOATS_FUNCTION_GENERATOR(CBRT_FUNCTION_GENERATOR)
#undef SIGN_FUNCTION_GENERATOR
#undef SIGNPOW_FUNCTION_GENERATOR
#undef SIGNSQRT_FUNCTION_GENERATOR
#undef CBRT_FUNCTION_GENERATOR
#undef ALL_FLOATS_FUNCTION_GENERATOR

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

float4 DivideSafe(float4 dividend, float4 divisor, float4 fallback) {
  return float4(DivideSafe(dividend.x, divisor.x, fallback.x),
                DivideSafe(dividend.y, divisor.y, fallback.y),
                DivideSafe(dividend.z, divisor.z, fallback.z),
                DivideSafe(dividend.w, divisor.w, fallback.w));
}

float Max(float x, float y, float z) {
  return max(x, max(y, z));
}

float Max(float x, float y, float z, float w) {
  return max(x, max(y, max(z, w)));
}

float Min(float x, float y, float z) {
  return min(x, min(y, z));
}

float Min(float x, float y, float z, float w) {
  return min(x, min(y, min(z, w)));
}

float3x3 Invert3x3(float3x3 m) {
  float a = m[0][0], b = m[0][1], c = m[0][2];
  float d = m[1][0], e = m[1][1], f = m[1][2];
  float g = m[2][0], h = m[2][1], i = m[2][2];

  float A = (e * i - f * h);
  float B = -(d * i - f * g);
  float C = (d * h - e * g);
  float D = -(b * i - c * h);
  float E = (a * i - c * g);
  float F = -(a * h - b * g);
  float G = (b * f - c * e);
  float H = -(a * f - c * d);
  float I = (a * e - b * d);

  float det = a * A + b * B + c * C;
  float invDet = 1.0 / det;

  return float3x3(
             A, D, G,
             B, E, H,
             C, F, I)
         * invDet;
}

END_NAMESPACE(math)
END_NAMESPACE(renodx)

#endif  // SRC_SHADERS_MATH_HLSL_
