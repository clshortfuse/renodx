#ifndef RENODX_SHADERS_COLOR_CONVERT_HLSL
#define RENODX_SHADERS_COLOR_CONVERT_HLSL

#include "./rgb.hlsl"

namespace renodx {
namespace color {
namespace convert {
static const float COLOR_SPACE_UNKNOWN = -1;
static const float COLOR_SPACE_NONE = -1;
static const float COLOR_SPACE_BT709 = 0;
static const float COLOR_SPACE_BT2020 = 1.f;
static const float COLOR_SPACE_AP1 = 2.f;

float3 ColorSpaceFromBT709(float3 color, float color_space) {
  [branch]
  if (color_space == COLOR_SPACE_BT2020) {
    color = renodx::color::bt2020::from::BT709(color);
  } else {
    [branch]
    if (color_space == COLOR_SPACE_AP1) {
      color = renodx::color::ap1::from::BT709(color);
    } else {
      color = color;
    }
  }
  return color;
}

float3 ColorSpaceFromBT2020(float3 color, float color_space) {
  [branch]
  if (color_space == COLOR_SPACE_BT709) {
    color = renodx::color::bt709::from::BT2020(color);
  } else {
    [branch]
    if (color_space == COLOR_SPACE_AP1) {
      color = renodx::color::ap1::from::BT2020(color);
    } else {
      color = color;
    }
  }
  return color;
}

float3 ColorSpaceFromAP1(float3 color, float color_space) {
  [branch]
  if (color_space == COLOR_SPACE_BT709) {
    color = renodx::color::bt709::from::AP1(color);
  } else {
    [branch]
    if (color_space == COLOR_SPACE_BT2020) {
      color = renodx::color::bt2020::from::AP1(color);
    } else {
      color = color;
    }
  }
  return color;
}

float3 ColorSpaces(float3 color, float input_color_space, float output_color_space) {
  [branch]
  if (input_color_space == COLOR_SPACE_BT709) {
    color = ColorSpaceFromBT709(color, output_color_space);
  } else {
    [branch]
    if (input_color_space == COLOR_SPACE_BT2020) {
      color = ColorSpaceFromBT2020(color, output_color_space);
    } else {
      [branch]
      if (input_color_space == COLOR_SPACE_AP1) {
        color = ColorSpaceFromAP1(color, output_color_space);
      } else {
        color = color;
      }
    }
  }
  return color;
}

float Luminance(float3 color, float color_space) {
  [branch]
  if (color_space == COLOR_SPACE_BT2020) {
    return renodx::color::y::from::BT2020(color);
  } else {
    [branch]
    if (color_space == COLOR_SPACE_AP1) {
      return renodx::color::y::from::AP1(color);
    } else {
      return renodx::color::y::from::BT709(color);
    }
  }
}

}  // namespace convert
}  // namespace color
}  // namespace renodx

#endif  // RENODX_SHADERS_COLOR_CONVERT_HLSL_