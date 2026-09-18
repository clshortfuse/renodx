//
// Call of Duty: World at War
// HDR-safe 16-tap filter / blur shader.
//
// Original:
//   - 16 texture samples.
//   - 8 pairs of UV coordinates.
//   - filterTap[0..7].w supplies the pair weights.
//
// FP16 fix:
//   - Sanitize EVERY texture sample before accumulation.
//   - NaN -> 0.
//   - Negative -> 0.
//   - Preserve HDR values above 1.0.
//   - Preserve the original filter weights and accumulation order.
//   - Protect final output from FP16 overflow.
//
// No kernel normalization.
// No SDR clamp.
// No change to tap positions.
// No change to blur strength.
//

sampler2D colorMapSampler : register(s0);

float4 filterTap[8] : register(c12);


// ============================================================================
// Input
// ============================================================================
//
// Each TEXCOORD contains TWO texture coordinates:
//
//     .xy = first sample
//     .zw = second sample
//
// 8 TEXCOORDs x 2 samples = 16 samples total.
//

struct PixelInput
{
    float4 tap0 : TEXCOORD0;
    float4 tap1 : TEXCOORD1;
    float4 tap2 : TEXCOORD2;
    float4 tap3 : TEXCOORD3;
    float4 tap4 : TEXCOORD4;
    float4 tap5 : TEXCOORD5;
    float4 tap6 : TEXCOORD6;
    float4 tap7 : TEXCOORD7;
};


// ============================================================================
// Safety
// ============================================================================

float SafeFinitePositive1(float value)
{
    // NaN -> 0.
    if (!(value == value))
    {
        return 0.0f;
    }

    // Original UNORM resources could not contain negative values.
    //
    // Preserve HDR above 1.0, but stay inside finite FP16 range.
    return min(
        max(
            value,
            0.0f
        ),
        65504.0f
    );
}


float4 SafeFinitePositive4(float4 color)
{
    return float4(
        SafeFinitePositive1(color.r),
        SafeFinitePositive1(color.g),
        SafeFinitePositive1(color.b),
        SafeFinitePositive1(color.a)
    );
}


// ============================================================================
// Preserve signed filter weights
// ============================================================================
//
// Do NOT clamp valid weights to positive.
//
// Even though this appears to be a normal blur kernel, preserving the original
// signed weight makes this replacement faithful if another version of the
// game supplies a negative/lobed filter.
//
// Only invalid values are replaced.
//

float SafeFilterWeight(float value)
{
    // NaN.
    if (!(value == value))
    {
        return 0.0f;
    }

    // Limit only to finite FP16-scale magnitude.
    return clamp(
        value,
        -65504.0f,
        65504.0f
    );
}


// ============================================================================
// HDR-safe texture sampling
// ============================================================================

float4 SampleHDRSafe(float2 uv)
{
    float4 color =
        tex2D(
            colorMapSampler,
            uv
        );

    // Broad lower-bound protection.
    //
    // Do NOT saturate().
    //
    // 2.0, 4.0, 10.0 etc. remain HDR.
    return SafeFinitePositive4(
        color
    );
}


// ============================================================================
// Sample one pair
// ============================================================================

float4 SamplePairHDRSafe(
    float4 coordinates)
{
    float4 sampleA =
        SampleHDRSafe(
            coordinates.xy
        );

    float4 sampleB =
        SampleHDRSafe(
            coordinates.zw
        );

    return SafeFinitePositive4(
        sampleA
        + sampleB
    );
}


// ============================================================================
// Main
// ============================================================================

float4 main(PixelInput input) : COLOR0
{
    // ========================================================================
    // Original first pair:
    //
    // texld r0, v1, s0
    // texld r1, v1.zwzw, s0
    // add   r0, r0, r1
    // mul   r1, r0, c13.w
    // ========================================================================

    float4 pair1 =
        SamplePairHDRSafe(
            input.tap1
        );

    float weight1 =
        SafeFilterWeight(
            filterTap[1].w
        );

    float4 result =
        pair1
        * weight1;


    // ========================================================================
    // Original tap 0
    //
    // texld r0, v0, s0
    // texld r2, v0.zwzw, s0
    // add   r0, r0, r2
    // mad   r1, c12.w, r0, r1
    // ========================================================================

    float4 pair0 =
        SamplePairHDRSafe(
            input.tap0
        );

    float weight0 =
        SafeFilterWeight(
            filterTap[0].w
        );

    result =
        pair0
        * weight0
        + result;


    // ========================================================================
    // Tap 2
    // ========================================================================

    float4 pair2 =
        SamplePairHDRSafe(
            input.tap2
        );

    float weight2 =
        SafeFilterWeight(
            filterTap[2].w
        );

    result =
        pair2
        * weight2
        + result;


    // ========================================================================
    // Tap 3
    // ========================================================================

    float4 pair3 =
        SamplePairHDRSafe(
            input.tap3
        );

    float weight3 =
        SafeFilterWeight(
            filterTap[3].w
        );

    result =
        pair3
        * weight3
        + result;


    // ========================================================================
    // Tap 4
    // ========================================================================

    float4 pair4 =
        SamplePairHDRSafe(
            input.tap4
        );

    float weight4 =
        SafeFilterWeight(
            filterTap[4].w
        );

    result =
        pair4
        * weight4
        + result;


    // ========================================================================
    // Tap 5
    // ========================================================================

    float4 pair5 =
        SamplePairHDRSafe(
            input.tap5
        );

    float weight5 =
        SafeFilterWeight(
            filterTap[5].w
        );

    result =
        pair5
        * weight5
        + result;


    // ========================================================================
    // Tap 6
    // ========================================================================

    float4 pair6 =
        SamplePairHDRSafe(
            input.tap6
        );

    float weight6 =
        SafeFilterWeight(
            filterTap[6].w
        );

    result =
        pair6
        * weight6
        + result;


    // ========================================================================
    // Tap 7
    //
    // Original final instruction:
    //
    // mad oC0, c19.w, r0, r1
    // ========================================================================

    float4 pair7 =
        SamplePairHDRSafe(
            input.tap7
        );

    float weight7 =
        SafeFilterWeight(
            filterTap[7].w
        );

    result =
        pair7
        * weight7
        + result;


    // ========================================================================
    // Final FP16 protection
    // ========================================================================
    //
    // Do NOT saturate.
    //
    // HDR values remain above 1.0.
    //
    // This only prevents invalid/negative/runaway values from reaching the
    // upgraded FP16 render target.
    // ========================================================================

    result =
        SafeFinitePositive4(
            result
        );


    return result;
}