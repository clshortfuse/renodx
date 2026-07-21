// FP16-compatible reconstruction of the original ps_3_0 bloom setup shader.
//
// The source and destination may be R16G16B16A16_FLOAT, but the original
// bloom algorithm is evaluated in its original SDR 0.0–1.0 domain.
//
// This prevents HDR values above 1.0 from overwhelming the legacy bloom
// threshold, colour-tint curve, and subsequent blur passes.
//
// No gamma or sRGB conversion is performed.

sampler2D colorMapSampler : register(s0);

float4 glowSetup               : register(c3);
float4 colorTintBase           : register(c5);
float4 colorTintDelta          : register(c6);
float4 colorTintQuadraticDelta : register(c7);
float4 colorBias               : register(c8);


struct PS_INPUT
{
    float2 texcoord0 : TEXCOORD0;
    float2 texcoord1 : TEXCOORD1;
    float2 texcoord2 : TEXCOORD2;
    float2 texcoord3 : TEXCOORD3;
};


static const float3 LUMINANCE_WEIGHTS =
    float3(
        0.298999995f,
        0.587000012f,
        0.114000000f
    );


float3 ProcessBloomTap(float2 texcoord)
{
    float3 sampledColor = tex2D(
        colorMapSampler,
        texcoord
    ).rgb;

    // The original render target was UNORM, so values reaching this bloom
    // calculation were effectively restricted to 0.0–1.0.
    //
    // Preserve that behaviour even though the resource is now FP16.
    float3 bloomInput = saturate(sampledColor);

    float luminance = dot(
        bloomInput,
        LUMINANCE_WEIGHTS
    );

    // Assembly equivalent:
    //
    // mad tintParameters,
    //     colorTintDelta.wxyz,
    //     luminance,
    //     colorTintBase.wxyz
    float4 tintParameters =
        float4(
            colorTintDelta.w,
            colorTintDelta.x,
            colorTintDelta.y,
            colorTintDelta.z
        ) * luminance
        +
        float4(
            colorTintBase.w,
            colorTintBase.x,
            colorTintBase.y,
            colorTintBase.z
        );

    // Assembly:
    //
    // lrp tintedColor.xyz,
    //     tintParameters.x,
    //     luminance,
    //     bloomInput
    float3 luminanceColor = float3(
        luminance,
        luminance,
        luminance
    );

    float3 tintedColor = lerp(
        bloomInput,
        luminanceColor,
        tintParameters.x
    );

    float luminanceSquared = luminance * luminance;

    float3 tintMultiplier =
        tintParameters.yzw
        +
        luminanceSquared
        * colorTintQuadraticDelta.xyz;

    float3 gradedColor =
        tintedColor
        * tintMultiplier
        + colorBias.xyz;

    // Preserve the original add_sat threshold.
    //
    // Luminance is intentionally SDR-limited here. Using raw HDR luminance
    // causes nearly every bright highlight to receive a full bloom mask.
    float bloomMask = saturate(
        luminance - glowSetup.x
    );

    float3 bloomColor =
        gradedColor
        * bloomMask
        * glowSetup.y;

    // UNORM would have removed negative output values.
    // Apply only a lower bound; no positive upper clamp is needed here.
    return max(bloomColor, 0.0f);
}


float4 main(PS_INPUT input) : COLOR0
{
    // Preserve the original tap order.
    float3 bloomSum = 0.0f;

    bloomSum += ProcessBloomTap(input.texcoord1);
    bloomSum += ProcessBloomTap(input.texcoord0);
    bloomSum += ProcessBloomTap(input.texcoord2);
    bloomSum += ProcessBloomTap(input.texcoord3);

    float3 bloomAverage = bloomSum * 0.25f;

    float bloomLuminance = dot(
        bloomAverage,
        LUMINANCE_WEIGHTS
    );

    float3 bloomLuminanceColor = float3(
        bloomLuminance,
        bloomLuminance,
        bloomLuminance
    );

    // Original final desaturation:
    //
    // output = average
    //        + glowSetup.w * (luminance - average)
    float3 outputColor = lerp(
        bloomAverage,
        bloomLuminanceColor,
        glowSetup.w
    );

    // Match the lower clamping formerly provided by UNORM storage.
    outputColor = max(outputColor, 0.0f);

    return float4(outputColor, 1.0f);
}