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

// namespace extended {
// float3 BT709(float3 x, float linear_white = 11.2, float A, float B, float C, float D, float E, float F) {
//   float3 numerator = mad(x, mad(A, x, C * B), D * E);  // x * (a * x + c * b) + d * e
//   float3 denominator = mad(x, mad(A, x, B), D * F);    // x * (a * x + b) + d * f

//   float numerator_white = mad(linear_white, mad(A, linear_white, C * B), D * E);
//   float denominator_white = mad(linear_white, mad(A, linear_white, B), D * F);

//   float e_over_f = E / F;

//   float3 curve_x = (numerator / denominator) - e_over_f;
//   float curve_white = (numerator_white / denominator_white) - e_over_f;
//   float curve_white_inverse = 1.f / curve_white;

//   float3 value = curve_x * curve_white_inverse;

//   // Use Cardono's Method to solve for point of peak velocity (2nd derivative = 0)
//   // 2B^{2}D(E-CF)+2AD(E-F)(-DF+3Ax^{2})+2ABx(3D(E-CF)+A(-1+C)x^{2}) = 0
//   float a_0 = 2 * B * B * D * (E - C * F) - 2 * A * D * D * F * (E - F);
//   float a_1 = 6 * A * B * D * (E - C * F);
//   float a_2 = 6 * A * A * D * (E - F);
//   float a_3 = 2 * A * A * B * (C - 1);

//   float a_3_rcp = 1.f / a_3;  // Helper

//   // float p = (3 * a_1 * a_3 - a_2 * a_2) / (3 * a_3 * a_3);
//   float p = (3 * a_1 * a_3 - a_2 * a_2) * (1.f / 3.f) * (a_3_rcp * a_3_rcp);

//   // float q = (27 * a_0 * a_3 * a_3 - 9 * a_1 * a_2 * a_3 + 2 * a_2 * a_2 * a_2) / (27 * a_3 * a_3 * a_3);
//   float q = (27 * a_0 * a_3 * a_3 - 9 * a_1 * a_2 * a_3 + 2 * a_2 * a_2 * a_2) * (1.f / 27.f) * (a_3_rcp * a_3_rcp * a_3_rcp);

//   // float delta = pow((q / 2), 2) + pow((p / 3), 3);
//   float delta = (q * q) / 4.f + (p * p * p) / 27.f;

//   float z;
//   [branch]
//   if (delta >= 0.0f) {
//     // float z = pow(sqrt(delta) - q / 2.f, 1.f / 3.f) - pow(sqrt(delta) + q / 2.f, 1.f / 3.f);
//     // Δ ≥ 0 → one real root, cube‑root form
//     float sqrt_delta = sqrt(delta);
//     z = pow(-q / 2.f + sqrt_delta, 1.f / 3.f) + pow(-q / 2.f - sqrt_delta, 1.f / 3.f);
//   } else {
//     // Δ < 0 → three real roots, use cosine form
//     // usually ta k e k=0 root
//     // float theta = acos((-q / 2.0f) / sqrt(-pow(p / 3.0f, 3)));
//     // float r = 2.0f * sqrt(-p / 3.0f);

//     // p is always negative here
//     float positive_p_over_3 = -p / 3.f;

//     float theta = acos((-q / 2.0f) * rsqrt(positive_p_over_3 * positive_p_over_3 * positive_p_over_3));
//     float r = 2.0f * sqrt(positive_p_over_3);

//     z = r * cos(theta / 3.0f);
//   }

//   // float peak_velocity = z - a_2 / (3 * a_3);
//   float peak_velocity_point = (z - a_2) * (1.f / 3.f) * a_3_rcp;

//   // If no toe, use initial velocity
//   peak_velocity_point = max(0, peak_velocity_point);

//   float peak_velocity_value_numerator = mad(peak_velocity_point, mad(A, peak_velocity_point, C * B), D * E);
//   float peak_velocity_value_denominator = mad(peak_velocity_point, mad(A, peak_velocity_point, B), D * F);
//   float peak_velocity_value_denominator_inverse = 1.f / peak_velocity_value_denominator;

//   float peak_velocity_value_base = peak_velocity_value_numerator * peak_velocity_value_denominator_inverse;

//   // Evaluate first deriviate to get velocity (skip [E/F, W] normalization)
//   // R\left(x\right)=\frac{(2Ax+CB)D_{r}\left(x\right)-(2Ax+B)N_{r}\left(x\right)}{D_{r}\left(x\right)^{2}}
//   // R\left(x\right)=\frac{(2Ax+CB)-(2Ax+B)F\left(x\right)}{D_{r}\left(x\right)}
//   float peak_velocity_unscaled = ((2 * A * peak_velocity_point + C * B)
//                                   - ((2 * A * peak_velocity_point + B) * peak_velocity_value_base))
//                                  * peak_velocity_value_denominator_inverse;

//   float peak_velocity = peak_velocity_unscaled * curve_white_inverse;

//   float curve_peak = peak_velocity_value_base - e_over_f;
//   float value_peak = curve_peak * curve_white_inverse;

//   // Use point slope form (y = y1 + m(x - x1)) to extend curve linearly beyond peak velocity

//   float m = peak_velocity;
//   float3 x = value;
//   float x1 = peak_velocity_point;
//   float y1 = value_peak;
//   float3 extended_value = y1 + m * (x - x1);

//   return float3(
//       value.x > peak_velocity_point ? extended_value.x : value.x,
//       value.y > peak_velocity_point ? extended_value.y : value.y,
//       value.z > peak_velocity_point ? extended_value.z : value.z);
// }
// }

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

float FindSecondDerivativeRoot(float a, float b, float c, float d, float e, float f) {
  // Coefficients of the numerator of f''(x):
  // num(x) = A3 x^3 + A2 x^2 + A1 x + A0

  float A3 = a * a * b * (c - 1.0f);
  float A2 = 3.0f * a * a * d * (e - f);
  float A1 = 3.0f * a * b * d * (e - c * f);
  float A0 = a * d * d * (f * f - e * f) + b * b * d * (e - c * f);

  // If A3 = 0, curve is degenerate → no inflection
  if (abs(A3) < 1e-12f)
    return 0.f;

  // Normalize to monic cubic: x^3 + ax^2 + bx + c = 0
  float invA3 = 1.0f / A3;
  float an = A2 * invA3;
  float bn = A1 * invA3;
  float cn = A0 * invA3;

  // Depressed cubic t^3 + p t + q = 0  with x = t - a/3
  float an_3 = an / 3.0f;
  float p = bn - an * an_3;
  float q = 2.0f * an * an * an / 27.0f - an * bn / 3.0f + cn;

  float half_q = 0.5f * q;
  float Delta = half_q * half_q + (p / 3.0f) * (p / 3.0f) * (p / 3.0f);

  // Real root output
  float t;

  if (Delta >= 0.f) {
    float sqrtD = sqrt(Delta);
    float u = (-half_q + sqrtD);
    float v = (-half_q - sqrtD);

    // Use signed cube root
    float u_c = renodx::math::SignPow(u, 1.0f / 3.0f);
    float v_c = renodx::math::SignPow(v, 1.0f / 3.0f);
    t = u_c + v_c;
  } else {
    // 3 real roots → trig branch
    float m = 2.0f * sqrt(-p / 3.0f);
    float angle = acos((-half_q) / sqrt(-(p * p * p) / 27.0f));
    t = m * cos(angle / 3.0f);
  }

  float x = t - an_3;

  // Only meaningful inflection is positive
  return max(x, 0.f);
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
  // float sNeg = renodx::math::SignSqrt(-centerNeg);
  // Compiler computes centerNeg is always negative, making CopySign impossible
  float sNeg = sign(-centerNeg);
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

  // Max root seems to be always be the right one
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

Uncharted2ExtendedConfig CreateUncharted2ExtendedConfig(float coeffs[6], float white_precompute) {
  float pivot_point = FindThirdDerivativeRoot(coeffs[0], coeffs[1], coeffs[2], coeffs[3], coeffs[4], coeffs[5]);
  // pivot_point = (pivot_point + FindSecondDerivativeRoot(coeffs[0], coeffs[1], coeffs[2], coeffs[3], coeffs[4], coeffs[5])) / 2.f;

  return CreateUncharted2ExtendedConfig(pivot_point, coeffs, white_precompute);
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

float ReinhardDerivative(float x, float peak) {
  return (peak * peak) / ((x + peak) * (x + peak));
}

// Analytic (Cardano) solution of x^3 + 2P x^2 + P^2 x - P^2 = 0
// Finds the real pivot x such that f'(x) = x,
// where f(x) = (peak * x) / (x + peak)
// and      f'(x) = peak^2 / (x + peak)^2.
//
// For peak > 0 this returns the unique positive real root.
float ReinhardFindPivot(float peak) {
  float P = peak;
  float P2 = P * P;
  float P3 = P2 * P;
  float P4 = P3 * P;
  float P5 = P4 * P;

  // This follows Wolfram’s structure:
  // A = 2 P^3 + 27 P^2 + 3 sqrt(3) sqrt(4 P^5 + 27 P^4)
  float innerSqrt = 4.0f * P5 + 27.0f * P4;  // 4 P^5 + 27 P^4
  float sqrtTerm = 3.0f * sqrt(3.0f) * sqrt(innerSqrt);
  float A = 2.0f * P3 + 27.0f * P2 + sqrtTerm;

  // Cardano cube roots
  float cbrtA = pow(A, 1.0f / 3.0f);
  float cbrt2 = pow(2.0f, 1.0f / 3.0f);

  // Wolfram expression:
  // x = 1/3 * ( (2^(1/3) P^2)/A^(1/3) + A^(1/3)/2^(1/3) - 2P )
  float term1 = (cbrt2 * P2) / cbrtA;
  float term2 = cbrtA / cbrt2;

  float x = (term1 + term2 - 2.0f * P) / 3.0f;
  return x;
}

#define APPLY_EXTENDED_GENERATOR(T)                           \
  T ApplyReinhardPlus(                                        \
      T x, T base, float peak = 1.f) {                        \
    float pivot_x = ReinhardFindPivot(peak);                  \
    float pivot_y = renodx::tonemap::Reinhard(pivot_x, peak); \
    float slope = ReinhardDerivative(pivot_x, peak);          \
    T offset = pivot_y - slope * pivot_x;                     \
                                                              \
    T extended = slope * x + offset; /* match slope */        \
                                                              \
    return lerp(base, extended, step(pivot_x, x));            \
  }

APPLY_EXTENDED_GENERATOR(float)
APPLY_EXTENDED_GENERATOR(float3)
#undef APPLY_EXTENDED_GENERATOR

float ReinhardExtendedDerivative(float x, float white_max = 1000.f / 203.f, float peak = 1.f) {
  float p = peak, w = white_max;
  float w2 = w * w;

  // numerator: p^2 * (x(2p + x) + w^2)
  float num = p * p * (x * (2.f * p + x) + w2);

  // denominator: w^2 * (p + x)^2
  float px = p + x;
  float den = w2 * px * px;

  return num / den;
}

// Cube root that works for negative values too
float Cbrt(float v) {
  return (v >= 0.0f) ? pow(v, 1.0f / 3.0f) : -pow(-v, 1.0f / 3.0f);
}

// Solve f'(x) = x for the ReinhardExtended luminance curve:
// f(x)  = (p * x / (p + x)) * (1 + (p * x) / (w * w))
// f'(x) = p^2 * (w^2 + x * (2p + x)) / (w^2 * (p + x)^2)
// Returns the Cardano analytic pivot x(p, w).
float ReinhardExtendedFindPivot(float peak, float white_max) {
  float p = peak;
  float w = white_max;
  float p2 = p * p;
  float p3 = p2 * p;
  float w2 = w * w;

  // Cubic: a x^3 + b x^2 + c x + d = 0
  float a = w2;
  float b = 2.0f * p * w2 - p2;
  float c = p2 * w2 - 2.0f * p3;
  float d = -p2 * w2;

  // Normalize: x^3 + A x^2 + B x + C = 0
  float A = b / a;
  float B = c / a;
  float C = d / a;

  // Depressed cubic: t^3 + p_c t + q_c = 0 via x = t - A/3
  float A2 = A * A;
  float A3 = A2 * A;

  float p_c = B - (A2 / 3.0f);
  float q_c = 2.0f * A3 / 27.0f - A * B / 3.0f + C;

  float half_q = 0.5f * q_c;
  float disc = half_q * half_q + (p_c * p_c * p_c) / 27.0f;

  // Clamp tiny negative due to FP error
  disc = max(disc, 0.0f);

  float sqrt_disc = sqrt(disc);

  float u = -half_q + sqrt_disc;
  float v = -half_q - sqrt_disc;

  float u_c = renodx::math::Cbrt(u);
  float v_c = renodx::math::Cbrt(v);

  float t = u_c + v_c;

  // Back-substitute: x = t - A / 3
  float x = t - A / 3.0f;
  return x;
}

#define APPLY_REINHARD_EXTENDED_PLUS_GENERATOR(T)                                \
  T ApplyReinhardExtendedPlus(                                                   \
      T x, T base, float white_max, float peak = 1.f) {                          \
    float pivot_x = ReinhardExtendedFindPivot(peak, white_max);                  \
                                                                                 \
    float pivot_y = renodx::tonemap::ReinhardExtended(pivot_x, white_max, peak); \
                                                                                 \
    float slope = ReinhardExtendedDerivative(pivot_x, white_max, peak);          \
                                                                                 \
    /* Line passing through (pivot_x, pivot_y) with matching slope */            \
    T offset = pivot_y - slope * pivot_x;                                        \
    T extended = slope * x + offset;                                             \
                                                                                 \
    return lerp(base, extended, step(pivot_x, x));                               \
  }

APPLY_REINHARD_EXTENDED_PLUS_GENERATOR(float)
APPLY_REINHARD_EXTENDED_PLUS_GENERATOR(float3)
#undef APPLY_REINHARD_EXTENDED_PLUS_GENERATOR

float3 HueAndChrominance1ReferenceColorOKLab(
    float3 incorrect_color, float3 reference_color,
    float hue_correct_strength = 0.f,
    float chrominance_correct_strength = 0.f) {
  if (hue_correct_strength != 0.0 || chrominance_correct_strength != 0.0) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color);
    const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);

    float chrominance_current = length(perceptual_new.yz);
    float chrominance_ratio = 1.0;

    if (hue_correct_strength != 0.0) {
      const float chrominance_pre = chrominance_current;
      perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, hue_correct_strength);
      const float chrominancePost = length(perceptual_new.yz);
      chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
      chrominance_current = chrominancePost;
    }

    if (chrominance_correct_strength != 0.0) {
      const float reference_chrominance = length(reference_oklab.yz);
      float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
      chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_correct_strength);
    }
    perceptual_new.yz *= chrominance_ratio;

    incorrect_color = renodx::color::bt709::from::OkLab(perceptual_new);
    incorrect_color = renodx::color::bt709::clamp::AP1(incorrect_color);
  }
  return incorrect_color;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    // value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1.f
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

// highlights
#if 0
  // const float highlights = 1 + (sign(config.highlights - 1) * pow(abs(config.highlights - 1), 10.f));
  // float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);
#else
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
#endif
  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config, float per_channel_blowout = 0.f) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f || per_channel_blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f || per_channel_blowout != 0.f) {
      const float3 reference_oklab = renodx::color::oklab::from::BT709(hue_reference_color);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.f;

      if (config.hue_correction_strength != 0.f) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, config.hue_correction_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (per_channel_blowout != 0.f) {
        const float reference_chrominance = length(reference_oklab.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, per_channel_blowout);
      }
      perceptual_new.yz *= chrominance_ratio;
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 ApplyUserGrading(float3 ungraded) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_DECHROMA;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  // float3 hue_shift_source = renodx::tonemap::ReinhardPiecewise(ungraded, 4.f, 0.5f);
  float3 hue_shift_source = renodx::tonemap::ExponentialRollOff(ungraded, 0.5f, 4.f);

  float y = renodx::color::y::from::BT709(ungraded);
  float3 graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, y, cg_config);
  graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded, hue_shift_source, y, cg_config, RENODX_TONE_MAP_PER_CHANNEL_BLOWOUT);

  return graded;
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float diffuse_nits, float peak_nits) {
  input = renodx::color::bt2020::from::BT709(input);
  input = max(0, input);

  const float peak_ratio = peak_nits / diffuse_nits;
  float white_clip = max(100.f, peak_ratio * 1.5f);  // safeguard to prevent artifacts

  float max_channel = renodx::math::Max(input.r, input.g, input.b);

  float max_pq = renodx::color::pq::Encode(max_channel, diffuse_nits);
  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, diffuse_nits);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled_pq = renodx::tonemap::HermiteSplineRolloff(max_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float mapped_max = renodx::color::pq::Decode(scaled_pq, diffuse_nits);
  mapped_max = min(mapped_max, peak_ratio);

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 0.f);
  float3 output = input * scale;
  output = renodx::color::bt709::from::BT2020(output);
  return output;
}
