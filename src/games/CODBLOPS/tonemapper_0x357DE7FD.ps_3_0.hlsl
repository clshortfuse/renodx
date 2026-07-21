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

            // RenoDX tone-map controls.
            RENODX_TONE_MAP_EXPOSURE,
            RENODX_TONE_MAP_HIGHLIGHTS,
            RENODX_TONE_MAP_SHADOWS,
            RENODX_TONE_MAP_CONTRAST,
            RENODX_TONE_MAP_SATURATION,

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
// RenoDX tonemapper
// ============================================================================

float3 ApplyRenoDXTonemap(float3 linearColor)
{
    linearColor =
        SafePositive(linearColor);

    // Apply the same stronger white shoulder before both RenoDRT and
    // PsychoV22. This keeps the comparison between the two modes consistent.


    if (IsPsychoV22Mode())
    {
        return ApplyPsychoV22Tonemap(
            linearColor
        );
    }

    renodx::draw::Config config =
        renodx::draw::BuildConfig();

    config.reno_drt_tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;

    linearColor =
        renodx::draw::ToneMapPass(
            linearColor,
            config
        );

    return SafePositive(linearColor);
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
        // The shared stronger white shoulder is applied inside
        // ApplyRenoDXTonemap before either RenoDRT or PsychoV22.
        toneMappedColor =
            ApplyRenoDXTonemap(
                toneMapInput
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