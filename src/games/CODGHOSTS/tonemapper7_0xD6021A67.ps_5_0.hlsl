#include "./shared.h"

// ============================================================================
// Call of Duty: Ghosts
// Tonemapper-1-style HDR conversion of the adaptive dual-curve + 3D LUT pass
// ============================================================================
//
// Original shader:
//
//   scene
//   -> BT.601-style luminance
//   -> two luminance/desaturation-adjusted RGB branches
//   -> per-channel power curve A
//   -> per-channel power curve B
//   -> adaptive blend driven by t4
//   -> saturate
//   -> 3D LUT t5
//
// HDR conversion follows the same structure used by the main Ghosts
// Tonemapper 1:
//
//   scene
//   -> RenoDX pre-tonemap controls
//   -> ORIGINAL adaptive curve below 0.18
//   -> first-derivative linear extension above 0.18
//   -> RenoDRT-style per-channel HDR rolloff OR Pragmap
//   -> hue-direction correction
//   -> luminance-compress HDR carrier to SDR LUT domain
//   -> 0.96 LUT-input headroom
//   -> original t5 3D LUT
//   -> UpgradeToneMap(colorU, colorN, colorNGraded)
//   -> RenoDX post-tonemap controls
//   -> RenderIntermediatePass
//
// Important:
// - The original adaptive curve is this shader's SDR anchor.
// - It is NOT replaced by the rational curve from 0x9B6E3C62.
// - The first derivative is taken along the current pixel's chromaticity ray,
//   at the 0.18 luminance pivot. No second derivative/root solving.
// - max(color, 0) is applied broadly before risky HDR math.
// ============================================================================


// ============================================================================
// Runtime mode configuration
// ============================================================================

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PRAGMAP
  #ifdef RENODX_TONE_MAP_TYPE_PRAGMAPV2
    #define RENODX_TONE_MAP_TYPE_PRAGMAP RENODX_TONE_MAP_TYPE_PRAGMAPV2
  #else
    #define RENODX_TONE_MAP_TYPE_PRAGMAP 4.0f
  #endif
#endif

#ifndef RENODX_ADAPTIVE_TONEMAP_PIVOT
#define RENODX_ADAPTIVE_TONEMAP_PIVOT 0.18f
#endif

#ifndef RENODX_ADAPTIVE_TONEMAP_DERIVATIVE_EPSILON
#define RENODX_ADAPTIVE_TONEMAP_DERIVATIVE_EPSILON 0.001f
#endif

#ifndef RENODX_COMMON_WHITE_CLIP
#define RENODX_COMMON_WHITE_CLIP 100.0f
#endif

#ifndef RENODX_GHOSTS_LUT_INPUT_MAX
#define RENODX_GHOSTS_LUT_INPUT_MAX 0.96f
#endif

#ifndef RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION
#define RENODX_GHOSTS_PER_CHANNEL_HUE_CORRECTION 1.0f
#endif

#ifndef RENODX_HDR_BOOST
#define RENODX_HDR_BOOST 0.0f
#endif

#ifndef RENODX_HDR_BOOST_NORMALIZATION_POINT
#define RENODX_HDR_BOOST_NORMALIZATION_POINT 0.02f
#endif

#include "./pragmap.hlsl"


// ============================================================================
// Original resources
// ============================================================================

Texture3D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
    float4 cb2[26];
}


// ============================================================================
// Safety helpers
// ============================================================================

static const float GHOSTS_EPSILON  = 0.000001f;
static const float GHOSTS_FP16_MAX = 65504.0f;

float SafeFiniteSigned1(float value)
{
    if (value != value)
        return 0.0f;

    return clamp(
        value,
        -GHOSTS_FP16_MAX,
        GHOSTS_FP16_MAX
    );
}

float SafeFinitePositive1(float value)
{
    if (value != value)
        return 0.0f;

    return min(
        max(value, 0.0f),
        GHOSTS_FP16_MAX
    );
}

float3 SafePositive(float3 color)
{
    // Preferred broad cleanup for upgraded HDR paths.
    color =
        max(
            color,
            0.0f.xxx
        );

    return float3(
        SafeFinitePositive1(color.r),
        SafeFinitePositive1(color.g),
        SafeFinitePositive1(color.b)
    );
}

float3 SafeSigned3(float3 color)
{
    return float3(
        SafeFiniteSigned1(color.r),
        SafeFiniteSigned1(color.g),
        SafeFiniteSigned1(color.b)
    );
}

float SafeDivideSigned1(
    float numerator,
    float denominator,
    float fallbackValue)
{
    numerator =
        SafeFiniteSigned1(
            numerator
        );

    denominator =
        SafeFiniteSigned1(
            denominator
        );

    if (
        denominator > -GHOSTS_EPSILON
        && denominator < GHOSTS_EPSILON
    )
    {
        return fallbackValue;
    }

    return SafeFiniteSigned1(
        numerator / denominator
    );
}

float SafePowPositive1(
    float baseValue,
    float exponentValue)
{
    baseValue =
        SafeFinitePositive1(
            max(baseValue, 0.0f)
        );

    exponentValue =
        SafeFiniteSigned1(
            exponentValue
        );

    if (baseValue <= 0.0f)
    {
        if (exponentValue < 0.0f)
            return 0.0f;

        if (exponentValue == 0.0f)
            return 1.0f;

        return 0.0f;
    }

    return SafeFinitePositive1(
        pow(
            max(baseValue, 0.00000001f),
            exponentValue
        )
    );
}

float3 SafePowPositive3(
    float3 baseValue,
    float3 exponentValue)
{
    baseValue =
        SafePositive(
            max(baseValue, 0.0f)
        );

    return float3(
        SafePowPositive1(baseValue.r, exponentValue.r),
        SafePowPositive1(baseValue.g, exponentValue.g),
        SafePowPositive1(baseValue.b, exponentValue.b)
    );
}

float GetGhostsLuminance(float3 color)
{
    return dot(
        color,
        float3(
            0.298999995f,
            0.587000012f,
            0.114f
        )
    );
}

float GetHDRDisplayPeak()
{
    return max(
        RENODX_PEAK_WHITE_NITS
        / max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f
        ),
        1.000001f
    );
}

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
// RenoDX pre-tonemap controls
// ============================================================================

float3 ApplyHDRBoost(
    float3 color,
    float power,
    float normalizationPoint)
{
    color =
        SafePositive(
            max(color, 0.0f)
        );

    power =
        clamp(
            SafeFiniteSigned1(power),
            0.0f,
            0.50f
        );

    if (power <= 0.000001f)
        return color;

    normalizationPoint =
        max(
            SafeFinitePositive1(
                normalizationPoint
            ),
            0.000001f
        );

    float smoothing =
        max(
            power * 2.0f,
            0.000001f
        );

    float3 normalizedColor =
        color / normalizationPoint;

    float3 poweredColor =
        normalizationPoint
        * float3(
            SafePowPositive1(
                normalizedColor.r,
                1.0f + power
            ),
            SafePowPositive1(
                normalizedColor.g,
                1.0f + power
            ),
            SafePowPositive1(
                normalizedColor.b,
                1.0f + power
            )
        );

    float3 blendAmount =
        color
        / (
            color / smoothing
            + 1.0f.xxx
        );

    float3 boostedColor =
        lerp(
            color,
            poweredColor,
            blendAmount
        );

    return SafePositive(
        max(
            color,
            boostedColor
        )
    );
}

float3 ApplyPreTonemapControls(float3 sceneColor)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    sceneColor =
        ApplyHDRBoost(
            sceneColor,
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

    bool controlsAreNeutral =
        config.exposure == 1.0f
        && config.shadows == 1.0f
        && config.highlights == 1.0f
        && config.contrast == 1.0f
        && config.flare == 0.0f;

    if (controlsAreNeutral)
        return sceneColor;

    const float midGray =
        0.18f;

    float sourceY =
        max(
            renodx::color::y::from::BT709(
                sceneColor
            ),
            0.0f
        );

    float3 color =
        sceneColor
        * config.exposure;

    float exposedY =
        max(
            sourceY
            * config.exposure,
            0.0f
        );

    float normalizedY =
        exposedY / midGray;

    float flareScale =
        renodx::math::DivideSafe(
            normalizedY
            + config.flare,
            normalizedY,
            1.0f
        );

    float contrastedY =
        SafePowPositive1(
            normalizedY,
            config.contrast
            * flareScale
        );

    float highlightedY =
        SafePowPositive1(
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
        SafePowPositive1(
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
// Original adaptive two-curve tonemapper
// ============================================================================
//
// This reconstructs the original shader before the final saturate/LUT.
//
// The original code builds two branches:
//
//   branch A:
//     source -> saturation mix cb2[2].w
//     -> gain cb2[1].xyz
//     -> power cb2[2].xyz
//     -> offset cb2[0].xyz
//
//   branch B:
//     source -> saturation mix cb2[5].w
//     -> gain cb2[4].xyz
//     -> power cb2[5].xyz
//     -> offset cb2[3].xyz
//
// The t4 texture determines the blend between them.
// ============================================================================

float GetAdaptiveBlendWeight(float2 uv)
{
    float adaptationSample =
        t4.SampleLevel(
            s4_s,
            uv,
            0.0f
        ).x;

    adaptationSample =
        SafeFiniteSigned1(
            adaptationSample
        );

    // Original:
    // max(1e-8, abs(sample))
    float absoluteSample =
        adaptationSample < 0.0f
        ? -adaptationSample
        : adaptationSample;

    absoluteSample =
        max(
            absoluteSample,
            0.00000001f
        );

    float adaptationDriver =
        cb2[25].x
        / absoluteSample;

    adaptationDriver -=
        cb2[0].w;

    return saturate(
        cb2[3].w
        * adaptationDriver
    );
}

float3 EvaluateOriginalAdaptiveCurveUnclamped(
    float3 sceneColor,
    float adaptationWeight)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    float luminance =
        GetGhostsLuminance(
            sceneColor
        );

    float3 towardGray =
        luminance.xxx
        - sceneColor;

    // Original branch A.
    float3 branchAInput =
        sceneColor
        + cb2[2].w
        * towardGray;

    branchAInput *=
        cb2[1].xyz;

    branchAInput =
        max(
            branchAInput,
            0.0f.xxx
        );

    float3 branchA =
        cb2[0].xyz
        + SafePowPositive3(
            branchAInput,
            cb2[2].xyz
        );

    // Original branch B.
    float3 branchBInput =
        sceneColor
        + cb2[5].w
        * towardGray;

    branchBInput *=
        cb2[4].xyz;

    branchBInput =
        max(
            branchBInput,
            0.0f.xxx
        );

    float3 branchB =
        cb2[3].xyz
        + SafePowPositive3(
            branchBInput,
            cb2[5].xyz
        );

    float3 adaptiveColor =
        lerp(
            branchA,
            branchB,
            adaptationWeight
        );

    return SafePositive(
        max(adaptiveColor, 0.0f)
    );
}

float3 EvaluateOriginalAdaptiveCurveSDR(
    float3 sceneColor,
    float adaptationWeight)
{
    return saturate(
        EvaluateOriginalAdaptiveCurveUnclamped(
            sceneColor,
            adaptationWeight
        )
    );
}


// ============================================================================
// Tonemapper-1-style first-derivative extension
// ============================================================================
//
// Unlike 0x9B6E3C62, this curve is not separable per RGB channel because the
// luminance/saturation mix couples the channels.
//
// To preserve this pass faithfully, the tangent is measured along the current
// pixel's chromaticity ray:
//
//       ray = sceneColor / sceneLuminance
//
// At Y = 0.18:
//
//       pivotColor = ray * 0.18
//
// First derivative:
//
//       dF / dY ~=
//         [ F(ray * (pivot + eps)) - F(ray * (pivot - eps)) ]
//         / (2 * eps)
//
// Above the pivot:
//
//       F_HDR(Y) = F(pivot) + F'(pivot) * (Y - pivot)
//
// This gives value and first-derivative continuity along the pixel's own hue.
// No second derivative/root solving is used.
// ============================================================================

float3 ApplyAdaptiveLinearPiecewiseExtension(
    float3 sceneColor,
    float adaptationWeight)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    float pivot =
        max(
            RENODX_ADAPTIVE_TONEMAP_PIVOT,
            0.00001f
        );

    float sceneY =
        max(
            GetGhostsLuminance(
                sceneColor
            ),
            0.0f
        );

    // Preserve the exact original SDR curve through the pivot.
    if (sceneY <= pivot)
    {
        return EvaluateOriginalAdaptiveCurveSDR(
            sceneColor,
            adaptationWeight
        );
    }

    float safeSceneY =
        max(
            sceneY,
            0.000001f
        );

    float3 chromaticityRay =
        sceneColor
        / safeSceneY;

    chromaticityRay =
        SafePositive(
            max(chromaticityRay, 0.0f)
        );

    float derivativeEpsilon =
        clamp(
            RENODX_ADAPTIVE_TONEMAP_DERIVATIVE_EPSILON,
            0.00001f,
            pivot * 0.25f
        );

    float lowerY =
        max(
            pivot
            - derivativeEpsilon,
            0.000001f
        );

    float upperY =
        pivot
        + derivativeEpsilon;

    float3 pivotColor =
        chromaticityRay
        * pivot;

    float3 lowerColor =
        chromaticityRay
        * lowerY;

    float3 upperColor =
        chromaticityRay
        * upperY;

    float3 outputAtPivot =
        EvaluateOriginalAdaptiveCurveUnclamped(
            pivotColor,
            adaptationWeight
        );

    float3 outputBelowPivot =
        EvaluateOriginalAdaptiveCurveUnclamped(
            lowerColor,
            adaptationWeight
        );

    float3 outputAbovePivot =
        EvaluateOriginalAdaptiveCurveUnclamped(
            upperColor,
            adaptationWeight
        );

    float derivativeDenominator =
        max(
            upperY - lowerY,
            0.000001f
        );

    float3 slopeAtPivot =
        (
            outputAbovePivot
            - outputBelowPivot
        )
        / derivativeDenominator;

    slopeAtPivot =
        SafeSigned3(
            slopeAtPivot
        );

    float3 extendedColor =
        outputAtPivot
        + slopeAtPivot
        * (sceneY - pivot);

    return SafePositive(
        max(extendedColor, 0.0f)
    );
}


// ============================================================================
// Original 3D LUT
// ============================================================================

float3 SampleOriginalLUT(float3 color)
{
    color =
        saturate(
            SafePositive(
                max(color, 0.0f)
            )
        );

    // Exact original 32x32x32 LUT cell-center remap:
    //
    //   color * 31/32 + 1/64
    //
    float3 lutCoordinates =
        color * 0.96875f
        + 0.015625f;

    float3 lutColor =
        t5.Sample(
            s5_s,
            lutCoordinates
        ).xyz;

    return SafePositive(
        max(lutColor, 0.0f)
    );
}

float3 ApplyOriginalVanillaPipeline(
    float3 sceneColor,
    float adaptationWeight)
{
    float3 preLUTColor =
        EvaluateOriginalAdaptiveCurveSDR(
            sceneColor,
            adaptationWeight
        );

    return SampleOriginalLUT(
        preLUTColor
    );
}


// ============================================================================
// Per-channel HDR-rolloff hue correction
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
        length(
            sourceLab.yz
        );

    float rolledChroma =
        length(
            rolledLab.yz
        );

    if (
        sourceChroma <= 0.000001f
        || rolledChroma <= 0.000001f
    )
    {
        return rolledColor;
    }

    float2 sourceHueDirection =
        sourceLab.yz
        / sourceChroma;

    rolledLab.yz =
        lerp(
            rolledLab.yz,
            sourceHueDirection
            * rolledChroma,
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
// Pragmap wrapper
// ============================================================================
//
// Keeps pragmap.hlsl itself untouched.
//
// Existing addon mapping:
//
//     Shoulder Compression 75% -> 0.75
//
// Stock Pragmap:
//
//     toneCompression = 1.50
//
// Therefore:
//
//     mainCompression = slider * 2.0
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
            SafeFinitePositive1(peak),
            0.000001f
        );

    mainCompression =
        max(
            SafeFinitePositive1(
                mainCompression
            ),
            0.01f
        );

    float y1 =
        max(
            renodx::color::y::from::BT709(
                color
            ),
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
            max(
                color.g,
                color.b
            )
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
            SafeDivideSigned1(
                m2,
                m1,
                1.0f
            )
        );

    float hueDriver =
        SafeDivideSigned1(
            y2 - toneAnchor,
            peak - toneAnchor,
            0.0f
        );

    float3 jzazbz =
        jzazbzFromBt709(
            color
        );

    jzazbz =
        SafeSigned3(
            jzazbz
        );

    jzazbz =
        hueShiftBezoldBrucke(
            jzazbz,
            hueDriver,
            hueStrength
        );

    jzazbz =
        SafeSigned3(
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
        SafeSigned3(
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
            renodx::color::y::from::BT709(
                color
            ),
            0.000001f
        );

    color *=
        SafeDivideSigned1(
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

    float displayPeak =
        GetHDRDisplayPeak();

    float hueControl =
        saturate(
            SafeFinitePositive1(
                RENODX_PRAGMAP_HUE_STRENGTH
            )
        );

    float pragmapHueStrength =
        hueControl;

    if (hueControl > 0.25f)
    {
        float highRange =
            saturate(
                (hueControl - 0.25f)
                / 0.75f
            );

        pragmapHueStrength =
            lerp(
                0.25f,
                4.0f,
                highRange
            );
    }

    float blowoutControl =
        saturate(
            SafeFinitePositive1(
                RENODX_PRAGMAP_BLOWOUT_STRENGTH
            )
        );

    float pragmapBlowoutStrength =
        blowoutControl;

    if (blowoutControl > 0.20f)
    {
        float highRange =
            saturate(
                (blowoutControl - 0.20f)
                / 0.80f
            );

        pragmapBlowoutStrength =
            lerp(
                0.20f,
                4.0f,
                highRange
            );
    }

    float shoulder =
        clamp(
            SafeFinitePositive1(
                RENODX_PRAGMAP_SHOULDER
            ),
            0.01f,
            0.99f
        );

    float compressionControl =
        clamp(
            SafeFinitePositive1(
                RENODX_PRAGMAP_SHOULDER_COMPRESSION
            ),
            0.01f,
            4.0f
        );

    float mainCompression =
        max(
            compressionControl
            * 2.0f,
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

    // Keep Shoulder independent from main Shoulder Compression.
    const float originalShoulder =
        0.80f;

    float shoulderDelta =
        shoulder
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
                shoulder,
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
// Selected HDR carrier
// ============================================================================
//
// Tonemapper-1 style:
//
//   original curve / first-derivative extension
//   -> RenoDRT-style per-channel HDR rolloff + hue correction
//
// or:
//
//   original curve / first-derivative extension
//   -> Pragmap
// ============================================================================

float3 ApplySelectedHDRRolloff(
    float3 sceneColor,
    float adaptationWeight)
{
    sceneColor =
        SafePositive(
            max(sceneColor, 0.0f)
        );

    float3 extendedScene =
        ApplyAdaptiveLinearPiecewiseExtension(
            sceneColor,
            adaptationWeight
        );

    extendedScene =
        SafePositive(
            max(extendedScene, 0.0f)
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
            GetHDRDisplayPeak();

        float whiteClip =
            max(
                RENODX_COMMON_WHITE_CLIP,
                displayPeak
                + 0.000001f
            );

        float3 rolloffInput =
            renodx::color::bt709::clamp::AP1(
                extendedScene
            );

        rolloffInput =
            SafePositive(
                max(rolloffInput, 0.0f)
            );

        float3 hdrRolloff =
            renodx::tonemap::HermiteSplinePerChannelRolloff(
                rolloffInput,
                displayPeak,
                whiteClip
            );

        hdrRolloff =
            SafePositive(
                max(hdrRolloff, 0.0f)
            );

        selectedHDR =
            CorrectPerChannelRolloffHue(
                rolloffInput,
                hdrRolloff
            );
    }

    return SafePositive(
        max(selectedHDR, 0.0f)
    );
}


// ============================================================================
// Tonemapper-1-style HDR -> SDR LUT compression
// ============================================================================

float3 CompressHDRRolloffToSDRLUT(float3 hdrColor)
{
    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    float hdrPeak =
        GetHDRDisplayPeak();

    float3 sdrLUTInput =
        renodx::tonemap::HermiteSplineLuminanceRolloff(
            hdrColor,
            1.0f,
            hdrPeak
        );

    return saturate(
        SafePositive(
            max(sdrLUTInput, 0.0f)
        )
    );
}


// ============================================================================
// Tonemapper-1-style LUT reconstruction
// ============================================================================

float3 ApplyOriginalLUTToHDR(float3 hdrColor)
{
    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    float lutStrength =
        saturate(
            RENODX_COLOR_GRADE_STRENGTH
        );

    if (lutStrength <= 0.000001f)
        return hdrColor;

    // colorU = HDR carrier.
    float3 colorU =
        hdrColor;

    // colorN = HDR carrier compressed into SDR display/LUT range.
    float3 colorN =
        CompressHDRRolloffToSDRLUT(
            colorU
        );

    // Same 4% LUT-input headroom used by Tonemapper 1.
    //
    // Scale rather than clamp, preserving separation:
    //
    //   0.50 -> 0.48
    //   1.00 -> 0.96
    colorN *=
        saturate(
            RENODX_GHOSTS_LUT_INPUT_MAX
        );

    colorN =
        saturate(
            SafePositive(
                max(colorN, 0.0f)
            )
        );

    float3 fullyGradedColor =
        SampleOriginalLUT(
            colorN
        );

    fullyGradedColor =
        saturate(
            SafePositive(
                max(fullyGradedColor, 0.0f)
            )
        );

    float3 colorNGraded =
        lerp(
            colorN,
            fullyGradedColor,
            lutStrength
        );

    colorNGraded =
        saturate(
            SafePositive(
                max(colorNGraded, 0.0f)
            )
        );

    colorU =
        SafePositive(
            max(colorU, 0.0f)
        );

    float3 restoredHDR =
        renodx::tonemap::UpgradeToneMap(
            colorU,
            colorN,
            colorNGraded
        );

    return SafePositive(
        max(restoredHDR, 0.0f)
    );
}


// ============================================================================
// RenoDX post-tonemap controls
// ============================================================================

float3 ApplyPostTonemapControls(float3 hdrColor)
{
    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
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

    bool controlsAreNeutral =
        config.saturation == 1.0f
        && config.dechroma == 0.0f
        && config.blowout == 0.0f;

    if (controlsAreNeutral)
        return hdrColor;

    float luminance =
        max(
            renodx::color::y::from::BT709(
                hdrColor
            ),
            0.0f
        );

    float3 oklab =
        renodx::color::oklab::from::BT709(
            hdrColor
        );

    oklab =
        SafeSigned3(
            oklab
        );

    if (config.dechroma != 0.0f)
    {
        float highlightAmount =
            saturate(
                SafePowPositive1(
                    max(
                        luminance
                        / 100.0f,
                        0.0f
                    ),
                    1.0f
                    - config.dechroma
                )
            );

        oklab.yz *=
            1.0f
            - highlightAmount;
    }

    if (config.blowout != 0.0f)
    {
        float blowoutMagnitude =
            config.blowout < 0.0f
            ? -config.blowout
            : config.blowout;

        float blowoutChange =
            SafePowPositive1(
                1.0f
                - saturate(
                    luminance
                    / 100.0f
                ),
                100.0f
                * blowoutMagnitude
            );

        if (config.blowout < 0.0f)
        {
            blowoutChange =
                2.0f
                - blowoutChange;
        }

        oklab.yz *=
            blowoutChange;
    }

    oklab.yz *=
        config.saturation;

    float3 color =
        renodx::color::bt709::from::OkLab(
            oklab
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

    source.rgb =
        SafePositive(
            max(source.rgb, 0.0f)
        );

    source.a =
        SafeFiniteSigned1(
            source.a
        );

    // Sample adaptation once and use the same value for Vanilla and HDR.
    float adaptationWeight =
        GetAdaptiveBlendWeight(
            texcoord
        );

    // ---------------------------------------------------------------------
    // 1. Exact original Vanilla pipeline
    // ---------------------------------------------------------------------

    if (IsVanillaMode())
    {
        float3 vanillaColor =
            ApplyOriginalVanillaPipeline(
                source.rgb,
                adaptationWeight
            );

        vanillaColor =
            SafePositive(
                max(vanillaColor, 0.0f)
            );

        outputColor.rgb =
            SafePositive(
                max(
                    renodx::draw::RenderIntermediatePass(
                        vanillaColor
                    ),
                    0.0f
                )
            );

        outputColor.a =
            source.a;

        return;
    }

    // ---------------------------------------------------------------------
    // 2. RenoDX pre-tonemap controls
    // ---------------------------------------------------------------------

    float3 preTonemapColor =
        ApplyPreTonemapControls(
            source.rgb
        );

    preTonemapColor =
        SafePositive(
            max(preTonemapColor, 0.0f)
        );

    // ---------------------------------------------------------------------
    // 3. Original adaptive SDR curve / first-derivative extension
    //    -> selected HDR display mapper
    // ---------------------------------------------------------------------

    float3 hdrColor =
        ApplySelectedHDRRolloff(
            preTonemapColor,
            adaptationWeight
        );

    // ---------------------------------------------------------------------
    // 4. HDR carrier -> SDR LUT domain -> original 3D LUT -> UpgradeToneMap
    // ---------------------------------------------------------------------

    hdrColor =
        ApplyOriginalLUTToHDR(
            hdrColor
        );

    // ---------------------------------------------------------------------
    // 5. RenoDX post-tonemap controls
    // ---------------------------------------------------------------------

    hdrColor =
        ApplyPostTonemapControls(
            hdrColor
        );

    hdrColor =
        SafePositive(
            max(hdrColor, 0.0f)
        );

    // ---------------------------------------------------------------------
    // 6. Output
    // ---------------------------------------------------------------------

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
