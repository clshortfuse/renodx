//
// Call of Duty: World at War
//
// DIRECT HDR TONEMAPPER
//
// Absolutely NO RenderIntermediatePass.
//
// V5 keeps the exact direct-output look of this shader at the defaults:
//   Game Brightness = 203 nits
//   Gamma Correction = 2.2
//
// Only two minimal direct-output compensations are added:
//   1. Game Brightness compensation
//   2. Relative Gamma Correction control
//
// No EncodeColor, DecodeColor, RenderIntermediatePass, or color-space conversion.
//
// VANILLA:
//
//     original WaW shader
//          ↓
//       saturate
//
// HDR:
//
//     original WaW shader
//        UNCLAMPED
//          ↓
//     RenoDRT / Psycho
//          ↓
//       DIRECT OUTPUT
//
// No:
//   RenderIntermediatePass
//   EncodeColor
//   DecodeColor
//   ColorSpaces
//   GammaSafe
//   intermediate scaling
//   UpgradeToneMap
//   SDR reconstruction
//
// shared.h remains unchanged.
//

#include "./shared.h"


// ============================================================================
// Tone mapper IDs
// ============================================================================

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_RENODRT
#define RENODX_TONE_MAP_TYPE_RENODRT 3.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PSYCHO
#define RENODX_TONE_MAP_TYPE_PSYCHO 24.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PRAGMAP
#define RENODX_TONE_MAP_TYPE_PRAGMAP 31.0f
#endif


// ============================================================================
// Psycho + Pragmap
// ============================================================================
//
// Psycho is supplied by psychov.hlsl. Integration names are intentionally
// version-neutral so psychov.hlsl can be updated later without renaming them.
//

#include "../../shaders/tonemap/psychov/psychov.hlsl"
#include "./pragmap.hlsl"


// ============================================================================
// Original shader resources
// ============================================================================

sampler2D colorMapSampler : register(s0);

float4 colorTintBase  : register(c5);
float4 colorTintDelta : register(c6);
float4 colorBias      : register(c7);


// ============================================================================
// Pixel input
// ============================================================================

struct PixelInput
{
    float2 texCoord : TEXCOORD0;
};


// ============================================================================
// Original WaW luminance
// ============================================================================

static const float3 WAW_LUMINANCE =
    float3(
        0.298999995f,
        0.587000012f,
        0.114000000f
    );


// ============================================================================
// Safety
// ============================================================================
//
// Keeps every positive HDR value.
//
// Only:
//
//     NaN -> 0
//     negative -> 0
//     > FP16 finite maximum -> 65504
//

float SafePositive1(float value)
{
    value =
        (value == value)
        ? value
        : 0.0f;

    return min(
        max(
            value,
            0.0f
        ),
        65504.0f
    );
}


float3 SafePositive(float3 color)
{
    return float3(
        SafePositive1(color.r),
        SafePositive1(color.g),
        SafePositive1(color.b)
    );
}


// ============================================================================
// Mode selection
// ============================================================================

bool IsVanillaMode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_VANILLA
    ) < 0.5f;
}


bool IsPsychoMode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PSYCHO
    ) < 0.5f;
}


bool IsPragmapMode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PRAGMAP
    ) < 0.5f;
}


// ============================================================================
// EXACT ORIGINAL WORLD AT WAR SHADER
// ============================================================================
//
// Original:
//
//     texld_pp r0, v0, s0
//
//     dp3_pp r0.w,
//         r0,
//         float3(
//             0.299,
//             0.587,
//             0.114)
//
//     mad r0.xyz,
//         r0,
//         colorBias.w,
//         r0.w
//
//     tint =
//         colorTintDelta.rgb * luminance
//         + colorTintBase.rgb
//
//     output =
//         adjustedColor * tint
//         + colorBias.rgb
//
// There is no tonemapper.
//
// On the original 8-bit UNORM render target, >1 values were simply clipped.
//
// On FP16 those values survive and can be tone mapped directly.
//

float3 ApplyOriginalWaWShader(float3 color)
{
    // Original luminance.

    float luminance =
        dot(
            color,
            WAW_LUMINANCE
        );


    // Original:
    //
    // mad r0.xyz, r0, c7.w, r0.w

    float3 adjustedColor =
        color
        * colorBias.w
        + luminance.xxx;


    // Original:
    //
    // mov r1.xyz, c6
    // mad r1.xyz, r1, r0.w, c5

    float3 tint =
        colorTintDelta.rgb
        * luminance
        + colorTintBase.rgb;


    // Original:
    //
    // mad_pp oC0.xyz, r0, r1, c7

    return
        adjustedColor
        * tint
        + colorBias.rgb;
}


// ============================================================================
// RenoDRT
// ============================================================================
//
// This is the full native RenoDX grading/tone-mapping path.
//
// ToneMapPass gets its settings through BuildConfig:
//
//     Peak Brightness
//     Game Paper White
//
//     Exposure
//     Highlights
//     Shadows
//     Contrast
//     Saturation
//     Highlight Saturation
//     Blowout
//     Flare
//
//     Hue Correction
//     Hue Shift
//     Hue Processor
//
//     Working Color Space
//     Clamp Color Space
//     Clamp Peak
//     Per Channel
//
// None of these require RenderIntermediatePass.
//

float3 ApplyRenoDRT(
    float3 color,
    renodx::draw::Config config)
{
    color =
        SafePositive(
            color
        );


    color =
        renodx::draw::ToneMapPass(
            color,
            config
        );


    return SafePositive(
        color
    );
}


// ============================================================================
// RenoDX standard grading for custom tonemappers
// ============================================================================
//
// Psycho and Pragmap are separate tonemappers, so retain all of the
// normal RenoDX grading controls.
//
// RenoDX supports:
//
//     tone_map_type = VANILLA
//
// while retaining the grading controls.
//
// Therefore this stage performs:
//
//     Exposure
//     Highlights
//     Shadows
//     Contrast
//     Saturation
//     Highlight Saturation
//     Blowout
//     Flare
//     Hue Correction / Shift
//     working-space controls
//
// WITHOUT applying RenoDRT.
//
// Psycho then performs the actual display mapping.
//

float3 ApplyStandardRenoDXControlsForCustom(
    float3 color,
    renodx::draw::Config config)
{
    color =
        SafePositive(
            color
        );


    // Grading-only mode.

    config.tone_map_type =
        renodx::draw::TONE_MAP_TYPE_VANILLA;


    color =
        renodx::draw::ToneMapPass(
            color,
            config
        );


    return SafePositive(
        color
    );
}


// ============================================================================
// Psycho
// ============================================================================

float3 ApplyPsycho(
    float3 color,
    renodx::draw::Config config)
{
    color =
        ApplyStandardRenoDXControlsForCustom(
            SafePositive(color),
            config
        );

    float peakValue =
        max(
            RENODX_PEAK_WHITE_NITS
            / max(
                RENODX_DIFFUSE_WHITE_NITS,
                1.0f
            ),
            1.0f
        );

    int gamutMode =
        (RENODX_PSYCHO_GAMUT_MODE > 0.5f)
        ? 1
        : 0;

    // Common RenoDX grading controls were already applied above.
    // Dedicated Psycho controls are passed directly to psychov.hlsl.
    color =
        renodx::tonemap::psychov::psychotm_test30(
            color,
            peakValue,
            1.0f,                         // Exposure already applied
            1.0f,                         // Highlights already applied
            1.0f,                         // Shadows already applied
            1.0f,                         // Contrast already applied
            RENODX_PSYCHO_PURITY,
            1.0f,                         // compatibility placeholder
            100.0f,                       // compatibility placeholder
            1.0f,                         // compatibility placeholder
            1.0f,                         // compatibility placeholder
            0,                            // compatibility placeholder
            RENODX_PSYCHO_CONE_RESPONSE,
            0.18f.xxx,
            0.18f.xxx,
            RENODX_PSYCHO_GAMUT_COMPRESSION,
            gamutMode,
            1.0f,                         // compatibility placeholder
            RENODX_PSYCHO_COMPRESSION
        );

    return SafePositive(color);
}


// ============================================================================
// Pragmap
// ============================================================================

float3 ApplyPragmap(
    float3 color,
    renodx::draw::Config config)
{
    color =
        ApplyStandardRenoDXControlsForCustom(
            SafePositive(color),
            config
        );

    float peakValue =
        max(
            RENODX_PEAK_WHITE_NITS
            / max(
                RENODX_DIFFUSE_WHITE_NITS,
                1.0f
            ),
            1.0f
        );

    color =
        pragmap(
            color,
            peakValue,
            RENODX_PRAGMAP_HUE_STRENGTH,
            RENODX_PRAGMAP_BLOWOUT_STRENGTH
        );

    return SafePositive(color);
}


// ============================================================================
// HDR Boost
// ============================================================================

float3 ApplyHDRBoost(
    float3 color,
    float power,
    float normalizationPoint)
{
    if (power == 0.0f)
        return color;

    color = SafePositive(color);

    float smoothing = max(power * 2.0f, 1e-6f);

    float3 normalized =
        max(
            color / max(normalizationPoint, 1e-6f),
            0.0f.xxx
        );

    float3 boosted =
        normalizationPoint
        * pow(
            normalized,
            1.0f + power
        );

    float3 weight =
        color
        / (
            color / smoothing
            + 1.0f
        );

    color =
        max(
            color,
            lerp(color, boosted, weight)
        );

    return SafePositive(color);
}


// ============================================================================
// MINIMAL DIRECT-OUTPUT CONTROLS
// ============================================================================
//
// IMPORTANT:
// These controls are intentionally relative to the current correct-looking
// direct-output baseline.
//
// This means:
//   Game Brightness = 203 nits -> exact identity
//   Gamma = 2.2              -> exact identity
//
// Therefore the default image remains byte-for-byte as close as possible to
// the original direct-output version.
//
// No intermediate encoding is performed here.
// No color-space conversion is performed here.
// No RenderIntermediatePass is performed here.
// ============================================================================


// The addon currently defines 203 nits as the default Game Brightness.
// Keep this fixed reference local to this shader so changing UI Brightness
// cannot accidentally change scene brightness.
static const float WAW_REFERENCE_GAME_NITS = 203.0f;


// --------------------------------------------------------------------------
// Game Brightness compensation
// --------------------------------------------------------------------------
//
// ToneMapPass/Psycho already use:
//
//     Peak Brightness / Game Brightness
//
// to determine HDR headroom.
//
// By itself, increasing Game Brightness reduces that ratio and can make the
// picture darker. The normal RenoDX pipeline later applies an upward
// paper-white scale. This direct-output shader previously omitted that half.
//
// Restore ONLY that missing compensation:
//
//     output *= GameBrightness / 203
//
// At 203 nits this is exactly 1.0, so the current correct-looking image is
// unchanged.
//
// Because the tonemapper still receives the actual Game Brightness, this does
// not simply raise the peak without limit: the shoulder simultaneously adapts
// to the new paper white.
float3 ApplyDirectGameBrightness(float3 color)
{
    float gameNits =
        max(
            (float)RENODX_DIFFUSE_WHITE_NITS,
            1.0f
        );

    float scale =
        gameNits
        / WAW_REFERENCE_GAME_NITS;

    return SafePositive(
        color * scale
    );
}


// --------------------------------------------------------------------------
// Gamma Correction
// --------------------------------------------------------------------------
//
// The current direct-output shader looks correct with the addon's default
// Gamma Correction = 2.2, so V5 treats 2.2 as the visual reference.
//
// This is deliberately NOT the V4 approach:
//   - no direct EncodeColor()
//   - no intermediate encoding
//   - no RenderIntermediatePass
//
// Instead, change gamma RELATIVE to the known-good 2.2 baseline:
//
//   2.2     -> identity, preserves the current image exactly
//
//   Off     -> undo the 2.2 correction toward the uncorrected/sRGB response
//
//   BT.1886 -> convert the 2.2 baseline response to a 2.4 response
//
// GammaSafe is used so positive HDR values above 1.0 remain valid and negative
// values cannot create unsafe pow() behavior.
float3 ApplyDirectGammaCorrection(
    float3 color,
    renodx::draw::Config config)
{
    color =
        SafePositive(
            color
        );


    // Gamma 2.2 is the exact visual baseline of this direct-output version.
    if (config.gamma_correction
        == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2)
    {
        return color;
    }


    // Move from the assumed 2.2 baseline back toward the uncorrected/sRGB
    // response first.
    color =
        renodx::color::correct::GammaSafe(
            color,
            true,
            2.2f
        );


    // BT.1886 / 2.4:
    // after undoing the 2.2 reference, apply a 2.4 response.
    if (config.gamma_correction
        == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4)
    {
        color =
            renodx::color::correct::GammaSafe(
                color,
                false,
                2.4f
            );
    }


    // Gamma Off returns the uncorrected result from the 2.2 undo above.
    return SafePositive(
        color
    );
}


// Apply the two direct controls in the same conceptual order used by RenoDX:
// gamma/EOTF first, paper-white scaling second.
float3 ApplyMinimalDirectOutputControls(
    float3 color,
    renodx::draw::Config config)
{
    color =
        ApplyDirectGammaCorrection(
            color,
            config
        );


    color =
        ApplyDirectGameBrightness(
            color
        );


    return SafePositive(
        color
    );
}


// ============================================================================
// MAIN
// ============================================================================

float4 main(PixelInput input) : COLOR0
{
    // ========================================================================
    // Sample source
    // ========================================================================

    float4 sampledColor =
        tex2D(
            colorMapSampler,
            input.texCoord
        );


    // ========================================================================
    // EXACT ORIGINAL WaW COLOR
    // ========================================================================

    float3 originalColor =
        ApplyOriginalWaWShader(
            sampledColor.rgb
        );


    // ========================================================================
    // VANILLA
    // ========================================================================
    //
    // Emulate the original UNORM render-target clamp.
    //
    // This remains the true visual SDR reference.
    //
    // NOTHING ELSE touches Vanilla.
    // ========================================================================

    if (IsVanillaMode())
    {
        return float4(
            saturate(
                originalColor
            ),
            1.0f
        );
    }


    // ========================================================================
    // HDR SOURCE
    // ========================================================================
    //
    // The original WaW shader is now rendering into FP16.
    //
    // Therefore its >1 values are already available.
    //
    // That is our HDR source.
    // ========================================================================

    float3 hdrSource =
        lerp(
            sampledColor.rgb,
            originalColor,
            saturate(RENODX_COLOR_GRADE_STRENGTH)
        );

    float3 hdrColor =
        max(
            hdrSource,
            0.0f.xxx
        );


    hdrColor =
        SafePositive(
            hdrColor
        );


    // ========================================================================
    // RenoDX configuration
    // ========================================================================

    renodx::draw::Config config =
        renodx::draw::BuildConfig();

    hdrColor =
        ApplyHDRBoost(
            hdrColor,
            RENODX_HDR_BOOST,
            0.02f
        );


    // ========================================================================
    // Selected tonemapper
    // ========================================================================

    if (IsPsychoMode())
    {
        hdrColor =
            ApplyPsycho(
                hdrColor,
                config
            );
    }
    else if (IsPragmapMode())
    {
        hdrColor =
            ApplyPragmap(
                hdrColor,
                config
            );
    }
    else
    {
        hdrColor =
            ApplyRenoDRT(
                hdrColor,
                config
            );
    }


    hdrColor =
        SafePositive(
            hdrColor
        );


    // ========================================================================
    // MINIMAL DIRECT HDR OUTPUT
    // ========================================================================
    //
    // Keep the correct-looking direct output and apply ONLY:
    //
    //     1. relative Gamma Correction
    //     2. Game Brightness compensation
    //
    // At the defaults (Gamma 2.2 / Game 203 nits), both operations are identity.
    //
    // Still NO:
    //     RenderIntermediatePass
    //     EncodeColor
    //     DecodeColor
    //     color-space conversion
    //     UI/Game ratio
    // ========================================================================

    hdrColor =
        ApplyMinimalDirectOutputControls(
            hdrColor,
            config
        );


    return float4(
        hdrColor,
        1.0f
    );
}