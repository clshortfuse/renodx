// Call of Duty: Black Ops Cold War
// RenoDX hash: 0xA93248D1
// Shader Model: ps_6_1
//
// Late native HDR output pass:
//
//   linear HDR
//     -> ST.2084 / PQ
//     -> native 32x32x32 LUT
//     -> 128x128 dithering
//     -> output quantization
//
// RenoDX modifications:
//
// VANILLA:
//   Completely reconstructed native behavior.
//   No black-floor correction.
//   No highlight unlock.
//   No RenoDX peak clamp.
//
// NON-VANILLA:
//
//   1. Protect absolute black from the native LUT:
//        <= 0.005 nits : raw PQ
//        0.005-0.20    : fade into native LUT
//
//   2. Preserve the native LUT color grade.
//
//   3. Reconstruct HDR brightness lost to the LUT in absolute-nit space:
//        - preserve LUT RGB/color relationships
//        - restore the pre-LUT max channel progressively in highlights
//        - no fixed arbitrary post-LUT brightness multiplier
//
//
//   4. Apply extreme-overshoot-only protection after reconstruction.
//
//      This prevents the LUT from re-expanding many bright values into the same
//      hard Peak Brightness ceiling. Only the post-dither safety clamp remains.
//
// PQ itself remains capable of representing up to 10,000 nits.

#include "./shared.h"


// ============================================================================
// Original resources
// ============================================================================

SamplerState samplerLUT : register(s0);

// Original DXIL bindings:
//
// t1 = source HDR image
// t2 = 32^3 HDR LUT
// t3 = 128x128 dither/noise texture

Texture2D<float4> codeTexture0 : register(t1);
Texture3D<float4> codeTexture1 : register(t2);
Texture2D<float4> codeTexture3 : register(t3);


// ============================================================================
// ST.2084 / PQ constants
// ============================================================================

static const float PQ_M1 = 0.1593017578125f;
static const float PQ_M2 = 78.84375f;

static const float PQ_C1 = 0.8359375f;
static const float PQ_C2 = 18.8515625f;
static const float PQ_C3 = 18.6875f;


// Cold War's source convention:
//
//     1.0 linear = approximately 100 nits
//
// ST.2084 normalized linear convention:
//
//     1.0 = 10,000 nits
//
// Therefore:
//
//     ColdWarLinear * 0.01
//
static const float COLDWAR_LINEAR_TO_PQ_NORMALIZED = 0.01f;

static const float COLDWAR_GAME_UNIT_NITS = 100.0f;


// ============================================================================
// Native 32^3 LUT coordinates
// ============================================================================
//
// Original DXIL:
//
//     saturate(PQ) * (31 / 32)
//                  + (0.5 / 32)
//

static const float COLDWAR_LUT_SCALE =
    31.0f / 32.0f;

static const float COLDWAR_LUT_OFFSET =
    0.5f / 32.0f;


// ============================================================================
// Near-black LUT correction
// ============================================================================
//
// <= 0.005 nits
//     Completely bypass native LUT.
//
// 0.005 -> 0.20 nits
//     Smoothly restore native LUT.
//
// >= 0.20 nits
//     Native LUT has full strength unless highlight release begins.
//

static const float BLACK_FIX_START_NITS = 0.005f;
static const float BLACK_FIX_END_NITS   = 0.20f;


// ============================================================================
// Highlight LUT release
// ============================================================================
//
// <= 900 nits
//     Full native LUT.
//
// 900 -> 1100 nits
//     Smoothly release native LUT.
//
// >= 1100 nits
//     Raw PQ result.
//
// This removes the apparent ~1000-nit ceiling imposed by the late HDR LUT.
//

// RenoDX-style HDR LUT brightness reconstruction.
//
// The LUT remains responsible for color. Brightness lost to the LUT is
// progressively reconstructed from the already-tonemapped pre-LUT HDR signal
// in absolute-nit space.
//
// 800-nit example:
//   <= ~320 nits : preserve native LUT luminance
//   320-680 nits : progressively restore pre-LUT highlight brightness
//   >= ~680 nits : fully preserve pre-LUT max-channel brightness
static const float LUT_RECONSTRUCT_START_RATIO = 0.40f;
static const float LUT_RECONSTRUCT_FULL_RATIO  = 0.85f;

// Safety cap for pathological LUT values. A normal 686 -> 400 nit loss needs
// only ~1.72x, so it is fully recoverable.
static const float LUT_RECONSTRUCT_MAX_GAIN = 4.00f;


// ============================================================================
// Extreme-overshoot-only highlight protection
// ============================================================================
//
// Normal display-range highlights are completely untouched.
//
// At an 800-nit Peak Brightness setting:
//     686 nits -> untouched
//     750 nits -> untouched
//     799 nits -> untouched
//     >800 nits -> smoothly folded into a narrow band below peak
//
// This is deliberately not a general highlight shoulder. It exists only to
// prevent true post-LUT overshoot from reaching the hard display ceiling.
//
static const float OVERSHOOT_BAND_START_RATIO  = 0.9900f;
static const float OVERSHOOT_BAND_TARGET_RATIO = 0.9975f;
static const float OVERSHOOT_RESPONSE_RATIO    = 0.10f;


// ============================================================================
// Safety helpers
// ============================================================================

float3 SafePositive(float3 color)
{
    return max(
        color,
        0.0f.xxx);
}


float Max3(float3 color)
{
    return max(
        color.r,
        max(
            color.g,
            color.b));
}


// ============================================================================
// ST.2084 / PQ encode
// ============================================================================
//
// Input:
//
//     Cold War linear HDR
//     1.0 = approximately 100 nits
//
// Output:
//
//     ST.2084 PQ
//
//     PQ 0 = 0 nits
//     PQ 1 = 10,000 nits
//

float3 PQEncode(float3 color)
{
    color =
        SafePositive(color);

    float3 linear10000 =
        color
        * COLDWAR_LINEAR_TO_PQ_NORMALIZED;

    linear10000 =
        SafePositive(linear10000);

    float3 powered =
        pow(
            linear10000,
            PQ_M1.xxx);

    float3 numerator =
        PQ_C1.xxx
        + PQ_C2.xxx
        * powered;

    float3 denominator =
        1.0f.xxx
        + PQ_C3.xxx
        * powered;

    float3 pq =
        pow(
            SafePositive(
                numerator
                / max(
                    denominator,
                    0.000001f.xxx)),
            PQ_M2.xxx);

    return saturate(pq);
}



// ============================================================================
// ST.2084 / PQ decode to absolute nits
// ============================================================================

float3 PQDecodeNits(float3 pqColor)
{
    pqColor =
        saturate(
            SafePositive(
                pqColor));

    float3 p =
        pow(
            pqColor,
            (1.0f / PQ_M2).xxx);

    float3 numerator =
        max(
            p - PQ_C1.xxx,
            0.0f.xxx);

    float3 denominator =
        max(
            PQ_C2.xxx
            - PQ_C3.xxx
            * p,
            0.000001f.xxx);

    float3 linear10000 =
        pow(
            numerator
            / denominator,
            (1.0f / PQ_M1).xxx);

    return SafePositive(
        linear10000
        * 10000.0f);
}


// ============================================================================
// HDR LUT max-channel reconstruction
// ============================================================================
//
// rawPQ    = pre-LUT HDR result after the primary tonemapper
// gradedPQ = native Cold War LUT result
//
// Decode both to absolute nits, preserve the LUT's RGB ratios/color, and
// progressively restore max-channel energy that the LUT removed.
//
// This does not invent brightness above the pre-LUT tonemapped signal.

float3 ReconstructLUTBrightnessPQ(
    float3 rawPQ,
    float3 gradedPQ,
    float configuredPeakNits)
{
    float3 rawNits =
        PQDecodeNits(
            rawPQ);

    float3 gradedNits =
        PQDecodeNits(
            gradedPQ);

    float rawPeakNits =
        Max3(
            rawNits);

    float gradedPeakNits =
        Max3(
            gradedNits);

    float restoreStartNits =
        configuredPeakNits
        * LUT_RECONSTRUCT_START_RATIO;

    float restoreFullNits =
        configuredPeakNits
        * LUT_RECONSTRUCT_FULL_RATIO;

    float restoreStrength =
        smoothstep(
            restoreStartNits,
            max(
                restoreFullNits,
                restoreStartNits + 0.001f),
            rawPeakNits);

    // Only restore brightness LOST to the LUT.
    // If the LUT is already brighter, leave that brightness unchanged here.
    float desiredGain =
        rawPeakNits
        / max(
            gradedPeakNits,
            0.0001f);

    desiredGain =
        clamp(
            desiredGain,
            1.0f,
            LUT_RECONSTRUCT_MAX_GAIN);

    float appliedGain =
        lerp(
            1.0f,
            desiredGain,
            restoreStrength);

    float3 reconstructedNits =
        SafePositive(
            gradedNits
            * appliedGain);

    // PQEncode expects Cold War linear units where 1.0 = 100 nits.
    return PQEncode(
        reconstructedNits
        / COLDWAR_GAME_UNIT_NITS);
}


// ============================================================================
// Extreme overshoot protection (PQ -> nits -> PQ)
// ============================================================================
//
// Only pixels whose brightest channel is ABOVE the configured peak enter this
// function's mapping. Everything at or below Peak Brightness returns unchanged.
// RGB is scaled uniformly to preserve hue/chromaticity.
//
float3 ApplyUnderPeakProtectionPQ(
    float3 pqColor)
{
    float3 linearNits =
        PQDecodeNits(
            pqColor);

    float sourcePeakNits =
        Max3(
            linearNits);

    float displayPeakNits =
        clamp(
            RENODX_PEAK_WHITE_NITS,
            1.0f,
            10000.0f);

    // IMPORTANT: normal highlights are completely untouched.
    if (sourcePeakNits <= displayPeakNits)
    {
        return pqColor;
    }

    float bandStartNits =
        displayPeakNits
        * OVERSHOOT_BAND_START_RATIO;

    float targetPeakNits =
        displayPeakNits
        * OVERSHOOT_BAND_TARGET_RATIO;

    float responseNits =
        max(
            displayPeakNits
            * OVERSHOOT_RESPONSE_RATIO,
            0.001f);

    float overshootNits =
        sourcePeakNits
        - displayPeakNits;

    // Only the TRUE overshoot controls the blend.
    // Just-over-peak values land near 99% of peak; progressively more extreme
    // values approach 99.75% instead of clipping to exactly Peak Brightness.
    float response =
        1.0f
        - exp(
            -overshootNits
            / responseNits);

    float mappedPeakNits =
        lerp(
            bandStartNits,
            targetPeakNits,
            saturate(response));

    float scale =
        mappedPeakNits
        / max(
            sourcePeakNits,
            0.000001f);

    float3 mappedNits =
        SafePositive(
            linearNits
            * scale);

    return PQEncode(
        mappedNits
        / COLDWAR_GAME_UNIT_NITS);
}


// ============================================================================
// Configured RenoDX peak -> PQ
// ============================================================================
//
// Convert:
//
//     RENODX_PEAK_WHITE_NITS
//
// into the same PQ domain used by this shader.
//
// Examples:
//
//     1000 nits  -> PQ code for 1000 nits
//     2000 nits  -> PQ code for 2000 nits
//     4000 nits  -> PQ code for 4000 nits
//     10000 nits -> PQ 1.0
//

float GetRenoDXPeakPQ()
{
    float peakNits =
        clamp(
            RENODX_PEAK_WHITE_NITS,
            1.0f,
            10000.0f);

    // PQEncode expects Cold War game-linear units:
    //
    //     1.0 = 100 nits
    //
    // Therefore:
    //
    //     gameLinear = peakNits / 100
    //

    float peakGameLinear =
        peakNits
        / COLDWAR_GAME_UNIT_NITS;

    float3 peakPQ =
        PQEncode(
            peakGameLinear.xxx);

    return peakPQ.r;
}


// ============================================================================
// Native HDR LUT
// ============================================================================

float3 SampleNativeHDRLUT(float3 pqColor)
{
    float3 lutCoordinates =
        saturate(pqColor)
        * COLDWAR_LUT_SCALE
        + COLDWAR_LUT_OFFSET;

    return codeTexture1.Sample(
        samplerLUT,
        lutCoordinates).rgb;
}


// ============================================================================
// Shader input
// ============================================================================

struct PSInput
{
    float4 position : SV_Position;
    float2 texcoord : TEXCOORD0;
};


// ============================================================================
// Main
// ============================================================================

float4 main(PSInput input) : SV_Target0
{
    // ------------------------------------------------------------------------
    // Original source load
    // ------------------------------------------------------------------------

    int2 sourcePixel =
        int2(input.texcoord);

    float3 linearHDR =
        codeTexture0.Load(
            int3(
                sourcePixel,
                0)).rgb;

    linearHDR =
        SafePositive(linearHDR);


    // ------------------------------------------------------------------------
    // Original ST.2084 / PQ encode
    // ------------------------------------------------------------------------

    float3 pqColor =
        PQEncode(
            linearHDR);


    // ------------------------------------------------------------------------
    // Original native 32^3 LUT
    // ------------------------------------------------------------------------

    float3 lutColor =
        SampleNativeHDRLUT(
            pqColor);


    // ------------------------------------------------------------------------
    // Output selection
    // ------------------------------------------------------------------------

    float3 outputColor;

    // Defaults to the full PQ maximum.
    // Vanilla never uses the RenoDX peak clamp.
    float configuredPeakPQ =
        1.0f;


    [branch]
    if (RENODX_TONE_MAP_TYPE < 0.5f)
    {
        // ====================================================================
        // VANILLA
        // ====================================================================
        //
        // Exact reconstructed Cold War behavior.
        //
        // No black fix.
        // No LUT highlight release.
        // No RenoDX peak clamp.
        //

        outputColor =
            lutColor;
    }
    else
    {
        // ====================================================================
        // RENO DX MODES
        // ====================================================================

        float inputNits =
            Max3(linearHDR)
            * COLDWAR_GAME_UNIT_NITS;


        // --------------------------------------------------------------------
        // Near-black LUT strength
        // --------------------------------------------------------------------

        float blackLUTStrength =
            smoothstep(
                BLACK_FIX_START_NITS,
                BLACK_FIX_END_NITS,
                inputNits);


        // --------------------------------------------------------------------
        // HDR LUT brightness reconstruction
        // --------------------------------------------------------------------

        float configuredPeakNits =
            max(
                RENODX_PEAK_WHITE_NITS,
                1.0f);

        float3 reconstructedLUT =
            ReconstructLUTBrightnessPQ(
                pqColor,
                lutColor,
                configuredPeakNits);


        // --------------------------------------------------------------------
        // Near-black LUT bypass + reconstructed LUT
        // --------------------------------------------------------------------
        //
        // Absolute black still bypasses the LUT. Everywhere else, keep the
        // native LUT color while using the reconstructed HDR brightness.
        //
        outputColor =
            lerp(
                pqColor,
                reconstructedLUT,
                saturate(
                    blackLUTStrength));


        // --------------------------------------------------------------------
        // Extreme-overshoot-only highlight protection
        // --------------------------------------------------------------------
        //
        // The native LUT can re-expand highlights after the primary tonemapper.
        // Only catch true post-LUT overshoot here. Normal highlights at or below
        // Peak Brightness remain completely unchanged.
        //
        outputColor =
            ApplyUnderPeakProtectionPQ(
                outputColor);

        // Emergency post-dither ceiling remains the REAL display peak. Because
        // the image shoulder targets below peak, this should almost never touch
        // actual highlight content.
        configuredPeakPQ =
            GetRenoDXPeakPQ();
    }


    // ------------------------------------------------------------------------
    // Original 128x128 dither/noise lookup
    // ------------------------------------------------------------------------

    int2 ditherPixel =
        int2(
            input.position.xy);

    ditherPixel.x &=
        127;

    ditherPixel.y &=
        127;

    float3 dither =
        codeTexture3.Load(
            int3(
                ditherPixel,
                0)).rgb;


    // ------------------------------------------------------------------------
    // Original final quantization
    // ------------------------------------------------------------------------

    float3 quantized =
        floor(
            outputColor
            * 877.0f
            + dither
            * 2.0f
            - 1.0f)
        / 876.0f;


    // ------------------------------------------------------------------------
    // Final post-dither peak ceiling
    // ------------------------------------------------------------------------
    //
    // This second clamp is intentional.
    //
    // Even if outputColor is exactly at the requested peak, the dither term can
    // move the final quantized code upward by roughly one output step.
    //
    // Clamp AFTER quantization so Peak Brightness really is the final maximum.
    //
    // Vanilla is intentionally excluded.
    //

    [branch]
    if (RENODX_TONE_MAP_TYPE >= 0.5f)
    {
        quantized =
            min(
                quantized,
                configuredPeakPQ.xxx);
    }


    return float4(
        quantized,
        1.0f);
}