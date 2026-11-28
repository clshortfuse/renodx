#include "./shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0 : register(s0);

cbuffer cb2 : register(b2)
{
    float4 cb2[14];
};

static const float3 LUMINANCE_WEIGHTS = float3(0.2126f, 0.7152f, 0.0722f);

float4 main(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float2 offset = cb2[13].zw * 0.25f;

    float4 upperLeft  = t0.Sample(s0, uv + float2(-offset.x,  offset.y));
    float4 upperRight = t0.Sample(s0, uv + float2( offset.x,  offset.y));
    float4 lowerLeft  = t0.Sample(s0, uv + float2(-offset.x, -offset.y));
    float4 lowerRight = t0.Sample(s0, uv + float2( offset.x, -offset.y));

    float4 sampleLuminance = float4(
        dot(upperLeft.rgb, LUMINANCE_WEIGHTS),
        dot(upperRight.rgb, LUMINANCE_WEIGHTS),
        dot(lowerLeft.rgb, LUMINANCE_WEIGHTS),
        dot(lowerRight.rgb, LUMINANCE_WEIGHTS));
    float4 sampleWeights = float4(
        upperLeft.a, upperRight.a, lowerLeft.a, lowerRight.a);

    if (RENODX_BLOOM_MODE >= 0.5f)
    {
        // Restore the original per-sample soft-knee luminance threshold.
        // A zero threshold on a black sample should pass through without 0/0.
        float4 denominator = max(sampleWeights * sampleLuminance, -cb2[0].xxxx);
        denominator = (denominator == 0.0f) ? 1.0f.xxxx : denominator;
        sampleWeights *= 1.0f + cb2[0].xxxx / denominator;
    }

    // Energy-conserving mode uses the complete scene without the threshold.
    float3 downsampledColor = 0.25f * (
        upperLeft.rgb * sampleWeights.x
        + upperRight.rgb * sampleWeights.y
        + lowerLeft.rgb * sampleWeights.z
        + lowerRight.rgb * sampleWeights.w);

    // Alpha carries the original, unthresholded average scene luminance used
    // by the exposure reduction chain. Leave it independent of bloom RGB.
    float averageSceneLuminance = dot(sampleLuminance, 0.25f.xxxx);

    float downsampledLuminance = dot(downsampledColor, LUMINANCE_WEIGHTS);
    downsampledColor = lerp(
        downsampledColor,
        downsampledLuminance.xxx,
        cb2[0].z);

    return float4(
        min(downsampledColor, 65504.0f.xxx),
        min(averageSceneLuminance, 65504.0f));
}
