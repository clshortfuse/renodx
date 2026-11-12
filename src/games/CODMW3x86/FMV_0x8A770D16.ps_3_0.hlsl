//
// Generated from:
// Microsoft (R) HLSL Shader Compiler 9.29.952.3111
//
// Call of Duty: Modern Warfare 3 (2011)
// RenoDX FMV HDR replacement
//
// SM3-safe version.
//
// Changes:
// - Preserves original Y / Cr / Cb / Alpha sampling.
// - Preserves original YCbCr -> RGB conversion exactly.
// - Preserves original COLOR0 tint/fade.
// - Preserves original alpha.
// - No additional limited-range conversion.
// - Does NOT use renodx::draw::UpscaleVideoPass().
// - Performs BT.2446a video ITM directly.
// - SDR / Vanilla mode remains original.
// - HDR values above 1.0 are preserved.
//
// Target:
//   ps_3_0
//

#include "./shared.h"


// =============================================================================
// ORIGINAL CINEMATIC SAMPLERS
// =============================================================================

sampler2D cinematicYSampler  : register(s4);
sampler2D cinematicCrSampler : register(s5);
sampler2D cinematicCbSampler : register(s6);
sampler2D cinematicASampler  : register(s7);


// =============================================================================
// VIDEO ITM SETTINGS
// =============================================================================

// Standard SDR video mastering level.
#define VIDEO_SDR_NITS 100.0f

// RenoDX reference white used for the video expansion.
#define VIDEO_REFERENCE_WHITE_NITS 203.0f


// =============================================================================
// SM3-SAFE VIDEO ITM
// =============================================================================
//
// This is deliberately written without:
//
//     renodx::draw::UpscaleVideoPass()
//
// because the one-argument overload invokes BuildConfig(), which pulls in a
// large RenoDX Config structure. That's unnecessary for this very small
// ps_3_0 cinematic shader.
//
// Instead we use only:
//
//     RENODX_TONE_MAP_TYPE
//     RENODX_PEAK_WHITE_NITS
//     RENODX_DIFFUSE_WHITE_NITS
//
// The actual BT.2446a implementation still comes from RenoDX.
//

float3 ApplyVideoITM(float3 videoColor)
{
    // -------------------------------------------------------------------------
    // VANILLA / SDR
    // -------------------------------------------------------------------------

    if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_VANILLA)
    {
        return videoColor;
    }


    // -------------------------------------------------------------------------
    // INJECTION SAFETY
    // -------------------------------------------------------------------------
    //
    // If this shader gets drawn before the RenoDX constants are populated,
    // don't attempt HDR expansion.
    //

    if (RENODX_PEAK_WHITE_NITS <= 0.0f
        || RENODX_DIFFUSE_WHITE_NITS <= 0.0f)
    {
        return videoColor;
    }


    // -------------------------------------------------------------------------
    // SDR SOURCE SANITIZATION
    // -------------------------------------------------------------------------
    //
    // The YCbCr conversion can create tiny negative/over-1 values.
    //
    // This is only a SOURCE clamp.
    //
    // There is deliberately NO clamp after the inverse tonemapper.
    //

    videoColor = saturate(videoColor);


    // -------------------------------------------------------------------------
    // GAMMA 2.4 -> LINEAR
    // -------------------------------------------------------------------------
    //
    // BT.2446a expects the SDR video signal in linear light.
    //

    videoColor =
        renodx::color::gamma::DecodeSafe(
            videoColor,
            2.4f
        );


    // -------------------------------------------------------------------------
    // HDR VIDEO PEAK
    // -------------------------------------------------------------------------

    float peakNits =
        RENODX_PEAK_WHITE_NITS;

    float diffuseNits =
        RENODX_DIFFUSE_WHITE_NITS;


    // Protect against corrupted/uninitialized constants.
    peakNits =
        min(
            max(peakNits, VIDEO_SDR_NITS),
            10000.0f
        );

    diffuseNits =
        min(
            max(diffuseNits, 1.0f),
            peakNits
        );


    // Example:
    //
    // Peak White   = 1000
    // Diffuse White = 203
    //
    // videoPeak = 1000
    //
    float videoPeak =
        peakNits
        /
        (
            diffuseNits
            /
            VIDEO_REFERENCE_WHITE_NITS
        );


    videoPeak =
        max(
            videoPeak,
            VIDEO_SDR_NITS
        );


    // =========================================================================
    // BT.2446A INVERSE TONEMAPPING
    // =========================================================================
    //
    // SDR video:
    //
    //     100 nits
    //
    // gets expanded toward:
    //
    //     videoPeak
    //
    // according to the selected RenoDX display brightness.
    //

    videoColor =
        renodx::tonemap::inverse::bt2446a::BT709(
            videoColor,
            VIDEO_SDR_NITS,
            videoPeak
        );


    // BT2446a returns values expressed relative to its target peak.
    //
    // Normalize so:
    //
    //     1.0 = HDR video peak
    //

    videoColor /= videoPeak;


    // Scale relative to RenoDX diffuse white.
    //
    // With:
    //
    //     peak    = 1000
    //     diffuse = 203
    //
    // the maximum HDR signal becomes roughly:
    //
    //     1000 / 203 = 4.926
    //

    videoColor *=
        peakNits
        /
        diffuseNits;


    // -------------------------------------------------------------------------
    // RETURN TO VIDEO GAMMA
    // -------------------------------------------------------------------------
    //
    // The original cinematic shader outputs gamma-domain RGB.
    //
    // Keep that representation for the following game pipeline.
    //

    videoColor =
        renodx::color::gamma::EncodeSafe(
            max(videoColor, 0.0f),
            2.4f
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
    // =========================================================================
    // ORIGINAL TEXTURE SAMPLING
    // =========================================================================

    float alpha =
        tex2D(
            cinematicASampler,
            v0
        ).x;


    float Cr =
        tex2D(
            cinematicCrSampler,
            v0
        ).x;


    float Cb =
        tex2D(
            cinematicCbSampler,
            v0
        ).x;


    float Y =
        tex2D(
            cinematicYSampler,
            v0
        ).x;


    // =========================================================================
    // ORIGINAL YCbCr -> RGB
    // =========================================================================
    //
    // This directly reproduces the original shader constants:
    //
    // c0:
    //
    //   1.16412354
    //   1.59579468
    //  -0.87065506
    //
    // c1:
    //
    //   1.16412354
    //  -0.813476562
    //  -0.391448975
    //   0.529705048
    //
    // c2:
    //
    //   1.16412354
    //   2.01782227
    //  -1.08166885
    //
    // The offsets are already built into this conversion.
    //
    // DO NOT apply another 16-235 range conversion.
    // =========================================================================

    float3 videoColor;


    // RED
    videoColor.r =
          Y  * 1.16412354f
        + Cr * 1.59579468f
        - 0.87065506f;


    // GREEN
    videoColor.g =
          Y  * 1.16412354f
        - Cr * 0.813476562f
        - Cb * 0.391448975f
        + 0.529705048f;


    // BLUE
    videoColor.b =
          Y  * 1.16412354f
        + Cb * 2.01782227f
        - 1.08166885f;


    // =========================================================================
    // VIDEO-ONLY HDR
    // =========================================================================

    videoColor =
        ApplyVideoITM(
            videoColor
        );


    // =========================================================================
    // ORIGINAL FINAL MULTIPLICATION
    // =========================================================================
    //
    // Original assembly:
    //
    //     mul_pp oC0, r0, v1
    //
    // The cinematic COLOR0 multiplication remains AFTER ITM so things such as
    // fade-to-black continue to behave like the original shader.
    //
    // IMPORTANT:
    // There is no saturate() here because that would destroy the HDR values.
    // =========================================================================

    oC0.rgb =
        videoColor
        * v1.rgb;


    oC0.a =
        alpha
        * v1.a;
}