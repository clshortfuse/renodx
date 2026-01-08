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
static const float FLT_MAX = CROSS_COMPILE(asfloat(0x7F7FFFFF), 3.40282346638528859812e+38);

static const float INFINITY = CROSS_COMPILE(asfloat(0x7F800000), 1.0 / 0.0);
static const float NEG_INFINITY = CROSS_COMPILE(asfloat(0xFF800000), -1.0 / 0.0);
static const float PI = 3.14159265358979323846f;

static const float FLT10_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0040), 0.0078125);         // 2^-7
static const float FLT11_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0020), 0.00390625);        // 2^-8
static const float FLT12_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0010), 0.001953125);       // 2^-9
static const float FLT16_EPSILON = CROSS_COMPILE(asfloat(0x3C00 + 0x0004), 0.0009765625);      // 2^-10
static const float FLT32_EPSILON = CROSS_COMPILE(asfloat(0x34000000), 1.1920928955078125e-7);  // 2^-23
static const float FLT_EPSILON = CROSS_COMPILE(asfloat(0x34000000), 1.1920928955078125e-7);    // 2^-23

#if __SHADER_TARGET_MAJOR >= 6 || defined(VULKAN)
#define SELECT_FUNCTION_GENERATOR_SCALAR(TYPE)                   \
  TYPE Select(bool condition, TYPE trueValue, TYPE falseValue) { \
    return select(condition, trueValue, falseValue);             \
  }

#define SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, SIZE)                                     \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) {       \
    return select(condition, trueValue, falseValue);                                     \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE falseValue) {             \
    return select(condition, trueValue, falseValue);                                     \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE trueValue, TYPE##SIZE falseValue) {             \
    return select(condition, trueValue, falseValue);                                     \
  }                                                                                      \
  TYPE##SIZE Select(bool##SIZE condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) { \
    return select(condition, trueValue, falseValue);                                     \
  }

#else
// Backport of select(t,a,b)
#define SELECT_FUNCTION_GENERATOR_SCALAR(TYPE)                   \
  TYPE Select(bool condition, TYPE trueValue, TYPE falseValue) { \
    [flatten]                                                    \
    if (condition) {                                             \
      return trueValue;                                          \
    } else {                                                     \
      return falseValue;                                         \
    }                                                            \
  }

#define SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, SIZE)                                     \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) {       \
    [flatten]                                                                            \
    if (condition) {                                                                     \
      return trueValue;                                                                  \
    } else {                                                                             \
      return falseValue;                                                                 \
    }                                                                                    \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE falseValue) {             \
    [flatten]                                                                            \
    if (condition) {                                                                     \
      return trueValue;                                                                  \
    } else {                                                                             \
      return falseValue;                                                                 \
    }                                                                                    \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE trueValue, TYPE##SIZE falseValue) {             \
    [flatten]                                                                            \
    if (condition) {                                                                     \
      return trueValue;                                                                  \
    } else {                                                                             \
      return falseValue;                                                                 \
    }                                                                                    \
  }                                                                                      \
  TYPE##SIZE Select(bool##SIZE condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) { \
    TYPE##SIZE result;                                                                   \
    [unroll]                                                                             \
    for (int i = 0; i < SIZE; ++i) {                                                     \
      [flatten]                                                                          \
      if (condition[i]) {                                                                \
        result[i] = trueValue[i];                                                        \
      } else {                                                                           \
        result[i] = falseValue[i];                                                       \
      }                                                                                  \
    }                                                                                    \
    return result;                                                                       \
  }

#endif

#define SELECT_FUNCTION_GENERATOR(TYPE)     \
  SELECT_FUNCTION_GENERATOR_SCALAR(TYPE)    \
  SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, 2) \
  SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, 3) \
  SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, 4)

SELECT_FUNCTION_GENERATOR(float)
SELECT_FUNCTION_GENERATOR(uint)
SELECT_FUNCTION_GENERATOR(int)

#undef SELECT_FUNCTION_GENERATOR_SCALAR
#undef SELECT_FUNCTION_GENERATOR_VECTOR
#undef SELECT_FUNCTION_GENERATOR

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

// -1 or 1 (Doesn't follow IEEE standard for zero or NaN)
// https://en.cppreference.com/w/cpp/numeric/math/copysign.html
#if __SHADER_TARGET_MAJOR <= 3
#define COPYSIGN_FUNCTION_GENERATOR(T)           \
  T CopySign(T mag, T sgn) {                     \
    return Select(sgn < 0, -abs(mag), abs(mag)); \
  }
#else
// https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl#L819
#define COPYSIGN_FUNCTION_GENERATOR(T)                                         \
  T CopySign(T mag, T sgn) {                                                   \
    /* 0x80000000u = 10000000000000000000000000000000 */                       \
    /* 0x7FFFFFFFu = 01111111111111111111111111111111 */                       \
    return asfloat((asuint(sgn) & 0x80000000u) | (asuint(mag) & 0x7FFFFFFFu)); \
  }
#endif

#define SIGNPOW_FUNCTION_GENERATOR(struct)     \
  struct SignPow(struct x, float exponent) {   \
    return CopySign(pow(abs(x), exponent), x); \
  }

#define SIGNSQRT_FUNCTION_GENERATOR(struct) \
  struct SignSqrt(struct x) {               \
    return CopySign(sqrt(abs(x)), x);       \
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
ALL_FLOATS_FUNCTION_GENERATOR(COPYSIGN_FUNCTION_GENERATOR)
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
  return Select(divisor == 0.f, CopySign(FLT_MAX, dividend), dividend / divisor);
}

float DivideSafe(float dividend, float divisor, float fallback) {
  return Select(divisor == 0.f, fallback, dividend / divisor);
}

float2 DivideSafe(float2 dividend, float2 divisor) {
  return float2(DivideSafe(dividend.x, divisor.x, CopySign(FLT_MAX, dividend.x)),
                DivideSafe(dividend.y, divisor.y, CopySign(FLT_MAX, dividend.y)));
}

float2 DivideSafe(float2 dividend, float2 divisor, float2 fallback) {
  return float2(DivideSafe(dividend.x, divisor.x, fallback.x),
                DivideSafe(dividend.y, divisor.y, fallback.y));
}

float3 DivideSafe(float3 dividend, float3 divisor) {
  return float3(DivideSafe(dividend.x, divisor.x, CopySign(FLT_MAX, dividend.x)),
                DivideSafe(dividend.y, divisor.y, CopySign(FLT_MAX, dividend.y)),
                DivideSafe(dividend.z, divisor.z, CopySign(FLT_MAX, dividend.z)));
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

float Min(float x, float y) {
  return min(x, y);
}

float Min(float x, float y, float z) {
  return Min(x, Min(y, z));
}

float Min(float x, float y, float z, float w) {
  return Min(x, Min(y, z, w));
}

float Min(float2 xy) {
  return Min(xy.x, xy.y);
}

float Min(float3 xyz) {
  return Min(xyz.x, xyz.y, xyz.z);
}

float Min(float4 xyzw) {
  return Min(xyzw.x, xyzw.y, xyzw.z, xyzw.w);
}

float Max(float x, float y) {
  return max(x, y);
}

float Max(float x, float y, float z) {
  return Max(x, Max(y, z));
}

float Max(float x, float y, float z, float w) {
  return Max(x, Max(y, z, w));
}

float Max(float2 xy) {
  return Max(xy.x, xy.y);
}

float Max(float3 xyz) {
  return Max(xyz.x, xyz.y, xyz.z);
}

float Max(float4 xyzw) {
  return Max(xyzw.x, xyzw.y, xyzw.z, xyzw.w);
}

// Linear Normalization
// normalize() is reserved in HLSL
float Rescale(float x, float x_min, float x_max, float y_min = 0, float y_max = 1, bool clamp = false) {
  float value = lerp(y_min, y_max, (x - x_min) / (x_max - x_min));
  if (clamp) {
    value = saturate(value);
  }
  return value;
}

float Rescale(float x, float x_min, float x_max, bool clamp) {
  return Rescale(x, x_min, x_max, 0.f, 1.f, clamp);
}

float3 Rescale(float3 x, float3 x_min, float3 x_max, float3 y_min = float3(0, 0, 0), float3 y_max = float3(1, 1, 1), bool clamp = false) {
  float3 value = lerp(y_min, y_max, (x - x_min) / (x_max - x_min));
  if (clamp) {
    value = saturate(value);
  }
  return value;
}

float3 Rescale(float3 x, float3 x_min, float3 x_max, bool clamp) {
  return Rescale(x, x_min, x_max, float3(0, 0, 0), float3(1, 1, 1), clamp);
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
  float invDet = DivideSafe(1.0, det, 0.0);

  return float3x3(
             A, D, G,
             B, E, H,
             C, F, I)
         * invDet;
}

END_NAMESPACE(math)
END_NAMESPACE(renodx)

#endif  // SRC_SHADERS_MATH_HLSL_
