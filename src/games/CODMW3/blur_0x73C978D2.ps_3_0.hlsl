// Call of Duty: Modern Warfare 3
// Shader hash: 0x73C978D2
// HDR/NaN-safe reconstruction of the original 16-tap ps_3_0 blur.
//
// Fix:
// - Preserve the exact 16 texture taps and filterTap[].w weighting.
// - Replace NaN texture values with 0.
// - Bound infinities/overflow to the finite FP16 range.
// - Do NOT clamp HDR RGB to 1.0.
// - Re-sanitize the accumulator after each weighted pair so a single bad
//   highlight cannot poison the remainder of the blur.
//
// Original resources:
//   colorMapSampler : s0
//   filterTap[8]    : c12-c19

sampler2D colorMapSampler : register(s0);
float4 filterTap[8] : register(c12);

struct PixelInput
{
    float4 texCoord0 : TEXCOORD0;
    float4 texCoord1 : TEXCOORD1;
    float4 texCoord2 : TEXCOORD2;
    float4 texCoord3 : TEXCOORD3;
    float4 texCoord4 : TEXCOORD4;
    float4 texCoord5 : TEXCOORD5;
    float4 texCoord6 : TEXCOORD6;
    float4 texCoord7 : TEXCOORD7;
};

float SafeFinite1(float value)
{
    // NaN is the only floating-point value for which value != value.
    value = (value == value) ? value : 0.0f;

    // Keep HDR, but prevent infinities / values outside the useful FP16 range
    // from contaminating later arithmetic.
    return clamp(value, -65504.0f, 65504.0f);
}

float4 SafeFinite4(float4 value)
{
    return float4(
        SafeFinite1(value.r),
        SafeFinite1(value.g),
        SafeFinite1(value.b),
        SafeFinite1(value.a)
    );
}

float SafeWeight(float value)
{
    // Preserve the original signed weight semantics; only reject NaN/Inf.
    return SafeFinite1(value);
}

float4 SamplePair(float4 tc)
{
    float4 a = SafeFinite4(tex2D(colorMapSampler, tc.xy));
    float4 b = SafeFinite4(tex2D(colorMapSampler, tc.zw));

    return SafeFinite4(a + b);
}

float4 main(PixelInput input) : COLOR0
{
    // Preserve the exact original accumulation order:
    //
    // pair 1 uses TEXCOORD1 + c13.w
    // pair 0 uses TEXCOORD0 + c12.w
    // then TEXCOORD2..7 + c14.w..c19.w.

    float4 result =
        SamplePair(input.texCoord1)
        * SafeWeight(filterTap[1].w);

    result = SafeFinite4(
        result
        + SamplePair(input.texCoord0) * SafeWeight(filterTap[0].w)
    );

    result = SafeFinite4(
        result
        + SamplePair(input.texCoord2) * SafeWeight(filterTap[2].w)
    );

    result = SafeFinite4(
        result
        + SamplePair(input.texCoord3) * SafeWeight(filterTap[3].w)
    );

    result = SafeFinite4(
        result
        + SamplePair(input.texCoord4) * SafeWeight(filterTap[4].w)
    );

    result = SafeFinite4(
        result
        + SamplePair(input.texCoord5) * SafeWeight(filterTap[5].w)
    );

    result = SafeFinite4(
        result
        + SamplePair(input.texCoord6) * SafeWeight(filterTap[6].w)
    );

    result = SafeFinite4(
        result
        + SamplePair(input.texCoord7) * SafeWeight(filterTap[7].w)
    );

    // No saturate() here:
    // HDR RGB > 1.0 remains valid and can continue through the upgraded path.
    return SafeFinite4(result);
}
