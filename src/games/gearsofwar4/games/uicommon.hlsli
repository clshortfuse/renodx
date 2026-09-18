#include "../shared.h"

// PQ Decode -> get BT709 color -> srgb Encode
// Used for handling UI thats supposed to run in sRGB, but PQ because of forcing HDR
float3 PQDecodeSrgbEncode(float x, float y, float z) {
  float3 color = float3(x, y, z);
  color.rgb = renodx::color::pq::DecodeSafe(color.rgb, RENODX_DIFFUSE_WHITE_NITS);
  color.rgb = renodx::color::bt709::from::BT2020(color.rgb);
  color.rgb = renodx::color::srgb::EncodeSafe(color.rgb);

  return color;
}

float3 PQDecodeSrgbEncode(float3 color) {
  return PQDecodeSrgbEncode(color.x, color.y, color.z);
}

float3 RestoreLumiannce(float3 color) {
  if (RENODX_GAMMA_CORRECTION) {
    color = renodx::color::gamma::DecodeSafe(color);  // Decode
    color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    color = renodx::color::gamma::EncodeSafe(color);  // Encode
  } else if (!RENODX_GAMMA_CORRECTION) {              // if sRGB/no Gamma Correction
    color = renodx::color::srgb::DecodeSafe(color);
    color *= RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    color = renodx::color::srgb::EncodeSafe(color);
  }

  return color;
}
