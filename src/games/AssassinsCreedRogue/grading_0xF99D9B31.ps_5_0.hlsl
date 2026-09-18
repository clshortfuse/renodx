#include "./common.hlsl"

// Put psychov-24.hlsl here:
//   src/shaders/tonemap/psychov/psychov-24.hlsl
#ifndef RENODX_USE_PSYCHOV24
#define RENODX_USE_PSYCHOV24 1
#endif

#if RENODX_USE_PSYCHOV24
#include "../../shaders/tonemap/psychov/psychov-24.hlsl"
#endif


Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t0 : register(t0);

SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s0_s : register(s0);


cbuffer cb0 : register(b0)
{
    float4 cb0[186];
}


#ifndef RENODX_BLOOM_STRENGTH
#define RENODX_BLOOM_STRENGTH 1.0f
#endif


// -----------------------------------------------------------------------------
// HDR -> SDR LUT-reference controls
// -----------------------------------------------------------------------------

// Where the per-channel HDR shoulder begins.
//
// 1.0 means:
//   <= 1.0 stays untouched
//   >  1.0 begins rolling toward the HDR peak.
//
// This is intentionally done PER CHANNEL before the luminance rolloff.
#ifndef RENODX_LUT_HDR_ROLLOFF_START
#define RENODX_LUT_HDR_ROLLOFF_START 1.0f
#endif


// 0 = automatically use:
//
//     PeakWhiteNits / DiffuseWhiteNits
//
// as the exact SDR white-clip point.
//
// You can override this with something such as:
//   #define RENODX_LUT_WHITE_CLIP 4.0f
//
// if the game's original SDR tonemapper has a known white-clip point.
#ifndef RENODX_LUT_WHITE_CLIP
#define RENODX_LUT_WHITE_CLIP 0.0f
#endif


// Correct the hue distortion introduced when the luminance-tonemapped
// reference has channels that need to fit inside the SDR 0-1 gamut.
//
// 0 = keep the clipped SDR hue
// 1 = restore the hue of the per-channel HDR-rolled reference
#ifndef RENODX_LUT_HUE_CORRECTION
#define RENODX_LUT_HUE_CORRECTION 1.0f
#endif


#ifndef RENODX_COLOR_GRADE_STRENGTH
#define RENODX_COLOR_GRADE_STRENGTH 1.0f
#endif


// -----------------------------------------------------------------------------
// PsychoV24
// -----------------------------------------------------------------------------

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV24
#define RENODX_TONE_MAP_TYPE_PSYCHOV24 24.0f
#endif

#ifndef RENODX_PSYCHOV24_COMPRESSION
#define RENODX_PSYCHOV24_COMPRESSION 4.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_COMPRESSION
#define RENODX_PSYCHOV24_GAMUT_COMPRESSION 1.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_MODE
#define RENODX_PSYCHOV24_GAMUT_MODE 1.0f
#endif

#ifndef RENODX_PSYCHOV24_CONE_RESPONSE
#define RENODX_PSYCHOV24_CONE_RESPONSE 1.0f
#endif

#ifndef RENODX_PSYCHOV24_HIGHLIGHT_SATURATION
#define RENODX_PSYCHOV24_HIGHLIGHT_SATURATION 1.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_HUE_RESTORE
#define RENODX_PSYCHOV24_GAMUT_HUE_RESTORE 0.0f
#endif


static const float3 RENODX_LUMINANCE_WEIGHTS =
    float3(0.2126f, 0.7152f, 0.0722f);


// -----------------------------------------------------------------------------
// Basic helpers
// -----------------------------------------------------------------------------

float SafeFinite1(float value)
{
    // NaN is the only floating point value where value != value.
    value = (value == value) ? value : 0.0f;

    return min(max(value, 0.0f), 65504.0f);
}


float3 SafePositive(float3 color)
{
    return float3(
        SafeFinite1(color.r),
        SafeFinite1(color.g),
        SafeFinite1(color.b));
}


float GetLuminance(float3 color)
{
    return dot(color, RENODX_LUMINANCE_WEIGHTS);
}


float GetMaxChannel(float3 color)
{
    return max(color.r, max(color.g, color.b));
}


bool IsRenoDRTMode()
{
    return abs(
               RENODX_TONE_MAP_TYPE
               - renodx::draw::TONE_MAP_TYPE_RENO_DRT)
        < 0.5f;
}


bool IsPsychoV24Mode()
{
    return abs(
               RENODX_TONE_MAP_TYPE
               - RENODX_TONE_MAP_TYPE_PSYCHOV24)
        < 0.5f;
}


bool IsCustomHDRMode()
{
    return IsRenoDRTMode() || IsPsychoV24Mode();
}


float GetHDRPeakValue()
{
    return max(
        RENODX_PEAK_WHITE_NITS
            / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
        1.0f);
}


float GetLUTWhiteClip()
{
    if (RENODX_LUT_WHITE_CLIP > 1.0f)
    {
        return RENODX_LUT_WHITE_CLIP;
    }

    return max(GetHDRPeakValue(), 1.0001f);
}


// -----------------------------------------------------------------------------
// PsychoV24
// -----------------------------------------------------------------------------

float3 ApplyPsychoV24HDRTonemap(float3 hdr_color)
{
    hdr_color = SafePositive(hdr_color);

#if RENODX_USE_PSYCHOV24

    float peak_value = GetHDRPeakValue();

    int gamut_mode =
        (RENODX_PSYCHOV24_GAMUT_MODE > 0.5f)
            ? 1
            : 0;

    hdr_color =
        renodx::tonemap::psychov::psychotm_test24(
            hdr_color,

            peak_value,

            RENODX_TONE_MAP_EXPOSURE,
            RENODX_TONE_MAP_HIGHLIGHTS,
            RENODX_TONE_MAP_SHADOWS,
            RENODX_TONE_MAP_CONTRAST,
            RENODX_TONE_MAP_SATURATION,

            1.0f,      // bleaching_intensity, reserved
            100.0f,    // clip_point, reserved

            RENODX_TONE_MAP_HUE_CORRECTION,

            1.0f,      // adaptation_contrast, deprecated
            0,         // white_curve_mode, deprecated

            RENODX_PSYCHOV24_CONE_RESPONSE,

            0.18f.xxx, // current adaptive state / anchor-in
            0.18f.xxx, // desired background state / anchor-out

            RENODX_PSYCHOV24_GAMUT_COMPRESSION,
            gamut_mode,

            1.0f,      // adaptive_normalization, deprecated

            RENODX_PSYCHOV24_COMPRESSION,
            RENODX_PSYCHOV24_HIGHLIGHT_SATURATION,
            RENODX_PSYCHOV24_GAMUT_HUE_RESTORE);

#endif

    return SafePositive(hdr_color);
}


// =============================================================================
// STEP 1
//
// PER-CHANNEL HDR ROLLOFF
//
// This is only used to construct the SDR LUT reference.
//
// Values below the shoulder start are unchanged.
// Values above it smoothly approach HDR peak.
//
// Doing this per channel before the luminance SDR tonemap prevents one extremely
// bright channel, such as saturated red, from remaining disproportionately
// energetic when the HDR signal is converted into the SDR LUT domain.
// =============================================================================

float RolloffChannelToHDRPeak(
    float value,
    float hdrPeak)
{
    value = max(value, 0.0f);

    hdrPeak = max(hdrPeak, 1.0001f);

    float rolloffStart =
        clamp(
            RENODX_LUT_HDR_ROLLOFF_START,
            0.0f,
            hdrPeak - 0.0001f);

    if (value <= rolloffStart)
    {
        return value;
    }

    float range =
        hdrPeak - rolloffStart;

    float excess =
        value - rolloffStart;

    // Smooth rational shoulder.
    //
    // At the shoulder:
    //     slope = 1
    //
    // At infinity:
    //     result -> hdrPeak
    //
    // Unlike a simple x / (1+x) curve this does not alter the dark/mid range.

    float compressedExcess =
        range
        * excess
        / max(excess + range, 0.000001f);

    return rolloffStart + compressedExcess;
}


float3 PerChannelRolloffToHDRPeak(
    float3 color,
    float hdrPeak)
{
    color = max(color, 0.0f);

    return float3(
        RolloffChannelToHDRPeak(color.r, hdrPeak),
        RolloffChannelToHDRPeak(color.g, hdrPeak),
        RolloffChannelToHDRPeak(color.b, hdrPeak));
}


// =============================================================================
// STEP 2
//
// EXACT-WHITE-CLIP LUMINANCE ROLLOFF
//
// Extended Reinhard:
//
//               x * (1 + x / W²)
//     f(x) = -----------------------
//                    1 + x
//
// Crucially:
//
//     f(W) = 1
//
// exactly.
//
// We run the curve only on luminance, then multiply RGB by the luminance ratio.
// Therefore this stage itself does not change hue.
// =============================================================================

float ExactWhiteClipRolloff(
    float value,
    float whiteClip)
{
    value = max(value, 0.0f);
    whiteClip = max(whiteClip, 0.0001f);

    float whiteClipSquared =
        whiteClip * whiteClip;

    float mapped =
        value
        * (1.0f + value / whiteClipSquared)
        / (1.0f + value);

    return saturate(mapped);
}


float3 RolloffToSDRByLuminance(
    float3 hdrColor,
    float whiteClip)
{
    hdrColor = max(hdrColor, 0.0f);

    float hdrLuminance =
        GetLuminance(hdrColor);

    if (hdrLuminance <= 0.000001f)
    {
        return 0.0f;
    }

    float sdrLuminance =
        ExactWhiteClipRolloff(
            hdrLuminance,
            whiteClip);

    float luminanceScale =
        sdrLuminance
        / hdrLuminance;

    return max(
        hdrColor * luminanceScale,
        0.0f);
}


// =============================================================================
// STEP 3
//
// HUE CORRECTION FOR SDR BLOWOUT
//
// The luminance rolloff can still leave an individual RGB channel above 1.
// Vanilla SDR must fit in 0-1, so those channels eventually blow out.
//
// First produce the actual clipped SDR representation.
//
// Then reconstruct the hue from the PER-CHANNEL HDR-ROLLED color while keeping
// the same maximum SDR channel.
//
// This means hue correction cannot simply reintroduce >1 values.
// =============================================================================

float3 CorrectSDRBlowoutHue(
    float3 hueReference,
    float3 clippedSDR)
{
    hueReference = max(hueReference, 0.0f);
    clippedSDR   = saturate(clippedSDR);

    float referenceMax =
        GetMaxChannel(hueReference);

    float clippedMax =
        GetMaxChannel(clippedSDR);

    if (referenceMax <= 0.000001f
        || clippedMax <= 0.000001f)
    {
        return clippedSDR;
    }

    // Preserve the hue/chromatic relationship from the HDR-rolled reference,
    // but constrain its maximum channel to the already valid SDR maximum.

    float3 huePreserved =
        hueReference
        * (clippedMax / referenceMax);

    huePreserved =
        saturate(huePreserved);

    return lerp(
        clippedSDR,
        huePreserved,
        saturate(RENODX_LUT_HUE_CORRECTION));
}


// =============================================================================
// VANILLA GAME LUT + POST FILTER
//
// IMPORTANT:
//
// There is deliberately NO HDR ComputeMaxChannelScale() handling here anymore.
//
// HDR never directly enters these LUTs.
//
// The HDR path constructs a legitimate SDR reference first, and this function
// samples that exactly the same way as the game's SDR path.
// =============================================================================

float3 ApplyGameLUTAndGrade(float3 inputColor)
{
    // -------------------------------------------------------------------------
    // Game's LUT coordinate transform
    // -------------------------------------------------------------------------

    float3 lutCoordinates =
        inputColor * cb0[128].xyz
        + cb0[129].xyz;


    // -------------------------------------------------------------------------
    // Three one-dimensional LUTs
    // -------------------------------------------------------------------------

    float3 lutColor;

    lutColor.r =
        t5.SampleLevel(
            s5_s,
            float2(lutCoordinates.r, 0.5f),
            0.0f).r;

    lutColor.g =
        t6.SampleLevel(
            s6_s,
            float2(lutCoordinates.g, 0.5f),
            0.0f).r;

    lutColor.b =
        t7.SampleLevel(
            s7_s,
            float2(lutCoordinates.b, 0.5f),
            0.0f).r;


    // -------------------------------------------------------------------------
    // Game's 3x4 color matrix
    // -------------------------------------------------------------------------

    float4 lutColor4 =
        float4(lutColor, 1.0f);

    float3 matrixColor;

    matrixColor.r =
        dot(
            lutColor4,
            cb0[183]);

    matrixColor.g =
        dot(
            lutColor4,
            cb0[184]);

    matrixColor.b =
        dot(
            lutColor4,
            cb0[185]);


    // -------------------------------------------------------------------------
    // Original game's optional color filter
    // -------------------------------------------------------------------------

    float filterLuminance =
        dot(
            matrixColor,
            float3(
                0.212500006f,
                0.715399981f,
                0.0720999986f));


    // cb0[133].x moves the secondary filter color toward luminance.
    float3 filterColor =
        lerp(
            matrixColor,
            filterLuminance.xxx,
            cb0[133].x);


    // Original overlay-style blend.
    float3 overlayControl =
        cb0[134].xyz
        * filterColor;


    float3 overlayLow =
        2.0f
        * overlayControl
        * matrixColor;


    float3 overlayHigh =
        1.0f
        - 2.0f
        * (1.0f - matrixColor)
        * (1.0f - overlayControl);


    float3 overlayResult;

    overlayResult.r =
        (matrixColor.r < 0.5f)
            ? overlayLow.r
            : overlayHigh.r;

    overlayResult.g =
        (matrixColor.g < 0.5f)
            ? overlayLow.g
            : overlayHigh.g;

    overlayResult.b =
        (matrixColor.b < 0.5f)
            ? overlayLow.b
            : overlayHigh.b;


    float3 filteredColor =
        lerp(
            matrixColor,
            overlayResult,
            cb0[134].w);


    bool filterEnabled =
        cb0[132].x != 0.0f;


    return filterEnabled
        ? filteredColor
        : matrixColor;
}


// =============================================================================
// STEP 4
//
// RESTORE POST PROCESS
//
// This replaces the old:
//
//     CustomGradingBegin()
//     LUT
//     CustomGradingEnd()
//
// reconstruction.
//
// We measure TWO things from the SDR reference:
//
//   1. luminance change
//   2. chrominance change
//
// and reapply those changes to the untouched HDR source.
//
// This is why we no longer need the old manual black/mid-grey compensation.
// The LUT's luminance modification is measured directly.
// =============================================================================

float3 RestorePostProcess(
    float3 hdrSource,
    float3 sdrBeforePostProcess,
    float3 sdrAfterPostProcess)
{
    hdrSource =
        max(hdrSource, 0.0f);

    sdrBeforePostProcess =
        max(sdrBeforePostProcess, 0.0f);

    sdrAfterPostProcess =
        max(sdrAfterPostProcess, 0.0f);


    float hdrLuminance =
        GetLuminance(hdrSource);

    float beforeLuminance =
        GetLuminance(sdrBeforePostProcess);

    float afterLuminance =
        GetLuminance(sdrAfterPostProcess);


    // Extremely dark pixels do not contain enough reliable chromatic
    // information for normalized-chroma reconstruction.
    //
    // Fall back to a simple additive post-process delta there.

    if (hdrLuminance <= 0.000001f
        || beforeLuminance <= 0.000001f
        || afterLuminance <= 0.000001f)
    {
        return max(
            hdrSource
                + (sdrAfterPostProcess - sdrBeforePostProcess),
            0.0f);
    }


    // -------------------------------------------------------------------------
    // Restore luminance delta
    // -------------------------------------------------------------------------

    float luminanceRatio =
        afterLuminance
        / beforeLuminance;


    float restoredLuminance =
        hdrLuminance
        * luminanceRatio;


    // -------------------------------------------------------------------------
    // Calculate chrominance in luminance-normalized RGB
    //
    // Each of these has a luminance of approximately 1.
    // -------------------------------------------------------------------------

    float3 hdrChrominance =
        hdrSource
        / hdrLuminance;


    float3 beforeChrominance =
        sdrBeforePostProcess
        / beforeLuminance;


    float3 afterChrominance =
        sdrAfterPostProcess
        / afterLuminance;


    // The actual post-processing chroma change.
    float3 chrominanceDelta =
        afterChrominance
        - beforeChrominance;


    // Apply that same chroma change to HDR.
    float3 restoredChrominance =
        hdrChrominance
        + chrominanceDelta;


    restoredChrominance =
        max(
            restoredChrominance,
            0.0f);


    float3 restoredColor =
        restoredChrominance
        * restoredLuminance;


    // max(..., 0) above can very slightly alter luminance.
    //
    // Renormalize so the luminance delta remains exact.

    float actualRestoredLuminance =
        GetLuminance(restoredColor);


    if (actualRestoredLuminance > 0.000001f)
    {
        restoredColor *=
            restoredLuminance
            / actualRestoredLuminance;
    }


    return max(
        restoredColor,
        0.0f);
}


// =============================================================================
// MAIN
// =============================================================================

void main(
    float4 v0 : SV_Position0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0)
{
    // -------------------------------------------------------------------------
    // Original scene inputs
    // -------------------------------------------------------------------------

    float3 sceneColor =
        t0.Sample(
            s0_s,
            v1.xy).rgb;


    float3 bloomColor =
        t4.Sample(
            s4_s,
            v1.xy).rgb;


    // =========================================================================
    // VANILLA SDR
    // =========================================================================

    if (!IsCustomHDRMode())
    {
        float3 colorSDR =
            saturate(
                sceneColor
                + bloomColor);


        colorSDR =
            ApplyGameLUTAndGrade(
                colorSDR);


        o0.rgb = colorSDR;
        o0.a   = 0.0f;

        return;
    }


    // =========================================================================
    // HDR
    // =========================================================================

    // Preferred basic NaN/negative-safe input behavior.
    sceneColor =
        max(
            sceneColor,
            0.0f);


    bloomColor =
        max(
            bloomColor,
            0.0f);


    float3 combinedColor =
        sceneColor
        + bloomColor
            * RENODX_BLOOM_STRENGTH;


    // Game framebuffer -> linear HDR.
    float3 hdrSource =
        renodx::color::gamma::DecodeSafe(
            max(
                combinedColor,
                0.0f));


    hdrSource =
        max(
            hdrSource,
            0.0f);


    // RenoDX pre-tonemap controls operate on the actual HDR signal.
    hdrSource =
        PreTonemapSliders(
            hdrSource);


    hdrSource =
        max(
            hdrSource,
            0.0f);


    // =========================================================================
    // 1. PER-CHANNEL ROLLOFF TO HDR PEAK
    // =========================================================================

    float hdrPeak =
        GetHDRPeakValue();


    float3 hdrLUTReference =
        PerChannelRolloffToHDRPeak(
            hdrSource,
            hdrPeak);


    // =========================================================================
    // 2. EXACT-WHITE-CLIP LUMINANCE ROLLOFF TO SDR
    // =========================================================================

    float lutWhiteClip =
        GetLUTWhiteClip();


    float3 sdrLuminanceReference =
        RolloffToSDRByLuminance(
            hdrLUTReference,
            lutWhiteClip);


    // =========================================================================
    // 3. SDR BLOWOUT + HUE CORRECTION
    // =========================================================================

    float3 clippedSDRReference =
        saturate(
            sdrLuminanceReference);


    float3 sdrReference =
        CorrectSDRBlowoutHue(
            hdrLUTReference,
            clippedSDRReference);


    sdrReference =
        saturate(
            sdrReference);


    // =========================================================================
    // VANILLA LUT
    //
    // LUT sees an ordinary SDR gamma-encoded image.
    // =========================================================================

    float3 lutInput =
        renodx::color::gamma::EncodeSafe(
            max(
                sdrReference,
                0.0f));


    float3 gradedLUTOutput =
        ApplyGameLUTAndGrade(
            lutInput);


    float3 gradedSDR =
        renodx::color::gamma::DecodeSafe(
            max(
                gradedLUTOutput,
                0.0f));


    gradedSDR =
        max(
            gradedSDR,
            0.0f);


    // Preserve RenoDX scene grading strength without using the old
    // mid-grey/reference reconstruction.
    gradedSDR =
        lerp(
            sdrReference,
            gradedSDR,
            saturate(
                RENODX_COLOR_GRADE_STRENGTH));


    // =========================================================================
    // 4. RESTORE POST-PROCESS CHROMINANCE + LUMINANCE DELTA ONTO HDR
    // =========================================================================

    float3 outputColor =
        RestorePostProcess(
            hdrSource,
            sdrReference,
            gradedSDR);


    // =========================================================================
    // FINAL HDR TONEMAPPER
    // =========================================================================

    if (IsPsychoV24Mode())
    {
        outputColor =
            ApplyPsychoV24HDRTonemap(
                outputColor);
    }


    outputColor =
        PostTonemapSliders(
            outputColor);


    outputColor =
        max(
            outputColor,
            0.0f);


    // Linear HDR -> game's expected output encoding.
    o0.rgb =
        renodx::color::gamma::EncodeSafe(
            outputColor);


    o0.a = 0.0f;
}