#include "../shared.h"

void InverIntermediateToSRGB(inout float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  color = renodx::draw::InvertIntermediatePass(color);
  color = renodx::color::srgb::EncodeSafe(color);
}

void RenderIntermediateFromSRGB(inout float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  color = renodx::color::srgb::DecodeSafe(color);
  color = renodx::draw::RenderIntermediatePass(color);
}
