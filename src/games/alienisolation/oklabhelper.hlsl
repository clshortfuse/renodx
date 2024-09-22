#include "./shared.h"

float3 lightnessCorrect(float3 incorrect_color, float3 correct_color) {
  float3 correct_lch = renodx::color::oklch::from::BT709(correct_color);
  float3 incorrect_lch = renodx::color::oklch::from::BT709(incorrect_color);
  incorrect_lch[0] = correct_lch[0];
  float3 color = renodx::color::bt709::from::OkLCh(incorrect_lch);
  return color;
}