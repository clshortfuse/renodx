// Reconstructed equivalent of the original ps_3_0 shader 0x646BE87B.
// This replacement is intentionally visually neutral: it preserves the game's
// original 25% luminance desaturation behavior. Its presence also gives RenoDX
// a normal custom-shader entry so addon.cpp can attach the shader-scoped
// readback-tag callback without adding global per-draw shader scanning.

sampler2D colorMapSampler : register(s0);

struct PixelInput
{
    float4 color    : COLOR0;
    float2 texCoord : TEXCOORD0;
};

float4 main(PixelInput input) : COLOR0
{
    float3 sampledColor = tex2D(colorMapSampler, input.texCoord).rgb;
    float3 modulated = sampledColor * input.color.rgb;

    float luminance = dot(
        modulated,
        float3(0.298999995f, 0.587000012f, 0.114f));

    float3 result = lerp(modulated, luminance.xxx, 0.25f);

    return float4(result, input.color.a);
}
