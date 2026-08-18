// FP16-compatible bloom setup with center-preserving downsampling.
//
// Fixes a dark or hollow glow core caused by:
// - The original four offset taps missing a small bright center.
// - Averaging reducing the center more than the wider glow edge.
// - The legacy tint curve darkening bright bloom values.
//
// No gamma or sRGB conversion is performed.
//
// CORE_PRESERVE_STRENGTH:
//   0.0 = original four-tap averaged mask
//   0.5 = partial center preservation
//   1.0 = preserve the strongest sampled bloom mask
//
// DEBUG_VIEW:
//   0 = corrected colored bloom
//   1 = original averaged mask
//   2 = strongest mask
//   3 = direct center-sample mask

#define CORE_PRESERVE_STRENGTH 1.0f
#define DEBUG_VIEW             2

sampler2D colorMapSampler : register(s0);

float4 glowSetup               : register(c3);
float4 colorTintBase           : register(c5);
float4 colorTintDelta          : register(c6);
float4 colorTintQuadraticDelta : register(c7);
float4 colorBias               : register(c8);

struct PS_INPUT
{
    float2 texcoord0 : TEXCOORD0;
    float2 texcoord1 : TEXCOORD1;
    float2 texcoord2 : TEXCOORD2;
    float2 texcoord3 : TEXCOORD3;
};

static const float3 LUMINANCE_WEIGHTS =
    float3(
        0.298999995f,
        0.587000012f,
        0.114000000f
    );

float GetLuminance(float3 color)
{
    return dot(color, LUMINANCE_WEIGHTS);
}

// RGB contains normalized bloom chroma.
// Alpha contains the bloom threshold mask.
float4 SampleBloomData(float2 texcoord)
{
    float3 source =
        tex2D(colorMapSampler, texcoord).rgb;

    // Match the original unsigned SDR input domain.
    float3 bloomInput =
        saturate(source);

    float luminance =
        GetLuminance(bloomInput);

    float bloomMask =
        saturate(luminance - glowSetup.x);

    // Normalize the source color so it supplies hue/chroma only.
    // The threshold mask supplies the bloom brightness.
    float3 chroma = 1.0f;

    if (luminance > 0.000001f)
    {
        chroma = bloomInput / luminance;
    }

    // Avoid extreme chroma from very dark or highly saturated samples.
    chroma = clamp(
        chroma,
        0.0f,
        4.0f
    );

    return float4(
        chroma,
        bloomMask
    );
}

float4 SelectStrongerSample(float4 sampleA, float4 sampleB)
{
    // Alpha stores the mask strength.
    float selectB =
        step(sampleA.a, sampleB.a);

    return lerp(
        sampleA,
        sampleB,
        selectB
    );
}

float4 main(PS_INPUT input) : COLOR0
{
    float4 tap0 =
        SampleBloomData(input.texcoord0);

    float4 tap1 =
        SampleBloomData(input.texcoord1);

    float4 tap2 =
        SampleBloomData(input.texcoord2);

    float4 tap3 =
        SampleBloomData(input.texcoord3);

    // The average of the four offset coordinates should correspond
    // to the source area center.
    float2 centerTexcoord =
        (
            input.texcoord0
            + input.texcoord1
            + input.texcoord2
            + input.texcoord3
        ) * 0.25f;

    float4 centerTap =
        SampleBloomData(centerTexcoord);

    // Original four-tap mask behavior.
    float averageMask =
        (
            tap0.a
            + tap1.a
            + tap2.a
            + tap3.a
        ) * 0.25f;

    // Find the sample containing the strongest bloom response.
    float4 strongestTap =
        SelectStrongerSample(tap0, tap1);

    strongestTap =
        SelectStrongerSample(
            strongestTap,
            tap2
        );

    strongestTap =
        SelectStrongerSample(
            strongestTap,
            tap3
        );

    strongestTap =
        SelectStrongerSample(
            strongestTap,
            centerTap
        );

    float strongestMask =
        strongestTap.a;

#if DEBUG_VIEW == 1

    return float4(
        averageMask.xxx,
        1.0f
    );

#elif DEBUG_VIEW == 2

    return float4(
        strongestMask.xxx,
        1.0f
    );

#elif DEBUG_VIEW == 3

    return float4(
        centerTap.aaa,
        1.0f
    );

#else

    // Preserve the original mask average while raising areas where
    // the downsample missed a stronger center.
    float preservedMask =
        lerp(
            averageMask,
            strongestMask,
            saturate(CORE_PRESERVE_STRENGTH)
        );

    // Calculate a mask-weighted average chroma.
    float totalMask =
        tap0.a
        + tap1.a
        + tap2.a
        + tap3.a;

    float3 weightedChroma =
        tap0.rgb * tap0.a
        + tap1.rgb * tap1.a
        + tap2.rgb * tap2.a
        + tap3.rgb * tap3.a;

    float3 bloomChroma;

    if (totalMask > 0.000001f)
    {
        bloomChroma =
            weightedChroma / totalMask;
    }
    else
    {
        bloomChroma =
            strongestTap.rgb;
    }

    // Pull the color slightly toward the strongest sample as the
    // preserved mask becomes stronger than the original average.
    float coreDifference =
        saturate(
            (strongestMask - averageMask)
            / max(strongestMask, 0.000001f)
        );

    bloomChroma =
        lerp(
            bloomChroma,
            strongestTap.rgb,
            coreDifference
        );

    float glowStrength =
        max(glowSetup.y, 0.0f);

    float3 outputColor =
        bloomChroma
        * preservedMask
        * glowStrength;

    float outputLuminance =
        GetLuminance(outputColor);

    float desaturationAmount =
        saturate(glowSetup.w);

    outputColor =
        lerp(
            outputColor,
            outputLuminance.xxx,
            desaturationAmount
        );

    return float4(
        max(outputColor, 0.0f),
        1.0f
    );

#endif
}