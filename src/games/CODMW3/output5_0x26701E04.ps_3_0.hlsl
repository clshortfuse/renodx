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
#if RENODX_USE_PSYCHOV24
#include "../../shaders/tonemap/psychov/psychov-24.hlsl"
#endif


// ============================================================================
// Scene encoding and HDR grading compatibility
// ============================================================================

// Encoding of colorMapSampler at this output pass:
//
//   0 = scene-linear RGB
//   1 = gamma-2.0 encoded RGB; most likely for this original DX9 output pass
//   2 = scene-linear RGB, but emulate the missing gamma write before grading
//
// The previous conversion effectively assumed mode 2 unconditionally. That can
// produce severely incorrect color when this particular s0 is already encoded.
#ifndef RENODX_SCENE_ENCODING
#define RENODX_SCENE_ENCODING 2
#endif

// 1 = reproduce the exact original grading for SDR values, then extend only the
//     resulting correction into values above 1.0. Recommended for HDR.
// 0 = run the legacy curve directly on unrestricted values. This is closer to
//     the literal assembly but can make HDR colors extreme or inverted.
#ifndef RENODX_SAFE_HDR_GRADING
#define RENODX_SAFE_HDR_GRADING 1
#endif


// ============================================================================
// Original shader resources and register layout
// ============================================================================

sampler2D colorMapSampler  : register(s0);
sampler2D normalMapSampler : register(s4);

float4 gameTime                : register(c3);
float4 colorTintBase           : register(c5);
float4 colorTintDelta          : register(c6);
float4 colorTintQuadraticDelta : register(c7);
float4 colorBias               : register(c8);
float4 fullscreenDistortion    : register(c9);
float4 fadeEffect              : register(c11);
float4 viewportDimensions      : register(c35);


struct PS_INPUT
{
    float2 texcoord           : TEXCOORD0;
    float2 distortionTexcoord : TEXCOORD1;
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
    value = (value == value)
        ? value
        : 0.0f;

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
    return sqrt(
        max(
            linearColor,
            0.0f
        )
    );
}


float3 GammaDecode2(float3 gammaColor)
{
    gammaColor = max(
        gammaColor,
        0.0f
    );

    return gammaColor * gammaColor;
}


// ============================================================================
// Assembly-equivalent fullscreen distortion and viewport sampling
// ============================================================================

float2 GetSceneTexcoord(PS_INPUT input)
{
    // Assembly reconstruction:
    //
    //   r0.x = gameTime.x * fullscreenDistortion.x
    //   r0.z = input.distortionTexcoord.y
    //          - gameTime.w * fullscreenDistortion.z
    //   r0.xy = float2(r0.x + input.distortionTexcoord.x, r0.z + 1)

    float2 animatedNormalUV;

    animatedNormalUV.x =
        input.distortionTexcoord.x
        + gameTime.x * fullscreenDistortion.x;

    animatedNormalUV.y =
        input.distortionTexcoord.y
        + 1.0f
        - gameTime.w * fullscreenDistortion.z;


    // First normal-map layer:
    //
    //   texld normalMapSampler, animatedNormalUV
    //   normal0.xy *= gameTime.y

    float2 normal0 =
        tex2D(
            normalMapSampler,
            animatedNormalUV
        ).xy
        * gameTime.y;


    // Second normal-map layer at half scale:
    //
    //   texld normalMapSampler, animatedNormalUV * 0.5
    //   normal1.xy *= gameTime.x

    float2 normal1 =
        tex2D(
            normalMapSampler,
            animatedNormalUV * 0.5f
        ).xy
        * gameTime.x;


    // Assembly:
    //
    //   r0.xy = normal0.xy * 0.5 + normal1.xy * 0.5

    float2 distortionVector =
        (normal0 + normal1) * 0.5f;


    // Assembly:
    //
    //   fade = saturate(input.texcoord.y + 1 - 2 * fadeEffect.w)
    //   fade = fade * fade
    //   distortionAmount = fade * fullscreenDistortion.w

    float fadeMask = saturate(
        input.texcoord.y
        + 1.0f
        - 2.0f * fadeEffect.w
    );

    fadeMask *= fadeMask;

    float distortionAmount =
        fadeMask * fullscreenDistortion.w;


    float2 sceneTexcoord =
        input.texcoord
        + distortionVector * distortionAmount;


    // Preserve the assembly viewport clamp and half-pixel offsets:
    //
    //   uv = saturate(
    //       (uv - viewportDimensions.xy + float2(0, 0.005))
    //       * viewportDimensions.zw
    //   )
    //
    //   uv = uv / viewportDimensions.zw
    //      + viewportDimensions.xy
    //      + float2(0, -0.0025)

    float2 viewportLocal = saturate(
        (
            sceneTexcoord
            - viewportDimensions.xy
            + float2(0.0f, 0.00499999989f)
        )
        * viewportDimensions.zw
    );

    sceneTexcoord =
        viewportLocal / viewportDimensions.zw
        + viewportDimensions.xy
        + float2(-0.0f, -0.00249999994f);

    return sceneTexcoord;
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
    linearColor = SafePositive(linearColor);

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
            peakValue,
            RENODX_TONE_MAP_EXPOSURE,
            RENODX_TONE_MAP_HIGHLIGHTS,
            RENODX_TONE_MAP_SHADOWS,
            RENODX_TONE_MAP_CONTRAST,
            RENODX_TONE_MAP_SATURATION,
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

    return SafePositive(linearColor);
}


// ============================================================================
// RenoDX tonemapping
// ============================================================================

float3 ApplyRenoDXTonemap(float3 linearColor)
{
    linearColor = SafePositive(linearColor);

    if (IsPsychoV24Mode())
    {
        return ApplyPsychoV24Tonemap(
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

float3 ApplyOriginalColorGrading(float3 gradingInput)
{
    float luminance = dot(
        gradingInput,
        LUMINANCE_WEIGHTS
    );

    float4 tintParameters =
        colorTintDelta.wxyz
        * luminance
        + colorTintBase.wxyz;

    // Exact assembly equivalent:
    //   lrp r2.xyz, r1.x, r0.w, r0
    float3 tintedColor = lerp(
        gradingInput,
        luminance.xxx,
        tintParameters.x
    );

    float luminanceSquared =
        luminance * luminance;

    float3 tintScale =
        luminanceSquared
        * colorTintQuadraticDelta.rgb
        + tintParameters.yzw;

    return tintedColor
        * tintScale
        + colorBias.rgb;
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    float2 sceneTexcoord =
        GetSceneTexcoord(input);

    float4 sampledColor = tex2D(
        colorMapSampler,
        sceneTexcoord
    );

    float3 sampledRGB =
        SafePositive(sampledColor.rgb);


    // ========================================================================
    // Select the encoding in which the original grading was authored
    // ========================================================================

    float3 gradingInput;

#if RENODX_SCENE_ENCODING == 0

    // s0 is already scene-linear.
    gradingInput = sampledRGB;

#elif RENODX_SCENE_ENCODING == 1

    // s0 is already gamma-2.0 encoded. Do not encode it again.
    gradingInput = sampledRGB;

#else

    // s0 is linear, but preceding material passes omitted the gamma write that
    // the original grading expected.
    gradingInput = GammaEncode2(sampledRGB);

#endif


    // ========================================================================
    // Original grading with a safe HDR extension
    // ========================================================================

    float3 gradedEncoding;

#if RENODX_SAFE_HDR_GRADING

    // The original output was authored around an unsigned 0-1 intermediate.
    // Evaluate that exact curve in its intended domain.
    float3 legacyInput = saturate(gradingInput);

    float3 legacyGraded =
        ApplyOriginalColorGrading(legacyInput);

    legacyGraded =
        max(legacyGraded, 0.0f);

    // For every value in the original SDR range this is mathematically equal
    // to legacyGraded. Above 1.0, carry forward only the grading correction
    // instead of feeding HDR values into the quadratic legacy curve.
    float3 gradingCorrection =
        legacyGraded - legacyInput;

    gradedEncoding =
        gradingInput + gradingCorrection;

#else

    // Literal unrestricted extension of the assembly grading curve.
    gradedEncoding =
        ApplyOriginalColorGrading(gradingInput);

#endif

    gradedEncoding =
        SafePositive(gradedEncoding);


    // ========================================================================
    // Convert to scene-linear before RenoDX/PsychoV24 tone mapping
    // ========================================================================

    float3 linearOutput;

#if RENODX_SCENE_ENCODING == 0

    // The grading itself was evaluated in linear space.
    linearOutput = gradedEncoding;

#else

    // Modes 1 and 2 evaluate the original grade in gamma-2.0 space.
    linearOutput = GammaDecode2(gradedEncoding);

#endif

    linearOutput =
        SafePositive(linearOutput);


    // ========================================================================
    // RenoDX/PsychoV24 output
    // ========================================================================

    float3 toneMappedColor =
        ApplyRenoDXTonemap(linearOutput);

    float3 intermediateColor =
        renodx::draw::RenderIntermediatePass(
            toneMappedColor
        );

    intermediateColor =
        SafePositive(intermediateColor);

    if (IsVanillaMode())
    {
        intermediateColor =
            saturate(intermediateColor);
    }

    // The original assembly writes alpha 1.0.
    return float4(
        intermediateColor,
        1.0f
    );
}
