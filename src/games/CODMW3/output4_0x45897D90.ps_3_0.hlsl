#include "./shared.h"


// ============================================================================
// PsychoV22 configuration
// ============================================================================

#ifndef RENODX_USE_PSYCHOV22
#define RENODX_USE_PSYCHOV22 1
#endif

// RenoDX normally uses 0 for the Vanilla tone-map selection.
// This local definition is guarded so shared.h can override it if needed.
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
//     scene and DOF samples
//       -> gamma 2.0 encode
//       -> original filtering, DOF blending, tint, color bias, and grain
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

sampler2D colorMapSampler  : register(s0);
sampler2D colorMapSampler1 : register(s4);
sampler2D colorMapSampler2 : register(s5);
sampler2D grainMapSampler  : register(s6);
sampler2D floatZSampler    : register(s7);

float4 renderTargetSize               : register(c3);
float4 colorTintBase                  : register(c5);
float4 colorTintDelta                 : register(c6);
float4 colorTintQuadraticDelta        : register(c7);
float4 colorBias                      : register(c8);
float4 dofEquationScene               : register(c9);
float4 dofEquationViewModelAndFarBlur : register(c11);
float4 dofLerpScale                   : register(c20);
float4 dofLerpBias                    : register(c21);


struct PS_INPUT
{
    // Scene, DOF, and depth texture coordinates.
    float2 texcoord  : TEXCOORD0;

    // Grain texture coordinates.
    float2 texcoord1 : TEXCOORD1;
};


// ============================================================================
// Safety helpers
// ============================================================================

float SafeFinite1(float value)
{
    // NaN is the only value that does not equal itself.
    value = (value == value)
        ? value
        : 0.0f;

    // Keep values representable in R16G16B16A16_FLOAT.
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


float3 PrepareSceneSample(float3 sampledColor)
{
    sampledColor =
        SafePositive(
            sampledColor
        );

#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    // Reconstruct the gamma 2.0 write that the original material passes
    // performed before this filter/DOF composite sampled their output.
    sampledColor =
        GammaEncode2(
            sampledColor
        );

#endif

    return sampledColor;
}


// ============================================================================
// Tone-map selection
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
    linearColor = SafePositive(linearColor);

#if RENODX_USE_PSYCHOV22

    float peakValue = max(
        RENODX_PEAK_WHITE_NITS
        / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
        1.0f
    );

    int gamutMode =
        (RENODX_PSYCHOV22_GAMUT_MODE > 0.5f)
        ? 1
        : 0;

    linearColor =
        renodx::tonemap::psychov::psychotm_test22(
            linearColor,
            peakValue,

            RENODX_TONE_MAP_EXPOSURE,
            RENODX_TONE_MAP_HIGHLIGHTS,
            RENODX_TONE_MAP_SHADOWS,
            RENODX_TONE_MAP_CONTRAST,
            RENODX_TONE_MAP_SATURATION,

            1.0f,                             // bleaching_intensity
            100.0f,                           // clip_point

            RENODX_TONE_MAP_HUE_CORRECTION,

            1.0f,                             // adaptation_contrast
            0,                                // white_curve_mode

            RENODX_PSYCHOV22_CONE_RESPONSE,

            0.18f.xxx,                        // current adaptation anchor
            0.18f.xxx,                        // desired adaptation anchor

            RENODX_PSYCHOV22_GAMUT_COMPRESSION,
            gamutMode,

            1.0f,                             // adaptive_normalization
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
    linearColor = SafePositive(linearColor);

    if (IsPsychoV22Mode())
    {
        return ApplyPsychoV22Tonemap(linearColor);
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
    const float centerWeight =
        0.0588235296f;

    const float surroundingWeight =
        0.235294119f;

    const float maximumSceneDepth =
        1500000.0f;

    const float3 luminanceWeights =
        float3(
            0.298999995f,
            0.587000012f,
            0.114f
        );

    float2 texelSize =
        renderTargetSize.zw;


    // ========================================================================
    // Five-tap scene filter
    // ========================================================================

    float2 sampleUV0 =
        input.texcoord
        + texelSize * float2(0.5f, -1.5f);

    float2 sampleUV1 =
        input.texcoord
        + texelSize * float2(-1.5f, -0.5f);

    float2 sampleUV2 =
        input.texcoord
        + texelSize * float2(-0.5f, 1.5f);

    float2 sampleUV3 =
        input.texcoord
        + texelSize * float2(1.5f, 0.5f);

    float3 sceneSample0 =
        PrepareSceneSample(
            tex2D(
                colorMapSampler,
                sampleUV0
            ).rgb
        );

    float4 centerSample =
        tex2D(
            colorMapSampler,
            input.texcoord
        );

    centerSample.rgb =
        PrepareSceneSample(
            centerSample.rgb
        );

    float3 sceneSample1 =
        PrepareSceneSample(
            tex2D(
                colorMapSampler,
                sampleUV1
            ).rgb
        );

    float3 sceneSample2 =
        PrepareSceneSample(
            tex2D(
                colorMapSampler,
                sampleUV2
            ).rgb
        );

    float3 sceneSample3 =
        PrepareSceneSample(
            tex2D(
                colorMapSampler,
                sampleUV3
            ).rgb
        );

    // Filter in the reconstructed gamma space, matching the path that would
    // have existed if every contributing material shader wrote gamma-encoded
    // RGB into the scene buffers.
    float3 filteredScene =
        sceneSample0
        * surroundingWeight;

    filteredScene +=
        centerSample.rgb
        * centerWeight;

    filteredScene +=
        sceneSample1
        * surroundingWeight;

    filteredScene +=
        sceneSample2
        * surroundingWeight;

    filteredScene +=
        sceneSample3
        * surroundingWeight;


    // ========================================================================
    // Depth-of-field factor
    // ========================================================================

    float sceneDepth =
        tex2D(
            floatZSampler,
            input.texcoord
        ).r;

    float depthComparison =
        maximumSceneDepth
        - sceneDepth;

    float sceneBlur =
        saturate(
            dofEquationScene.y * sceneDepth
            + dofEquationScene.w
        );

    sceneBlur *=
        dofEquationViewModelAndFarBlur.w;


    // ========================================================================
    // Additional DOF buffers
    // ========================================================================

    float4 colorMap1 =
        tex2D(
            colorMapSampler1,
            input.texcoord
        );

    colorMap1.rgb =
        PrepareSceneSample(
            colorMap1.rgb
        );

    float selectedBlur;

    if (depthComparison >= 0.0f)
    {
        selectedBlur =
            max(
                sceneBlur,
                colorMap1.a
            );
    }
    else
    {
        selectedBlur =
            colorMap1.a;
    }

    float4 dofWeights =
        saturate(
            selectedBlur * dofLerpScale
            + dofLerpBias
        );

    float2 inverseWeights =
        1.0f - dofWeights.xy;

    float filteredSceneWeight =
        min(
            inverseWeights.x,
            dofWeights.y
        );

    float colorMap1Weight =
        min(
            inverseWeights.y,
            dofWeights.z
        );


    // ========================================================================
    // Combine scene and DOF buffers
    // ========================================================================

    float3 combinedColor =
        filteredScene
        * filteredSceneWeight;

    combinedColor +=
        centerSample.rgb
        * dofWeights.x;

    combinedColor +=
        colorMap1.rgb
        * colorMap1Weight;

    float4 colorMap2 =
        tex2D(
            colorMapSampler2,
            input.texcoord
        );

    colorMap2.rgb =
        PrepareSceneSample(
            colorMap2.rgb
        );

    combinedColor +=
        colorMap2.rgb
        * dofWeights.w;


    // ========================================================================
    // Luminance-based color tint in the reconstructed grading space
    // ========================================================================

    // When compatibility mode is enabled, the scene and DOF buffers were
    // gamma-encoded before filtering and blending. Keep that reconstructed
    // grading space through the game's original tint and color-bias work.
    combinedColor =
        SafePositive(
            combinedColor
        );

    // Preserve unrestricted grading-space luminance for the grayscale target.
    // Values above 1.0 remain available.
    float gradingSpaceLuminance =
        dot(
            combinedColor,
            luminanceWeights
        );

    gradingSpaceLuminance =
        SafeFinite1(
            gradingSpaceLuminance
        );

    // The game's tint constants were authored around an SDR 0.0-1.0
    // luminance range. Restrict only the luminance used to calculate those
    // constants so HDR highlights do not make the tint and quadratic terms
    // grow uncontrollably.
    float gradingLuminance =
        saturate(
            gradingSpaceLuminance
        );

    float desaturationAmount =
        colorTintBase.w
        + gradingLuminance
        * colorTintDelta.w;

    float3 linearTint =
        colorTintBase.rgb
        + gradingLuminance
        * colorTintDelta.rgb;

    // Use the unrestricted grading-space luminance as the grayscale target
    // so values above 1.0 remain unclamped through the original grading.
    float3 luminanceTintedColor =
        lerp(
            combinedColor,
            gradingSpaceLuminance.xxx,
            desaturationAmount
        );


    // ========================================================================
    // HDR-safe quadratic tint and color bias
    // ========================================================================

    // Use the SDR-limited luminance only for the quadratic grading curve.
    // For example, an HDR luminance of 8.0 would otherwise square to 64.0.
    float gradingLuminanceSquared =
        gradingLuminance
        * gradingLuminance;

    float3 tintMultiplier =
        linearTint
        + gradingLuminanceSquared
        * colorTintQuadraticDelta.rgb;

    float3 gradedOutput =
        luminanceTintedColor
        * tintMultiplier
        + colorBias.rgb;

    gradedOutput =
        SafePositive(
            gradedOutput
        );


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
    //   add r1.xyz, -gradedOutput, 1
    //   mad output.xyz, grainColor, r1, gradedOutput
    //
    // Equivalent to:
    //
    //   gradedOutput + grainColor * (1 - gradedOutput)
    float3 grainOutput =
        gradedOutput
        + grainColor
        * (1.0f - gradedOutput);

    grainOutput =
        SafePositive(
            grainOutput
        );


    // ========================================================================
    // Decode to scene-linear RGB before RenoDX / PsychoV22 tonemapping
    // ========================================================================

    float3 linearOutput =
        grainOutput;

#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    // Filtering, DOF composition, grading, and grain were evaluated in the
    // reconstructed gamma 2.0 space. Decode the completed result back to
    // scene-linear RGB before passing it to either HDR tonemapper.
    linearOutput =
        GammaDecode2(
            grainOutput
        );

#endif

    linearOutput =
        SafePositive(
            linearOutput
        );

    float3 toneMappedOutput =
        ApplyRenoDXTonemap(
            linearOutput
        );


    // ========================================================================
    // RenoDX intermediate output
    // ========================================================================

    // No additional gamma encoding, sRGB encoding, or BT.2020 conversion is
    // performed here. Compatibility mode already decoded the graded scene back
    // to linear before tone mapping, so RenoDX's intermediate output remains in
    // its expected linear HDR space.
    float3 intermediateOutput =
        renodx::draw::RenderIntermediatePass(
            toneMappedOutput
        );

    intermediateOutput =
        SafePositive(
            intermediateOutput
        );


    // ========================================================================
    // Vanilla SDR output clamp
    // ========================================================================

    // Vanilla mode remains constrained to the original SDR 0.0-1.0 output
    // range. The clamp is performed at the final write point so any earlier
    // grading or intermediate-output conversion cannot restore HDR values.
    //
    // RenoDRT, PsychoV22, and all other HDR modes remain unclamped.
    if (IsVanillaMode())
    {
        intermediateOutput =
            saturate(
                intermediateOutput
            );
    }


    return float4(
        intermediateOutput,
        1.0f
    );
}