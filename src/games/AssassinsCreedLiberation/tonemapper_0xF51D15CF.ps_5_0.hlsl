#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 20 21:15:57 2026
// Fixed RenoDX exposure pass - PsychoV24
//
// Fix:
//   This pass NO LONGER applies HDRDisplayMap / Psycho / PostTonemapSliders
//   in HDR modes.
//   It only applies exposure and forwards scene color to the later LUT/final
//   tonemap pass.
//
// PsychoV24 fix:
//   PsychoV24 uses tone-map type 24.
//   The old shader checked for PsychoV22/type 22, causing PsychoV24 to fall
//   through the vanilla SDR path.
//
// Result:
//   - Vanilla still uses the game's original ACES fitted SDR tonemap.
//   - RenoDRT forwards unclipped HDR scene values.
//   - PsychoV24 forwards unclipped HDR scene values.
//   - The later LUT/final shader remains the ONLY HDR tonemapper.
//   - Prevents double tonemapping.
//   - Prevents PsychoV24 input from being clipped to SDR first.

SamplerState _sampler_Scene_s : register(s0);
SamplerState _sampler_Exposure_s : register(s1);

Texture2D _texture_Scene : register(t0);
Texture2D _texture_Exposure : register(t1);


// ============================================================================
// PsychoV24
// ============================================================================

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV24
#define RENODX_TONE_MAP_TYPE_PSYCHOV24 24.0f
#endif


// ============================================================================
// Safe helpers
// ============================================================================

float3 EncodeSRGBSafeLocal(float3 color)
{
    color = max(color, 0.0f);

    float3 low = color * 12.92f;
    float3 high = pow(color, 1.0f / 2.4f) * 1.055f - 0.055f;

    float3 useHigh = step(
        float3(0.0031308f, 0.0031308f, 0.0031308f),
        color
    );

    return lerp(low, high, useHigh);
}


float3 SafeFinite3(float3 color)
{
    // Remove NaN without clipping HDR values above 1.0.
    color = (color == color) ? color : 0.0f.xxx;

    // R16G16B16A16_FLOAT positive representable range.
    return clamp(color, 0.0f.xxx, 65504.0f.xxx);
}


// ============================================================================
// Original game SDR tonemapper
// ============================================================================

float3 GameACESFittedTonemap(float3 color)
{
    float3 aces;

    aces.x = dot(
        float3(
            0.597190022f,
            0.354579985f,
            0.0482299998f
        ),
        color
    );

    aces.y = dot(
        float3(
            0.0759999976f,
            0.908339977f,
            0.0156599991f
        ),
        color
    );

    aces.z = dot(
        float3(
            0.0284000002f,
            0.133829996f,
            0.837769985f
        ),
        color
    );


    float3 numerator =
        aces * (aces + 0.0245785993f)
        - 0.0000905370034f;

    float3 denominator =
        aces * (aces * 0.983729005f + 0.432951003f)
        + 0.238080993f;

    float3 mapped =
        numerator / max(denominator, 0.000001f);


    float3 output;

    output.x = dot(
        float3(
            1.60475004f,
            -0.531080008f,
            -0.0736699998f
        ),
        mapped
    );

    output.y = dot(
        float3(
            -0.102080002f,
            1.10812998f,
            -0.00604999997f
        ),
        mapped
    );

    output.z = dot(
        float3(
            -0.00326999999f,
            -0.0727600008f,
            1.07602f
        ),
        mapped
    );


    // Vanilla SDR path intentionally remains clamped.
    return saturate(output);
}


// ============================================================================
// Tone-map mode detection
// ============================================================================

bool IsRenoDRTMode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - renodx::draw::TONE_MAP_TYPE_RENO_DRT
    ) < 0.5f;
}


bool IsPsychoV24Mode()
{
    return abs(
        RENODX_TONE_MAP_TYPE
        - RENODX_TONE_MAP_TYPE_PSYCHOV24
    ) < 0.5f;
}


bool IsCustomHDRMode()
{
    return IsRenoDRTMode()
        || IsPsychoV24Mode();
}


// ============================================================================
// Main
// ============================================================================

void main(
    float4 v0 : SV_Position0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0)
{
    // ------------------------------------------------------------------------
    // Sample original linear scene
    // ------------------------------------------------------------------------

    float3 sceneColor =
        _texture_Scene.Sample(
            _sampler_Scene_s,
            v1.xy
        ).xyz;

    float exposure =
        _texture_Exposure.Sample(
            _sampler_Exposure_s,
            float2(0.0f, 0.0f)
        ).x;


    // ------------------------------------------------------------------------
    // Sanitize input
    // ------------------------------------------------------------------------

    sceneColor = SafeFinite3(sceneColor);

    exposure =
        (exposure == exposure)
        ? exposure
        : 1.0f;

    exposure = clamp(
        exposure,
        0.0f,
        65504.0f
    );


    // ------------------------------------------------------------------------
    // Apply game's exposure
    // ------------------------------------------------------------------------

    sceneColor *= exposure;

    sceneColor = SafeFinite3(sceneColor);


    // ========================================================================
    // VANILLA / SDR
    // ========================================================================
    //
    // Keep the game's ACES fitted tonemap here.
    //
    // The following LUT/final pass expects SDR gamma input when RenoDX HDR
    // tonemapping is disabled.
    //
    // ========================================================================

    if (!IsCustomHDRMode())
    {
        float3 sdrColor =
            GameACESFittedTonemap(sceneColor);

        o0.rgb =
            EncodeSRGBSafeLocal(sdrColor);

        o0.a = 1.0f;

        return;
    }


    // ========================================================================
    // RENO DRT / PSYCHOV24 HDR
    // ========================================================================
    //
    // DO NOT:
    //
    //   - run GameACESFittedTonemap
    //   - saturate sceneColor
    //   - call PreTonemapSliders
    //   - call HDRDisplayMap
    //   - call psychotm_test24
    //   - call PostTonemapSliders
    //
    // here.
    //
    // This pass exists only to apply the game's exposure and forward the
    // unclipped scene into the later LUT/final shader.
    //
    // EncodeSafe is only the intermediate gamma representation. It does NOT
    // intentionally clamp HDR scene values to 1.0.
    //
    // The later shader DecodeSafe() restores this to linear before applying:
    //
    //      LUT reconstruction
    //          ->
    //      RenoDRT / PsychoV24
    //          ->
    //      HDR intermediate output
    //
    // ========================================================================

    o0.rgb =
        renodx::color::gamma::EncodeSafe(
            sceneColor
        );

    o0.a = 1.0f;

    return;
}