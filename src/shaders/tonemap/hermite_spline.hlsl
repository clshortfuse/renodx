#ifndef RENODX_SHADERS_TONEMAP_HERMITE_SPLINE_HLSL_
#define RENODX_SHADERS_TONEMAP_HERMITE_SPLINE_HLSL_

#include "../color.hlsl"
#include "../colorcorrect.hlsl"
#include "../math.hlsl"

namespace renodx {
namespace tonemap {

float HermiteSplineRolloff(float input, float target_white = 1.f, float max_white = 20.f) {
  float l_w = max_white;
  // float l_b = min_black;
  // float l_min = target_black;
  float l_max = target_white;
  float e_1 = renodx::math::Rescale(input, 0, l_w);
  // float min_lum = renodx::math::Rescale(l_min, l_b, l_w);
  float max_lum = renodx::math::Rescale(l_max, 0, l_w);
  float knee_start = 1.5f * max_lum - 0.5f;
  // float b = min_lum;
  float t_b = renodx::math::Rescale(e_1, knee_start, 1.f);

  // float p_e1 = (((2 * t_b * t_b * t_b) - (3 * t_b * t_b) + 1) * knee_start)
  //              + (((t_b * t_b * t_b) - (2 * t_b * t_b) + t_b) * (1.f - knee_start))
  //              + ((-(2 * t_b * t_b * t_b) + (3 * t_b * t_b)) * max_lum);
  float t_b_squared = t_b * t_b;
  float t_b_cubed = t_b_squared * t_b;
  float two_t_b_cubed = 2.f * t_b_cubed;
  float three_t_b_squared = 3.f * t_b_squared;
  float p_e1_h00 = (two_t_b_cubed - three_t_b_squared + 1.f);
  float p_e1_h10 = (t_b_cubed - 2.f * t_b_squared + t_b);
  float p_e1_h01 = (-two_t_b_cubed + three_t_b_squared);
  // float p_e1_h11 = (t_b_cubed - t_b_squared); // Not used since derivative is 0 at max_lum

  float p_e1 = p_e1_h00 * knee_start
               + p_e1_h10 * (1.f - knee_start)
               + p_e1_h01 * max_lum;

  float e_2 = (e_1 < knee_start) ? e_1 : p_e1;

  // float e_3 = e_2 + b * pow(1-e_2, 4);
  // float e_3a1 = (1 - e_2) * (1 - e_2);
  // float e_3a2 = e_3a1 * (1 - e_2);
  float e_3 = e_2;

  // Custom: clamp before lerp
  // e_3 = saturate(e_3);

  // float e_4 = lerp(l_b, l_w, e_3);
  float e_4 = l_w * e_3;

  return min(e_4, target_white);
}

// Hermite Spline Rolloff
// Must be normalized between 0-1
// https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-BT.2408-8-2024-PDF-E.pdf
float HermiteSplineRolloff(
    float input,
    float target_white,
    float max_white,
    float target_black,
    float min_black = 0.f) {
  float l_w = max_white;
  float l_b = min_black;
  float l_min = target_black;
  float l_max = target_white;
  float e_1 = renodx::math::Rescale(input, l_b, l_w);
  float min_lum = renodx::math::Rescale(l_min, l_b, l_w);
  float max_lum = renodx::math::Rescale(l_max, l_b, l_w);
  float knee_start = 1.5f * max_lum - 0.5f;
  float b = min_lum;
  float t_b = renodx::math::Rescale(e_1, knee_start, 1.f);

  // float p_e1 = (((2 * t_b * t_b * t_b) - (3 * t_b * t_b) + 1) * knee_start)
  //              + (((t_b * t_b * t_b) - (2 * t_b * t_b) + t_b) * (1.f - knee_start))
  //              + ((-(2 * t_b * t_b * t_b) + (3 * t_b * t_b)) * max_lum);
  float t_b_squared = t_b * t_b;
  float t_b_cubed = t_b_squared * t_b;
  float two_t_b_cubed = 2.f * t_b_cubed;
  float three_t_b_squared = 3.f * t_b_squared;
  float p_e1_h00 = (two_t_b_cubed - three_t_b_squared + 1.f);
  float p_e1_h10 = (t_b_cubed - 2.f * t_b_squared + t_b);
  float p_e1_h01 = (-two_t_b_cubed + three_t_b_squared);
  // float p_e1_h11 = (t_b_cubed - t_b_squared); // Not used since derivative is 0 at max_lum

  float p_e1 = p_e1_h00 * knee_start
               + p_e1_h10 * (1.f - knee_start)
               + p_e1_h01 * max_lum;

  float e_2 = (e_1 < knee_start) ? e_1 : p_e1;

  // float e_3 = e_2 + b * pow(1-e_2, 4);
  float e_3a1 = (1 - e_2) * (1 - e_2);
  float e_3a2 = e_3a1 * (1 - e_2);
  float e_3 = e_2 + (b * e_3a2);

  // Custom: clamp before lerp
  e_3 = saturate(e_3);

  float e_4 = lerp(l_b, l_w, e_3);
  return e_4;
}

float HermiteSplineLuminanceRolloff(float luminance, float target_white, float max_white, float target_black, float min_black, float nits = 100.f) {
  float luminance_pq = renodx::color::pq::Encode(luminance, nits);
  float target_white_pq = renodx::color::pq::Encode(target_white, nits);
  float max_white_pq = renodx::color::pq::Encode(max_white, nits);
  float target_black_pq = renodx::color::pq::Encode(target_black, nits);
  float min_black_pq = renodx::color::pq::Encode(min_black, nits);

  float scaled = HermiteSplineRolloff(luminance_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float unpq_scaled = renodx::color::pq::Decode(scaled, nits);
  return unpq_scaled;
}

float3 HermiteSplineLuminanceRolloff(float3 color, float target_white, float max_white, float target_black, float min_black = 0.f, float nits = 100.f) {
  float y = renodx::color::y::from::BT709(color);
  float new_y = HermiteSplineLuminanceRolloff(y, target_white, max_white, target_black, min_black, nits);
  float3 new_color = renodx::color::correct::Luminance(color, y, new_y);
  return new_color;
}

float3 HermiteSplinePerChannelRolloff(float3 input, float target_white, float max_white, float target_black, float min_black = 0.f, float nits = 100.f) {
  float3 input_pq = renodx::color::pq::Encode(input, nits);
  float target_white_pq = renodx::color::pq::Encode(target_white, nits);
  float max_white_pq = renodx::color::pq::Encode(max_white, nits);
  float target_black_pq = renodx::color::pq::Encode(target_black, nits);
  float min_black_pq = renodx::color::pq::Encode(min_black, nits);

  float3 scaled = float3(
      HermiteSplineRolloff(input_pq.r, target_white_pq, max_white_pq, target_black_pq, min_black_pq),
      HermiteSplineRolloff(input_pq.g, target_white_pq, max_white_pq, target_black_pq, min_black_pq),
      HermiteSplineRolloff(input_pq.b, target_white_pq, max_white_pq, target_black_pq, min_black_pq));

  float3 unpq_scaled = renodx::color::pq::Decode(scaled, nits);
  return unpq_scaled;
}

float HermiteSplineLuminanceRolloff(float luminance, float target_white = 1.f, float max_white = 20.f) {
  if (luminance == 0) return 0;
  return exp2(HermiteSplineRolloff(log2(luminance), log2(target_white), log2(max_white)));
}

float3 HermiteSplineLuminanceRolloff(float3 color, float target_white = 1.f, float max_white = 20.f) {
  float y = renodx::color::y::from::BT709(color);
  float new_y = HermiteSplineLuminanceRolloff(y, target_white, max_white);
  float3 new_color = renodx::color::correct::Luminance(color, y, new_y);
  return new_color;
}

float3 HermiteSplinePerChannelRolloff(float3 input, float target_white = 1.f, float max_white = 20.f) {
  float target_white_log2 = log2(target_white);
  float max_white_log2 = log2(max_white);
  float3 scaled = float3(
      input.r == 0 ? 0 : exp2(HermiteSplineRolloff(log2(input.r), target_white_log2, max_white_log2)),
      input.g == 0 ? 0 : exp2(HermiteSplineRolloff(log2(input.g), target_white_log2, max_white_log2)),
      input.b == 0 ? 0 : exp2(HermiteSplineRolloff(log2(input.b), target_white_log2, max_white_log2)));
  return scaled;
}

}
}

#endif  // RENODX_SHADERS_TONEMAP_HERMITE_SPLINE_HLSL_