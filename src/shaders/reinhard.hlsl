#ifndef SRC_SHADERS_REINHARD_HLSL_
#define SRC_SHADERS_REINHARD_HLSL_

namespace renodx {
namespace tonemap {

float Reinhard(float x, float peak = 1.f) {
  return x / (x / peak + 1.f);
}

float3 Reinhard(float3 x, float peak = 1.f) {
  return x / (x / peak + 1.f);
}

float ReinhardExtended(float color, float white_max = 1000.f / 203.f, float peak = 1.f) {
  return Reinhard(color, peak) * (1.f + (peak * color) / (white_max * white_max));
}

float3 ReinhardExtended(float3 color, float white_max = 1000.f / 203.f, float peak = 1.f) {
  return Reinhard(color, peak) * (1.f + (peak * color) / (white_max * white_max));
}

float ComputeReinhardScale(float channel_max = 1.f, float channel_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  return (channel_max * (channel_min * gray_out + channel_min - gray_out))
         / (gray_in * (gray_out - channel_max));
}

float ReinhardScalable(float x, float x_max = 1.f, float x_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  float exposure = ComputeReinhardScale(x_max, x_min, gray_in, gray_out);
  return mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);
}

float3 ReinhardScalable(float3 x, float x_max = 1.f, float x_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  float exposure = ComputeReinhardScale(x_max, x_min, gray_in, gray_out);
  return mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);
}

float ComputeReinhardExtendableScale(float w = 100.f, float p = 1.f, float m = 0.f, float x = 0.18f, float y = 0.18f) {
  // y = (sx / (sx + 1) * (1 + (psx)/(sw*sw))
  // solve for s (scale)
  // Min not currently supported
  return p * (w * w * y - p * x) / (w * w * x * (p - y));
}

float ReinhardScalableExtended(float x, float white_max = 100.f, float x_max = 1.f, float x_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  float exposure = ComputeReinhardScale(x_max, x_min, gray_in, gray_out);
  float extended = ReinhardExtended(x * exposure, white_max * exposure, x_max);
  return min(extended, x_max);
}

float3 ReinhardScalableExtended(float3 x, float white_max = 100.f, float x_max = 1.f, float x_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  float exposure = ComputeReinhardScale(x_max, x_min, gray_in, gray_out);
  float3 extended = ReinhardExtended(x * exposure, white_max * exposure, x_max);
  return min(extended, x_max);
}

}
}

#endif  // SRC_SHADERS_TONEMAP_HLSL_