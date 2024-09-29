#ifndef SRC_SHADERS_DEBUG_HLSL_
#define SRC_SHADERS_DEBUG_HLSL_

#include "./color.hlsl"

namespace renodx {
namespace debug {
namespace graph {
static const uint SIZE = 512;
static const uint PADDING = 8;
static const uint BINS = SIZE - (2 * PADDING);

struct Config {
  bool draw;
  uint y;
  float x;
  float3 color;
  float peak_nits;
  float scale;
};

Config DrawStart(float2 position, float3 color_input, float width, float height, float peak_nits, float scale = 80.f) {
  Config config = { false, 0, 0, color_input, peak_nits, scale };
  uint2 offset = uint2(
      position.x - (width - SIZE),
      SIZE - position.y);
  if (offset.x >= 0 && offset.y >= 0) {
    config.color = float3(0.15f, 0.15f, 0.15f);
    if (
        offset.x >= PADDING
        && offset.y >= PADDING
        && offset.x < (SIZE - PADDING)
        && offset.y < (SIZE - PADDING)) {
      config.draw = true;
      uint graph_x = offset.x - PADDING;
      config.y = offset.y - PADDING;

      // From 0.01 to Peak nits (in log)
      const float x_min = log10(0.01 / scale);
      const float x_max = log10(10000.f / scale);
      const float x_range = x_max - x_min;
      config.x = (float(graph_x) / float(BINS)) * (x_range) + x_min;
      config.x = pow(10.f, config.x);
      config.color = float3(config.x, config.x, config.x);
    }
  }
  return config;
}

Config DrawStart(float2 position, float3 color_input, Texture2D<float3> texture_untonemapped, float peak_nits, float scale = 80.f) {
  float width;
  float height;
  texture_untonemapped.GetDimensions(width, height);
  return DrawStart(position, color_input, width, height, peak_nits, scale);
}

Config DrawStart(float2 position, float3 color_input, Texture2D<float4> texture_untonemapped, float peak_nits, float scale = 80.f) {
  float width;
  float height;
  texture_untonemapped.GetDimensions(width, height);
  return DrawStart(position, color_input, width, height, peak_nits, scale);
}

float3 DrawEnd(float3 color_input, inout Config config) {
  // From 0.01 to Peak nits (in log)
  const float y_min = log10(0.01);
  const float y_max = log10(10000.f);
  const float y_range = y_max - y_min;
  float y_value = (float(config.y) / float(BINS)) * (y_range) + y_min;
  const float peak_nits = config.peak_nits;
  const float scale = config.scale;
  y_value = pow(10.f, y_value);
  y_value /= scale;
  float y_output = renodx::color::y::from::BT709(color_input);
  if (y_output > y_value) {
    if (y_output < 0.18f) {
      return float3(0.3f, 0, 0.3f);
    }
    if (y_output > peak_nits / scale) {
      return float3(0, 0.3f, 0.3f);
    }
    return max(0.05f, y_value);
  }

  if (config.x < 0.18f) {
    return float3(0, 0.3f, 0);
  }
  if (y_value >= peak_nits / scale) {
    return float3(0, 0, 0.3f);
  }
  return 0.05f;
}
}  // namespace graph
}  // namespace debug
}  // namespace renodx

#endif  // SRC_SHADERS_DEBUG_HLSL_
