#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  // Used for OpenGL support
  uv.y = lerp(uv.y, 1.0 - uv.y, shader_injection.custom_flip_uv_y);

  renodx::draw::Config config = renodx::draw::BuildConfig();
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // Preserve extended BT.709 through final output. Compress to the HDR
    // container gamut instead of clipping negative Rec.709 channels.
    config.swap_chain_clamp_color_space = renodx::color::convert::COLOR_SPACE_NONE;
    config.swap_chain_compress_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
  }
  return float4(renodx::draw::SwapChainPass(t0.Sample(s0, uv).rgb, config), 1.f);
}
