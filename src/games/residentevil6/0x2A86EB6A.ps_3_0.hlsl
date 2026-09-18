float4 CBHDRFactor__packed0   : register(c1);
float4 CBBloomFilter__packed0 : register(c2);

sampler2D SSPoint__tBaseMap : register(s0);

struct PS_IN
{
    float2 texcoord : TEXCOORD0;
};

float3 SRGBToLinear(float3 c)
{
    float3 lo = c / 12.92;
    float3 hi = pow((c + 0.055) / 1.055, 2.4);

    return float3(
        c.r <= 0.03928 ? lo.r : hi.r,
        c.g <= 0.03928 ? lo.g : hi.g,
        c.b <= 0.03928 ? lo.b : hi.b
    );
}

float4 main(PS_IN i) : COLOR
{
    float4 base = tex2D(SSPoint__tBaseMap, i.texcoord);

    // Original shader appears to decode from sRGB/SDR.
    // Keep this if the input texture is SDR/sRGB.
    float3 color = SRGBToLinear(base.rgb);

    // Original shader divides by alpha.
    // Keep this because the assembly does rcp r0.w and multiplies RGB by it.
    color *= rcp(max(base.a, 1e-6));

    // Original HDR factor multiplies.
    color *= CBHDRFactor__packed0.w;
    color *= CBHDRFactor__packed0.z;

    // Bloom threshold.
    // c2.w is the original threshold used by the shader.
    float threshold = CBBloomFilter__packed0.w;

    float peak = max(color.r, max(color.g, color.b));

    // HDR-safe bloom mask.
    // This keeps HDR energy instead of normalizing the color back toward 1.0.
    float bloomMask = max(peak - threshold, 0.0) / max(peak, 1e-6);

    float3 bloom = color * bloomMask;

    // IMPORTANT:
    // Do NOT convert back to sRGB here.
    // Keep output linear HDR.
    return float4(bloom, 1.0);
}