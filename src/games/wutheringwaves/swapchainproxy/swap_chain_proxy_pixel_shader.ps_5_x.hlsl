#include "../common.hlsl"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float3 color = t0.Sample(s0, uv).rgb;

  CLAMP_IF_SDR(color);

  color = renodx::color::srgb::DecodeSafe(color);

  [branch]
  if (RENODX_SWAP_CHAIN_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
  } else if (RENODX_SWAP_CHAIN_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  }

  color *= RENODX_SWAP_CHAIN_SCALING_NITS;
  color = min(color, RENODX_SWAP_CHAIN_CLAMP_NITS);

  [branch]
  if (RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE == RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE) {  // HDR10
    [branch]
    if (RENODX_OUTPUT_COLOR_SPACE < 2.f) {  // BT.2020
      [branch]
      if (RENODX_OUTPUT_COLOR_SPACE == 0.f) {  // BT.709 -> BT.2020
        color = renodx::color::bt2020::from::BT709(color);
      } else {  // DCI-P3 -> BT.2020
        color = mul(wuwa::DCIP3_to_BT2020_MAT, color);
      }
    }

    color = saturate(renodx::draw::EncodeColor(color, RENODX_SWAP_CHAIN_ENCODING));
  } else {  // scRGB
    color = renodx::color::convert::ColorSpaces(color, RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE, RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE);
    color = max(0, color);
    color = renodx::color::convert::ColorSpaces(color, RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE, RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE);

    color = renodx::draw::EncodeColor(color, RENODX_SWAP_CHAIN_ENCODING);
  }

  return float4(color, 1.f);
}
