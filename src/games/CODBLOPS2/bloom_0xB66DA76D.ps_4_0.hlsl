// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 01 12:29:50 2026
//
// HDR-safe DOF fix with restored blur softness.
//
// ALPHA_POWER:
//   1.00 = raw texture alpha; least blurry
//   0.75 = moderately wider blur
//   0.50 = strong, soft blur
//   0.35 = very wide/strong blur
//
// Values below 1 expand low-alpha regions while keeping zero alpha at zero.

#define ALPHA_POWER 0.50f
#define ALPHA_BOOST 1.00f

SamplerState colorMapSampler_s : register(s0);
Texture2D<float4> colorMapSampler : register(t0);

bool IsFiniteFloat4(float4 value)
{
    return !any(isnan(value)) && !any(isinf(value));
}

void main(
    float4 v0 : SV_Position0,
    float4 v1 : COLOR0,
    float2 v2 : TEXCOORD0,
    out float4 o0 : SV_Target0)
{
    float4 sampledColor =
        colorMapSampler.Sample(colorMapSampler_s, v2.xy);

    // Invalid samples must contribute nothing to the DOF composite.
    if (!IsFiniteFloat4(sampledColor))
    {
        discard;
    }

    float textureAlpha = saturate(sampledColor.a);
    float vertexAlpha = saturate(v1.a);

    // Expand faint portions of the DOF alpha mask.
    //
    // Alpha zero remains exactly zero, preventing the black padding
    // from being drawn. Low nonzero alpha becomes stronger, restoring
    // the soft and wide appearance of the original DOF.
    float expandedAlpha = pow(textureAlpha, ALPHA_POWER);
    expandedAlpha = saturate(expandedAlpha * ALPHA_BOOST);

    float coverage = expandedAlpha * vertexAlpha;

    // Only discard pixels that are effectively completely transparent.
    // Do not use a larger clip threshold because that cuts away the
    // soft outer portion of the blur.
    clip(coverage - 0.000001f);

    float3 textureRGB = max(sampledColor.rgb, 0.0f);
    float3 vertexRGB = max(v1.rgb, 0.0f);

    // Straight-alpha output.
    // Values above 1.0 remain available for HDR.
    o0.rgb = textureRGB * vertexRGB;
    o0.a = coverage;
}