#include "./shared.h"

// Fullscreen bloom/tonemap pass with RenoDX-controlled bloom brightness
// and perceived large-flare size.
//
// RenoDX sliders:
//   RENODX_BLOOM_BRIGHTNESS
//     0.00 = no restored HDR bloom
//     1.00 = normal restored bloom
//     3.00 = three times restored bloom
//
//   RENODX_BLOOM_FLARE_SIZE
//     0.00 = remove the bloom flare completely
//     0.50 = retain mainly the bright flare core
//     1.00 = retain a reduced core and reduced halo
//
// Changes in this version:
//   - Bloom halo and core are progressively neutralized toward white instead of
//     inheriting excessive red/pink color from the underlying scene.
//   - Scene-color tinting is capped so bloom keeps more of its source color.
//   - Flare-size classification uses unboosted bloom brightness, so increasing
//     bloom brightness does not also make the flare spatially enormous.
//   - The flare-size mask is applied to BOTH the original rational-tonemap bloom
//     input and the restored HDR bloom. At 0.0 the sampled bloom contribution is
//     removed completely; 0.5 restores a smaller core and 1.0 restores a
//     smaller halo without returning to the original oversized blur extent.
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

// Separate brightness masks control the visible radius of the halo and core.
// Raising these thresholds makes both regions spatially smaller because fewer
// pixels from the blurred bloom texture survive the soft cutoff.
#define BLOOM_FLARE_HALO_START       0.100f
#define BLOOM_FLARE_HALO_FULL        1.200f
#define BLOOM_FLARE_CORE_START       1.500f
#define BLOOM_FLARE_CORE_FULL        8.000f

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
    float flareSizeControl = saturate(RENODX_BLOOM_FLARE_SIZE);

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

    // IMPORTANT:
    // Use unboosted bloom brightness for flare-size classification. Increasing
    // bloom brightness therefore does not make progressively more of the blurred
    // halo count as the retained core.
    float flareBrightnessForSize = rawBloomBrightness;

    // Use separate soft cutoffs for the halo and the bright core. Neither mask
    // restores the complete original blur, even at Flare Size = 1.0. This makes
    // both the central hot area and the surrounding halo visibly smaller.
    float flareHaloMask = BloomSmoothRangeMask(
        flareBrightnessForSize,
        BLOOM_FLARE_HALO_START,
        BLOOM_FLARE_HALO_FULL
    );

    // Stronger nonlinear falloff removes more of the faint outer halo while
    // retaining a smooth edge.
    flareHaloMask *= flareHaloMask;

    float flareCoreMask = BloomSmoothRangeMask(
        flareBrightnessForSize,
        BLOOM_FLARE_CORE_START,
        BLOOM_FLARE_CORE_FULL
    );

    // A cubic response restricts the visible bright core to only the hottest
    // bloom pixels, reducing its apparent radius without a hard circular cutoff.
    flareCoreMask =
        flareCoreMask * flareCoreMask * flareCoreMask;

    // Two-stage size response:
    //   0.00 -> no sampled bloom
    //   0.50 -> reduced bright core
    //   1.00 -> reduced core plus reduced halo
    //
    // The maximum setting now restores flareHaloMask rather than 1.0, so the
    // original oversized halo is never fully restored by this shader.
    float coreRestoreAmount = BloomSmoothCubic01(
        saturate(flareSizeControl * 0.5f)
    );

    float haloRestoreAmount = BloomSmoothCubic01(
        saturate((flareSizeControl - 0.5f) * 0.5f)
    );

    float retainedCore = flareCoreMask * coreRestoreAmount;

    float flareExtentScale = lerp(
        retainedCore,
        flareHaloMask,
        haloRestoreAmount
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
