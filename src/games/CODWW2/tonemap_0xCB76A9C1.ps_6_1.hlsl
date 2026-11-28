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
//   31 = Pragmap
//
// Responsibility split:
//
//   CB76A9C1:
//     - reconstructs the original Cold War HDR scene composition
//     - preserves an exact Vanilla branch
//     - performs RenoDRT / PsychoV30 / Pragmap display mapping
//     - prevents configured-peak overshoot in linear HDR
//     - runs RenoDX RenderIntermediatePass for custom tone-map modes
//
//   A93248D1:
//     - keeps the later native PQ/output path
//     - corrects the near-black LUT floor
//     - releases the native HDR LUT above its old highlight ceiling
//
// psychov.hlsl and pragmap.hlsl themselves are not modified.

#include "./shared.h"

// PsychoV30:
//   src/shaders/tonemap/psychov/psychov.hlsl
#include "../../shaders/tonemap/psychov/psychov.hlsl"

// Pragmap remains beside the game shader:
//   src/games/CODCOLDWAR/pragmap.hlsl
#include "./pragmap.hlsl"


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
// Custom-mode highlight rolloff + emergency peak protection
// ============================================================================
//
// The selected RenoDX tone mapper remains responsible for the main HDR mapping.
//
// A moderately stronger post-map shoulder starts at 85% of the configured display
// peak. The older 97% shoulder packed too many bright lights into the final few
// nits below Peak Brightness.
//
// Example at an 800-nit peak:
//     shoulder begins around 680 nits
//     a mapped 800-nit highlight becomes about 740 nits
//     stronger highlights progressively approach 800 nits
//
// The emergency guard below is separate and only catches real overshoot.
//
static const float HIGHLIGHT_ROLLOFF_START_RATIO =
    0.85f;

static const float PEAK_OVERSHOOT_TOLERANCE =
    1.002f;


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


bool IsPragmapMode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - COLDWAR_TONE_MAP_TYPE_PRAGMAP)
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
// Reference-white-relative display peak
// ============================================================================
//
// All custom display mappers are fed the same properly-normalized domain:
//
//     1.0 = RENODX_DIFFUSE_WHITE_NITS
//
// Therefore:
//
//     display peak = Peak Brightness / Game Brightness
//

float GetDisplayPeakRelative()
{
    float diffuseWhiteNits =
        max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f);


    return max(
        RENODX_PEAK_WHITE_NITS
        / diffuseWhiteNits,
        1.000001f);
}


// ============================================================================
// RenoDRT
// ============================================================================

float3 ApplyRenoDRT(
    float3 sceneRelative)
{
    sceneRelative =
        SafePositive(
            sceneRelative);


    renodx::draw::Config config =
        renodx::draw::BuildConfig();


    config.reno_drt_tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::REINHARD;


    float3 mapped =
        renodx::draw::ToneMapPass(
            sceneRelative,
            config);


    return SafePositive(
        mapped);
}


// ============================================================================
// PsychoV30
// ============================================================================
//
// IMPORTANT:
//
// This does NOT reproduce or alter PsychoV30's algorithm.
//
// It calls the original uploaded psychotm_test30() function and passes its
// existing parameters directly.
//

float3 ApplyPsychoV30(
    float3 sceneRelative)
{
    sceneRelative =
        SafePositive(
            sceneRelative);


    float displayPeak =
        GetDisplayPeakRelative();


    // PsychoV30's original implementation divides purity_scale by contrast.
    // Prevent only the invalid exact-zero configuration at the wrapper level.
    float psychoContrast =
        max(
            RENODX_TONE_MAP_CONTRAST,
            0.0001f);


    int gamutCompressionMode =
        RENODX_PSYCHOV30_GAMUT_TARGET >= 0.5f
            ? 1
            : 0;


    float3 mapped =
        renodx::tonemap::psychov::psychotm_test30(
            // Original direct linear BT.709 input.
            sceneRelative,

            // peak_value
            displayPeak,

            // exposure
            max(
                RENODX_TONE_MAP_EXPOSURE,
                0.0f),

            // highlights
            RENODX_TONE_MAP_HIGHLIGHTS,

            // shadows
            RENODX_TONE_MAP_SHADOWS,

            // contrast
            psychoContrast,

            // purity_scale
            RENODX_PSYCHOV30_PURITY_SCALE,

            // bleaching_intensity
            1.0f,

            // clip_point
            100.0f,

            // hue_restore
            1.0f,

            // encoded_response_power
            1.0f,

            // white_curve_mode
            0,

            // cone_response_exponent
            RENODX_PSYCHOV30_CONE_RESPONSE,

            // current_adaptive_state_bt709
            0.18f.xxx,

            // current_background_state_bt709
            0.18f.xxx,

            // gamut_compression
            RENODX_PSYCHOV30_GAMUT_COMPRESSION,

            // gamut_compression_mode
            //
            // 0       = BT.709
            // nonzero = BT.2020
            gamutCompressionMode,

            // adaptive_normalization
            1.0f,

            // compression
            RENODX_PSYCHOV30_COMPRESSION);


    return SafePositive(
        mapped);
}


// ============================================================================
// Pragmap
// ============================================================================
//
// IMPORTANT:
//
// The supplied Pragmap function is left completely unchanged.
//
// Original signature:
//
//     pragmap(
//         color,
//         peak,
//         hueStrength,
//         blowoutStrength)
//
// These sliders feed exactly those existing parameters.
//

float3 ApplyPragmap(
    float3 sceneRelative)
{
    sceneRelative =
        SafePositive(
            sceneRelative);


    // Pragmap does not expose exposure as one of its own arguments.
    // Apply RenoDX exposure to the incoming scene signal.
    sceneRelative *=
        max(
            RENODX_TONE_MAP_EXPOSURE,
            0.0f);


    float displayPeak =
        GetDisplayPeakRelative();


    float3 mapped =
        pragmap(
            sceneRelative,
            displayPeak,

            // Original hueStrength parameter.
            RENODX_PRAGMAP_HUE_STRENGTH,

            // Original blowoutStrength parameter.
            RENODX_PRAGMAP_BLOWOUT_STRENGTH);


    return SafePositive(
        mapped);
}


// ============================================================================
// Tone mapper selection
// ============================================================================

float3 ApplySelectedToneMapper(
    float3 sceneRelative)
{
    [branch]
    if (IsPsychoV30Mode())
    {
        return ApplyPsychoV30(
            sceneRelative);
    }


    [branch]
    if (IsPragmapMode())
    {
        return ApplyPragmap(
            sceneRelative);
    }


    // Only remaining custom UI mode is RenoDRT.
    return ApplyRenoDRT(
        sceneRelative);
}



// ============================================================================
// Gentle upper-highlight rolloff
// ============================================================================
//
// Input/output are RenoDX reference-white-relative linear values:
//
//     1.0 = RENODX_DIFFUSE_WHITE_NITS
//
// Rolloff is calculated from the brightest RGB channel, then RGB is scaled
// uniformly so highlight hue is preserved.
//
float RollOffHighlightPeakRelative(
    float value,
    float displayPeak)
{
    displayPeak =
        max(
            displayPeak,
            1.000001f);

    float shoulderStart =
        displayPeak
        * HIGHLIGHT_ROLLOFF_START_RATIO;

    if (value <= shoulderStart)
    {
        return value;
    }

    float shoulderRange =
        max(
            displayPeak
            - shoulderStart,
            0.000001f);

    float distance =
        max(
            value
            - shoulderStart,
            0.0f);

    // Rational shoulder:
    //   shoulderStart -> unchanged
    //   displayPeak   -> halfway through the remaining shoulder range
    //   extreme input -> approaches displayPeak smoothly
    return shoulderStart
        + shoulderRange
        * (
            distance
            / (
                distance
                + shoulderRange));
}


float3 ApplyGentleHighlightRolloff(
    float3 mappedRelative)
{
    mappedRelative =
        SafePositive(
            mappedRelative);

    float sourcePeak =
        Max3(
            mappedRelative);

    float displayPeak =
        GetDisplayPeakRelative();

    float shoulderStart =
        displayPeak
        * HIGHLIGHT_ROLLOFF_START_RATIO;

    if (sourcePeak <= shoulderStart)
    {
        return mappedRelative;
    }

    float rolledPeak =
        RollOffHighlightPeakRelative(
            sourcePeak,
            displayPeak);

    float scale =
        rolledPeak
        / max(
            sourcePeak,
            0.000001f);

    return SafePositive(
        mappedRelative
        * scale);
}


// ============================================================================
// Emergency configured-peak overshoot protection
// ============================================================================
//
// This is not another shoulder. It remains completely inactive unless the
// mapped result exceeds the configured peak by more than a tiny tolerance.
//
float3 ApplyPeakOvershootProtection(
    float3 mappedRelative)
{
    mappedRelative =
        SafePositive(
            mappedRelative);

    float sourcePeak =
        Max3(
            mappedRelative);

    float displayPeak =
        GetDisplayPeakRelative();

    float allowedPeak =
        displayPeak
        * PEAK_OVERSHOOT_TOLERANCE;

    if (sourcePeak <= allowedPeak)
    {
        return mappedRelative;
    }

    float scale =
        displayPeak
        / max(
            sourcePeak,
            0.000001f);

    return SafePositive(
        mappedRelative
        * scale);
}


// ============================================================================
// Cold War HDR -> scene relative -> display mapper -> Cold War HDR
// ============================================================================
//
// MIDTONE SCALE FIX:
//
// OLD:
//
//     Input:
//       1.0 relative = 100 nits
//
//     Output:
//       1.0 relative = Game Brightness, normally 203 nits
//
// That could turn:
//
//     100 nits -> 1.0 -> 203 nits
//
// and raise the middle range.
//
// NEW:
//
// Both directions use RENODX_DIFFUSE_WHITE_NITS.
//
// At Game Brightness = 203:
//
//     100 nits
//       -> 100 / 203
//       -> tonemapper
//       -> * 203
//
// so the bridge itself no longer adds the old ~2.03x mismatch.
//

float3 ApplyRenoDXToNativeHDR(
    float3 nativeLinear10000)
{
    float diffuseWhiteNits =
        max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f);

    // Native Cold War HDR:
    //
    //     1.0 = 10,000 nits
    //
    // RenoDX scene-relative:
    //
    //     1.0 = RENODX_DIFFUSE_WHITE_NITS
    //
    float3 sceneRelative =
        SafePositive(
            nativeLinear10000)
        * (
            10000.0f
            / diffuseWhiteNits);

    // Primary display mapping now lives in this shader.
    float3 mappedRelative =
        ApplySelectedToneMapper(
            sceneRelative);

    mappedRelative =
        SafePositive(
            mappedRelative);

    // No additional common highlight shoulder here.
    // RenoDRT / PsychoV30 / Pragmap keep full control of their mapped result.
    // Final overshoot-only protection is performed later in A93248D1, after
    // Cold War's remaining HDR output processing, so normal highlights are not
    // compressed twice.

    // RenoDX intermediate stage requested for the primary tonemapper.
    //
    // Vanilla deliberately does NOT pass through this function; the Vanilla
    // branch below remains the reconstructed original Cold War shader.
    mappedRelative =
        SafePositive(
            renodx::draw::RenderIntermediatePass(
                mappedRelative));

    // Convert back to Cold War's normalized absolute-linear HDR domain.
    float3 mappedLinear10000 =
        mappedRelative
        * (
            diffuseWhiteNits
            / 10000.0f);

    // PQ is physically defined only through 10,000 nits. This is only the
    // physical PQ-domain guard, not the configured display-peak limiter.
    return min(
        SafePositive(
            mappedLinear10000),
        1.0f.xxx);
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
    // Custom primary tonemapper:
    // RenoDRT / PsychoV30 / Pragmap -> peak protection -> RenderIntermediatePass
    // ------------------------------------------------------------------------

    float3 mappedLinear10000 =
        ApplyRenoDXToNativeHDR(
            nativeLinear10000);


    float3 mappedPQ =
        PQEncodeNormalized(
            mappedLinear10000);


    // Preserve Cold War's native HDR grading LUT.
    float3 gradedPQ =
        SampleNativeHDRLUT(
            mappedPQ);


    float sceneGradeStrength =
        saturate(
            RENODX_COLOR_GRADE_STRENGTH);


    float3 finalColor =
        lerp(
            mappedPQ,
            gradedPQ,
            sceneGradeStrength);


    return float4(
        SafePositive(
            finalColor),
        1.0f);
}