#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 07 21:38:55 2026
//
// RenoDX HDR FMV upgrade
//
// Original behavior preserved:
// - Samples the Bink/video texture.
// - Preserves the original BGR -> RGB channel swap.
// - Preserves g_BinkConsts.w alpha.
//
// HDR behavior:
// - Uses RenoDX's BT.2446A video inverse tonemapper.
// - SDR video white is expanded into the configured HDR range.
// - Peak brightness follows RENODX_PEAK_WHITE_NITS.
// - Reference/diffuse brightness follows RENODX_DIFFUSE_WHITE_NITS.
// - Converts the RenoDX video pass's gamma-2.4 output back to the
//   game's configured gamma-2.2 intermediate representation.
//
// This does NOT run PsychoV24/RenoDRT over the FMV.
// FMVs are already display-referred SDR, so they need inverse
// tonemapping rather than normal scene-referred HDR tonemapping.


cbuffer _Globals : register(b0)
{
    float g_PaperWhite : packoffset(c129);
    float g_MaxNitsHDRTV : packoffset(c130);

    float4x4 g_WorldViewProj : packoffset(c0);

    float4 tor : packoffset(c4);
    float4 tog : packoffset(c5);
    float4 tob : packoffset(c6);

    float4 g_BinkConsts : packoffset(c7);
}


SamplerState _sampler_tex0_s : register(s0);
Texture2D<float4> _texture_tex0 : register(t0);


// 3Dmigoto declarations
#define cmp -


// -----------------------------------------------------------------------------
// RenoDX FMV inverse tonemapping
// -----------------------------------------------------------------------------
float3 ApplyFMVInverseTonemap(float3 color)
{
    // Bink/video is SDR display-referred data.
    // Remove invalid negative values without clipping HDR values.
    color = max(color, 0.0f);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();

    // RenoDX's dedicated video ITM:
    //
    // 1. Decodes the SDR video as gamma 2.4.
    // 2. Applies BT.2446A inverse tonemapping.
    // 3. Expands SDR video into:
    //
    //      diffuse white -> RENODX_DIFFUSE_WHITE_NITS
    //      HDR highlights -> RENODX_PEAK_WHITE_NITS
    //
    // 4. Returns gamma-2.4 encoded HDR values.
    color = renodx::draw::UpscaleVideoPass(
        color,
        draw_config
    );

    // UpscaleVideoPass returns gamma-2.4 encoded values.
    //
    // This Assassin's Creed Liberation shared.h uses:
    //
    //   RENODX_INTERMEDIATE_ENCODING = 2
    //   RENODX_SWAP_CHAIN_DECODING   = 2
    //
    // which means gamma 2.2.
    //
    // Convert 2.4 -> linear -> 2.2 so the later RenoDX swapchain
    // pass decodes this FMV exactly like the rest of the game's
    // intermediate image.
    color = renodx::color::gamma::DecodeSafe(
        color,
        2.4f
    );

    color = renodx::color::gamma::EncodeSafe(
        color,
        2.2f
    );

    return color;
}


void main(
    float4 v0 : SV_Position0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0)
{
    float4 r0;
    uint4 bitmask, uiDest;
    float4 fDest;


    // Original Bink texture sample.
    r0.xyz = _texture_tex0.Sample(
        _sampler_tex0_s,
        v1.xy
    ).xyz;


    // Original shader performs BGR -> RGB.
    float3 color = r0.zyx;


    // Only inverse-tonemap when the RenoDX output is HDR/PQ.
    //
    // This allows the shader to retain the original SDR FMV
    // behavior if the addon is switched back to an SDR output.
    [branch]
    if (RENODX_SWAP_CHAIN_ENCODING == renodx::draw::ENCODING_PQ)
    {
        color = ApplyFMVInverseTonemap(color);
    }


    o0.xyz = color;

    // Preserve original alpha behavior.
    o0.w = g_BinkConsts.w;

    return;
}