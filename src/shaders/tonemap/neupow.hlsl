#ifndef RENODX_SHADERS_TONEMAP_NEUPOW_HLSL_
#define RENODX_SHADERS_TONEMAP_NEUPOW_HLSL_

#include "../color.hlsl"

namespace renodx {
namespace tonemap {

// Neutwo but pow().
// Less optimized for more flexibility.
// https://www.desmos.com/calculator/693lgrzm2v
//
// power = 2: Neutwo.
// power = 1: Reinhard.
// power > 2: Similar to late shoulder ExponentialRolloff / GTSport.
// power < 1: Super compressed & mid gray will noticably shift.

float Neupow(float x, float power) {
  // return x / pow(pow(x, power) + 1, rcp(power));

  float log2_x = log2(x);
  return exp2(log2_x - log2(1.0f + exp2(power * log2_x)) * rcp(power));
}

float Neupow(float x, float peak, float power) {
  // return (x * peak) / pow(pow(x, power) + pow(peak, power), rcp(power));

  float p_over_x_pow_a = exp2(power * (log2(peak) - log2(x)));
  return peak * rcp(exp2(log2(1.0f + p_over_x_pow_a) * rcp(power)));
}

float Neupow(float x, float peak, float power, float clip) {
  // return (clip * peak * x) / pow(pow(x, power) * (pow(clip, power) - pow(peak, power)) + (pow(clip, power) * pow(peak, power)), rcp(power));

  float log2_x = log2(x);
  float x_pow_a = exp2(power * log2_x);
  float k = exp2(-power * log2(peak)) - exp2(-power * log2(clip));
  return exp2(log2_x - log2(k * x_pow_a + 1.0f) * rcp(power));
}

namespace neupow {

float ComputeBT709Scale(float3 color, float power) {
  float y = renodx::color::y::from::BT709(color);
  float new_y = renodx::tonemap::Neupow(y, power);
  float scale = y != 0 ? (new_y / y) : 1.f;
  return scale;
}

float ComputeBT709Scale(float3 color, float peak, float power) {
  float y = renodx::color::y::from::BT709(color);
  float new_y = renodx::tonemap::Neupow(y, peak, power);
  float scale = y != 0 ? (new_y / y) : 1.f;
  return scale;
}

float ComputeBT709Scale(float3 color, float peak, float clip, float power) {
  float y = renodx::color::y::from::BT709(color);
  float new_y = renodx::tonemap::Neupow(y, peak, clip, power);
  float scale = y != 0 ? (new_y / y) : 1.f;
  return scale;
}

float ComputeBT2020Scale(float3 color, float power) {
  float y = renodx::color::y::from::BT2020(color);
  float new_y = renodx::tonemap::Neupow(y, power);
  float scale = y != 0 ? (new_y / y) : 1.f;
  return scale;
}

float ComputeBT2020Scale(float3 color, float peak, float power) {
  float y = renodx::color::y::from::BT2020(color);
  float new_y = renodx::tonemap::Neupow(y, peak, power);
  float scale = y != 0 ? (new_y / y) : 1.f;
  return scale;
}

float ComputeBT2020Scale(float3 color, float peak, float clip, float power) {
  float y = renodx::color::y::from::BT2020(color);
  float new_y = renodx::tonemap::Neupow(y, peak, clip, power);
  float scale = y != 0 ? (new_y / y) : 1.f;
  return scale;
}

float ComputeMaxChannelScale(float3 color, float power) {
  float max_channel = renodx::math::Max(abs(color.rgb));
  float new_max = renodx::tonemap::Neupow(max_channel, power);
  float scale = max_channel != 0 ? (new_max / max_channel) : 1.f;
  return scale;
}

float ComputeMaxChannelScale(float3 color, float peak, float power) {
  float max_channel = renodx::math::Max(abs(color.rgb));
  float new_max = renodx::tonemap::Neupow(max_channel, peak, power);
  float scale = max_channel != 0 ? (new_max / max_channel) : 1.f;
  return scale;
}

float ComputeMaxChannelScale(float3 color, float peak, float clip, float power) {
  float max_channel = renodx::math::Max(abs(color.rgb));
  float new_max = renodx::tonemap::Neupow(max_channel, peak, clip, power);
  float scale = max_channel != 0 ? (new_max / max_channel) : 1.f;
  return scale;
}

float3 BT709(float3 color, float power) {
  return color * ComputeBT709Scale(color, power);
}

float3 BT709(float3 color, float peak, float power) {
  return color * ComputeBT709Scale(color, peak, power);
}

float3 BT709(float3 color, float peak, float clip, float power) {
  return color * ComputeBT709Scale(color, peak, clip, power);
}

float3 BT2020(float3 color, float power) {
  return color * ComputeBT2020Scale(color, power);
}

float3 BT2020(float3 color, float peak, float power) {
  return color * ComputeBT2020Scale(color, peak, power);
}

float3 BT2020(float3 color, float peak, float clip, float power) {
  return color * ComputeBT2020Scale(color, peak, clip, power);
}

float3 MaxChannel(float3 color, float power) {
  return color * ComputeMaxChannelScale(color, power);
}

float3 MaxChannel(float3 color, float peak, float power) {
  return color * ComputeMaxChannelScale(color, peak, power);
}

float3 MaxChannel(float3 color, float peak, float clip, float power) {
  return color * ComputeMaxChannelScale(color, peak, clip, power);
}

float3 PerChannel(float3 color, float3 power) {
  return float3(renodx::tonemap::Neupow(color.r, power.r),
                renodx::tonemap::Neupow(color.g, power.g),
                renodx::tonemap::Neupow(color.b, power.b));
}

float3 PerChannel(float3 color, float3 peak, float3 power) {
  return float3(renodx::tonemap::Neupow(color.r, peak.r, power.r),
                renodx::tonemap::Neupow(color.g, peak.g, power.g),
                renodx::tonemap::Neupow(color.b, peak.b, power.b));
}

float3 PerChannel(float3 color, float3 peak, float3 clip, float3 power) {
  return float3(renodx::tonemap::Neupow(color.r, peak.r, clip.r, power.r),
                renodx::tonemap::Neupow(color.g, peak.g, clip.g, power.g),
                renodx::tonemap::Neupow(color.b, peak.b, clip.b, power.b));
}

} // namespace neupow

// TODO: inverse?

} // namespace tonemap
} // namespace renodx

#endif // RENODX_SHADERS_TONEMAP_NEUPOW_HLSL_