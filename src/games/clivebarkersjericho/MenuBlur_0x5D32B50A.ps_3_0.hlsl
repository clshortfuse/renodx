#include "./shared.h"

// Menu Blur Shader
sampler2D ActualFrameSampler : register(s0);
float g_Value : register(c15);                  // Blend factor
float g_Scale : register(c16);                  // Scale for sample offsets
float2 g_avSampleOffsets[15] : register(c0);    // Predefined blur offsets

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    float4 accumulated = float4(0,0,0,0);
    float4 originalSample = tex2D(ActualFrameSampler, texcoord);

    float scale = g_Scale.x;

    // Accumulate the 15 samples
    [unroll]
    for (int i = 0; i < 15; i++)
    {
        float2 sampleUV = texcoord + g_avSampleOffsets[i] * scale;
        accumulated += tex2D(ActualFrameSampler, sampleUV);
    }

    // Add the 16th sample
    float4 lastSample = tex2D(ActualFrameSampler, texcoord);
    accumulated += lastSample;

    // Apply 1/16 factor and subtract original
    float blurFactor = 0.0625;
    float4 blur = accumulated * blurFactor - lastSample;

    // Blend with original
    float4 outputColor = (g_Value.x * Custom_UI_Menu_Blur_Intensity) * blur + lastSample;

    return outputColor;
}
