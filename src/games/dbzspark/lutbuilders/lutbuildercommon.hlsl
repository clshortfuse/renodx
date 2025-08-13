#include "../composite.hlsl"
#include "../shared.h"

static const float DEFAULT_PQ_DECODE = 100.f;  // 50%
static const float DEFAULT_BRIGHTNESS = 0.f;   // 50%
static const float DEFAULT_CONTRAST = 1.f;     // 50%
static const float DEFAULT_GAMMA = 1.f;        // 50%

bool GenerateOutput(float3 input_color, inout float4 SV_Target, bool is_hdr) {
  if (RENODX_TONE_MAP_TYPE == 0) return false;  // off uses Engine.ini HDR
  float3 final_color = input_color;
  if (RENODX_TONE_MAP_TYPE == 4.f) final_color = saturate(final_color);

  // final_color = renodx::color::bt709::clamp::BT2020(final_color);
  final_color = renodx::draw::RenderIntermediatePass(final_color);
  final_color *= 1.f / 1.05f;
  SV_Target = float4(final_color, 0.f);
  return true;
}

float3 SignPow(float3 value, float3 exponent) {
  return float3(
      renodx::math::SignPow(value.x, exponent.x),
      renodx::math::SignPow(value.y, exponent.y),
      renodx::math::SignPow(value.z, exponent.z));
}
