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
//   Measure the LUT black endpoint and remove its luminance floor in linear nits.
//   Restore highlight brightness with a uniform RGB scale, preserving LUT colour.
//   Use a continuous shoulder in the last 1% of the display range.
//   Keep native LUT coordinates, dithering and quantization; bound custom output.
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


// Keep the existing peak-relative recovery window for compatibility.
static const float LUT_RECONSTRUCT_START_RATIO = 0.40f;
static const float LUT_RECONSTRUCT_FULL_RATIO = 0.85f;
static const float OUTPUT_SHOULDER_START_RATIO = 0.99f;

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


// Measured black correction, analogous to lut::CorrectBlack at strength zero.
// This pass uses native BT.2020/PQ, so use BT.2020 luminance in absolute nits
// instead of the shared helper's BT.709 weights. Uniform scaling retains hue.
float3 CorrectLUTBlackNits(float3 gradedNits, float3 blackNits)
{
    const float3 lumaWeights = float3(0.2627f, 0.6780f, 0.0593f);
    float gradedY = dot(gradedNits, lumaWeights);
    float blackY = dot(blackNits, lumaWeights);
    if (blackY <= 0.0f) return gradedNits;
    return gradedNits * (max(gradedY - blackY, 0.0f) / max(gradedY, 1e-8f));
}

// Recover only energy lost to the LUT, using its RGB direction in linear light.
// Normalize before applying the target peak: no arbitrary gain ceiling that
// could leave strongly compressed highlights trapped below the display peak.
float3 ReconstructLUTBrightnessNits(
    float3 rawNits,
    float3 gradedNits,
    float configuredPeakNits)
{
    float rawPeak = Max3(rawNits);
    float gradedPeak = Max3(gradedNits);
    float strength = smoothstep(
        configuredPeakNits * LUT_RECONSTRUCT_START_RATIO,
        configuredPeakNits * LUT_RECONSTRUCT_FULL_RATIO,
        rawPeak);
    if (strength <= 0.0f || rawPeak <= gradedPeak) return gradedNits;
    float targetPeak = lerp(gradedPeak, rawPeak, strength);

    // A black/near-black LUT result has no reliable hue. Fade to the input
    // direction in this degenerate case instead of multiplying zero by infinity.
    const float epsilonNits = 1e-4f;
    float3 rawDirection = rawNits / max(rawPeak, epsilonNits);
    float3 direction = gradedNits / max(gradedPeak, epsilonNits)
        + rawDirection * (1.0f - saturate(gradedPeak / epsilonNits));
    return direction * (targetPeak / max(Max3(direction), 1e-8f));
}

// A bounded monotonic curve must start BELOW peak; folding only values above
// peak back underneath it creates a downward discontinuity. This exponential
// is value- and slope-continuous at 99% and scales RGB uniformly to retain hue.
float3 ApplyUnderPeakProtectionNits(float3 linearNits, float displayPeakNits)
{
    float sourcePeak = Max3(linearNits);
    float start = displayPeakNits * OUTPUT_SHOULDER_START_RATIO;
    if (sourcePeak <= start) return linearNits;
    float headroom = displayPeakNits - start;
    float mappedPeak = start + headroom
        * (1.0f - exp(-(sourcePeak - start) / headroom));
    return linearNits * (mappedPeak / sourcePeak);
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

        float configuredPeakNits = clamp(RENODX_PEAK_WHITE_NITS, 1.0f, 10000.0f);

        // Use the same PQ black coordinate as the pixel path, at explicit LOD 0.
        // This measures the current LUT, including changes with scene/settings.
        float3 blackPQ = PQEncode(0.0f.xxx);
        float3 blackNits = PQDecodeNits(codeTexture1.SampleLevel(
            samplerLUT, blackPQ * COLDWAR_LUT_SCALE + COLDWAR_LUT_OFFSET, 0).rgb);
        float3 gradedNits = CorrectLUTBlackNits(PQDecodeNits(lutColor), blackNits);
        float3 reconstructedNits = ReconstructLUTBrightnessNits(
            SafePositive(linearHDR) * COLDWAR_GAME_UNIT_NITS,
            gradedNits, configuredPeakNits);
        float3 outputNits = ApplyUnderPeakProtectionNits(
            reconstructedNits, configuredPeakNits);
        outputColor = PQEncode(outputNits / COLDWAR_GAME_UNIT_NITS);
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
        quantized = clamp(quantized, 0.0f.xxx, configuredPeakPQ.xxx);
    }


    return float4(
        quantized,
        1.0f);
}