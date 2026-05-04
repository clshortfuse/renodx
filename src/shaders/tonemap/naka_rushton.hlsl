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
// n = c * p / (p - a)
//
// Input-Output Anchored Naka-Rushton form:
// f(x) = p * z * x^n / (x^n * z + g^n * (p-g))
// z = anchor_out
//
// Optimized split:
// f_contrast(x) = z * (abs(x) / g)^n
// f_saturate(u) = (p * u) / (u + p - z)
// f(x) = sign(x) * f_saturate(f_contrast(x))
//
// White Clip
// f_{sw}(x)=\frac{p\left(x\left(f_{c}(w)^{2}-zp\right)+x^{2}(p-z)\right)}{x\left(f_{c}(w)^{2}-zp\right)+f_{c}(w)^{2}(p-z)}
//
// where:
// - p is the asymptotic peak,
// - g is the anchored input and z is the anchored output, f(g) = z,
// - c controls the response exponent.
// - w white clip point

float NakaRushton(float x, float peak = 1.0f, float anchor_in = 0.18f, float anchor_out = 0.18f, float cone_response_exponent = 1.0f) {
  float peak_minus_anchor_out = peak - anchor_out;
  float n = cone_response_exponent * peak / peak_minus_anchor_out;
  float contrasted = anchor_out * pow(abs(x) / anchor_in, n);
  float saturated = peak * contrasted / (contrasted + peak_minus_anchor_out);
  return renodx::math::CopySign(saturated, x);
}

float NakaRushton(float x, float peak, float anchor_in, float anchor_out, float cone_response_exponent, float white_clip) {
  float peak_minus_anchor_out = peak - anchor_out;
  float n = cone_response_exponent * peak / peak_minus_anchor_out;
  float contrasted = anchor_out * pow(abs(x) / anchor_in, n);
  float contrasted_squared = contrasted * contrasted;

  float white_contrasted = anchor_out * pow(white_clip / anchor_in, n);
  float white_contrasted_squared = white_contrasted * white_contrasted;

  float peak_times_anchor_out = peak * anchor_out;

  float optimization_1 = contrasted * (white_contrasted_squared - peak_times_anchor_out);
  float numerator = peak * mad(contrasted_squared, peak_minus_anchor_out, optimization_1);
  float denominator = mad(white_contrasted_squared, peak_minus_anchor_out, optimization_1);
  float saturated = numerator / denominator;
  return renodx::math::CopySign(saturated, x);
}

float3 NakaRushton(float3 x, float3 peak = 1.0f, float3 anchor_in = 0.18f, float3 anchor_out = 0.18f, float cone_response_exponent = 1.0f) {
  float3 peak_minus_anchor_out = peak - anchor_out;
  float3 n = cone_response_exponent * peak / peak_minus_anchor_out;
  float3 contrasted = anchor_out * pow(abs(x) / anchor_in, n);
  float3 saturated = peak * contrasted / (contrasted + peak_minus_anchor_out);
  return renodx::math::CopySign(saturated, x);
}

float3 NakaRushton(float3 x, float3 peak, float3 anchor_in, float3 anchor_out, float3 cone_response_exponent, float3 white_clip) {
  float3 peak_minus_anchor_out = peak - anchor_out;
  float3 n = cone_response_exponent * peak / peak_minus_anchor_out;
  float3 contrasted = anchor_out * pow(abs(x) / anchor_in, n);
  float3 contrasted_squared = contrasted * contrasted;

  float3 white_contrasted = anchor_out * pow(white_clip / anchor_in, n);
  float3 white_contrasted_squared = white_contrasted * white_contrasted;

  float3 peak_times_anchor_out = peak * anchor_out;

  float3 optimization_1 = contrasted * (white_contrasted_squared - peak_times_anchor_out);
  float3 numerator = peak * mad(contrasted_squared, peak_minus_anchor_out, optimization_1);
  float3 denominator = mad(white_contrasted_squared, peak_minus_anchor_out, optimization_1);
  float3 saturated = numerator / denominator;
  return renodx::math::CopySign(saturated, x);
}

float3 NakaRushton(float3 x, float peak = 1.0f, float anchor_in = 0.18f, float anchor_out = 0.18f, float cone_response_exponent = 1.0f) {
  return NakaRushton(
      x,
      float3(peak, peak, peak),
      float3(anchor_in, anchor_in, anchor_in),
      float3(anchor_out, anchor_out, anchor_out),
      cone_response_exponent);
}

float3 NakaRushton(float3 x, float peak, float anchor_in, float anchor_out, float cone_response_exponent, float white_clip) {
  return NakaRushton(
      x,
      float3(peak, peak, peak),
      float3(anchor_in, anchor_in, anchor_in),
      float3(anchor_out, anchor_out, anchor_out),
      cone_response_exponent,
      white_clip);
}

}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_NAKA_RUSHTON_HLSL_
