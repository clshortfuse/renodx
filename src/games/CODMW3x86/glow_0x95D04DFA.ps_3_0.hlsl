#include "./bloom_legacy_safe.hlsl"

// WaW-style bounded source for MW3's legacy glow composite.
// The scene destination and output shaders retain their HDR range.
sampler2D colorMapSampler : register(s0);
float4 glowApply : register(c3);

struct PixelInput {
    float2 texCoord : TEXCOORD0;
};

float4 main(PixelInput input) : COLOR0 {
    float4 sampled = tex2D(colorMapSampler, input.texCoord);
    float3 bloom = MW3BloomStrength(sampled.rgb, glowApply.w);
    return float4(bloom, saturate(MW3BloomFinite(sampled.a)));
}
