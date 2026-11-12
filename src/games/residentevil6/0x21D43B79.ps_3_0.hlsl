#include "./shared.h"

sampler2D SSPoint__tBaseMap : register(s0);
float4 CBHDRFactor__packed0 : register(c1);

// Input is normally gamma/sRGB.
#ifndef RENODX_HDR_FACTOR_INPUT_IS_SRGB
#define RENODX_HDR_FACTOR_INPUT_IS_SRGB 1
#endif

// Output is normally gamma/sRGB for the next pass.
// This uses extended sRGB, so values above 1.0 survive on float targets.
#ifndef RENODX_HDR_FACTOR_OUTPUT_SRGB
#define RENODX_HDR_FACTOR_OUTPUT_SRGB 1
#endif

// Keep alpha SDR/clamped by default.
// Important if alpha is used as luma for FXAA/edge detection/exposure.
#ifndef RENODX_HDR_FACTOR_ALPHA_SDR_LUMA
#define RENODX_HDR_FACTOR_ALPHA_SDR_LUMA 1
#endif

#define RENODX_EPSILON 0.00001f

float3 SafePositive(float3 c)
{
    // Remove negatives only.
    // Do not clamp positive HDR values.
    return max(c, 0.0f);
}

float SRGBToLinear1_NoSaturate(float c)
{
    c = max(c, 0.0f);

    float lo = c * 0.07739938f;
    float hi = pow(max((c + 0.055f) * 0.9478673f, 0.0f), 2.4f);

    return (c <= 0.03928f) ? lo : hi;
}

float3 SRGBToLinear3_NoSaturate(float3 c)
{
    return float3(
        SRGBToLinear1_NoSaturate(c.r),
        SRGBToLinear1_NoSaturate(c.g),
        SRGBToLinear1_NoSaturate(c.b)
    );
}

float LinearToSRGB1_NoSaturate(float c)
{
    c = max(c, 0.0f);

    float lo = c * 12.92f;
    float hi = pow(c, 0.416666657f) * 1.055f - 0.055f;

    return (c <= 0.003131f) ? lo : hi;
}

float3 LinearToSRGB3_NoSaturate(float3 c)
{
    return float3(
        LinearToSRGB1_NoSaturate(c.r),
        LinearToSRGB1_NoSaturate(c.g),
        LinearToSRGB1_NoSaturate(c.b)
    );
}

float GetLumaSDR(float3 c)
{
    return dot(c, float3(0.299f, 0.587f, 0.114f));
}

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    float4 color = tex2D(SSPoint__tBaseMap, texcoord);

    float3 linear_color = SafePositive(color.rgb);

#if RENODX_HDR_FACTOR_INPUT_IS_SRGB
    // Match original shader behavior, but do not saturate.
    linear_color = SRGBToLinear3_NoSaturate(linear_color);
#endif

    // Original shader:
    // linear_color *= CBHDRFactor__packed0.y;
    // linear_color = saturate(linear_color * CBHDRFactor__packed0.z);
    //
    // HDR-safe version:
    // keep the same multipliers, but remove the saturate.
    float hdr_scale =
        CBHDRFactor__packed0.y *
        CBHDRFactor__packed0.z;

    float3 hdr_color = SafePositive(linear_color * hdr_scale);

    float4 output_color;

#if RENODX_HDR_FACTOR_OUTPUT_SRGB
    // Extended sRGB encode.
    // Do not saturate; float targets can carry values above 1.0.
    output_color.rgb = LinearToSRGB3_NoSaturate(hdr_color);
#else
    // Linear HDR output path.
    output_color.rgb = hdr_color;
#endif

#if RENODX_HDR_FACTOR_ALPHA_SDR_LUMA
    // Keep alpha stable/SDR for passes that use alpha as luma.
    // This is important for FXAA-like shaders and can reduce flicker.
    float3 alpha_color = saturate(hdr_color);
    output_color.a = GetLumaSDR(alpha_color);
#else
    // HDR alpha/luma, only use if you know the next pass expects HDR luma.
    output_color.a = GetLumaSDR(hdr_color);
#endif

    return output_color;
}