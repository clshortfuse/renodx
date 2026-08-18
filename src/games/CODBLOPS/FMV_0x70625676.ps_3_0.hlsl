//
// Generated from:
// Microsoft (R) D3DX9 Shader Compiler 9.15.779.0000
//
// RenoDX HDR FMV replacement
//
// Original shader:
// - Samples cinematic Y / Cr / Cb / Alpha planes.
// - Reconstructs SDR RGB.
// - Supports the game's cinematic blur-box coordinate behavior.
// - Multiplies the resulting movie by the original vertex color.
//
// RenoDX changes:
// - Keeps the original video decoding unchanged.
// - DOES NOT add any extra limited-range correction.
// - Applies RenoDX BT.2446a inverse tone mapping only to the
//   reconstructed FMV RGB.
// - Applies ITM before v1 COLOR multiplication so original cinematic
//   fades/tints remain in the same place in the pipeline.
// - Vanilla mode remains SDR.
// - Alpha behavior remains original.
//
// Target: ps_3_0
//

#include "./shared.h"


// =============================================================================
// ORIGINAL CONSTANTS
// =============================================================================

float4 cinematicBlurBox  : register(c5);
float4 cinematicBlurBox2 : register(c6);


// =============================================================================
// ORIGINAL VIDEO SAMPLERS
// =============================================================================

sampler2D cinematicYSampler  : register(s1);
sampler2D cinematicCrSampler : register(s2);
sampler2D cinematicCbSampler : register(s3);
sampler2D cinematicASampler  : register(s4);


// =============================================================================
// VIDEO ITM
// =============================================================================
//
// Do not perform an additional 16-235 conversion here.
//
// The original YCbCr conversion below already contains the appropriate
// offsets/scaling:
//
// R = 1.16412354 * Y
//   + 1.59579468 * Cr
//   - 0.87065506
//
// G = 1.16412354 * Y
//   - 0.813476562 * Cr
//   - 0.391448975 * Cb
//   + 0.529705048
//
// B = 1.16412354 * Y
//   + 2.01782227 * Cb
//   - 1.08166885
//
// Those bias terms already account for the encoded YCbCr black/chroma
// offsets. Applying another limited-range conversion would double-correct it.
//

float3 ApplyVideoITM(float3 videoColor)
{
    // Vanilla / SDR mode.
    if (RENODX_TONE_MAP_TYPE == 0.0f)
    {
        return videoColor;
    }


    // YCbCr conversion can produce tiny negative values around black.
    // Remove only invalid negative light.
    //
    // Do NOT apply a separate limited-range remap.
    videoColor = max(videoColor, 0.0f);


    // The actual source movie is SDR, so values supplied to the inverse
    // tonemapper should remain in the SDR display range.
    videoColor = min(videoColor, 1.0f);


    // RenoDX video-specific inverse tone mapping.
    //
    // Current RenoDX UpscaleVideoPass performs:
    //
    //     gamma 2.4 decode
    //          ->
    //     BT.2446a inverse tonemap
    //          ->
    //     Peak White / Diffuse White scaling
    //          ->
    //     gamma 2.4 encode
    //
    videoColor =
        renodx::draw::UpscaleVideoPass(
            videoColor
        );


    return videoColor;
}


// =============================================================================
// MAIN
// =============================================================================

void main(
    float2 v0 : TEXCOORD0,
    float4 v1 : COLOR0,
    out float4 oC0 : COLOR0)
{
    float4 r0;
    float4 r1;
    float4 r2;


    // =========================================================================
    // ORIGINAL CINEMATIC BLUR-BOX COORDINATE LOGIC
    // =========================================================================
    //
    // Original assembly:
    //
    // add r0, v0.xxyy, -c6.xzyw
    // cmp r0, r0, c0.xyxy, c0.yxyx
    // mul r0.y, r0.y, r0.x
    // mul r2.w, r0.z, r0.y
    //

    float4 testBox2 =
        v0.xxyy
        - cinematicBlurBox2.xzyw;


    r0.x =
        (testBox2.x >= 0.0f)
        ? 1.0f
        : 0.0f;

    r0.y =
        (testBox2.y >= 0.0f)
        ? 0.0f
        : 1.0f;

    r0.z =
        (testBox2.z >= 0.0f)
        ? 1.0f
        : 0.0f;

    r0.w =
        (testBox2.w >= 0.0f)
        ? 0.0f
        : 1.0f;


    r0.y *= r0.x;
    r2.w = r0.z * r0.y;


    // -------------------------------------------------------------------------
    // First cinematic blur box
    // -------------------------------------------------------------------------

    float4 testBox1 =
        v0.xxyy
        - cinematicBlurBox.xzyw;


    r1.x =
        (testBox1.x >= 0.0f)
        ? 1.0f
        : 0.0f;

    r1.y =
        (testBox1.y >= 0.0f)
        ? 0.0f
        : 1.0f;

    r1.z =
        (testBox1.z >= 0.0f)
        ? 1.0f
        : 0.0f;

    r1.w =
        (testBox1.w >= 0.0f)
        ? 0.0f
        : 1.0f;


    // =========================================================================
    // ORIGINAL 40x40 COORDINATE QUANTIZATION
    // =========================================================================

    r0.xy = v0.xy * 40.0f;


    // Build first blur-box mask.
    r0.z = r1.y * r1.x;


    // Fractional 40x40 position.
    r1.xy = frac(r0.xy);


    r0.z = r1.z * r0.z;


    // Remove fractional part.
    r0.xy -= r1.xy;


    r0.z = r1.w * r0.z;


    // Convert quantized position back into normalized coordinates.
    r1.xy = r0.xy * 0.025f;


    // Complete second box mask.
    r0.w *= r2.w;


    // -------------------------------------------------------------------------
    // Original:
    //
    // cmp r0.xy, -r0.z, v0, r1
    //
    // If we're inside cinematicBlurBox, use the quantized coordinates.
    // Otherwise use the original coordinates.
    // -------------------------------------------------------------------------

    if (r0.z > 0.0f)
    {
        r0.xy = r1.xy;
    }
    else
    {
        r0.xy = v0.xy;
    }


    // -------------------------------------------------------------------------
    // Original:
    //
    // cmp r0.xy, -r0.w, r0, r1
    //
    // cinematicBlurBox2 can also force the quantized coordinates.
    // -------------------------------------------------------------------------

    if (r0.w > 0.0f)
    {
        r0.xy = r1.xy;
    }


    // =========================================================================
    // ORIGINAL CINEMATIC PLANE SAMPLING
    // =========================================================================

    float Y =
        tex2D(
            cinematicYSampler,
            r0.xy
        ).x;


    float Cr =
        tex2D(
            cinematicCrSampler,
            r0.xy
        ).x;


    float Cb =
        tex2D(
            cinematicCbSampler,
            v0.xy
        ).x;


    float alpha =
        tex2D(
            cinematicASampler,
            v0.xy
        ).x;


    // =========================================================================
    // ORIGINAL YCbCr -> RGB CONVERSION
    // =========================================================================
    //
    // This reproduces:
    //
    // def c1, 1.16412354,  1.59579468, -0.87065506, 0
    //
    // def c2, 1.16412354, -0.813476562,
    //         -0.391448975, 0.529705048
    //
    // def c3, 1.16412354,  2.01782227,
    //         -1.08166885, 0
    //
    //
    // IMPORTANT:
    //
    // The offsets already contain the video's encoded black/chroma
    // correction.
    //
    // Therefore there is intentionally NO extra:
    //
    //     (Y - 16/255) / (235/255 - 16/255)
    //
    // conversion in this shader.
    // =========================================================================


    float3 videoColor;


    // R
    videoColor.r =
          1.16412354f * Y
        + 1.59579468f * Cr
        - 0.87065506f;


    // G
    videoColor.g =
          1.16412354f  * Y
        - 0.813476562f * Cr
        - 0.391448975f * Cb
        + 0.529705048f;


    // B
    videoColor.b =
          1.16412354f * Y
        + 2.01782227f * Cb
        - 1.08166885f;


    // =========================================================================
    // RENO DX VIDEO-ONLY INVERSE TONEMAPPING
    // =========================================================================
    //
    // This occurs AFTER YCbCr -> RGB.
    //
    // This occurs BEFORE v1 COLOR multiplication.
    //
    // Therefore things such as:
    //
    //     cinematic fade to black
    //     vertex brightness
    //     tinting
    //
    // remain after the ITM exactly where they existed in the original
    // pipeline.
    // =========================================================================

    videoColor = ApplyVideoITM(videoColor);


    // =========================================================================
    // ORIGINAL FINAL COLOR MULTIPLICATION
    // =========================================================================
    //
    // Original:
    //
    //     mul_pp oC0, r0, v1
    //
    // RGB gets vertex color/tint.
    // Alpha gets cinematic alpha * vertex alpha.
    // =========================================================================

    oC0.rgb = videoColor * v1.rgb;
    oC0.a   = alpha * v1.a;
}