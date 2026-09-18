// Call of Duty: World at War - D3D9 HDR clone -> SDR readback shader
// ps_3_0
//
// This intentionally mirrors the addon's old CPU readback behavior:
//   - NaN / non-finite FP16-style values become 0
//   - linear RGB is clamped to 0..1
//   - RGB is encoded to sRGB
//   - alpha is clamped to 0..1
//
// The actual HDR render target remains FP16/unclamped. Only the representation
// handed back to the game's legacy readback path is converted to SDR.

sampler2D hdrSourceSampler : register(s0);

float SafeUnit(float inputValue)
{
    // NaN fails equality with itself.
    if (inputValue != inputValue)
    {
        return 0.0f;
    }

    // Reject values outside finite FP16 range (including +/-INF).
    if (abs(inputValue) > 65504.0f)
    {
        return 0.0f;
    }

    return saturate(inputValue);
}

float LinearToSRGB(float inputValue)
{
    float safeValue = SafeUnit(inputValue);

    if (safeValue <= 0.0031308f)
    {
        return 12.92f * safeValue;
    }

    return 1.055f * pow(safeValue, 1.0f / 2.4f) - 0.055f;
}

float4 main(float2 texCoord : TEXCOORD0) : COLOR0
{
    float4 color = tex2D(hdrSourceSampler, texCoord);

    float red   = LinearToSRGB(color.r);
    float green = LinearToSRGB(color.g);
    float blue  = LinearToSRGB(color.b);
    float alpha = SafeUnit(color.a);

    return float4(red, green, blue, alpha);
}
