// Shader disabled: discards every pixel and writes nothing.
//
// Compatible with ps_3_0.

sampler2D colorMapSampler : register(s0);

struct PS_INPUT
{
    float4 color    : COLOR0;
    float2 texcoord : TEXCOORD0;
};

float4 main(PS_INPUT input) : COLOR0
{
    // Always discard the pixel.
    clip(-1.0f);

    // Required syntactically, but never reached.
    return float4(0.0f, 0.0f, 0.0f, 0.0f);
}