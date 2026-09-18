// HDR-safe reconstruction of the original soft-particle shader.
//
// Fixes:
// - Prevents negative alpha from flipping RGB negative.
// - Prevents negative sampled RGB from becoming subtractive.
// - Preserves HDR RGB values above 1.0.
// - Preserves the original depth-feather behavior.
//
// FEATHER_MODE:
//   0 = original absolute depth feather
//   1 = one-sided depth feather; useful if effects have hollow centers
//   2 = disable depth feather for diagnosis
//
// RGB_ALPHA_MODE:
//   0 = original premultiplied RGB behavior
//   1 = do not multiply RGB by texture alpha; diagnostic only

#define FEATHER_MODE 0
#define RGB_ALPHA_MODE 0

sampler2D colorMapSampler : register(s0);
sampler2D floatZSampler   : register(s4);

float4 featherParms : register(c3);

struct PS_INPUT
{
    float4 color      : COLOR0;
    float3 texcoord   : TEXCOORD0;
    float4 depthCoord : TEXCOORD1;
};

float ComputeDepthFeather(float sceneDepth, float effectDepth)
{
    // Matches:
    // abs(depthSample) * featherParms.x - v1.z
    float depthDifference =
        abs(sceneDepth) * featherParms.x - effectDepth;

#if FEATHER_MODE == 0

    // Original shader:
    // abs_sat r0.x, r0.x
    return saturate(abs(depthDifference));

#elif FEATHER_MODE == 1

    // One-sided soft-particle feather.
    // This avoids fading both sides of the depth intersection.
    return saturate(depthDifference);

#else

    // Diagnostic: completely disable depth feathering.
    return 1.0f;

#endif
}

float4 main(PS_INPUT input) : COLOR0
{
    float sceneDepth = tex2Dproj(floatZSampler, input.depthCoord).x;

    float feather = ComputeDepthFeather(
        sceneDepth,
        input.texcoord.z
    );

    float4 color =
        tex2D(colorMapSampler, input.texcoord.xy)
        * input.color;

    // HDR targets preserve negative values, unlike the likely original
    // UNORM destination. Negative RGB can behave like subtractive light.
    color.rgb = max(color.rgb, 0.0f);

    // Alpha is a coverage/mask value, not HDR color.
    // A negative alpha would flip the final premultiplied RGB negative.
    float textureAlpha = saturate(color.a);
    float outputAlpha = feather * textureAlpha;

#if RGB_ALPHA_MODE == 0

    // Original behavior:
    // RGB is premultiplied by the final alpha.
    float3 outputColor = color.rgb * outputAlpha;

#else

    // Diagnostic behavior:
    // Keeps depth feathering but does not multiply RGB by texture alpha.
    float3 outputColor = color.rgb * feather;

#endif

    return float4(outputColor, outputAlpha);
}