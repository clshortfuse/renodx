#include "../composite.hlsl"
#include "../shared.h"


bool GenerateOutput(float r, float g, float b, inout float4 SV_Target, bool is_hdr) {
  if (RENODX_TONE_MAP_TYPE == 0) return false;  // off uses Engine.ini HDR
  float3 final_color = (float3(r, g, b));
  if (RENODX_TONE_MAP_TYPE == 4.f) final_color = saturate(final_color);

  renodx::draw::Config outputConfig = GetIntermediateConfig(is_hdr);

  final_color = renodx::draw::RenderIntermediatePass(final_color, outputConfig);
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
