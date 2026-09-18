#include "./shared.h"


// ============================================================================
// PsychoV24 configuration
// ============================================================================

#ifndef RENODX_USE_PSYCHOV24
#define RENODX_USE_PSYCHOV24 1
#endif

// RenoDX normally uses 0 for the Vanilla tone-map selection.
// This definition is guarded so shared.h can override it if necessary.
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
#if RENODX_USE_PSYCHOV24
#include "../../shaders/tonemap/psychov/psychov-24.hlsl"
#endif


// ============================================================================
// Missing gamma-write compatibility
// ============================================================================

// 1 = reconstruct the original gamma-space scene path in this output shader.
//
// Processing when enabled:
//
//     sampled linear scene
//       -> gamma 2.0 encode
//       -> original tint, color bias, and grain
//       -> gamma 2.0 decode
//       -> RenoDX/PsychoV24 tone mapping
//
// Disable this if the contributing material shaders already contain their
// individual final gamma-encoding fixes.
#ifndef RENODX_COMPENSATE_MISSING_GAMMA_WRITES
#define RENODX_COMPENSATE_MISSING_GAMMA_WRITES 1
#endif


// ============================================================================
// Original shader resources
// ============================================================================

sampler2D colorMapSampler : register(s0);
sampler2D grainMapSampler : register(s4);

float4 colorTintBase           : register(c3);
float4 colorTintDelta          : register(c5);
float4 colorTintQuadraticDelta : register(c6);
float4 colorBias               : register(c7);


struct PS_INPUT
{
    float2 texcoord  : TEXCOORD0;
    float2 texcoord1 : TEXCOORD1;
};


// ============================================================================
// Constants
// ============================================================================

static const float3 LUMINANCE_WEIGHTS =
    float3(
        0.298999995f,
        0.587000012f,
        0.114000000f
    );


// ============================================================================
// Safety and gamma helpers
// ============================================================================

float SafeFinite1(float value)
{
    // NaN is the only floating-point value that is not equal to itself.
    value = (value == value)
        ? value
        : 0.0f;

    // Keep values representable by R16G16B16A16_FLOAT and positive for the
    // HDR tonemappers.
    return min(
        max(value, 0.0f),
        65504.0f
    );
}


float3 SafePositive(float3 color)
{
    return float3(
        SafeFinite1(color.r),
        SafeFinite1(color.g),
        SafeFinite1(color.b)
    );
}


float3 GammaEncode2(float3 linearColor)
{
    // Power-law gamma 2.0 encoding, not sRGB encoding.
    //
    // There is no upper clamp. Values above 1.0 remain above 1.0.
    return sqrt(
        max(
            linearColor,
            0.0f
        )
    );
}


float3 GammaDecode2(float3 gammaColor)
{
    // Inverse of GammaEncode2().
    //
    // Values above 1.0 remain above 1.0 and become linear HDR values.
    gammaColor =
        max(
            gammaColor,
            0.0f
        );

    return gammaColor * gammaColor;
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
        SafePositive(
            linearColor
        );

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

            // RenoDX tone-map controls.
            RENODX_TONE_MAP_EXPOSURE,
            RENODX_TONE_MAP_HIGHLIGHTS,
            RENODX_TONE_MAP_SHADOWS,
            RENODX_TONE_MAP_CONTRAST,
            RENODX_TONE_MAP_SATURATION,

            // PsychoV24 controls.
            1.0f,                            // bleaching_intensity
            100.0f,                          // clip_point

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
            RENODX_PSYCHOV24_HIGHLIGHT_SATURATION, // highlight_saturation
            RENODX_PSYCHOV24_GAMUT_HUE_RESTORE     // gamut_hue_restore
        );

#endif

    return SafePositive(
        linearColor
    );
}


// ============================================================================
// RenoDX tonemapping
// ============================================================================

float3 ApplyRenoDXTonemap(float3 linearColor)
{
    linearColor =
        SafePositive(
            linearColor
        );

    if (IsPsychoV24Mode())
    {
        return ApplyPsychoV24Tonemap(
            linearColor
        );
    }

    // This is the correct RenoDX configuration path used by the other
    // working output shaders. There is no Config::Create() API here.
    renodx::draw::Config config =
        renodx::draw::BuildConfig();

    config.reno_drt_tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;

    linearColor =
        renodx::draw::ToneMapPass(
            linearColor,
            config
        );

    return SafePositive(
        linearColor
    );
}



// ============================================================================
// Post-tonemap bloom / highlight headroom restoration
// ============================================================================
//
// RenoDRT / PsychoV24 may compress bright scene values before later WaW bloom
// or post-processing sees them. Preserve the existing tonemapped image, then
// restore only the source energy that originally existed above 1.0.
//
// RENODX_BLOOM_BRIGHTNESS controls ONLY this restored HDR excess:
//
//   0.0 = no restoration; exact existing tonemapped output
//   1.0 = restore the original missing >1.0 source headroom
//   2.0 = twice the source excess, bounded by configured display headroom
//
// This leaves all existing RenoDX / Psycho sliders fully active because their
// tonemapped result remains the base image.
// ============================================================================

float3 RestorePostTonemapBloomHeadroom(
    float3 preTonemapColor,
    float3 postTonemapColor)
{
    preTonemapColor =
        SafePositive(
            preTonemapColor
        );

    postTonemapColor =
        SafePositive(
            postTonemapColor
        );

    float bloomStrength =
        max(
            (float)RENODX_BLOOM_BRIGHTNESS,
            0.0f
        );

    if (bloomStrength <= 0.0f)
        return postTonemapColor;

    float sourcePeak =
        max(
            preTonemapColor.r,
            max(
                preTonemapColor.g,
                preTonemapColor.b
            )
        );

    // SDR-range pixels have no HDR excess to restore.
    if (sourcePeak <= 1.0f)
        return postTonemapColor;

    float mappedPeak =
        max(
            postTonemapColor.r,
            max(
                postTonemapColor.g,
                postTonemapColor.b
            )
        );

    float displayPeak =
        max(
            RENODX_PEAK_WHITE_NITS
            / max(
                RENODX_DIFFUSE_WHITE_NITS,
                1.0f
            ),
            1.0f
        );

    // Scale only the original HDR excess above SDR white.
    // This keeps the Bloom Strength slider meaningful instead of multiplying
    // the complete scene image.
    float sourceExcess =
        sourcePeak
        - 1.0f;

    float targetPeak =
        min(
            1.0f
            + sourceExcess
            * bloomStrength,
            displayPeak
        );

    // Never reduce the normal tonemapper result.
    if (targetPeak <= mappedPeak)
        return postTonemapColor;

    // Restore with the source highlight's RGB ratios rather than per-channel
    // clipping, so saturated highlights retain their hue.
    float3 sourceShape =
        preTonemapColor
        / max(
            sourcePeak,
            1e-6f
        );

    float missingPeak =
        targetPeak
        - mappedPeak;

    float3 restoredColor =
        postTonemapColor
        + sourceShape
        * missingPeak;

    restoredColor =
        SafePositive(
            restoredColor
        );

    // Final configured-display guard. Use one common scale to avoid changing
    // hue if the additive restoration slightly overshoots the target peak.
    float restoredPeak =
        max(
            restoredColor.r,
            max(
                restoredColor.g,
                restoredColor.b
            )
        );

    if (restoredPeak > displayPeak)
    {
        restoredColor *=
            displayPeak
            / max(
                restoredPeak,
                1e-6f
            );
    }

    return SafePositive(
        restoredColor
    );
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    float4 sampledColor =
        tex2D(
            colorMapSampler,
            input.texcoord
        );


    // ========================================================================
    // Scene input and optional gamma-space reconstruction
    // ========================================================================

    float3 gradingInput =
        SafePositive(
            sampledColor.rgb
        );

#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    gradingInput =
        GammaEncode2(
            gradingInput
        );

#endif


    // ========================================================================
    // Original luminance-based tint and color bias
    // ========================================================================

    float gradingSpaceLuminance = dot(
        gradingInput,
        LUMINANCE_WEIGHTS
    );

    gradingSpaceLuminance =
        SafeFinite1(
            gradingSpaceLuminance
        );

    // The game-authored tint constants are intended for an SDR-range
    // luminance control value. Preserve unrestricted luminance only for the
    // grayscale target.
    float gradingLuminance =
        saturate(
            gradingSpaceLuminance
        );

    // Original assembly:
    //
    //   mad r1, c5.wxyz, luminance, c3.wxyz
    float4 tintParameters =
        colorTintDelta.wxyz
        * gradingLuminance
        + colorTintBase.wxyz;

    // Original assembly:
    //
    //   lrp r2.xyz, r1.x, luminance, sampledColor
    float3 tintedColor =
        lerp(
            gradingInput,
            gradingSpaceLuminance.xxx,
            tintParameters.x
        );

    float gradingLuminanceSquared =
        gradingLuminance
        * gradingLuminance;

    // Original assembly:
    //
    //   mad r0.xyz, luminanceSquared, c6, r1.yzww
    float3 tintScale =
        gradingLuminanceSquared
        * colorTintQuadraticDelta.rgb
        + tintParameters.yzw;

    float3 gradedColor =
        tintedColor
        * tintScale
        + colorBias.rgb;


    // ========================================================================
    // Original grain processing
    // ========================================================================

    float3 grainColor =
        tex2D(
            grainMapSampler,
            input.texcoord1
        ).rgb;

    // Original assembly:
    //
    //   add r1.xyz, -gradedColor, 1
    //   mad output.xyz, grain, r1, gradedColor
    //
    // Equivalent to:
    //
    //   gradedColor + grain * (1 - gradedColor)
    float3 grainOutput =
        gradedColor
        + grainColor
        * (1.0f - gradedColor);

    grainOutput =
        SafePositive(
            grainOutput
        );


    // ========================================================================
    // Decode to scene-linear RGB before tone mapping
    // ========================================================================

    float3 linearOutput =
        grainOutput;

#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    linearOutput =
        GammaDecode2(
            grainOutput
        );

#endif

    linearOutput =
        SafePositive(
            linearOutput
        );


    // ========================================================================
    // RenoDX or PsychoV24 tone mapping
    // ========================================================================

    float3 toneMappedColor =
        ApplyRenoDXTonemap(
            linearOutput
        );


    // ========================================================================
    // RenoDX intermediate rendering
    // ========================================================================

    // Restore headroom in linear BT.709, before intermediate gamma correction,
    // scaling, color conversion, and encoding. Both operands use the same units.
    if (!IsVanillaMode())
    {
        toneMappedColor = RestorePostTonemapBloomHeadroom(linearOutput, toneMappedColor);
    }
    float3 intermediateColor =
        renodx::draw::RenderIntermediatePass(
            toneMappedColor
        );

    intermediateColor =
        SafePositive(
            intermediateColor
        );






    // ========================================================================
    // Vanilla SDR output clamp
    // ========================================================================

    // Vanilla remains limited to the original SDR output range.
    // RenoDRT, PsychoV24, and other HDR modes remain unclamped.
    if (IsVanillaMode())
    {
        intermediateColor =
            saturate(
                intermediateColor
            );
    }


    return float4(
        intermediateColor,
        1.0f
    );
}
