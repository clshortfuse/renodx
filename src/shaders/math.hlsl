#ifndef SRC_SHADERS_MATH_HLSL_
#define SRC_SHADERS_MATH_HLSL_

namespace renodx {
namespace math {

static const float FLT_MIN = asfloat(0x00800000);  // 1.175494351e-38f
static const float FLT_MAX = asfloat(0x7F7FFFFF);  // 3.402823466e+38f
static const float FLT10_MAX = 64512.f;
static const float FLT11_MAX = 65024.f;
static const float FLT16_MAX = 65504.f;

#if __SHADER_TARGET_MAJOR <= 5
#define SIGN_FUNCTION_GENERATOR(T)                          \
  T Sign(T x) {                                             \
    return mad(saturate(mad(x, FLT_MAX, 0.5f)), 2.f, -1.f); \
  }
#else
#define SIGN_FUNCTION_GENERATOR(T) \
  T Sign(T x) {                    \
    return sign(x);                \
  }
#endif

SIGN_FUNCTION_GENERATOR(float);
SIGN_FUNCTION_GENERATOR(float2);
SIGN_FUNCTION_GENERATOR(float3);
SIGN_FUNCTION_GENERATOR(float4);

#undef SIGN_FUNCTION_GENERATOR

#define POWSAFE_FUNCTION_GENERATOR(struct)   \
  struct PowSafe(struct x, float exponent) { \
    return Sign(x) * pow(abs(x), exponent);  \
  }

POWSAFE_FUNCTION_GENERATOR(float);
POWSAFE_FUNCTION_GENERATOR(float2);
POWSAFE_FUNCTION_GENERATOR(float3);
POWSAFE_FUNCTION_GENERATOR(float4);
#undef POWSAFE_FUNCTION_GENERATOR

#define SQRTSAFE_FUNCTION_GENERATOR(struct) \
  struct SqrtSafe(struct x) {               \
    return Sign(x) * sqrt(abs(x));          \
  }

SQRTSAFE_FUNCTION_GENERATOR(float);
SQRTSAFE_FUNCTION_GENERATOR(float2);
SQRTSAFE_FUNCTION_GENERATOR(float3);
SQRTSAFE_FUNCTION_GENERATOR(float4);
#undef SQRTSAFE_FUNCTION_GENERATOR

float Average(float3 color) {
  return (color.x + color.y + color.z) / 3.f;
}

#if __HLSL_VERSION >= 2021
template <typename T>
T DivideSafe(T dividend, T divisor) {
  return select(divisor == 0.f, FLT_MAX * Sign(dividend), dividend / divisor);
}
template <typename T>
T DivideSafe(T dividend, T divisor, T fallback) {
  return select(divisor == 0.f, fallback, dividend / divisor);
}
#else
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
#endif

}  // namespace math
}  // namespace renodx
#endif  // SRC_SHADERS_MATH_HLSL_
