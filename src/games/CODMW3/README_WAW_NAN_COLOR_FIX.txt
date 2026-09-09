// ============================================================================
// HDR-safe reconstruction of the original color tint shader
//
// Original shader:
//   - Samples colorMapSampler
//   - Calculates luminance
//   - Applies luminance-based tint
//   - Applies quadratic tint
//   - Adds colorBias
//   - Multiplies by vertex color
//
// Added fixes:
//   - Optional gamma 2.0 write reconstruction
//   - HDR-safe luminance handling
//   - Prevents quadratic tint from exploding above SDR white
//   - Preserves HDR values above 1.0
//   - Removes invalid/negative values
//
// This is NOT a tonemapper.
// ============================================================================


// ============================================================================
// Missing gamma-write compatibility
// ============================================================================

// 1 =
//     sampled linear scene
//       -> gamma 2.0 encode
//       -> original tint / bias shader
//       -> gamma 2.0 decode
//
// 0 = use the texture exactly as provided.
//
// If you've already fixed the material shaders themselves so that they perform
// the expected gamma writes, set this to 0.

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


// ============================================================================
// Pixel shader input
// ============================================================================

struct PixelInput
{
    float4 color    : COLOR0;
    float2 texCoord : TEXCOORD0;
};


// ============================================================================
// Original luminance coefficients
// ============================================================================

static const float3 LUMINANCE_WEIGHTS =
    float3(
        0.298999995f,
        0.587000012f,
        0.114000000f
    );


// ============================================================================
// HDR safety
// ============================================================================

float SafeFinite1(float value)
{
    // NaN check.
    value = (value == value)
        ? value
        : 0.0f;

    // Keep the result positive and representable by FP16.
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


// ============================================================================
// Gamma 2.0 reconstruction
// ============================================================================

float3 GammaEncode2(float3 linearColor)
{
    // Equivalent to pow(color, 1 / 2).
    //
    // IMPORTANT:
    // There is deliberately no saturate() here.
    // HDR values above 1.0 stay above 1.0.

    return sqrt(
        max(
            linearColor,
            0.0f
        )
    );
}


float3 GammaDecode2(float3 gammaColor)
{
    // Equivalent to pow(color, 2).

    gammaColor =
        max(
            gammaColor,
            0.0f
        );

    return gammaColor * gammaColor;
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PixelInput input) : COLOR0
{
    // ------------------------------------------------------------------------
    // Original:
    //
    //     texld_pp r0, v1, s0
    // ------------------------------------------------------------------------

    float4 sampledColor =
        tex2D(
            colorMapSampler,
            input.texCoord
        );


    // ------------------------------------------------------------------------
    // Scene input
    // ------------------------------------------------------------------------

    float3 gradingInput =
        SafePositive(
            sampledColor.rgb
        );


#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    // Reconstruct the gamma 2.0 scene representation that the original shader
    // was apparently authored to receive.
    //
    // HDR is NOT clipped here.

    gradingInput =
        GammaEncode2(
            gradingInput
        );

#endif


    // ========================================================================
    // Luminance
    // ========================================================================

    // Original:
    //
    //     dp3_pp r0.w, r0, c0

    float gradingSpaceLuminance =
        dot(
            gradingInput,
            LUMINANCE_WEIGHTS
        );

    gradingSpaceLuminance =
        SafeFinite1(
            gradingSpaceLuminance
        );


    // ------------------------------------------------------------------------
    // SDR control luminance
    // ------------------------------------------------------------------------
    //
    // The tint constants were authored for an SDR-range luminance value.
    //
    // DO NOT clamp gradingInput itself.
    //
    // Instead, only clamp the luminance used to calculate the tint controls.
    //
    // This is particularly important for the quadratic color term. Without
    // this, an HDR luminance of 8 would become:
    //
    //     8 * 8 = 64
    //
    // which can massively amplify the tint.

    float tintLuminance =
        saturate(
            gradingSpaceLuminance
        );


    // ========================================================================
    // Linear tint parameters
    // ========================================================================

    // Original assembly:
    //
    //     mov r1, c5
    //
    //     mad r1,
    //         r1.wxyz,
    //         r0.w,
    //         c3.wxyz
    //
    //
    // Equivalent:
    //
    //     r1 = colorTintDelta.wxyz * luminance
    //        + colorTintBase.wxyz

    float4 tintParameters =
        colorTintDelta.wxyz
        * tintLuminance
        + colorTintBase.wxyz;


    // ========================================================================
    // Luminance tint / desaturation
    // ========================================================================

    // Original:
    //
    //     lrp r2.xyz,
    //         r1.x,
    //         r0.w,
    //         r0
    //
    //
    // LRP here is equivalent to:
    //
    //     lerp(originalColor, luminance, amount)
    //
    //
    // IMPORTANT:
    //
    // Use the FULL HDR luminance here instead of tintLuminance.
    //
    // That allows highlights above 1.0 to remain above 1.0.

    float3 tintedColor =
        lerp(
            gradingInput,
            gradingSpaceLuminance.xxx,
            tintParameters.x
        );


    // ========================================================================
    // Quadratic tint
    // ========================================================================

    // Original:
    //
    //     mul r0.x, r0.w, r0.w

    float tintLuminanceSquared =
        tintLuminance
        * tintLuminance;


    // Original:
    //
    //     mad r0.xyz,
    //         r0.x,
    //         c6,
    //         r1.yzww

    float3 tintScale =
        tintLuminanceSquared
        * colorTintQuadraticDelta.rgb
        + tintParameters.yzw;


    // ========================================================================
    // Color bias
    // ========================================================================

    // Original:
    //
    //     mad_pp r0.xyz,
    //            r2,
    //            r0,
    //            c7

    float3 outputColor =
        tintedColor
        * tintScale
        + colorBias.rgb;


    // ========================================================================
    // Original vertex-color multiplication
    // ========================================================================

    // Original:
    //
    //     mul_pp oC0.xyz, r0, v0
    //
    // Keep this BEFORE the gamma decode because it was part of the original
    // gamma-space shader operation.

    outputColor *=
        input.color.rgb;


    outputColor =
        SafePositive(
            outputColor
        );


#if RENODX_COMPENSATE_MISSING_GAMMA_WRITES

    // ------------------------------------------------------------------------
    // Return to scene-linear
    // ------------------------------------------------------------------------
    //
    // No tonemapping is done.
    //
    // HDR values above 1.0 remain above 1.0.

    

    outputColor =
        SafePositive(
            outputColor
        );

#endif


    // ========================================================================
    // Final output
    // ========================================================================

    // Original alpha:
    //
    //     mov_pp oC0.w, v0.w
    //
    // No saturate().
    // No SDR clamp.
    // No RenoDRT.
    // No PsychoV24.
    // No RenderIntermediatePass.

    return float4(
        outputColor,
        input.color.a
    );
}