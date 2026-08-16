#include "./shared.h"

// ============================================================================
// Pragmap V2 - third HDR tonemapper
// ============================================================================
//
// Internal tone-map IDs:
//   0 = Vanilla
//   3 = RenoDRT / Ghosts-faithful HDR
//   4 = Pragmap V2
#ifndef RENODX_TONE_MAP_TYPE_PRAGMAPV2
#define RENODX_TONE_MAP_TYPE_PRAGMAPV2 4.0f
#endif

#include "./PragmapV2.hlsl"


// Tonemapper 5 (0xD1DAA81A) - Ghosts-faithful RenoDX HDR conversion.
//
// Vanilla mode:
//   preserves the pass's original rational tonemapper / LUT path.
//
// Strict HDR test path:
//   linear scene
//   -> RenoDX pre-tonemap controls
//   -> original Ghosts rational curve through the 0.18 pivot
//   -> exact first-derivative linear extension above the pivot
//   -> per-channel Hermite rolloff to the configured HDR peak
//   -> hue-direction correction
//   -> luminance rolloff to SDR with HDR peak as exact white clip
//   -> original 16x16x16 LUT
//   -> UpgradeToneMap(colorU, colorN, colorNGraded)
//   -> RenoDX post-tonemap controls
//   -> RenderIntermediatePass
//
// The old highlight-restoration and SDR color/shadow match stages remain
// available behind compile-time test toggles, but default OFF.
#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

// FXC can emit invalid D3D11 bytecode when an inlined abs() becomes a source
// modifier on an opcode that does not permit that modifier. The earlier
// max(x, -x) replacement was not sufficient because /O3 recognized it and
// converted it back into abs. These overloads clear the floating-point sign

// ============================================================================
// common.hlsl HDR Boost configuration
// ============================================================================

// Dedicated RenoDX slider value. The normal shared.h definition maps this to
// c59.w. The fallback keeps the shader buildable without the modified shared.h.
#ifndef RENODX_HDR_BOOST
#define RENODX_HDR_BOOST 0.0f
#endif

// This matches the normalization point used by the supplied common.hlsl.
#ifndef RENODX_HDR_BOOST_NORMALIZATION_POINT
#define RENODX_HDR_BOOST_NORMALIZATION_POINT 0.02f
#endif

// ============================================================================
// common.hlsl tonemapping pipeline configuration
// ============================================================================
#ifndef RENODX_COMMON_MID_GRAY
#define RENODX_COMMON_MID_GRAY 0.18f
#endif

// Maximum scene-light value supplied to the common Hermite display mapper.
// This is not an output clamp; the output peak still comes from the RenoDX
// Peak Brightness and Game Brightness settings.
#ifndef RENODX_COMMON_WHITE_CLIP
#define RENODX_COMMON_WHITE_CLIP 100.0f
#endif

// 1 = use the common gamma-domain gamut compression/decompression wrapper
// around the RenoDRT/Common Hermite display mapper.
#ifndef RENODX_COMMON_GAMUT_COMPRESSION
#define RENODX_COMMON_GAMUT_COMPRESSION 1
#endif

// ============================================================================
// Controlled HDR highlight restoration
// ============================================================================

// Restores part of the pre-tonemap HDR signal after the base RenoDX HDR mapper.
// Shadows, midtones, and Vanilla mode remain unchanged.
//
// 0.00 = normal tonemapper output
// 0.25 = moderate additional HDR brightness
// 0.50 = strong restoration
// 1.00 = approach the pre-tonemap signal in fully selected highlights
#ifndef RENODX_HDR_HIGHLIGHT_RESTORE
#define RENODX_HDR_HIGHLIGHT_RESTORE 0.35f
#endif

// Pre-tonemap peak where restoration begins.
#ifndef RENODX_HDR_HIGHLIGHT_START
#define RENODX_HDR_HIGHLIGHT_START 1.00f
#endif

// Pre-tonemap peak where the selected restoration strength becomes fully active.
#ifndef RENODX_HDR_HIGHLIGHT_FULL
#define RENODX_HDR_HIGHLIGHT_FULL 4.00f
#endif

// 1 = keep the restoration target at or below the configured display peak.
// 0 = allow restored values above the configured display peak.
#ifndef RENODX_HDR_RESTORE_LIMIT_TO_DISPLAY
#define RENODX_HDR_RESTORE_LIMIT_TO_DISPLAY 1
#endif

// ============================================================================
// Original shader resources
// ============================================================================
//
// Exact resource layout from the supplied disassembly:
//
//   t0 / s0 = scene color
//   t4 / s4 = 2D UV/distortion texture
//   t5 / s5 = original 16x16x16 color LUT
//   cb2      = original 37-entry constant buffer
//
// ============================================================================

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t4 : register(t4);
Texture3D<float4> t5 : register(t5);

SamplerState s0_s : register(s0);
SamplerState s4_s : register(s4);
SamplerState s5_s : register(s5);

cbuffer cb2 : register(b2)
{
    float4 cb2[37];
};

// ============================================================================
// Call of Duty: Ghosts pass configuration
// ============================================================================

// Preserve the game's original 16x16x16 3D LUT in Vanilla and HDR modes.
#ifndef RENODX_GHOSTS_USE_ORIGINAL_LUT
#define RENODX_GHOSTS_USE_ORIGINAL_LUT 1
#endif

// Maximum normalized value sent into the original Ghosts 3D LUT.
//
// Give the LUT 4% headroom instead of driving its top edge directly at 1.0.
// This is used as a SCALE, not a hard clamp, so bright values keep their
// separation:
//
//     0.00 -> 0.00
//     0.50 -> 0.48
//     1.00 -> 0.96
#ifndef RENODX_GHOSTS_LUT_INPUT_MAX
#define RENODX_GHOSTS_LUT_INPUT_MAX 0.96f
#endif


// The existing RenoDX Scene Grading slider controls the authored Ghosts LUT.
// RENODX_COLOR_GRADE_STRENGTH is 0.0 at 0% and 1.0 at 100%.
//
// 0%   = original rational tonemapper with no authored 3D LUT contribution
// 100% = the complete original authored LUT, matching the previous behavior
//
// The same strength is also used by the HDR-aware UpgradeToneMap path and by
// the SDR reference used for HDR color/luminance matching, so later matching
// stages cannot silently re-apply a full-strength LUT.

// Optional multiplier applied to the reconstructed linear scene before the
// RenoDX pre-tonemap controls. Leave at 1.0 unless the game's scene signal is
// systematically too dim or too bright after resource upgrading.
#ifndef RENODX_GHOSTS_HDR_INPUT_SCALE
#define RENODX_GHOSTS_HDR_INPUT_SCALE 1.0f
#endif

// ============================================================================
// Ghosts-faithful HDR rolloff experiment
// ============================================================================
//
// The original rational tonemapper is preserved through a mid-gray pivot.
// Above the pivot, its exact first derivative is extended linearly.
//
// That extended signal is then rolled PER CHANNEL to the configured HDR peak,
// followed by hue-direction correction.
//
// The old highlight-restoration and SDR-reference matching stages are optional
// and disabled by default so they cannot hide the behavior of this path.
#ifndef RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT
#define RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT 0.18f
#endif

#ifndef RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
#define RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION 1.0f
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE 0
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH 0
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH 0
#endif


// Partial absolute SDR color match, matching Tonemapper 1.
#ifndef RENODX_GHOSTS_SDR_ABSOLUTE_COLOR_MATCH
#define RENODX_GHOSTS_SDR_ABSOLUTE_COLOR_MATCH 0.35f
#endif

// Middle-gray sample used by the HDR LUT upgrade.
// Original SDR shadow/lower-midtone matcher.
//
// Darken-only:
//   - full strength through SDR Y <= 0.18
//   - fades out by SDR Y = 0.75
//   - never brightens HDR
#ifndef RENODX_GHOSTS_SDR_SHADOW_MATCH
#define RENODX_GHOSTS_SDR_SHADOW_MATCH 1.0f
#endif

#ifndef RENODX_GHOSTS_SDR_SHADOW_MATCH_FULL
#define RENODX_GHOSTS_SDR_SHADOW_MATCH_FULL 0.18f
#endif

#ifndef RENODX_GHOSTS_SDR_SHADOW_MATCH_END
#define RENODX_GHOSTS_SDR_SHADOW_MATCH_END 0.75f
#endif

// ============================================================================
// Soft SDR shadow/midtone luminance match with HDR release
// ============================================================================
//
// Do not substitute the Vanilla SDR pixel into HDR.
//
// Instead:
//   - preserve the HDR RGB/hue,
//   - guide HDR luminance toward the actual Vanilla SDR luminance,
//   - release early using PRE-TONEMAP HDR scene intensity.
//
// This avoids the dense ~100-nit SDR shoulder while keeping the SDR brightness
// character.
//
// Match SDR strongly through shadows/mid-gray.
// Release before the scene reaches the clipped SDR shoulder.
// Full configured SDR luminance guidance before scene-referred release.
// ============================================================================
// Shoulder-aware upper-SDR brightness match
// ============================================================================
//
// Match bright diffuse SDR values when HDR lands a little too low, but stop
// following SDR as the PRE-TONEMAP scene approaches the range where the SDR
// tonemapper is flattening/clipping.
//
// The correction is lift-only and scales RGB uniformly:
//   - SDR color/hue/saturation stay unchanged;
//   - HDR is never darkened;
//   - values already brighter than SDR are untouched;
//   - true HDR highlights are released from the SDR brightness target.
// Begin the extra lift in the upper SDR diffuse range.
// Full brightness-match strength by this SDR luminance, before shoulder release.
// Start releasing the SDR brightness target as the scene approaches the SDR
// shoulder. These use PRE-TONEMAP scene peak, not the clipped SDR result.
// Safety cap for this extra lift. It does not clamp final HDR output.
// 0 = Vanilla mode is converted to linear and sent through
//     RenderIntermediatePass. This is the correct default for RenoDX output.
// 1 = Vanilla mode reproduces the original sRGB encode and cb2[36] output-range
//     transform directly. Use only as a comparison/debug mode.
#ifndef RENODX_GHOSTS_EXACT_ENCODED_VANILLA
#define RENODX_GHOSTS_EXACT_ENCODED_VANILLA 0
#endif

// ============================================================================
// Safety helpers
// ============================================================================

float SafeFinitePositive1(float value)
{
    // Replace NaN with zero.
    value =
        (value == value)
        ? value
        : 0.0f;

    // Tonemappers expect positive scene-light values.
    //
    // 65504 is the largest finite value representable by float16.
    // This does not clamp HDR values to 1.0.
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

// ============================================================================
// Extra HDR NaN / INF protection
// ============================================================================
//
// `max(color, 0)` remains the first/default cleanup for color values.
//
// These helpers cover the cases max() alone cannot fix:
//   - NaN
//   - +INF / -INF
//   - invalid zero-base negative powers
//
// Finite positive HDR is preserved up to FP16's real maximum (65504).
float GhostsFiniteSigned1(float value)
{
    if (value != value)
        return 0.0f;

    return clamp(
        value,
        -65504.0f,
        65504.0f
    );
}

float2 GhostsFiniteSigned2(float2 value)
{
    return float2(
        GhostsFiniteSigned1(value.x),
        GhostsFiniteSigned1(value.y)
    );
}

float3 GhostsFiniteSigned3(float3 value)
{
    return float3(
        GhostsFiniteSigned1(value.x),
        GhostsFiniteSigned1(value.y),
        GhostsFiniteSigned1(value.z)
    );
}

float4 GhostsFiniteSigned4(float4 value)
{
    return float4(
        GhostsFiniteSigned1(value.x),
        GhostsFiniteSigned1(value.y),
        GhostsFiniteSigned1(value.z),
        GhostsFiniteSigned1(value.w)
    );
}

float GhostsSafePositiveParameter1(
    float value,
    float fallbackValue)
{
    if (value != value)
        value = fallbackValue;

    return clamp(
        value,
        0.0f,
        65504.0f
    );
}

float GhostsSafePowPositive1(
    float baseValue,
    float exponent)
{
    baseValue =
        SafeFinitePositive1(
            max(baseValue, 0.0f)
        );

    exponent =
        GhostsFiniteSigned1(
            exponent
        );

    // Avoid 0 raised to a negative exponent -> INF.
    if (baseValue <= 0.0f)
    {
        if (exponent < 0.0f)
            return 0.0f;

        if (exponent == 0.0f)
            return 1.0f;

        return 0.0f;
    }

    return SafeFinitePositive1(
        pow(
            max(baseValue, 0.00000001f),
            exponent
        )
    );
}


float3 ApplyGhostsPartialAbsoluteSDRColorMatch(
    float3 hdrColor,
    float3 sdrReference)
{
    hdrColor = SafePositive(max(hdrColor, 0.0f.xxx));
    sdrReference = saturate(SafePositive(max(sdrReference, 0.0f.xxx)));

    const float epsilon = 0.000001f;

    float hdrLuminance =
        max(
            renodx::color::y::from::BT709(hdrColor),
            0.0f
        );

    float sdrLuminance =
        max(
            renodx::color::y::from::BT709(sdrReference),
            0.0f
        );

    if (sdrLuminance <= epsilon)
    {
        return hdrColor;
    }

    // Absolute SDR chromaticity, normalized to the HDR luminance.
    float3 sdrMatchedColor =
        sdrReference
        * (hdrLuminance / sdrLuminance);

    float strength =
        saturate(RENODX_GHOSTS_SDR_ABSOLUTE_COLOR_MATCH);

    return SafePositive(
        max(
            lerp(
                hdrColor,
                sdrMatchedColor,
                strength
            ),
            0.0f.xxx
        )
    );
}


float MaxRGB(float3 color)
{
    return max(
        color.r,
        max(
            color.g,
            color.b
        )
    );
}

// Correct only the hue direction shifted by the per-channel rolloff.
//
// The rolled-off OkLab chroma magnitude is intentionally retained, so this does
// not undo the desired per-channel highlight blowout/desaturation.
float3 CorrectGhostsPerChannelRolloffHue(
    float3 preRolloffColor,
    float3 rolledOffColor)
{
    preRolloffColor =
        SafePositive(
            max(preRolloffColor, 0.0f)
        );

    rolledOffColor =
        SafePositive(
            max(rolledOffColor, 0.0f)
        );

    float strength =
        saturate(
            RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
        );

    if (strength <= 0.000001f)
    {
        return rolledOffColor;
    }

    float3 sourceLab =
        renodx::color::oklab::from::BT709(
            preRolloffColor
        );

    float3 rolledLab =
        renodx::color::oklab::from::BT709(
            rolledOffColor
        );

    float sourceChroma =
        length(sourceLab.yz);

    float rolledChroma =
        length(rolledLab.yz);

    if (
        sourceChroma <= 0.000001f
        || rolledChroma <= 0.000001f
    )
    {
        return rolledOffColor;
    }

    float2 sourceHueDirection =
        sourceLab.yz / sourceChroma;

    float2 hueCorrectedChroma =
        sourceHueDirection * rolledChroma;

    rolledLab.yz =
        lerp(
            rolledLab.yz,
            hueCorrectedChroma,
            strength
        );

    float3 correctedColor =
        renodx::color::bt709::from::OkLab(
            rolledLab
        );

    correctedColor =
        renodx::color::bt709::clamp::AP1(
            correctedColor
        );

    return SafePositive(
        max(correctedColor, 0.0f)
    );
}

float SmoothCubic01(float value)
{
    value = saturate(value);

    return value
        * value
        * (3.0f - 2.0f * value);
}

// common.hlsl HDRBoost curve, adapted with finite-value protection.
//
// The slider is the original `power` parameter:
//   0.00 = disabled
//   0.20 = common.hlsl default
//   0.50 = maximum exposed by the addon slider
//
// Keeping power at or below 0.50 also keeps the original per-channel lerp
// factor from asymptotically exceeding 1.0.
float3 ApplyCommonHDRBoost(
    float3 color,
    float power,
    float normalizationPoint
)
{
    color = SafePositive(color);

    power = clamp(
        power,
        0.0f,
        0.50f
    );

    if (power <= 0.000001f)
    {
        return color;
    }

    normalizationPoint = max(
        normalizationPoint,
        0.000001f
    );

    float smoothing = max(
        power * 2.0f,
        0.000001f
    );

    float3 normalizedColor =
        color / normalizationPoint;

    float3 poweredColor =
        normalizationPoint
        * pow(
            normalizedColor,
            (1.0f + power).xxx
        );

    // This is the same adaptive blend factor used by common.hlsl. It gives
    // progressively more boost to highlights while leaving dark values close
    // to their original level.
    float3 blendAmount =
        color
        / (
            color / smoothing
            + 1.0f
        );

    float3 boostedColor = lerp(
        color,
        poweredColor,
        blendAmount
    );

    // The original function never reduces a channel.
    boostedColor = max(
        color,
        boostedColor
    );

    return SafePositive(boostedColor);
}

// ============================================================================
// common.hlsl reusable tone-mapping helpers
// ============================================================================

// Compress out-of-gamut color in gamma space before the display mapper, then
// restore it afterward. This keeps saturated HDR highlights from shifting hue
// as aggressively during luminance or per-channel rolloff.
void CommonGamutCompression(
    inout float3 color,
    out float compressionScale
)
{
    color = SafePositive(color);

    float3 gammaColor =
        renodx::color::gamma::EncodeSafe(color);

    float grayscale =
        renodx::color::y::from::BT709(gammaColor);

    compressionScale =
        renodx::color::correct::ComputeGamutCompressionScale(
            gammaColor,
            grayscale
        );

    gammaColor =
        renodx::color::correct::GamutCompress(
            gammaColor,
            grayscale,
            compressionScale
        );

    color =
        renodx::color::gamma::DecodeSafe(gammaColor);

    color =
        renodx::color::bt709::clamp::BT709(color);

    color = SafePositive(color);
}

void CommonGamutDecompression(
    inout float3 color,
    float compressionScale
)
{
    color = SafePositive(color);

    float3 gammaColor =
        renodx::color::gamma::EncodeSafe(color);

    gammaColor =
        renodx::color::correct::GamutDecompress(
            gammaColor,
            compressionScale
        );

    color =
        renodx::color::gamma::DecodeSafe(gammaColor);

    color = SafePositive(color);
}

// Applies Exposure, Contrast, Flare, Highlights, and Shadows using luminance.
// RGB is scaled uniformly, avoiding the per-channel hue shifts that occur when
// those controls are applied independently to red, green, and blue.
float3 CommonApplyPreTonemapControlsByLuminance(
    float3 untonemapped,
    float luminance,
    renodx::color::grade::Config config,
    float midGray
)
{
    untonemapped = SafePositive(untonemapped);
    midGray = max(midGray, 0.000001f);

    if (
        config.exposure == 1.0f
        && config.shadows == 1.0f
        && config.highlights == 1.0f
        && config.contrast == 1.0f
        && config.flare == 0.0f
    )
    {
        return untonemapped;
    }

    float3 color =
        untonemapped * config.exposure;

    // Exposure changes luminance by the same amount.
    float exposedLuminance =
        max(luminance * config.exposure, 0.0f);

    float normalizedY =
        exposedLuminance / midGray;

    float highlightMask =
        1.0f / midGray;

    float shadowMask =
        midGray;

    float flare =
        renodx::math::DivideSafe(
            normalizedY + config.flare,
            normalizedY,
            1.0f
        );

    float exponent =
        config.contrast * flare;

    float contrastedY =
        pow(
            max(normalizedY, 0.0f),
            exponent
        );

    float highlightedY =
        GhostsSafePowPositive1(
            contrastedY,
            config.highlights
        );

    highlightedY =
        lerp(
            contrastedY,
            highlightedY,
            saturate(contrastedY / highlightMask)
        );

    float shadowedY =
        pow(
            max(highlightedY, 0.0f),
            -1.0f * (config.shadows - 2.0f)
        );

    shadowedY =
        lerp(
            shadowedY,
            highlightedY,
            saturate(highlightedY / shadowMask)
        );

    float finalY =
        shadowedY * midGray;

    color *=
        exposedLuminance > 0.0f
        ? finalY / exposedLuminance
        : 0.0f;

    return SafePositive(color);
}

// Applies Saturation, Blowout/dechroma, and Highlight Saturation after the
// display mapper in OkLab, matching the common.hlsl ordering.
float3 CommonApplyPostTonemapControls(
    float3 tonemapped,
    float luminance,
    renodx::color::grade::Config config
)
{
    float3 color = SafePositive(tonemapped);

    if (
        config.saturation != 1.0f
        || config.dechroma != 0.0f
        || config.blowout != 0.0f
    )
    {
        float3 perceptual =
            renodx::color::oklab::from::BT709(color);

        if (config.dechroma != 0.0f)
        {
            float highlightAmount =
                saturate(
                    pow(
                        max(luminance / 100.0f, 0.0f),
                        1.0f - config.dechroma
                    )
                );

            perceptual.yz *=
                lerp(
                    1.0f,
                    0.0f,
                    highlightAmount
                );
        }

        if (config.blowout != 0.0f)
        {
            float percentMax =
                saturate(luminance / 100.0f);

            // Avoid abs() here. FXC can incorrectly preserve an absolute-value
            // source modifier on the generated pow/log instruction sequence,
            // producing bytecode rejected by the D3D11 validator.
            float blowoutMagnitude = config.blowout;

            if (blowoutMagnitude < 0.0f)
            {
                blowoutMagnitude = -blowoutMagnitude;
            }

            float blowoutChange =
                pow(
                    1.0f - percentMax,
                    100.0f * blowoutMagnitude
                );

            if (config.blowout < 0.0f)
            {
                blowoutChange =
                    2.0f - blowoutChange;
            }

            perceptual.yz *=
                blowoutChange;
        }

        perceptual.yz *=
            config.saturation;

        color =
            renodx::color::bt709::from::OkLab(perceptual);

        color =
            renodx::color::bt709::clamp::AP1(color);
    }

    return SafePositive(color);
}

float3 ApplyCommonPreTonemapPipeline(float3 untonemapped)
{
    untonemapped = SafePositive(untonemapped);

    // Match the supplied common.hlsl ordering: HDR Boost first, then the
    // luminance-based pre-tonemap grading controls.
    untonemapped =
        ApplyCommonHDRBoost(
            untonemapped,
            RENODX_HDR_BOOST,
            RENODX_HDR_BOOST_NORMALIZATION_POINT
        );

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.exposure =
        RENODX_TONE_MAP_EXPOSURE;

    config.contrast =
        RENODX_TONE_MAP_CONTRAST;

    config.flare =
        RENODX_TONE_MAP_FLARE;

    config.shadows =
        RENODX_TONE_MAP_SHADOWS;

    config.highlights =
        RENODX_TONE_MAP_HIGHLIGHTS;

    float luminance =
        renodx::color::y::from::BT709(untonemapped);

    return CommonApplyPreTonemapControlsByLuminance(
        untonemapped,
        luminance,
        config,
        RENODX_COMMON_MID_GRAY
    );
}

float3 ApplyCommonPostTonemapPipeline(float3 hdrColor)
{
    hdrColor = SafePositive(hdrColor);

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.saturation =
        RENODX_TONE_MAP_SATURATION;

    // Common.hlsl maps Blowout to highlight dechroma.
    config.dechroma =
        RENODX_TONE_MAP_BLOWOUT;

    // Highlight Saturation is represented as a signed blowout adjustment:
    // 1.0 is neutral, below 1.0 removes highlight chroma, above 1.0 retains it.
    config.blowout =
        -1.0f
        * (
            RENODX_TONE_MAP_HIGHLIGHT_SATURATION
            - 1.0f
        );

    float luminance =
        renodx::color::y::from::BT709(hdrColor);

    return CommonApplyPostTonemapControls(
        hdrColor,
        luminance,
        config
    );
}

// Common Hermite HDR display mapper. Peak output is determined by the ratio of
// RenoDX Peak Brightness to Game Brightness. Luminance mode preserves hue;
// Per Channel mode intentionally rolls individual channels toward white.
float3 ApplyCommonHDRDisplayMap(float3 color)
{
    color = SafePositive(color);

    float peakTonemap = max(
        RENODX_PEAK_WHITE_NITS
        / max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f
        ),
        1.0f
    );

    color =
        renodx::color::bt709::clamp::AP1(color);

    float compressionScale = 1.0f;

#if RENODX_COMMON_GAMUT_COMPRESSION

    CommonGamutCompression(
        color,
        compressionScale
    );

#endif

    float whiteClip = max(
        RENODX_COMMON_WHITE_CLIP,
        peakTonemap + 0.000001f
    );

    // Initialize before branching to prevent FXC from reporting or propagating
    // a potentially-uninitialized aggregate after aggressive inlining.
    float3 outputColor = 0.0f.xxx;

    if (RENODX_TONE_MAP_PER_CHANNEL < 0.5f)
    {
        outputColor =
            renodx::tonemap::HermiteSplineLuminanceRolloff(
                color,
                peakTonemap,
                whiteClip
            );
    }
    else
    {
        outputColor =
            renodx::tonemap::HermiteSplinePerChannelRolloff(
                color,
                peakTonemap,
                whiteClip
            );
    }

#if RENODX_COMMON_GAMUT_COMPRESSION

    CommonGamutDecompression(
        outputColor,
        compressionScale
    );

#endif

    return SafePositive(outputColor);
}

// Blend selected pre-tonemap HDR energy back into the tonemapped result.
// The restoration mask is based on pre-tonemap peak brightness, and RGB is
// scaled uniformly when limiting to the display peak so highlight hue is kept.
float3 RestoreHDRHighlights(
    float3 toneMappedColor,
    float3 preTonemapColor
)
{
    toneMappedColor =
        SafePositive(toneMappedColor);

    preTonemapColor =
        SafePositive(preTonemapColor);

    float preTonemapPeak =
        MaxRGB(preTonemapColor);

    float restoreRange = max(
        RENODX_HDR_HIGHLIGHT_FULL
        - RENODX_HDR_HIGHLIGHT_START,
        0.000001f
    );

    float restoreMask = saturate(
        (
            preTonemapPeak
            - RENODX_HDR_HIGHLIGHT_START
        )
        / restoreRange
    );

    restoreMask =
        SmoothCubic01(restoreMask);

    restoreMask *=
        saturate(RENODX_HDR_HIGHLIGHT_RESTORE);

    float3 restorationTarget =
        preTonemapColor;

#if RENODX_HDR_RESTORE_LIMIT_TO_DISPLAY

    // HDR values are relative to diffuse white.
    float displayPeak = max(
        RENODX_PEAK_WHITE_NITS
        / max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f
        ),
        1.0f
    );

    if (preTonemapPeak > displayPeak)
    {
        restorationTarget *=
            displayPeak
            / max(
                preTonemapPeak,
                0.000001f
            );
    }

#endif

    return SafePositive(
        lerp(
            toneMappedColor,
            restorationTarget,
            restoreMask
        )
    );
}

// ============================================================================
// Tone-map mode selection
// ============================================================================

bool IsVanillaMode()
{
    // Avoid abs() in this shader as well. Use a two-sided comparison instead.
    float modeDelta =
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_VANILLA;

    return
        modeDelta > -0.5f
        && modeDelta < 0.5f;
}

bool IsPragmapV2Mode()
{
    float modeDelta =
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PRAGMAPV2;

    return modeDelta > -0.5f
        && modeDelta < 0.5f;
}

// ============================================================================
// PsychoV24 HDR display mapper
// ============================================================================

// ============================================================================
// Pragmap V2 HDR display mapper
// ============================================================================
//
// Pragmap is a complete display mapper and therefore runs as a PARALLEL branch
// to the Ghosts/RenoDRT tangent + Hermite path.
//
// It receives pre-tonemap linear color and uses peak brightness relative to
// diffuse white, matching the RenoDX HDR-domain convention used by this mod.
float3 ApplyPragmapV2Tonemap(float3 linearColor)
{
    linearColor =
        SafePositive(
            max(linearColor, 0.0f)
        );

    float safePeakWhite =
        GhostsSafePositiveParameter1(
            RENODX_PEAK_WHITE_NITS,
            1000.0f
        );

    float safeDiffuseWhite =
        max(
            GhostsSafePositiveParameter1(
                RENODX_DIFFUSE_WHITE_NITS,
                203.0f
            ),
            1.0f
        );

    float displayPeak =
        clamp(
            safePeakWhite / safeDiffuseWhite,
            1.000001f,
            65504.0f
        );

    // HDR color itself remains unclamped above 1.0.
    //
    // The original Pragmap Hue/Blowout defaults are quite subtle in this game.
    // Preserve those defaults EXACTLY, but expand the upper part of each UI
    // slider so 100% produces a clearly stronger testable effect.

    float hueControl =
        saturate(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_HUE_STRENGTH
            )
        );

    float pragmapHueStrength =
        hueControl;

    if (hueControl > 0.25f)
    {
        float hueHighRange =
            saturate(
                (hueControl - 0.25f)
                / 0.75f
            );

        pragmapHueStrength =
            lerp(
                0.25f,
                4.0f,
                hueHighRange
            );
    }

    float blowoutControl =
        saturate(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_BLOWOUT_STRENGTH
            )
        );

    float pragmapBlowoutStrength =
        blowoutControl;

    if (blowoutControl > 0.20f)
    {
        float blowoutHighRange =
            saturate(
                (blowoutControl - 0.20f)
                / 0.80f
            );

        pragmapBlowoutStrength =
            lerp(
                0.20f,
                4.0f,
                blowoutHighRange
            );
    }

    float pragmapShoulder =
        clamp(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_SHOULDER
            ),
            0.01f,
            0.99f
        );

    // Keep PragmapV2.hlsl completely unmodified in this variant.
    //
    // Because the original Pragmap implementation hardcodes its internal
    // shoulder values, these two controls are applied as an OPTIONAL extra
    // post-Pragmap overshoot stage. At the original defaults:
    //
    //     shoulder = 0.80
    //     compression = 0.75
    //
    // this extra stage is bypassed so the exact original Pragmap output is
    // preserved.
    float pragmapShoulderCompression =
        max(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_SHOULDER_COMPRESSION
            ),
            0.01f
        );

    float3 mappedColor =
        pragmap(
            linearColor,
            displayPeak,
            pragmapHueStrength,
            pragmapBlowoutStrength
        );

    mappedColor =
        SafePositive(
            max(mappedColor, 0.0f)
        );

    const float pragmapDefaultShoulder = 0.80f;
    const float pragmapDefaultShoulderCompression = 0.75f;

    float shoulderDelta =
        GhostsFiniteSigned1(
            pragmapShoulder - pragmapDefaultShoulder
        );

    float shoulderCompressionDelta =
        GhostsFiniteSigned1(
            pragmapShoulderCompression
            - pragmapDefaultShoulderCompression
        );

    bool useExtraShoulderStage =
        shoulderDelta > 0.000001f
        || shoulderDelta < -0.000001f
        || shoulderCompressionDelta > 0.000001f
        || shoulderCompressionDelta < -0.000001f;

    if (useExtraShoulderStage)
    {
        mappedColor =
            overshootCorrection(
                mappedColor,
                displayPeak,
                pragmapShoulder,
                pragmapShoulderCompression
            );

        mappedColor =
            SafePositive(
                max(mappedColor, 0.0f)
            );
    }

    return SafePositive(
        max(mappedColor, 0.0f)
    );
}

// Forward declaration for FXC: the implementation is below the original
// Ghosts rational-tonemapper helpers.
float3 ApplyGhostsLinearPiecewiseExtension(float3 sceneColor);

// ============================================================================
// Selected RenoDX HDR display mapper
// ============================================================================

// ============================================================================
// Strict Ghosts-faithful HDR carrier
// ============================================================================
//
// original rational curve / first-derivative extension
//     -> per-channel Hermite rolloff to HDR peak
//     -> hue-direction correction
float3 ApplyRenoDXTonemap(float3 linearColor)
{
    linearColor =
        SafePositive(
            max(linearColor, 0.0f)
        );

    // Explicit initialization avoids old FXC X4000 data-flow warnings.
    float3 selectedHDR =
        0.0f.xxx;

    [branch]
    if (IsPragmapV2Mode())
    {
        // Pragmap V2 owns display mapping in this mode.
        selectedHDR =
            ApplyPragmapV2Tonemap(
                linearColor
            );
    }
    else
    {
        // -------------------------------------------------------------
        // RenoDRT / Ghosts-faithful HDR path
        // -------------------------------------------------------------
        //
        // Original curve through the mid-gray pivot
        // -> first-derivative linear extension
        // -> per-channel Hermite rolloff
        // -> hue-direction correction.

        float3 extendedScene =
            ApplyGhostsLinearPiecewiseExtension(
                linearColor
            );

        extendedScene =
            SafePositive(
                max(extendedScene, 0.0f)
            );

        float displayPeak =
            max(
                RENODX_PEAK_WHITE_NITS
                / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
                1.000001f
            );

        float whiteClip =
            max(
                RENODX_COMMON_WHITE_CLIP,
                displayPeak + 0.000001f
            );

        float3 rolloffInput =
            renodx::color::bt709::clamp::AP1(
                extendedScene
            );

        float3 hdrRolloff =
            renodx::tonemap::HermiteSplinePerChannelRolloff(
                rolloffInput,
                displayPeak,
                whiteClip
            );

        hdrRolloff =
            CorrectGhostsPerChannelRolloffHue(
                rolloffInput,
                hdrRolloff
            );

        selectedHDR =
            SafePositive(
                max(hdrRolloff, 0.0f)
            );
    }

    return SafePositive(
        max(selectedHDR, 0.0f)
    );
}

// ============================================================================
// Call of Duty: Ghosts original rational tonemapper and 3D LUT
// ============================================================================

float SafeFiniteSigned1(float value)
{
    value =
        (value == value)
        ? value
        : 0.0f;

    return clamp(
        value,
        -65504.0f,
        65504.0f
    );
}

float SafeDivideSigned1(
    float numerator,
    float denominator
)
{
    numerator = SafeFiniteSigned1(numerator);
    denominator = SafeFiniteSigned1(denominator);

    const float epsilon = 0.000001f;

    // Avoid abs() for the same FXC bytecode-validator issue described above.
    if (denominator > -epsilon && denominator < epsilon)
    {
        denominator =
            denominator < 0.0f
            ? -epsilon
            : epsilon;
    }

    return SafeFiniteSigned1(
        numerator / denominator
    );
}

float3 ApplyGhostsOriginalRationalTonemap(float3 sceneColor)
{
    sceneColor = SafePositive(sceneColor);

    float3 sceneSquared =
        sceneColor * sceneColor;

    float3 linearTerm =
        sceneColor * cb2[6].xyz;

    float3 quadraticTerm =
        sceneSquared * cb2[8].xyz;

    float3 denominator =
        quadraticTerm
        + linearTerm
        + cb2[4].xyz;

    float3 numerator =
        cb2[7].xyz * linearTerm
        + quadraticTerm
        + cb2[3].xyz;

    float3 toneMapped = float3(
        SafeDivideSigned1(numerator.r, denominator.r),
        SafeDivideSigned1(numerator.g, denominator.g),
        SafeDivideSigned1(numerator.b, denominator.b)
    );

    toneMapped -= cb2[5].xyz;
    toneMapped *= cb2[9].xyz;

    return float3(
        SafeFiniteSigned1(toneMapped.r),
        SafeFiniteSigned1(toneMapped.g),
        SafeFiniteSigned1(toneMapped.b)
    );
}

// ============================================================================
// First derivative of the original Ghosts rational tonemapper
// ============================================================================
//
// N(x) = cb2[3] + cb2[7]*cb2[6]*x + cb2[8]*x^2
// D(x) = cb2[4] + cb2[6]*x          + cb2[8]*x^2
//
// F(x) = cb2[9] * (N(x) / D(x) - cb2[5])
float3 GetGhostsOriginalTonemapSlope(float inputValue)
{
    float x =
        max(inputValue, 0.0f);

    float xSquared =
        x * x;

    float3 denominatorLinear =
        cb2[6].xyz;

    float3 numeratorLinear =
        cb2[7].xyz * cb2[6].xyz;

    float3 quadratic =
        cb2[8].xyz;

    float3 numerator =
        cb2[3].xyz
        + numeratorLinear * x
        + quadratic * xSquared;

    float3 denominator =
        cb2[4].xyz
        + denominatorLinear * x
        + quadratic * xSquared;

    float3 numeratorDerivative =
        numeratorLinear
        + 2.0f * quadratic * x;

    float3 denominatorDerivative =
        denominatorLinear
        + 2.0f * quadratic * x;

    float3 derivativeNumerator =
        numeratorDerivative * denominator
        - numerator * denominatorDerivative;

    float3 derivativeDenominator =
        denominator * denominator;

    float3 rationalSlope = float3(
        SafeDivideSigned1(
            derivativeNumerator.r,
            derivativeDenominator.r
        ),
        SafeDivideSigned1(
            derivativeNumerator.g,
            derivativeDenominator.g
        ),
        SafeDivideSigned1(
            derivativeNumerator.b,
            derivativeDenominator.b
        )
    );

    return float3(
        SafeFiniteSigned1(rationalSlope.r * cb2[9].r),
        SafeFiniteSigned1(rationalSlope.g * cb2[9].g),
        SafeFiniteSigned1(rationalSlope.b * cb2[9].b)
    );
}


// Preserve the original Ghosts curve through the pivot, then continue with the
// tangent line above it.
float3 ApplyGhostsLinearPiecewiseExtension(float3 sceneColor)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    float pivot =
        max(
            RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT,
            0.000001f
        );

    float3 originalCurve =
        ApplyGhostsOriginalRationalTonemap(
            sceneColor
        );

    float3 outputAtPivot =
        ApplyGhostsOriginalRationalTonemap(
            pivot.xxx
        );

    float3 slopeAtPivot =
        GetGhostsOriginalTonemapSlope(
            pivot
        );

    float3 linearExtension =
        slopeAtPivot * (sceneColor - pivot.xxx)
        + outputAtPivot;

    return SafePositive(
        max(
            float3(
                sceneColor.r <= pivot ? originalCurve.r : linearExtension.r,
                sceneColor.g <= pivot ? originalCurve.g : linearExtension.g,
                sceneColor.b <= pivot ? originalCurve.b : linearExtension.b
            ),
            0.0f
        )
    );
}

float3 SampleGhostsOriginalLUT(float3 toneMappedColor)
{
#if RENODX_GHOSTS_USE_ORIGINAL_LUT

    float3 safeLUTInput =
        saturate(
            SafePositive(
                max(toneMappedColor, 0.0f)
            )
        );

    // Exact 16^3 LUT texel-centre remap from the original shader.
    float3 lutCoordinates =
        safeLUTInput * 0.9375f
        + 0.03125f;

    return SafePositive(
        max(
            t5.Sample(
                s5_s,
                GhostsFiniteSigned3(lutCoordinates)
            ).rgb,
            0.0f
        )
    );

#else

    return SafePositive(toneMappedColor);

#endif
}

float3 ApplyGhostsOriginalGradeWithStrength(
    float3 sceneColor,
    float lutStrength
)
{
    float3 toneMapped =
        ApplyGhostsOriginalRationalTonemap(
            sceneColor
        );

    // Neutral reference: keep the original rational tonemapper, but remove only
    // the authored 3D LUT. Clamp at the same display-referred stage.
    float3 ungradedColor =
        saturate(
            SafePositive(
                max(
                    toneMapped,
                    0.0f.xxx
                )
            )
        );

    lutStrength = saturate(lutStrength);

    [branch]
    if (lutStrength <= 0.000001f)
    {
        return ungradedColor;
    }

    float3 fullyGradedColor =
        saturate(
            SampleGhostsOriginalLUT(
                toneMapped
            )
        );

    [branch]
    if (lutStrength >= 0.999999f)
    {
        return fullyGradedColor;
    }

    return SafePositive(
        lerp(
            ungradedColor,
            fullyGradedColor,
            lutStrength
        )
    );
}

float3 ApplyGhostsOriginalGradeDirect(float3 sceneColor)
{
    // Vanilla mode must remain the exact full authored grade regardless of the
    // HDR-only Scene Grading control state.
    return ApplyGhostsOriginalGradeWithStrength(
        sceneColor,
        1.0f
    );
}

// ============================================================================
// HDR-aware original LUT upgrade
// ============================================================================
//
// colorHDR       = saved HDR result
// colorSDR       = max-channel-compressed HDR copy in 0..1
// colorSDRGraded = LUT(colorSDR)
//
// colorHDR *= luminance(LUT(0.18)) / 0.18
// UpgradeToneMap(colorHDR, colorSDR, colorSDRGraded)
// ============================================================================




// Compress the already per-channel-rolled HDR carrier to the SDR LUT domain
// BY LUMINANCE.
//
// output peak      = 1.0
// exact white clip = configured HDR peak
float3 CompressHDRForGhostsLUT(float3 colorU)
{
    colorU =
        SafePositive(
            max(colorU, 0.0f)
        );

    float hdrPeak =
        max(
            RENODX_PEAK_WHITE_NITS
            / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
            1.000001f
        );

    float3 colorN =
        renodx::tonemap::HermiteSplineLuminanceRolloff(
            colorU,
            1.0f,
            hdrPeak
        );

    return saturate(
        SafePositive(
            max(colorN, 0.0f)
        )
    );
}


float3 ApplyGhostsLUTUpgradeToHDR(float3 hdrColor)
{
    hdrColor =
        SafePositive(
            max(
                hdrColor,
                0.0f.xxx
            )
        );

#if RENODX_GHOSTS_USE_ORIGINAL_LUT

    float lutStrength =
        saturate(
            RENODX_COLOR_GRADE_STRENGTH
        );

    if (lutStrength <= 0.000001f)
    {
        return hdrColor;
    }

    // colorU: per-channel HDR rolloff after hue-direction correction.
    float3 colorU =
        hdrColor;

    // colorN: luminance-compressed SDR representation of the same colorU.
    float3 colorN =
        CompressHDRForGhostsLUT(
            colorU
        );

    // Keep the LUT input away from the 1.0 boundary.
    //
    // Scale rather than clamp:
    //   clamp/min would flatten all values above 0.96 together,
    //   while scaling keeps highlight separation intact.
    colorN *=
        saturate(
            RENODX_GHOSTS_LUT_INPUT_MAX
        );

    // Sample the original Ghosts 3D LUT.
    float3 fullyGraded =
        saturate(
            SampleGhostsOriginalLUT(
                colorN
            )
        );

    float3 colorNGraded =
        lerp(
            colorN,
            fullyGraded,
            lutStrength
        );

    // RenoDX equivalent of the supplied:
    //   RestorePostProcess(colorU, colorN, colorNGraded, ...)
    //
    // UpgradeToneMap uses the matching triplet:
    //   untonemapped, tonemapped, tonemapped_graded.
    // Keep invalid values from entering UpgradeToneMap().
    colorU =
        SafePositive(
            max(colorU, 0.0f)
        );

    colorN =
        saturate(
            SafePositive(
                max(colorN, 0.0f)
            )
        );

    colorNGraded =
        saturate(
            SafePositive(
                max(colorNGraded, 0.0f)
            )
        );

    float3 restoredHDR =
        renodx::tonemap::UpgradeToneMap(
            colorU,
            colorN,
            colorNGraded
        );

    return SafePositive(
        max(
            restoredHDR,
            0.0f.xxx
        )
    );

#else

    return hdrColor;

#endif
}

// ============================================================================

// Match the HDR color appearance to the actual Vanilla SDR result WITHOUT
// changing HDR luminance.
//
// The SDR reference already contains the original rational tonemapper + t5 LUT.
// We borrow its RGB ratios / white balance / saturation, then scale to the
// current HDR BT.709 luminance.
// Soft waveform-safe SDR luminance anchor.
//
// HDR RGB ratios stay unchanged. Only luminance is guided toward the actual SDR
// result, and that guidance releases based on PRE-TONEMAP HDR scene intensity.
// Lift bright diffuse values toward the SDR reference, then release the match
// before the SDR shoulder can flatten true HDR highlights.
// Original SDR shadow/lower-midtone matcher.
//
// This is intentionally darken-only and is applied AFTER the soft waveform
// anchor. It restores the older shadow behavior without pulling HDR highlights
// back onto the SDR shoulder.
float3 ApplyGhostsSDRShadowMatch(
    float3 hdrColor,
    float3 vanillaColor
)
{
    hdrColor = SafePositive(hdrColor);

    vanillaColor =
        saturate(
            SafePositive(vanillaColor)
        );

    float strength =
        saturate(
            RENODX_GHOSTS_SDR_SHADOW_MATCH
        );

    if (strength <= 0.000001f)
    {
        return hdrColor;
    }

    float fullPoint =
        max(
            RENODX_GHOSTS_SDR_SHADOW_MATCH_FULL,
            0.0f
        );

    float endPoint =
        max(
            RENODX_GHOSTS_SDR_SHADOW_MATCH_END,
            fullPoint + 0.000001f
        );

    float vanillaLuminance =
        max(
            renodx::color::y::from::BT709(vanillaColor),
            0.0f
        );

    float hdrLuminance =
        max(
            renodx::color::y::from::BT709(hdrColor),
            0.0f
        );

    float fadePosition =
        saturate(
            (vanillaLuminance - fullPoint)
            / (endPoint - fullPoint)
        );

    float matchMask =
        1.0f - SmoothCubic01(fadePosition);

    matchMask *=
        strength;

    // Darken only. Never lift HDR above its current value.
    float luminanceScale =
        min(
            vanillaLuminance
            / max(
                hdrLuminance,
                0.000001f
            ),
            1.0f
        );

    float3 matchedColor =
        hdrColor * luminanceScale;

    return SafePositive(
        lerp(
            hdrColor,
            matchedColor,
            matchMask
        )
    );
}

// Exact original piecewise linear-to-sRGB encode, retained only for the
// optional encoded Vanilla comparison mode.
float3 GhostsLinearToSRGB(float3 linearColor)
{
    linearColor = saturate(
        SafePositive(linearColor)
    );

    float3 safeForLog = max(
        linearColor,
        0.00000001f.xxx
    );

    float3 highEncoded =
        exp2(
            log2(safeForLog)
            * 0.416666657f
        )
        * 1.05499995f
        - 0.0549999997f;

    float3 lowEncoded =
        linearColor * 12.9200001f;

    return float3(
        linearColor.r <= 0.00313080009f ? lowEncoded.r : highEncoded.r,
        linearColor.g <= 0.00313080009f ? lowEncoded.g : highEncoded.g,
        linearColor.b <= 0.00313080009f ? lowEncoded.b : highEncoded.b
    );
}

float3 ApplyGhostsOriginalOutputRange(float3 linearColor)
{
    float3 encodedColor =
        GhostsLinearToSRGB(
            linearColor
        );

    encodedColor -= cb2[36].xxx;

    return saturate(
        encodedColor * cb2[36].yyy
    );
}

// ============================================================================
// Original pre-tonemap scene sampling
// ============================================================================
//
// This is the human-readable reconstruction of disassembly instructions 0-19.
//
// IMPORTANT:
// The original SDR tonemapper begins after the distorted t0 scene sample.
// RenoDX branches from that unclamped scene signal before the SDR curve/LUT.
// ============================================================================

// Signed fractional part used by the original animated distortion lookup.
//
// Equivalent to the disassembly's:
//   sign test
//   frac(abs(value))
//   conditional sign restore
float GhostsSignedFraction(float value)
{
    float magnitude =
        value >= 0.0f
        ? value
        : -value;

    float fractional =
        frac(magnitude);

    return value >= 0.0f
        ? fractional
        : -fractional;
}


// Reconstruct the animated t4 distortion from the supplied shader.
//
// The original shader derives two animated atlas coordinates plus a separate
// modulation/mask lookup from cb2[33], cb2[22], and the screen UV. The final
// offset is applied to t0 without clamping the UV, preserving sampler behavior.
float2 ComputeOriginalSceneUV(float2 texcoord)
{
    texcoord =
        GhostsFiniteSigned2(
            texcoord
        );

    // Original:
    //   r0.x = cb2[33].y * cb2[22].z;
    //   r0.x = floor(15 * r0.x);
    float animationIndex =
        floor(
            cb2[33].y
            * cb2[22].z
            * 15.0f
        );

    // Original phase used by sin().
    float animationPhase =
        animationIndex
        * 0.0666666701f;

    float sineStrength =
        max(
            sin(animationPhase),
            0.0f
        );

    // Animated atlas offsets.
    float animatedX =
        GhostsSignedFraction(
            animationIndex
            * 5.39166689f
        );

    float animatedY =
        GhostsSignedFraction(
            animationIndex
            * 1.82500005f
        );

    float frameIndex =
        floor(
            animatedX
            * 60.2400017f
        );

    float2 distortionLookupUV =
        texcoord
        * float2(
            0.600000024f,
            0.400000006f
        )
        + float2(
            animatedX * 8.0f,
            animatedY * 8.0f
        );

    // t4.xy stores the signed distortion direction.
    distortionLookupUV =
        GhostsFiniteSigned2(
            distortionLookupUV
        );

    float2 distortionDirection =
        GhostsFiniteSigned2(
            t4.Sample(
                s4_s,
                distortionLookupUV
            ).xy
        );

    distortionDirection =
        distortionDirection
        * 2.0f
        - 1.0f;

    // A second animated lookup in t4.zw controls the effect strength/gating.
    float2 modulationLookupUV =
        texcoord
        * float2(
            0.25f,
            1.0f
        )
        + float2(
            frameIndex
            * 0.0166002642f,
            0.0f
        );

    modulationLookupUV =
        GhostsFiniteSigned2(
            modulationLookupUV
        );

    float2 modulationSample =
        GhostsFiniteSigned2(
            t4.Sample(
                s4_s,
                modulationLookupUV
            ).zw
        );

    // Original:
    //   r0.x = r1.y * max(sin(phase), 0)
    //   r0.w = saturate(cb2[33].x - r1.x)
    //   r0.x *= r0.w
    float gate =
        saturate(
            cb2[33].x
            - modulationSample.x
        );

    float animatedStrength =
        GhostsFiniteSigned1(
            modulationSample.y
            * sineStrength
            * gate
        );

    // Original anisotropic scale:
    //   x = gate * 0.100 + animatedStrength
    //   y = gate * 0.033 + animatedStrength
    float2 distortionScale =
        float2(
            gate * 0.100000001f + animatedStrength,
            gate * 0.0329999998f + animatedStrength
        );

    distortionScale =
        GhostsFiniteSigned2(
            distortionScale
        );

    float2 distortionOffset =
        GhostsFiniteSigned2(
            distortionDirection
            * distortionScale
        );

    // Original final gate:
    //   threshold = 0.5 * distortionScale.x + cb2[33].x
    //   keep offset only when modulationSample.x < threshold
    float threshold =
        distortionScale.x
        * 0.5f
        + cb2[33].x;

    if (modulationSample.x >= threshold)
    {
        distortionOffset =
            0.0f.xx;
    }

    return GhostsFiniteSigned2(
        texcoord
        + distortionOffset
    );
}

// ============================================================================
// Main shader
// ============================================================================

void main(
    float4 position : SV_POSITION,
    float2 texcoord : TEXCOORD0,
    float sceneScale : TEXCOORD2,
    out float4 outputColor : SV_TARGET0
)
{
    // Reconstruct the original animated t4 distortion before sampling the scene.
    float2 sceneUV =
        ComputeOriginalSceneUV(
            texcoord
        );

    // Sample the original scene using the reconstructed distorted UV.
    float4 source =
        t0.Sample(
            s0_s,
            sceneUV
        );

    
    // Remove bad texture data before scene scaling can turn INF * 0 into NaN.
    source.rgb =
        SafePositive(
            max(source.rgb, 0.0f)
        );

    source.a =
        GhostsFiniteSigned1(
            source.a
        );

    sceneScale =
        GhostsFiniteSigned1(
            sceneScale
        );
// This is the actual pre-tonemap scene signal. RenoDX branches here,
    // before the original rational tonemapper and LUT.
    //
    // max(..., 0) removes negative values without clamping positive HDR.
    float3 sceneColor =
        max(
            source.rgb * sceneScale,
            0.0f.xxx
        );

    // Reconstruct the original rational tonemapper + t5 LUT for Vanilla and
    // for the SDR reference used by the Tonemapper-1-style HDR path.
    float3 vanillaLinear =
        ApplyGhostsOriginalGradeDirect(
            sceneColor
        );

    // ---------------------------------------------------------------------
    // Vanilla
    // ---------------------------------------------------------------------
    //
    // Type 0 keeps the original game tonemapper.
    //
    // RENODX_GHOSTS_EXACT_ENCODED_VANILLA = 1 reproduces instructions 33-41
    // directly. The default 0 keeps the reference RenoDX behavior and passes
    // the original linear SDR result through RenderIntermediatePass.
    // ---------------------------------------------------------------------
    if (IsVanillaMode())
    {
#if RENODX_GHOSTS_EXACT_ENCODED_VANILLA

        outputColor.rgb =
            ApplyGhostsOriginalOutputRange(
                vanillaLinear
            );

        // Instruction 19: original alpha comes directly from t0.
        outputColor.a = source.a;
        return;

#else

        float3 intermediateColor =
            renodx::draw::RenderIntermediatePass(
                vanillaLinear
            );

        outputColor.rgb =
            saturate(
                SafePositive(
                    intermediateColor
                )
            );

        outputColor.a = source.a;
        return;

#endif
    }

    // ---------------------------------------------------------------------
    // RenoDX HDR
    // ---------------------------------------------------------------------
    //
    // Use the unclamped scene from instruction 18 rather than the SDR result
    // from instructions 20-41.
    // ---------------------------------------------------------------------

    float3 toneMapInput =
        SafePositive(
            sceneColor
            * max(
                RENODX_GHOSTS_HDR_INPUT_SCALE,
                0.0f
            )
        );

    // Same ordering as the supplied working RenoDX reference:
    //
    //   1. HDR Boost
    //   2. Exposure / Contrast / Flare / Highlights / Shadows
    //   3. RenoDX Common Hermite OR PsychoV24 display mapper
    //   4. Controlled HDR highlight restoration
    //   5. HDR-aware original t5 LUT at Scene Grading strength
    //   6. UpgradeToneMap HDR luminance recovery
    //   7. Match user-adjusted Vanilla SDR color at preserved HDR luminance
    //   8. Soft SDR shadow/midtone luminance match with HDR release
    //   9. Original SDR shadow/lower-midtone matcher
    //  10. Shoulder-aware upper-SDR brightness match
    //  11. Final Saturation / Blowout / Highlight Saturation user controls
    //  12. RenderIntermediatePass
    float3 commonPreTonemapColor =
        ApplyCommonPreTonemapPipeline(
            toneMapInput
        );

    // Match Tonemapper 1: use the same graded SDR reference for the
    // partial absolute color match and the darken-only shadow level.
    float3 sdrShadowReference =
        ApplyGhostsOriginalGradeWithStrength(
            commonPreTonemapColor,
            RENODX_COLOR_GRADE_STRENGTH
        );

    float3 toneMappedColor =
        ApplyRenoDXTonemap(
            commonPreTonemapColor
        );

    // Reconstruct the original LUT from a luminance-compressed SDR copy of
    // the already per-channel-rolled HDR carrier.
    toneMappedColor =
        ApplyGhostsLUTUpgradeToHDR(
            toneMappedColor
        );

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE

    toneMappedColor =
        RestoreHDRHighlights(
            toneMappedColor,
            commonPreTonemapColor
        );

#endif

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH

    toneMappedColor =
        ApplyGhostsPartialAbsoluteSDRColorMatch(
            toneMappedColor,
            sdrShadowReference
        );

#endif

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH

    toneMappedColor =
        ApplyGhostsSDRShadowMatch(
            toneMappedColor,
            sdrShadowReference
        );

#endif

    // Same final RenoDX post-tonemap controls as Tonemapper 1.
    toneMappedColor =
        ApplyCommonPostTonemapPipeline(
            toneMappedColor
        );

    // Broad final negative-value protection without clipping HDR above 1.
    toneMappedColor =
        max(
            toneMappedColor,
            0.0f.xxx
        );

    outputColor.rgb =
        SafePositive(
            renodx::draw::RenderIntermediatePass(
                toneMappedColor
            )
        );

    // Preserve instruction 19's alpha behavior exactly.
    outputColor.a = source.a;
}
