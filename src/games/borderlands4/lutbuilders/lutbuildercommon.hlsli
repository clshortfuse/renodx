#include "../shared.h"

bool GenerateOutput(float r, float g, float b, inout float4 SV_Target) {

    if (RENODX_TONE_MAP_TYPE == 0) return false;  // off uses Engine.ini HDR

    float3 final_color = (float3(r, g, b));
    if (RENODX_TONE_MAP_TYPE == 4.f) final_color = saturate(final_color);
  
    float3 bt2020_color = renodx::color::bt2020::from::BT709(final_color);
    float3 encoded_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS) / 1.05f;

    SV_Target = float4(encoded_color, 0.f);
    return true;
  
}

float3 SignPow(float3 value, float3 exponent) {
  return float3(
      renodx::math::SignPow(value.x, exponent.x),
      renodx::math::SignPow(value.y, exponent.y),
      renodx::math::SignPow(value.z, exponent.z));
}