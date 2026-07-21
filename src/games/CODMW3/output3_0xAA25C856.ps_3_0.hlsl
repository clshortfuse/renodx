#include "./shared.h"


// ============================================================================
// PsychoV22 configuration
// ============================================================================

#ifndef RENODX_USE_PSYCHOV22
#define RENODX_USE_PSYCHOV22 1
#endif

// RenoDX normally uses 0 for the Vanilla tone-map selection.
// This definition is guarded so shared.h can override it if necessary.
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
//       -> RenoDX/PsychoV22 tone mapping
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
        SafePositive(
            linearColor
        );

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
            100.0f,                          // clip_point

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

    if (IsPsychoV22Mode())
    {
        return ApplyPsychoV22Tonemap(
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
    // RenoDX or PsychoV22 tone mapping
    // ========================================================================

    float3 toneMappedColor =
        ApplyRenoDXTonemap(
            linearOutput
        );


    // ========================================================================
    // RenoDX intermediate rendering
    // ========================================================================

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
    // RenoDRT, PsychoV22, and other HDR modes remain unclamped.
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
