#include "./shared.h"

// ReShade Before UI: converts the back buffer (output encoding written by the
// swapchain proxy pixel shader, after ReShade effects) back into the RenoDX
// intermediate encoding of the float back buffer clone. Inverse of
// SwapChainPass without its peak/gamut clamps, which the final output applies
// again anyway.
Texture2D t0 : register(t0);

float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0) : SV_TARGET {
  renodx::draw::Config config = renodx::draw::BuildConfig();

  float3 color = t0.Load(int3(vpos.xy, 0)).rgb;

  [branch] if (config.swap_chain_output_preset == renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10) {
    config.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
    config.swap_chain_encoding = renodx::draw::ENCODING_PQ;
  }
  else if (config.swap_chain_output_preset == renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_SCRGB) {
    config.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT709;
    config.swap_chain_encoding = renodx::draw::ENCODING_SCRGB;
  }

  color = renodx::draw::DecodeColor(color, config.swap_chain_encoding);

  const bool gamma_corrected = config.swap_chain_gamma_correction == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2
                               || config.swap_chain_gamma_correction == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4;
  const float working_color_space = gamma_corrected ? renodx::color::convert::COLOR_SPACE_BT709
                                                    : config.swap_chain_decoding_color_space;
  color = renodx::color::convert::ColorSpaces(color, config.swap_chain_encoding_color_space, working_color_space);

  color /= config.swap_chain_scaling_nits;

  if (config.swap_chain_gamma_correction == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) {
    color = renodx::color::correct::GammaSafe(color, true, 2.2f);
  } else if (config.swap_chain_gamma_correction == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) {
    color = renodx::color::correct::GammaSafe(color, true, 2.4f);
  }
  color = renodx::color::convert::ColorSpaces(color, working_color_space, config.swap_chain_decoding_color_space);

  color = renodx::draw::EncodeColor(color, config.swap_chain_decoding);

  return float4(color, 1.f);
}
