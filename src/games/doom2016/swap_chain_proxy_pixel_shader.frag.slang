#version 450

[[vk::binding(0, 0)]]
Texture2D sourceTexture : register(t0);

[[vk::binding(1, 0)]]
SamplerState sourceSampler : register(s0);

float4 main(float4 position : SV_Position, float2 uv : TEXCOORD0)
    : SV_Target
{
    // The DOOM output replacement already produced BT.2020/ST.2084 code
    // values in the RGBA16F game-facing clone. This pass intentionally does
    // no tone mapping, inverse tone mapping, gamut conversion, or re-encoding.
    return float4(sourceTexture.Sample(sourceSampler, uv).rgb, 1.0);
}
