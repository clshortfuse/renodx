#include "../common.hlsli"

// rl_hdr_output_transform, scRGB: decodes the sRGB scene+UI buffer and scales by Hdr_paper_white / 80.

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float hdr_paper_white : packoffset(c000.x);
};

SamplerState s5_space1 : register(s5, space1);

float4 main(
    noperspective float4 SV_Position : SV_Position,
    linear float2 TEXCOORD : TEXCOORD)
    : SV_Target {
  float4 _6 = t0.Sample(s5_space1, float2(TEXCOORD.x, TEXCOORD.y));

  [branch] if (SR_TONE_MAP_ACTIVE) {
    return float4(renodx::draw::SwapChainPass(_6.rgb), 1.f);
  }

  return float4(renodx::color::srgb::Decode(max(_6.rgb, 0.f)) * (hdr_paper_white * 0.012500000186264515f), 1.f);
}
