#ifndef RENODX_ROGUE_UI_WHITE_HLSLI_
#define RENODX_ROGUE_UI_WHITE_HLSLI_

#include "./shared.h"

float3 ScaleRogueUI(float3 color, float game_nits, float ui_nits, float encoding) {
  // The output pass applies game white to the composite. Adjust UI in linear
  // light so its own white level survives that common output conversion.
  float scale = ui_nits / max(game_nits, 1.f);
  return renodx::draw::EncodeColor(renodx::draw::DecodeColor(max(color, 0.f), encoding) * scale, encoding);
}

float3 ScaleRogueUI(float3 color) {
  return ScaleRogueUI(color, RENODX_DIFFUSE_WHITE_NITS, RENODX_GRAPHICS_WHITE_NITS, RENODX_SWAP_CHAIN_DECODING);
}

#endif
