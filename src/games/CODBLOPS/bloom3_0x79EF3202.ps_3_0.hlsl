// Full-size, lower-coverage flare/particle sprite replacement for 0x79EF3202.
// Keeps the existing flare RGB brightness while reducing visual solidity.
//
// Original:
//   textureColor *= vertexColor;
//   output.rgb = textureColor.rgb * textureColor.a;
//   output.a   = textureColor.a;
//
// Adjustments:
//   - Original alpha footprint is retained instead of being raised to a high
//     power for spatial shrinking.
//   - FLARE_BRIGHTNESS remains unchanged.
//   - WHITE_BASE_AMOUNT adds a general white bias to the whole flare.
//   - WHITE_CORE_AMOUNT makes the brighter center even whiter.
//   - Luminance is preserved after whitening so the flare does not become
//     unintentionally brighter just from the color shift.
//   - Output remains premultiplied-alpha compatible.
//   - No final RGB saturation is applied.

#define FLARE_BRIGHTNESS   0.50f
#define ALPHA_POWER        5.00f

// Density/coverage controls. The RGB core remains unchanged at density 1.0.
// OUTPUT_ALPHA_COVERAGE changes destination coverage only; it does not multiply
// the source RGB, which is what allows the flare to look more transparent
// without lowering the existing FLARE_BRIGHTNESS value.
#define FLARE_HALO_DENSITY       0.30f
#define FLARE_CORE_DENSITY       0.30f
#define FLARE_DENSITY_FULL       0.60f
#define OUTPUT_ALPHA_COVERAGE    0.40f

#define WHITE_BASE_AMOUNT  0.15f
#define WHITE_CORE_AMOUNT  1.15f
#define WHITE_CORE_START   0.50f
#define WHITE_CORE_FULL    1.00f

sampler2D colorMapSampler : register(s0);

struct PS_INPUT
{
    float4 color    : COLOR0;
    float2 texcoord : TEXCOORD0;
};

float FlareLuminance(float3 color)
{
    return dot(color, float3(0.2126f, 0.7152f, 0.0722f));
}

float FlareSafeDivide(float numerator, float denominator)
{
    return numerator / max(denominator, 0.000001f);
}

float FlareSmooth01(float value)
{
    value = saturate(value);
    return value * value * (3.0f - 2.0f * value);
}

float FlareSmoothRangeMask(float value, float startValue, float fullValue)
{
    return FlareSmooth01(
        FlareSafeDivide(value - startValue, fullValue - startValue)
    );
}

float4 main(PS_INPUT input) : COLOR0
{
    float4 textureColor = tex2D(colorMapSampler, input.texcoord);

    float3 flareColor = textureColor.rgb * input.color.rgb;

    float originalAlpha = textureColor.a * input.color.a;
    originalAlpha = saturate(originalAlpha);

    // Preserve the original alpha footprint instead of raising alpha to a high
    // power, which made the visible flare physically smaller. Use alpha only to
    // derive a density ramp: faint pixels remain present at a lower density and
    // the hot center smoothly returns to full density.
    float densityCoreMask = FlareSmoothRangeMask(
        originalAlpha,
        0.0f,
        FLARE_DENSITY_FULL
    );

    float flareDensity = lerp(
        FLARE_HALO_DENSITY,
        FLARE_CORE_DENSITY,
        densityCoreMask
    );

    float shapedAlpha = originalAlpha;

    // Preserve the previous whitening response without using that response to
    // shrink the actual flare footprint.
    float whiteningAlpha = pow(
        max(originalAlpha, 0.0f),
        ALPHA_POWER
    );

    // Make the flare whiter.
    // The whole flare gets some whitening, and the brighter core gets more.
    float coreWhiteMask = FlareSmoothRangeMask(
        whiteningAlpha,
        WHITE_CORE_START,
        WHITE_CORE_FULL
    );

    float whiteAmount = lerp(
        WHITE_BASE_AMOUNT,
        WHITE_CORE_AMOUNT,
        coreWhiteMask
    );

    float flareBrightness = max(FlareLuminance(flareColor), 0.000001f);
    float3 whiteFlareColor = flareBrightness.xxx;

    float3 whitenedFlareColor = lerp(
        flareColor,
        whiteFlareColor,
        whiteAmount
    );

    // Re-normalize luminance so whitening changes hue more than brightness.
    float whitenedBrightness = max(
        FlareLuminance(whitenedFlareColor),
        0.000001f
    );

    whitenedFlareColor *= flareBrightness / whitenedBrightness;

    // Keep the existing RGB brightness control. Density only shapes the halo;
    // the core now tops out below 1.0 so the center looks less solid.
    float3 outputColor =
        whitenedFlareColor
        * shapedAlpha
        * flareDensity
        * FLARE_BRIGHTNESS;

    // Lower coverage separately from source RGB. With the game's premultiplied
    // flare blend this lets more of the scene remain visible through the sprite
    // without changing FLARE_BRIGHTNESS.
    float coreAlphaScale = lerp(1.0f, FLARE_CORE_DENSITY, densityCoreMask);
    float outputAlpha = shapedAlpha * OUTPUT_ALPHA_COVERAGE * coreAlphaScale;

    return float4(outputColor, outputAlpha);
}