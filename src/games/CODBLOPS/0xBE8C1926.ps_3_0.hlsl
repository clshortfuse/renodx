// Original fullscreen bloom/tonemap pass with controlled HDR restoration.
//
// The original rational curve remains active for the base image.
// Bright values from the pre-tonemap signal are then blended back in.
//
// HIGHLIGHT_RESTORE:
//   0.00 = original compressed result
//   0.10 = subtle HDR restoration
//   0.25 = moderate restoration
//   0.50 = strong restoration
//   1.00 = approaches Mode 2 in bright areas
//
// HIGHLIGHT_START:
//   Pre-tonemap brightness where restoration begins.
//
// HIGHLIGHT_FULL:
//   Pre-tonemap brightness where the selected restoration strength
//   becomes fully active.
//
// No final RGB clamp is applied.

#define HIGHLIGHT_RESTORE 1.00f
#define HIGHLIGHT_START   1.00f
#define HIGHLIGHT_FULL    4.00f

sampler2D bloomSampler : register(s0);
sampler2D colorSampler : register(s1);

float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);
float4 postFxControl2 : register(c7);


struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};


float SafeDivide(float numerator, float denominator)
{
    const float epsilon = 0.000001f;

    // NaN input protection.
    if (numerator != numerator || denominator != denominator)
    {
        return 0.0f;
    }

    // Protect against division by zero.
    if (abs(denominator) < epsilon)
    {
        denominator =
            denominator < 0.0f
            ? -epsilon
            : epsilon;
    }

    float result = numerator / denominator;

    // NaN result protection.
    if (result != result)
    {
        return 0.0f;
    }

    return result;
}


float3 SafeDivide3(float3 numerator, float3 denominator)
{
    return float3(
        SafeDivide(numerator.r, denominator.r),
        SafeDivide(numerator.g, denominator.g),
        SafeDivide(numerator.b, denominator.b)
    );
}


float4 main(PS_INPUT input) : COLOR0
{
    float4 bloomSample = tex2D(
        bloomSampler,
        input.texcoord
    );

    float4 colorSample = tex2D(
        colorSampler,
        input.texcoord
    );

    // Original pre-tonemap signal:
    //
    //   x = color² * 8 + bloom * 64
    float3 x =
        colorSample.rgb
        * colorSample.rgb
        * 8.0f
        + bloomSample.rgb
        * 64.0f;

    // Keep the rational curve in its expected nonnegative domain.
    // There is no upper clamp.
    x = max(x, 0.0f);

    // Original rational tonemapping curve.
    float3 denominator =
        x * (
            x * postFxControl0.x
            + postFxControl0.y
        )
        + postFxControl0.z;

    float3 numerator =
        x * (
            x * postFxControl1.x
            + postFxControl1.y
        )
        + postFxControl1.z;

    float3 originalOutput = SafeDivide3(
        numerator,
        denominator
    );

    originalOutput =
        (originalOutput + postFxControl2.x)
        * postFxControl2.y;

    // Mode 2's signal:
    //
    //   x / 8
    // = color² + bloom * 8
    //
    // This is the source of the much larger highlights you observed.
    float3 preTonemapHDR = x * 0.125f;

    float preTonemapPeak = max(
        preTonemapHDR.r,
        max(preTonemapHDR.g, preTonemapHDR.b)
    );

    // Create a smooth highlight-only restoration mask.
    float highlightRange = max(
        HIGHLIGHT_FULL - HIGHLIGHT_START,
        0.000001f
    );

    float highlightMask = saturate(
        (preTonemapPeak - HIGHLIGHT_START)
        / highlightRange
    );

    // Smooth cubic transition.
    highlightMask =
        highlightMask
        * highlightMask
        * (3.0f - 2.0f * highlightMask);

    float restorationAmount =
        highlightMask
        * HIGHLIGHT_RESTORE;

    // Preserve the original image in SDR and darker areas, but blend toward
    // the brighter Mode 2 signal as highlight intensity increases.
    float3 outputColor = lerp(
        originalOutput,
        preTonemapHDR,
        restorationAmount
    );

    // NaN protection only. No RGB saturation or clamp-to-one.
    if (outputColor.r != outputColor.r)
    {
        outputColor.r = 0.0f;
    }

    if (outputColor.g != outputColor.g)
    {
        outputColor.g = 0.0f;
    }

    if (outputColor.b != outputColor.b)
    {
        outputColor.b = 0.0f;
    }

    return float4(
        outputColor,
        colorSample.a
    );
}