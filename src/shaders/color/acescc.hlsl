#ifndef SRC_SHADERS_COLOR_ACESCC_HLSL_
#define SRC_SHADERS_COLOR_ACESCC_HLSL_

#include "../math.hlsl"

namespace renodx {
namespace color {
namespace acescc {

// https://docs.acescentral.com/specifications/acescc/#acescc
// Avoid using, since not a 0-1 encoding:
// "ACEScc, however, uses values above 1.0 and below 0.0 to encode the entire range of ACES values."

float Encode(float ap1_channel) {
  if (ap1_channel <= 0) {
    // -0.35844748858447484
    return (log2(pow(2.f, -16.f)) + 9.72f) / 17.52f;
  } else if (ap1_channel < pow(2.f, -15.f)) {
    return (log2(pow(2.f, -16.f) + ap1_channel * 0.5f) + 9.72f) / 17.52f;
  } else {
    return (log2(pow(2.f, -16.f) + ap1_channel) + 9.72f) / 17.52f;
  }
}

float Decode(float aces_cc_data) {
  if (aces_cc_data <= ((9.72f - 15.f) / 17.52)) {
    // <= -0.3013698630136986
    return (pow(2.f, aces_cc_data * 17.52f - 9.72f) - pow(2.f, -16.f)) * 2.f;
  } else if (aces_cc_data < ((log2(65504.f) + 9.72f) / 17.52f)) {
    return pow(2.f, aces_cc_data * 17.52f - 9.72f);
  } else {
    return 65504.f;  // FLT16_MAX
  }
}

float3 Encode(float3 ap1_color) {
  return float3(Encode(ap1_color.r), Encode(ap1_color.g), Encode(ap1_color.b));
}

float3 Decode(float3 aces_cc_data) {
  return float3(Decode(aces_cc_data.r), Decode(aces_cc_data.g), Decode(aces_cc_data.b));
}

// Already safe, just for namespace parity
float3 EncodeSafe(float3 color) {
  return Encode(color);
}

float3 DecodeSafe(float3 aces_cc_data) {
  return Decode(aces_cc_data);
}

}  // namespace acescc
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_ACESCC_HLSL_