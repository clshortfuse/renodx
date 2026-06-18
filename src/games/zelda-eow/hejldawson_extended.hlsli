// HDR extension of the Hejl-Dawson filmic tonemapper (GDC 2010).
//
// Raw curve (sRGB-encoded output):
//   f(u) = u*(6.2*u + 0.5) / (u*(6.2*u + 1.7) + 0.06)
//
// The raw curve f(u) is purely concave (f'' < 0 everywhere) with no inflection.
// But f(u) has a built-in ~2.2 gamma encoding. The TRUE linear-to-linear curve is:
//
//   g(u) = f(u)^gamma
//
// This composite curve DOES have an S-curve shape:
//   - Near u=0: g(u) ~ (8.33u)^gamma = C*u^gamma, which is convex for gamma > 1
//   - For large u: g(u) -> 1, concave (decelerating)
//   - g''(u) changes sign => inflection point exists (at u ~ 0.081 for gamma=2.2)
//
// The inflection is the natural pivot for HDR extension — same concept as UC2's
// FindSecondDerivativeRoot. Below the pivot: preserve the filmic toe. Above: extend
// linearly into HDR with slope-matched C1 continuity.
//
// Finding the inflection: g''(u) = 0 reduces to
//   (gamma-1)*(f')^2 + f*f'' = 0
// which is a quintic in u (no closed form). We solve via bisection.

#include "./shared.h"

namespace HejlDawson {

// --- Constants ---
static const float HD_DEFAULT_A  = 6.2f;
static const float HD_B          = 1.7f;
static const float HD_C          = 0.5f;
static const float HD_DEFAULT_DF = 0.06f;

// --- Raw curve f(u): sRGB-encoded output ---

float Apply(float x, float a, float df) {
  float u = max(0.f, x);
  return (u * (a * u + HD_C))
       / (u * (a * u + HD_B) + df);
}

float Apply(float x) {
  return Apply(x, HD_DEFAULT_A, HD_DEFAULT_DF);
}

float Apply(float x, float2 param) {
  return Apply(x, param.x, param.y);
}

float3 Apply(float3 x, float a, float df) {
  return float3(Apply(x.r, a, df), Apply(x.g, a, df), Apply(x.b, a, df));
}

float3 Apply(float3 x) {
  return Apply(x, HD_DEFAULT_A, HD_DEFAULT_DF);
}

float3 Apply(float3 x, float2 param) {
  return Apply(x, param.x, param.y);
}

// --- First derivative f'(u) ---
// f'(u) = [A(B-C)u^2 + 2A*DF*u + C*DF] / D(u)^2

float Derivative(float x, float a, float df) {
  float u = max(0.f, x);
  float D = u * (a * u + HD_B) + df;
  float num = a * (HD_B - HD_C) * u * u
            + 2.f * a * df * u
            + HD_C * df;
  return num / (D * D);
}

float Derivative(float x) {
  return Derivative(x, HD_DEFAULT_A, HD_DEFAULT_DF);
}

// --- Second derivative f''(u) ---
// f''(u) = [-2a^2(b-c)u^3 - 6a^2*df*u^2 - 6ac*df*u + 2df(a*df-bc)] / D(u)^3

float SecondDerivative(float x, float a, float df) {
  float u = max(0.f, x);
  float D = u * (a * u + HD_B) + df;

  float num = -2.f * a * a * (HD_B - HD_C) * u * u * u
            - 6.f * a * a * df * u * u
            - 6.f * a * HD_C * df * u
            + 2.f * df * (a * df - HD_B * HD_C);

  return num / (D * D * D);
}

float SecondDerivative(float x) {
  return SecondDerivative(x, HD_DEFAULT_A, HD_DEFAULT_DF);
}

// --- Composite curve g(u) = f(u)^gamma: linear-to-linear ---

float ApplyLinear(float x, float gamma, float a, float df) {
  return pow(max(Apply(x, a, df), 0.f), gamma);
}

float ApplyLinear(float x, float gamma) {
  return ApplyLinear(x, gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

float3 ApplyLinear(float3 x, float gamma, float a, float df) {
  return float3(ApplyLinear(x.r, gamma, a, df),
                ApplyLinear(x.g, gamma, a, df),
                ApplyLinear(x.b, gamma, a, df));
}

float3 ApplyLinear(float3 x, float gamma) {
  return ApplyLinear(x, gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

// --- Derivative of composite g'(u) = gamma * f^(gamma-1) * f' ---

float DerivativeLinear(float x, float gamma, float a, float df) {
  float f = max(Apply(x, a, df), 1e-6f);
  return gamma * pow(f, gamma - 1.f) * Derivative(x, a, df);
}

float DerivativeLinear(float x, float gamma) {
  return DerivativeLinear(x, gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

// --- Find inflection point of g(u) = f(u)^gamma ---
// Solves: (gamma-1)*(f')^2 + f*f'' = 0
// h(u) > 0 near u=0 (convex region), h(u) < 0 for larger u (concave region).
// 16 bisection steps on [1e-4, 0.5] gives ~1e-5 precision.

float FindInflectionPoint(float gamma, float a, float df) {
  float lo = 1e-4f;
  float hi = 0.5f;

  [unroll]
  for (int i = 0; i < 16; i++) {
    float mid = (lo + hi) * 0.5f;
    float f_val = Apply(mid, a, df);
    float fp    = Derivative(mid, a, df);
    float fpp   = SecondDerivative(mid, a, df);
    float h     = (gamma - 1.f) * fp * fp + f_val * fpp;

    if (h > 0.f) lo = mid;
    else         hi = mid;
  }

  return (lo + hi) * 0.5f;
}

float FindInflectionPoint(float gamma) {
  return FindInflectionPoint(gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

// --- Extended curve ---
// Below pivot: g(u) = f(u)^gamma (original composite).
// Above pivot: linear extension with matched slope (C1 continuous).

#define HD_APPLY_EXTENDED_GENERATOR(T)                                         \
  T ApplyExtended(T x, T base_linear, float pivot_x, float gamma, float a, float df) { \
    float pivot_y = ApplyLinear(pivot_x, gamma, a, df);                         \
    float slope   = DerivativeLinear(pivot_x, gamma, a, df);                    \
    T extended    = pivot_y + slope * (x - pivot_x);                             \
    return lerp(base_linear, extended, step(pivot_x, x));                        \
  }

HD_APPLY_EXTENDED_GENERATOR(float)
HD_APPLY_EXTENDED_GENERATOR(float3)
#undef HD_APPLY_EXTENDED_GENERATOR

float ApplyExtended(float x, float gamma, float a, float df) {
  float pivot_x     = 0.18f;  // g'''=0 root for gamma=2.2 (23% SDR peak)
  float base_linear = ApplyLinear(x, gamma, a, df);
  return ApplyExtended(x, base_linear, pivot_x, gamma, a, df);
}

float ApplyExtended(float x, float gamma) {
  return ApplyExtended(x, gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

float ApplyExtended(float x, float gamma, float2 param) {
  return ApplyExtended(x, gamma, param.x, param.y);
}

float3 ApplyExtended(float3 x, float gamma, float a, float df) {
  float  pivot_x     = 0.18f;
  float3 base_linear = ApplyLinear(x, gamma, a, df);
  return ApplyExtended(x, base_linear, pivot_x, gamma, a, df);
}

float3 ApplyExtended(float3 x, float gamma) {
  return ApplyExtended(x, gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

float3 ApplyExtended(float3 x, float gamma, float2 param) {
  return ApplyExtended(x, gamma, param.x, param.y);
}

float3 ApplyExtended(float3 x, float3 base_linear, float gamma, float a, float df) {
  float pivot_x = 0.18f;
  return ApplyExtended(x, base_linear, pivot_x, gamma, a, df);
}

float3 ApplyExtended(float3 x, float3 base_linear, float gamma) {
  return ApplyExtended(x, base_linear, gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

float3 ApplyExtended(float3 x, float3 base_linear, float gamma, float2 param) {
  return ApplyExtended(x, base_linear, gamma, param.x, param.y);
}

float3 ApplyExtendedWithMidgray(float3 x, float3 base_linear, float middleGray, float gamma, float a, float df) {
  float pivot_x = middleGray;
  return ApplyExtended(x, base_linear, pivot_x, gamma, a, df);
}

float3 ApplyExtendedWithMidgray(float3 x, float3 base_linear, float middleGray, float gamma) {
  return ApplyExtendedWithMidgray(x, base_linear, middleGray, gamma, HD_DEFAULT_A, HD_DEFAULT_DF);
}

float3 ApplyExtendedWithMidgray(float3 x, float3 base_linear, float middleGray, float gamma, float2 param) {
  return ApplyExtendedWithMidgray(x, base_linear, middleGray, gamma, param.x, param.y);
}

}  // namespace HejlDawson
