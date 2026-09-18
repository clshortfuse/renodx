//
// Call of Duty: World at War
//
// LAST BLOOM PASS - HDR / INVERSION SAFE
//
// This version keeps the legacy bloom draw safe even when it is the last
// bloom/scene shader.
//
// Key rule:
//   The actual source may contain HDR RGB > 1.0,
//   but THIS OLD BLOOM DRAW must never OUTPUT RGB > 1.0.
//
// Instead of per-channel saturate(), which changes hue, this shader uses
// max-channel normalization:
//
//     (4.0, 1.5, 0.25)
//          ↓
//     (1.0, 0.375, 0.0625)
//
// That preserves RGB ratios/hue and prevents old inverse/complement-style D3D9
// blend math from seeing >1.0 source values.
//
// Bloom Strength:
//   0%   = no bloom RGB
//   100% = original safe bloom
//   >100% = stronger bloom, but still bounded to <=1.0
//

#include "./shared.h"

sampler2D colorMapSampler : register(s0);
sampler2D floatZSampler   : register(s4);

float4 featherParms : register(c5);

struct PixelInput
{
    float4 color      : COLOR0;
    float3 texCoord   : TEXCOORD0;
    float4 depthCoord : TEXCOORD1;
};


// ============================================================================
// Safety
// ============================================================================

float SafeFinite1(float value)
{
    if (value != value)
        return 0.0f;

    if (abs(value) > 65504.0f)
        return 0.0f;

    return value;
}

float SafePositive1(float value)
{
    return max(
        SafeFinite1(value),
        0.0f
    );
}

float3 SafePositive3(float3 value)
{
    return float3(
        SafePositive1(value.r),
        SafePositive1(value.g),
        SafePositive1(value.b)
    );
}

float4 SafePositive4(float4 value)
{
    return float4(
        SafePositive1(value.r),
        SafePositive1(value.g),
        SafePositive1(value.b),
        SafePositive1(value.a)
    );
}


// ============================================================================
// Hue-preserving legacy-safe conversion
// ============================================================================
//
// Values <=1 are unchanged.
//
// If any RGB channel is >1, divide all channels by the same max-channel value.
// This keeps the color's channel ratios instead of whitening the highlight.
//

float3 NormalizeHDRToLegacy3(float3 color)
{
    color =
        SafePositive3(
            color
        );

    float peak =
        max(
            color.r,
            max(
                color.g,
                color.b
            )
        );

    if (peak > 1.0f)
    {
        color /=
            peak;
    }

    return color;
}


// ============================================================================
// Effective bounded Bloom Strength
// ============================================================================
//
// Plain:
//
//     color *= strength;
//     NormalizeHDRToLegacy3(color);
//
// can make >100% strengths look almost identical.
//
// This modifies the SAFE peak instead:
//
//   strength <= 1:
//       linear reduction.
//
//   strength > 1:
//       increase toward 1.0 without crossing it.
//
// Example, base peak = 0.8:
//
//   0%   -> 0.0
//   50%  -> 0.4
//   100% -> 0.8
//   200% -> 0.96
//

float3 ApplySafeBloomStrength(
    float3 color,
    float strength)
{
    color =
        NormalizeHDRToLegacy3(
            color
        );

    strength =
        SafePositive1(
            strength
        );

    float peak =
        max(
            color.r,
            max(
                color.g,
                color.b
            )
        );

    if (peak <= 1e-6f || strength <= 0.0f)
    {
        return 0.0f.xxx;
    }

    float newPeak;

    if (strength <= 1.0f)
    {
        newPeak =
            peak
            * strength;
    }
    else
    {
        newPeak =
            1.0f
            - pow(
                max(
                    1.0f - peak,
                    0.0f
                ),
                strength
            );
    }

    float scale =
        newPeak
        / max(
            peak,
            1e-6f
        );

    return NormalizeHDRToLegacy3(
        color
        * scale
    );
}


// ============================================================================
// Main
// ============================================================================

float4 main(PixelInput input) : COLOR0
{
    // ------------------------------------------------------------------------
    // Preserve original depth access.
    // ------------------------------------------------------------------------

    float depth =
        SafeFinite1(
            tex2Dproj(
                floatZSampler,
                input.depthCoord
            ).x
        );

    float depthDifference =
        SafeFinite1(
            abs(depth)
            - input.texCoord.z
        );

    float originalFeather =
        saturate(
            SafeFinite1(
                depthDifference
                * featherParms.x
            )
        );

    // Keep feather bypassed.
    // Reconstructing it previously produced the dark / inverted center.


    // ------------------------------------------------------------------------
    // Sample source.
    // ------------------------------------------------------------------------

    float4 sampledColor =
        tex2D(
            colorMapSampler,
            input.texCoord.xy
        );

    sampledColor =
        SafePositive4(
            sampledColor
        );


    // ------------------------------------------------------------------------
    // Convert ONLY this bloom-driving RGB copy into the safe legacy domain.
    //
    // Do NOT use per-channel saturate(sampledColor.rgb).
    // ------------------------------------------------------------------------

    float3 sampledRGB =
        NormalizeHDRToLegacy3(
            sampledColor.rgb
        );

    float sampledAlpha =
        saturate(
            sampledColor.a
        );


    // ------------------------------------------------------------------------
    // Vertex modulation.
    // ------------------------------------------------------------------------

    float3 vertexRGB =
        NormalizeHDRToLegacy3(
            input.color.rgb
        );

    float vertexAlpha =
        saturate(
            SafePositive1(
                input.color.a
            )
        );


    // ------------------------------------------------------------------------
    // Original color modulation.
    // ------------------------------------------------------------------------

    float3 colorRGB =
        SafePositive3(
            sampledRGB
            * vertexRGB
        );

    float finalIntensity =
        saturate(
            sampledAlpha
            * vertexAlpha
        );


    // ------------------------------------------------------------------------
    // Original bloom RGB.
    // ------------------------------------------------------------------------

    float3 baseBloom =
        SafePositive3(
            colorRGB
            * finalIntensity
        );


    // ------------------------------------------------------------------------
    // RenoDX Bloom Strength.
    // ------------------------------------------------------------------------

    float bloomStrength =
        SafePositive1(
            RENODX_BLOOM_BRIGHTNESS
        );

    float3 outputColor =
        ApplySafeBloomStrength(
            baseBloom,
            bloomStrength
        );


    // ------------------------------------------------------------------------
    // FINAL ANTI-INVERSION GUARANTEE.
    //
    // Whatever happens above, oC0.rgb can NEVER exceed 1.0.
    //
    // This is the important part if this is the final bloom draw and the game
    // applies an SDR-era inverse/complement blend factor after the pixel shader.
    // ------------------------------------------------------------------------

    outputColor =
        NormalizeHDRToLegacy3(
            outputColor
        );


    // Preserve the original alpha/intensity semantics.
    return float4(
        outputColor,
        finalIntensity
    );
}
