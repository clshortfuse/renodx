#ifndef RENODX_SHADERS_TONEMAP_RUSHTON_HENRY_HLSL_
#define RENODX_SHADERS_TONEMAP_RUSHTON_HENRY_HLSL_

#include "../math.hlsl"

namespace renodx {
namespace tonemap {

// The intensity-response function for the human red and green cone mechanisms
// in the living eye
// G.H. Henry, W.A.H. Rushton
// First published : 01 July 1968
// https://doi.org/10.1113/jphysiol.1968.sp008649
//
// Desmos reference:
// https://www.desmos.com/calculator/yjlwm2mb4c
//
// Classical Rushton-Henry availability form:
// f(x) = p * k^n / (x^n + k^n)
//
// Input-output anchored Rushton-Henry form:
// f(x) = p * a^n * z / (x^n * (p - z) + a^n * z)
// a = anchor_in
// z = anchor_out
// n = c * p / z
//
// where:
// - p is the zero-input peak, f(0) = p,
// - a is the anchored input and z is the anchored output, f(a) = z,
// - c controls the response exponent.
//
// This is the decreasing complement of the anchored Naka-Rushton form:
// RushtonHenry(x, p, a, z, c) = p - NakaRushton(x, p, a, p - z, c)
//
// The simple bleaching availability law
//   f(x) = 1 / (1 + x / k)
// is the special case:
//   RushtonHenry(x, 1.0f, k, 0.5f, 0.5f)

float RushtonHenry(float x, float peak = 1.0f, float anchor_in = 0.18f, float anchor_out = 0.18f, float cone_response_exponent = 1.0f) {
  float n = cone_response_exponent * peak / anchor_out;
  float a_n = pow(anchor_in, n);
  float x_n = pow(max(x, 0.0f), n);
  float num = peak * a_n * anchor_out;
  float den = mad(x_n, peak - anchor_out, a_n * anchor_out);
  return num / den;
}

float3 RushtonHenry(float3 x, float3 peak = 1.0f, float3 anchor_in = 0.18f, float3 anchor_out = 0.18f, float cone_response_exponent = 1.0f) {
  float3 n = cone_response_exponent * peak / anchor_out;
  float3 a_n = pow(anchor_in, n);
  float3 x_n = pow(max(x, 0.0f), n);
  float3 num = peak * a_n * anchor_out;
  float3 den = mad(x_n, peak - anchor_out, a_n * anchor_out);
  return num / den;
}

float3 RushtonHenry(float3 x, float peak = 1.0f, float anchor_in = 0.18f, float anchor_out = 0.18f, float cone_response_exponent = 1.0f) {
  return RushtonHenry(
      x,
      float3(peak, peak, peak),
      float3(anchor_in, anchor_in, anchor_in),
      float3(anchor_out, anchor_out, anchor_out),
      cone_response_exponent);
}

}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_RUSHTON_HENRY_HLSL_
