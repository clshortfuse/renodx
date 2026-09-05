#include "./shared.h"

// Put psychov-24.hlsl here:
//   src/shaders/tonemap/psychov/psychov-24.hlsl
//
// From src/games/residentevil6 this include path should resolve.
#ifndef RENODX_USE_PSYCHOV24
#define RENODX_USE_PSYCHOV24 1
#endif

#if RENODX_USE_PSYCHOV24
#include "../../shaders/tonemap/psychov/psychov-24.hlsl"
#endif

sampler2D SSPoint__tBaseMap : register(s0);
float3 fGamma : register(c1);

#ifndef RENODX_FINAL_USE_TONEMAP
#define RENODX_FINAL_USE_TONEMAP 1
#endif

#ifndef RENODX_FINAL_INPUT_IS_SRGB
#define RENODX_FINAL_INPUT_IS_SRGB 1
#endif

#ifndef RENODX_FINAL_INPUT_IS_EXTENDED_SRGB
#define RENODX_FINAL_INPUT_IS_EXTENDED_SRGB 1
#endif

#ifndef RENODX_FINAL_APPLY_GAME_GAMMA
#define RENODX_FINAL_APPLY_GAME_GAMMA 1
#endif

#ifndef RENODX_FINAL_HDR_BOOST
#define RENODX_FINAL_HDR_BOOST 1.00f
#endif

#ifndef RENODX_FINAL_HDR_BOOST_START
#define RENODX_FINAL_HDR_BOOST_START 1.00f
#endif

#ifndef RENODX_FINAL_HDR_BOOST_END
#define RENODX_FINAL_HDR_BOOST_END 4.00f
#endif


// ------------------------------------------------------------
// HDR -> SDR reference reconstruction
// ------------------------------------------------------------

// Start of the per-channel HDR shoulder used ONLY to construct the
// temporary SDR reference for the original game gamma/post-process.
//
// Values at or below this point are unchanged. Values above it roll
// smoothly toward the configured HDR display peak.
#ifndef RENODX_FINAL_GRADING_HDR_ROLLOFF_START
#define RENODX_FINAL_GRADING_HDR_ROLLOFF_START 1.00f
#endif

// 0.0 = automatically use PeakWhiteNits / DiffuseWhiteNits.
//
// The luminance rolloff maps this exact scene-linear value to SDR 1.0.
#ifndef RENODX_FINAL_GRADING_WHITE_CLIP
#define RENODX_FINAL_GRADING_WHITE_CLIP 0.0f
#endif

// Restores hue after the luminance-tonemapped SDR reference is forced
// into the legal 0..1 SDR cube.
//
// 0.0 = keep ordinary clipped SDR hue
// 1.0 = preserve the hue of the per-channel HDR-rolled reference
#ifndef RENODX_FINAL_GRADING_HUE_CORRECTION
#define RENODX_FINAL_GRADING_HUE_CORRECTION 1.0f
#endif

#ifndef RENODX_VANILLA_CLAMP_TO_SDR
#define RENODX_VANILLA_CLAMP_TO_SDR 1
#endif

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_RENODRT
#define RENODX_TONE_MAP_TYPE_RENODRT 3.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV24
#define RENODX_TONE_MAP_TYPE_PSYCHOV24 24.0f
#endif

#ifndef RENODX_PSYCHOV24_COMPRESSION
#define RENODX_PSYCHOV24_COMPRESSION 4.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_COMPRESSION
#define RENODX_PSYCHOV24_GAMUT_COMPRESSION 1.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_MODE
#define RENODX_PSYCHOV24_GAMUT_MODE 1.0f
#endif

#ifndef RENODX_PSYCHOV24_HIGHLIGHT_SATURATION
#define RENODX_PSYCHOV24_HIGHLIGHT_SATURATION 1.0f
#endif

#ifndef RENODX_PSYCHOV24_GAMUT_HUE_RESTORE
#define RENODX_PSYCHOV24_GAMUT_HUE_RESTORE 0.0f
#endif

#ifndef RENODX_PEAK_WHITE_NITS
#define RENODX_PEAK_WHITE_NITS 1000.0f
#endif

#ifndef RENODX_DIFFUSE_WHITE_NITS
#define RENODX_DIFFUSE_WHITE_NITS 203.0f
#endif

#ifndef RENODX_TONE_MAP_EXPOSURE
#define RENODX_TONE_MAP_EXPOSURE 1.0f
#endif

#ifndef RENODX_TONE_MAP_HIGHLIGHTS
#define RENODX_TONE_MAP_HIGHLIGHTS 1.0f
#endif

#ifndef RENODX_TONE_MAP_SHADOWS
#define RENODX_TONE_MAP_SHADOWS 1.0f
#endif

#ifndef RENODX_TONE_MAP_CONTRAST
#define RENODX_TONE_MAP_CONTRAST 1.0f
#endif

#ifndef RENODX_TONE_MAP_SATURATION
#define RENODX_TONE_MAP_SATURATION 1.0f
#endif

#ifndef RENODX_TONE_MAP_HUE_CORRECTION
#define RENODX_TONE_MAP_HUE_CORRECTION 1.0f
#endif

// ------------------------------------------------------------
// Safety helpers
// ------------------------------------------------------------

float SafeFinite1(float v)
{
    // NaN is the only value where v != v.
    v = (v == v) ? v : 0.0f;

    // Avoid feeding extreme values into pow/log-based tonemappers.
    return min(max(v, 0.0f), 65504.0f);
}

float3 SafePositive(float3 c)
{
    return float3(
        SafeFinite1(c.r),
        SafeFinite1(c.g),
        SafeFinite1(c.b)
    );
}

float GetMaxChannel(float3 c)
{
    return max(max(c.r, c.g), c.b);
}

float SmoothStep01(float x)
{
    x = saturate(x);
    return x * x * (3.0f - 2.0f * x);
}

bool IsToneMapType(float type_value)
{
    return abs(RENODX_TONE_MAP_TYPE - type_value) < 0.5f;
}

bool IsPsychoV24Mode()
{
    return IsToneMapType(RENODX_TONE_MAP_TYPE_PSYCHOV24);
}

int GetPsychoV24GamutMode()
{
    return (RENODX_PSYCHOV24_GAMUT_MODE >= 0.5f) ? 1 : 0;
}

// ------------------------------------------------------------
// Original shader sRGB decode
// ------------------------------------------------------------

float SRGBToLinear1_NoSaturate(float c)
{
    c = SafeFinite1(c);

    float lo = c * 0.07739938f;
    float hi = pow(max((c + 0.055f) * 0.9478673f, 0.0f), 2.4f);

    return (c <= 0.03928f) ? lo : hi;
}

float3 SRGBToLinear3_NoSaturate(float3 c)
{
    return float3(
        SRGBToLinear1_NoSaturate(c.r),
        SRGBToLinear1_NoSaturate(c.g),
        SRGBToLinear1_NoSaturate(c.b)
    );
}

float SRGBToLinear1_HDRSafe(float c)
{
    c = SafeFinite1(c);

    // HDR path only:
    // Values above 1.0 can be treated as already-linear HDR.
    if (c > 1.0f)
    {
        return c;
    }

    float lo = c * 0.07739938f;
    float hi = pow(max((c + 0.055f) * 0.9478673f, 0.0f), 2.4f);

    return (c <= 0.03928f) ? lo : hi;
}

float3 SRGBToLinear3_HDRSafe(float3 c)
{
    return float3(
        SRGBToLinear1_HDRSafe(c.r),
        SRGBToLinear1_HDRSafe(c.g),
        SRGBToLinear1_HDRSafe(c.b)
    );
}

// ------------------------------------------------------------
// Original shader sRGB encode
// ------------------------------------------------------------

float LinearToSRGB1(float c)
{
    c = SafeFinite1(c);

    float lo = c * 12.92f;
    float hi = pow(c, 1.0f / 2.4f) * 1.055f - 0.055f;

    return (c <= 0.0031308f) ? lo : hi;
}

float3 LinearToSRGB3(float3 c)
{
    return float3(
        LinearToSRGB1(c.r),
        LinearToSRGB1(c.g),
        LinearToSRGB1(c.b)
    );
}

// ------------------------------------------------------------
// Original game gamma
// ------------------------------------------------------------

float3 ApplyOriginalGameGamma(float3 c)
{
    c = max(SafePositive(c), 0.000001f);

    float gamma = max(fGamma.x, 0.000001f);

    // Original shader behavior:
    // decoded_color -> pow(decoded_color, fGamma.x)
    c.r = pow(c.r, gamma);
    c.g = pow(c.g, gamma);
    c.b = pow(c.b, gamma);

    return SafePositive(c);
}

// ------------------------------------------------------------
// Vanilla SDR branch
// ------------------------------------------------------------

float3 ApplyOriginalVanillaTonemapperSDR(float3 encoded_color)
{
#if RENODX_VANILLA_CLAMP_TO_SDR
    // Simulate the original SDR render target.
    encoded_color = saturate(encoded_color);
#endif

    // Original shader:
    // sRGB decode -> fGamma -> sRGB encode
    float3 linear_color = SRGBToLinear3_NoSaturate(encoded_color);
    linear_color = ApplyOriginalGameGamma(linear_color);

    float3 output_color = LinearToSRGB3(linear_color);

#if RENODX_VANILLA_CLAMP_TO_SDR
    output_color = saturate(output_color);
#endif

    return output_color;
}

// ------------------------------------------------------------
// HDR input decode
// ------------------------------------------------------------

float3 DecodeFinalInputForHDR(float3 c)
{
    c = SafePositive(c);

#if RENODX_FINAL_INPUT_IS_SRGB
    #if RENODX_FINAL_INPUT_IS_EXTENDED_SRGB
        // Original-like decode for all positive values.
        // This matches the previous HDR branch behavior before the vanilla SDR clamp.
        c = SRGBToLinear3_NoSaturate(c);
    #else
        // Decode SDR range, preserve >1.0 HDR.
        c = SRGBToLinear3_HDRSafe(c);
    #endif
#endif

    return SafePositive(c);
}

float3 ApplyHDRBoost(float3 c)
{
    c = SafePositive(c);

    float max_channel = GetMaxChannel(c);

    float range = max(
        RENODX_FINAL_HDR_BOOST_END - RENODX_FINAL_HDR_BOOST_START,
        0.000001f
    );

    float boost_mask = SmoothStep01(
        (max_channel - RENODX_FINAL_HDR_BOOST_START) / range
    );

    float boost_scale = lerp(
        1.0f,
        RENODX_FINAL_HDR_BOOST,
        boost_mask
    );

    return SafePositive(c * boost_scale);
}


// ------------------------------------------------------------
// SDR-reference / RestorePostProcess helpers
// ------------------------------------------------------------

static const float3 RENODX_FINAL_LUMINANCE_WEIGHTS =
    float3(0.2126f, 0.7152f, 0.0722f);

float GetFinalLuminance(float3 color)
{
    return dot(
        max(color, 0.0f.xxx),
        RENODX_FINAL_LUMINANCE_WEIGHTS
    );
}

float GetFinalHDRPeakValue()
{
    return max(
        RENODX_PEAK_WHITE_NITS
        / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
        1.0f
    );
}

float GetFinalGradingWhiteClip()
{
    if (RENODX_FINAL_GRADING_WHITE_CLIP > 1.0f)
    {
        return RENODX_FINAL_GRADING_WHITE_CLIP;
    }

    return max(
        GetFinalHDRPeakValue(),
        1.0001f
    );
}

// Per-channel shoulder used before converting the HDR signal to the SDR
// post-process reference.
//
// At the shoulder the slope is 1.0. At very large values the result
// asymptotically approaches hdr_peak.
float FinalRolloffChannelToHDRPeak(
    float value,
    float hdr_peak
)
{
    value = max(value, 0.0f);
    hdr_peak = max(hdr_peak, 1.0001f);

    float rolloff_start = clamp(
        RENODX_FINAL_GRADING_HDR_ROLLOFF_START,
        0.0f,
        hdr_peak - 0.0001f
    );

    if (value <= rolloff_start)
    {
        return value;
    }

    float shoulder_range =
        hdr_peak - rolloff_start;

    float excess =
        value - rolloff_start;

    float compressed_excess =
        shoulder_range
        * excess
        / max(
            excess + shoulder_range,
            0.000001f
        );

    return rolloff_start + compressed_excess;
}

float3 FinalPerChannelRolloffToHDRPeak(
    float3 color,
    float hdr_peak
)
{
    color = SafePositive(color);

    return SafePositive(
        float3(
            FinalRolloffChannelToHDRPeak(color.r, hdr_peak),
            FinalRolloffChannelToHDRPeak(color.g, hdr_peak),
            FinalRolloffChannelToHDRPeak(color.b, hdr_peak)
        )
    );
}

// Extended-Reinhard luminance shoulder.
//
// f(W) == 1.0 exactly, so white_clip is the exact scene-linear value
// that becomes SDR white.
//
// RGB is scaled by one luminance ratio, so this stage itself preserves hue.
float FinalExactWhiteClipRolloff(
    float value,
    float white_clip
)
{
    value = max(value, 0.0f);
    white_clip = max(white_clip, 0.0001f);

    float white_clip_squared =
        white_clip * white_clip;

    float mapped =
        value
        * (1.0f + value / white_clip_squared)
        / (1.0f + value);

    return saturate(mapped);
}

float3 FinalRolloffToSDRByLuminance(
    float3 hdr_color,
    float white_clip
)
{
    hdr_color = SafePositive(hdr_color);

    float hdr_luminance =
        GetFinalLuminance(hdr_color);

    if (hdr_luminance <= 0.000001f)
    {
        return 0.0f.xxx;
    }

    float sdr_luminance =
        FinalExactWhiteClipRolloff(
            hdr_luminance,
            white_clip
        );

    float luminance_scale =
        sdr_luminance
        / hdr_luminance;

    return SafePositive(
        hdr_color * luminance_scale
    );
}

// The luminance shoulder can still leave an individual RGB channel above 1.
// Build the real clipped SDR representation, then restore the hue ratios from
// the per-channel HDR-rolled reference without allowing values above SDR white.
float3 FinalCorrectSDRBlowoutHue(
    float3 hue_reference,
    float3 clipped_sdr
)
{
    hue_reference = SafePositive(hue_reference);
    clipped_sdr = saturate(clipped_sdr);

    float reference_max =
        GetMaxChannel(hue_reference);

    float clipped_max =
        GetMaxChannel(clipped_sdr);

    if (
        reference_max <= 0.000001f
        || clipped_max <= 0.000001f
    )
    {
        return clipped_sdr;
    }

    float3 hue_preserved =
        hue_reference
        * (clipped_max / reference_max);

    hue_preserved =
        saturate(hue_preserved);

    return lerp(
        clipped_sdr,
        hue_preserved,
        saturate(RENODX_FINAL_GRADING_HUE_CORRECTION)
    );
}

// Run the exact original SDR gamma/post-process on a legal linear-SDR
// reference and return the result in linear light.
//
// The game's post-process is:
//   linear -> sRGB encode -> original shader
//          -> sRGB decode -> fGamma -> sRGB encode
//
// ApplyOriginalVanillaTonemapperSDR() contains the original middle portion.
float3 SampleOriginalGameGammaFromSDRReference(
    float3 linear_sdr_reference
)
{
    linear_sdr_reference =
        saturate(
            SafePositive(linear_sdr_reference)
        );

    float3 encoded_reference =
        LinearToSRGB3(
            linear_sdr_reference
        );

    float3 graded_encoded =
        ApplyOriginalVanillaTonemapperSDR(
            encoded_reference
        );

    return SafePositive(
        SRGBToLinear3_NoSaturate(
            graded_encoded
        )
    );
}

// Restore both the luminance and chrominance change measured from the SDR
// post-process onto the real HDR signal.
//
// This replaces the old strategy of directly applying fGamma to the HDR
// signal. The SDR post-process is sampled in its native range, while the
// original HDR luminance range remains available for RenoDRT/PsychoV24.
float3 RestoreFinalPostProcess(
    float3 hdr_source,
    float3 sdr_before_post_process,
    float3 sdr_after_post_process
)
{
    hdr_source =
        SafePositive(hdr_source);

    sdr_before_post_process =
        SafePositive(sdr_before_post_process);

    sdr_after_post_process =
        SafePositive(sdr_after_post_process);

    float hdr_luminance =
        GetFinalLuminance(hdr_source);

    float before_luminance =
        GetFinalLuminance(sdr_before_post_process);

    float after_luminance =
        GetFinalLuminance(sdr_after_post_process);

    // Near black there is not enough stable normalized chroma information.
    // Use the measured linear post-process delta instead.
    if (
        hdr_luminance <= 0.000001f
        || before_luminance <= 0.000001f
        || after_luminance <= 0.000001f
    )
    {
        return SafePositive(
            hdr_source
            + (
                sdr_after_post_process
                - sdr_before_post_process
            )
        );
    }

    // Luminance change produced by the original post-process.
    float luminance_ratio =
        after_luminance
        / before_luminance;

    float restored_luminance =
        hdr_luminance
        * luminance_ratio;

    // Luminance-normalized RGB acts as a simple chrominance representation.
    float3 hdr_chrominance =
        hdr_source
        / hdr_luminance;

    float3 before_chrominance =
        sdr_before_post_process
        / before_luminance;

    float3 after_chrominance =
        sdr_after_post_process
        / after_luminance;

    float3 chrominance_delta =
        after_chrominance
        - before_chrominance;

    float3 restored_chrominance =
        max(
            hdr_chrominance
            + chrominance_delta,
            0.0f.xxx
        );

    float3 restored_color =
        restored_chrominance
        * restored_luminance;

    // max(..., 0) can slightly alter luminance. Renormalize so the measured
    // luminance delta remains exact.
    float actual_luminance =
        GetFinalLuminance(restored_color);

    if (actual_luminance > 0.000001f)
    {
        restored_color *=
            restored_luminance
            / actual_luminance;
    }

    return SafePositive(restored_color);
}

// ------------------------------------------------------------
// PsychoV24 HDR branch
// ------------------------------------------------------------

float3 ApplyPsychoV24HDRTonemap(float3 hdr_color)
{
    hdr_color = SafePositive(hdr_color);

#if RENODX_USE_PSYCHOV24
    // PsychoV24 expects BT.709 scene-linear input.
    // peak_value is scene-linear where diffuse white is 1.0.
    float peak_value = max(
        RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
        1.0f
    );

    hdr_color = renodx::tonemap::psychov::psychotm_test24(
        hdr_color,
        peak_value,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        1.0f,                                  // bleaching_intensity, reserved
        100.0f,                                // clip_point, reserved
        RENODX_TONE_MAP_HUE_CORRECTION,
        1.0f,                                  // adaptation_contrast, deprecated
        0,                                     // white_curve_mode, deprecated
        RENODX_PSYCHOV24_CONE_RESPONSE,        // cone_response_exponent; 1.0 = neutral
        0.18f.xxx,                             // current adaptive state / anchor-in
        0.18f.xxx,                             // desired background state / anchor-out
        RENODX_PSYCHOV24_GAMUT_COMPRESSION,
        GetPsychoV24GamutMode(),
        1.0f,                                  // adaptive_normalization, deprecated
        RENODX_PSYCHOV24_COMPRESSION,          // 0.0 = auto, 4.0 is your bright manual default
        RENODX_PSYCHOV24_HIGHLIGHT_SATURATION, // Test24 highlight saturation
        RENODX_PSYCHOV24_GAMUT_HUE_RESTORE     // Test24 gamut hue restoration
    );
#endif

    return SafePositive(hdr_color);
}

// ------------------------------------------------------------
// RenoDX RenoDRT HDR branch
// ------------------------------------------------------------

float3 ApplyRenoDXHDRTonemap(float3 hdr_color)
{
    hdr_color = SafePositive(hdr_color);

#if RENODX_FINAL_USE_TONEMAP
    renodx::draw::Config config = renodx::draw::BuildConfig();

    config.reno_drt_tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;

    hdr_color = renodx::draw::ToneMapPass(hdr_color, config);
#endif

    return SafePositive(hdr_color);
}

// ------------------------------------------------------------
// Main
// ------------------------------------------------------------

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    float4 color = tex2D(SSPoint__tBaseMap, texcoord);

    // ------------------------------------------------------------
    // Vanilla mode:
    //
    // Original SDR behavior.
    // Clamped 0-1.
    // No HDR.
    // No RenoDX ToneMapPass.
    // No RenderIntermediatePass.
    // ------------------------------------------------------------

    if (RENODX_TONE_MAP_TYPE < 0.5f)
    {
        color.rgb = ApplyOriginalVanillaTonemapperSDR(color.rgb);
        color.a = saturate(color.a);
        return color;
    }

    // ------------------------------------------------------------
    // HDR modes:
    //
    // RenoDRT / PsychoV24:
    //   Decode final input
    //   -> HDR boost
    //   -> per-channel rolloff to HDR peak
    //   -> exact-white-clip luminance rolloff to SDR
    //   -> hue-correct SDR blowout
    //   -> sample original fGamma post-process in SDR
    //   -> restore its luminance + chrominance deltas onto HDR
    //   -> selected HDR display mapper
    //   -> RenderIntermediatePass.
    // ------------------------------------------------------------

    // Decode the real HDR signal first. This stays available at full
    // scene-linear range; the SDR rolloffs below are used only to construct
    // a temporary reference for sampling the game's original post-process.
    float3 hdr_color =
        DecodeFinalInputForHDR(
            color.rgb
        );

    // Treat HDR boost as a pre-tonemap control, matching the newer
    // LUT/post-process reconstruction path.
    hdr_color =
        ApplyHDRBoost(
            hdr_color
        );

#if RENODX_FINAL_APPLY_GAME_GAMMA

    // ------------------------------------------------------------
    // 1. Per-channel rolloff toward HDR peak
    // ------------------------------------------------------------

    float hdr_peak =
        GetFinalHDRPeakValue();

    float3 per_channel_reference =
        FinalPerChannelRolloffToHDRPeak(
            hdr_color,
            hdr_peak
        );


    // ------------------------------------------------------------
    // 2. Exact-white-clip luminance rolloff into SDR
    // ------------------------------------------------------------

    float grading_white_clip =
        GetFinalGradingWhiteClip();

    float3 sdr_luminance_reference =
        FinalRolloffToSDRByLuminance(
            per_channel_reference,
            grading_white_clip
        );


    // ------------------------------------------------------------
    // 3. Fit to SDR and hue-correct channel blowout
    // ------------------------------------------------------------

    float3 clipped_sdr_reference =
        saturate(
            sdr_luminance_reference
        );

    float3 sdr_reference =
        FinalCorrectSDRBlowoutHue(
            per_channel_reference,
            clipped_sdr_reference
        );

    sdr_reference =
        saturate(
            sdr_reference
        );


    // ------------------------------------------------------------
    // 4. Sample the original game gamma/post-process in SDR
    // ------------------------------------------------------------

    float3 graded_sdr =
        SampleOriginalGameGammaFromSDRReference(
            sdr_reference
        );


    // ------------------------------------------------------------
    // 5. Restore post-process luminance + chrominance onto HDR
    // ------------------------------------------------------------

    hdr_color =
        RestoreFinalPostProcess(
            hdr_color,
            sdr_reference,
            graded_sdr
        );

#endif


    // ------------------------------------------------------------
    // 6. Selected HDR display mapper
    // ------------------------------------------------------------

#if RENODX_USE_PSYCHOV24
    if (IsPsychoV24Mode())
    {
        hdr_color =
            ApplyPsychoV24HDRTonemap(
                hdr_color
            );
    }
    else
    {
        hdr_color =
            ApplyRenoDXHDRTonemap(
                hdr_color
            );
    }
#else
    // If PsychoV24 was not compiled in, never leave the HDR path untonemapped.
    hdr_color =
        ApplyRenoDXHDRTonemap(
            hdr_color
        );
#endif

    color.rgb = renodx::draw::RenderIntermediatePass(SafePositive(hdr_color));
    color.a = saturate(color.a);
    return color;
}
