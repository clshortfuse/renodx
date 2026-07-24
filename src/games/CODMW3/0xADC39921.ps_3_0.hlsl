// HDR-compatible reconstruction of the original ps_3_0 shader.
//
// The original surface, lighting, fog, and alpha calculations are preserved.
//
// Optional correction:
//   Apply manual gamma-2.0 encoding before writing to an upgraded
//   R16G16B16A16_FLOAT render target.
//
// This may be needed when the original render target used automatic gamma
// or sRGB write conversion, which is no longer available after upgrading
// the target to a floating-point format.
//
// Positive values above 1.0 remain above 1.0:
//
//   1.0 -> 1.0
//   4.0 -> 2.0
//   9.0 -> 3.0
//
// No upper clamp is performed.

sampler2D colorMapSampler : register(s0);

float4 fogColorLinear : register(c0);


// ============================================================================
// Configuration
// ============================================================================

// Enable manual gamma-2.0 output encoding.
//
// Set to 1 for the primary test.
// Set to 0 to reproduce the original shader output without encoding.
#ifndef MW3_MANUAL_GAMMA2_OUTPUT
#define MW3_MANUAL_GAMMA2_OUTPUT 1
#endif


// Diagnostic test.
//
// Set to 1 temporarily. If affected objects become bright magenta, this
// replacement shader is active. If nothing changes, this shader is either
// not active in the affected scene or the replacement hash is incorrect.
#ifndef MW3_DEBUG_SHADER_ACTIVE
#define MW3_DEBUG_SHADER_ACTIVE 1
#endif


struct PS_INPUT
{
    float4 color     : COLOR0;
    float2 texcoord0 : TEXCOORD0;
    float4 texcoord1 : TEXCOORD1;
};


// ============================================================================
// Gamma encoding
// ============================================================================

float3 EncodeGamma2(float3 linearColor)
{
    return sqrt(
        max(linearColor, 0.0f)
    );
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
#if MW3_DEBUG_SHADER_ACTIVE

    return float4(
        1.0f,
        0.0f,
        1.0f,
        1.0f
    );

#else

    // Original:
    //
    //   texld r0, v1, s0
    float4 sampledColor =
        tex2D(
            colorMapSampler,
            input.texcoord0
        );


    // Original:
    //
    //   mul r0, r0, v0
    float4 modulatedColor =
        sampledColor
        * input.color;


    // Original:
    //
    //   mul r0.xyz, r0, r0
    //
    // Preserve the original approximate gamma-2.0 decoding operation.
    float3 decodedSurfaceColor =
        modulatedColor.rgb
        * modulatedColor.rgb;


    // Original:
    //
    //   mad r0.xyz, r0, v2, -c0
    //   mad oC0.xyz, v2.w, r0, c0
    //
    // Equivalent to:
    //
    //   lerp(
    //       fogColorLinear.rgb,
    //       decodedSurfaceColor * input.texcoord1.rgb,
    //       input.texcoord1.a
    //   )
    float3 litColor =
        decodedSurfaceColor
        * input.texcoord1.rgb;

    float3 outputColor =
        lerp(
            fogColorLinear.rgb,
            litColor,
            input.texcoord1.a
        );


    // The original destination was likely UNORM and could not retain
    // negative RGB. Restore that lower-bound behavior explicitly.
    outputColor =
        max(
            outputColor,
            0.0f
        );


#if MW3_MANUAL_GAMMA2_OUTPUT

    // Reproduce an approximate gamma-2.0 render-target write conversion.
    //
    // There is deliberately no clamp to 1.0, so HDR values remain available
    // on an R16G16B16A16_FLOAT destination.
    outputColor =
        EncodeGamma2(
            outputColor
        );

#endif


    // Original alpha:
    //
    //   sampled alpha * vertex alpha
    //
    // Do not gamma-encode alpha.
    float outputAlpha =
        saturate(
            modulatedColor.a
        );


    return float4(
        outputColor,
        outputAlpha
    );

#endif
}