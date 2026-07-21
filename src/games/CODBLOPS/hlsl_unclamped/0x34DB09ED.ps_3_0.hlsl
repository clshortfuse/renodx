// Mechanically reconstructed from 0x34DB09ED.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
samplerCUBE s0 : register(s0);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    const float4 c0 = float4(-9.99999975e-05f, 1.0f, 64.0f, 1.44269502f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 oC0 = 0.0f;

    r0.z = (c[5].w) * (v1.z) + (c[5].x);
    r1.w = min(r0.z, c0.z);
    r0.w = (r1.w) * (c0.w);
    r1.w = exp2(r0.w);
    r0.y = (v1.z) * (c[5].w);
    r0.x = (r0.z) + (c0.y);
    r0.w = (abs(r0.y)) + (c0.x);
    r0.z = ((r0.z) >= 0.0f ? (r0.x) : (r1.w));
    r0.y = ((r0.w) >= 0.0f ? (r0.y) : (c0.y));
    r0.z = (r0.z) + (-(c[6].x));
    r0.y = 1.0f / (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = saturate(c[6].x);
    r0.w = ((r0.w) >= 0.0f ? (r0.z) : (r0.y));
    r3.w = (r0.w) * (c[5].y);
    r3.z = dot(v1.xyz, v1.xyz);
    r2 = texCUBE(s0, v0.xyz);
    r1 = texCUBE(s0, v0.xyw);
    r0 = lerp(r2, r1, v1.wwww);
    r1.w = rsqrt(r3.z);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r1.w = 1.0f / (r1.w);
    r0.x = dot(r1.xyz, c[7].xyz);
    r0.y = dot(r1.xyz, c[8].xyz);
    r0.z = dot(r1.xyz, c[9].xyz);
    r1.w = (r3.w) * (r1.w) + (c[5].z);
    r0.xyz = (r0.xyz) * (c[20].zzz);
    r1.w = saturate(exp2(r1.w));
    r0.xyz = (r0.xyz) * (c[11].xxx) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
