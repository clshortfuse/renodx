// Reconstructed HDR-safe / unclamped version of the TV noise + bloom + LUT shader.
// ps_3_0 style replacement.

sampler2D SSFilter__tBaseMap             : register(s0);
sampler2D SSWrapPoint__tTVNoiseMap       : register(s1);
sampler2D SSWrapPoint__tTVNoiseMaskMap   : register(s2);
sampler2D SSLinear__tFilterTempMap2      : register(s3);
sampler2D SSPoint__tColorCorrectTableMap : register(s4);

float4x4 fColorCorrectMatrix : register(c1);

float4 fTVNoisePower    : register(c5);
float4 fTVNoiseUVOffset : register(c6);
float4 fTVNoiseScanline : register(c7);
float4 fTVNoiseHVSync   : register(c8);

float4 CBBloomFilter__packed0 : register(c9);
float4 fColorCorrectColor     : register(c10);

float3 SRGBToLinear_Unclamped(float3 color)
{
    // Avoid NaNs from pow() if an upgraded float target ever gives tiny negatives.
    color = max(color, 0.0f);

    float3 low  = color / 12.92f;
    float3 high = pow((color + 0.055f) / 1.055f, 2.4f);

    return lerp(high, low, color <= 0.03928f);
}

float3 LinearToSRGB_Unclamped(float3 color)
{
    // Do not saturate upper range. Only protect pow() from negatives.
    color = max(color, 0.0f);

    float3 low  = color * 12.92f;
    float3 high = 1.055f * pow(color, 1.0f / 2.4f) - 0.055f;

    return lerp(high, low, color <= 0.003131f);
}

float3 RGBToYCbCr_WithNoise(float3 rgb, float3 noise)
{
    float y  = dot(rgb, float3(0.299f, 0.587f, 0.114f));
    float cb = dot(rgb.zxy, float3(0.5f, -0.169f, -0.331f));
    float cr = dot(rgb, float3(0.5f, -0.419f, -0.081f));

    y  += fTVNoisePower.x * noise.z;
    cb += fTVNoisePower.y * noise.x;
    cr += fTVNoisePower.y * noise.y;

    return float3(y, cb, cr);
}

float3 YCbCrToRGB(float3 ycbcr)
{
    float y  = ycbcr.x;
    float cb = ycbcr.y;
    float cr = ycbcr.z;

    float r = y + 1.402f * cr;
    float g = y - 0.344f * cb - 0.714f * cr;
    float b = y + 1.772f * cb;

    return float3(r, g, b);
}

float3 ApplyColorCorrectMatrix(float3 color)
{
    // Matches the assembly:
    // r1 = color.y * c2
    // r1 = color.x * c1 + r1
    // r1 = color.z * c3 + r1
    // r1 = r1 + c4

    return
        color.r * fColorCorrectMatrix[0].xyz +
        color.g * fColorCorrectMatrix[1].xyz +
        color.b * fColorCorrectMatrix[2].xyz +
                  fColorCorrectMatrix[3].xyz;
}

float3 SampleColorCorrectLUT(float3 coord)
{
    // LUT itself must stay SDR-range.
    coord = saturate(coord);

    float4 rSample = tex2D(SSPoint__tColorCorrectTableMap, coord.xx);
    float4 gSample = tex2D(SSPoint__tColorCorrectTableMap, coord.yy);
    float4 bSample = tex2D(SSPoint__tColorCorrectTableMap, coord.zz);

    float3 lutSRGB;
    lutSRGB.r = rSample.r;
    lutSRGB.g = gSample.g;
    lutSRGB.b = bSample.b;

    return SRGBToLinear_Unclamped(lutSRGB);
}

float3 ApplyLUT_HDRSafe(float3 color)
{
    float3 lutCoordHDR = ApplyColorCorrectMatrix(color);

    // Clamp only the sample position, not the HDR color path.
    float3 lutCoordSDR = saturate(lutCoordHDR);

    float3 lutResultSDR = SampleColorCorrectLUT(lutCoordSDR);

    // Preserve HDR by applying the SDR LUT's color difference to HDR.
    float3 lutDelta = lutResultSDR - lutCoordSDR;
    float3 lutResultHDR = lutCoordHDR + lutDelta;

    return lerp(color, lutResultHDR, fColorCorrectColor.w);
}

float4 main(
    float2 texcoord : TEXCOORD0,
    float2 noiseUV  : TEXCOORD1
) : COLOR0
{
    // TV noise UVs.
    float4 noiseCoords = noiseUV.xyxy * fTVNoisePower.zwzw + fTVNoiseUVOffset.xyxy;

    float4 noiseSampleA = tex2D(SSWrapPoint__tTVNoiseMap, noiseCoords.xy);
    float4 noiseSampleB = tex2D(SSWrapPoint__tTVNoiseMap, noiseCoords.zw);

    float3 tvNoise;
    tvNoise.x = noiseSampleB.y - 0.5f;
    tvNoise.y = noiseSampleB.z - 0.5f;
    tvNoise.z = noiseSampleA.x - 0.5f;

    tvNoise *= 1.0f + fTVNoiseHVSync.z;

    // Base scene.
    float4 baseSample = tex2D(SSFilter__tBaseMap, texcoord);
    float3 baseLinear = SRGBToLinear_Unclamped(baseSample.rgb);

    // Apply TV noise in YCbCr space.
    float3 ycbcr = RGBToYCbCr_WithNoise(baseLinear, tvNoise);
    float3 noisyRGB = YCbCrToRGB(ycbcr);

    // Scanline mask.
    float2 scanlineUV = noiseUV * fTVNoiseScanline.z;
    float scanlineMask = tex2D(SSWrapPoint__tTVNoiseMaskMap, scanlineUV).x;

    float scanlinePower = 1.0f - ((1.0f - scanlineMask) * fTVNoiseScanline.y);
    noisyRGB *= scanlinePower;

    // Bloom / filter temp.
    float4 bloomSample = tex2D(SSLinear__tFilterTempMap2, texcoord);
    float3 bloomLinear = SRGBToLinear_Unclamped(bloomSample.rgb);

    // Keep bloom unclamped.
    float3 combined = noisyRGB + bloomLinear * CBBloomFilter__packed0.rgb;

    // Optional safety: prevent negative color from going into LUT delta / encode.
    combined = max(combined, 0.0f);

    // HDR-safe LUT/color correction.
    float3 gradedLinear = ApplyLUT_HDRSafe(combined);

    // Final encode. No saturate here.
    float3 finalColor = LinearToSRGB_Unclamped(gradedLinear);

    return float4(finalColor, 1.0f);
}