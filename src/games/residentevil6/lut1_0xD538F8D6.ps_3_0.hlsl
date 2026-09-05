sampler2D SSPoint__tBaseMap : register(s0);
sampler2D SSPoint__tColorCorrectTableMap : register(s1);

float4x4 fColorCorrectMatrix : register(c1);
float4 fColorCorrectColor : register(c5);


// ============================================================================
// HDR-safe pre-tonemap LUT reconstruction
//
// IMPORTANT:
//
// This shader is NOT the HDR tonemapper.
//
// The real HDR/scene-linear signal is preserved by this pass and handed to the
// tonemapper later in the pipeline.
//
// The SDR rolloffs below exist ONLY to create a temporary 0..1 reference that
// can safely sample the game's original SDR color-correction table.
//
// No display peak, diffuse white, RenoDRT, PsychoV24, or output-nit mapping is
// performed here.
// ============================================================================


// Start of the temporary per-channel shoulder.
//
// Values <= this are unchanged in the LUT REFERENCE.
// Values above it smoothly roll toward RENODX_LUT_REFERENCE_PEAK.
//
// The actual HDR signal is never replaced by this reference.
#ifndef RENODX_LUT_REFERENCE_ROLLOFF_START
#define RENODX_LUT_REFERENCE_ROLLOFF_START 1.0f
#endif


// Scene/grading-domain reference peak used ONLY while constructing the SDR LUT
// sample.
//
// This is deliberately independent of the eventual HDR display peak.
//
// A value around 4 is a reasonable starting point for a pre-tonemap grade,
// but this can be tuned if the game's scene values occupy a different range.
#ifndef RENODX_LUT_REFERENCE_PEAK
#define RENODX_LUT_REFERENCE_PEAK 4.0f
#endif


// Exact luminance white-clip point for the temporary SDR reference.
//
// f(WHITE_CLIP) == 1.0 exactly.
//
// This is also grading-domain only and has nothing to do with monitor peak.
#ifndef RENODX_LUT_REFERENCE_WHITE_CLIP
#define RENODX_LUT_REFERENCE_WHITE_CLIP 4.0f
#endif


// Hue correction after the temporary SDR reference has been fit into 0..1.
//
// 0.0 = ordinary SDR channel clipping
// 1.0 = restore hue ratios from the pre-clipped reference
#ifndef RENODX_LUT_REFERENCE_HUE_CORRECTION
#define RENODX_LUT_REFERENCE_HUE_CORRECTION 1.0f
#endif


static const float3 RENODX_LUMINANCE_WEIGHTS =
    float3(0.2126f, 0.7152f, 0.0722f);


// ============================================================================
// Safety helpers
// ============================================================================

float SafeFinitePositive1(float value)
{
    // NaN is the only floating-point value where value != value.
    value = (value == value) ? value : 0.0f;

    // Preserve HDR values while staying inside the finite FP16 range.
    return min(
        max(value, 0.0f),
        65504.0f
    );
}


float3 SafePositive(float3 color)
{
    return float3(
        SafeFinitePositive1(color.r),
        SafeFinitePositive1(color.g),
        SafeFinitePositive1(color.b)
    );
}


float GetMaxChannel(float3 color)
{
    return max(
        color.r,
        max(color.g, color.b)
    );
}


float GetLuminance(float3 color)
{
    return dot(
        max(color, 0.0f.xxx),
        RENODX_LUMINANCE_WEIGHTS
    );
}


// ============================================================================
// sRGB decode / encode
// ============================================================================

// Extended positive sRGB decode.
//
// There is no saturate() here. Values above 1.0 are allowed to remain HDR.
float3 SRGBToLinear(float3 color)
{
    color = SafePositive(color);

    float3 low =
        color / 12.92f;

    float3 high =
        pow(
            max(
                (color + 0.055f) / 1.055f,
                0.0f.xxx
            ),
            2.4f.xxx
        );

    return SafePositive(
        lerp(
            high,
            low,
            color <= 0.03928f
        )
    );
}


// Extended positive sRGB encode.
//
// Do not clamp the result to 1.0. This pass must preserve values for the real
// tonemapper that executes later.
float3 LinearToSRGB_Unclamped(float3 color)
{
    color = SafePositive(color);

    float3 low =
        color * 12.92f;

    float3 high =
        1.055f
        * pow(
            max(color, 0.0f.xxx),
            (1.0f / 2.4f).xxx
        )
        - 0.055f;

    return SafePositive(
        lerp(
            high,
            low,
            color <= 0.003131f
        )
    );
}


// ============================================================================
// Original color-correction LUT
// ============================================================================

float3 SampleColorCorrectLUT(float3 coord)
{
    // The authored color-correction table itself is SDR-domain.
    coord = saturate(coord);

    float4 rSample =
        tex2D(
            SSPoint__tColorCorrectTableMap,
            coord.xx
        );

    float4 gSample =
        tex2D(
            SSPoint__tColorCorrectTableMap,
            coord.yy
        );

    float4 bSample =
        tex2D(
            SSPoint__tColorCorrectTableMap,
            coord.zz
        );

    float3 lutColor;

    lutColor.r = rSample.r;
    lutColor.g = gSample.g;
    lutColor.b = bSample.b;

    // Convert the LUT's encoded result back to linear light before measuring
    // its luminance/chrominance effect.
    return SRGBToLinear(lutColor);
}


// ============================================================================
// STEP 1
//
// TEMPORARY PER-CHANNEL REFERENCE ROLLOFF
//
// This is NOT the game's HDR tonemapper.
//
// Its only purpose is to stop one extreme channel from dominating the SDR LUT
// reference. The original HDR matrix result remains untouched and is restored
// after the LUT is sampled.
// ============================================================================

float RolloffReferenceChannel(
    float value
)
{
    value = max(value, 0.0f);

    float referencePeak =
        max(
            RENODX_LUT_REFERENCE_PEAK,
            1.0001f
        );

    float rolloffStart =
        clamp(
            RENODX_LUT_REFERENCE_ROLLOFF_START,
            0.0f,
            referencePeak - 0.0001f
        );

    if (value <= rolloffStart)
    {
        return value;
    }

    float shoulderRange =
        referencePeak - rolloffStart;

    float excess =
        value - rolloffStart;

    // Continuous rational shoulder:
    //
    //   at rolloffStart: slope = 1
    //   at infinity:     result -> referencePeak
    float compressedExcess =
        shoulderRange
        * excess
        / max(
            excess + shoulderRange,
            0.000001f
        );

    return rolloffStart + compressedExcess;
}


float3 BuildPerChannelReference(
    float3 hdrColor
)
{
    hdrColor = SafePositive(hdrColor);

    return SafePositive(
        float3(
            RolloffReferenceChannel(hdrColor.r),
            RolloffReferenceChannel(hdrColor.g),
            RolloffReferenceChannel(hdrColor.b)
        )
    );
}


// ============================================================================
// STEP 2
//
// TEMPORARY EXACT-WHITE-CLIP LUMINANCE ROLLOFF
//
// Extended Reinhard:
//
//                 x * (1 + x / W^2)
//     f(x) = -----------------------------
//                        1 + x
//
// f(W) = 1 exactly.
//
// Again: this is only a virtual SDR reference used for LUT sampling.
// It is not the later HDR display tonemapper.
// ============================================================================

float ExactReferenceWhiteClip(
    float value
)
{
    value = max(value, 0.0f);

    float whiteClip =
        max(
            RENODX_LUT_REFERENCE_WHITE_CLIP,
            0.0001f
        );

    float whiteClipSquared =
        whiteClip * whiteClip;

    float mapped =
        value
        * (1.0f + value / whiteClipSquared)
        / (1.0f + value);

    return saturate(mapped);
}


float3 BuildLuminanceSDRReference(
    float3 referenceColor
)
{
    referenceColor = SafePositive(referenceColor);

    float sourceLuminance =
        GetLuminance(referenceColor);

    if (sourceLuminance <= 0.000001f)
    {
        return 0.0f.xxx;
    }

    float mappedLuminance =
        ExactReferenceWhiteClip(
            sourceLuminance
        );

    float luminanceScale =
        mappedLuminance
        / sourceLuminance;

    return SafePositive(
        referenceColor * luminanceScale
    );
}


// ============================================================================
// STEP 3
//
// HUE CORRECTION FOR SDR REFERENCE BLOWOUT
//
// Luminance mapping can still leave one individual channel above 1.0.
//
// We first build the legal clipped SDR coordinate, then restore the hue ratios
// from the pre-clipped reference while keeping the coordinate inside 0..1.
// ============================================================================

float3 CorrectReferenceBlowoutHue(
    float3 hueReference,
    float3 clippedSDR
)
{
    hueReference =
        SafePositive(hueReference);

    clippedSDR =
        saturate(clippedSDR);

    float referenceMax =
        GetMaxChannel(hueReference);

    float clippedMax =
        GetMaxChannel(clippedSDR);

    if (
        referenceMax <= 0.000001f
        || clippedMax <= 0.000001f
    )
    {
        return clippedSDR;
    }

    float3 huePreserved =
        hueReference
        * (clippedMax / referenceMax);

    huePreserved =
        saturate(huePreserved);

    return lerp(
        clippedSDR,
        huePreserved,
        saturate(RENODX_LUT_REFERENCE_HUE_CORRECTION)
    );
}


// ============================================================================
// STEP 4
//
// RESTORE POST PROCESS
//
// Measure the original SDR LUT's:
//
//   1. luminance change
//   2. chrominance change
//
// then apply those changes to the untouched HDR matrix result.
//
// The temporary SDR compression is therefore discarded after sampling.
// Only the authored LUT grade survives.
//
// This is the important part that keeps this pass a COLOR-GRADE pass rather
// than becoming an HDR tonemapper.
// ============================================================================

float3 RestorePostProcess(
    float3 hdrSource,
    float3 sdrBeforePostProcess,
    float3 sdrAfterPostProcess
)
{
    hdrSource =
        SafePositive(hdrSource);

    sdrBeforePostProcess =
        SafePositive(sdrBeforePostProcess);

    sdrAfterPostProcess =
        SafePositive(sdrAfterPostProcess);

    float hdrLuminance =
        GetLuminance(hdrSource);

    float beforeLuminance =
        GetLuminance(sdrBeforePostProcess);

    float afterLuminance =
        GetLuminance(sdrAfterPostProcess);


    // Near black, normalized chrominance is numerically unstable.
    // Fall back to the measured linear SDR post-process delta.
    if (
        hdrLuminance <= 0.000001f
        || beforeLuminance <= 0.000001f
        || afterLuminance <= 0.000001f
    )
    {
        return SafePositive(
            hdrSource
            + (
                sdrAfterPostProcess
                - sdrBeforePostProcess
            )
        );
    }


    // ------------------------------------------------------------------------
    // Luminance delta
    // ------------------------------------------------------------------------

    float luminanceRatio =
        afterLuminance
        / beforeLuminance;

    float restoredLuminance =
        hdrLuminance
        * luminanceRatio;


    // ------------------------------------------------------------------------
    // Chrominance delta
    // ------------------------------------------------------------------------

    float3 hdrChrominance =
        hdrSource
        / hdrLuminance;

    float3 beforeChrominance =
        sdrBeforePostProcess
        / beforeLuminance;

    float3 afterChrominance =
        sdrAfterPostProcess
        / afterLuminance;

    float3 chrominanceDelta =
        afterChrominance
        - beforeChrominance;

    float3 restoredChrominance =
        max(
            hdrChrominance
            + chrominanceDelta,
            0.0f.xxx
        );

    float3 restoredColor =
        restoredChrominance
        * restoredLuminance;


    // max(..., 0) can slightly alter reconstructed luminance.
    // Renormalize so the measured LUT luminance ratio is retained.
    float actualLuminance =
        GetLuminance(restoredColor);

    if (actualLuminance > 0.000001f)
    {
        restoredColor *=
            restoredLuminance
            / actualLuminance;
    }

    return SafePositive(restoredColor);
}


// ============================================================================
// Main
// ============================================================================

float4 main(float2 texcoord : TEXCOORD0) : COLOR0
{
    float4 baseSample =
        tex2D(
            SSPoint__tBaseMap,
            texcoord
        );


    // ------------------------------------------------------------------------
    // Decode the incoming extended-sRGB signal.
    //
    // Values above 1.0 are NOT clipped.
    // ------------------------------------------------------------------------

    float3 baseLinear =
        SRGBToLinear(
            max(
                baseSample.rgb,
                0.0f.xxx
            )
        );


    // ------------------------------------------------------------------------
    // Original matrix path.
    //
    // This is the REAL pre-tonemap HDR result of this color-correction pass.
    // Keep it intact.
    // ------------------------------------------------------------------------

    float3 lutCoordHDR =
        baseLinear.r * fColorCorrectMatrix[0].xyz
        + baseLinear.g * fColorCorrectMatrix[1].xyz
        + baseLinear.b * fColorCorrectMatrix[2].xyz
        + fColorCorrectMatrix[3].xyz;

    lutCoordHDR =
        SafePositive(lutCoordHDR);


    // ========================================================================
    // TEMPORARY SDR REFERENCE FOR LUT SAMPLING
    // ========================================================================

    // 1. Per-channel reference shoulder.
    float3 perChannelReference =
        BuildPerChannelReference(
            lutCoordHDR
        );


    // 2. Luminance reference shoulder with exact virtual SDR white clip.
    float3 luminanceReference =
        BuildLuminanceSDRReference(
            perChannelReference
        );


    // 3. Fit to the LUT's real 0..1 domain and restore hue where possible.
    float3 clippedReference =
        saturate(
            luminanceReference
        );

    float3 lutCoordSDR =
        CorrectReferenceBlowoutHue(
            perChannelReference,
            clippedReference
        );

    lutCoordSDR =
        saturate(lutCoordSDR);


    // ========================================================================
    // ORIGINAL LUT SAMPLE
    // ========================================================================

    float3 lutResultSDR =
        SampleColorCorrectLUT(
            lutCoordSDR
        );


    // ========================================================================
    // RESTORE ONLY THE LUT'S GRADE ONTO THE REAL HDR SIGNAL
    //
    // No temporary SDR tonemapping survives this point.
    // ========================================================================

    float3 gradedHDR =
        RestorePostProcess(
            lutCoordHDR,
            lutCoordSDR,
            lutResultSDR
        );


    // ------------------------------------------------------------------------
    // Preserve the original color-correction strength behavior.
    // ------------------------------------------------------------------------

    float lutStrength =
        saturate(
            fColorCorrectColor.w
        );

    float3 finalLinear =
        lerp(
            baseLinear,
            gradedHDR,
            lutStrength
        );

    finalLinear =
        SafePositive(finalLinear);


    // ------------------------------------------------------------------------
    // Return extended sRGB without clamping.
    //
    // The REAL HDR tonemapper later in the pipeline receives the preserved
    // values above 1.0.
    // ------------------------------------------------------------------------

    float3 finalSRGB =
        LinearToSRGB_Unclamped(
            finalLinear
        );

    return float4(
        finalSRGB,
        baseSample.a
    );
}
