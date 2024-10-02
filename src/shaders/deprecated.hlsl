#ifndef SRC_SHADERS_DEPRECATED_HLSL_
#define SRC_SHADERS_DEPRECATED_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"

namespace renodx {
namespace color {
namespace srgb {
namespace from {
/// @deprecated
float BT709(float channel) {
  return renodx::color::srgb::Encode(channel);
}
/// @deprecated
float3 BT709(float3 color) {
  return renodx::color::srgb::Encode(color);
}
/// @deprecated - Use Encode
float4 BT709(float4 color) {
  return renodx::color::srgb::Encode(color);
}
}  // namespace from
}  // namespace srgb

namespace bt709 {
namespace from {
/// @deprecated
float SRGB(float channel) {
  return renodx::color::srgb::Decode(channel);
}
/// @deprecated
float3 SRGB(float3 color) {
  return renodx::color::srgb::Decode(color);
}
/// @deprecated - Use Encode
float4 SRGB(float4 color) {
  return renodx::color::srgb::Decode(color);
}
/// @deprecated - Use Encode
float4 SRGBA(float4 color) {
  return renodx::color::srgba::Decode(color);
}
}
}

namespace srgba {
namespace from {
/// @deprecated - Use Decode
float4 BT709(float4 color) {
  return renodx::color::srgba::Decode(color);
}
}  // namespace from
}  // namespace srgba
}  // namespace color

namespace math {
/// @deprecated
float3 SafePow(float3 color, float exponent) {
  return PowSafe(color, exponent);
}

/// @deprecated
float1 SafePow(float color, float exponent) {
  return PowSafe(color, exponent);
}
}

}  // namespace renodx

#endif  // SRC_SHADERS_DEPRECATED_HLSL_