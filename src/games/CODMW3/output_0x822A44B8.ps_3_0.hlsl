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

// 1 = reconstruct the original gamma-space scene path at this output shader.
//
// Processing when enabled:
//
//     sampled linear scene
//       -> gamma 2.0 encode
//       -> original tint and colour-bias processing
//       -> gamma 2.0 decode
//       -> RenoDX/PsychoV22 tone mapping
//
// This approximates the original material-pass gamma writes without requiring
// every affected material shader to be patched individually.
//
// Keep this disabled if the individual material shaders are already patched,
// otherwise the scene may be encoded and decoded incorrectly.
#ifndef RENODX_COMPENSATE_MISSING_GAMMA_WRITES
#define RENODX_COMPENSATE_MISSING_GAMMA_WRITES 1
#endif


// ============================================================================
// Original shader resources
// ============================================================================

sampler2D colorMapSampler : register(s0);

float4 colorTintBase           : register(c3);
float4 colorTintDelta          : register(c5);
float4 colorTintQuadraticDelta : register(c6);
float4 colorBias               : register(c7);


struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
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
// Safety helpers
// ============================================================================

float SafeFinite1(float value)
{
    // NaN is the only floating-point value that is not equal to itself.
    value = (value == value)
        ? value
        : 0.0f;

    // Keep the value representable by R16G16B16A16_FLOAT.
    //
    // Negative scene-light values are also removed because the tonemappers
    // used below expect positive scene-linear RGB.
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

    return SafePositive(linearColor);
}


// ============================================================================
// RenoDX tonemapping
// ============================================================================

float3 ApplyRenoDXTonemap(float3 linearColor)
{
    linearColor =
        SafePositive(linearColor);

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
    // Scene input and optional missing gamma-write compensation
    // ========================================================================

    float3 sceneInput =
        SafePositive(
            sampledColor.rgb
        );

#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    // Approximate the gamma 2.0 write that would otherwise need to be added
    // to every affected material shader.
    //
    // This is intentionally applied before the original tint/grading and
    // tone-mapping path, because that most closely matches receiving a
    // gamma-encoded scene texture from the preceding material passes.
    sceneInput =
        GammaEncode2(
            sceneInput
        );

#endif

    // The original tint and colour-bias operations are evaluated in the scene
    // encoding reconstructed above. When compatibility mode is enabled, this
    // is gamma 2.0 space rather than scene-linear space.
    float3 gradingInput =
        sceneInput;


    // ========================================================================
    // Grading-space luminance
    // ========================================================================

    // Preserve values above 1.0 while the original tint operations run.
    float gradingSpaceLuminance = dot(
        gradingInput,
        LUMINANCE_WEIGHTS
    );

    gradingSpaceLuminance =
        SafeFinite1(gradingSpaceLuminance);


    // The tint constants were authored around an SDR 0.0–1.0 luminance
    // range. Restrict only the luminance used to calculate those constants.
    //
    // This prevents the quadratic tint term from growing rapidly when bloom
    // or other highlights contain HDR values above 1.0.
    float gradingLuminance =
        saturate(gradingSpaceLuminance);


    // ========================================================================
    // Original luminance-based tint and colour-bias processing
    // ========================================================================

    // Original assembly equivalent:
    //
    //   mad r1, c5.wxyz, luminance, c3.wxyz
    //
    // The original SDR-authored tint parameters now use gradingLuminance.
    float4 tintParameters =
        colorTintDelta.wxyz
        * gradingLuminance
        + colorTintBase.wxyz;


    // Original assembly equivalent:
    //
    //   lrp r2.xyz, r1.x, luminance, sampledColor
    //
    // Use the unrestricted grading-space luminance as the grayscale target.
    // Values above 1.0 are retained rather than clipped to SDR white.
    float3 tintedColor = lerp(
        gradingInput,
        gradingSpaceLuminance.xxx,
        tintParameters.x
    );


    // Use the SDR-limited luminance for the quadratic colour-tint term.
    //
    // Without this restriction, an HDR luminance of 8.0 would produce a
    // quadratic value of 64.0 and could strongly amplify coloured bloom.
    float gradingLuminanceSquared =
        gradingLuminance
        * gradingLuminance;


    // Original assembly equivalent:
    //
    //   mad r0.xyz, luminanceSquared, c6, r1.yzww
    float3 tintScale =
        gradingLuminanceSquared
        * colorTintQuadraticDelta.rgb
        + tintParameters.yzw;


    float3 gradedOutput =
        tintedColor
        * tintScale
        + colorBias.rgb;

    gradedOutput =
        SafePositive(
            gradedOutput
        );


    // ========================================================================
    // Decode to scene-linear RGB before tone mapping
    // ========================================================================

    float3 linearOutput =
        gradedOutput;

#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    // The original tint and bias work was evaluated in gamma 2.0 space.
    // Decode it back to scene-linear RGB before RenoDRT or PsychoV22.
    linearOutput =
        GammaDecode2(
            gradedOutput
        );

#endif

    // Tonemappers require finite, positive scene-linear input.
    linearOutput =
        SafePositive(
            linearOutput
        );


    // ========================================================================
    // RenoDX or PsychoV22 tonemapping
    // ========================================================================

    float3 toneMappedColor =
        ApplyRenoDXTonemap(
            linearOutput
        );


    // ========================================================================
    // RenoDX intermediate rendering
    // ========================================================================

    // No manual BT.709-to-BT.2020 conversion is performed here.
    //
    // The tonemapped RGB is passed directly to RenoDX's intermediate output
    // processing.
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

    // Vanilla mode is restricted to the original SDR 0.0-1.0 output range.
    // Applying the clamp at the final write point guarantees that grading,
    // tone-map selection, and RenderIntermediatePass cannot leave HDR values
    // in the Vanilla output.
    //
    // RenoDRT, PsychoV22, and other HDR modes remain unclamped.
    if (IsVanillaMode())
    {
        intermediateColor =
            saturate(
                intermediateColor
            );
    }


    // ========================================================================
    // Final output
    // ========================================================================

    // No additional gamma or sRGB encoding is applied here.
    //
    // Compatibility mode encoded the scene before the original grading, then
    // decoded that graded result before tone mapping. RenderIntermediatePass
    // and the final HDR target remain in RenoDX's expected linear output space.
    //
    // HDR values above 1.0 remain available in non-Vanilla modes when the
    // destination resource is R16G16B16A16_FLOAT.
    return float4(
        intermediateColor,
        1.0f
    );
}