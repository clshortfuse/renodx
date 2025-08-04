#include "./shared.h"

half Sign(half x) {
  return mad(saturate(mad(x, 65504.h, 0.5h)), 2.h, -1.h);
}

half3 ComputeCAS(half3 a, half3 b, half3 c, half3 d, half3 e, half strength) {
  half max_value;
  half min_value;
  bool use_luminance = true;
  if (use_luminance) {
    float a_y = renodx::color::y::from::BT709(a);
    float b_y = renodx::color::y::from::BT709(b);
    float c_y = renodx::color::y::from::BT709(c);
    float d_y = renodx::color::y::from::BT709(d);
    float e_y = renodx::color::y::from::BT709(e);
    max_value = max(max(max(max(a_y, b_y), c_y), d_y), e_y);
    min_value = min(min(min(min(a_y, b_y), c_y), d_y), e_y);
  } else {
    // use green
    max_value = max(max(max(max(a.g, b.g), c.g), d.g), e.g);
    min_value = min(min(min(min(a.g, b.g), c.g), d.g), e.g);
  }

  if (max_value == 0.h) return c;
  half value_0 = min(min_value, (1.0h - max_value)) * (1.0h / max_value);

  half value_1 = strength * Sign(value_0) * sqrt(abs(value_0));
  half value_2 = 1.0h / (value_1 * 4.0h + 1.0h);

  half3 computed = ((value_1 * (a + b + d + e) + c) * value_2);
  computed = renodx::color::bt709::clamp::BT2020(computed);
  return computed;
}

// float bethesdaSRGB(float color, float a, float gamma) {
//   float d = (2.f * color - 1.f) * a;
//   float e = d / (sqrt(d * d) + 1.f);
//   float f = e * (2.f * a / sqrt(a * a + 1.f)) + 0.5f;

//   return max(pow(_x, 1.f / gamma) * 1.055f - 0.055f, 0.0f);
// }
