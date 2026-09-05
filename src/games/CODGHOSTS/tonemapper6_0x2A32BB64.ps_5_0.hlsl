#include "./shared.h"

// ============================================================================
// Call of Duty: Ghosts - HDR conversion of the SDR sRGB/color-grade pass
// ============================================================================
//
// Original pass:
//
//   source
//   -> clamp RGB to 0..1
//   -> linear-to-sRGB encode
//   -> encoded-space luminance
//   -> luminance-dependent desaturation
//   -> per-channel quadratic gain
//   -> per-channel offset
//
// HDR path:
//
//   unclamped positive source
//   -> RenoDX pre-tonemap controls
//   -> RenoDRT or Pragmap
//   -> reconstruct original SDR ungraded/graded pair
//   -> UpgradeToneMap()
//   -> RenoDX post-tonemap controls
//   -> RenderIntermediatePass
//
// This shader has no 3D LUT and no Ghosts rational filmic curve.
// Its original SDR mapping before sRGB encoding is just saturate(sceneColor),
// so the correct HDR extension is the unclamped identity signal.
// ============================================================================

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PRAGMAP
#define RENODX_TONE_MAP_TYPE_PRAGMAP 4.0f
#endif

#ifndef RENODX_TONEMAPPER_MID_GRAY
#define RENODX_TONEMAPPER_MID_GRAY 0.18f
#endif

#ifndef RENODX_TONEMAPPER_WHITE_CLIP
#define RENODX_TONEMAPPER_WHITE_CLIP 100.0f
#endif

#ifndef RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
#define RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION 1.0f
#endif


// ============================================================================
// Vanilla color-accuracy match
// ============================================================================
//
// 1.0 = use exact Vanilla graded chromaticity through normal SDR picture levels.
// HDR luminance is preserved exactly by the color-match stage.
#ifndef RENODX_GHOSTS_SRGB_GRADE_COLOR_MATCH
#define RENODX_GHOSTS_SRGB_GRADE_COLOR_MATCH 1.0f
#endif

// Begin releasing exact SDR chromaticity before scene values become true HDR.
#ifndef RENODX_GHOSTS_SRGB_GRADE_COLOR_RELEASE_START
#define RENODX_GHOSTS_SRGB_GRADE_COLOR_RELEASE_START 0.75f
#endif

// By this pre-tonemap scene peak, RenoDRT/Pragmap owns the color completely.
#ifndef RENODX_GHOSTS_SRGB_GRADE_COLOR_RELEASE_END
#define RENODX_GHOSTS_SRGB_GRADE_COLOR_RELEASE_END 1.50f
#endif

#include "./pragmap.hlsl"


Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
    float4 cb2[10];
}


// ============================================================================
// Safety helpers
// ============================================================================

float SafeFinitePositive1(float value)
{
    if (value != value)
        return 0.0f;

    return clamp(value, 0.0f, 65504.0f);
}

float3 SafePositive(float3 color)
{
    // Preferred first/default cleanup for these HDR color paths.
    color = max(color, 0.0f.xxx);

    return float3(
        SafeFinitePositive1(color.r),
        SafeFinitePositive1(color.g),
        SafeFinitePositive1(color.b)
    );
}

float GhostsFiniteSigned1(float value)
{
    if (value != value)
        return 0.0f;

    return clamp(value, -65504.0f, 65504.0f);
}

float3 GhostsFiniteSigned3(float3 value)
{
    return float3(
        GhostsFiniteSigned1(value.r),
        GhostsFiniteSigned1(value.g),
        GhostsFiniteSigned1(value.b)
    );
}

float GhostsSafePositiveParameter1(float value, float fallbackValue)
{
    if (value != value)
        value = fallbackValue;

    return clamp(value, 0.0f, 65504.0f);
}

float GhostsSafePowPositive1(float baseValue, float exponent)
{
    baseValue = SafeFinitePositive1(max(baseValue, 0.0f));
    exponent = GhostsFiniteSigned1(exponent);

    if (baseValue <= 0.0f)
    {
        if (exponent < 0.0f)
            return 0.0f;

        if (exponent == 0.0f)
            return 1.0f;

        return 0.0f;
    }

    return SafeFinitePositive1(
        pow(max(baseValue, 0.00000001f), exponent)
    );
}


// ============================================================================
// Runtime mode selection
// ============================================================================

bool IsVanillaMode()
{
    float modeDelta =
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_VANILLA;

    return modeDelta > -0.5f
        && modeDelta < 0.5f;
}

bool IsPragmapMode()
{
    float modeDelta =
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PRAGMAP;

    return modeDelta > -0.5f
        && modeDelta < 0.5f;
}


// ============================================================================
// sRGB conversion
// ============================================================================
//
// LinearToSRGBSafe matches the original shader's piecewise encode.
// SRGBToLinearSafe is used only to bring the reconstructed original SDR grade
// back to linear for UpgradeToneMap().
// ============================================================================

float3 LinearToSRGBSafe(float3 color)
{
    color = SafePositive(max(color, 0.0f));

    float3 lower = 12.92f * color;

    float3 upper =
        1.055f
        * float3(
            GhostsSafePowPositive1(color.r, 1.0f / 2.4f),
            GhostsSafePowPositive1(color.g, 1.0f / 2.4f),
            GhostsSafePowPositive1(color.b, 1.0f / 2.4f)
        )
        - 0.055f;

    return float3(
        color.r <= 0.0031308f ? lower.r : upper.r,
        color.g <= 0.0031308f ? lower.g : upper.g,
        color.b <= 0.0031308f ? lower.b : upper.b
    );
}

float3 SRGBToLinearSafe(float3 color)
{
    color = SafePositive(max(color, 0.0f));

    float3 lower =
        color / 12.92f;

    float3 normalized =
        max(
            (color + 0.055f)
            / 1.055f,
            0.0f.xxx
        );

    float3 upper =
        float3(
            GhostsSafePowPositive1(normalized.r, 2.4f),
            GhostsSafePowPositive1(normalized.g, 2.4f),
            GhostsSafePowPositive1(normalized.b, 2.4f)
        );

    return SafePositive(
        float3(
            color.r <= 0.04045f ? lower.r : upper.r,
            color.g <= 0.04045f ? lower.g : upper.g,
            color.b <= 0.04045f ? lower.b : upper.b
        )
    );
}


// ============================================================================
// Exact original encoded-space color grade
// ============================================================================
//
// From the original shader:
//
//   Y = dot(encodedRGB, 0.299, 0.587, 0.114)
//
//   desaturation = cb2[6].w + cb2[7].w * Y
//
//   gain.rgb =
//       cb2[6].xyz
//     + cb2[7].xyz * Y
//     + cb2[8].xyz * Y^2
//
//   mixedRGB = encodedRGB + desaturation * (Y - encodedRGB)
//
//   output.rgb = mixedRGB * gain.rgb + cb2[9].xyz
// ============================================================================

float3 ApplyOriginalEncodedColorGrade(float3 encodedColor)
{
    encodedColor =
        GhostsFiniteSigned3(
            encodedColor
        );

    float luminance =
        dot(
            encodedColor,
            float3(
                0.298999995f,
                0.587000012f,
                0.114f
            )
        );

    luminance =
        GhostsFiniteSigned1(
            luminance
        );

    float desaturationAmount =
        cb2[6].w
        + cb2[7].w * luminance;

    float luminanceSquared =
        luminance * luminance;

    float3 gain =
        cb2[6].xyz
        + cb2[7].xyz * luminance
        + cb2[8].xyz * luminanceSquared;

    float3 mixedColor =
        encodedColor
        + desaturationAmount
        * (luminance.xxx - encodedColor);

    float3 gradedColor =
        mixedColor * gain
        + cb2[9].xyz;

    return GhostsFiniteSigned3(
        gradedColor
    );
}


// ============================================================================
// Exact Vanilla path
// ============================================================================

float3 ApplyOriginalVanillaPass(float3 sourceLinear)
{
    // Original SDR input clamp.
    float3 originalSDRLinear =
        saturate(
            SafePositive(
                max(sourceLinear, 0.0f)
            )
        );

    // Original linear -> sRGB encoding.
    float3 encodedColor =
        LinearToSRGBSafe(
            originalSDRLinear
        );

    // Original Ghosts luminance-dependent grade.
    float3 gradedColor =
        ApplyOriginalEncodedColorGrade(
            encodedColor
        );

    // Final SDR output clamp.
    // Prevents the color grade from pushing Vanilla above 1.0.
    return saturate(
        gradedColor
    );
}

// ============================================================================
// RenoDX pre-tonemap controls
// ============================================================================

float3 ApplyPreTonemapControls(float3 sceneColor)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.exposure = RENODX_TONE_MAP_EXPOSURE;
    config.contrast = RENODX_TONE_MAP_CONTRAST;
    config.flare = RENODX_TONE_MAP_FLARE;
    config.shadows = RENODX_TONE_MAP_SHADOWS;
    config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

    float midGray =
        max(
            RENODX_TONEMAPPER_MID_GRAY,
            0.000001f
        );

    float sourceY =
        max(
            renodx::color::y::from::BT709(sceneColor),
            0.0f
        );

    float3 color =
        sceneColor * config.exposure;

    float exposedY =
        max(
            sourceY * config.exposure,
            0.0f
        );

    float normalizedY =
        exposedY / midGray;

    float flareScale =
        renodx::math::DivideSafe(
            normalizedY + config.flare,
            normalizedY,
            1.0f
        );

    float contrastedY =
        GhostsSafePowPositive1(
            max(normalizedY, 0.0f),
            config.contrast * flareScale
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
            saturate(
                contrastedY
                / (1.0f / midGray)
            )
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
            saturate(
                highlightedY / midGray
            )
        );

    float finalY =
        shadowedY * midGray;

    color *=
        exposedY > 0.0f
        ? finalY / exposedY
        : 0.0f;

    return SafePositive(
        max(color, 0.0f)
    );
}


// ============================================================================
// Per-channel rolloff hue correction
// ============================================================================

float3 CorrectPerChannelRolloffHue(
    float3 sourceColor,
    float3 rolledColor)
{
    sourceColor =
        SafePositive(
            max(sourceColor, 0.0f)
        );

    rolledColor =
        SafePositive(
            max(rolledColor, 0.0f)
        );

    float strength =
        saturate(
            RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
        );

    if (strength <= 0.000001f)
        return rolledColor;

    float3 sourceLab =
        renodx::color::oklab::from::BT709(
            sourceColor
        );

    float3 rolledLab =
        renodx::color::oklab::from::BT709(
            rolledColor
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
        return rolledColor;
    }

    float2 sourceHue =
        sourceLab.yz / sourceChroma;

    rolledLab.yz =
        lerp(
            rolledLab.yz,
            sourceHue * rolledChroma,
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


// ============================================================================
// Pragmap wrapper with working Shoulder Compression control
// ============================================================================
//
// pragmap.hlsl itself is not modified.
// 75% slider -> 0.75 -> 1.50 original Pragmap toneCompression.
// ============================================================================

float3 ApplyPragmapWithMainCompression(
    float3 color,
    float peak,
    float hueStrength,
    float blowoutStrength,
    float mainCompression)
{
    color =
        SafePositive(
            max(color, 0.0f)
        );

    peak =
        max(
            GhostsFiniteSigned1(peak),
            0.000001f
        );

    mainCompression =
        max(
            GhostsFiniteSigned1(mainCompression),
            0.01f
        );

    float y1 =
        max(
            renodx::color::y::from::BT709(color),
            0.0f
        );

    float y2 =
        anchoredCInfinityShoulder(
            y1,
            peak,
            toneAnchor,
            mainCompression
        );

    y2 =
        SafeFinitePositive1(
            y2
        );

    float m1 =
        max(
            color.r,
            max(color.g, color.b)
        );

    float m2 =
        anchoredCInfinityShoulder(
            m1,
            peak,
            toneAnchor,
            mainCompression
        );

    m2 =
        SafeFinitePositive1(
            m2
        );

    float mDiff =
        saturate(
            renodx::math::DivideSafe(
                m2,
                m1,
                1.0f
            )
        );

    float hueDriver =
        renodx::math::DivideSafe(
            y2 - toneAnchor,
            peak - toneAnchor,
            0.0f
        );

    float3 jzazbz =
        jzazbzFromBt709(
            color
        );

    jzazbz =
        GhostsFiniteSigned3(
            jzazbz
        );

    jzazbz =
        hueShiftBezoldBrucke(
            jzazbz,
            hueDriver,
            hueStrength
        );

    jzazbz =
        GhostsFiniteSigned3(
            jzazbz
        );

    float3 blownOutColor =
        jzazbz;

    blownOutColor.yz *=
        mDiff;

    jzazbz =
        lerp(
            jzazbz,
            blownOutColor,
            blowoutStrength
        );

    jzazbz =
        GhostsFiniteSigned3(
            jzazbz
        );

    color =
        bt709FromJzAzBz(
            jzazbz
        );

    color =
        SafePositive(
            max(color, 0.0f)
        );

    float reconstructedY =
        max(
            renodx::color::y::from::BT709(color),
            0.000001f
        );

    color *=
        renodx::math::DivideSafe(
            y2,
            reconstructedY,
            1.0f
        );

    color =
        SafePositive(
            max(color, 0.0f)
        );

    color =
        overshootCorrection(
            color,
            peak,
            overshootShoulder,
            0.75f
        );

    return SafePositive(
        max(color, 0.0f)
    );
}

float3 ApplyPragmapTonemap(float3 linearColor)
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
        float upperRange =
            saturate(
                (hueControl - 0.25f)
                / 0.75f
            );

        pragmapHueStrength =
            lerp(
                0.25f,
                4.0f,
                upperRange
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
        float upperRange =
            saturate(
                (blowoutControl - 0.20f)
                / 0.80f
            );

        pragmapBlowoutStrength =
            lerp(
                0.20f,
                4.0f,
                upperRange
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

    float compressionControl =
        clamp(
            GhostsFiniteSigned1(
                RENODX_PRAGMAP_SHOULDER_COMPRESSION
            ),
            0.01f,
            4.0f
        );

    float mainCompression =
        max(
            compressionControl * 2.0f,
            0.02f
        );

    float3 mappedColor =
        ApplyPragmapWithMainCompression(
            linearColor,
            displayPeak,
            pragmapHueStrength,
            pragmapBlowoutStrength,
            mainCompression
        );

    mappedColor =
        SafePositive(
            max(mappedColor, 0.0f)
        );

    // Shoulder remains separate from Shoulder Compression.
    const float originalShoulder =
        0.80f;

    float shoulderDelta =
        pragmapShoulder
        - originalShoulder;

    if (
        shoulderDelta > 0.000001f
        || shoulderDelta < -0.000001f
    )
    {
        mappedColor =
            overshootCorrection(
                mappedColor,
                displayPeak,
                pragmapShoulder,
                0.75f
            );

        mappedColor =
            SafePositive(
                max(mappedColor, 0.0f)
            );
    }

    return mappedColor;
}


// ============================================================================
// HDR display mapper
// ============================================================================
//
// There is no original filmic curve in this pass.
// Original SDR before encoding = saturate(scene).
// HDR extension = unclamped positive scene.
// ============================================================================

float3 ApplySelectedHDRDisplayMap(float3 sceneColor)
{
    float3 extendedScene =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    float3 selectedHDR =
        0.0f.xxx;

    [branch]
    if (IsPragmapMode())
    {
        selectedHDR =
            ApplyPragmapTonemap(
                extendedScene
            );
    }
    else
    {
        float displayPeak =
            max(
                RENODX_PEAK_WHITE_NITS
                / max(
                    RENODX_DIFFUSE_WHITE_NITS,
                    1.0f
                ),
                1.000001f
            );

        float whiteClip =
            max(
                RENODX_TONEMAPPER_WHITE_CLIP,
                displayPeak + 0.000001f
            );

        float3 rolloffInput =
            renodx::color::bt709::clamp::AP1(
                extendedScene
            );

        rolloffInput =
            SafePositive(
                max(rolloffInput, 0.0f)
            );

        float3 rolledColor =
            renodx::tonemap::HermiteSplinePerChannelRolloff(
                rolloffInput,
                displayPeak,
                whiteClip
            );

        rolledColor =
            SafePositive(
                max(rolledColor, 0.0f)
            );

        selectedHDR =
            CorrectPerChannelRolloffHue(
                rolloffInput,
                rolledColor
            );
    }

    return SafePositive(
        max(selectedHDR, 0.0f)
    );
}



// ============================================================================
// Exact Vanilla chromaticity match for HDR
// ============================================================================

float MaxRGB(float3 color)
{
    return max(color.r, max(color.g, color.b));
}

float SmoothCubic01(float value)
{
    value = saturate(value);
    return value * value * (3.0f - 2.0f * value);
}

// Move HDR color toward the exact final Vanilla SDR chromaticity while keeping
// the current HDR BT.709 luminance unchanged.
//
// This is deliberately an ABSOLUTE color match, not another grade multiplier:
// UpgradeToneMap() gets us close, then this corrects the remaining hue / white
// balance / saturation difference without changing waveform height.
//
// The match releases above the SDR picture range so true HDR highlights keep
// the RenoDRT / Pragmap highlight color instead of inheriting clipped SDR white.
float3 MatchExactVanillaColorPreserveHDRLuminance(
    float3 hdrColor,
    float3 vanillaGradedLinear,
    float3 preTonemapColor)
{
    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    vanillaGradedLinear =
        saturate(
            SafePositive(
                max(vanillaGradedLinear, 0.0f)
            )
        );

    preTonemapColor =
        SafePositive(
            max(preTonemapColor, 0.0f)
        );

    const float epsilon = 0.000001f;

    float hdrLuminance =
        max(
            renodx::color::y::from::BT709(hdrColor),
            0.0f
        );

    float vanillaLuminance =
        max(
            renodx::color::y::from::BT709(vanillaGradedLinear),
            0.0f
        );

    if (
        hdrLuminance <= epsilon
        || vanillaLuminance <= epsilon
    )
    {
        return hdrColor;
    }

    // Exact Vanilla RGB ratios/chromaticity at the current HDR luminance.
    float3 vanillaColorAtHDRLuminance =
        vanillaGradedLinear
        * (hdrLuminance / vanillaLuminance);

    vanillaColorAtHDRLuminance =
        SafePositive(
            max(vanillaColorAtHDRLuminance, 0.0f)
        );

    float scenePeak =
        MaxRGB(preTonemapColor);

    float releaseStart =
        max(
            RENODX_GHOSTS_SRGB_GRADE_COLOR_RELEASE_START,
            0.0f
        );

    float releaseEnd =
        max(
            RENODX_GHOSTS_SRGB_GRADE_COLOR_RELEASE_END,
            releaseStart + 0.000001f
        );

    float highlightRelease =
        SmoothCubic01(
            (scenePeak - releaseStart)
            / (releaseEnd - releaseStart)
        );

    float matchStrength =
        saturate(
            RENODX_GHOSTS_SRGB_GRADE_COLOR_MATCH
        )
        * (1.0f - highlightRelease);

    float3 matchedColor =
        lerp(
            hdrColor,
            vanillaColorAtHDRLuminance,
            matchStrength
        );

    // Numerical cleanup while keeping HDR above 1.0 intact.
    matchedColor =
        SafePositive(
            max(matchedColor, 0.0f)
        );

    // Re-normalize luminance after interpolation so this color correction
    // cannot change HDR brightness/peak on its own.
    float matchedLuminance =
        max(
            renodx::color::y::from::BT709(matchedColor),
            epsilon
        );

    matchedColor *=
        hdrLuminance / matchedLuminance;

    return SafePositive(
        max(matchedColor, 0.0f)
    );
}

// ============================================================================
// Transfer original SDR grade onto HDR
// ============================================================================

float3 ApplyOriginalGradeToHDR(
    float3 hdrColor,
    float3 preTonemapColor)
{
    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    preTonemapColor =
        SafePositive(
            max(preTonemapColor, 0.0f)
        );

    float gradeStrength =
        saturate(
            RENODX_COLOR_GRADE_STRENGTH
        );

    if (gradeStrength <= 0.000001f)
        return hdrColor;

    // ------------------------------------------------------------------
    // Reconstruct the EXACT final Vanilla SDR reference.
    // ------------------------------------------------------------------
    //
    // Vanilla now does:
    //
    //   saturate(linear scene)
    //   -> sRGB encode
    //   -> original encoded color grade
    //   -> FINAL saturate
    //
    // The HDR reference must use the same final encoded clamp. The older
    // version kept/restored post-grade values above 1.0; that is no longer
    // correct once Vanilla itself has a final saturate().

    float3 colorN =
        saturate(
            preTonemapColor
        );

    colorN =
        SafePositive(
            max(colorN, 0.0f)
        );

    float3 encodedUngraded =
        LinearToSRGBSafe(
            colorN
        );

    float3 encodedGraded =
        ApplyOriginalEncodedColorGrade(
            encodedUngraded
        );

    // EXACTLY match ApplyOriginalVanillaPass(): clamp after the grade while
    // still in the game's encoded output domain.
    float3 encodedVanillaFinal =
        saturate(
            GhostsFiniteSigned3(
                encodedGraded
            )
        );

    // Decode that exact final Vanilla color to linear for UpgradeToneMap().
    float3 vanillaGradedLinear =
        SRGBToLinearSafe(
            encodedVanillaFinal
        );

    vanillaGradedLinear =
        saturate(
            SafePositive(
                max(vanillaGradedLinear, 0.0f)
            )
        );

    float3 colorNGraded =
        lerp(
            colorN,
            vanillaGradedLinear,
            gradeStrength
        );

    colorNGraded =
        saturate(
            SafePositive(
                max(colorNGraded, 0.0f)
            )
        );

    // First transfer the authored grade through RenoDX's HDR-aware mechanism.
    float3 upgradedHDR =
        renodx::tonemap::UpgradeToneMap(
            hdrColor,
            colorN,
            colorNGraded
        );

    upgradedHDR =
        SafePositive(
            max(upgradedHDR, 0.0f)
        );

    // Then correct any remaining color mismatch toward the exact final Vanilla
    // reference while preserving HDR luminance. This gives much closer Vanilla
    // hue / saturation / white balance without flattening HDR brightness.
    upgradedHDR =
        MatchExactVanillaColorPreserveHDRLuminance(
            upgradedHDR,
            colorNGraded,
            preTonemapColor
        );

    return SafePositive(
        max(upgradedHDR, 0.0f)
    );
}


// ============================================================================
// RenoDX post-tonemap controls
// ============================================================================

float3 ApplyPostTonemapControls(float3 mappedColor)
{
    mappedColor =
        SafePositive(
            max(mappedColor, 0.0f)
        );

    renodx::color::grade::Config config =
        renodx::color::grade::config::Create();

    config.saturation =
        RENODX_TONE_MAP_SATURATION;

    config.dechroma =
        RENODX_TONE_MAP_BLOWOUT;

    config.blowout =
        -(
            RENODX_TONE_MAP_HIGHLIGHT_SATURATION
            - 1.0f
        );

    float luminance =
        max(
            renodx::color::y::from::BT709(mappedColor),
            0.0f
        );

    float3 perceptual =
        renodx::color::oklab::from::BT709(
            mappedColor
        );

    perceptual =
        GhostsFiniteSigned3(
            perceptual
        );

    if (config.dechroma != 0.0f)
    {
        float highlightAmount =
            saturate(
                GhostsSafePowPositive1(
                    max(
                        luminance / 100.0f,
                        0.0f
                    ),
                    1.0f - config.dechroma
                )
            );

        perceptual.yz *=
            1.0f - highlightAmount;
    }

    if (config.blowout != 0.0f)
    {
        float blowoutMagnitude =
            config.blowout < 0.0f
            ? -config.blowout
            : config.blowout;

        float blowoutChange =
            GhostsSafePowPositive1(
                1.0f
                - saturate(
                    luminance / 100.0f
                ),
                100.0f
                * blowoutMagnitude
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

    float3 color =
        renodx::color::bt709::from::OkLab(
            perceptual
        );

    color =
        renodx::color::bt709::clamp::AP1(
            color
        );

    return SafePositive(
        max(color, 0.0f)
    );
}


// ============================================================================
// Main
// ============================================================================

void main(
    float4 position : SV_POSITION0,
    float2 texcoord : TEXCOORD0,
    out float4 outputColor : SV_TARGET0)
{
    float4 source =
        t0.Sample(
            s0_s,
            texcoord
        );

    // Do not saturate HDR input. Only remove negative/bad values.
    source.rgb =
        SafePositive(
            max(source.rgb, 0.0f)
        );

    source.a =
        GhostsFiniteSigned1(
            source.a
        );

    // ---------------------------------------------------------------------
    // Vanilla: preserve the original shader path.
    // ---------------------------------------------------------------------
    if (IsVanillaMode())
    {
        outputColor.rgb =
            ApplyOriginalVanillaPass(
                source.rgb
            );
    
        outputColor.a =
            source.a;

        return;
    }

    // ---------------------------------------------------------------------
    // HDR path.
    // ---------------------------------------------------------------------

    float3 preTonemapColor =
        ApplyPreTonemapControls(
            source.rgb
        );

    preTonemapColor =
        SafePositive(
            max(preTonemapColor, 0.0f)
        );

    float3 hdrColor =
        ApplySelectedHDRDisplayMap(
            preTonemapColor
        );

    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    hdrColor =
        ApplyOriginalGradeToHDR(
            hdrColor,
            preTonemapColor
        );

    hdrColor =
        ApplyPostTonemapControls(
            hdrColor
        );

    // Final broad protection without clamping HDR above 1.0.
    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    outputColor.rgb =
        SafePositive(
            max(
                renodx::draw::RenderIntermediatePass(
                    hdrColor
                ),
                0.0f
            )
        );

    outputColor.a =
        source.a;
}
