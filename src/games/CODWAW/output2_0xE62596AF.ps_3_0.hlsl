// Call of Duty: World at War
// Human-readable HDR-safe replacement for the supplied ps_3_0 shader.
//
// HDR changes:
//   1. KEEP the original saturate used for screen/UV coordinates.
//   2. REMOVE the upper clamp from the color + flame/effect combination.
//   3. REMOVE the upper clamp from the final fade/composite.
//   4. Preserve the original lower 0 bound with max(color, 0).
//
// This keeps positive values above 1.0 alive for an upgraded FP16 render target.

sampler2D colorMapSampler  : register(s0);
sampler2D colorMapSampler1 : register(s4);
sampler2D normalMapSampler : register(s5);

float4 gameTime           : register(c5);
float4 colorTintBase      : register(c6);
float4 colorTintDelta     : register(c7);
float4 colorBias          : register(c8);
float4 flameDistortion    : register(c9);
float4 fadeEffect         : register(c10);
float4 viewportDimensions : register(c11);


struct PixelInput
{
    float2 texCoord0 : TEXCOORD0;
    float2 texCoord1 : TEXCOORD1;
    float4 texCoord2 : TEXCOORD2;
    float4 texCoord3 : TEXCOORD3;
};


static const float3 WAW_LUMINANCE =
    float3(
        0.298999995f,
        0.587000012f,
        0.114000000f
    );


float3 SafePositive(float3 color)
{
    // Preserve HDR values above 1.0.
    // Only retain the original shader's lower 0 bound.
    return max(color, 0.0f);
}


// Reconstructs the same colorBias / tint operation used by the game.
float3 ApplyWaWColorTransform(float3 color)
{
    float luminance =
        dot(
            color,
            WAW_LUMINANCE
        );

    float3 adjustedColor =
        color * colorBias.w
        + luminance.xxx;

    float3 tint =
        colorTintBase.rgb
        + colorTintDelta.rgb * luminance;

    return
        adjustedColor * tint
        + colorBias.rgb;
}


float4 main(PixelInput input) : COLOR0
{
    // ------------------------------------------------------------------------
    // Flame distortion normal-map coordinates
    // ------------------------------------------------------------------------

    float2 normalUV;

    normalUV.x =
        input.texCoord1.x
        + gameTime.x * flameDistortion.x;

    normalUV.y =
        input.texCoord1.y
        + gameTime.w * flameDistortion.z;


    float2 distortionNormal =
        tex2D(
            normalMapSampler,
            normalUV
        ).xy;


    float distortionAmount =
        input.texCoord0.y
        * flameDistortion.w;


    float2 distortedUV =
        input.texCoord0
        + distortionNormal * distortionAmount;


    // ------------------------------------------------------------------------
    // Original viewport/screen-coordinate protection
    // ------------------------------------------------------------------------
    //
    // IMPORTANT:
    // The original shader used mul_sat here.
    //
    // This clamp is NOT a color/HDR clamp. It protects the screen-space lookup,
    // so it must remain exactly clamped to 0..1.
    // ------------------------------------------------------------------------

    float2 normalizedViewportUV;

    normalizedViewportUV.x =
        saturate(
            (distortedUV.x - viewportDimensions.x)
            * viewportDimensions.z
        );

    normalizedViewportUV.y =
        saturate(
            (distortedUV.y - viewportDimensions.y + 0.005f)
            * viewportDimensions.w
        );


    float2 clampedDistortedUV;

    clampedDistortedUV.x =
        normalizedViewportUV.x
        / viewportDimensions.z
        + viewportDimensions.x;

    clampedDistortedUV.y =
        normalizedViewportUV.y
        / viewportDimensions.w
        + viewportDimensions.y;


    // Original shader samples the distorted scene 0.0025 upward/downward in Y
    // after its viewport correction.
    float2 distortedSceneUV =
        float2(
            clampedDistortedUV.x,
            clampedDistortedUV.y - 0.0025f
        );


    // ------------------------------------------------------------------------
    // Distorted scene sample + original WaW color transform
    // ------------------------------------------------------------------------

    float3 distortedScene =
        tex2D(
            colorMapSampler,
            distortedSceneUV
        ).rgb;


    float3 gradedDistortedScene =
        ApplyWaWColorTransform(
            distortedScene
        );


    // ------------------------------------------------------------------------
    // Flame/effect texture interpolation
    // ------------------------------------------------------------------------

    float3 effectA =
        tex2D(
            colorMapSampler1,
            input.texCoord2.xy
        ).rgb;


    float3 effectB =
        tex2D(
            colorMapSampler1,
            input.texCoord2.zw
        ).rgb;


    // D3D9 lrp r3.xyz, v3.x, r0, r1
    //
    // = v3.x * effectB + (1 - v3.x) * effectA
    float3 flameEffect =
        lerp(
            effectA,
            effectB,
            input.texCoord3.x
        );


    // ------------------------------------------------------------------------
    // HDR FIX #1
    // ------------------------------------------------------------------------
    //
    // Original assembly:
    //
    //     add_sat r1.xyz, r2, r3
    //
    // Equivalent original HLSL:
    //
    //     combined = saturate(gradedDistortedScene + flameEffect);
    //
    // That upper-clamps HDR values to 1.0.
    //
    // HDR-safe replacement:
    //
    //     combined = max(..., 0);
    //
    // This preserves the original lower bound while allowing >1.0 highlights.
    // ------------------------------------------------------------------------

    float3 combinedColor =
        SafePositive(
            gradedDistortedScene
            + flameEffect
        );


    // ------------------------------------------------------------------------
    // Original non-distorted scene sample
    // ------------------------------------------------------------------------

    float3 originalScene =
        tex2D(
            colorMapSampler,
            input.texCoord0
        ).rgb;


    // ------------------------------------------------------------------------
    // HDR FIX #2
    // ------------------------------------------------------------------------
    //
    // Original assembly:
    //
    //     add     r0.xyz, -r1, r0
    //     mad_sat oC0.xyz, c10.x, r0, r1
    //
    // Equivalent:
    //
    //     output = saturate(
    //         combinedColor
    //         + fadeEffect.x * (originalScene - combinedColor)
    //     );
    //
    // or:
    //
    //     output = saturate(
    //         lerp(combinedColor, originalScene, fadeEffect.x)
    //     );
    //
    // Remove ONLY the upper SDR clamp.
    // ------------------------------------------------------------------------

    float3 finalColor =
        lerp(
            combinedColor,
            originalScene,
            fadeEffect.x
        );


    finalColor =
        SafePositive(
            finalColor
        );


    return float4(
        finalColor,
        1.0f
    );
}
