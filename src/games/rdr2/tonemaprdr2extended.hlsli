#include "./shared.h"

namespace rdr2 {
namespace tonemap {
float Derivative(float x, float a, float b, float c, float d, float e, float f) {
  float denom = a * x * x + b * x + e;
  float numer = a * (b - c) * x * x + 2.0f * a * (e - d) * x + (c * e - b * d);
  return numer / (denom * denom);  // -f drops out because f is constant
}

// Solve cubic a3*x^3 + a2*x^2 + a1*x + a0 = 0
// Returns three real roots if disc <= 0, otherwise one real root duplicated.
float3 SolveCubic(float a3, float a2, float a1, float a0) {
  // Normalize: x = y - a2/(3a3)
  float invA = rcp(a3);
  float b = a2 * invA;
  float c = a1 * invA;
  float d = a0 * invA;

  float shift = b / 3.0;
  float p = c - (b * b) / 3.0;
  float q = (2.0 * b * b * b) / 27.0 - (b * c) / 3.0 + d;

  float halfQ = 0.5 * q;
  float thirdP = p / 3.0;

  float disc = halfQ * halfQ + thirdP * thirdP * thirdP;

  if (disc > 0.0) {
    // One real root
    float s = sqrt(disc);
    float u = renodx::math::Cbrt(-halfQ + s);
    float v = renodx::math::Cbrt(-halfQ - s);
    float y = u + v;
    float x = y - shift;
    return float3(x, x, x);
  } else {
    // Three real roots
    float t = 2.0 * sqrt(-thirdP);
    float cosArg = (-halfQ) / sqrt(-(thirdP * thirdP * thirdP));
    cosArg = clamp(cosArg, -1.0, 1.0);

    float phi = acos(cosArg) / 3.0;

    float y0 = t * cos(phi);
    float y1 = t * cos(phi - 2.0 * renodx::math::PI / 3.0);
    float y2 = t * cos(phi - 4.0 * renodx::math::PI / 3.0);

    return float3(
        y0 - shift,
        y1 - shift,
        y2 - shift);
  }
}

// f(x) = (A x^2 + C x + D) / (A x^2 + B x + E) - F
// f''(x) = 0  => cubic P3(x) = 0
float FindSecondDerivativeRootMax(float A, float B, float C, float D, float E) {
  float a3 = A * A * (B - C);
  float a2 = 3.0 * A * A * (E - D);
  float a1 = 3.0 * A * (C * E - B * D);
  float a0 = A * D * E - A * E * E - B * B * D + B * C * E;

  float3 roots = SolveCubic(a3, a2, a1, a0);

  // Just take the max — if NaN shows up, math is broken
  return renodx::math::Max(roots);
}

// Hable/U2-style tonemap used in RDR2
#define TONEMAP_RDR2_GENERATOR(T)                                                              \
  T Apply(T x, float A, float B, float C, float D, float E, float F, float white_precompute) { \
    /* (x * (a * x + c) + d)/(x * (a * x + b) + e) - f */                                      \
    T num = x * (A * x + C) + D;                                                               \
    T den = x * (A * x + B) + E;                                                               \
    return white_precompute * ((num / den) - F);                                               \
  }

TONEMAP_RDR2_GENERATOR(float)
TONEMAP_RDR2_GENERATOR(float3)
#undef TONEMAP_RDR2_GENERATOR

#define APPLY_EXTENDED_GENERATOR(T)                                         \
  T ApplyExtended(                                                          \
      T x,                                                                  \
      T base,                                                               \
      float pivot_point,                                                    \
      float white_precompute,                                               \
      float A, float B, float C, float D, float E, float F) {               \
    float pivot_x = pivot_point;                                            \
    float pivot_y = Apply(pivot_x, A, B, C, D, E, F, white_precompute);     \
    float slope = Derivative(pivot_x, A, B, C, D, E, F) * white_precompute; \
    T offset = pivot_y - slope * pivot_x;                                   \
                                                                            \
    T extended = slope * x + offset; /* match slope */                      \
                                                                            \
    return lerp(base, extended, step(pivot_x, x));                          \
  }

APPLY_EXTENDED_GENERATOR(float)
APPLY_EXTENDED_GENERATOR(float3)
#undef APPLY_EXTENDED_GENERATOR

}  // namespace tonemap
}  // namespace rdr2

