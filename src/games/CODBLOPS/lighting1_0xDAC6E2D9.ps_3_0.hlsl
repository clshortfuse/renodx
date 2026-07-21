// Unclamped reconstruction of the original ps_3_0 sky/cloud shader.
//
// Original final processing:
//
//     color = saturate(color * hdrControl0.x);
//     color = sqrt(color);
//
// Unclamped final processing:
//
//     color = sqrt(max(color * hdrControl0.x, 0.0f));
//
// RGB values above 1.0 are preserved. The lower bound remains to prevent
// negative values from producing NaNs during the square-root operation.
//
// Values above 1.0 will only survive when the destination render target is
// floating point, such as R16G16B16A16_FLOAT. A UNORM target will still clamp
// the result when it is stored.

samplerCUBE colorMapSampler    : register(s0);
sampler2D   cloudLayer0Sampler : register(s1);
sampler2D   cloudMask0Sampler  : register(s2);
sampler2D   cloudLayer1Sampler : register(s3);
sampler2D   cloudMask1Sampler  : register(s4);

float4 fogConsts          : register(c5);
float4 fogConsts2         : register(c6);
float4 colorMatrixR       : register(c7);
float4 colorMatrixG       : register(c8);
float4 colorMatrixB       : register(c9);
float4 hdrControl0        : register(c10);
float  skyColorMultiplier : register(c11);

float4 cloudsHeights : register(c20);
float4 cloudsFeather : register(c21);
float4 cloudsUVMul1  : register(c22);
float4 cloudsUVMul2  : register(c23);


struct PS_INPUT
{
    float4 texcoord0 : TEXCOORD0;
    float4 texcoord1 : TEXCOORD1;
    float3 texcoord2 : TEXCOORD2;
    float2 texcoord3 : TEXCOORD3;
    float4 texcoord4 : TEXCOORD4;
    float4 texcoord5 : TEXCOORD5;
};


float4 main(PS_INPUT input) : COLOR0
{
    // ---------------------------------------------------------------------
    // Calculate the cloud/fog depth factor.
    // ---------------------------------------------------------------------

    float fogInput =
        fogConsts.w * input.texcoord1.z
        + fogConsts.x;

    // The original shader limits this before evaluating the exponential.
    // This is overflow protection, not the final HDR output clamp.
    float limitedFogInput = min(fogInput, 64.0f);

    float exponentialFogInput = exp(limitedFogInput);

    float fogCurve;

    if (fogInput >= 0.0f)
    {
        fogCurve = fogInput + 1.0f;
    }
    else
    {
        fogCurve = exponentialFogInput;
    }

    fogCurve -= fogConsts2.x;

    float rawFogScale =
        input.texcoord1.z * fogConsts.w;

    bool validFogScale =
        abs(rawFogScale) >= 0.0001f;

    float safeFogScale =
        validFogScale
            ? rawFogScale
            : 1.0f;

    float cloudDepthFactor;

    if (validFogScale)
    {
        cloudDepthFactor =
            fogCurve / safeFogScale;
    }
    else
    {
        cloudDepthFactor =
            saturate(fogConsts2.x);
    }

    // ---------------------------------------------------------------------
    // Project the two cloud layers onto their configured heights.
    // ---------------------------------------------------------------------

    float inverseDirectionZ =
        1.0f / input.texcoord1.z;

    float2 cloudProjection0 =
        input.texcoord1.xy
        * cloudsHeights.x
        * inverseDirectionZ;

    float2 cloudProjection1 =
        input.texcoord1.xy
        * cloudsHeights.y
        * inverseDirectionZ;

    // ---------------------------------------------------------------------
    // First cloud layer.
    // ---------------------------------------------------------------------

    float cloudDistance0 =
        length(cloudProjection0);

    // This saturation controls cloud-edge opacity and should remain clamped.
    float cloudFeather0 = saturate(
        cloudDistance0 * cloudsFeather.x
        + cloudsFeather.y
    );

    float4 cloudUV0 =
        cloudProjection0.xyxy * cloudsUVMul1
        + input.texcoord4;

    float4 cloudLayer0 =
        tex2D(cloudLayer0Sampler, cloudUV0.xy);

    float4 cloudMask0 =
        tex2D(cloudMask0Sampler, cloudUV0.zw);

    float cloudOpacity0 =
        cloudMask0.r
        * cloudLayer0.a
        * cloudFeather0
        * input.texcoord3.x;

    // Clouds are disabled below the horizon.
    if (input.texcoord1.z <= 0.0f)
    {
        cloudOpacity0 = 0.0f;
    }

    // ---------------------------------------------------------------------
    // Sample and transform the base sky cubemap.
    // ---------------------------------------------------------------------

    float4 skySample0 =
        texCUBE(
            colorMapSampler,
            input.texcoord0.xyz
        );

    float4 skySample1 =
        texCUBE(
            colorMapSampler,
            float3(
                input.texcoord0.x,
                input.texcoord0.y,
                input.texcoord0.w
            )
        );

    float4 skySample =
        lerp(
            skySample0,
            skySample1,
            input.texcoord1.w
        );

    // The original shader squares the cubemap before applying its matrix.
    float3 squaredSky =
        skySample.rgb * skySample.rgb;

    float3 transformedSky;

    transformedSky.r =
        dot(squaredSky, colorMatrixR.xyz);

    transformedSky.g =
        dot(squaredSky, colorMatrixG.xyz);

    transformedSky.b =
        dot(squaredSky, colorMatrixB.xyz);

    // Blend the first cloud layer over the transformed sky.
    float3 combinedColor =
        lerp(
            transformedSky,
            cloudLayer0.rgb,
            cloudOpacity0
        );

    // ---------------------------------------------------------------------
    // Second cloud layer.
    // ---------------------------------------------------------------------

    float cloudDistance1 =
        length(cloudProjection1);

    // This saturation also controls cloud-edge opacity.
    float cloudFeather1 = saturate(
        cloudDistance1 * cloudsFeather.z
        + cloudsFeather.w
    );

    float4 cloudUV1 =
        cloudProjection1.xyxy * cloudsUVMul2
        + input.texcoord5;

    float4 cloudLayer1 =
        tex2D(cloudLayer1Sampler, cloudUV1.xy);

    float4 cloudMask1 =
        tex2D(cloudMask1Sampler, cloudUV1.zw);

    float cloudOpacity1 =
        cloudMask1.r
        * cloudLayer1.a
        * cloudFeather1
        * input.texcoord3.y;

    if (input.texcoord1.z <= 0.0f)
    {
        cloudOpacity1 = 0.0f;
    }

    combinedColor =
        lerp(
            combinedColor,
            cloudLayer1.rgb,
            cloudOpacity1
        );

    // Original overall cloud intensity multiplier.
    combinedColor *= cloudsHeights.z;

    // ---------------------------------------------------------------------
    // Distance fog and sky-color blending.
    // ---------------------------------------------------------------------

    float viewDirectionLength =
        length(input.texcoord1.xyz);

    float fogExponent =
        cloudDepthFactor
        * fogConsts.y
        * viewDirectionLength
        + fogConsts.z;

    // The original exp_sat instruction produces a bounded interpolation
    // factor. Removing this clamp would extrapolate the fog blend.
    float fogBlend =
        saturate(exp2(fogExponent));

    float3 multipliedSky =
        combinedColor * skyColorMultiplier;

    float3 foggedColor =
        lerp(
            input.texcoord2,
            multipliedSky,
            fogBlend
        );

    // ---------------------------------------------------------------------
    // Unclamped HDR output.
    // ---------------------------------------------------------------------

    float3 scaledColor =
        foggedColor * hdrControl0.x;

    // Original shader:
    //
    //     scaledColor = saturate(scaledColor);
    //     scaledColor = sqrt(scaledColor);
    //
    // Keep only the lower bound so negative values do not produce NaNs.
    // There is no upper clamp, so HDR values can remain above 1.0.
    float3 outputColor =
        sqrt(max(scaledColor, 0.0f));

    return float4(
        outputColor,
        skySample.a
    );
}