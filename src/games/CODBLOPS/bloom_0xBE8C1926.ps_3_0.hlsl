#include "./shared.h"

// Fullscreen bloom/tonemap pass with RenoDX-controlled bloom brightness.
// Original bloom footprint is retained while the halo is made less dense.
//
// RenoDX sliders:
//   RENODX_BLOOM_BRIGHTNESS
//     0.00 = no restored HDR bloom
//     1.00 = normal restored bloom
//     3.00 = three times restored bloom
//
// Changes in this version:
//   - Bloom halo and core are progressively neutralized toward white instead of
//     inheriting excessive red/pink color from the underlying scene.
//   - Scene-color tinting is capped so bloom keeps more of its source color.
//   - The authored bloom footprint is preserved instead of being clipped by a
//     flare-size mask. Faint halo pixels use a lower density while the hot core
//     returns to full strength.
//   - Bloom RGB channels are still scaled together after color correction.
//   - No final RGB clamp is applied.

#define HIGHLIGHT_RESTORE 1.00f
#define HIGHLIGHT_START   1.00f
#define HIGHLIGHT_FULL    4.00f

#define BLOOM_SCENE_COLOR_BASE       0.35f
#define BLOOM_SCENE_COLOR_DOMINANT   0.85f
#define BLOOM_SCENE_COLOR_MAX        0.25f
#define BLOOM_DOMINANCE_START        2.00f
#define BLOOM_DOMINANCE_FULL        10.00f
#define BLOOM_SCENE_COLOR_MINIMUM    0.002f
#define BLOOM_SCENE_COLOR_FULL       0.010f

// Bloom whitening controls. These affect chroma only; luminance is restored
// after whitening so the flare does not become brighter or larger.
//
// BASE applies a small neutral-white mix to all surviving bloom.
// HALO applies more whitening to medium-bright bloom.
// CORE applies the strongest whitening to the hottest center.
#define BLOOM_WHITE_BASE_AMOUNT  0.70f
#define BLOOM_WHITE_HALO_AMOUNT  1.00f
#define BLOOM_WHITE_CORE_AMOUNT  1.00f

#define BLOOM_WHITE_HALO_START       0.050f
#define BLOOM_WHITE_HALO_FULL        0.400f
#define BLOOM_WHITE_CORE_START       0.250f
#define BLOOM_WHITE_CORE_FULL        0.900f

// Density shaping keeps the full authored bloom footprint instead of cutting
// the halo away. The faint halo uses BLOOM_TRANSPARENT_HALO_DENSITY, while
// the hot core smoothly returns to 1.0 so peak/core brightness is unchanged.
#define BLOOM_TRANSPARENT_HALO_DENSITY  0.30f
#define BLOOM_TRANSPARENT_CORE_DENSITY  0.30f
#define BLOOM_DENSITY_CORE_START        0.250f
#define BLOOM_DENSITY_CORE_FULL         2.000f

sampler2D bloomSampler : register(s0);
sampler2D colorSampler : register(s1);

float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);
float4 postFxControl2 : register(c7);

struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};

float BloomSafeDivide(float numerator, float denominator)
{
    const float epsilon = 0.000001f;

    if (numerator != numerator || denominator != denominator)
    {
        return 0.0f;
    }

    if (abs(denominator) < epsilon)
    {
        denominator = denominator < 0.0f ? -epsilon : epsilon;
    }

    float result = numerator / denominator;
    return result == result ? result : 0.0f;
}

float3 BloomSafeDivide3(float3 numerator, float3 denominator)
{
    return float3(
        BloomSafeDivide(numerator.r, denominator.r),
        BloomSafeDivide(numerator.g, denominator.g),
        BloomSafeDivide(numerator.b, denominator.b)
    );
}

float BloomMax3(float3 value)
{
    return max(value.r, max(value.g, value.b));
}

float BloomLuminance(float3 color)
{
    return dot(color, float3(0.2126f, 0.7152f, 0.0722f));
}

float BloomSmoothCubic01(float value)
{
    value = saturate(value);
    return value * value * (3.0f - 2.0f * value);
}

float BloomSmoothRangeMask(float value, float rangeStart, float rangeFull)
{
    float rangeLength = max(rangeFull - rangeStart, 0.000001f);

    return BloomSmoothCubic01(
        BloomSafeDivide(value - rangeStart, rangeLength)
    );
}

float4 main(PS_INPUT input) : COLOR0
{
    float4 bloomSample = tex2D(bloomSampler, input.texcoord);
    float4 colorSample = tex2D(colorSampler, input.texcoord);

    // Separate the Mode-2-style restoration target into scene and bloom.
    float3 sceneHDR = colorSample.rgb * colorSample.rgb;
    float3 rawBloomHDR = max(bloomSample.rgb, 0.0f) * 8.0f;

    float sceneBrightness = max(BloomLuminance(sceneHDR), 0.0f);
    float rawBloomBrightness = max(BloomLuminance(rawBloomHDR), 0.0f);

    // RenoDX controls. Sanitize values so an unset or invalid value cannot
    // create negative bloom or an invalid flare mask.
    float bloomBrightnessControl = max(RENODX_BLOOM_BRIGHTNESS, 0.0f);

    // Colorize bloom toward the underlying scene while preserving the bloom's
    // original luminance. The amount is capped below so bloom cannot become
    // overwhelmingly red/pink from the scene color.
    float3 sceneColorNormalized = BloomSafeDivide3(
        sceneHDR,
        float3(
            max(sceneBrightness, 0.000001f),
            max(sceneBrightness, 0.000001f),
            max(sceneBrightness, 0.000001f)
        )
    );

    float3 sceneColoredBloom =
        sceneColorNormalized * rawBloomBrightness;

    float sceneColorAvailability = BloomSmoothRangeMask(
        sceneBrightness,
        BLOOM_SCENE_COLOR_MINIMUM,
        BLOOM_SCENE_COLOR_FULL
    );

    // Use boosted brightness for bloom-versus-scene dominance only.
    // Flare-size classification below deliberately uses raw brightness instead.
    float adjustedBloomBrightness =
        rawBloomBrightness * bloomBrightnessControl;

    float dominanceRatio = BloomSafeDivide(
        adjustedBloomBrightness,
        max(sceneBrightness, 0.015625f)
    );

    float dominanceMask = BloomSmoothRangeMask(
        dominanceRatio,
        BLOOM_DOMINANCE_START,
        BLOOM_DOMINANCE_FULL
    );

    float sceneColorAmount = lerp(
        BLOOM_SCENE_COLOR_BASE,
        BLOOM_SCENE_COLOR_DOMINANT,
        dominanceMask
    );

    sceneColorAmount *= sceneColorAvailability;
    sceneColorAmount = min(sceneColorAmount, BLOOM_SCENE_COLOR_MAX);

    float3 coloredBloomHDR = lerp(
        rawBloomHDR,
        sceneColoredBloom,
        sceneColorAmount
    );

    // Correct numerical luminance drift caused by color blending.
    float coloredBloomBrightness = max(
        BloomLuminance(coloredBloomHDR),
        0.000001f
    );

    coloredBloomHDR *= BloomSafeDivide(
        rawBloomBrightness,
        coloredBloomBrightness
    );

    // Progressively neutralize the bloom toward white. The halo receives a
    // moderate amount while the hottest core becomes nearly white.
    float whiteHaloMask = BloomSmoothRangeMask(
        rawBloomBrightness,
        BLOOM_WHITE_HALO_START,
        BLOOM_WHITE_HALO_FULL
    );

    float whiteCoreMask = BloomSmoothRangeMask(
        rawBloomBrightness,
        BLOOM_WHITE_CORE_START,
        BLOOM_WHITE_CORE_FULL
    );

    float whiteAmount = BLOOM_WHITE_BASE_AMOUNT;
    whiteAmount = lerp(
        whiteAmount,
        BLOOM_WHITE_HALO_AMOUNT,
        whiteHaloMask
    );
    whiteAmount = lerp(
        whiteAmount,
        BLOOM_WHITE_CORE_AMOUNT,
        whiteCoreMask
    );
    whiteAmount = saturate(whiteAmount);

    float3 whiteBloomHDR = rawBloomBrightness.xxx;

    coloredBloomHDR = lerp(
        coloredBloomHDR,
        whiteBloomHDR,
        whiteAmount
    );

    // Re-normalize after whitening so this stage changes only color, not bloom
    // brightness or spatial size.
    coloredBloomBrightness = max(
        BloomLuminance(coloredBloomHDR),
        0.000001f
    );

    coloredBloomHDR *= BloomSafeDivide(
        rawBloomBrightness,
        coloredBloomBrightness
    );

    // Brightness scales every RGB channel together after color correction.
    coloredBloomHDR *= bloomBrightnessControl;

    // Keep the original spatial footprint of the sampled bloom. Instead of a
    // cutoff that physically shrinks the flare, only reduce the density of the
    // lower-energy halo. The brightest core now tops out at the configurable
    // core density instead of returning to a fully solid 1.0 contribution.
    float flareDensityBrightness = rawBloomBrightness;

    float flareCoreDensityMask = BloomSmoothRangeMask(
        flareDensityBrightness,
        BLOOM_DENSITY_CORE_START,
        BLOOM_DENSITY_CORE_FULL
    );

    flareCoreDensityMask *= flareCoreDensityMask;

    float flareExtentScale = lerp(
        BLOOM_TRANSPARENT_HALO_DENSITY,
        BLOOM_TRANSPARENT_CORE_DENSITY,
        flareCoreDensityMask
    );

    float3 controlledBloomHDR =
        coloredBloomHDR * flareExtentScale;

    // Rebuild the original rational-tonemap path with the SAME flare-size mask.
    // Without this, originalOutput still contains bloomSample * 64 at full size
    // and restores the oversized halo wherever highlight restoration is partial.
    float3 controlledBloomSample =
        max(bloomSample.rgb, 0.0f) * flareExtentScale;

    float3 x =
        colorSample.rgb * colorSample.rgb * 8.0f
        + controlledBloomSample * 64.0f;

    x = max(x, 0.0f);

    float3 denominator =
        x * (x * postFxControl0.x + postFxControl0.y)
        + postFxControl0.z;

    float3 numerator =
        x * (x * postFxControl1.x + postFxControl1.y)
        + postFxControl1.z;

    float3 originalOutput = BloomSafeDivide3(numerator, denominator);

    originalOutput =
        (originalOutput + postFxControl2.x)
        * postFxControl2.y;

    float3 preTonemapHDR = sceneHDR + controlledBloomHDR;
    float preTonemapPeak = BloomMax3(preTonemapHDR);

    float highlightMask = BloomSmoothRangeMask(
        preTonemapPeak,
        HIGHLIGHT_START,
        HIGHLIGHT_FULL
    );

    float restorationAmount =
        highlightMask * HIGHLIGHT_RESTORE;

    float3 outputColor = lerp(
        originalOutput,
        preTonemapHDR,
        restorationAmount
    );

    if (outputColor.r != outputColor.r) outputColor.r = 0.0f;
    if (outputColor.g != outputColor.g) outputColor.g = 0.0f;
    if (outputColor.b != outputColor.b) outputColor.b = 0.0f;

    // Deliberately unclamped so HDR values above 1.0 survive on a float target.
    return float4(outputColor, colorSample.a);
}
