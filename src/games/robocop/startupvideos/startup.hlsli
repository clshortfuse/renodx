#include "../shared.h"

float3 ConvertStartupVideos(float3 color_srgb) {
  float3 color_linear = renodx::color::srgb::DecodeSafe(color_srgb);
  float3 color_pq = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color_linear), RENODX_DIFFUSE_WHITE_NITS);

  return color_pq;
}
