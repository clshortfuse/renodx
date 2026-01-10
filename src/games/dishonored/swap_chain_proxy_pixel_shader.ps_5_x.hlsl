#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  // renodx::draw::Config config = renodx::draw::BuildConfig();
  // if (shader_injection.hdr_toggle == 0.f) {
  //   config.swap_chain_clamp_color_space = renodx::color::convert::COLOR_SPACE_NONE;
  //   config.swap_chain_compress_color_space = renodx::color::convert::COLOR_SPACE_BT709;
  //   config.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
  //   config.swap_chain_encoding = renodx::draw::ENCODING_SRGB;
  //   config.swap_chain_scaling_nits = 1.f;
  //   config.swap_chain_clamp_nits = 1.f;
  // }
  // return float4(renodx::draw::SwapChainPass(t0.Sample(s0, uv).xyz, uv, config), 0.f);

  float4 outputColor = t0.Sample(s0, uv);
  return renodx::draw::SwapChainPass(outputColor);
  //return renodx::draw::SwapChainPass(t0.Sample(s0, uv));
}
