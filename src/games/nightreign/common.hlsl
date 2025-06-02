#include "./shared.h"

void HandleUIScale(inout float4 ui_color_gamma) {
  float3 ui_color_linear = renodx::color::gamma::DecodeSafe(ui_color_gamma.rgb);

  ui_color_linear = renodx::color::correct::GammaSafe(ui_color_linear);
  ui_color_linear *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

  ui_color_gamma.rgb = renodx::color::gamma::EncodeSafe(ui_color_linear.rgb);
}

float4 HandleFinalEncoding(float3 final_color_linear) {
  float3 bt2020_color = renodx::color::bt2020::from::BT709(final_color_linear.rgb);
  float3 pq_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);
  return float4(pq_color, 1.f);
}
