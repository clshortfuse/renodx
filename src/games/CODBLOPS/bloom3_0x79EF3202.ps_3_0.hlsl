// Reduced flare/particle sprite replacement for 0x79EF3202.
// Whiter version.
//
// Original:
//   textureColor *= vertexColor;
//   output.rgb = textureColor.rgb * textureColor.a;
//   output.a   = textureColor.a;
//
// Adjustments:
//   - ALPHA_POWER suppresses the faint outer halo.
//   - ALPHA_THRESHOLD removes extremely faint outer pixels.
//   - FLARE_BRIGHTNESS reduces both the core and halo brightness.
//   - WHITE_BASE_AMOUNT adds a general white bias to the whole flare.
//   - WHITE_CORE_AMOUNT makes the brighter center even whiter.
//   - Luminance is preserved after whitening so the flare does not become
//     unintentionally brighter just from the color shift.
//   - Output remains premultiplied-alpha compatible.
//   - No final RGB saturation is applied.

#define FLARE_BRIGHTNESS   0.50f
#define ALPHA_POWER        5.00f
#define ALPHA_THRESHOLD    0.0025f

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

    // Remove only the faintest part of the sprite.
    float remappedAlpha = saturate(
        (originalAlpha - ALPHA_THRESHOLD)
        / max(1.0f - ALPHA_THRESHOLD, 0.000001f)
    );

    // Compress the low-alpha outer halo much more than the bright center.
    float shapedAlpha = pow(
        max(remappedAlpha, 0.0f),
        ALPHA_POWER
    );

    // Make the flare whiter.
    // The whole flare gets some whitening, and the brighter core gets more.
    float coreWhiteMask = FlareSmoothRangeMask(
        shapedAlpha,
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

    // Preserve the original premultiplied-alpha output structure.
    float3 outputColor =
        whitenedFlareColor
        * shapedAlpha
        * FLARE_BRIGHTNESS;

    return float4(outputColor, shapedAlpha);
}