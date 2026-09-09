// Call of Duty: Modern Warfare 3
// Shader hash: 0x95D04DFA
// HDR/NaN-safe replacement for the original glow apply shader.
//
// Original:
//     sample = tex2D(colorMapSampler, uv)
//     output.rgb = sample.rgb * glowApply.w
//     output.a   = sample.a
//
// Fix:
// - NaN -> 0
// - Inf / overflow -> finite FP16 range
// - Preserve HDR RGB above 1.0
// - Preserve original signed finite values
// - Preserve original alpha behavior, with NaN protection

sampler2D colorMapSampler : register(s0);
float4 glowApply : register(c3);

struct PixelInput
{
    float2 texCoord : TEXCOORD0;
};

float SafeFinite1(float value)
{
    if (value != value)
        return 0.0f;

    return clamp(value, -65504.0f, 65504.0f);
}

float3 SafeFinite3(float3 value)
{
    return float3(
        SafeFinite1(value.r),
        SafeFinite1(value.g),
        SafeFinite1(value.b)
    );
}

float4 main(PixelInput input) : COLOR0
{
    float4 sampled = tex2D(
        colorMapSampler,
        input.texCoord
    );

    float3 sourceRGB = SafeFinite3(sampled.rgb);
    float glowWeight = SafeFinite1(glowApply.w);

    float3 outputRGB = SafeFinite3(
        sourceRGB * glowWeight
    );

    float outputAlpha = SafeFinite1(sampled.a);

    // No saturate():
    // HDR values above 1.0 remain available to later passes.
    return float4(
        outputRGB,
        outputAlpha
    );
}
