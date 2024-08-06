#ifndef SRC_COMMON_MATH_HLSL_
#define SRC_COMMON_MATH_HLSL_

namespace renodx {
namespace math {

static const float FLT_MIN = asfloat(0x00800000);  // 1.175494351e-38f
static const float FLT_MAX = asfloat(0x7F7FFFFF);  // 3.402823466e+38f
static const float FLT10_MAX = 64512.f;
static const float FLT11_MAX = 65024.f;
static const float FLT16_MAX = 65504.f;

 float3 SafePow(float3 color, float exponent = 2.2f){
  return sign(color) * pow(abs(color), exponent);
 }

 float1 SafePow(float1 color, float exponent = 2.2f){
  return sign(color) * pow(abs(color), exponent);
 }
        
float3 Pow(float3 color, float exponent = 2.2f){
  return pow(color, exponent);
 }
        
float Average(float3 color) {
  return (color.x + color.y + color.z) / 3.f;
}

// Returns 1 or FLT_MAX if "dividend" is 0
float SafeDivision(float quotient, float dividend) {
  return (dividend == 0.f)
             ? FLT_MAX * sign(quotient)
             : (quotient / dividend);
}

float SafeDivision(float quotient, float dividend, float fallback) {
  return (dividend == 0.f)
             ? fallback
             : (quotient / dividend);
}

float3 SafeDivision(float3 quotient, float3 dividend) {
  return float3(SafeDivision(quotient.x, dividend.x, FLT_MAX * sign(quotient.x)),
                SafeDivision(quotient.y, dividend.y, FLT_MAX * sign(quotient.y)),
                SafeDivision(quotient.z, dividend.z, FLT_MAX * sign(quotient.z)));
}

float3 SafeDivision(float3 quotient, float3 dividend, float3 fallback) {
  return float3(SafeDivision(quotient.x, dividend.x, fallback.x),
                SafeDivision(quotient.y, dividend.y, fallback.y),
                SafeDivision(quotient.z, dividend.z, fallback.z));
}

}  // namespace math
}  // namespace renodx
#endif  // SRC_COMMON_MATH_HLSL_
