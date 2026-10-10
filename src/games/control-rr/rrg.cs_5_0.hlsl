/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 */

// control-rr: Control G-buffer -> DLSS-RR guide buffers.
//
// GBuffer1 (RGBA8): stereographic normal in x/y/w bits, z = gloss.
// GBuffer2 (RGBA8): y = tint factor, z/w = 16-bit material index.
// MaterialData (uint2 table): .x packs [R][G][B][brdf] bytes.
// EnvBRDF (LUT): indexed by (N.V, gloss), returns scale/bias for specular.
// Decodes match the game's own
// (dlf_spatial_spec.hlsli DecodeNormal; the LSAO resolve shader 0x3233A377).
//
// Outputs (all RGBA16F):
//   GuideNR      xyz = view-space normal, w = roughness (packed mode)
//   GuideDiffuse rgb = diffuse albedo
//   GuideSpec    rgb = specular albedo (EnvBRDF approx, N.V ~ |n.z|)

cbuffer Params : register(b0)
{
    uint InvertRoughness; // 1 = roughness = 1 - gloss
    uint Flags;           // bit0 = material+gbuffer2 valid, bit1 = envbrdf valid
    uint Width;
    uint Height;
};

Texture2D<float4> GBuffer1 : register(t0);
Texture2D<float4> GBuffer2 : register(t1);
StructuredBuffer<uint2> MaterialData : register(t2);
Texture2D<float4> EnvBRDF : register(t3);

SamplerState LinearClamp : register(s0);

RWTexture2D<float4> GuideNR : register(u0);
RWTexture2D<float4> GuideDiffuse : register(u1);
RWTexture2D<float4> GuideSpec : register(u2);

float3 DecodeNormal(float4 g)
{
    uint pw = (uint) (g.w * 255.0 + 0.5) & 254u;
    int3 v = (int3) floor(float3(g.x * 255.0 + 0.5, g.y * 255.0 + 0.5, (float) pw + 0.5));
    int e1 = (v.z >> 1) & 0x7;
    int e2 = (v.z >> 4) & 0xF;
    float fx = (float) ((v.x << 3) | e1) * 0.000977 - 1.0;
    float fy = (float) ((v.y << 4) | e2) * 0.000488 - 1.0;
    float2 p13 = float2(fx, fy) * 1.3;
    float d = dot(p13, p13);
    return float3(fx * 2.6, fy * 2.6, d - 1.0) / (d + 1.0);
}

[numthreads(16, 16, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x >= Width || tid.y >= Height)
        return;

    float4 g1 = GBuffer1.Load(int3(tid.xy, 0));
    float3 n = DecodeNormal(g1);
    float gloss = g1.z;
    float roughness = (InvertRoughness != 0u) ? (1.0 - gloss) : gloss;
    GuideNR[tid.xy] = float4(n, roughness);

    float3 diffuse = float3(0, 0, 0);
    float3 spec = float3(0, 0, 0);

    if ((Flags & 1u) != 0u)
    {
        // material albedo unpack, ported from the LSAO resolve shader
        float4 g2 = GBuffer2.Load(int3(tid.xy, 0));
        uint2 mat_zw = (uint2) (float2(g2.z, g2.w) * 255.0);
        uint mat_idx = (mat_zw.x << 8) | mat_zw.y;
        uint mat = MaterialData[mat_idx].x;
        float3 base = float3((float) (mat >> 24), (float) ((mat >> 16) & 0xFFu),
                             (float) ((mat >> 8) & 0xFFu)) * 0.003922;
        uint brdf = mat & 0xFFu;

        float lum = dot(base, float3(0.2126, 0.7152, 0.0722));
        float inv_lum = rcp(lum + 0.000001);
        float lum_gate = min(lum * 10000.0, 1.0);
        float3 tinted = g2.y * (lum_gate * (base * inv_lum - 1.0) + 1.0);
        diffuse = (brdf != 0u) ? base : tinted;

        if ((Flags & 2u) != 0u)
        {
            // spec albedo = albedo * EnvBRDF.x + EnvBRDF.y (LSAO resolve);
            // N.V approximated by |n.z| (view-space normals, forward ~ z)
            float ndv = saturate(abs(n.z));
            float2 env = EnvBRDF.SampleLevel(LinearClamp, float2(ndv, gloss), 0.0).xy;
            spec = diffuse * env.x + env.y;
            spec = (brdf == 3u) ? float3(0, 0, 0) : spec;
        }
    }

    GuideDiffuse[tid.xy] = float4(diffuse, 1.0);
    GuideSpec[tid.xy] = float4(spec, 1.0);
}
