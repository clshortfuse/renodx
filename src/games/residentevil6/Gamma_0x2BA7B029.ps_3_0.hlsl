#include "./shared.h"

// Put psychov-22.hlsl here:
//   src/shaders/tonemap/psychov/psychov-22.hlsl
//
// From src/games/residentevil6 this include path should resolve.
#ifndef RENODX_USE_PSYCHOV22
#define RENODX_USE_PSYCHOV22 1
#endif

#if RENODX_USE_PSYCHOV22
#include "../../shaders/tonemap/psychov/psychov-22.hlsl"
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

#ifndef RENODX_VANILLA_CLAMP_TO_SDR
#define RENODX_VANILLA_CLAMP_TO_SDR 1
#endif

#ifndef RENODX_TONE_MAP_TYPE_VANILLA
#define RENODX_TONE_MAP_TYPE_VANILLA 0.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_RENODRT
#define RENODX_TONE_MAP_TYPE_RENODRT 3.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV22
#define RENODX_TONE_MAP_TYPE_PSYCHOV22 22.0f
#endif

#ifndef RENODX_PSYCHOV22_COMPRESSION
#define RENODX_PSYCHOV22_COMPRESSION 4.0f
#endif

#ifndef RENODX_PSYCHOV22_GAMUT_COMPRESSION
#define RENODX_PSYCHOV22_GAMUT_COMPRESSION 1.0f
#endif

#ifndef RENODX_PSYCHOV22_GAMUT_MODE
#define RENODX_PSYCHOV22_GAMUT_MODE 1.0f
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

bool IsPsychoV22Mode()
{
    return IsToneMapType(RENODX_TONE_MAP_TYPE_PSYCHOV22);
}

int GetPsychoV22GamutMode()
{
    return (RENODX_PSYCHOV22_GAMUT_MODE >= 0.5f) ? 1 : 0;
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
// PsychoV22 HDR branch
// ------------------------------------------------------------

float3 ApplyPsychoV22HDRTonemap(float3 hdr_color)
{
    hdr_color = SafePositive(hdr_color);

#if RENODX_USE_PSYCHOV22
    // PsychoV22 expects BT.709 scene-linear input.
    // peak_value is scene-linear where diffuse white is 1.0.
    float peak_value = max(
        RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
        1.0f
    );

    hdr_color = renodx::tonemap::psychov::psychotm_test22(
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
        RENODX_PSYCHOV22_CONE_RESPONSE,        // cone_response_exponent; 1.0 = neutral
        0.18f.xxx,                             // current adaptive state / anchor-in
        0.18f.xxx,                             // desired background state / anchor-out
        RENODX_PSYCHOV22_GAMUT_COMPRESSION,
        GetPsychoV22GamutMode(),
        1.0f,                                  // adaptive_normalization, deprecated
        RENODX_PSYCHOV22_COMPRESSION           // 0.0 = auto, 4.0 is your bright manual default
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
    // RenoDRT:
    //   Decode final input -> original fGamma -> HDR boost
    //   -> RenoDX ToneMapPass -> RenderIntermediatePass.
    //
    // PsychoV22:
    //   Decode final input -> original fGamma -> HDR boost
    //   -> psychotm_test22 -> RenderIntermediatePass.
    // ------------------------------------------------------------

    float3 hdr_color = DecodeFinalInputForHDR(color.rgb);

#if RENODX_FINAL_APPLY_GAME_GAMMA
    hdr_color = ApplyOriginalGameGamma(hdr_color);
#endif

    hdr_color = ApplyHDRBoost(hdr_color);

#if RENODX_USE_PSYCHOV22
    if (IsPsychoV22Mode())
    {
        hdr_color = ApplyPsychoV22HDRTonemap(hdr_color);
    }
    else
    {
        hdr_color = ApplyRenoDXHDRTonemap(hdr_color);
    }
#else
    // If PsychoV22 was not compiled in, never leave the HDR path untonemapped.
    hdr_color = ApplyRenoDXHDRTonemap(hdr_color);
#endif

    color.rgb = renodx::draw::RenderIntermediatePass(SafePositive(hdr_color));
    color.a = saturate(color.a);
    return color;
}
