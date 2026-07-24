#include "./shared.h"

// Reconstructed ps_3_0 five-tap bloom blur with RenoDX Flare Size control.
//
// Slider mapping:
//
//   RENODX_BLOOM_FLARE_SIZE = 0.00  -> compact 0.35x radius
//   RENODX_BLOOM_FLARE_SIZE = 0.50  -> original game radius
//   RENODX_BLOOM_FLARE_SIZE = 1.00  -> expanded 1.65x radius
//
// The slider scales only the texture-coordinate offsets. It does not directly
// multiply bloom brightness, so increasing Bloom Brightness cannot secretly
// increase the geometric blur radius.
//
// When the slider is below 50%, faint bloom tails are also smoothly reduced.
// This makes the flare look genuinely smaller instead of leaving a dim halo at
// the original radius.
//
// Extreme HDR input values are soft-compressed before filtering. This prevents
// upgraded floating-point bloom resources from turning a bright colored light
// into a very large orange/red blob.
//
// RGB is not clamped to 1.0. Compression scales all RGB channels together and
// therefore preserves bloom hue.

#ifndef RENODX_BLOOM_FLARE_SIZE
#define RENODX_BLOOM_FLARE_SIZE 0.50f
#endif

sampler2D bloomSampler : register(s0);

float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);


// ============================================================================
// Configuration
// ============================================================================

// Radius scale at the minimum and maximum slider positions.
// The original radius is explicitly preserved at a slider value of 0.50.
#define BLOOM_RADIUS_MIN_SCALE 0.35f
#define BLOOM_RADIUS_MAX_SCALE 1.65f

// HDR soft-knee compression. Values below the knee remain unchanged.
#define BLOOM_KNEE_START       1.00f
#define BLOOM_KNEE_STRENGTH    0.30f
#define BLOOM_MAX_INPUT_PEAK   8.00f

// Tail reduction used only below the slider midpoint.
// At Flare Size 0%, values below roughly this peak are removed smoothly.
// At 50% and above, this compact-tail reduction is disabled.
#define BLOOM_COMPACT_TAIL_THRESHOLD 0.080f
#define BLOOM_COMPACT_TAIL_SOFTNESS  0.180f


struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};


// ============================================================================
// Helpers
// ============================================================================

float BloomMax3(float3 value)
{
    return max(
        value.r,
        max(value.g, value.b)
    );
}


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

    if (result != result)
    {
        return 0.0f;
    }

    return result;
}


float BloomSmoothCubic01(float value)
{
    value = saturate(value);

    return value
        * value
        * (3.0f - 2.0f * value);
}


// Map 0..1 so that 0.50 is exactly the original radius.
float BloomGetRadiusScale(float flareSize)
{
    flareSize = saturate(flareSize);

    float belowMidpoint = saturate(flareSize * 2.0f);
    float aboveMidpoint = saturate((flareSize - 0.5f) * 2.0f);

    float compactRadius = lerp(
        BLOOM_RADIUS_MIN_SCALE,
        1.0f,
        belowMidpoint
    );

    float expandedRadius = lerp(
        1.0f,
        BLOOM_RADIUS_MAX_SCALE,
        aboveMidpoint
    );

    // belowMidpoint reaches 1.0 at the midpoint. aboveMidpoint then adds only
    // the expansion above the original radius.
    return compactRadius
        + (expandedRadius - 1.0f);
}


// Compress an HDR bloom sample uniformly by peak RGB.
float3 BloomCompressHDR(float3 bloom)
{
    bloom = max(bloom, 0.0f);

    float originalPeak = BloomMax3(bloom);

    if (originalPeak <= 0.000001f)
    {
        return 0.0f;
    }

    float excess = max(
        originalPeak - BLOOM_KNEE_START,
        0.0f
    );

    float compressedExcess = BloomSafeDivide(
        excess,
        1.0f + excess * BLOOM_KNEE_STRENGTH
    );

    float compressedPeak =
        originalPeak
        - excess
        + compressedExcess;

    compressedPeak = min(
        compressedPeak,
        BLOOM_MAX_INPUT_PEAK
    );

    bloom *= BloomSafeDivide(
        compressedPeak,
        originalPeak
    );

    return bloom;
}


// Smaller flare sizes remove faint outer energy before it enters the blur.
// At slider 0.50 and above, compactAmount is zero and this passes through.
float3 BloomApplyCompactTail(float3 bloom, float flareSize)
{
    float compactAmount = saturate(
        (0.5f - saturate(flareSize)) * 2.0f
    );

    if (compactAmount <= 0.0f)
    {
        return bloom;
    }

    float bloomPeak = BloomMax3(bloom);

    float threshold =
        BLOOM_COMPACT_TAIL_THRESHOLD
        * compactAmount;

    float softness = max(
        BLOOM_COMPACT_TAIL_SOFTNESS,
        0.000001f
    );

    float tailMask = BloomSmoothCubic01(
        BloomSafeDivide(
            bloomPeak - threshold,
            softness
        )
    );

    // Blend rather than abruptly cutting the tail. At minimum flare size the
    // complete mask is used; near 50%, the effect smoothly disappears.
    float retainedTail = lerp(
        1.0f,
        tailMask,
        compactAmount
    );

    return bloom * retainedTail;
}


float4 BloomSampleControlled(
    float2 texcoord,
    float flareSize
)
{
    float4 bloom = tex2D(
        bloomSampler,
        texcoord
    );

    bloom.rgb = BloomCompressHDR(
        bloom.rgb
    );

    bloom.rgb = BloomApplyCompactTail(
        bloom.rgb,
        flareSize
    );

    return bloom;
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    float flareSize = saturate(
        RENODX_BLOOM_FLARE_SIZE
    );

    float radiusScale = BloomGetRadiusScale(
        flareSize
    );

    // Preserve the original offset directions while scaling their distance
    // from the current pixel. At 50%, these are exactly the game's c5/c6
    // offsets. Bloom brightness is not involved in this calculation.
    float4 scaledControl0 =
        postFxControl0
        * radiusScale;

    float4 scaledControl1 =
        postFxControl1
        * radiusScale;

    float4 centerSample = BloomSampleControlled(
        input.texcoord,
        flareSize
    );

    float4 texcoordPair0 =
        input.texcoord.xyxy
        + scaledControl0;

    float4 offsetSample0 = BloomSampleControlled(
        texcoordPair0.xy,
        flareSize
    );

    float4 offsetSample1 = BloomSampleControlled(
        texcoordPair0.zw,
        flareSize
    );

    float4 texcoordPair1 =
        input.texcoord.xyxy
        + scaledControl1;

    float4 offsetSample2 = BloomSampleControlled(
        texcoordPair1.xy,
        flareSize
    );

    float4 offsetSample3 = BloomSampleControlled(
        texcoordPair1.zw,
        flareSize
    );

    // Exact reconstruction of the original filter:
    //
    //   accumulated = center * 0.25 + offset0 + offset1 + offset2 + offset3
    //   output      = accumulated * (4 / 17)
    //
    // Effective weights:
    //
    //   center      = 1 / 17
    //   each offset = 4 / 17
    float4 accumulated =
        centerSample * 0.25f
        + offsetSample0
        + offsetSample1
        + offsetSample2
        + offsetSample3;

    float4 outputColor =
        accumulated
        * 0.235294119f;

    // NaN protection only. No clamp-to-one.
    if (outputColor.r != outputColor.r) outputColor.r = 0.0f;
    if (outputColor.g != outputColor.g) outputColor.g = 0.0f;
    if (outputColor.b != outputColor.b) outputColor.b = 0.0f;
    if (outputColor.a != outputColor.a) outputColor.a = 0.0f;

    return outputColor;
}
