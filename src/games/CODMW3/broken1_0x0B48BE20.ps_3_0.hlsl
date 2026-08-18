// Diagnostic version: output nothing.
//
// Every pixel is discarded with clip(), so this shader does not modify
// the destination render target.
//
// This is different from outputting black:
//   - Black output writes RGB 0.
//   - clip() performs no color or alpha write.
//
// If flashing still occurs, another shader/draw or stale render-target
// contents are responsible.

sampler2D colorMapSampler : register(s0);

float4 colorTintBase           : register(c3);
float4 colorTintDelta          : register(c5);
float4 colorTintQuadraticDelta : register(c6);
float4 colorBias               : register(c7);

struct PS_INPUT
{
    float4 vertexColor : COLOR0;
    float2 texcoord    : TEXCOORD0;
};

float4 main(PS_INPUT input) : COLOR0
{
    clip(-1.0f);

    // Unreachable, but required as the function's return value.
    return float4(0.0f, 0.0f, 0.0f, 0.0f);
}