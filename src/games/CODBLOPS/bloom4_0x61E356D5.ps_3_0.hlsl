// Replacement for BO1 pixel shader 0x79EF3202.
//
// Purpose:
//   Major reduction of oversized bloom flares while preserving the original
//   weighted blur, color treatment, hdrControl parameters and scene composite.
//
// What changes:
//   1. All vertical sampling offsets are multiplied by BLOOM_RADIUS_SCALE.
//      This makes the blur kernel physically narrower without altering its
//      authored weights.
//   2. A smooth nonlinear mask suppresses the faint outer halo after the blur.
//   3. The final bloom contribution can be reduced independently with
//      BLOOM_CONTRIBUTION_SCALE.
//   4. The final tinted bloom is neutralized toward luminance-matched white,
//      with stronger whitening in the bright core than in the halo.
//
// Important:
//   This shader only offsets samples vertically. A matching horizontal blur
//   shader may also exist. Applying the same radius reduction there will shrink
//   the flare symmetrically in both directions.
//
// Suggested tuning:
//   BLOOM_RADIUS_SCALE
//     1.00 = original radius
//     0.50 = half radius
//     0.25 = strongly reduced
//     0.15 = extremely small
//
//   BLOOM_HALO_START / BLOOM_HALO_FULL
//     Raise both values to keep only brighter bloom pixels and reduce the
//     apparent radius further.
//
// No final RGB clamp is applied.

#define BLOOM_RADIUS_SCALE        0.15f
#define BLOOM_HALO_START          0.025f
#define BLOOM_HALO_FULL           0.350f
#define BLOOM_HALO_POWER          1.00f
#define BLOOM_CONTRIBUTION_SCALE  0.85f

// Bloom whitening controls. Whitening happens after hdrControl1.rgb so the
// game's final bloom tint cannot recolor the flare afterward.
// The white target has the same luminance as the colored bloom contribution,
// so this changes saturation/hue without intentionally raising brightness.
#define BLOOM_WHITE_BASE_AMOUNT   0.35f
#define BLOOM_WHITE_CORE_AMOUNT   0.90f
#define BLOOM_WHITE_CORE_START    0.050f
#define BLOOM_WHITE_CORE_FULL     0.800f

sampler2D bloomSampler : register(s0);
sampler2D colorSampler : register(s1);

float4 hdrControl0 : register(c5);
float4 hdrControl1 : register(c6);

float4 postFxControl0 : register(c7);
float4 postFxControl1 : register(c8);
float4 postFxControl2 : register(c9);
float4 postFxControl3 : register(c10);
float4 postFxControl4 : register(c11);
float4 postFxControl5 : register(c20);
float4 postFxControl6 : register(c21);
float4 postFxControl7 : register(c22);
float4 postFxControl8 : register(c23);
float4 postFxControl9 : register(c24);
float4 postFxControlA : register(c25);
float4 postFxControlB : register(c26);
float4 postFxControlC : register(c27);
float4 postFxControlD : register(c28);
float4 postFxControlE : register(c29);
float4 postFxControlF : register(c30);

struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};

float BloomMax3(float3 value)
{
    return max(value.r, max(value.g, value.b));
}

float BloomSmooth01(float value)
{
    value = saturate(value);
    return value * value * (3.0f - 2.0f * value);
}

float BloomRangeMask(float value, float startValue, float fullValue)
{
    float width = max(fullValue - startValue, 0.000001f);
    return BloomSmooth01((value - startValue) / width);
}

float3 SampleWeightedBloom(
    float2 texcoord,
    float4 blurControl,
    float direction)
{
    float2 sampleCoord = texcoord;
    sampleCoord.y += direction * blurControl.w * BLOOM_RADIUS_SCALE;

    return tex2D(bloomSampler, sampleCoord).rgb * blurControl.rgb;
}

float4 main(PS_INPUT input) : COLOR0
{
    // Preserve the exact original 32-tap weight set. Only the spatial offsets
    // are compressed by BLOOM_RADIUS_SCALE.
    float3 blurredBloom = 0.0f;

    // Negative side. The unusual E/F/D ordering matches the original bytecode.
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlE, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlF, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlD, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlC, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlB, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlA, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl9, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl8, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl7, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl6, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl5, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl4, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl3, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl2, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl1, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl0, -1.0f);

    // Positive side.
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl0, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl1, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl2, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl3, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl4, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl5, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl6, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl7, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl8, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl9, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlA, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlB, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlC, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlD, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlE, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlF, 1.0f);

    // Suppress the low-intensity outer blur. Raising the mask to a power makes
    // its falloff much steeper without introducing a hard circular boundary.
    float bloomStrength = max(BloomMax3(blurredBloom), 0.0f);

    float retainedHalo = BloomRangeMask(
        bloomStrength,
        BLOOM_HALO_START,
        BLOOM_HALO_FULL
    );

    retainedHalo = pow(max(retainedHalo, 0.0f), BLOOM_HALO_POWER);
    blurredBloom *= retainedHalo;

    // Preserve the original luminance-based desaturation/color interpolation:
    //   luminance = dot(blurredBloom, hdrControl0.rgb)
    //   treatedBloom = lerp(luminance.xxx, blurredBloom, hdrControl0.w)
    float bloomLuminance = dot(blurredBloom, hdrControl0.rgb);

    float3 treatedBloom = lerp(
        bloomLuminance.xxx,
        blurredBloom,
        hdrControl0.w
    );

    // Apply the game's original final bloom tint first.
    float3 bloomContribution = treatedBloom * hdrControl1.rgb;

    // Neutralize the surviving flare toward white. The hottest core becomes
    // much whiter than the halo, while even the halo receives some whitening.
    // Because whiteBloom uses the same luminance, the interpolation preserves
    // luminance and should not make the flare larger merely from recoloring it.
    const float3 luminanceWeights =
        float3(0.2126f, 0.7152f, 0.0722f);

    float contributionLuminance = max(
        dot(bloomContribution, luminanceWeights),
        0.0f
    );

    float whiteCoreMask = BloomRangeMask(
        contributionLuminance,
        BLOOM_WHITE_CORE_START,
        BLOOM_WHITE_CORE_FULL
    );

    float whiteAmount = lerp(
        BLOOM_WHITE_BASE_AMOUNT,
        BLOOM_WHITE_CORE_AMOUNT,
        whiteCoreMask
    );

    float3 whiteBloom = contributionLuminance.xxx;

    bloomContribution = lerp(
        bloomContribution,
        whiteBloom,
        saturate(whiteAmount)
    );

    float4 sceneColor = tex2D(colorSampler, input.texcoord);

    // Preserve the original additive composite, with the existing optional
    // contribution scale applied after whitening.
    float3 outputColor =
        sceneColor.rgb
        + bloomContribution * BLOOM_CONTRIBUTION_SCALE;

    return float4(outputColor, sceneColor.a);
}
