#ifndef RENODX_SHADERS_TONEMAP_NAKA_RUSHTON_HLSL_
#define RENODX_SHADERS_TONEMAP_NAKA_RUSHTON_HLSL_

#include "../math.hlsl"

namespace renodx {
namespace tonemap {

// S-potentials from luminosity units in the retina of fish (Cyprinidae)
// K.I.Naka, W.A.H.Rushton
// First published : 01 August 1966
// https://doi.org/10.1113/jphysiol.1966.sp008003

// Desmos reference:
// https://www.desmos.com/calculator/pu2vzff8t0
//
// f(x) = p * x^n / (x^n + k^n)
//
// Input Anchored Naka-Rushton form:
// f(x) = p * x^n / (x^n + a^(n-1) * (p - a))
// a = anchor_in
// n    = c * p / (p - a)
//
// Input-Output Anchored Naka-Rushton form:
// f(x) = p * z * x^n / (x^n * z + g^n * (p-g))
// z = anchor_out
// where:
// - p is the asymptotic peak,
// - a is the anchored input and z is the anchored output, f(a) = z,
// - c controls the response exponent.

float NakaRushton(float x, float peak = 1.0f, float anchor_in = 0.18f, float anchor_out = 0.18f, float cone_response_exponent = 1.f) {
  float peak_minus_anchor_out = peak - anchor_out;
  float n = cone_response_exponent * peak / peak_minus_anchor_out;
  float a_n = pow(anchor_in, n);
  float sign = renodx::math::Sign(x);
  float x_n = pow(abs(x), n);
  float x_n_anchor_out = x_n * anchor_out;
  float num = peak * x_n_anchor_out;
  float den = mad(a_n, peak_minus_anchor_out, x_n_anchor_out);
  return sign * num / den;
}

float3 NakaRushton(float3 x, float3 peak = 1.0f, float3 anchor_in = 0.18f, float3 anchor_out = 0.18f, float cone_response_exponent = 1.f) {
  float3 peak_minus_anchor_out = peak - anchor_out;
  float3 n = cone_response_exponent * peak / peak_minus_anchor_out;
  float3 a_n = pow(anchor_in, n);
  float3 sign = renodx::math::Sign(x);
  float3 x_n = pow(abs(x), n);
  float3 x_n_anchor_out = x_n * anchor_out;
  float3 num = peak * x_n_anchor_out;
  float3 den = mad(a_n, peak_minus_anchor_out, x_n_anchor_out);
  return sign * num / den;
}

float3 NakaRushton(float3 x, float peak = 1.0f, float anchor_in = 0.18f, float anchor_out = 0.18f, float cone_response_exponent = 1.0f) {
  return NakaRushton(
      x,
      float3(peak, peak, peak),
      float3(anchor_in, anchor_in, anchor_in),
      float3(anchor_out, anchor_out, anchor_out),
      cone_response_exponent);
}

}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_NAKA_RUSHTON_HLSL_
