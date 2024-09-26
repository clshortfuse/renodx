#include "./shared.h"

Texture2D<float4> g_applyHdrCodingSrcTmpBuffer : register(t0, space0);
SamplerState g_applyHdrCodingSamplerState : register(s0, space0);

cbuffer g_applyHdrCodingConstants : register(b0, space1)
{
    float4 m_params;
};

struct PSInput
{
    float4 SV_Position : SV_POSITION;
    float2 TEXCOORD : TEXCOORD;
};

float4 main(PSInput IN) : SV_Target
{
    float3 inputColor = g_applyHdrCodingSrcTmpBuffer.Sample(g_applyHdrCodingSamplerState, IN.TEXCOORD).xyz;
    
    // Linearize with 2.2 Gamma
    float3 linearColor = renodx::math::SafePow(inputColor, 2.2);

    // if (injectedData.toneMapType) { // Apply DICE Tonemap
        // const float peakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;
        // const float paperWhite = m_params.x / renodx::color::srgb::REFERENCE_WHITE;
        // const float highlightsShoulderStart = paperWhite;

        // linearColor *= paperWhite;
        // linearColor = renodx::tonemap::dice::BT709(linearColor, peakWhite, highlightsShoulderStart);
        // linearColor /= paperWhite;
    // }
    
    // Convert from BT.709 to BT.2020 PQ with paper white based on brightness slider
    float3 bt2020Color = renodx::color::bt2020::from::BT709(linearColor);
    float3 pqEncodedColor = renodx::color::pq::from::BT2020(bt2020Color, m_params.x);

    // Return the final PQ-encoded color with alpha set to 1.0
    return float4(pqEncodedColor, 1.0);
}