// The scene mapper already applies the selected peak before LUT encoding.
// Keep the output transport from imposing a second scene-peak ceiling.
#define RENODX_SWAP_CHAIN_CLAMP_NITS 10000.f
#include "../shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 color = t0.Sample(s0, uv);
  color = renodx::math::ZeroNaN(color);
  renodx::draw::Config config = renodx::draw::BuildConfig();
  if (config.tone_map_type == 0.f) {
    color.rgb = saturate(color.rgb);
    config.swap_chain_clamp_nits = config.graphics_white_nits;
  }
  return float4(renodx::draw::SwapChainPass(color.rgb, uv, config), 1.f);
}
