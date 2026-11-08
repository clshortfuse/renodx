// Call of Duty: Black Ops Cold War
// RenoDX hash: 0xCB76A9C1
// Shader Model: ps_6_1
//
// PRIMARY HDR TONEMAPPER - EXTREME-ONLY PEAK PROTECTION SPLIT
//
// Tone mappers:
//
//   0  = Vanilla
//   3  = RenoDRT
//   30 = PsychoV30
//   31 = PrismTM
//
// Responsibility split:
//
//   CB76A9C1:
//     - reconstructs the original Cold War HDR scene composition
//     - preserves an exact Vanilla branch
//     - custom modes (port of CODWW2MapHDR, CODWW2/hdr.hlsli): the live scene
//       LUT runs FIRST and is followed as-is up to the mapper knee (45% of
//       Peak Brightness), continued at its local slope above that, then shared
//       grading, then RenoDRT / PsychoV30 / PrismTM compress only above the knee
//     - runs RenoDX RenderIntermediatePass for custom tone-map modes
//
//   A93248D1:
//     - keeps the later native PQ/output path
//     - corrects the near-black LUT floor
//     - releases the native HDR LUT above its old highlight ceiling
//
// psychov.hlsl is not modified. prismTM.hlsl keeps the supplied prism() as-is.

#include "../CODColdWar/shared.h"

// PsychoV30:
//   src/shaders/tonemap/psychov/psychov.hlsl
#include "../../shaders/tonemap/psychov/psychov.hlsl"

// PrismTM remains beside the game shader:
//   src/games/CODColdWar/prismTM.hlsl
#include "../CODColdWar/prismTM.hlsl"


// ============================================================================
// Original resources
// ============================================================================

Texture2D<float4> codeTexture0 : register(t0);
Texture3D<float3> codeTexture1 : register(t1);
Texture2D<float4> codeTexture2 : register(t2);
Texture2D<float4> codeTexture3 : register(t3);
Texture2D<float4> exposure     : register(t5);

SamplerState bilinearClamp : register(s0);


// The original PostFxCBuffer is 2064 bytes = 129 float4 registers.
cbuffer PostFxCBuffer : register(b6)
{
    float4 waterFFT_init_0;      // c0
    float4 waterFFT_init_1;      // c1
    float4 waterFFT_update;      // c2

    float4 postFxControl0;       // c3
    float4 postFxControl1;       // c4

    float4 _postFxUnused[124];   // c5 .. c128
};


// ============================================================================
// Native Cold War HDR constants
// ============================================================================

static const float COLDWAR_LINEAR_TO_PQ_NORMALIZED =
    0.01f;

// Cold War game-linear convention:
//     1.0 = 100 nits
static const float COLDWAR_GAME_UNIT_NITS =
    100.0f;


// Native very-high-HDR safety shoulder.
static const float COLDWAR_NATIVE_ROLLOFF_START_NORMALIZED =
    0.875f;

static const float COLDWAR_NATIVE_ROLLOFF_RANGE =
    0.125f;

static const float COLDWAR_NATIVE_ROLLOFF_RATE =
    0.11541559547185898f;

static const float COLDWAR_NATIVE_ROLLOFF_OFFSET =
    10.098865509033203f;


// SMPTE ST.2084 / PQ.
static const float PQ_M1 = 0.1593017578125f;
static const float PQ_M2 = 78.84375f;

static const float PQ_C1 = 0.8359375f;
static const float PQ_C2 = 18.8515625f;
static const float PQ_C3 = 18.6875f;


// Original centered 32^3 LUT coordinates.
static const float COLDWAR_LUT_SCALE =
    31.0f / 32.0f;

static const float COLDWAR_LUT_OFFSET =
    0.5f / 32.0f;


// ============================================================================
// Safety
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
// Mode helpers
// ============================================================================

bool IsPsychoV30Mode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - COLDWAR_TONE_MAP_TYPE_PSYCHOV30)
        < 0.5f;
}


bool IsPrismMode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - COLDWAR_TONE_MAP_TYPE_PRISM)
        < 0.5f;
}


// ============================================================================
// Native extreme-highlight rolloff
// ============================================================================

float NativeExtremeHighlightRolloffChannel(
    float gameLinear)
{
    float normalized =
        gameLinear
        * COLDWAR_LINEAR_TO_PQ_NORMALIZED;


    if (
        normalized
        <= COLDWAR_NATIVE_ROLLOFF_START_NORMALIZED)
    {
        return normalized;
    }


    float rolled =
        COLDWAR_NATIVE_ROLLOFF_START_NORMALIZED
        + COLDWAR_NATIVE_ROLLOFF_RANGE
        * (
            1.0f
            - exp(
                COLDWAR_NATIVE_ROLLOFF_OFFSET
                - COLDWAR_NATIVE_ROLLOFF_RATE
                * gameLinear));


    return saturate(
        rolled);
}


float3 NativeExtremeHighlightRolloff(
    float3 gameLinear)
{
    return float3(
        NativeExtremeHighlightRolloffChannel(
            gameLinear.r),

        NativeExtremeHighlightRolloffChannel(
            gameLinear.g),

        NativeExtremeHighlightRolloffChannel(
            gameLinear.b));
}


// ============================================================================
// Native PQ
// ============================================================================

float3 PQEncodeNormalized(
    float3 linear10000)
{
    linear10000 =
        SafePositive(
            linear10000);


    float3 p =
        pow(
            linear10000,
            PQ_M1.xxx);


    float3 numerator =
        PQ_C1.xxx
        + PQ_C2.xxx
        * p;


    float3 denominator =
        1.0f.xxx
        + PQ_C3.xxx
        * p;


    return pow(
        SafePositive(
            numerator
            / max(
                denominator,
                0.000001f.xxx)),
        PQ_M2.xxx);
}


// ============================================================================
// Native HDR LUT
// ============================================================================

float3 SampleNativeHDRLUT(
    float3 pqColor)
{
    float3 lutCoord =
        pqColor
        * COLDWAR_LUT_SCALE
        + COLDWAR_LUT_OFFSET;


    return codeTexture1.Sample(
        bilinearClamp,
        lutCoord);
}


// ============================================================================
// Reconstruct original Cold War HDR signal before PQ
// ============================================================================
//
// Returns normalized linear HDR:
//
//     1.0 = 10,000 nits
//

float3 BuildNativeLinearHDR(
    float2 texcoord)
{
    float3 sceneInput =
        codeTexture2.Sample(
            bilinearClamp,
            texcoord).rgb;


    float3 auxiliaryInput =
        codeTexture0.Sample(
            bilinearClamp,
            texcoord).rgb;


    float3 additiveInput =
        codeTexture3.Sample(
            bilinearClamp,
            texcoord).rgb;


    // Original exposure branch.
    if (postFxControl1.y > 0.0f)
    {
        float exposureValue =
            exposure.Load(
                int3(
                    8,
                    0,
                    0)).x;


        float exposureScale =
            postFxControl0.w
            / max(
                exposureValue,
                0.000001f);


        sceneInput *=
            exposureScale;
    }


    // Original scene composition.
    float3 sceneGameLinear =
        postFxControl0.rgb
        * sceneInput
        + additiveInput;


    float3 sceneNormalized =
        NativeExtremeHighlightRolloff(
            sceneGameLinear);


    // Original auxiliary path:
    //
    //     saturate(t0 * t0 * 0.01)
    //
    float3 auxiliaryNormalized =
        saturate(
            auxiliaryInput
            * auxiliaryInput
            * COLDWAR_LINEAR_TO_PQ_NORMALIZED);


    // Original screen blend:
    //
    //     A + B - A*B
    //
    float3 combinedNormalized =
        auxiliaryNormalized
        + sceneNormalized
        - auxiliaryNormalized
        * sceneNormalized;


    return SafePositive(
        combinedNormalized);
}


// ============================================================================
// Custom modes: live scene LUT first, selected mapper only above the knee
// ============================================================================
//
// Port of CODWW2MapHDR / CODWW2MapShoulder (src/games/CODWW2/hdr.hlsli).
//
// The scene LUT (t1) is Cold War's vanilla tonemapper: absolute PQ in,
// linear game units out (1.0 = 100 nits). Measured 2026-10-20 on a neutral
// ramp it is a continuous filmic curve: octave log-slopes 0.79-0.94 from
// 100 to 1600 nits, 0.68 and 0.46 above, ~2575 nits at PQ 1.0.
//
// The previous custom path ran the mapper FIRST and this LUT afterwards, so
// highlights were tone-mapped twice: a 10,000-nit scene value left this pass
// at ~1210 nits, 1000 nits at ~544 (LUT alone: 688).
//
// Now the LUT runs first. Because it never becomes near-linear, WWII's
// 0.9 log-slope shoulder test would stop at the first octave; instead the
// octave walk follows the LUT until its neutral output would pass the mapper
// knee (or half its own maximum). Below that the LUT is used as-is, so the
// vanilla tone and grade are kept. Above it luminance continues at the LUT's
// last octave slope, and the selected mapper compresses only above the knee.
// Grade colour is sampled one octave below the walk end (WWII behaviour).
//
// Units: nits for LUT values; "relative" is nits / Game Brightness.
// The LUT domain is treated as BT.2020 (it feeds the HDR10 output pass);
// mappers receive the same values the previous path gave them.

static const float3 BT2020_LUMINANCE = float3(0.2627f, 0.6780f, 0.0593f);
static const float LUT_BASE_NITS = 100.0f;      // LUT as-is below; first walk point
static const float LUT_CEILING_FRACTION = 0.5f; // never follow the LUT above half its maximum
static const float LUT_MAX_SLOPE = 1.5f;        // cap on the continuation slope
static const float SHOULDER_KNEE = 0.45f;       // fraction of Peak Brightness (as WWII)


float3 SampleSceneLUTNits(float3 nits)
{
    return codeTexture1.SampleLevel(
        bilinearClamp,
        PQEncodeNormalized(nits / 10000.0f) * COLDWAR_LUT_SCALE + COLDWAR_LUT_OFFSET,
        0) * COLDWAR_GAME_UNIT_NITS;
}


float NeutralSceneLUTY(float nits)
{
    return max(dot(SampleSceneLUTNits(nits.xxx), BT2020_LUMINANCE), 0.0001f);
}


// Shoulder start in relative units; never below diffuse white.
float ShoulderKneeRelative()
{
    return max(
        SHOULDER_KNEE * RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
        1.0f);
}


// Reserve the range below the knee. Each mapper's 0.18 anchor is translated
// to the knee so switching mappers does not compress midtones again. Shared
// grading has already run once, so the mappers get neutral grading.
float3 MapShoulder(float3 color, float knee)
{
    float peakRelative = max(
        RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f) - knee + 0.18f,
        0.180001f);

    [branch]
    if (IsPsychoV30Mode())
    {
        return renodx::tonemap::psychov::psychotm_test30(
            color, peakRelative, 1.0f, 1.0f, 1.0f, 1.0f,
            RENODX_PSYCHOV30_PURITY_SCALE, 1.0f, 100.0f, 1.0f, 1.0f, 0,
            max(RENODX_PSYCHOV30_CONE_RESPONSE, 0.0001f), 0.18f.xxx, 0.18f.xxx,
            RENODX_PSYCHOV30_GAMUT_COMPRESSION,
            RENODX_PSYCHOV30_GAMUT_TARGET >= 0.5f ? 1 : 0, 1.0f,
            RENODX_PSYCHOV30_COMPRESSION);
    }

    [branch]
    if (IsPrismMode())
    {
        return prism(color, peakRelative);
    }

    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.peak_white_nits = peakRelative * RENODX_DIFFUSE_WHITE_NITS;
    config.reno_drt_tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
    config.tone_map_exposure = 1.0f;
    config.tone_map_highlights = 1.0f;
    config.tone_map_shadows = 1.0f;
    config.tone_map_contrast = 1.0f;
    config.tone_map_saturation = 1.0f;
    config.tone_map_highlight_saturation = 1.0f;
    config.tone_map_blowout = 0.0f;
    config.tone_map_flare = 0.0f;
    return renodx::draw::ToneMapPass(color, config);
}


// Returns linear game units (1.0 = 100 nits), the scene LUT's output units.
float3 MapSceneHDR(float3 nativeLinear10000, float3 pixelLUTNits)
{
    float3 sourceNits = SafePositive(nativeLinear10000) * 10000.0f;
    float sourceY = max(dot(sourceNits, BT2020_LUMINANCE), 0.0f);
    float gradeStrength = saturate(RENODX_COLOR_GRADE_STRENGTH);
    float diffuseNits = max(RENODX_DIFFUSE_WHITE_NITS, 1.0f);
    float knee = ShoulderKneeRelative();

    float3 gradedNits;
    [branch]
    if (sourceY <= LUT_BASE_NITS)
    {
        float3 neutralNits = sourceNits
            * (NeutralSceneLUTY(sourceY) / max(sourceY, 0.000001f));
        gradedNits = lerp(neutralNits, pixelLUTNits, gradeStrength);
    }
    else
    {
        float kneeNits = knee * diffuseNits;
        float ceilingY = NeutralSceneLUTY(10000.0f) * LUT_CEILING_FRACTION;
        float shoulderX = LUT_BASE_NITS;
        float shoulderY = NeutralSceneLUTY(shoulderX);
        float slope = 1.0f;
        [loop]
        for (int i = 0; i < 7; ++i)  // walk up to 12800 nits
        {
            float nextY = NeutralSceneLUTY(shoulderX * 2.0f);
            if (nextY > kneeNits || nextY > ceilingY) break;
            slope = min(log2(nextY / shoulderY), LUT_MAX_SLOPE);
            shoulderX *= 2.0f;
            shoulderY = nextY;
        }

        float toneY = sourceY <= shoulderX
            ? NeutralSceneLUTY(sourceY)
            : shoulderY * pow(sourceY / shoulderX, slope);

        float sampleY = min(sourceY, max(shoulderX * 0.5f, LUT_BASE_NITS));
        float3 sampleNits = sourceNits * (sampleY / sourceY);
        float neutralY = NeutralSceneLUTY(sampleY);
        float3 neutralNits = sampleNits * (neutralY / sampleY);
        float3 nativeNits = sampleY < sourceY ? SampleSceneLUTNits(sampleNits) : pixelLUTNits;
        gradedNits = lerp(neutralNits, nativeNits, gradeStrength) * (toneY / neutralY);
    }

    float3 relative = gradedNits / diffuseNits;

    renodx::color::grade::Config grade = renodx::color::grade::config::Create();
    grade.exposure = RENODX_TONE_MAP_EXPOSURE;
    grade.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
    grade.shadows = RENODX_TONE_MAP_SHADOWS;
    grade.contrast = RENODX_TONE_MAP_CONTRAST;
    grade.flare = 0.10f * pow(max(RENODX_TONE_MAP_FLARE, 0.0f), 10.0f);
    grade.saturation = RENODX_TONE_MAP_SATURATION;
    grade.hue_correction_strength = 0.0f;
    relative = renodx::color::grade::config::ApplyUserColorGrading(relative, grade);

    if (!IsPsychoV30Mode() && RENODX_TONE_MAP_PER_CHANNEL == 0.0f)
    {
        float y = max(dot(relative, BT2020_LUMINANCE), 0.0f);
        if (y > knee)
        {
            float mappedY = MapShoulder((y - knee + 0.18f).xxx, knee).x;
            relative *= (knee + max(mappedY - 0.18f, 0.0f)) / y;
        }
    }
    else if (Max3(relative) > knee)
    {
        float3 aboveKnee = max(relative - knee, 0.0f);
        relative = min(relative, knee)
            + max(MapShoulder(aboveKnee + 0.18f, knee) - 0.18f, 0.0f);
    }

    // Chroma controls use absolute luminance (100-nit library normalization).
    grade = renodx::color::grade::config::Create();
    grade.hue_correction_strength = 0.0f;
    grade.dechroma = RENODX_TONE_MAP_BLOWOUT;
    grade.blowout = 1.0f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
    relative = renodx::color::grade::config::ApplyUserColorGrading(
        relative * (diffuseNits / 100.0f), grade) * (100.0f / diffuseNits);

    relative = SafePositive(renodx::draw::RenderIntermediatePass(SafePositive(relative)));

    // PQ is physically defined only through 10,000 nits; the display-peak
    // limit is applied after the late output LUT in A93248D1.
    return min(relative * diffuseNits, 10000.0f) / COLDWAR_GAME_UNIT_NITS;
}


// ============================================================================
// Main
// ============================================================================

struct PSInput
{
    float2 texcoord : TEXCOORD0;
    float4 position : SV_Position;
};


float4 main(
    PSInput input) : SV_Target0
{
    float3 nativeLinear10000 =
        BuildNativeLinearHDR(
            input.texcoord);


    // ------------------------------------------------------------------------
    // Vanilla
    // ------------------------------------------------------------------------

    [branch]
    if (
        RENODX_TONE_MAP_TYPE
        < 0.5f)
    {
        float3 nativePQ =
            PQEncodeNormalized(
                nativeLinear10000);


        float3 nativeOutput =
            SampleNativeHDRLUT(
                nativePQ);


        return float4(
            nativeOutput,
            1.0f);
    }


    // ------------------------------------------------------------------------
    // Custom modes: live scene LUT first, mapper above the knee (MapSceneHDR)
    // ------------------------------------------------------------------------

    float3 pixelLUTNits =
        SampleNativeHDRLUT(
            PQEncodeNormalized(
                nativeLinear10000))
        * COLDWAR_GAME_UNIT_NITS;

    return float4(
        MapSceneHDR(
            nativeLinear10000,
            pixelLUTNits),
        1.0f);
}