// ---- Human-readable HDR-safe reconstruction
//
// Robust NaN/INF fix for the sprite modulation pass.
//
// Why max(color, 0) alone was not enough:
//
//   1. max(+INF, 0) is still +INF.
//   2. The final shader multiplies sceneColor * spriteColor.
//   3. IEEE floating-point defines:
//
//          INF * 0 = NaN
//
//   4. A NaN/INF distortion sample can also poison the sprite UV before t5
//      is sampled.
//
// This version:
// - Replaces NaN with a safe fallback.
// - Removes negative values.
// - Converts +INF to FP16 maximum instead of allowing INF into the multiply.
// - Sanitizes the distortion vector before UV math.
// - Preserves all ordinary positive HDR values above 1.0.
// - Does NOT use saturate() on HDR RGB.
//
// R16G16B16A16_FLOAT finite maximum:
//     65504.0

Texture2D<float4> SceneTexture      : register(t0);
Texture2D<float4> DistortionTexture : register(t4);
Texture2D<float4> SpriteTexture     : register(t5);

SamplerState SceneSampler      : register(s0);
SamplerState DistortionSampler : register(s4);
SamplerState SpriteSampler     : register(s5);

cbuffer SpriteBounds : register(b2)
{
    // xy = minimum allowed sprite UV
    // zw = maximum allowed sprite UV
    float4 spriteUVBounds : packoffset(c0);
};


// ============================================================================
// Finite-value safety helpers
// ============================================================================

// Preserve finite positive HDR values while removing values that can poison
// later multiplication.
//
// NaN:
//     value != value
//
// +INF:
//     min(+INF, 65504) -> 65504
//
// -INF / negative:
//     max(value, 0) -> 0
float SanitizePositiveFinite(float value)
{
    // Explicit NaN removal first.
    value =
        (value == value)
        ? value
        : 0.0f;

    // Keep the full finite FP16 HDR range.
    return min(
        max(value, 0.0f),
        65504.0f
    );
}


float4 SanitizePositiveFinite(float4 color)
{
    return float4(
        SanitizePositiveFinite(color.r),
        SanitizePositiveFinite(color.g),
        SanitizePositiveFinite(color.b),
        SanitizePositiveFinite(color.a)
    );
}


// Distortion values are different from colors.
//
// The source texture is expected to be centered around 0.5. If a component is
// NaN, using 0.5 gives ZERO distortion after subtracting 0.5, which is much
// safer than substituting black and shifting the sprite by -0.5.
float SanitizeDistortionComponent(float value)
{
    // NaN -> neutral distortion center.
    value =
        (value == value)
        ? value
        : 0.5f;

    // Prevent infinities or absurd values from poisoning UV math.
    return clamp(
        value,
        -65504.0f,
        65504.0f
    );
}


float2 SanitizeDistortion(float2 distortion)
{
    return float2(
        SanitizeDistortionComponent(distortion.x),
        SanitizeDistortionComponent(distortion.y)
    );
}


// UV safety after all distortion math.
//
// A NaN here would make the following texture sample undefined.
float SanitizeUVComponent(float value, float fallback)
{
    value =
        (value == value)
        ? value
        : fallback;

    return clamp(
        value,
        -65504.0f,
        65504.0f
    );
}


float2 SanitizeUV(float2 uv, float2 fallback)
{
    return float2(
        SanitizeUVComponent(uv.x, fallback.x),
        SanitizeUVComponent(uv.y, fallback.y)
    );
}


// ============================================================================
// Pixel shader
// ============================================================================

void main(
    float4 position         : SV_POSITION0,
    float4 packedTexcoord   : TEXCOORD0,
    float2 distortionScale  : TEXCOORD1,
    out float4 outputColor  : SV_TARGET0)
{
    // packedTexcoord.xy:
    //     base sprite UV
    //
    // packedTexcoord.zw:
    //     distortion texture UV + scene texture UV


    // ------------------------------------------------------------------------
    // 1. Sanitize the base/sample UVs before any texture access
    // ------------------------------------------------------------------------

    float2 baseSpriteUV =
        SanitizeUV(
            packedTexcoord.xy,
            0.0f.xx
        );

    float2 sceneUV =
        SanitizeUV(
            packedTexcoord.zw,
            0.0f.xx
        );


    // ------------------------------------------------------------------------
    // 2. Sample and sanitize distortion
    // ------------------------------------------------------------------------

    float2 distortionSample =
        DistortionTexture.Sample(
            DistortionSampler,
            sceneUV
        ).xy;

    distortionSample =
        SanitizeDistortion(
            distortionSample
        );

    // Original shader:
    //
    //     distortion = sample - 0.5
    //
    float2 centeredDistortion =
        distortionSample
        - 0.5f.xx;


    // ------------------------------------------------------------------------
    // 3. Protect distortion scale
    // ------------------------------------------------------------------------

    float2 safeDistortionScale =
        float2(
            SanitizeUVComponent(
                distortionScale.x,
                0.0f
            ),
            SanitizeUVComponent(
                distortionScale.y,
                0.0f
            )
        );


    // ------------------------------------------------------------------------
    // 4. Build sprite UV
    // ------------------------------------------------------------------------

    float2 spriteUV =
        centeredDistortion
        * safeDistortionScale
        + baseSpriteUV;

    // If the multiply/add somehow produced NaN, fall back to the original
    // undistorted sprite coordinate.
    spriteUV =
        SanitizeUV(
            spriteUV,
            baseSpriteUV
        );


    // ------------------------------------------------------------------------
    // 5. Preserve original sprite-region clamping
    // ------------------------------------------------------------------------

    float2 minimumSpriteUV =
        spriteUVBounds.xy;

    float2 maximumSpriteUV =
        spriteUVBounds.zw;

    spriteUV =
        max(
            minimumSpriteUV,
            spriteUV
        );

    spriteUV =
        min(
            maximumSpriteUV,
            spriteUV
        );

    // One final safety pass before sampling t5.
    spriteUV =
        SanitizeUV(
            spriteUV,
            baseSpriteUV
        );


    // ------------------------------------------------------------------------
    // 6. Sample and sanitize the sprite
    // ------------------------------------------------------------------------

    float4 spriteColor =
        SpriteTexture.Sample(
            SpriteSampler,
            spriteUV
        );

    spriteColor =
        SanitizePositiveFinite(
            spriteColor
        );


    // ------------------------------------------------------------------------
    // 7. Sample and sanitize the HDR scene
    // ------------------------------------------------------------------------

    float4 sceneColor =
        SceneTexture.Sample(
            SceneSampler,
            sceneUV
        );

    sceneColor =
        SanitizePositiveFinite(
            sceneColor
        );


    // ------------------------------------------------------------------------
    // 8. Original sprite modulation
    // ------------------------------------------------------------------------
    //
    // Original shader:
    //
    //     output = sceneColor * spriteColor;
    //
    // Both operands are now guaranteed to be finite positive values, so:
    //
    //     INF * 0
    //
    // can no longer create a NaN.

    float4 modulatedColor =
        sceneColor
        * spriteColor;


    // ------------------------------------------------------------------------
    // 9. Final finite guard
    // ------------------------------------------------------------------------
    //
    // This normally does nothing because both operands were already sanitized.
    // It is retained as a final defense against overflow in the multiplication.

    outputColor =
        SanitizePositiveFinite(
            modulatedColor
        );

    return;
}
