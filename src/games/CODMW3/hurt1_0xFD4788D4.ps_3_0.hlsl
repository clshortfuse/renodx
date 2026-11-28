// HDR/format-upgrade-safe reconstruction of the original ps_3_0 shader.
//
// Original operation:
//
//   mask = saturate(vertexAlpha * 5.0 - maskTexture.r * 4.0);
//   output = colorTexture * mask;
//
// Fixes:
//   1. Clamp the mask texture's red channel to 0.0–1.0 before using it.
//      The original texture was likely UNORM, so values outside that range
//      can make most of the screen disappear after a format upgrade.
//
//   2. Limit final RGB to 1.0 using proportional scaling.
//      This preserves hue better than saturate(outputColor.rgb).
//
//   3. Preserve the original mask and alpha multiplication behavior.

sampler2D colorMapSampler  : register(s0);
sampler2D colorMapSampler1 : register(s4);

struct PS_INPUT
{
    float2 texcoord    : TEXCOORD0;
    float4 vertexColor : COLOR0;
};


// Limits RGB to the 0.0–1.0 range without clipping individual channels.
//
// Example:
//   (2.0, 1.0, 0.5) becomes (1.0, 0.5, 0.25)
//
// A normal per-channel saturate would instead produce:
//   (1.0, 1.0, 0.5)
//
// That per-channel clipping can severely change color and saturation.
float3 ClampRGBPreserveHue(float3 color)
{
    color = max(color, 0.0f);

    float largestChannel = max(
        color.r,
        max(color.g, color.b)
    );

    if (largestChannel > 1.0f)
    {
        color /= largestChannel;
    }

    return color;
}


float4 main(PS_INPUT input) : COLOR0
{
    // Secondary texture used to construct the visibility/coverage mask.
    float maskTextureRed = tex2D(
        colorMapSampler1,
        input.texcoord
    ).r;

    // The original shader likely read this from a UNORM texture.
    // Constrain it before performing the mask calculation.
    maskTextureRed = saturate(maskTextureRed);

    // Original instructions:
    //
    //   mul_pp     r0.x, r0.x, 4
    //   mad_sat_pp r0.x, v1.w, 5, -r0.x
    //
    float mask = saturate(
        input.vertexColor.a * 5.0f
        - maskTextureRed * 4.0f
    );

    // Primary color texture.
    float4 sampledColor = tex2D(
        colorMapSampler,
        input.texcoord
    );

    // Original final multiplication.
    float4 outputColor = sampledColor * mask;

    // Restrict output to SDR 1.0 while preserving RGB ratios.
    outputColor.rgb = ClampRGBPreserveHue(outputColor.rgb);
    outputColor.a   = saturate(outputColor.a);

    return outputColor;
}