// HDR-safe reconstruction of the original ps_3_0 depth-of-field composite.
//
// The original shader's final RGB output is already unclamped.
//
// The two original saturation operations are preserved because they clamp
// DOF control values, not scene lighting:
//
//   1. sceneDOFAmount
//   2. dofWeights
//
// Removing those clamps can create negative or greater-than-one blend
// coefficients, causing bright lighting to become dark or inverted.
//
// RGB values above 1.0 remain intact as long as the destination render target
// is floating point, such as R16G16B16A16_FLOAT.

sampler2D colorMapSampler  : register(s0);
sampler2D floatZSampler    : register(s1);
sampler2D colorMapSampler1 : register(s2);
sampler2D colorMapSampler2 : register(s3);

float4 renderTargetSize               : register(c5);
float4 dofEquationScene               : register(c6);
float4 dofEquationViewModelAndFarBlur : register(c7);
float4 dofLerpScale                   : register(c8);
float4 dofLerpBias                    : register(c9);


struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};


float4 main(PS_INPUT input) : COLOR0
{
    float2 texelSize = renderTargetSize.zw;

    // ---------------------------------------------------------------------
    // Original four offset samples
    // ---------------------------------------------------------------------

    float3 blurSample0 = tex2D(
        colorMapSampler,
        input.texcoord
            + texelSize * float2(0.5f, -1.5f)
    ).rgb;

    float3 blurSample1 = tex2D(
        colorMapSampler,
        input.texcoord
            + texelSize * float2(-1.5f, -0.5f)
    ).rgb;

    float3 blurSample2 = tex2D(
        colorMapSampler,
        input.texcoord
            + texelSize * float2(-0.5f, 1.5f)
    ).rgb;

    float3 blurSample3 = tex2D(
        colorMapSampler,
        input.texcoord
            + texelSize * float2(1.5f, 0.5f)
    ).rgb;

    float3 offsetSampleSum =
        blurSample0
        + blurSample1
        + blurSample2
        + blurSample3;

    // Original center scene sample.
    float4 sceneColor = tex2D(
        colorMapSampler,
        input.texcoord
    );

    // Original weighted blur:
    //
    // Each offset sample receives approximately 4/17.
    // The center sample receives approximately 1/17.
    //
    // This path is deliberately not clamped.
    float3 blurredScene =
        offsetSampleSum * 0.235294119f
        + sceneColor.rgb * 0.0588235296f;

    // ---------------------------------------------------------------------
    // Original depth-of-field controls
    // ---------------------------------------------------------------------

    float depth = tex2D(
        floatZSampler,
        input.texcoord
    ).x;

    // Original assembly:
    //
    //   mad_sat r0.w, c6.y, r0.x, c6.w
    //
    // This saturation must remain. It constrains a DOF mask and does not
    // clamp scene RGB or HDR brightness.
    float sceneDOFAmount = saturate(
        dofEquationScene.y * depth
        + dofEquationScene.w
    );

    float sceneDOFAlpha =
        sceneDOFAmount
        * dofEquationViewModelAndFarBlur.w;

    float4 secondaryBlur = tex2D(
        colorMapSampler1,
        input.texcoord
    );

    float selectedDOFAlpha;

    // Original assembly:
    //
    //   add r1.w, -depth, 1500000
    //   max r1.z, sceneDOFAlpha, secondaryBlur.a
    //   cmp r0.w, r1.w, r1.z, secondaryBlur.a
    //
    // D3D9 cmp selects the first value when the comparison source is
    // greater than or equal to zero.
    if ((1500000.0f - depth) >= 0.0f)
    {
        selectedDOFAlpha = max(
            sceneDOFAlpha,
            secondaryBlur.a
        );
    }
    else
    {
        selectedDOFAlpha = secondaryBlur.a;
    }

    // Original assembly:
    //
    //   mad_sat r1, r0.w, c8, c9
    //
    // This saturation must also remain. These are interpolation weights,
    // not RGB output values.
    float4 dofWeights = saturate(
        selectedDOFAlpha * dofLerpScale
        + dofLerpBias
    );

    // Original blend-weight relationships.
    float sceneBlurWeight = min(
        1.0f - dofWeights.x,
        dofWeights.y
    );

    float secondaryBlurWeight = min(
        1.0f - dofWeights.y,
        dofWeights.z
    );

    // ---------------------------------------------------------------------
    // Original unclamped HDR composite
    // ---------------------------------------------------------------------

    float3 outputColor =
        sceneColor.rgb * dofWeights.x;

    outputColor +=
        blurredScene * sceneBlurWeight;

    outputColor +=
        secondaryBlur.rgb * secondaryBlurWeight;

    float4 tertiaryBlur = tex2D(
        colorMapSampler2,
        input.texcoord
    );

    outputColor +=
        tertiaryBlur.rgb * dofWeights.w;

    // No saturate, min(1), clamp, gamma encoding, or tone mapping is applied
    // to outputColor. Values above 1.0 remain above 1.0.
    return float4(
        outputColor,
        sceneColor.a
    );
}