sampler2D SSPoint__tBaseMap : register(s0);
sampler2D SSPoint__tColorCorrectTableMap : register(s1);

float4x4 fColorCorrectMatrix : register(c1);
float4 fColorCorrectColor : register(c5);

float3 SRGBToLinear(float3 color)
{
    float3 low  = color / 12.92f;
    float3 high = pow((color + 0.055f) / 1.055f, 2.4f);

    return lerp(high, low, color <= 0.03928f);
}

float3 LinearToSRGB_Unclamped(float3 color)
{
    color = max(color, 0.0f);

    float3 low  = color * 12.92f;
    float3 high = 1.055f * pow(color, 1.0f / 2.4f) - 0.055f;

    return lerp(high, low, color <= 0.003131f);
}

float3 SampleColorCorrectLUT(float3 coord)
{
    coord = saturate(coord);

    float4 rSample = tex2D(SSPoint__tColorCorrectTableMap, coord.xx);
    float4 gSample = tex2D(SSPoint__tColorCorrectTableMap, coord.yy);
    float4 bSample = tex2D(SSPoint__tColorCorrectTableMap, coord.zz);

    float3 lutColor;
    lutColor.r = rSample.r;
    lutColor.g = gSample.g;
    lutColor.b = bSample.b;

    return SRGBToLinear(lutColor);
}

float4 main(float2 texcoord : TEXCOORD0) : COLOR0
{
    float4 baseSample = tex2D(SSPoint__tBaseMap, texcoord);

    float3 baseLinear = SRGBToLinear(baseSample.rgb);

    // Same as the original matrix path used to build LUT coordinates.
    float3 lutCoordHDR =
        baseLinear.r * fColorCorrectMatrix[0].xyz +
        baseLinear.g * fColorCorrectMatrix[1].xyz +
        baseLinear.b * fColorCorrectMatrix[2].xyz +
        fColorCorrectMatrix[3].xyz;

    // SDR-safe coordinate for the actual LUT sample.
    float3 lutCoordSDR = saturate(lutCoordHDR);

    float3 lutResultSDR = SampleColorCorrectLUT(lutCoordSDR);

    // Apply only the LUT's color/grading difference back onto HDR.
    // This keeps values above 1.0 alive instead of flattening them into the LUT.
    float3 lutDelta = lutResultSDR - lutCoordSDR;

    float3 gradedHDR = lutCoordHDR + lutDelta;

    // Original shader blends LUT result with original decoded base color using c5.w.
    float lutStrength = fColorCorrectColor.w;

    float3 finalLinear = lerp(baseLinear, gradedHDR, lutStrength);

    // Do not saturate here if output target is R16G16B16A16_FLOAT / HDR.
    float3 finalSRGB = LinearToSRGB_Unclamped(finalLinear);

    return float4(finalSRGB, baseSample.a);
}