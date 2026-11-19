#include "./shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
    float4 cb2[1];
};

float4 main(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 blurredScene = t0.Sample(s0_s, uv);

    if (RENODX_BLOOM_MODE >= 0.5f)
    {
        // Original game RGB scale/offset and composite alpha.
        return float4(blurredScene.rgb * cb2[0].w + cb2[0].x, cb2[0].y);
    }

    // The game's blend state is ONE / INV_SRC_ALPHA. Scaling RGB and alpha
    // together makes the result lerp(scene, blur, strength).
    float strength = saturate(RENODX_FX_BLOOM_STRENGTH);
    return float4(blurredScene.rgb * strength, strength);
}
