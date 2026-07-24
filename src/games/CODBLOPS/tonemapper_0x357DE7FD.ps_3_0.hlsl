#include "./shared.h"


// ============================================================================
// PsychoV22 configuration
// ============================================================================

#ifndef RENODX_USE_PSYCHOV22
#define RENODX_USE_PSYCHOV22 1
#endif

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV22
#define RENODX_TONE_MAP_TYPE_PSYCHOV22 22.0f
#endif

// 0.0 = automatic compression.
#ifndef RENODX_PSYCHOV22_COMPRESSION
#define RENODX_PSYCHOV22_COMPRESSION 0.0f
#endif

#ifndef RENODX_PSYCHOV22_GAMUT_COMPRESSION
#define RENODX_PSYCHOV22_GAMUT_COMPRESSION 1.0f
#endif

// 0 = disabled.
// 1 = enabled.
#ifndef RENODX_PSYCHOV22_GAMUT_MODE
#define RENODX_PSYCHOV22_GAMUT_MODE 1.0f
#endif

#ifndef RENODX_PSYCHOV22_CONE_RESPONSE
#define RENODX_PSYCHOV22_CONE_RESPONSE 1.0f
#endif

#if RENODX_USE_PSYCHOV22
#include "../../shaders/tonemap/psychov/psychov-22.hlsl"
#endif


// ============================================================================
// Gamma decode configuration
// ============================================================================

// 1 = decode both the Vanilla graded result and the HDR-restored result with
//     a power-law gamma 2.0 curve.
// 0 = leave both signals in their existing encoded domain.
#ifndef RENODX_GAMMA_DECODE_INPUT
#define RENODX_GAMMA_DECODE_INPUT 1
#endif


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

// Scene middle gray used by the luminance-based pre-tonemap controls.
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
// Shared white-clip configuration
// ============================================================================

// The same hue-preserving white shoulder is applied before both RenoDRT and
// PsychoV22. It does not affect Vanilla mode.
//
// Values below START pass through unchanged. Values above START are smoothly
// compressed toward LIMIT. Lower values create a stronger white clip.
#ifndef RENODX_WHITE_CLIP_START
#define RENODX_WHITE_CLIP_START 1.0f
#endif

#ifndef RENODX_WHITE_CLIP_LIMIT
#define RENODX_WHITE_CLIP_LIMIT 8.0f
#endif

// PsychoV22 also has its own internal clip point. Lower is stronger.
#ifndef RENODX_PSYCHOV22_CLIP_POINT
#define RENODX_PSYCHOV22_CLIP_POINT 8.0f
#endif


// ============================================================================
// Controlled HDR highlight restoration
// ============================================================================

// Restores part of the pre-tonemap HDR signal after RenoDRT or PsychoV22.
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

sampler2D colorMapSampler : register(s0);

float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);
float4 postFxControl2 : register(c7);
float4 postFxControl3 : register(c8);
float4 postFxControl4 : register(c9);
float4 postFxControl5 : register(c10);
float4 postFxControl6 : register(c11);

float4 postFxControl7 : register(c20);
float4 postFxControl8 : register(c21);
float4 postFxControl9 : register(c22);
float4 postFxControlA : register(c23);


struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};


// ============================================================================
// Constants
// ============================================================================

static const float3 ORIGINAL_LUMINANCE_WEIGHTS =
    float3(
        0.25f,
        0.50f,
        0.25f
    );


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
        pow(
            max(contrastedY, 0.0f),
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

            float blowoutChange =
                pow(
                    1.0f - percentMax,
                    100.0f * abs(config.blowout)
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

    float3 outputColor;

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


// Power-law gamma 2.0 decode.
//
// This is not an sRGB decode. Values above 1.0 remain HDR and are squared:
//
//   0.5 -> 0.25
//   1.0 -> 1.0
//   2.0 -> 4.0
//
// The decode can be applied to both Vanilla and HDR paths.
float3 GammaDecode2(float3 encodedColor)
{
    encodedColor =
        SafePositive(encodedColor);

    return SafePositive(
        encodedColor * encodedColor
    );
}


// Hue-preserving soft white clip shared by RenoDRT and PsychoV22.
//
// The maximum RGB channel is used as the highlight magnitude. All channels
// are then scaled equally, preserving the original highlight hue.
float3 ApplySharedWhiteClip(float3 color)
{
    color =
        SafePositive(color);

    float peak = max(
        color.r,
        max(
            color.g,
            color.b
        )
    );

    float clipStart = max(
        RENODX_WHITE_CLIP_START,
        0.000001f
    );

    float clipLimit = max(
        RENODX_WHITE_CLIP_LIMIT,
        clipStart + 0.000001f
    );

    if (peak <= clipStart)
    {
        return color;
    }

    float excess =
        peak - clipStart;

    float shoulderRange =
        clipLimit - clipStart;

    // Smoothly approaches clipLimit without a hard discontinuity.
    float clippedPeak =
        clipStart
        + excess
        / (1.0f + excess / shoulderRange);

    float scale =
        clippedPeak
        / max(
            peak,
            0.000001f
        );

    return SafePositive(
        color * scale
    );
}


// ============================================================================
// Tone-map mode selection
// ============================================================================

bool IsVanillaMode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_VANILLA
    ) < 0.5f;
}


bool IsPsychoV22Mode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PSYCHOV22
    ) < 0.5f;
}


// ============================================================================
// PsychoV22 tonemapper
// ============================================================================

float3 ApplyPsychoV22Tonemap(float3 linearColor)
{
    linearColor =
        SafePositive(linearColor);

#if RENODX_USE_PSYCHOV22

    float peakValue = max(
        RENODX_PEAK_WHITE_NITS
        / max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f
        ),
        1.0f
    );

    int gamutMode =
        (RENODX_PSYCHOV22_GAMUT_MODE > 0.5f)
        ? 1
        : 0;

    linearColor =
        renodx::tonemap::psychov::psychotm_test22(
            linearColor,

            // Display peak relative to diffuse white.
            peakValue,

            // Standard grading controls are applied by the common pre/post
            // stages. Keep them neutral here to prevent double-processing.
            1.0f,  // exposure
            1.0f,  // highlights
            1.0f,  // shadows
            1.0f,  // contrast
            1.0f,  // saturation

            // PsychoV22 controls.
            1.0f,                            // bleaching_intensity
            RENODX_PSYCHOV22_CLIP_POINT,       // stronger clip_point

            RENODX_TONE_MAP_HUE_CORRECTION,

            1.0f,                            // adaptation_contrast
            0,                               // white_curve_mode

            RENODX_PSYCHOV22_CONE_RESPONSE,

            0.18f.xxx,                       // current adaptation anchor
            0.18f.xxx,                       // desired adaptation anchor

            RENODX_PSYCHOV22_GAMUT_COMPRESSION,
            gamutMode,

            1.0f,                            // adaptive_normalization
            RENODX_PSYCHOV22_COMPRESSION
        );

#endif

    return SafePositive(linearColor);
}


// ============================================================================
// Selected HDR display mapper
// ============================================================================

float3 ApplyRenoDXTonemap(float3 linearColor)
{
    linearColor =
        SafePositive(linearColor);

    if (IsPsychoV22Mode())
    {
        // PsychoV22 retains its own display mapping and gamut model, while the
        // common pre/post grading stages surround it.
        return ApplyPsychoV22Tonemap(
            linearColor
        );
    }

    // RenoDRT mode now uses the common.hlsl Hermite display mapper, including
    // luminance/per-channel selection and gamut compression/decompression.
    return ApplyCommonHDRDisplayMap(
        linearColor
    );
}


// ============================================================================
// Original color grading
// ============================================================================

float3 ApplyOriginalColorGrading(
    float3 sourceColor,
    out float hdrScale
)
{
    sourceColor =
        SafePositive(sourceColor);

    // Determine the HDR intensity carried by the source.
    float sourcePeak = max(
        sourceColor.r,
        max(
            sourceColor.g,
            sourceColor.b
        )
    );

    hdrScale =
        max(
            sourcePeak,
            1.0f
        );

    // Normalize HDR values into the original shader's expected SDR domain.
    //
    // Dividing by the peak is preferable to independently saturating every
    // channel. It preserves the relative color of mixed-color highlights.
    //
    // Example:
    //
    //     HDR input:       4.0, 1.0, 1.0
    //     Normalized input: 1.0, 0.25, 0.25
    //
    // A direct saturate would instead produce 1.0, 1.0, 1.0 and turn the
    // highlight white.
    float3 gradingInput =
        saturate(
            sourceColor / hdrScale
        );

    // Original weighted luminance:
    //
    //   red   * 0.25
    // + green * 0.50
    // + blue  * 0.25
    float luminance = dot(
        gradingInput,
        ORIGINAL_LUMINANCE_WEIGHTS
    );

    float inverseLuminance =
        1.0f - luminance;

    // Preserve the original saturated interpolation controls.
    //
    // These clamp blend weights, not final HDR RGB.
    float blendWeight0 = saturate(
        luminance * postFxControlA.x
        + postFxControlA.y
    );

    float blendWeight1 = saturate(
        luminance * postFxControlA.z
        + postFxControlA.w
    );

    // Inputs for the three original color-grading matrices.
    float3 matrixInput0 = lerp(
        gradingInput,
        inverseLuminance.xxx,
        postFxControl9.x
    );

    float3 matrixInput1 = lerp(
        gradingInput,
        inverseLuminance.xxx,
        postFxControl9.y
    );

    float3 matrixInput2 = lerp(
        gradingInput,
        inverseLuminance.xxx,
        postFxControl9.z
    );

    float4 matrixInput0WithBias =
        float4(
            matrixInput0,
            1.0f
        );

    float4 matrixInput1WithBias =
        float4(
            matrixInput1,
            1.0f
        );

    float4 matrixInput2WithBias =
        float4(
            matrixInput2,
            1.0f
        );

    // ------------------------------------------------------------------------
    // First original grading matrix
    // ------------------------------------------------------------------------

    float3 grade0;

    grade0.r = saturate(
        dot(
            matrixInput0WithBias,
            postFxControl0
        )
    );

    grade0.g = saturate(
        dot(
            matrixInput0WithBias,
            postFxControl1
        )
    );

    grade0.b = saturate(
        dot(
            matrixInput0WithBias,
            postFxControl2
        )
    );

    // ------------------------------------------------------------------------
    // Second original grading matrix
    // ------------------------------------------------------------------------

    float3 grade1;

    grade1.r = saturate(
        dot(
            matrixInput1WithBias,
            postFxControl3
        )
    );

    grade1.g = saturate(
        dot(
            matrixInput1WithBias,
            postFxControl4
        )
    );

    grade1.b = saturate(
        dot(
            matrixInput1WithBias,
            postFxControl5
        )
    );

    float3 combinedGrade = lerp(
        grade0,
        grade1,
        blendWeight0
    );

    // ------------------------------------------------------------------------
    // Third original grading matrix
    // ------------------------------------------------------------------------

    float3 grade2;

    grade2.r = saturate(
        dot(
            matrixInput2WithBias,
            postFxControl6
        )
    );

    grade2.g = saturate(
        dot(
            matrixInput2WithBias,
            postFxControl7
        )
    );

    grade2.b = saturate(
        dot(
            matrixInput2WithBias,
            postFxControl8
        )
    );

    // Original SDR-domain graded result.
    return lerp(
        combinedGrade,
        grade2,
        blendWeight1
    );
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    float4 sourceColor = tex2D(
        colorMapSampler,
        input.texcoord
    );

    float3 sourceRGB =
        SafePositive(
            sourceColor.rgb
        );

    // ------------------------------------------------------------------------
    // Original color grading
    // ------------------------------------------------------------------------

    float hdrScale;

    float3 gradedSDR =
        ApplyOriginalColorGrading(
            sourceRGB,
            hdrScale
        );

    // Restore the HDR intensity after running the original matrices inside
    // their intended SDR domain.
    //
    // Gamma decoding, when enabled, is applied below after this reconstruction.
    float3 gradedHDR =
        SafePositive(
            gradedSDR * hdrScale
        );

    // ------------------------------------------------------------------------
    // Optional gamma 2.0 decode for both Vanilla and HDR paths
    // ------------------------------------------------------------------------

    float3 vanillaColor =
        gradedSDR;

    float3 toneMapInput =
        gradedHDR;

#if RENODX_GAMMA_DECODE_INPUT

    // Decode after the original grading in both paths.
    //
    // Vanilla decodes the original SDR-domain graded result.
    // RenoDRT/PsychoV22 decode the HDR-restored graded result.
    // No matching gamma encode is performed later.
    vanillaColor =
        GammaDecode2(
            vanillaColor
        );

    toneMapInput =
        GammaDecode2(
            toneMapInput
        );

#endif

    // ------------------------------------------------------------------------
    // Tone mapping
    // ------------------------------------------------------------------------

    float3 toneMappedColor;

    if (IsVanillaMode())
    {
        // Vanilla now receives the same gamma 2.0 decode when enabled.
        // The source HDR scale is still deliberately not restored.
        toneMappedColor =
            vanillaColor;
    }
    else
    {
        // common.hlsl ordering:
        //   1. HDR Boost
        //   2. Luminance-based Exposure/Contrast/Flare/Highlights/Shadows
        //   3. Selected display mapper
        //   4. Controlled HDR highlight restoration
        //   5. OkLab Saturation/Blowout/Highlight Saturation
        float3 commonPreTonemapColor =
            ApplyCommonPreTonemapPipeline(
                toneMapInput
            );

        toneMappedColor =
            ApplyRenoDXTonemap(
                commonPreTonemapColor
            );

        toneMappedColor =
            RestoreHDRHighlights(
                toneMappedColor,
                commonPreTonemapColor
            );

        toneMappedColor =
            ApplyCommonPostTonemapPipeline(
                toneMappedColor
            );
    }

    // ------------------------------------------------------------------------
    // RenoDX intermediate output
    // ------------------------------------------------------------------------

    float3 intermediateColor =
        renodx::draw::RenderIntermediatePass(
            toneMappedColor
        );

    intermediateColor =
        SafePositive(
            intermediateColor
        );

    // Guarantee original SDR-range output in Vanilla mode.
    if (IsVanillaMode())
    {
        intermediateColor =
            saturate(
                intermediateColor
            );
    }

    // Optional gamma 2.0 decode may be applied to both Vanilla and HDR.
    // No gamma encoding is performed.
    // No sRGB conversion.
    // No manual BT.709-to-BT.2020 conversion.
    // No HDR clamp in RenoDRT or PsychoV22 modes.
    return float4(
        intermediateColor,
        sourceColor.a
    );
}