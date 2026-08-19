#include "./common.hlsli"

float4 SwapchainPass(float4 color) {
  if (RENODX_GAMMA_CORRECTION) {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb);
  } else {
    color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  }
  color.rgb = renodx::color::bt2020::from::BT709(color.rgb);
  color.rgb = renodx::color::pq::EncodeSafe(color.rgb, RENODX_GRAPHICS_WHITE_NITS);
  return color;
}
