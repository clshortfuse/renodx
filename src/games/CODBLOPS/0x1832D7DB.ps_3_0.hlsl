// Human-readable replacement for DX9 pixel shader 0x1832D7DB.
//
// Goal:
//   - Keep the original particle/flare size.
//   - Make it look less like a dense solid blob.
//   - Do not reduce the original RGB brightness contribution.
//   - Only reduce alpha/coverage, mostly in the faint halo.
//
// Original behavior:
//   1. Sample scene depth.
//   2. Compute a depth-feather factor.
//   3. Sample the particle texture.
//   4. Multiply texture RGB by vertex RGB.
//   5. Build alpha from depth feather * texture alpha.
//   6. Multiply alpha by a luminance term.
//   7. Output premultiplied RGB = color * alpha, and output alpha = alpha.
//
// This version preserves the original premultiplied RGB brightness,
// but remaps alpha so the halo becomes more transparent while the core
// stays much closer to the original opacity.

sampler2D colorMapSampler : register(s0);
sampler2D floatZSampler   : register(s1);

float4 renderTargetSize : register(c5);
float4 featherParms     : register(c6);

// -----------------------------------------------------------------------------
// Tuning
// -----------------------------------------------------------------------------
// Lower = more transparent outer halo.
// 0.35 is a good starting point.
// 0.20 = much more transparent
// 0.50 = less transparent
#define TRANSPARENCY_HALO_ALPHA_SCALE 0.35f
#define TRANSPARENCY_CORE_ALPHA_SCALE 0.70f

// Higher = keep the core more intact while making the halo more transparent.
// 1.0 = softer transition
// 2.0 = stronger “solid core, airy halo” behavior
#define TRANSPARENCY_CORE_POWER 1.50f

struct PS_INPUT
{
    float4 color    : COLOR0;
    float3 texcoord : TEXCOORD0;   // xy = particle UV, z = particle depth reference
    float2 vpos     : VPOS;
};

float Smooth01(float x)
{
    x = saturate(x);
    return x * x * (3.0f - 2.0f * x);
}

float ComputeTransparencyScale(float alpha)
{
    float coreMask = Smooth01(alpha);
    coreMask = pow(max(coreMask, 0.0f), TRANSPARENCY_CORE_POWER);

    // Low-alpha halo gets reduced more.
    // Bright core is also reduced so it does not become a solid center.
    return lerp(
        TRANSPARENCY_HALO_ALPHA_SCALE,
        TRANSPARENCY_CORE_ALPHA_SCALE,
        coreMask
    );
}

float4 main(PS_INPUT input) : COLOR0
{
    // Reconstruct the original depth UV.
    float2 depthUV = input.vpos.xy * renderTargetSize.zw;

    // Original depth sample.
    float4 depthSample = tex2D(floatZSampler, depthUV);

    // Original depth-feather logic:
    // abs(sceneDepth) - particleDepth
    float feather = abs(depthSample.x) - input.texcoord.z;
    feather = saturate(feather * featherParms.x);
    feather *= input.color.a;

    // Original particle texture sample.
    float4 textureSample = tex2D(colorMapSampler, input.texcoord.xy);

    // Original RGB color path.
    float3 particleColor = input.color.rgb * textureSample.rgb;

    // Original alpha before luminance weighting.
    float baseAlpha = feather * textureSample.a;

    // Original luminance weighting:
    // dp3 r0.xzy, c0.xxy where c0 = (0.25, 0.5, 0, 0)
    // => R*0.25 + G*0.50 + B*0.25
    float luminanceWeight = dot(
        particleColor,
        float3(0.25f, 0.50f, 0.25f)
    );

    // Original final alpha.
    float originalAlpha = baseAlpha * luminanceWeight;
    originalAlpha = saturate(originalAlpha);

    // Original premultiplied RGB output.
    // This is the part we preserve so brightness does not get reduced.
    float3 originalPremultipliedRGB = particleColor * originalAlpha;

    // New alpha-only transparency shaping.
    // Same size, but the lower-alpha halo becomes more transparent.
    float transparencyScale = ComputeTransparencyScale(originalAlpha);
    float adjustedAlpha = originalAlpha * transparencyScale;

    return float4(originalPremultipliedRGB, adjustedAlpha);
}
