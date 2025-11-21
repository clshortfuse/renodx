#include "./shared.h"

float InverseUncharted2(
    float y, float W,
    float A, float B, float C, float D, float E, float F) {
  // 1. Recover raw ApplyCurve output: y_raw = y * ApplyCurve(W)
  float rawW = renodx::tonemap::ApplyCurve(W, A, B, C, D, E, F);
  float y_raw = y * rawW;

  // 2. Solve inverse of ApplyCurve analytically (quadratic)
  float ef = E / F;
  float yp = y_raw + ef;

  // Quadratic coefficients:
  // A_q x^2 + B_q x + C_q = 0
  float A_q = A * (yp - 1.0);
  float B_q = B * (yp - C);
  float C_q = D * (F * yp - E);

  // Quadratic discriminant
  float disc = B_q * B_q - 4.0 * A_q * C_q;
  disc = max(disc, 0.0);
  float sqrtD = sqrt(disc);

  float x1 = (-B_q + sqrtD) / (2.0 * A_q);
  float x2 = (-B_q - sqrtD) / (2.0 * A_q);

  // pick the physically meaningful root (positive, usually x1)
  return max(x1, x2);
}

float3 InverseUncharted2(
    float3 color, float W,
    float A, float B, float C, float D, float E, float F) {
  return float3(
      InverseUncharted2(color.r, W, A, B, C, D, E, F),
      InverseUncharted2(color.g, W, A, B, C, D, E, F),
      InverseUncharted2(color.b, W, A, B, C, D, E, F));
}

namespace Uncharted2 {

float Derivative(
    float x,
    float a, float b, float c,
    float d, float e, float f) {
  float num = -a * b * (c - 1.0) * x * x
              + 2.0 * a * d * (f - e) * x
              + b * d * (c * f - e);

  float den = x * (a * x + b) + d * f;
  den = den * den;

  return num / den;
}

// Root of f'(x) = 0 for the raw ApplyCurve, using quadratic formula.
// With a,b,c,d,e,f > 0 and 0 < c < 1, this is well-defined.
float FindDerivativeRoot(
    float a, float b, float c,
    float d, float e, float f) {
  // Quadratic coefficients for numerator of f'(x)
  // -a*b*(c - 1) * x^2 + 2*a*d*(f - e)*x + b*d*(c*f - e) = 0
  float Aq = a * b * (1.f - c);  // -a*b*(c-1)
  float Bq = 2.f * a * d * (f - e);
  float Cq = b * d * (c * f - e);

  // Discriminant
  float disc = Bq * Bq - 4.f * Aq * Cq;
  disc = max(disc, 0.f);  // just in case of tiny negatives

  float sqrtDisc = sqrt(disc);

  float r1 = (-Bq + sqrtDisc) / (2.f * Aq);
  float r2 = (-Bq - sqrtDisc) / (2.f * Aq);

  // Larger root of the quadratic
  float root = max(r1, r2);

  // Only care about non-negative x in our domain
  return max(root, 0.f);
}

float SecondDerivative(
    float x,
    float a, float b, float c,
    float d, float e, float f) {
  // Common denom: (x*(a*x + b) + d*f)^3
  float t = x * (a * x + b) + d * f;
  float den = t * t * t;

  // Numerator pieces from WA:
  // 2 * ( a*b*x*(a*(c-1)*x^2 + 3*d*(e - c*f))
  //     + a*d*(e - f)*(3*a*x^2 - d*f)
  //     + b*b*d*(e - c*f) )
  float term1 = a * b * x * (a * (c - 1.f) * x * x + 3.f * d * (e - c * f));
  float term2 = a * d * (e - f) * (3.f * a * x * x - d * f);
  float term3 = b * b * d * (e - c * f);

  float num = 2.f * (term1 + term2 + term3);

  return num / den;
}

float FindSecondDerivativeRoot(
    float a, float b, float c,
    float d, float e, float f) {
  float D0 = (a * a * b * c - a * a * b);

  float term1 = -(a * a * d * e - a * a * d * f) / D0;

  float X = (-54.f * d * d * d * e * e * e * a * a * a * a * a * a
             + 54.f * d * d * d * f * f * f * a * a * a * a * a * a
             - 162.f * d * d * d * e * f * f * a * a * a * a * a * a
             + 162.f * d * d * d * e * e * f * a * a * a * a * a * a
             - 81.f * b * b * d * d * e * e * a * a * a * a * a
             + 81.f * b * b * c * d * d * e * e * a * a * a * a * a
             - 27.f * b * b * d * d * f * f * a * a * a * a * a
             + 54.f * b * b * c * c * d * d * f * f * a * a * a * a * a
             - 27.f * b * b * c * d * d * f * f * a * a * a * a * a
             + 108.f * b * b * d * d * e * f * a * a * a * a * a
             - 54.f * b * b * c * c * d * d * e * f * a * a * a * a * a
             - 54.f * b * b * c * d * d * e * f * a * a * a * a * a
             - 27.f * b * b * b * b * d * e * a * a * a * a
             - 27.f * b * b * b * b * c * c * d * e * a * a * a * a
             + 54.f * b * b * b * b * c * d * e * a * a * a * a
             + 27.f * b * b * b * b * c * c * c * d * f * a * a * a * a
             - 54.f * b * b * b * b * c * c * d * f * a * a * a * a
             + 27.f * b * b * b * b * c * d * f * a * a * a * a);

  float innerA = 9.f * D0 * (a * b * d * e - a * b * c * d * f)
                 - 9.f * (a * a * d * e - a * a * d * f) * (a * a * d * e - a * a * d * f);

  float innerB = 4.f * pow(innerA, 3.f)
                 + (X * X);

  float sqrt_innerB = sqrt(innerB);

  float numerator1 = (X + sqrt_innerB);

  float denomA = 3.f * pow(2.f, 1.f / 3.f) * D0;

  float C = renodx::math::SignPow(numerator1, 1.f / 3.f);

  float term2 = C / denomA;

  float term3 = (pow(2.f, 1.f / 3.f) * innerA) / (3.f * D0 * C);

  float root = term1 + term2 - term3;
  return root;
}

float ThirdDerivative(
    float x,
    float a, float b, float c,
    float d, float e, float f) {
  // Common denom: (x*(a*x + b) + d*f)^4
  float t = x * (a * x + b) + d * f;
  float den = t * t * t * t;

  // Numerator from WA:
  // -6 * (
  //   a*b*(a^2*(c-1)*x^4 + 6*a*d*x^2*(e - c*f) + d^2*f*(c*f - 2*e + f))
  //   + 4*a^2*d*x*(e - f)*(a*x^2 - d*f)
  //   + 4*a*b*b*d*x*(e - c*f)
  //   + b^3*d*(e - c*f)
  // )
  float x2 = x * x;
  float x4 = x2 * x2;

  float term1 = a * b * (a * a * (c - 1.f) * x4 + 6.f * a * d * x2 * (e - c * f) + d * d * f * (c * f - 2.f * e + f));

  float term2 = 4.f * a * a * d * x * (e - f) * (a * x2 - d * f);
  float term3 = 4.f * a * b * b * d * x * (e - c * f);
  float term4 = b * b * b * d * (e - c * f);

  float num = -6.f * (term1 + term2 + term3 + term4);

  return num / den;
}

// Analytic knee root of f'''(x) = 0 for Uncharted2/Hable ApplyCurve
// a,b,c,d,e,f > 0, typically 0 < c < 1.
// Returns the smallest positive real root ("first knee") in x > 0.
float FindThirdDerivativeRoot(float a, float b, float c, float d, float e, float f) {
  // sqrt(a b^2 c^2 - 2 a b^2 c + a b^2)
  float sqrt_ab = sqrt(
      a * b * b * c * c
      - 2.f * a * b * b * c
      + a * b * b);

  // sqrt(a d^2 e^2 - 2 a d^2 e f + a d^2 f^2
  //    + b^2 c^2 d f + b^2 (-c) d e - b^2 c d f + b^2 d e)
  float sqrt_df = sqrt(
      a * d * d * e * e
      - 2.f * a * d * d * e * f
      + a * d * d * f * f
      + b * b * c * c * d * f
      + b * b * (-c) * d * e
      - b * b * c * d * f
      + b * b * d * e);

  // Precompute (d e - d f)
  float de_df = d * e - d * f;

  // Inner big piece: sqrt_ab * (...) / (8 * sqrt_df)
  float term_top =
      32.f * (a * d * d * e * f - a * d * d * f * f + b * b * c * d * f - b * b * d * e)
      / (a * a * b * (c - 1.f));

  float term_mid =
      96.f * de_df * (c * d * f - d * e)
      / (a * b * (c - 1.f) * (c - 1.f));

  float de_df2 = de_df * de_df;
  float de_df3 = de_df2 * de_df;

  float term_tail =
      64.f * de_df3
      / (b * b * b * (c - 1.f) * (c - 1.f) * (c - 1.f));

  float Tfrac = sqrt_ab * (term_top - term_mid - term_tail)
                / (8.f * sqrt_df);

  // (12 a^2 b c d f - 12 a^2 b d e) / (6 (a^3 b c - a^3 b))
  float Tmid2_num = 12.f * a * a * b * c * d * f
                    - 12.f * a * a * b * d * e;
  float Tmid2_den = 6.f * (a * a * a * b * c - a * a * a * b);
  float Tmid2 = Tmid2_num / Tmid2_den;

  // (6 (c d f - d e))/(a (c - 1))
  float T3 = 6.f * (c * d * f - d * e)
             / (a * (c - 1.f));

  // (8 (d e - d f)^2)/(b^2 (c - 1)^2)
  float T4 = 8.f * de_df2
             / (b * b * (c - 1.f) * (c - 1.f));

  // Centers for the ± branches
  float centerNeg = -Tfrac + Tmid2 + T3 + T4;  // used with sqrt(-centerNeg)
  float centerPos = Tfrac + Tmid2 + T3 + T4;   // used with sqrt( centerPos)

  // Branch square roots: use SignSqrt for robustness and correct branch behaviour
  float sNeg = renodx::math::SignSqrt(-centerNeg);
  float sPos = renodx::math::SignSqrt(centerPos);

  // Shifts:
  //  - first two roots use:  - sqrt_df/sqrt_ab - (d e - d f)/(b (c - 1))
  //  - last two use:          sqrt_df/sqrt_ab - (d e - d f)/(b (c - 1))
  float shift1 = sqrt_df / sqrt_ab + de_df / (b * (c - 1.f));  // we subtract this
  float shift2 = sqrt_df / sqrt_ab - de_df / (b * (c - 1.f));  // we add this

  // The four analytic roots from WA, mapped to floats:
  float r1 = -0.5f * sNeg - shift1;  // -1/2 * sqrt(-centerNeg) - shift1
  float r2 = 0.5f * sNeg - shift1;   //  1/2 * sqrt(-centerNeg) - shift1
  float r3 = -0.5f * sPos + shift2;  // -1/2 * sqrt( centerPos) + shift2
  float r4 = 0.5f * sPos + shift2;   //  1/2 * sqrt( centerPos) + shift2

  float root = saturate(renodx::math::Max(r1, r2, r3, r4));

  return root;
}

namespace Config {

struct Uncharted2ExtendedConfig {
  float pivot_point;
  float white_precompute;
  float coeffs[6];  // A,B,C,D,E,F
};

Uncharted2ExtendedConfig CreateUncharted2ExtendedConfig(
    float pivot_point,
    float coeffs[6], float white_precompute) {
  Uncharted2ExtendedConfig cfg;
  cfg.pivot_point = pivot_point;
  cfg.white_precompute = white_precompute;
  cfg.coeffs = coeffs;

  return cfg;
}

Uncharted2ExtendedConfig CreateUncharted2ExtendedConfig(
    float coeffs[6], float white_precompute) {
  return CreateUncharted2ExtendedConfig(
      FindSecondDerivativeRoot(coeffs[0], coeffs[1], coeffs[2], coeffs[3], coeffs[4], coeffs[5]),  // 0.1621583f with default params
      coeffs, white_precompute);
}

}  // Config

#define APPLY_EXTENDED_GENERATOR(T)                                                            \
  T ApplyExtended(                                                                             \
      T x,                                                                                     \
      T base,                                                                                  \
      float pivot_point,                                                                       \
      float white_precompute,                                                                  \
      float A, float B, float C, float D, float E, float F) {                                  \
    float pivot_x = pivot_point;                                                               \
    float pivot_y = renodx::tonemap::ApplyCurve(pivot_x, A, B, C, D, E, F) * white_precompute; \
    float slope = Derivative(pivot_x, A, B, C, D, E, F) * white_precompute;                    \
    T offset = pivot_y - slope * pivot_x;                                                      \
                                                                                               \
    T extended = slope * x + offset; /* match slope */                                         \
                                                                                               \
    return lerp(base, extended, step(pivot_x, x));                                             \
  }

APPLY_EXTENDED_GENERATOR(float)
APPLY_EXTENDED_GENERATOR(float3)
#undef APPLY_EXTENDED_GENERATOR

float ApplyExtended(float x, float base, Config::Uncharted2ExtendedConfig uc2_config) {
  return ApplyExtended(
      x, base, uc2_config.pivot_point, uc2_config.white_precompute,
      uc2_config.coeffs[0], uc2_config.coeffs[1], uc2_config.coeffs[2],
      uc2_config.coeffs[3], uc2_config.coeffs[4], uc2_config.coeffs[5]);
}

float3 ApplyExtended(float3 x, float3 base, Config::Uncharted2ExtendedConfig uc2_config) {
  return ApplyExtended(
      x, base, uc2_config.pivot_point, uc2_config.white_precompute,
      uc2_config.coeffs[0], uc2_config.coeffs[1], uc2_config.coeffs[2],
      uc2_config.coeffs[3], uc2_config.coeffs[4], uc2_config.coeffs[5]);
}

float ApplyExtended(float x, Config::Uncharted2ExtendedConfig uc2_config) {
  float base =
      renodx::tonemap::ApplyCurve(x, uc2_config.coeffs[0], uc2_config.coeffs[1], uc2_config.coeffs[2],
                                  uc2_config.coeffs[3], uc2_config.coeffs[4], uc2_config.coeffs[5])
      * uc2_config.white_precompute;

  return ApplyExtended(x, base, uc2_config);
}

float3 ApplyExtended(float3 x, Config::Uncharted2ExtendedConfig uc2_config) {
  float3 base =
      renodx::tonemap::ApplyCurve(x, uc2_config.coeffs[0], uc2_config.coeffs[1], uc2_config.coeffs[2],
                                  uc2_config.coeffs[3], uc2_config.coeffs[4], uc2_config.coeffs[5])
      * uc2_config.white_precompute;
  return ApplyExtended(x, base, uc2_config);
}
}  // Uncharted2
