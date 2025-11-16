#include "./shared.h"

// Skybox shader
sampler2D DiffuseMapSampler : register(s0);
float4 Levels : register(c0); // x = offset, y/z/w = scaling factors

struct PS_IN
{
    float4 texcoord : TEXCOORD;
    float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN input) : COLOR
{
    // --- Sample skybox texture ---
    float4 skySample = tex2D(DiffuseMapSampler, input.texcoord1);

    // --- Compute level adjustments ---
    float4 levelFactor = input.texcoord * Levels.z;  // Scale by Levels.z
    levelFactor.w = levelFactor.w * Levels.x - Levels.x; // Apply offset
    levelFactor.w = levelFactor.w + 1;                // Final adjustment for alpha

    // --- Apply the level scaling to RGB and alpha ---
    float3 finalRGB = skySample.rgb * levelFactor.xyz * Custom_Skybox_Intensity;
    float  finalA   = skySample.a * levelFactor.w;

    return float4(finalRGB, finalA);
}
