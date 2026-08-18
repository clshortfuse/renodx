// Human-readable replacement for DX9 pixel shader 0x039025BC.
//
// Goal:
//   - Keep the original cloud/flare size.
//   - Make it more transparent / less blob-like.
//   - Do not reduce the original RGB brightness.
//
// Original behavior:
//   1. Sample texture.
//   2. Multiply by particleCloudColor.
//   3. Output premultiplied RGB = rgb * alpha.
//   4. Output alpha = alpha.
//
// This version preserves the original premultiplied RGB brightness,
// but reduces alpha more in the faint halo than in the bright core.

sampler2D colorMapSampler : register(s0);

float4 particleCloudColor : register(c3);

// -----------------------------------------------------------------------------
// Tuning
// -----------------------------------------------------------------------------
// Lower = more transparent outer halo.
// 0.35 is a good starting point.
#define TRANSPARENCY_HALO_ALPHA_SCALE 0.35f
#define TRANSPARENCY_CORE_ALPHA_SCALE 0.70f

// Higher = changes how quickly the alpha transitions from halo to core.
#define TRANSPARENCY_CORE_POWER 1.50f

struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};

float Smooth01(float x)
{
    x = saturate(x);
    return x * x * (3.0f - 2.0f * x);
}

float ComputeTransparencyScale(float alpha)
{
    float coreMask = Smooth01(alpha);
    coreMask = pow(max(coreMask, 0.0f), TRANSPARENCY_CORE_POWER);

    return lerp(
        TRANSPARENCY_HALO_ALPHA_SCALE,
        TRANSPARENCY_CORE_ALPHA_SCALE,
        coreMask
    );
}

float4 main(PS_INPUT input) : COLOR0
{
    // Original sample and tint.
    float4 particle = tex2D(colorMapSampler, input.texcoord) * particleCloudColor;

    // Original alpha.
    float originalAlpha = saturate(particle.a);

    // Original premultiplied RGB output.
    float3 originalPremultipliedRGB = particle.rgb * originalAlpha;

    // Alpha-only transparency remap.
    float transparencyScale = ComputeTransparencyScale(originalAlpha);
    float adjustedAlpha = originalAlpha * transparencyScale;

    return float4(originalPremultipliedRGB, adjustedAlpha);
}
