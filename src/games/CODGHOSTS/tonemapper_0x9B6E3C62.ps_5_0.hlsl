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


// Call of Duty: Ghosts - RenoDX HDR tonemapper
//
// Active HDR pipeline:
//
//   linear scene
//     -> RenoDX pre-tonemap controls
//     -> original Ghosts curve below the mid-gray pivot
//     -> first-derivative linear extension above the pivot
//     -> per-channel Hermite rolloff to the configured HDR peak
//     -> hue-direction correction
//     -> luminance rolloff to SDR with HDR peak as exact white clip
//     -> original Ghosts 3D LUT
//     -> UpgradeToneMap(colorU, colorN, colorNGraded)
//     -> RenoDX post-tonemap controls
//     -> RenderIntermediatePass
//
// The 0.18 pivot belongs only to the original-tonemapper extension.
// It is NOT sampled from the LUT and is NOT used as a brightness multiplier.
//

// ============================================================================
// Tone-map mode configuration
// ============================================================================

// Tone-map type 0 preserves the original game tonemapper. Type 24 selects
// PsychoV24. Other HDR modes use the base RenoDX/Common Hermite mapper.
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
// Original Call of Duty: Ghosts shader resources
// ============================================================================

Texture2D<float4> t0 : register(t0);
Texture3D<float4> t4 : register(t4);

SamplerState s0_s : register(s0);
SamplerState s4_s : register(s4);

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
// The same strength is used by the SDR reference that supplies HDR color and
// shoulder-protected SDR-range brightness matching.

// Optional multiplier applied to the reconstructed linear scene before the
// RenoDX pre-tonemap controls. Leave at 1.0 unless the game's scene signal is
// systematically too dim or too bright after resource upgrading.
#ifndef RENODX_GHOSTS_HDR_INPUT_SCALE
#define RENODX_GHOSTS_HDR_INPUT_SCALE 1.0f
#endif

// Mid-gray pivot used to extend the ORIGINAL Ghosts tonemapper.
//
// Below this input value:
//     keep the original Ghosts rational curve.
//
// Above this input value:
//     continue with the tangent line at the pivot.
//
// This is a tonemapper pivot only. It is NOT a LUT(0.18) brightness sample.
#ifndef RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT
#define RENODX_GHOSTS_LINEAR_EXTENSION_PIVOT 0.18f
#endif


// ============================================================================
// Per-channel HDR rolloff -> exact-white-clip SDR LUT compression
// ============================================================================
//
// This path intentionally does NOT use:
//   - LUT(0.18)
//   - a middle-gray multiplier
//   - gamma decoding of a LUT brightness sample
//   - neutral-axis LUT luma scaling
//   - Vanilla SDR brightness matching
//
// Workflow:
//   1. Per-channel roll off the linear HDR signal to the configured HDR peak.
//   2. Correct the hue shift introduced by per-channel blowout while preserving
//      the rolled-off chroma magnitude.
//   3. Compress that HDR result to the SDR LUT domain BY LUMINANCE.
//      The configured HDR peak is used as the exact white clip.
//   4. Sample the original Ghosts LUT.
//   5. UpgradeToneMap(colorU, colorN, colorNGraded).
//
// The goal is to retain the original game's luminance dynamics more faithfully,
// especially for strongly colored highlights such as red lights.

// Hue-direction correction after per-channel rolloff.
// 0 = leave the per-channel rolloff hue unchanged.
// 1 = restore the pre-rolloff hue direction while keeping the rolloff's chroma.
#ifndef RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
#define RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION 1.0f
#endif

// Optional legacy stages are disabled by default in this clean test so they
// cannot hide or distort the behavior of the new rolloff/LUT relationship.
#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE 0
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH 0
#endif

#ifndef RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH
#define RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH 0
#endif

// Partial absolute SDR color match.
//
// 0.0 = keep only the HDR/LUT-upgrade color.
// 1.0 = use the exact SDR reference chromaticity while preserving HDR luminance.
//
// A moderate default gives more of the original SDR look without fully replacing
// the HDR color character.
#ifndef RENODX_GHOSTS_SDR_ABSOLUTE_COLOR_MATCH
#define RENODX_GHOSTS_SDR_ABSOLUTE_COLOR_MATCH 0.35f
#endif

// Match the luminance of HDR shadows and lower midtones to the game's original
// SDR tonemapper. RGB is scaled uniformly, preserving the HDR result's hue.
// Bright highlights are untouched.
//
// 0.0 = disabled
// 1.0 = fully match the original SDR luminance in selected dark areas
#ifndef RENODX_GHOSTS_SDR_SHADOW_MATCH
#define RENODX_GHOSTS_SDR_SHADOW_MATCH 1.0f
#endif

// The match has full strength at and below this original-SDR linear luminance.
#ifndef RENODX_GHOSTS_SDR_SHADOW_MATCH_FULL
#define RENODX_GHOSTS_SDR_SHADOW_MATCH_FULL 0.18f
#endif

// The match smoothly fades to zero at this original-SDR linear luminance.
// Values at and above this point retain the normal RenoDX HDR brightness.
#ifndef RENODX_GHOSTS_SDR_SHADOW_MATCH_END
#define RENODX_GHOSTS_SDR_SHADOW_MATCH_END 0.75f
#endif

// ============================================================================
// SDR shadow/midtone luminance match with HDR release
// ============================================================================
//
// Do not substitute the Vanilla SDR pixel into HDR.
//
// Instead:
//   - measure the actual Vanilla SDR luminance,
//   - scale HDR RGB uniformly toward that luminance,
//   - release the correction using PRE-TONEMAP HDR scene intensity.
//
// This keeps HDR hue/chromaticity intact and avoids accumulating most of the
// picture on the SDR shoulder around diffuse white.
//
// Keep the strongest SDR luminance guidance only in the deepest scene range.
// Starting the release this early prevents the SDR shoulder from turning into
// a dense horizontal shelf in HDR.
// Use a long, gradual release into the untouched HDR curve.
// Full configured SDR luminance guidance before scene-referred release. This preserves the game's
// SDR brightness character without forcing many different scene values onto the
// exact same SDR luminance shoulder.
// Safety limits for the luminance ratio only. They do not clamp HDR output.
// ============================================================================
// Shoulder-aware upper-SDR brightness match
// ============================================================================
//
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
// ============================================================================
// SDR-reference shoulder protection
// ============================================================================
//
// The SDR tonemapper + LUT is used as a REFERENCE for HDR color and normal
// picture brightness. It must not become the HDR highlight curve.
//
// As the graded SDR reference approaches white, progressively stop matching its
// luminance. The HDR mapper then owns highlight brightness.
// Neutral bright HDR highlights also release from the SDR/LUT white chromaticity
// so clipped SDR whites cannot turn neutral HDR whites brown/warm.
#ifndef RENODX_GHOSTS_EXACT_ENCODED_VANILLA
#define RENODX_GHOSTS_EXACT_ENCODED_VANILLA 0
#endif


// ============================================================================
// Safety helpers
// ============================================================================

float SafeFinitePositive1(float value)
{
    // NaN fails the value == value comparison.
    if (value != value)
        return 0.0f;

    // Keep the value valid for an FP16 render target without clamping HDR to 1.
    return clamp(value, 0.0f, 65504.0f);
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


// Move HDR chromaticity toward the actual graded SDR reference while preserving
// the current HDR BT.709 luminance exactly.
float3 ApplyGhostsPartialAbsoluteSDRColorMatch(
    float3 hdrColor,
    float3 sdrReference)
{
    hdrColor = SafePositive(max(hdrColor, 0.0f));
    sdrReference = saturate(SafePositive(max(sdrReference, 0.0f)));

    const float epsilon = 0.000001f;

    float hdrLuminance =
        max(renodx::color::y::from::BT709(hdrColor), 0.0f);

    float sdrLuminance =
        max(renodx::color::y::from::BT709(sdrReference), 0.0f);

    if (sdrLuminance <= epsilon)
        return hdrColor;

    // Use the SDR reference's chromaticity, but keep the HDR luminance.
    float3 sdrColorAtHDRLuminance =
        sdrReference * (hdrLuminance / sdrLuminance);

    float strength =
        saturate(RENODX_GHOSTS_SDR_ABSOLUTE_COLOR_MATCH);

    return SafePositive(max(
        lerp(hdrColor, sdrColorAtHDRLuminance, strength),
        0.0f
    ));
}


float MaxRGB(float3 color)
{
    return max(color.r, max(color.g, color.b));
}


float SmoothCubic01(float value)
{
    value = saturate(value);
    return value * value * (3.0f - 2.0f * value);
}

// Correct only the HUE DIRECTION shifted by per-channel rolloff.
//
// The rolled-off OkLab chroma magnitude is retained, so this does not undo the
// desired per-channel highlight blowout/desaturation. It only rotates that
// chroma back toward the hue direction of the pre-rolloff HDR signal.
float3 CorrectGhostsPerChannelRolloffHue(
    float3 sourceColor,
    float3 rolledOffColor)
{
    sourceColor = SafePositive(max(sourceColor, 0.0f));
    rolledOffColor = SafePositive(max(rolledOffColor, 0.0f));

    float strength =
        saturate(RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION);

    if (strength <= 0.000001f)
        return rolledOffColor;

    float3 sourceLab =
        renodx::color::oklab::from::BT709(sourceColor);

    float3 rolledLab =
        renodx::color::oklab::from::BT709(rolledOffColor);

    float sourceChroma = length(sourceLab.yz);
    float rolledChroma = length(rolledLab.yz);

    if (sourceChroma <= 0.000001f || rolledChroma <= 0.000001f)
        return rolledOffColor;

    // Restore only the original hue direction.
    // Keep the rolled-off chroma magnitude so we do not undo highlight blowout.
    float2 sourceHueDirection = sourceLab.yz / sourceChroma;
    float2 correctedChroma = sourceHueDirection * rolledChroma;

    rolledLab.yz =
        lerp(rolledLab.yz, correctedChroma, strength);

    float3 correctedColor =
        renodx::color::bt709::from::OkLab(rolledLab);

    correctedColor =
        renodx::color::bt709::clamp::AP1(correctedColor);

    return SafePositive(max(correctedColor, 0.0f));
}


// Returns how much the original SDR result is still trusted as a LUMINANCE
// reference. Color matching is intentionally handled elsewhere and is unaffected.
// Return the amount of SDR/LUT COLOR matching to keep for this pixel.
//
// A bright SDR shoulder alone is not enough to release color because strongly
// colored highlights may intentionally use the authored LUT hue. We also require
// the incoming HDR result to be close to neutral.
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
    float normalizationPoint)
{
    color = SafePositive(max(color, 0.0f));

    power = clamp(power, 0.0f, 0.50f);

    if (power <= 0.000001f)
        return color;

    normalizationPoint = max(normalizationPoint, 0.000001f);
    float smoothing = max(power * 2.0f, 0.000001f);

    float3 normalizedColor =
        color / normalizationPoint;

    float3 poweredColor =
        normalizationPoint
        * pow(max(normalizedColor, 0.0f), (1.0f + power).xxx);

    float3 blendAmount =
        color / (color / smoothing + 1.0f);

    float3 boostedColor =
        lerp(color, poweredColor, blendAmount);

    // HDR Boost is lift-only.
    return SafePositive(max(color, boostedColor));
}


// ============================================================================
// RenoDX pre/post grading helpers
// ============================================================================

// Compress out-of-gamut color in gamma space before the display mapper, then
// restore it afterward. This keeps saturated HDR highlights from shifting hue
// as aggressively during luminance or per-channel rolloff.


// Applies Exposure, Contrast, Flare, Highlights, and Shadows using luminance.
// RGB is scaled uniformly, avoiding the per-channel hue shifts that occur when
// those controls are applied independently to red, green, and blue.
float3 CommonApplyPreTonemapControlsByLuminance(
    float3 sceneColor,
    float sceneLuminance,
    renodx::color::grade::Config config,
    float midGray)
{
    sceneColor = SafePositive(max(sceneColor, 0.0f));
    midGray = max(midGray, 0.000001f);

    bool controlsAreNeutral =
        config.exposure == 1.0f
        && config.shadows == 1.0f
        && config.highlights == 1.0f
        && config.contrast == 1.0f
        && config.flare == 0.0f;

    if (controlsAreNeutral)
        return sceneColor;

    float3 color = sceneColor * config.exposure;
    float exposedY = max(sceneLuminance * config.exposure, 0.0f);
    float normalizedY = exposedY / midGray;

    float highlightMask = 1.0f / midGray;
    float shadowMask = midGray;

    float flare =
        renodx::math::DivideSafe(
            normalizedY + config.flare,
            normalizedY,
            1.0f
        );

    float contrastExponent = config.contrast * flare;

    float contrastedY =
        GhostsSafePowPositive1(
            normalizedY,
            contrastExponent
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
        GhostsSafePowPositive1(
            highlightedY,
            -(config.shadows - 2.0f)
        );

    shadowedY =
        lerp(
            shadowedY,
            highlightedY,
            saturate(highlightedY / shadowMask)
        );

    float finalY = shadowedY * midGray;

    color *=
        exposedY > 0.0f
        ? finalY / exposedY
        : 0.0f;

    return SafePositive(max(color, 0.0f));
}


// Applies Saturation, Blowout/dechroma, and Highlight Saturation after the
// display mapper in OkLab, matching the common.hlsl ordering.
float3 CommonApplyPostTonemapControls(
    float3 hdrColor,
    float luminance,
    renodx::color::grade::Config config)
{
    float3 color = SafePositive(max(hdrColor, 0.0f));

    bool controlsAreNeutral =
        config.saturation == 1.0f
        && config.dechroma == 0.0f
        && config.blowout == 0.0f;

    if (controlsAreNeutral)
        return color;

    float3 oklab =
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

        oklab.yz *= 1.0f - highlightAmount;
    }

    if (config.blowout != 0.0f)
    {
        float percentMax = saturate(luminance / 100.0f);

        // Avoid abs() because FXC may produce invalid bytecode here.
        float blowoutMagnitude =
            config.blowout < 0.0f
            ? -config.blowout
            : config.blowout;

        float blowoutChange =
            pow(
                1.0f - percentMax,
                100.0f * blowoutMagnitude
            );

        if (config.blowout < 0.0f)
            blowoutChange = 2.0f - blowoutChange;

        oklab.yz *= blowoutChange;
    }

    oklab.yz *= config.saturation;

    color =
        renodx::color::bt709::from::OkLab(oklab);

    color =
        renodx::color::bt709::clamp::AP1(color);

    return SafePositive(max(color, 0.0f));
}


float3 ApplyCommonPreTonemapPipeline(float3 sceneColor)
{
    sceneColor = SafePositive(max(sceneColor, 0.0f));

    sceneColor =
        ApplyCommonHDRBoost(
            sceneColor,
            RENODX_HDR_BOOST,
            RENODX_HDR_BOOST_NORMALIZATION_POINT
        );

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.exposure = RENODX_TONE_MAP_EXPOSURE;
    config.contrast = RENODX_TONE_MAP_CONTRAST;
    config.flare = RENODX_TONE_MAP_FLARE;
    config.shadows = RENODX_TONE_MAP_SHADOWS;
    config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

    float luminance =
        renodx::color::y::from::BT709(sceneColor);

    return CommonApplyPreTonemapControlsByLuminance(
        sceneColor,
        luminance,
        config,
        RENODX_COMMON_MID_GRAY
    );
}


float3 ApplyCommonPostTonemapPipeline(float3 hdrColor)
{
    hdrColor = SafePositive(max(hdrColor, 0.0f));

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.saturation = RENODX_TONE_MAP_SATURATION;
    config.dechroma = RENODX_TONE_MAP_BLOWOUT;

    // 1.0 is neutral. Below 1 removes highlight chroma; above 1 retains more.
    config.blowout =
        -(RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.0f);

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


// Blend selected pre-tonemap HDR energy back into the tonemapped result.
// The restoration mask is based on pre-tonemap peak brightness, and RGB is
// scaled uniformly when limiting to the display peak so highlight hue is kept.
float3 RestoreHDRHighlights(
    float3 hdrColor,
    float3 preTonemapColor)
{
    hdrColor = SafePositive(max(hdrColor, 0.0f));
    preTonemapColor = SafePositive(max(preTonemapColor, 0.0f));

    float preTonemapPeak = MaxRGB(preTonemapColor);

    float restoreRange =
        max(
            RENODX_HDR_HIGHLIGHT_FULL - RENODX_HDR_HIGHLIGHT_START,
            0.000001f
        );

    float restoreMask =
        saturate(
            (preTonemapPeak - RENODX_HDR_HIGHLIGHT_START)
            / restoreRange
        );

    restoreMask =
        SmoothCubic01(restoreMask)
        * saturate(RENODX_HDR_HIGHLIGHT_RESTORE);

    float3 targetColor = preTonemapColor;

#if RENODX_HDR_RESTORE_LIMIT_TO_DISPLAY

    float displayPeak =
        max(
            RENODX_PEAK_WHITE_NITS
            / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
            1.0f
        );

    if (preTonemapPeak > displayPeak)
        targetColor *= displayPeak / max(preTonemapPeak, 0.000001f);

#endif

    return SafePositive(
        max(
            lerp(hdrColor, targetColor, restoreMask),
            0.0f
        )
    );
}

// ============================================================================
// Tone-map mode selection
// ============================================================================

bool IsVanillaMode()
{
    float difference =
        RENODX_TONE_MAP_TYPE - RENODX_TONE_MAP_TYPE_VANILLA;

    return difference > -0.5f && difference < 0.5f;
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


// ============================================================================
// Selected RenoDX HDR display mapper
// ============================================================================


// HDR rolloff carrier used by the LUT-upgrade path.
//
// PsychoV24 mode:
//   Use the real PsychoV24 mapper so its Psycho-specific controls remain live.
//
// Other HDR modes:
//   Use the requested per-channel Hermite rolloff, followed by hue-direction
//   correction that preserves the rolloff's chroma magnitude.
//
// Both branches then feed the same exact-white-clip SDR compression -> LUT ->
// UpgradeToneMap(colorU, colorN, colorNGraded) path.
// Select the HDR rolloff that becomes colorU for the LUT reconstruction.
//
// PsychoV24 mode:
//     PsychoV24 is the rolloff. Do not apply another Hermite curve afterward.
//
// Other HDR modes:
//     Use a per-channel Hermite rolloff, then correct only its hue rotation.
// Defined later beside the original Ghosts rational tonemapper.
float3 ApplyGhostsLinearPiecewiseExtension(float3 sceneColor);

// ============================================================================
// HDR carrier
// ============================================================================
//
// Requested order:
//
//     original Ghosts curve / tangent extension
//         -> per-channel Hermite rolloff to HDR peak
//         -> hue-direction correction
//
// The tangent extension preserves the original Ghosts mid-gray value and local
// slope. The per-channel rolloff then handles the actual HDR display mapping.
float3 ApplySelectedHDRRolloff(float3 sceneColor)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    // =====================================================================
    // Shared SDR-anchored HDR carrier
    // =====================================================================
    //
    // BOTH RenoDRT and Pragmap now start from the same Ghosts-faithful
    // piecewise signal:
    //
    //     below pivot:
    //         exact original Ghosts rational SDR curve
    //
    //     above pivot:
    //         slopeAtPivot * (scene - pivot) + outputAtPivot
    //
    // This keeps the original SDR middle-gray / average-brightness
    // relationship before either HDR display mapper changes the highlights.

    float3 extendedScene =
        ApplyGhostsLinearPiecewiseExtension(
            sceneColor
        );

    extendedScene =
        SafePositive(
            max(extendedScene, 0.0f)
        );

    // Explicit initialization keeps old FXC data-flow analysis happy.
    float3 selectedHDR =
        0.0f.xxx;

    [branch]
    if (IsPragmapV2Mode())
    {
        // -------------------------------------------------------------
        // Pragmap V2
        // -------------------------------------------------------------
        //
        // Important:
        // Pragmap no longer sees the raw scene signal.
        //
        // It receives the SAME SDR-anchored tangent extension as RenoDRT.
        // This preserves the game's original lower-range brightness character
        // while letting Pragmap handle the upper HDR shoulder / hue behavior.

        selectedHDR =
            ApplyPragmapV2Tonemap(
                extendedScene
            );
    }
    else
    {
        // -------------------------------------------------------------
        // RenoDRT / Ghosts per-channel HDR mapper
        // -------------------------------------------------------------

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
    if (value != value)
        return 0.0f;

    return clamp(value, -65504.0f, 65504.0f);
}


float SafeDivideSigned1(float numerator, float denominator)
{
    numerator = SafeFiniteSigned1(numerator);
    denominator = SafeFiniteSigned1(denominator);

    const float epsilon = 0.000001f;

    if (denominator > -epsilon && denominator < epsilon)
        denominator = denominator < 0.0f ? -epsilon : epsilon;

    return SafeFiniteSigned1(numerator / denominator);
}


float3 ApplyGhostsOriginalRationalTonemap(float3 sceneColor)
{
    sceneColor = SafePositive(max(sceneColor, 0.0f));

    float3 sceneSquared = sceneColor * sceneColor;
    float3 linearTerm = sceneColor * cb2[6].xyz;
    float3 quadraticTerm = sceneSquared * cb2[8].xyz;

    float3 denominator =
        quadraticTerm + linearTerm + cb2[4].xyz;

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
// For each RGB channel:
//
//     N(x) = cb2[3] + cb2[7] * cb2[6] * x + cb2[8] * x^2
//     D(x) = cb2[4] + cb2[6] * x + cb2[8] * x^2
//
//     F(x) = cb2[9] * (N(x) / D(x) - cb2[5])
//
// Therefore:
//
//     F'(x) = cb2[9] * (N'(x)D(x) - N(x)D'(x)) / D(x)^2
//
// cb2[5] is a constant output offset, so it correctly disappears from F'(x).
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

    // cb2[9] is the final linear scale applied before the LUT.
    return float3(
        SafeFiniteSigned1(rationalSlope.r * cb2[9].r),
        SafeFiniteSigned1(rationalSlope.g * cb2[9].g),
        SafeFiniteSigned1(rationalSlope.b * cb2[9].b)
    );
}


// ============================================================================
// Original Ghosts curve + first-derivative linear extension
// ============================================================================
//
// Equivalent idea:
//
//     lower = originalSDR;
//     upper = slopeAtPivot * (scene - pivot) + outputAtPivot;
//
//     result = scene < pivot ? lower : upper;
//
// The join is continuous in both value and first derivative:
//
//     extension(pivot)  = originalCurve(pivot)
//     extension'(pivot) = originalCurve'(pivot)
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

    float3 extendedColor = float3(
        sceneColor.r <= pivot
            ? originalCurve.r
            : linearExtension.r,

        sceneColor.g <= pivot
            ? originalCurve.g
            : linearExtension.g,

        sceneColor.b <= pivot
            ? originalCurve.b
            : linearExtension.b
    );

    // Do NOT clamp this to SDR or the display peak here.
    // The following per-channel Hermite rolloff owns the HDR peak mapping.
    return SafePositive(
        max(extendedColor, 0.0f)
    );
}


float3 SampleGhostsOriginalLUT(float3 lutInput)
{
#if RENODX_GHOSTS_USE_ORIGINAL_LUT

    // Keep invalid HDR/SDR values out of texture coordinates.
    // LUT coordinates are display-referred, so 0..1 is the meaningful domain.
    float3 safeLUTInput =
        saturate(
            SafePositive(
                max(lutInput, 0.0f)
            )
        );

    // Ghosts uses a 16x16x16 LUT. This remaps 0..1 to texel centers.
    float3 lutCoordinates =
        safeLUTInput * 0.9375f + 0.03125f;

    return SafePositive(
        max(
            SafePositive(
                max(
                    t4.Sample(
                        s4_s,
                        GhostsFiniteSigned3(lutCoordinates)
                    ).rgb,
                    0.0f
                )
            ),
            0.0f
        )
    );

#else

    return SafePositive(max(lutInput, 0.0f));

#endif
}


float3 ApplyGhostsOriginalGradeWithStrength(
    float3 sceneColor,
    float lutStrength)
{
    float3 preLUTColor =
        ApplyGhostsOriginalRationalTonemap(sceneColor);

    float3 ungradedColor =
        saturate(
            SafePositive(max(preLUTColor, 0.0f))
        );

    lutStrength = saturate(lutStrength);

    if (lutStrength <= 0.000001f)
        return ungradedColor;

    float3 fullyGradedColor =
        saturate(
            SampleGhostsOriginalLUT(preLUTColor)
        );

    if (lutStrength >= 0.999999f)
        return fullyGradedColor;

    return SafePositive(
        max(
            lerp(ungradedColor, fullyGradedColor, lutStrength),
            0.0f
        )
    );
}


float3 ApplyGhostsOriginalGradeDirect(float3 sceneColor)
{
    // Vanilla mode always uses the complete authored LUT.
    return ApplyGhostsOriginalGradeWithStrength(sceneColor, 1.0f);
}

// ============================================================================
// HDR LUT reconstruction
// ============================================================================
//
// New workflow:
//   1. Per-channel rolloff to HDR peak -> colorU.
//   2. Hue-correct the added per-channel blowout without restoring chroma.
//   3. Luminance rolloff colorU to SDR white with HDR peak as exact white clip -> colorN.
//   4. Sample original LUT -> colorNGraded.
//   5. UpgradeToneMap(colorU, colorN, colorNGraded).
//


// Compress the already per-channel-rolled HDR carrier into the SDR LUT domain.
//
// This is a LUMINANCE rolloff:
//     HDR peak -> SDR 1.0
//
// The configured HDR peak is used as the exact white clip. Because this step
// scales RGB uniformly, it preserves the hue/chroma relationships of the
// hue-corrected per-channel HDR rolloff.
// Convert the HDR rolloff (colorU) into the SDR-domain LUT input (colorN).
//
// The rolloff is luminance-based, so RGB ratios are preserved.
// The configured HDR peak is the exact input white clip that maps to SDR 1.0.
float3 CompressHDRRolloffToSDRLUT(float3 hdrRolloff)
{
    hdrRolloff = SafePositive(max(hdrRolloff, 0.0f));

    float hdrPeak =
        max(
            RENODX_PEAK_WHITE_NITS
            / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
            1.000001f
        );

    float3 sdrLUTInput =
        renodx::tonemap::HermiteSplineLuminanceRolloff(
            hdrRolloff,
            1.0f,
            hdrPeak
        );

    return saturate(
        SafePositive(max(sdrLUTInput, 0.0f))
    );
}


// Restore the original Ghosts LUT onto the per-channel rolled-off HDR carrier.
//
// No fixed pivot is sampled. No 0.18 calibration is used.
// The entire reconstruction is local/per-pixel.
// Apply the original Ghosts LUT to HDR without a fixed 0.18/mid-gray pivot.
//
// colorU       = selected HDR rolloff
// colorN       = luminance-compressed SDR representation of colorU
// colorNGraded = original LUT applied to colorN
//
// UpgradeToneMap transfers the local LUT change back onto colorU.
float3 ApplyGhostsLUTToHDR(float3 hdrRolloff)
{
    hdrRolloff = SafePositive(max(hdrRolloff, 0.0f));

#if RENODX_GHOSTS_USE_ORIGINAL_LUT

    float lutStrength =
        saturate(RENODX_COLOR_GRADE_STRENGTH);

    if (lutStrength <= 0.000001f)
        return hdrRolloff;

    float3 colorU = hdrRolloff;

    float3 colorN =
        CompressHDRRolloffToSDRLUT(colorU);

    // Keep the LUT input away from the 1.0 boundary.
    //
    // Scale rather than clamp:
    //   clamp/min would flatten all values above 0.96 together,
    //   while scaling keeps highlight separation intact.
    colorN *=
        saturate(
            RENODX_GHOSTS_LUT_INPUT_MAX
        );

    float3 fullyGradedColor =
        saturate(
            SampleGhostsOriginalLUT(colorN)
        );

    float3 colorNGraded =
        lerp(colorN, fullyGradedColor, lutStrength);

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

    return SafePositive(max(restoredHDR, 0.0f));

#else

    return hdrRolloff;

#endif
}


// ============================================================================

// Match only the luminance of dark HDR output to the original SDR result.
//
// This is intentionally applied after the HDR mapper, original LUT, and RenoDX
// post-tonemap controls. It therefore corrects the final dark-area brightness
// before the SDR shoulder can flatten true HDR highlights.
// Darken-only lower-range SDR match. This keeps the original shadow shape
// without reintroducing the clipped SDR highlight shoulder.
float3 ApplyGhostsSDRShadowMatch(
    float3 hdrColor,
    float3 vanillaColor)
{
    hdrColor = SafePositive(max(hdrColor, 0.0f));
    vanillaColor = saturate(SafePositive(max(vanillaColor, 0.0f)));

    float strength =
        saturate(RENODX_GHOSTS_SDR_SHADOW_MATCH);

    if (strength <= 0.000001f)
        return hdrColor;

    float fullPoint =
        max(RENODX_GHOSTS_SDR_SHADOW_MATCH_FULL, 0.0f);

    float endPoint =
        max(
            RENODX_GHOSTS_SDR_SHADOW_MATCH_END,
            fullPoint + 0.000001f
        );

    float vanillaY =
        max(renodx::color::y::from::BT709(vanillaColor), 0.0f);

    float hdrY =
        max(renodx::color::y::from::BT709(hdrColor), 0.0f);

    float fade =
        saturate(
            (vanillaY - fullPoint)
            / (endPoint - fullPoint)
        );

    float matchStrength =
        (1.0f - SmoothCubic01(fade)) * strength;

    // Darken only.
    float luminanceScale =
        min(
            vanillaY / max(hdrY, 0.000001f),
            1.0f
        );

    float3 matchedColor =
        hdrColor * luminanceScale;

    return SafePositive(
        max(
            lerp(hdrColor, matchedColor, matchStrength),
            0.0f
        )
    );
}


// Match the HDR color appearance to the actual Vanilla SDR result WITHOUT
// changing HDR luminance.
//
// The Vanilla reference already contains the game's original rational tonemapper
// and authored 3D LUT. We reuse its RGB ratios/chromaticity, then scale that
// color to the current HDR BT.709 luminance.
//
// Result:
//   - SDR hue / white balance / saturation
//   - HDR brightness is unchanged
//   - no extra blue HDR tonemapper tint
//   - no effect on the waveform height by itself
// Transfer only the COLOR CHANGE introduced by the SDR LUT.
//
// Copying the fully graded SDR chromaticity also copies any warm/cool bias from
// the SDR tonemapper itself. Instead, compare SDR before and after the LUT and
// transfer only that LUT-authored change to HDR.
// Match HDR luminance to the actual Vanilla SDR result through shadows and
// midtones while preserving the HDR RGB ratios and hue.
//
// The release is driven by PRE-TONEMAP HDR scene intensity, not by the already
// compressed SDR output. This lets the waveform rise naturally into HDR before
// the original SDR shoulder bunches values near diffuse white.
// Exact original piecewise linear-to-sRGB encode, retained only for the
// optional encoded Vanilla comparison mode.
float3 GhostsLinearToSRGB(float3 linearColor)
{
    linearColor =
        saturate(SafePositive(max(linearColor, 0.0f)));

    float3 safeColor =
        max(linearColor, 0.00000001f);

    float3 high =
        exp2(log2(safeColor) * 0.416666657f)
        * 1.05499995f
        - 0.0549999997f;

    float3 low =
        linearColor * 12.9200001f;

    return float3(
        linearColor.r <= 0.00313080009f ? low.r : high.r,
        linearColor.g <= 0.00313080009f ? low.g : high.g,
        linearColor.b <= 0.00313080009f ? low.b : high.b
    );
}


float3 ApplyGhostsOriginalOutputRange(float3 linearColor)
{
    float3 encodedColor =
        GhostsLinearToSRGB(linearColor);

    encodedColor -= cb2[36].xxx;

    return saturate(
        encodedColor * cb2[36].yyy
    );
}


// ============================================================================
// Main shader
// ============================================================================

void main(
    float4 position : SV_POSITION,
    float2 texcoord : TEXCOORD0,
    float sceneScale : TEXCOORD2,
    out float4 outputColor : SV_TARGET0)
{
    float4 source = t0.Sample(s0_s, texcoord);

    
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
// ---------------------------------------------------------------------
    // 1. Reconstruct the unclamped linear scene
    // ---------------------------------------------------------------------

    float3 sceneColor =
        SafePositive(
            max(
                source.rgb * sceneScale,
                0.0f
            )
        );

    // ---------------------------------------------------------------------
    // 2. Exact Vanilla path
    // ---------------------------------------------------------------------

    if (IsVanillaMode())
    {
        float3 vanillaColor =
            ApplyGhostsOriginalGradeDirect(sceneColor);

#if RENODX_GHOSTS_EXACT_ENCODED_VANILLA

        outputColor.rgb =
            ApplyGhostsOriginalOutputRange(vanillaColor);

#else

        outputColor.rgb =
            saturate(
                SafePositive(
                    renodx::draw::RenderIntermediatePass(vanillaColor)
                )
            );

#endif

        outputColor.a = source.a;
        return;
    }

    // ---------------------------------------------------------------------
    // 3. RenoDX pre-tonemap controls
    // ---------------------------------------------------------------------

    float3 hdrInput =
        SafePositive(
            max(
                sceneColor * max(RENODX_GHOSTS_HDR_INPUT_SCALE, 0.0f),
                0.0f
            )
        );

    float3 preTonemapColor =
        ApplyCommonPreTonemapPipeline(hdrInput);

    // Used only by the optional legacy SDR color/shadow matching stages.
    float3 vanillaReference =
        ApplyGhostsOriginalGradeWithStrength(
            preTonemapColor,
            RENODX_COLOR_GRADE_STRENGTH
        );

    // ---------------------------------------------------------------------
    // 4. HDR rolloff
    // ---------------------------------------------------------------------
    //
    // Build colorU:
    //
    //     original Ghosts curve below the pivot
    //     -> first-derivative linear extension above it
    //     -> per-channel HDR rolloff
    //     -> hue-direction correction
    //
    // This becomes the HDR carrier used by UpgradeToneMap().

    float3 hdrColor =
        ApplySelectedHDRRolloff(preTonemapColor);

    // ---------------------------------------------------------------------
    // 5. Original Ghosts LUT, reconstructed into HDR
    // ---------------------------------------------------------------------
    //
    // colorU       = hdrColor
    // colorN       = luminance rolloff of colorU to SDR
    // colorNGraded = LUT(colorN)
    //
    // No LUT(0.18), no fixed mid-gray multiplier.

    hdrColor =
        ApplyGhostsLUTToHDR(hdrColor);

    // ---------------------------------------------------------------------
    // 6. Optional legacy corrections
    // ---------------------------------------------------------------------

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_HIGHLIGHT_RESTORE

    hdrColor =
        RestoreHDRHighlights(
            hdrColor,
            preTonemapColor
        );

#endif

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_COLOR_MATCH

    hdrColor =
        ApplyGhostsPartialAbsoluteSDRColorMatch(
            hdrColor,
            vanillaReference
        );

#endif

#if RENODX_GHOSTS_ROLLOFF_TEST_USE_SDR_SHADOW_MATCH

    hdrColor =
        ApplyGhostsSDRShadowMatch(
            hdrColor,
            vanillaReference
        );

#endif

    // ---------------------------------------------------------------------
    // 7. RenoDX post-tonemap controls and output
    // ---------------------------------------------------------------------

    hdrColor =
        ApplyCommonPostTonemapPipeline(hdrColor);

    outputColor.rgb =
        SafePositive(
            renodx::draw::RenderIntermediatePass(hdrColor)
        );

    outputColor.a = source.a;
}

