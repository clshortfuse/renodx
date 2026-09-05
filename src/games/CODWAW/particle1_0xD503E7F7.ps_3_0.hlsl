//
// HDR / NaN-safe reconstruction
//

sampler2D colorMapSampler : register(s0);
sampler2D floatZSampler   : register(s4);

float4 featherParms : register(c5);

struct PixelInput
{
    float4 color      : COLOR0;
    float3 texCoord   : TEXCOORD0;
    float4 depthCoord : TEXCOORD1;
};


// ============================================================================
// NaN-safe scalar
// ============================================================================

float Sanitize01(float value)
{
    // Explicitly remove NaN BEFORE saturate.
    value =
        (value == value)
        ? value
        : 0.0f;

    return saturate(value);
}


float3 Sanitize01(float3 color)
{
    return float3(
        Sanitize01(color.r),
        Sanitize01(color.g),
        Sanitize01(color.b)
    );
}


float4 Sanitize01(float4 color)
{
    return float4(
        Sanitize01(color.r),
        Sanitize01(color.g),
        Sanitize01(color.b),
        Sanitize01(color.a)
    );
}


// ============================================================================
// Main
// ============================================================================

float4 main(PixelInput input) : COLOR0
{
    // ------------------------------------------------------------------------
    // Depth sample
    // ------------------------------------------------------------------------

    float depth =
        tex2Dproj(
            floatZSampler,
            input.depthCoord
        ).x;


    // Depth itself may potentially be invalid.
    depth =
        (depth == depth)
        ? depth
        : 0.0f;


    // Original:
    //
    // add r0.w, r0_abs.x, -v1.z

    float depthDifference =
        abs(depth)
        - input.texCoord.z;


    depthDifference =
        (depthDifference == depthDifference)
        ? depthDifference
        : 0.0f;


    // Original:
    //
    // mul_sat_pp r1.w, r0.w, c5.x

    float feather =
        depthDifference
        * featherParms.x;


    feather =
        Sanitize01(
            feather
        );


    // ------------------------------------------------------------------------
    // Bloom/color sample
    // ------------------------------------------------------------------------

    float4 sampledColor =
        tex2D(
            colorMapSampler,
            input.texCoord.xy
        );


    // IMPORTANT:
    //
    // First remove NaNs.
    //
    // THEN clamp the unsafe bloom buffer to 0..1.
    //
    // Doing only saturate(sampledColor) may not fix a value that has already
    // become NaN upstream.

    sampledColor =
        Sanitize01(
            sampledColor
        );


    // Vertex color is also part of the multiplication chain.
    float4 vertexColor =
        Sanitize01(
            input.color
        );


    // Original:
    //
    // mul_pp r0, r0, v0

    float4 color =
        sampledColor
        * vertexColor;


    // Sanitize AGAIN after multiplication.
    color =
        Sanitize01(
            color
        );


    // ------------------------------------------------------------------------
    // Alpha feather
    // ------------------------------------------------------------------------

    // Original:
    //
    // mul_pp r0.w, r1.w, r0.w

    float finalAlpha =
        feather
        * color.a;


    finalAlpha =
        Sanitize01(
            finalAlpha
        );


    // ------------------------------------------------------------------------
    // Final bloom RGB
    // ------------------------------------------------------------------------

    // Original:
    //
    // mul_pp oC0.xyz, r0, r0.w

    float3 outputColor =
        color.rgb
        * finalAlpha;


    // Explicit final NaN repair.
    outputColor =
        Sanitize01(
            outputColor
        );


    return float4(
        outputColor,
        finalAlpha
    );
}