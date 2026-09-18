// Reconstructed HDR-safe / unclamped version of the TV noise + bloom + LUT shader.
// ps_3_0 style replacement.
//
// IMPORTANT:
// This is a PRE-TONEMAP post-process/color-grading pass.
// It does NOT perform HDR display tonemapping.
//
// TV noise, scanlines, bloom, and the original color-correction matrix remain
// in the scene/post-process pipeline. A temporary SDR reference is constructed
// only so the original SDR LUT can be sampled safely, then the LUT's measured
// luminance/chrominance changes are restored onto the real HDR signal.

sampler2D SSFilter__tBaseMap             : register(s0);
sampler2D SSWrapPoint__tTVNoiseMap       : register(s1);
sampler2D SSWrapPoint__tTVNoiseMaskMap   : register(s2);
sampler2D SSLinear__tFilterTempMap2      : register(s3);
sampler2D SSPoint__tColorCorrectTableMap : register(s4);

float4x4 fColorCorrectMatrix : register(c1);

float4 fTVNoisePower    : register(c5);
float4 fTVNoiseUVOffset : register(c6);
float4 fTVNoiseScanline : register(c7);
float4 fTVNoiseHVSync   : register(c8);

float4 CBBloomFilter__packed0 : register(c9);
float4 fColorCorrectColor     : register(c10);


// ============================================================================
// HDR-safe pre-tonemap LUT reconstruction controls
// ============================================================================

// Start of the PER-CHANNEL shoulder used only to construct the temporary SDR
// LUT reference.
//
// Values <= this are unchanged in the reference.
// Values above it smoothly roll toward RENODX_LUT_REFERENCE_PEAK.
//
// The actual HDR signal is never replaced by this temporary reference.
#ifndef RENODX_LUT_REFERENCE_ROLLOFF_START
#define RENODX_LUT_REFERENCE_ROLLOFF_START 1.0f
#endif


// Grading-domain reference peak used ONLY while constructing the SDR LUT sample.
//
// This is intentionally independent of the later HDR tonemapper and display
// peak. It does not represent nits.
#ifndef RENODX_LUT_REFERENCE_PEAK
#define RENODX_LUT_REFERENCE_PEAK 4.0f
#endif


// Exact luminance white-clip point for the temporary SDR LUT reference.
//
// The luminance mapping satisfies:
//
//     f(RENODX_LUT_REFERENCE_WHITE_CLIP) == 1.0
//
// This is also grading-domain only. It is not the later display white point.
#ifndef RENODX_LUT_REFERENCE_WHITE_CLIP
#define RENODX_LUT_REFERENCE_WHITE_CLIP 4.0f
#endif


// Hue restoration after the temporary luminance-mapped reference is fit into
// the LUT's legal 0..1 coordinate range.
//
// 0.0 = ordinary SDR per-channel clipping
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

    // Preserve HDR while remaining finite for upgraded FP16 targets.
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

float3 SRGBToLinear_Unclamped(float3 color)
{
    // Preserve the existing behavior: allow HDR above 1.0, but remove negative
    // values before pow() so upgraded float targets cannot create NaNs.
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


float3 LinearToSRGB_Unclamped(float3 color)
{
    // Do not clamp the upper range. The actual HDR tonemapper is later.
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
// Original TV-noise processing
// ============================================================================

float3 RGBToYCbCr_WithNoise(
    float3 rgb,
    float3 noise
)
{
    float y =
        dot(
            rgb,
            float3(0.299f, 0.587f, 0.114f)
        );

    float cb =
        dot(
            rgb.zxy,
            float3(0.5f, -0.169f, -0.331f)
        );

    float cr =
        dot(
            rgb,
            float3(0.5f, -0.419f, -0.081f)
        );

    y  += fTVNoisePower.x * noise.z;
    cb += fTVNoisePower.y * noise.x;
    cr += fTVNoisePower.y * noise.y;

    return float3(
        y,
        cb,
        cr
    );
}


float3 YCbCrToRGB(float3 ycbcr)
{
    float y  = ycbcr.x;
    float cb = ycbcr.y;
    float cr = ycbcr.z;

    float r =
        y + 1.402f * cr;

    float g =
        y
        - 0.344f * cb
        - 0.714f * cr;

    float b =
        y + 1.772f * cb;

    return float3(
        r,
        g,
        b
    );
}


// ============================================================================
// Original color-correction matrix
// ============================================================================

float3 ApplyColorCorrectMatrix(float3 color)
{
    // Matches the original assembly:
    //
    // r1 = color.y * c2
    // r1 = color.x * c1 + r1
    // r1 = color.z * c3 + r1
    // r1 = r1 + c4

    return
        color.r * fColorCorrectMatrix[0].xyz
        + color.g * fColorCorrectMatrix[1].xyz
        + color.b * fColorCorrectMatrix[2].xyz
        + fColorCorrectMatrix[3].xyz;
}


// ============================================================================
// Original SDR color-correction LUT
// ============================================================================

float3 SampleColorCorrectLUT(float3 coord)
{
    // The authored table itself remains SDR-domain.
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

    float3 lutSRGB;

    lutSRGB.r = rSample.r;
    lutSRGB.g = gSample.g;
    lutSRGB.b = bSample.b;

    // Convert LUT output to linear before measuring its post-process change.
    return SRGBToLinear_Unclamped(
        lutSRGB
    );
}


// ============================================================================
// STEP 1
//
// TEMPORARY PER-CHANNEL HDR REFERENCE ROLLOFF
//
// This is NOT a display tonemapper.
//
// It only produces a better SDR reference for the original LUT. Doing the
// shoulder per channel first keeps a single saturated HDR channel (for example
// bright red) from dominating the SDR LUT coordinate.
// ============================================================================

float RolloffReferenceChannel(float value)
{
    value =
        max(
            value,
            0.0f
        );

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

    // Smooth rational shoulder:
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


float3 BuildPerChannelReference(float3 hdrColor)
{
    hdrColor =
        SafePositive(hdrColor);

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
// Only luminance is mapped. RGB is scaled uniformly, so this stage itself does
// not change hue.
//
// The result is discarded after LUT sampling; it does not tonemap the output.
// ============================================================================

float ExactReferenceWhiteClip(float value)
{
    value =
        max(
            value,
            0.0f
        );

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


float3 BuildLuminanceSDRReference(float3 referenceColor)
{
    referenceColor =
        SafePositive(referenceColor);

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
// HUE CORRECTION FOR TEMPORARY SDR CHANNEL BLOWOUT
//
// Even after luminance mapping, a highly saturated individual channel can still
// exceed 1.0.
//
// First create the legal clipped SDR coordinate. Then rebuild the hue ratios
// from the pre-clipped reference while keeping the maximum channel inside 1.0.
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
        * (
            clippedMax
            / referenceMax
        );

    huePreserved =
        saturate(huePreserved);

    return lerp(
        clippedSDR,
        huePreserved,
        saturate(
            RENODX_LUT_REFERENCE_HUE_CORRECTION
        )
    );
}


// ============================================================================
// STEP 4
//
// RESTORE POST PROCESS
//
// Instead of the old:
//
//     lutDelta     = lutResultSDR - lutCoordSDR;
//     lutResultHDR = lutCoordHDR + lutDelta;
//
// measure:
//
//   1. LUT luminance change
//   2. LUT chrominance change
//
// in the temporary SDR reference and apply those changes onto the ORIGINAL
// unclipped HDR matrix output.
//
// The temporary SDR compression itself therefore does not survive this pass.
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


    // Very near black, normalized chrominance becomes unstable.
    // Fall back to the measured linear post-process delta.
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
    // Restore LUT luminance change
    // ------------------------------------------------------------------------

    float luminanceRatio =
        afterLuminance
        / beforeLuminance;

    float restoredLuminance =
        hdrLuminance
        * luminanceRatio;


    // ------------------------------------------------------------------------
    // Restore LUT chrominance change
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


    // max(..., 0) can slightly modify luminance. Renormalize so the measured
    // LUT luminance change remains exact.
    float actualLuminance =
        GetLuminance(restoredColor);

    if (actualLuminance > 0.000001f)
    {
        restoredColor *=
            restoredLuminance
            / actualLuminance;
    }

    return SafePositive(
        restoredColor
    );
}


// ============================================================================
// HDR-safe original LUT/color-correction stage
// ============================================================================

float3 ApplyLUT_HDRSafe(float3 color)
{
    color =
        SafePositive(color);


    // ------------------------------------------------------------------------
    // Original matrix path.
    //
    // Keep the REAL HDR matrix result untouched. This is the signal that the
    // LUT grade will be restored onto.
    // ------------------------------------------------------------------------

    float3 lutCoordHDR =
        ApplyColorCorrectMatrix(
            color
        );

    lutCoordHDR =
        SafePositive(
            lutCoordHDR
        );


    // ========================================================================
    // TEMPORARY SDR LUT REFERENCE
    // ========================================================================

    // 1. Per-channel shoulder.
    float3 perChannelReference =
        BuildPerChannelReference(
            lutCoordHDR
        );


    // 2. Exact-white-clip luminance rolloff.
    float3 luminanceReference =
        BuildLuminanceSDRReference(
            perChannelReference
        );


    // 3. Fit to legal LUT coordinates and correct hue where possible.
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
        saturate(
            lutCoordSDR
        );


    // ========================================================================
    // ORIGINAL SDR LUT SAMPLE
    // ========================================================================

    float3 lutResultSDR =
        SampleColorCorrectLUT(
            lutCoordSDR
        );


    // ========================================================================
    // RESTORE ONLY THE LUT'S GRADE ONTO HDR
    // ========================================================================

    float3 lutResultHDR =
        RestorePostProcess(
            lutCoordHDR,
            lutCoordSDR,
            lutResultSDR
        );


    // ------------------------------------------------------------------------
    // Preserve the original shader's color-correction blend strength.
    // ------------------------------------------------------------------------

    float lutStrength =
        saturate(
            fColorCorrectColor.w
        );

    return SafePositive(
        lerp(
            color,
            lutResultHDR,
            lutStrength
        )
    );
}


// ============================================================================
// Main
// ============================================================================

float4 main(
    float2 texcoord : TEXCOORD0,
    float2 noiseUV  : TEXCOORD1
) : COLOR0
{
    // ------------------------------------------------------------------------
    // Original TV-noise UV construction.
    // ------------------------------------------------------------------------

    float4 noiseCoords =
        noiseUV.xyxy
        * fTVNoisePower.zwzw
        + fTVNoiseUVOffset.xyxy;

    float4 noiseSampleA =
        tex2D(
            SSWrapPoint__tTVNoiseMap,
            noiseCoords.xy
        );

    float4 noiseSampleB =
        tex2D(
            SSWrapPoint__tTVNoiseMap,
            noiseCoords.zw
        );

    float3 tvNoise;

    tvNoise.x =
        noiseSampleB.y - 0.5f;

    tvNoise.y =
        noiseSampleB.z - 0.5f;

    tvNoise.z =
        noiseSampleA.x - 0.5f;

    tvNoise *=
        1.0f + fTVNoiseHVSync.z;


    // ------------------------------------------------------------------------
    // Base scene.
    // ------------------------------------------------------------------------

    float4 baseSample =
        tex2D(
            SSFilter__tBaseMap,
            texcoord
        );

    float3 baseLinear =
        SRGBToLinear_Unclamped(
            baseSample.rgb
        );


    // ------------------------------------------------------------------------
    // Original TV-noise modification in YCbCr.
    // ------------------------------------------------------------------------

    float3 ycbcr =
        RGBToYCbCr_WithNoise(
            baseLinear,
            tvNoise
        );

    float3 noisyRGB =
        YCbCrToRGB(
            ycbcr
        );


    // ------------------------------------------------------------------------
    // Original scanline mask.
    // ------------------------------------------------------------------------

    float2 scanlineUV =
        noiseUV
        * fTVNoiseScanline.z;

    float scanlineMask =
        tex2D(
            SSWrapPoint__tTVNoiseMaskMap,
            scanlineUV
        ).x;

    float scanlinePower =
        1.0f
        - (
            (1.0f - scanlineMask)
            * fTVNoiseScanline.y
        );

    noisyRGB *=
        scanlinePower;


    // ------------------------------------------------------------------------
    // Original bloom/filter-temp contribution.
    // ------------------------------------------------------------------------

    float4 bloomSample =
        tex2D(
            SSLinear__tFilterTempMap2,
            texcoord
        );

    float3 bloomLinear =
        SRGBToLinear_Unclamped(
            bloomSample.rgb
        );


    // Keep bloom and scene HDR-range. No upper clamp.
    float3 combined =
        noisyRGB
        + bloomLinear
        * CBBloomFilter__packed0.rgb;


    // Preferred safety behavior before LUT reconstruction.
    //
    // Remove negative values without touching HDR values above 1.0.
    combined =
        max(
            combined,
            0.0f.xxx
        );


    // ------------------------------------------------------------------------
    // HDR-safe PRE-TONEMAP LUT/color correction.
    //
    // The temporary SDR reference is used only internally. The returned signal
    // remains HDR and is intended for the real tonemapper later in the pipeline.
    // ------------------------------------------------------------------------

    float3 gradedLinear =
        ApplyLUT_HDRSafe(
            combined
        );


    // ------------------------------------------------------------------------
    // Extended sRGB encode.
    //
    // No saturate() here. Preserve >1 values for the later HDR tonemapper.
    // ------------------------------------------------------------------------

    float3 finalColor =
        LinearToSRGB_Unclamped(
            gradedLinear
        );

    return float4(
        finalColor,
        1.0f
    );
}
