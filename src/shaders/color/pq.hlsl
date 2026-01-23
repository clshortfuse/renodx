#ifndef SRC_SHADERS_COLOR_PQ_HLSL_
#define SRC_SHADERS_COLOR_PQ_HLSL_

#include "../math.hlsl"

namespace renodx {
namespace color {
namespace pq {
static const float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
static const float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
static const float C1 = 3424.f / 4096.f;            // 0.8359375f;
static const float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
static const float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;

float Encode(float color, float scaling = 10000.f) {
  color *= (scaling / 10000.f);
  float y_m1 = pow(color, M1);
  return pow((C1 + C2 * y_m1) / (1.f + C3 * y_m1), M2);
}

float3 Encode(float3 color, float scaling = 10000.f) {
  color *= (scaling / 10000.f);
  float3 y_m1 = pow(color, M1);
  return pow((C1 + C2 * y_m1) / (1.f + C3 * y_m1), M2);
}

float Decode(float color, float scaling = 10000.f) {
  float e_m12 = pow(color, 1.f / M2);
  float out_color = pow(max(0, e_m12 - C1) / (C2 - C3 * e_m12), 1.f / M1);
  return out_color * (10000.f / scaling);
}

float3 Decode(float3 color, float scaling = 10000.f) {
  float3 e_m12 = pow(color, 1.f / M2);
  float3 out_color = pow(max(0, e_m12 - C1) / (C2 - C3 * e_m12), 1.f / M1);
  return out_color * (10000.f / scaling);
}

float3 EncodeSafe(float3 color, float scaling = 10000.f) {
  return Encode(max(0, color), scaling);
}

float3 DecodeSafe(float3 color, float scaling = 10000.f) {
  return Decode(max(0, color), scaling);
}

}  // namespace pq
}  // namespace color
}  // namespace renodx
#endif  // SRC_SHADERS_COLOR_PQ_HLSL_