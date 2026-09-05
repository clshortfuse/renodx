#include "./shared.h"


// ============================================================================
// PsychoV24 configuration
// ============================================================================

#ifndef RENODX_USE_PSYCHOV24
#define RENODX_USE_PSYCHOV24 1
#endif

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV24
#define RENODX_TONE_MAP_TYPE_PSYCHOV24 24.0f
#endif

// 0.0 = automatic compression.
#ifndef RENODX_PSYCHOV24_COMPRESSION
#define RENODX_PSYCHOV24_COMPRESSION 0.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_COMPRESSION
#define RENODX_PSYCHOV24_GAMUT_COMPRESSION 1.0f
#endif

// 0 = disabled.
// 1 = enabled.
#ifndef RENODX_PSYCHOV24_GAMUT_MODE
#define RENODX_PSYCHOV24_GAMUT_MODE 1.0f
#endif

#ifndef RENODX_PSYCHOV24_CONE_RESPONSE
#define RENODX_PSYCHOV24_CONE_RESPONSE 1.0f
#endif


#ifndef RENODX_PSYCHOV24_HIGHLIGHT_SATURATION
#define RENODX_PSYCHOV24_HIGHLIGHT_SATURATION 1.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_HUE_RESTORE
#define RENODX_PSYCHOV24_GAMUT_HUE_RESTORE 0.0f
#endif
// FXC can emit invalid D3D11 bytecode when an inlined abs() becomes a source
// modifier on an opcode that does not permit that modifier. PsychoV24 still
// uses abs(), so clear the floating-point sign bit explicitly while compiling
// the Psycho include. The macro is undefined immediately afterward so the
// rest of the BO2 shader keeps its original abs() behavior.
float RenoDXPsychoFXCSafeAbs(float value)
{
    uint bits = asuint(value);
    uint sign = bits >> 31u;
    bits ^= sign << 31u;
    return asfloat(bits);
}

float2 RenoDXPsychoFXCSafeAbs(float2 value)
{
    uint2 bits = asuint(value);
    uint2 sign = bits >> 31u;
    bits ^= sign << 31u;
    return asfloat(bits);
}

float3 RenoDXPsychoFXCSafeAbs(float3 value)
{
    uint3 bits = asuint(value);
    uint3 sign = bits >> 31u;
    bits ^= sign << 31u;
    return asfloat(bits);
}

float4 RenoDXPsychoFXCSafeAbs(float4 value)
{
    uint4 bits = asuint(value);
    uint4 sign = bits >> 31u;
    bits ^= sign << 31u;
    return asfloat(bits);
}

int RenoDXPsychoFXCSafeAbs(int value)
{
    int sign = value >> 31;
    return (value ^ sign) - sign;
}

int2 RenoDXPsychoFXCSafeAbs(int2 value)
{
    int2 sign = value >> 31;
    return (value ^ sign) - sign;
}

int3 RenoDXPsychoFXCSafeAbs(int3 value)
{
    int3 sign = value >> 31;
    return (value ^ sign) - sign;
}

int4 RenoDXPsychoFXCSafeAbs(int4 value)
{
    int4 sign = value >> 31;
    return (value ^ sign) - sign;
}

uint RenoDXPsychoFXCSafeAbs(uint value)
{
    return value;
}

uint2 RenoDXPsychoFXCSafeAbs(uint2 value)
{
    return value;
}

uint3 RenoDXPsychoFXCSafeAbs(uint3 value)
{
    return value;
}

uint4 RenoDXPsychoFXCSafeAbs(uint4 value)
{
    return value;
}

#if RENODX_USE_PSYCHOV24
#define abs RenoDXPsychoFXCSafeAbs
#include "../../shaders/tonemap/psychov/psychov-24.hlsl"
#undef abs
#endif


// ============================================================================
// Gamma decode configuration
// ============================================================================

// 1 = decode the original Vanilla result with a power-law gamma 2.0 curve
//     before RenderIntermediatePass.
// 0 = preserve the original BO2 encoded Vanilla output exactly.
//
// RenoDRT and PsychoV24 always receive the reconstructed linear scene signal,
// so no additional gamma decode is applied to the HDR path.
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
// PsychoV24. It does not affect Vanilla mode.
//
// Values below START pass through unchanged. Values above START are smoothly
// compressed toward LIMIT. Lower values create a stronger white clip.
#ifndef RENODX_WHITE_CLIP_START
#define RENODX_WHITE_CLIP_START 1.0f
#endif

#ifndef RENODX_WHITE_CLIP_LIMIT
#define RENODX_WHITE_CLIP_LIMIT 8.0f
#endif

// PsychoV24 also has its own internal clip point. Lower is stronger.
#ifndef RENODX_PSYCHOV24_CLIP_POINT
#define RENODX_PSYCHOV24_CLIP_POINT 8.0f
#endif


// ============================================================================
// Controlled HDR highlight restoration
// ============================================================================

// Restores part of the pre-tonemap HDR signal after RenoDRT or PsychoV24.
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
// Original Black Ops II shader resources
// ============================================================================

SamplerState codeTexture0_s : register(s0);
SamplerState codeTexture1_s : register(s1);
SamplerState codeTexture2_s : register(s2);

// Preserve the original decompiled resource mapping exactly.
Texture2D<float4> codeTexture2 : register(t0);  // bloom / glow contribution
Texture2D<float4> codeTexture0 : register(t1);  // scene color
Texture2D<float4> codeTexture1 : register(t2);  // packed 32x32x32 color LUT


// ============================================================================
// Black Ops II pass configuration
// ============================================================================

#ifndef RENODX_BO2_BLOOM_SCALE
#define RENODX_BO2_BLOOM_SCALE 4.0f
#endif

// Preserve the original packed 32^3 LUT in both Vanilla and HDR modes.
#ifndef RENODX_BO2_USE_ORIGINAL_LUT
#define RENODX_BO2_USE_ORIGINAL_LUT 1
#endif

// Strength of the original BO2 LUT colour correction in HDR modes.
// The original exponential SDR shoulder itself is not carried into HDR.
#ifndef RENODX_BO2_LUT_STRENGTH
#define RENODX_BO2_LUT_STRENGTH 1.0f
#endif

// The original shader applies a power-law gamma 2.0 encode with sqrt() before
// its shoulder and LUT. The framework's RENODX_GAMMA_DECODE_INPUT option
// reverses that encoded-domain output after grading and before HDR mapping.

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


// Hue-preserving soft white clip shared by RenoDRT and PsychoV24.
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


bool IsPsychoV24Mode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PSYCHOV24
    ) < 0.5f;
}


// ============================================================================
// PsychoV24 tonemapper
// ============================================================================

float3 ApplyPsychoV24Tonemap(float3 linearColor)
{
    linearColor =
        SafePositive(linearColor);

#if RENODX_USE_PSYCHOV24

    float peakValue = max(
        RENODX_PEAK_WHITE_NITS
        / max(
            RENODX_DIFFUSE_WHITE_NITS,
            1.0f
        ),
        1.0f
    );

    int gamutMode =
        (RENODX_PSYCHOV24_GAMUT_MODE > 0.5f)
        ? 1
        : 0;

    linearColor =
        renodx::tonemap::psychov::psychotm_test24(
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

            // PsychoV24 controls.
            1.0f,                            // bleaching_intensity
            RENODX_PSYCHOV24_CLIP_POINT,       // stronger clip_point

            RENODX_TONE_MAP_HUE_CORRECTION,

            1.0f,                            // adaptation_contrast
            0,                               // white_curve_mode

            RENODX_PSYCHOV24_CONE_RESPONSE,

            0.18f.xxx,                       // current adaptation anchor
            0.18f.xxx,                       // desired adaptation anchor

            RENODX_PSYCHOV24_GAMUT_COMPRESSION,
            gamutMode,

            1.0f,                            // adaptive_normalization
            RENODX_PSYCHOV24_COMPRESSION,

            // PsychoV24 adds these two tail parameters. Keep highlight
            // saturation neutral here because BO2's common post-tonemap stage
            // already applies RENODX_TONE_MAP_HIGHLIGHT_SATURATION.
            RENODX_PSYCHOV24_HIGHLIGHT_SATURATION, // highlight_saturation
            RENODX_PSYCHOV24_GAMUT_HUE_RESTORE     // gamut_hue_restore
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

    if (IsPsychoV24Mode())
    {
        // PsychoV24 retains its own display mapping and gamut model, while the
        // common pre/post grading stages surround it.
        return ApplyPsychoV24Tonemap(
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
// Black Ops II original shoulder and packed LUT
// ============================================================================

static const float3 BO2_OUTPUT_LUMINANCE_WEIGHTS =
    float3(
        0.298999995f,
        0.587000012f,
        0.114000000f
    );


float3 ApplyBO2OriginalShoulder(float3 encodedColor)
{
    encodedColor = SafePositive(encodedColor);

    // Original BO2 curve:
    //
    //   below 0.75: identity
    //   above 0.75: smooth exponential shoulder approaching 1.0
    float3 shoulder =
        0.75f
        + 0.25f
        * (
            1.0f
            - exp2(
                encodedColor * -5.77078009f
                + 4.32808495f
            )
        );

    return float3(
        encodedColor.r > 0.75f ? shoulder.r : encodedColor.r,
        encodedColor.g > 0.75f ? shoulder.g : encodedColor.g,
        encodedColor.b > 0.75f ? shoulder.b : encodedColor.b
    );
}


float3 SampleBO2PackedLUT(float3 lutInput)
{
#if RENODX_BO2_USE_ORIGINAL_LUT

    lutInput = saturate(lutInput);

    // The game stores a 32x32x32 LUT as 32 horizontal 32x32 slices in a
    // 1024x32 texture. Red moves within a slice, green moves vertically,
    // and blue selects/interpolates between adjacent slices.
    float bluePosition = lutInput.b * 31.0f;
    float blueSlice0 = floor(bluePosition);
    float blueSlice1 = min(blueSlice0 + 1.0f, 31.0f);
    float blueFraction = frac(bluePosition);

    float redTexel = lutInput.r * 31.0f + 0.5f;
    float greenUV = lutInput.g * 0.96875f + 0.015625f;

    float2 uv0 = float2(
        (blueSlice0 * 32.0f + redTexel) / 1024.0f,
        greenUV
    );

    float2 uv1 = float2(
        (blueSlice1 * 32.0f + redTexel) / 1024.0f,
        greenUV
    );

    float3 grade0 = codeTexture1.Sample(codeTexture1_s, uv0).rgb;
    float3 grade1 = codeTexture1.Sample(codeTexture1_s, uv1).rgb;

    return SafePositive(
        lerp(
            grade0,
            grade1,
            blueFraction
        )
    );

#else

    return saturate(lutInput);

#endif
}


float3 ApplyBO2OriginalGradeDirect(float3 encodedColor)
{
    return SampleBO2PackedLUT(
        ApplyBO2OriginalShoulder(
            encodedColor
        )
    );
}


float3 ApplyBO2LUTCorrectionHDR(float3 linearColor)
{
    linearColor = SafePositive(linearColor);

#if RENODX_BO2_USE_ORIGINAL_LUT

    // Normalize with one shared peak so the LUT can be evaluated in its
    // original SDR range without independently clipping RGB channels.
    float hdrScale = max(
        MaxRGB(linearColor),
        1.0f
    );

    float3 normalizedLinear = saturate(
        linearColor / hdrScale
    );

    // Recreate the signal at the point where BO2 originally sampled its LUT.
    // The shoulder is used only to locate the authored LUT correction; its
    // brightness compression is not applied to the HDR source itself.
    float3 originalEncoded = sqrt(
        normalizedLinear
    );

    float3 shoulderedEncoded = ApplyBO2OriginalShoulder(
        originalEncoded
    );

    float3 gradedEncoded = SampleBO2PackedLUT(
        shoulderedEncoded
    );

    // Compare the LUT output with its input in linear light. Applying only
    // this delta preserves BO2's colour grade without retaining the original
    // SDR shoulder, allowing RenoDRT or PsychoV24 to be the sole tonemapper.
    float3 shoulderedLinear =
        shoulderedEncoded * shoulderedEncoded;

    float3 gradedLinear =
        gradedEncoded * gradedEncoded;

    float3 lutCorrection =
        gradedLinear - shoulderedLinear;

    float lutStrength = max(
        RENODX_BO2_LUT_STRENGTH,
        0.0f
    );

    float3 correctedNormalized = SafePositive(
        normalizedLinear
        + lutCorrection * lutStrength
    );

    return SafePositive(
        correctedNormalized * hdrScale
    );

#else

    return linearColor;

#endif
}


// ============================================================================
// Main shader
// ============================================================================

void main(
    float4 v0 : SV_Position0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0
)
{
    float4 bloomSample = codeTexture2.Sample(
        codeTexture2_s,
        v1.xy
    );

    float4 sceneSample = codeTexture0.Sample(
        codeTexture0_s,
        v1.xy
    );

    // Clamp only the sampled DOF/bloom and scene inputs to zero.
    // Values above 1.0 remain untouched for HDR.
    float3 bloomRGB = max(
        bloomSample.rgb,
        0.0f.xxx
    );

    float3 sceneRGB = max(
        sceneSample.rgb,
        0.0f.xxx
    );

    // BO2 reconstructs the final signal as:
    //
    //   sqrt(scene + 4 * bloom^2)
    //
    // Everything inside sqrt is the useful linear pre-tonemap signal. Keep it
    // linear for RenoDRT/PsychoV24 instead of applying BO2's SDR encode first.
    float3 combinedLinear = SafePositive(
        sceneRGB
        + bloomRGB
        * bloomRGB
        * RENODX_BO2_BLOOM_SCALE
    );

    // Exact original BO2 Vanilla path:
    //   gamma-2 encode -> original exponential shoulder -> packed LUT.
    float3 vanillaEncoded = ApplyBO2OriginalGradeDirect(
        sqrt(combinedLinear)
    );

    float3 toneMappedColor;

    if (IsVanillaMode())
    {
#if RENODX_GAMMA_DECODE_INPUT

        // Decode the game's original encoded result for RenoDX's linear
        // intermediate/output path. Set the macro to 0 for exact encoded SDR.
        toneMappedColor = GammaDecode2(
            vanillaEncoded
        );

#else

        toneMappedColor = vanillaEncoded;

#endif
    }
    else
    {
        // Preserve BO2's packed LUT colour grade, but remove its original SDR
        // shoulder so RenoDRT or PsychoV24 is the only active tonemapper.
        float3 toneMapInput = ApplyBO2LUTCorrectionHDR(
            combinedLinear
        );

        // common.hlsl ordering:
        //   1. HDR Boost
        //   2. Exposure/Contrast/Flare/Highlights/Shadows
        //   3. RenoDRT or PsychoV24 display mapping
        //   4. Controlled HDR highlight restoration
        //   5. Saturation/Blowout/Highlight Saturation
        float3 commonPreTonemapColor = ApplyCommonPreTonemapPipeline(
            toneMapInput
        );

        toneMappedColor = ApplyRenoDXTonemap(
            commonPreTonemapColor
        );

        toneMappedColor = RestoreHDRHighlights(
            toneMappedColor,
            commonPreTonemapColor
        );

        toneMappedColor = ApplyCommonPostTonemapPipeline(
            toneMappedColor
        );
    }

    float3 intermediateColor = renodx::draw::RenderIntermediatePass(
        toneMappedColor
    );

    intermediateColor = SafePositive(
        intermediateColor
    );

    if (IsVanillaMode())
    {
        intermediateColor = saturate(
            intermediateColor
        );
    }

    o0.rgb = intermediateColor;

    // Preserve BO2's original alpha behavior independently of HDR mapping.
    o0.a = dot(
        vanillaEncoded,
        BO2_OUTPUT_LUMINANCE_WEIGHTS
    );
}
