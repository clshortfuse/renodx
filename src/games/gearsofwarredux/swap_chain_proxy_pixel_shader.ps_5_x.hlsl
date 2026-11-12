#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float4 main(float4 vpos : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET {
  float4 color = t0.Sample(s0, uv);
  [branch]
  if (RENODX_SWAP_CHAIN_OUTPUT_PRESET != renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_SCRGB
      || any(color.rgb < 0.f)) return renodx::draw::SwapChainPass(color);

  // Positive BT.709 RGB needs no BT.2020 gamut-compression round trip. Keep
  // the shared gamma decode, UI-white scaling, peak bound and scRGB encoding.
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.swap_chain_output_preset = renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_NONE;
  return float4(renodx::draw::SwapChainPass(color.rgb, config), 1.f);
}
