#include "./shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
    float4 cb2[10];
};

float4 main(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 negative0 = uv.xyxy - cb2[0].zwxy;
    float4 negative0a = t0.Sample(s0_s, negative0.xy);
    float4 negative0b = t0.Sample(s0_s, negative0.zw);
    float4 positive0 = uv.xyxy + cb2[0].xyzw;
    float4 positive0a = t0.Sample(s0_s, positive0.zw);
    float4 positive0b = t0.Sample(s0_s, positive0.xy);

    float4 blurred =
        cb2[8].x * (negative0b + positive0b)
        + cb2[8].y * (negative0a + positive0a);

    float4 negative1 = uv.xyxy - cb2[1].zwxy;
    float4 negative1a = t0.Sample(s0_s, negative1.zw);
    float4 negative1b = t0.Sample(s0_s, negative1.xy);
    float4 positive1 = uv.xyxy + cb2[1].xyzw;
    float4 positive1a = t0.Sample(s0_s, positive1.xy);
    float4 positive1b = t0.Sample(s0_s, positive1.zw);

    blurred +=
        cb2[8].z * (negative1a + positive1a)
        + cb2[8].w * (negative1b + positive1b);

    float4 negative2 = uv.xyxy - cb2[2].zwxy;
    float4 negative2a = t0.Sample(s0_s, negative2.zw);
    float4 negative2b = t0.Sample(s0_s, negative2.xy);
    float4 positive2 = uv.xyxy + cb2[2].xyzw;
    float4 positive2a = t0.Sample(s0_s, positive2.xy);
    float4 positive2b = t0.Sample(s0_s, positive2.zw);

    blurred +=
        cb2[9].x * (negative2a + positive2a)
        + cb2[9].y * (negative2b + positive2b);

    float4 negative3 = t0.Sample(s0_s, uv - cb2[3].xy);
    float4 positive3 = t0.Sample(s0_s, uv + cb2[3].xy);
    blurred += cb2[9].z * (negative3 + positive3);

    if (RENODX_BLOOM_MODE >= 0.5f)
    {
        return blurred;
    }

    float4 inputColor = t0.Sample(s0_s, uv);
    return lerp(inputColor, blurred, saturate(RENODX_BLOOM_INTERNAL_BLEND));
}
