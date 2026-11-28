// MW3 DX9 HDR clone -> SDR readback blit pixel shader.
// Mirrors the runtime-compiled shader in addon.cpp.

sampler2D SourceSampler : register(s0);

// x = force opaque alpha
// y = encode linear RGB to sRGB
// z = hue-preserving max-channel HDR highlight compression
float4 ReadbackOptions : register(c0);

float3 LinearToSRGB(float3 linearColor)
{
    linearColor = saturate(linearColor);
    float3 low = linearColor * 12.92;
    float3 exponentValue = float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4);
    float3 high = 1.055 * pow(max(linearColor, 0.0), exponentValue) - 0.055;
    float3 threshold = float3(0.0031308, 0.0031308, 0.0031308);
    float3 useHigh = step(threshold, linearColor);
    return lerp(low, high, useHigh);
}

float4 main(float2 texCoord : TEXCOORD0) : COLOR0
{
    float4 color = tex2D(SourceSampler, texCoord);
    float3 linearRGB = max(color.rgb, 0.0);

    // Preserve hue when HDR values exceed SDR white instead of clipping each
    // channel independently. Values <= 1.0 are untouched.
    float peak = max(linearRGB.r, max(linearRGB.g, linearRGB.b));
    float compressionScale = rcp(max(peak, 1.0));
    float3 compressedRGB = linearRGB * compressionScale;
    linearRGB = lerp(linearRGB, compressedRGB, saturate(ReadbackOptions.z));
    linearRGB = saturate(linearRGB);

    float3 encodedRGB = LinearToSRGB(linearRGB);
    color.rgb = lerp(linearRGB, encodedRGB, saturate(ReadbackOptions.y));
    color.a = lerp(saturate(color.a), 1.0, saturate(ReadbackOptions.x));
    return color;
}
