// HDR-safe reconstruction of the original ps_3_0 shader.
//
// Main correction:
//
// The original shader performed:
//
//     modulatedRGB = sampledRGB * vertexColorRGB;
//     linearRGB    = modulatedRGB * modulatedRGB;
//
// That square was likely an approximate gamma-2.0 decode for an SDR,
// gamma-encoded texture.
//
// When colorMapSampler is upgraded to R16G16B16A16_FLOAT and already
// contains linear RGB, squaring it again causes severe darkening.
//
// This version:
//
//   - Does not square an already-linear FP16 texture.
//   - Optionally preserves the original square on the vertex colour.
//   - Preserves HDR values above 1.0.
//   - Removes negative output values that UNORM storage previously removed.
//   - Performs no gamma or sRGB output encoding.

sampler2D colorMapSampler : register(s0);

float4 fogColorLinear : register(c0);
float4 lightDiffuse   : register(c18);


// ============================================================================
// Input configuration
// ============================================================================

// 1:
// colorMapSampler contains linear RGB, such as an upgraded FP16 scene texture.
//
// 0:
// colorMapSampler still contains gamma-encoded SDR RGB and requires the
// original approximate gamma-2.0 decode.
#ifndef MW3_COLOR_MAP_INPUT_IS_LINEAR
#define MW3_COLOR_MAP_INPUT_IS_LINEAR 1
#endif


// The original shader squared:
//
//     sampledColor * vertexColor
//
// Therefore, the vertex colour was also included in the approximate gamma
// decode.
//
// Keep this enabled initially to preserve the original treatment of the
// vertex colour while avoiding a second decode of the texture.
//
// Set to 0 if the result remains too dark and the vertex colour is already
// intended to be a linear multiplier.
#ifndef MW3_DECODE_VERTEX_COLOR_GAMMA2
#define MW3_DECODE_VERTEX_COLOR_GAMMA2 1
#endif


struct PS_INPUT
{
    float4 color     : COLOR0;
    float4 texcoord0 : TEXCOORD0;
    float4 texcoord1 : TEXCOORD1;
};


float4 main(PS_INPUT input) : COLOR0
{
    float4 sampledColor =
        tex2D(
            colorMapSampler,
            input.texcoord0.xy
        );


    // ========================================================================
    // Texture and vertex-colour modulation
    // ========================================================================

    float3 surfaceColor;

#if MW3_COLOR_MAP_INPUT_IS_LINEAR

    // The upgraded texture already contains linear RGB, so do not square it.
    float3 vertexMultiplier =
        input.color.rgb;

#if MW3_DECODE_VERTEX_COLOR_GAMMA2

    // Preserve the part of the original gamma-2.0 approximation that applied
    // to the vertex colour:
    //
    // Original:
    //
    //   (sampled * vertex)^2
    //
    // Expanded:
    //
    //   sampled^2 * vertex^2
    //
    // Because sampledColor is already linear, only vertex^2 is retained.
    vertexMultiplier *=
        vertexMultiplier;

#endif

    surfaceColor =
        sampledColor.rgb
        * vertexMultiplier;

#else

    // Exact reconstruction of the original shader for a gamma-encoded input.
    float3 modulatedColor =
        sampledColor.rgb
        * input.color.rgb;

    surfaceColor =
        modulatedColor
        * modulatedColor;

#endif


    // Original alpha behavior:
    //
    //   mul r0, texture, vertexColor
    //   mov oC0.w, r0.w
    float outputAlpha =
        sampledColor.a
        * input.color.a;


    // ========================================================================
    // Lighting
    // ========================================================================

    // Original assembly:
    //
    //   mov r1.xyz, v2
    //   mad r1.xyz, v1.w, c18, r1
    //
    // lighting = texcoord1.xyz + texcoord0.w * lightDiffuse
    float3 lighting =
        input.texcoord1.xyz
        + input.texcoord0.w
        * lightDiffuse.rgb;


    float3 litColor =
        surfaceColor
        * lighting;


    // ========================================================================
    // Fog
    // ========================================================================

    // Original assembly:
    //
    //   mad r0.xyz, r0, r1, -fogColor
    //   mad oC0.xyz, v2.w, r0, fogColor
    //
    // Equivalent to:
    //
    //   lerp(fogColor, litColor, texcoord1.w)
    //
    // The fog factor is intentionally not saturated because the original
    // shader did not clamp it.
    float3 outputColor =
        lerp(
            fogColorLinear.rgb,
            litColor,
            input.texcoord1.w
        );


    // The original UNORM target discarded negative values automatically.
    // FP16 preserves them, so restore only the original lower bound.
    //
    // Do not clamp the upper bound: HDR values above 1.0 remain available.
    outputColor =
        max(
            outputColor,
            0.0f
        );


    // Alpha was also previously stored in a UNORM target.
    outputAlpha =
        saturate(outputAlpha);


    // No gamma encoding.
    // No sRGB encoding.
    // No sqrt operation.
    return float4(
        outputColor,
        outputAlpha
    );
}