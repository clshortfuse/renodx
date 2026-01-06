#ifndef SRC_SHADERS_COLOR_ACESCCT_HLSL_
#define SRC_SHADERS_COLOR_ACESCCT_HLSL_

#include "../math.hlsl"

namespace renodx {
namespace color {
namespace acescct {

// https://docs.acescentral.com/specifications/acescct/#acescct
// Avoid using, since not a 0-1 encoding:
// "ACEScct uses values above 1.0 and below 0.0 to encode the entire range of ACES values."

float Encode(float ap1_channel) {
  if (ap1_channel <= 0.0078125f) {
    return 10.5402377416545f * ap1_channel + 0.0729055341958355;
  } else {
    return (log2(ap1_channel) + 9.72f) / 17.52f;
  }
}

float Decode(float aces_cct_data) {
  if (aces_cct_data <= 0.155251141552511f) {
    return (aces_cct_data - 0.0729055341958355) / 10.5402377416545f;
  } else if (aces_cct_data < ((log2(65504.f) + 9.72f) / 17.52f)) {
    return pow(2.f, aces_cct_data * 17.52f - 9.72f);
  } else {
    return 65504.f;  // FLT16_MAX
  }
}

float3 Encode(float3 ap1_color) {
  return float3(Encode(ap1_color.r), Encode(ap1_color.g), Encode(ap1_color.b));
}

float3 Decode(float3 aces_cct_data) {
  return float3(Decode(aces_cct_data.r), Decode(aces_cct_data.g), Decode(aces_cct_data.b));
}

// Already safe, just for namespace parity
float3 EncodeSafe(float3 color) {
  return Encode(color);
}

float3 DecodeSafe(float3 aces_cct_data) {
  return Decode(aces_cct_data);
}

}  // namespace acescct
}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_ACESCCT_HLSL_