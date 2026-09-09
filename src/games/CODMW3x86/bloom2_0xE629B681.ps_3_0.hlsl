#include "./bloom_legacy_safe.hlsl"

// WaW soft-particle workaround, with MW3's original registers and inputs.
// 2 matches WaW's feather bypass; use 0 to restore MW3's depth feather.
#ifndef FEATHER_MODE
#define FEATHER_MODE 2
#endif

sampler2D colorMapSampler : register(s0);
sampler2D floatZSampler : register(s4);
float4 featherParms : register(c3);

struct PS_INPUT {
    float4 color : COLOR0;
    float3 texcoord : TEXCOORD0;
    float4 depthCoord : TEXCOORD1;
};

float4 main(PS_INPUT input) : COLOR0 {
    float feather = 1.0f;
#if FEATHER_MODE != 2
    float depth = tex2Dproj(floatZSampler, input.depthCoord).x;
    // Preserve MW3's formula, not WaW's different depth formula.
    float difference = abs(depth) * featherParms.x - input.texcoord.z;
#if FEATHER_MODE == 0
    feather = saturate(MW3BloomFinite(abs(difference)));
#else
    feather = saturate(MW3BloomFinite(difference));
#endif
#endif

    float4 sampled = tex2D(colorMapSampler, input.texcoord.xy);
    float3 sampledRGB = MW3BloomNormalize(sampled.rgb);
    float3 vertexRGB = MW3BloomNormalize(input.color.rgb);
    float alpha = saturate(MW3BloomFinite(sampled.a))
                * saturate(MW3BloomFinite(input.color.a)) * feather;
    float3 bloom = MW3BloomNormalize(sampledRGB * vertexRGB * alpha);
    // MW3's Bloom Strength already drives restoration in the output shaders.
    // Do not apply that same slider a second time to this particle pass.
    return float4(bloom, alpha);
}
