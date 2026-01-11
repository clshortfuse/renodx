#ifndef SRC_SHADERS_MATH_HLSL_
#define SRC_SHADERS_MATH_HLSL_

#include "./math/constants.hlsl"
#include "./math/cross.hlsl"
#include "./math/select.hlsl"
#include "./math/sign.hlsl"

START_NAMESPACE(renodx)
START_NAMESPACE(math)

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

#if __SHADER_TARGET_MAJOR >= 4 || defined(VULKAN)
float ZeroNaN(float x) {
  return Select(isnan(x), 0.f, x);
}
float2 ZeroNaN(float2 x) {
  return Select(isnan(x), 0.f, x);
}
float3 ZeroNaN(float3 x) {
  return Select(isnan(x), 0.f, x);
}
float4 ZeroNaN(float4 x) {
  return Select(isnan(x), 0.f, x);
}
#else
float ZeroNaN(float x) {
  return Select(x != x, 0.f, x);
}
float2 ZeroNaN(float2 value) {
  return float2(ZeroNaN(value.x), ZeroNaN(value.y));
}
float3 ZeroNaN(float3 value) {
  return float3(ZeroNaN(value.x), ZeroNaN(value.y), ZeroNaN(value.z));
}
float4 ZeroNaN(float4 value) {
  return float4(ZeroNaN(value.x), ZeroNaN(value.y), ZeroNaN(value.z), ZeroNaN(value.w));
}
#endif

END_NAMESPACE(math)
END_NAMESPACE(renodx)

#endif  // SRC_SHADERS_MATH_HLSL_
