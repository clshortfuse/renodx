#include "./shared.h"

Texture2D<float4> g_applyHdrCodingSrcTmpBuffer : register(t0, space0);
SamplerState g_applyHdrCodingSamplerState : register(s0, space0);

cbuffer g_applyHdrCodingConstants : register(b0, space1) {
  float4 m_params;
};

struct PSInput {
  float4 SV_Position : SV_POSITION;
  float2 TEXCOORD : TEXCOORD;
};

float4 main(PSInput IN)
    : SV_Target {
  float3 inputColor = g_applyHdrCodingSrcTmpBuffer.Sample(g_applyHdrCodingSamplerState, IN.TEXCOORD).xyz;

  // Linearize with 2.2 Gamma
  float3 linearColor = renodx::math::SafePow(inputColor, 2.2);

  // Custom paper white values based on the brightness setting (m_params.x)
  float paperWhite = m_params.x;
  // Check brightness levels and adjust paper white accordingly
  if (m_params.x == 220) {
    paperWhite = 203.0f;  // Brightness level 3
  } else if (m_params.x == 260) {
    paperWhite = 250.0f;  // Brightness level 4
  }

  // Convert from BT.709 to BT.2020 PQ with paper white based on brightness slider
  float3 bt2020Color = renodx::color::bt2020::from::BT709(linearColor);
  float3 pqEncodedColor = renodx::color::pq::from::BT2020(bt2020Color, paperWhite);

  // Return the final PQ-encoded color with alpha set to 1.0
  return float4(pqEncodedColor, 1.0);
}
