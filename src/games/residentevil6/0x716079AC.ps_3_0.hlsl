// Converted from ps_3_0 disassembly.
// Bloom is reduced with a two-path blend:
//   1. Low-passed / softened bloom luma
//   2. Full bloom chroma/hue
// Then recombined in a YUV-like color space to keep bloom hue without harsh intensity.

float4x4 fColorCorrectMatrix : register(c1);

float4 fTVNoisePower    : register(c5);
float2 fTVNoiseUVOffset : register(c6);
float4 fTVNoiseScanline : register(c7);
float4 fTVNoiseHVSync   : register(c8);

float4 CBBloomFilter__packed0 : register(c9);
float4 fColorCorrectColor     : register(c10);
float3 fColorCorrectGamma     : register(c11);

sampler2D SSFilter__tBaseMap           : register(s0);
sampler2D SSWrapPoint__tTVNoiseMap     : register(s1);
sampler2D SSWrapPoint__tTVNoiseMaskMap : register(s2);
sampler2D SSLinear__tFilterTempMap2    : register(s3);

struct PS_IN
{
    float2 texcoord  : TEXCOORD0;
    float2 texcoord1 : TEXCOORD1;
};

// -------------------------
// Tuning
// -------------------------

// Main bloom strength after reconstruction.
// Lower = less severe bloom.
// Try 0.20 - 0.45.
#define BLOOM_STRENGTH 0.32

// How much hue/chroma from the full bloom sample is kept.
// 0.0 = grey bloom, 1.0 = full bloom hue.
// Try 0.50 - 0.90.
#define BLOOM_HUE_STRENGTH 0.70

// Compresses bright bloom before adding it.
// Higher = softer, less peak-heavy bloom.
// Try 0.80 - 2.00.
#define BLOOM_SOFT_KNEE 1.25

// Extra safety so reconstructed bloom chroma does not explode.
#define BLOOM_CHROMA_LIMIT 0.35

// -------------------------
// Color helpers
// -------------------------

float3 SRGBToLinear(float3 c)
{
    // Matches the original shader's sRGB decode constants closely.
    float3 lo = c * 0.0773993805;
    float3 hi = pow((c + 0.0549999997) * 0.947867274, 2.4000001);

    return float3(
        (c.x < 0.0392800011) ? lo.x : hi.x,
        (c.y < 0.0392800011) ? lo.y : hi.y,
        (c.z < 0.0392800011) ? lo.z : hi.z
    );
}

float3 LinearToSRGB(float3 c)
{
    c = max(c, 0.0);

    float3 lo = c * 12.9200001;
    float3 hi = 1.05499995 * pow(c, 0.416666657) - 0.0549999997;

    return float3(
        (c.x < 0.00313100009) ? lo.x : hi.x,
        (c.y < 0.00313100009) ? lo.y : hi.y,
        (c.z < 0.00313100009) ? lo.z : hi.z
    );
}

float3 ApplyGammaHDRSafe(float3 c, float3 gamma)
{
    c = max(c, 0.0);

    return float3(
        exp(log(max(c.x, 1e-6)) * gamma.x),
        exp(log(max(c.y, 1e-6)) * gamma.y),
        exp(log(max(c.z, 1e-6)) * gamma.z)
    );
}

// Original shader uses a YUV-style TV noise path.
// This keeps the bloom hue reconstruction in a similar color space.
float3 RGBToYUV(float3 rgb)
{
    float y = dot(rgb, float3(0.299, 0.587, 0.114));
    float u = 0.500 * rgb.b - 0.169 * rgb.r - 0.331 * rgb.g;
    float v = 0.500 * rgb.r - 0.419 * rgb.g - 0.081 * rgb.b;

    return float3(y, u, v);
}

float3 YUVToRGB(float3 yuv)
{
    float y = yuv.x;
    float u = yuv.y;
    float v = yuv.z;

    return float3(
        y + 1.402 * v,
        y - 0.344 * u - 0.714 * v,
        y + 1.772 * u
    );
}

float3 RebuildSoftBloomWithFullHue(float3 bloomLinear)
{
    bloomLinear = max(bloomLinear, 0.0);

    float3 bloomYUV = RGBToYUV(bloomLinear);

    // Low-passed bloom path:
    // Use luma only, then soft-compress it so bloom does not hit as hard.
    float lowLuma = bloomYUV.x;
    lowLuma = lowLuma / (1.0 + lowLuma * BLOOM_SOFT_KNEE);

    // Full normal path:
    // Take hue/chroma from the original full bloom sample.
    float2 fullChroma = bloomYUV.yz;

    // Prevent extreme hue/chroma from corrupting colors.
    fullChroma = clamp(fullChroma, -BLOOM_CHROMA_LIMIT, BLOOM_CHROMA_LIMIT);

    float3 rebuiltYUV;
    rebuiltYUV.x  = lowLuma;
    rebuiltYUV.yz = fullChroma * BLOOM_HUE_STRENGTH;

    return max(YUVToRGB(rebuiltYUV), 0.0);
}

float4 main(PS_IN i) : COLOR
{
    // -------------------------
    // TV noise setup
    // -------------------------

    float4 noiseUV;
    noiseUV.xy = i.texcoord1.xy * fTVNoisePower.zw + fTVNoiseUVOffset.xy;
    noiseUV.zw = i.texcoord1.xy * fTVNoisePower.zw + fTVNoiseUVOffset.xy;

    float4 noiseA = tex2D(SSWrapPoint__tTVNoiseMap, noiseUV.xy);
    float4 noiseB = tex2D(SSWrapPoint__tTVNoiseMap, noiseUV.zw);

    float3 noise;
    noise.x = noiseB.y - 0.5;
    noise.y = noiseB.z - 0.5;
    noise.z = noiseA.x - 0.5;

    noise *= 1.0 + fTVNoiseHVSync.z;

    // -------------------------
    // Base sample, sRGB -> linear
    // -------------------------

    float3 baseSRGB   = tex2D(SSFilter__tBaseMap, i.texcoord).rgb;
    float3 baseLinear = SRGBToLinear(baseSRGB);

    // -------------------------
    // Original YUV TV noise path
    // -------------------------

    float3 yuv = RGBToYUV(baseLinear);

    yuv.x += fTVNoisePower.x * noise.z;
    yuv.y += fTVNoisePower.y * noise.x;
    yuv.z += fTVNoisePower.y * noise.y;

    float3 colorLinear = YUVToRGB(yuv);

    // -------------------------
    // Scanline mask
    // -------------------------

    float scanMask = tex2D(
        SSWrapPoint__tTVNoiseMaskMap,
        i.texcoord1.xy * fTVNoiseScanline.z
    ).x;

    float scanlineAmount = 1.0 - ((1.0 - scanMask) * fTVNoiseScanline.y);
    colorLinear *= scanlineAmount;

    // -------------------------
    // Bloom sample, softened luma + full hue
    // -------------------------

    float3 bloomSRGB   = tex2D(SSLinear__tFilterTempMap2, i.texcoord).rgb;
    float3 bloomLinear = SRGBToLinear(bloomSRGB);

    float3 softBloom = RebuildSoftBloomWithFullHue(bloomLinear);

    // Preserve the game's RGB bloom weighting, but reduce severity.
    colorLinear += softBloom * CBBloomFilter__packed0.rgb * BLOOM_STRENGTH;

    // -------------------------
    // Color correction matrix
    // -------------------------

    float3 matrixColor = mul(float4(colorLinear, 1.0), fColorCorrectMatrix).rgb;

    // Original lrp:
    // lrp r2.xyz, c10.w, matrixColor, colorLinear
    colorLinear = lerp(colorLinear, matrixColor, fColorCorrectColor.w);

    // -------------------------
    // Gamma + linear -> sRGB
    // -------------------------

    colorLinear = ApplyGammaHDRSafe(colorLinear, fColorCorrectGamma);

    float3 finalSRGB = LinearToSRGB(colorLinear);

    return float4(finalSRGB, 1.0);
}