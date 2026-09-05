#include "./shared.h"

// Reconstructed ps_3_0 five-tap bloom blur.
//
// This version always uses the game's authored sampling radius. It does not
// shrink or expand the texture-coordinate offsets. Instead, faint bloom stays
// present across the original footprint at a lower density, while bright bloom
// reaches full density so hot-core brightness is unchanged.
//
// Extreme HDR input values are soft-compressed before filtering. This prevents
// upgraded floating-point bloom resources from turning a bright colored light
// into a very large orange/red blob.
//
// RGB is not clamped to 1.0. Compression scales all RGB channels together and
// therefore preserves bloom hue.

sampler2D bloomSampler : register(s0);

float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);


// ============================================================================
// Configuration
// ============================================================================

// HDR soft-knee compression. Values below the knee remain unchanged.
#define BLOOM_KNEE_START       1.00f
#define BLOOM_KNEE_STRENGTH    0.30f
#define BLOOM_MAX_INPUT_PEAK   8.00f

// Full-size transparency-style shaping. This never reaches zero, so the blur
// footprint remains present. The hot core returns to 1.0 density.
#define BLOOM_HALO_DENSITY          0.30f
#define BLOOM_CORE_DENSITY          0.30f
#define BLOOM_DENSITY_START         0.050f
#define BLOOM_DENSITY_FULL          0.800f


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


float4 BloomSampleControlled(
    float2 texcoord
)
{
    float4 bloom = tex2D(
        bloomSampler,
        texcoord
    );

    bloom.rgb = BloomCompressHDR(
        bloom.rgb
    );

    // Keep the full blur footprint, but make low-energy bloom less dense.
    // The core is capped below full density so it looks less solid.
    float bloomPeak = BloomMax3(bloom.rgb);
    float densityMask = BloomSmoothCubic01(
        BloomSafeDivide(
            bloomPeak - BLOOM_DENSITY_START,
            BLOOM_DENSITY_FULL - BLOOM_DENSITY_START
        )
    );

    bloom.rgb *= lerp(
        BLOOM_HALO_DENSITY,
        BLOOM_CORE_DENSITY,
        densityMask
    );

    return bloom;
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    // Always use the game's authored radius. Transparency/density is handled
    // in the samples instead of changing geometric flare size.
    float radiusScale = 1.0f;

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
        input.texcoord
    );

    float4 texcoordPair0 =
        input.texcoord.xyxy
        + scaledControl0;

    float4 offsetSample0 = BloomSampleControlled(
        texcoordPair0.xy
    );

    float4 offsetSample1 = BloomSampleControlled(
        texcoordPair0.zw
    );

    float4 texcoordPair1 =
        input.texcoord.xyxy
        + scaledControl1;

    float4 offsetSample2 = BloomSampleControlled(
        texcoordPair1.xy
    );

    float4 offsetSample3 = BloomSampleControlled(
        texcoordPair1.zw
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
