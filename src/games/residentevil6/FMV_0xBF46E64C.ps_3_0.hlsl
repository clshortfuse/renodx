//
// Generated from:
// Microsoft (R) HLSL Shader Compiler 9.29.952.3111
//
// Resident Evil 6
// RenoDX FMV / Image Plane HDR replacement
//
// Original shader:
//   texture sample
//       ->
//   sRGB decode
//       ->
//   multiply by fImagePlaneColor
//       ->
//   sRGB encode
//       ->
//   output
//
// HDR replacement:
//   texture sample
//       ->
//   sRGB decode
//       ->
//   BT.2446a inverse tone mapping
//       ->
//   multiply by fImagePlaneColor
//       ->
//   sRGB encode
//       ->
//   HDR output
//
// Notes:
// - No YUV conversion is required.
// - No limited-range correction is applied.
// - No UpscaleVideoPass()/BuildConfig() is used.
// - The existing sRGB conversion is preserved.
// - fImagePlaneColor remains AFTER ITM so fades/tints are not interpreted
//   as actual source-video luminance.
// - Vanilla mode preserves the original SDR path.
// - No final 0-1 clamp is used.
//
// Target:
//   ps_3_0
//

#include "./shared.h"


// =============================================================================
// ORIGINAL PARAMETERS
// =============================================================================

float4 fImagePlaneColor : register(c1);

sampler2D SSFilter__tBaseMap : register(s0);


// =============================================================================
// VIDEO ITM CONSTANTS
// =============================================================================

#define VIDEO_SDR_PEAK_NITS        100.0f
#define VIDEO_REFERENCE_WHITE_NITS 203.0f


// =============================================================================
// ORIGINAL sRGB TRANSFER FUNCTIONS
// =============================================================================
//
// These reproduce the transfer functions implemented by the original shader.
//
// Original decode constants:
//
//   0.03928
//   1 / 12.92 = 0.0773993805
//   0.055
//   1 / 1.055 = 0.947867274
//   gamma = 2.4
//
// Original encode constants:
//
//   0.003131
//   12.92
//   1 / 2.4
//   1.055
//   -0.055
//
// Scalar versions are used intentionally for ps_3_0 compatibility.
// =============================================================================

float DecodeSRGBChannel(float color)
{
    if (color <= 0.0392800011f)
    {
        return color * 0.0773993805f;
    }

    return pow(
        (color + 0.0549999997f) * 0.947867274f,
        2.4000001f
    );
}


float3 DecodeSRGB(float3 color)
{
    float3 output;

    output.r = DecodeSRGBChannel(color.r);
    output.g = DecodeSRGBChannel(color.g);
    output.b = DecodeSRGBChannel(color.b);

    return output;
}


float EncodeSRGBChannel(float color)
{
    // Prevent invalid pow() input without clamping HDR highlights.
    color = max(color, 0.0f);

    if (color <= 0.00313100009f)
    {
        return color * 12.9200001f;
    }

    return
        1.05499995f
        * pow(color, 0.416666657f)
        - 0.0549999997f;
}


float3 EncodeSRGB(float3 color)
{
    float3 output;

    output.r = EncodeSRGBChannel(color.r);
    output.g = EncodeSRGBChannel(color.g);
    output.b = EncodeSRGBChannel(color.b);

    return output;
}


// =============================================================================
// SM3-SAFE LINEAR VIDEO ITM
// =============================================================================
//
// IMPORTANT:
//
// Unlike the previous YUV cinematic shaders, this RE6 shader already converts
// its source from sRGB to linear.
//
// RenoDX UpscaleVideoPass normally does:
//
//   gamma input
//       ->
//   gamma 2.4 decode
//       ->
//   BT.2446a
//       ->
//   normalize
//       ->
//   HDR scaling
//       ->
//   gamma encode
//
// Here we are already linear, so we deliberately skip both the initial gamma
// decode and final gamma encode.
//
// The original RE6 shader performs its own final sRGB encoding afterward.
// =============================================================================

float3 ApplyVideoITMLinear(float3 linearVideo)
{
    // -------------------------------------------------------------------------
    // VANILLA / SDR
    // -------------------------------------------------------------------------

    if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_VANILLA)
    {
        return linearVideo;
    }


    // -------------------------------------------------------------------------
    // INJECTION SAFETY
    // -------------------------------------------------------------------------

    if (
        RENODX_PEAK_WHITE_NITS <= 0.0f
        || RENODX_DIFFUSE_WHITE_NITS <= 0.0f
    )
    {
        return linearVideo;
    }


    // -------------------------------------------------------------------------
    // SOURCE SDR RANGE
    // -------------------------------------------------------------------------
    //
    // This is the source video before HDR expansion.
    //
    // Constrain only the INPUT to the inverse tone mapper.
    //
    // There is intentionally no 0-1 clamp after ITM.
    // -------------------------------------------------------------------------

    linearVideo = saturate(linearVideo);


    // -------------------------------------------------------------------------
    // RENO DX DISPLAY VALUES
    // -------------------------------------------------------------------------

    float peakNits =
        RENODX_PEAK_WHITE_NITS;

    float diffuseNits =
        RENODX_DIFFUSE_WHITE_NITS;


    // Protect against invalid injection values.
    peakNits =
        min(
            max(
                peakNits,
                VIDEO_SDR_PEAK_NITS
            ),
            10000.0f
        );


    diffuseNits =
        min(
            max(
                diffuseNits,
                1.0f
            ),
            peakNits
        );


    // -------------------------------------------------------------------------
    // VIDEO HDR TARGET
    // -------------------------------------------------------------------------
    //
    // This follows RenoDX's video scaling relationship:
    //
    //     videoPeak =
    //         peak white
    //         /
    //         (diffuse white / 203)
    //
    //
    // Examples:
    //
    // Peak = 1000
    // Diffuse = 203
    //
    // videoPeak = 1000
    //
    //
    // Peak = 1000
    // Diffuse = 250
    //
    // videoPeak ~= 812
    // -------------------------------------------------------------------------

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
            VIDEO_SDR_PEAK_NITS
        );


    // -------------------------------------------------------------------------
    // BT.2446A INVERSE TONEMAPPING
    // -------------------------------------------------------------------------
    //
    // linearVideo is already linear BT.709/sRGB-primary RGB.
    //
    // Do NOT gamma-decode it again.
    // -------------------------------------------------------------------------

    linearVideo =
        renodx::tonemap::inverse::bt2446a::BT709(
            linearVideo,
            VIDEO_SDR_PEAK_NITS,
            videoPeak
        );


    // -------------------------------------------------------------------------
    // NORMALIZE THE BT.2446A OUTPUT
    // -------------------------------------------------------------------------

    linearVideo /= videoPeak;


    // -------------------------------------------------------------------------
    // SCALE INTO RENO DX HDR RANGE
    // -------------------------------------------------------------------------
    //
    // Example:
    //
    // Peak    = 1000
    // Diffuse = 203
    //
    // HDR maximum relative value:
    //
    //     1000 / 203
    //     = 4.926
    //
    // Values above 1.0 are deliberately retained.
    // -------------------------------------------------------------------------

    linearVideo *=
        peakNits
        /
        diffuseNits;


    // Remove only invalid negative light.
    linearVideo =
        max(
            linearVideo,
            0.0f
        );


    return linearVideo;
}


// =============================================================================
// MAIN
// =============================================================================

void main(
    float4 v0 : TEXCOORD0,
    out float4 oC0 : COLOR0)
{
    // =========================================================================
    // ORIGINAL TEXTURE SAMPLE
    // =========================================================================

    float4 sourceColor =
        tex2D(
            SSFilter__tBaseMap,
            v0.zw
        );


    // =========================================================================
    // ORIGINAL sRGB -> LINEAR
    // =========================================================================
    //
    // The disassembled shader does exactly this piecewise conversion before
    // applying fImagePlaneColor.
    // =========================================================================

    float3 linearVideo =
        DecodeSRGB(
            sourceColor.rgb
        );


    // =========================================================================
    // RENO DX VIDEO-ONLY HDR EXPANSION
    // =========================================================================
    //
    // Put ITM here:
    //
    //     AFTER  sRGB decode
    //     BEFORE fImagePlaneColor
    //
    // This is important because fImagePlaneColor may be used for things such
    // as cinematic fades or tinting.
    //
    // Feeding a fade through BT.2446a would cause the inverse tone mapper to
    // reinterpret the fade as different source-video luminance.
    // =========================================================================

    linearVideo =
        ApplyVideoITMLinear(
            linearVideo
        );


    // =========================================================================
    // ORIGINAL IMAGE-PLANE COLOR
    // =========================================================================
    //
    // Original assembly:
    //
    //     mul r1, r0, c1
    //
    // RGB multiplication occurs in linear light.
    //
    // Preserve this placement.
    // =========================================================================

    float3 finalLinear =
        linearVideo
        * fImagePlaneColor.rgb;


    // =========================================================================
    // ORIGINAL LINEAR -> sRGB
    // =========================================================================
    //
    // The original shader converts the image back to sRGB here.
    //
    // The encoding function intentionally supports values >1.0.
    //
    // Therefore an upgraded FP16 render target can retain HDR highlights.
    // =========================================================================

    oC0.rgb =
        EncodeSRGB(
            finalLinear
        );


    // =========================================================================
    // ORIGINAL ALPHA
    // =========================================================================
    //
    // Original:
    //
    //     r1.w = texture alpha * fImagePlaneColor.a
    //     oC0.w = r1.w
    // =========================================================================

    oC0.a =
        sourceColor.a
        * fImagePlaneColor.a;
}