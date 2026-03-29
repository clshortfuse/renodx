#define USE_SETTINGS_PUSHCONSTANTS

#include "./shared.h"

[[vk::binding(0, 0)]]
Texture2D<float4> textureSrc;

[[vk::binding(1, 0)]]
SamplerState textureSrcSampler;


struct PsInput
{
    [[vk::location(0)]] float2 passUV : TEXCOORD0;
};

struct PsOutput
{
    [[vk::location(0)]] float4 colorOut0 : SV_Target0;
};

renodx::draw::Config GetSwapChainPassConfig()
{
    renodx::draw::Config config = renodx::draw::BuildConfig();


    //config.swap_chain_output_preset = 2;
    config.swap_chain_decoding = 0;
    config.swap_chain_gamma_correction = 1;
    config.swap_chain_scaling_nits = RENODX_GRAPHICS_WHITE_NITS;
    //config.swap_chain_clamp_nits = 1000.f;

    // config.swap_chain_output_preset = renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10;
    // config.swap_chain_output_preset = renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_NONE;
    // config.swap_chain_encoding = renodx::draw::ENCODING_SCRGB;
    // config.swap_chain_encoding_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
    // config.swap_chain_clamp_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
    // config.swap_chain_compress_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
    // config.swap_chain_scaling_nits = 1.f;
    // config.swap_chain_scaling_nits = RENODX_GRAPHICS_WHITE_NITS;
    // config.swap_chain_scaling_nits = RENODX_DIFFUSE_WHITE_NITS;
    // config.swap_chain_clamp_nits = RENODX_PEAK_WHITE_NITS;

    return config;
}

[shader("fragment")]
PsOutput main(PsInput IN)
{
    PsOutput OUT;
    float4 sampled = textureSrc.Sample(textureSrcSampler, IN.passUV);

    float3 color = sampled.rgb;
    renodx::draw::Config swapChainConfig = GetSwapChainPassConfig();

    // testing srgb decode
    
    //color = renodx::color::srgb::DecodeSafe(color);
    
    color = renodx::draw::SwapChainPass(color);
    OUT.colorOut0 = float4(color, sampled.w);
    return OUT;
}