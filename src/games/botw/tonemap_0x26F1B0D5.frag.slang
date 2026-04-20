#version 450
#include "./shared.h"

layout(set = 1, binding = 2, std140) uniform ufBlock
{
    int4 uf_remappedPS[1];
    float4 uf_fragCoordScale;
} _409;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler2D textureUnitPS1;

layout(location = 0) in float4 passParameterSem0;
layout(location = 0) out float4 passPixelColor0;

float ComputeBotwSaturationGrade(float3 color, float grade_bias, float grade_scale)
{
    float triangle = dot(color, float3(0.6666667)) - 1.0;
    return (1.0 - triangle * triangle) * grade_scale + grade_bias;
}

float3 ApplyBotwSaturationGrade(float3 color, float grade)
{
    float peak_channel = renodx::math::Max(color);
    if (peak_channel <= 0.0) return float3(0.0);

    return peak_channel + (color - peak_channel.xxx) * grade;
}

float3 ComputeVanillaBlendedSdr(float3 untonemapped)
{
    float luminance = dot(untonemapped, float3(0.2989030703f, 0.5866198547f, 0.1144770751f));
    float luminance_curve = 1.0 - exp(-luminance);
    float blend_weight = pow(luminance_curve, 2.0);
    float luminance_scale = renodx::math::DivideSafe(luminance_curve, luminance, 0.0);

    float3 luminance_scaled = untonemapped * luminance_scale;
    float3 per_channel_curve = 1.0 - exp(-untonemapped);
    return saturate(lerp(luminance_scaled, per_channel_curve, blend_weight));
}

void main()
{
    float2 uv = passParameterSem0.xy;
    float alpha = passParameterSem0.w;
    float3 glow = texture(textureUnitPS0, uv).xyz;
    float3 raw = texture(textureUnitPS1, uv).xyz;
    float3 untonemapped = glow + raw;
    float3 vanilla_blended_sdr = ComputeVanillaBlendedSdr(untonemapped);

    float saturation_grade_bias = intBitsToFloat(_409.uf_remappedPS[0].x);
    float saturation_grade_scale = intBitsToFloat(_409.uf_remappedPS[0].y)* VANILLA_SATURATION;
    float vanilla_saturation_grade = ComputeBotwSaturationGrade(
        vanilla_blended_sdr,
        saturation_grade_bias,
        saturation_grade_scale);
    float3 tonemapped = ApplyBotwSaturationGrade(
        vanilla_blended_sdr,
        vanilla_saturation_grade);
    float3 output = tonemapped;
    if (RENODX_TONE_MAP_TYPE != 0.f)
    {
        float3 neutral_hdr = renodx::draw::ComputeUntonemappedGraded(untonemapped, vanilla_blended_sdr);
        output = ApplyBotwSaturationGrade(neutral_hdr, vanilla_saturation_grade);
    }
    output = (CUSTOM_TONEMAP_CLAMP == 1.f)
        ? renodx::color::bt709::clamp::AP1(output)
        : renodx::color::bt709::clamp::BT709(output);
    output = renodx::draw::ToneMapPass(output);

    passPixelColor0 = float4(renodx::draw::RenderIntermediatePass(output), alpha);
}